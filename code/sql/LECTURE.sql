/* code/sql/LECTURE.sql */

-- Question 2
CREATE TABLE LECTURE(
    Name VARCHAR(25),
    Instructor VARCHAR(25),
    Year YEAR(4),
    Code CHAR(5),
    PRIMARY KEY(Year, Code),
    FOREIGN KEY (Instructor) REFERENCES PROF(Login)
);

INSERT INTO LECTURE VALUES
    ('Intro to CS', 'caubert', 2017, '1304'),
    ('Intro to Algebra', 'perdos', 2017, '1405'),
    ('Intro to Cyber', 'aturing', 2017, '1234');

-- This representation can not handle the following situations:
-- - If multiple instructors teach the same class,
-- - If the lecture is taught more than once a year (either because it is taught in the Fall, Spring and Summer, or if multiple sections are offered at the same time),
-- - If a lecture is cross-listed, then some duplication of information will be needed.


-- Question 3
ALTER TABLE GRADE
    ADD COLUMN LectureCode CHAR(5),
    ADD COLUMN LectureYear YEAR(4);

DESCRIBE GRADE;

SELECT * FROM GRADE;

ALTER TABLE GRADE
    ADD FOREIGN KEY (LectureYear, LectureCode)
    REFERENCES LECTURE(Year, Code);

-- The values for LectureCode and LectureYear are set to NULL in all the tuples.

-- Question 4
UPDATE GRADE SET LectureCode = '1304', LectureYear = 2017
    WHERE Login = 'jrakesh'
    AND Grade = '2.85';

UPDATE GRADE SET LectureCode = '1405', LectureYear = 2017
    WHERE Login = 'svlatka'
    OR (Login = 'jrakesh' AND Grade = '3.85');

UPDATE GRADE SET LectureCode = '1234', LectureYear = 2017
    WHERE Login = 'aalyx'
    OR Login = 'cjoella';

-- Question 6
SELECT Login, Grade 
    FROM GRADE
    WHERE Lecturecode='1304' 
    AND LectureYear = '2017';

SELECT DISTINCT Instructor 
    FROM LECTURE
    WHERE Year = 2017;

SELECT Name, Grade 
    FROM STUDENT, GRADE
    WHERE GRADE.LectureCode = 1405
    AND STUDENT.Login = GRADE.Login;

SELECT Year
    FROM LECTURE
    WHERE Code = '1234';

SELECT Name
    FROM LECTURE
    WHERE Year IN
        (SELECT Year
        FROM LECTURE
        WHERE CODE = '1234');

SELECT B.name
    FROM STUDENT AS A, STUDENT AS B
    WHERE A.Name = 'Ava Alyx'
    AND A.Registered > B.Registered;

SELECT COUNT(DISTINCT PROF.Name) AS 'Head Teaching This Year'
    FROM LECTURE, DEPARTMENT, PROF
    WHERE Year = 2017
    AND Instructor = Head
    AND Head = PROF.Login; 
