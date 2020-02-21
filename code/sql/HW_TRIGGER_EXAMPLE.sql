/* code/sql/HW_TRIGGER_EXAMPLE.sql */

DROP SCHEMA IF EXISTS HW_TRIGGER_EXAMPLE;
CREATE SCHEMA HW_TRIGGER_EXAMPLE;
USE HW_TRIGGER_EXAMPLE;

CREATE TABLE STUDENT(
    Login VARCHAR(30) PRIMARY KEY,
    Average Float
    );

    
SET @number_of_student = 0;

/*
 SQL supports some primitive form of variables.
 cf.
 https://dev.mysql.com/doc/refman/8.0/en/user-variables.html
 https://mariadb.com/kb/en/library/user-defined-variables/
 There is no "clear" form of type
 https://dev.mysql.com/doc/refman/8.0/en/user-variables.html
 reads: 
 " In addition, the default result type of a variable is based on
 " its type at the beginning of the statement. This may have unintended
 " effects if a variable holds a value of one type at the beginning of a
 " statement in which it is also assigned a new value of a different type.

 " To avoid problems with this behavior, either do not assign a value to
 " and read the value of the same variable within a single statement, or else
  " set the variable to 0, 0.0, or '' to define its type before you use it. 
  
  In other words, mysql just "guess" the type of your value and go with it.
*/

/* 
 We can create a trigger to count the number 
 of times something was inserted in our STUDENT
 table.
*/

CREATE TRIGGER NUMBER_OF_STUDENT
AFTER INSERT ON STUDENT
FOR EACH ROW SET @number_of_student = @number_of_student + 1;
-- As far as I know, this is the only way to increment a variable.

INSERT INTO STUDENT(Login) VALUES ("A"), ("B"), ("C"), ("D");

SELECT COUNT(*) FROM STUDENT; -- We now have four value inserted in the table.
SELECT @number_of_student AS 'Total number of student'; -- And the counter knows it.

/*
 We should not forget to update our counter 
 when a student is removed from our table!
 */

CREATE TRIGGER NUMBER_OF_STUDENT
AFTER DELETE ON STUDENT
FOR EACH ROW SET @number_of_student = @number_of_student - 1;

DELETE FROM STUDENT WHERE Login = "D" || Login = "E";

SELECT COUNT(*) FROM STUDENT; -- Note that our previous query deleted only one student.
SELECT @number_of_student AS 'Total number of student'; -- And the counter knows it.

/*
 Let us now create a table for each individal grade,
 and a trigger to calculate the average for us.
 Note that the trigger will need to manipulate two tables
 at the same time.
 */

CREATE TABLE GRADE(
    Student VARCHAR(30),
    Exam VARCHAR(30),
    Grade INT,
    PRIMARY KEY(Student, Exam),
    FOREIGN KEY (Student) REFERENCES STUDENT(Login)
);

CREATE TRIGGER STUDENT_AVERAGE
AFTER INSERT ON GRADE
FOR EACH ROW -- Woh, a whole query inside our trigger!
    UPDATE STUDENT
    SET STUDENT.Average = 
        (SELECT AVG(Grade) FROM GRADE WHERE GRADE.Student = STUDENT.Login)
    WHERE STUDENT.Login = NEW.Student; -- The "NEW" keyword here refers to the "new" entry
    -- that is being inserted by the INSERT statement triggering the trigger.

INSERT INTO GRADE VALUES
    ("A", "Exam 1", 50),
    ("A", "Exam 2", 40),
    ("B", "Exam 1", 80),
    ("B", "Exam 2", 100);

SELECT * FROM GRADE;
SELECT * FROM STUDENT; -- Tada, all the averages have been computed!
-- Note also that the student "C" does not have an average!
