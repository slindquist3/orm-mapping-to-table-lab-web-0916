class Student

  sql = SQLite3::Database.new('db/students.db')

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
   sql = <<-SQL
     INSERT INTO students (name, grade, id)
     VALUES (?, ?, ?)
   SQL

   DB[:conn].execute(sql, self.name, self.grade)
   @id = DB[:conn].execute("SELECT id FROM students WHERE id = (SELECT MAX(id) FROM students)").flatten!.join("").to_i

 end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        grade TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table

    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)

  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

end
