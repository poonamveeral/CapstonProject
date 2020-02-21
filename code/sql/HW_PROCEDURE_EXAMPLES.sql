/* code/sql/HW_PROCEDURE_EXAMPLES.sql */

DROP SCHEMA IF EXISTS HW_PROCEDURE_EXAMPLES;
CREATE SCHEMA HW_PROCEDURE_EXAMPLES;
USE HW_PROCEDURE_EXAMPLES;

/*
 A "procedure" is a serie of statements stored in a schema,
 that can easily be executed repeatedly.
 https://dev.mysql.com/doc/refman/8.0/en/create-procedure.html
 https://mariadb.com/kb/en/library/create-procedure/
 */
 

CREATE TABLE STUDENT(
    Login INT PRIMARY KEY,
    Name VARCHAR(30),
    Major VARCHAR(30),
    Email VARCHAR(30)
    );

INSERT INTO STUDENT VALUES (123, "Test A", "CS", "a@a.edu"),
                           (124, "Test B", "IT", "b@a.edu"),
                           (125, "Test C", "CYBR", "c@a.edu");

DELIMITER // -- This tells mysql not to mistake the ; below for the end of the procedure definition.
-- We temporarily alter the language, and make the delimiter being //.
-- $$ is often used too, and the documentation, at https://dev.mysql.com/doc/refman/8.0/en/stored-programs-defining.html, reads:
--  " You can redefine the delimiter to a string other than //,
--  " and the delimiter can consist of a single character or multiple characters.
--  " You should avoid the use of the backslash (\) character because that is the escape character for MySQL. 
-- I am assuming that using the minus sign twice is also a poor choice.
CREATE PROCEDURE STUDENTLIST()
BEGIN
    SELECT * FROM STUDENT; -- This ";" is not the end of the procedure definition!
END;
// -- This is the delimiter that marks the end of the procedure definition.
DELIMITER ; -- Now, we want ";" to be the "natural" delimiter again.

CALL STUDENTLIST();

/* 
 As the "()" suggests, a procedure can take
 argument(s).
*/


DELIMITER //
CREATE PROCEDURE STUDENTLOGIN(NameP VARCHAR(30))
BEGIN
    SELECT Login 
    FROM STUDENT WHERE NameP = Name;
END;
//
DELIMITER ;

SHOW CREATE PROCEDURE STUDENTLOGIN; -- You can ask the system to give you information
-- About the procedure you just created.

CALL STUDENTLOGIN("Test A"); -- We can pass quite naturally an argument to our procedure.
