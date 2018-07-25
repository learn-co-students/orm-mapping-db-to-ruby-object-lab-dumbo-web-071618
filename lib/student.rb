class Student
  attr_accessor :id, :name, :grade

  # def initialize attributes
  #   attributes.each {|key,value| self.send "#{key}=",value}
  # end

  # def initialize id,name,grade
  #   @id = id
  #   @name = name
  #   @grade = grade
  # end

  def self.new_from_db(row)
    student = Student.new
    # binding.pry
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    students_array = DB[:conn].execute "SELECT * FROM students"
    # remember each row should be a new instance of the Student class
    students_array.map { |student_row| Student.new_from_db student_row }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    Student.new_from_db(DB[:conn].execute(sql,name)[0])
    # return a new instance of the Student class
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map {|student| Student.new_from_db student}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map {|student| Student.new_from_db student}
  end

  def self.first_X_students_in_grade_10 num
    sql = <<-SQL
      SELECT * FROM students where grade = 10 LIMIT ?
    SQL

    DB[:conn].execute(sql,num).map {|student| Student.new_from_db student}
  end

  def self.first_student_in_grade_10
    Student.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X g
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql,g).map {|student| Student.new_from_db student}
  end
end
