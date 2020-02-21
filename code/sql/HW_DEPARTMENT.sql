/* code/sql/HW_DEPARTMENT.sql */

/*
 Preamble:
    The following is in case you want to run your program on your installation:
*/

DROP SCHEMA IF EXISTS HW_DEPARTMENT;
 -- Carefull, we are dropping the schema HW_DEPARTMENT if it exists already, and all the data in it.
CREATE SCHEMA HW_DEPARTMENT;
-- And then re-creating it.
USE HW_DEPARTMENT;

/*
 End of the preamble.
*/


CREATE TABLE DEPARTMENT(
  ID INT PRIMARY KEY,
  Name VARCHAR(30)
  );

CREATE TABLE EMPLOYEE(
  ID INT PRIMARY KEY,
  Name VARCHAR(30),
  Hired DATE,
  Department INT,
  FOREIGN KEY (Department)
    REFERENCES DEPARTMENT(ID)
  );
  
INSERT INTO DEPARTMENT VALUES
  (1, "Storage"),
  (2, "Hardware");
  
INSERT INTO EMPLOYEE VALUES
   (1, "Bob", 20100101, 1),
   (2, "Samantha", 20150101, 1),
   (3, "Mark", 20050101, 2),
   (4, "Karen", NULL, 1),
   (5, "Jocelyn", 20100101, 1);

SELECT EMPLOYEE.Name
FROM EMPLOYEE, DEPARTMENT
WHERE DEPARTMENT.Name = "Storage"
  AND EMPLOYEE.Department = DEPARTMENT.ID;
  
/* 
Will return:
Bob
Samantha
Karen
Jocelyn
and not Mark, since that employee works in a differente department.
*/

SELECT Name
FROM EMPLOYEE
WHERE Hired <= ALL (
    SELECT Hired
    FROM EMPLOYEE
    WHERE Hired IS NOT NULL
);
  
/* 
Will return
Mark
since he has the smallest hiring date,
excluding Karen (whose hiring date is
unknown).
*/

SELECT EMPLOYEE.Name
FROM EMPLOYEE, DEPARTMENT
WHERE Hired <= ALL (
    SELECT Hired
    FROM EMPLOYEE
    WHERE Hired IS NOT NULL
       AND DEPARTMENT.Name = "Storage"
       AND EMPLOYEE.Department = DEPARTMENT.ID
)
  AND DEPARTMENT.Name = "Storage"
  AND EMPLOYEE.Department = DEPARTMENT.ID;
  
/*
Will return
Bob
Jocelyn
since those are the two employees of the 
department whose name is Storage that have
the smallest hiring date among the 
employee of the department whose name is storage.
*/
