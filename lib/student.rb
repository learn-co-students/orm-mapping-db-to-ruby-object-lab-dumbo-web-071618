class Student
  attr_accessor :id, :name, :grade
  # This is a class method that accepts a row from the database as an argument.
  def self.new_from_db(row)
    # Create a new Student object given a row from the database
    new_student = self.new  # Self.new is the same as running Student.new
    # Remember, our database doesn't store Ruby objects, so we have to manually
    # convert it ourself.
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # Return the newly created instance
  end
  # This is a class method that accepts a name of a student.
  def self.find_by_name(name)
    # You will first run a SQL query to get the result from the database where
    # the student's name matches the name passed into the argument.
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    # Find the student in the database given a name
    DB[:conn].execute(sql, name).map do |row|
      # Return a new instance of the Student class
      self.new_from_db(row)
    end.first
  end
  # This is a class method that does not need an argument.
  def self.count_all_students_in_grade_9
    # http://www.sqlitetutorial.net/sqlite-count-function/
    sql = <<-SQL
      -- Should this count? Or list? :/
      SELECT *
      FROM students
      WHERE grade = 9
    SQL
    # This method should return an array of all the students in grade 9.
    DB[:conn].execute(sql)
  end
  # This is a class method that does not need an argument.
  def self.students_below_12th_grade
    sql = <<-SQL
      -- Should this count? Or list? :/
      SELECT *
      FROM students
      WHERE grade < 12
    SQL
    # This method should return an array of all the students below 12th grade.
    DB[:conn].execute(sql).map do |row|
      # Return a new instance of the Student class
      self.new_from_db(row)
    end
  end
  # This is a class method that is very similar to the .find_by_name method.
  def self.all # You will not need an argument since we are returning
  # everything in the database.
    sql = <<-SQL
      -- Retrieve all the rows from the "Students" database
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      # Remember each row should be a new instance of the Student class
      self.new_from_db(row)
    end
  end
  # This is a class method that takes in an argument of the number of students
  # from grade 10 to select.
  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
    # This method should return an array of exactly X number of students.
    DB[:conn].execute(sql, number).map do |row|
      # Remember each row should be a new instance of the Student class
      self.new_from_db(row)
    end
  end
  # This is a class method that does not need an argument.
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL
    # This should return the first student that is in grade 10.
    DB[:conn].execute(sql).map do |row|
      # Return a new instance of the Student class
      self.new_from_db(row)
    end.first
  end
  # This is a class method that takes in an argument of grade for which to
  # retrieve the roster.
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL
    # This method should return an array of all students for grade X.
    DB[:conn].execute(sql, grade).map do |row|
      # Return a new instance of the Student class
      self.new_from_db(row)
    end
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
end
