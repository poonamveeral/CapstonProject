/* code/sql/HW_FACULTY.sql */

-- We first drop the schema if it already exists:
DROP  SCHEMA IF EXISTS HW_FACULTY;

-- Then we create the schema:
CREATE SCHEMA HW_FACULTY;

/*
Or we could have use the syntax:

CREATE DATABASE HW_FACUTLY;

*/

-- Now, let us create a table in it:
CREATE TABLE HW_FACULTY.PROF(
  Fname VARCHAR(15), 
  -- No String!
  -- The value "15" vas picked randomly, any value below 255 would 
  -- more or less do the same. Note that declaring extremely large
  -- values without using them can impact the performance of 
  -- your database, cf. for instance https://dba.stackexchange.com/a/162117/
  Room INT, 
  -- shorthad for INTEGER, are also available: SMALLINT, FLOAT, REAL, DEC
  -- The "REAL" datatype is like the "DOUBLE" datatype of C# (they are actually synonyms in SQL):
  -- more precise than the "FLOAT" datatype, but not as exact as the "NUMERIC" datatype. 
  -- cf. https://dev.mysql.com/doc/refman/8.0/en/numeric-types.html
  Title CHAR(3), 
  -- fixed-length string, padded with blanks if needed
  Tenured BIT(1), 
  Nice BOOLEAN, 
  -- True / False (= 0) / Unknown
  Hiring DATE, 
  -- The DATE is always supposed to be entered in a YEAR/MONTH/DAY variation.
  -- To tune the way it will be displayed, you can use the "DATE_FORMAT" function
  -- (cf. https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format),
  -- but you can enter those values only using the "standard" literals
  -- (cf. https://dev.mysql.com/doc/refman/8.0/en/date-and-time-literals.html )
  Last_seen TIME, 
  FavoriteFruit ENUM('apple', 'orange', 'pear'), 
  PRIMARY KEY(Fname, Hiring)
);

/*
Or, instead of using the fully qualified name HW_FACULTY.PROF,
we could have done:

USE HW_FACULTY;
CREATE TABLE PROF(…)

*/

-- Let us use this schema, from now on.
USE HW_FACULTY;

-- Let us insert some "Dummy" value in our table:
INSERT INTO PROF VALUES 
  (
    "Clément", -- Or 'Clément'.
    290, 
    'PhD', 
    0, 
    NULL, 
    '19940101', -- Or '940101',  '1994-01-01',  '94/01/01'
    '090500', -- Or '09:05:00', '9:05:0',  '9:5:0',  '090500'
    -- Note also the existence of DATETIME, with 'YYYY-MM-DD HH:MM:SS'
    'Apple' -- This is not case-sensitive, oddly enough.
  );
