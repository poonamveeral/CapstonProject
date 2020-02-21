/* code/sql/WORK_SOL.sql */

/*
  For this code to work, you need to execute
  the code in
  code/sql/HW_WORK.sql
  first.
*/

/*
 *
 * Determine if the following insertion statements would violate the the Entity integrity constraint, the Referential integrity constraint, if there would be some Other kind of error, or if it would result in uccessful insertion.
 *
 */

START TRANSACTION; -- We don't want to perform the actual insertions.

INSERT INTO EBOOK VALUES(0, NULL, 20180101, 0);
-- Query OK, 1 row affected (0.003 sec)
-- So, "Successful insertion".

INSERT INTO AUTHOR VALUES("Mary B.", "mb@fai.fr", NULL);
-- ERROR 1136 (21S01): Column count doesn't match value count at row 1
-- So, "Other kind of error".

INSERT INTO WORK VALUES("My Life", "Claude A.");
-- ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`HW_EXAM_1`.`WORK`, CONSTRAINT `WORK_ibfk_1` FOREIGN KEY (`Author`) REFERENCES `AUTHOR` (`Name`) ON DELETE CASCADE ON UPDATE CASCADE)
-- So, "Referential integrity constraint"

INSERT INTO BOOK VALUES(00000000, NULL, DATE'20001225', 90.9);
-- Query OK, 1 row affected (0.000 sec)
-- So, "Successful insertion".

INSERT INTO AUTHOR VALUES("Virginia W.", "alt@isp.net");
-- ERROR 1062 (23000): Duplicate entry 'Virginia W.' for key 'PRIMARY'
-- So, "Entity integrity constraint".

ROLLBACK; -- We go back to the previous state.




/*
 * 
 * List the rows (i.e., A.2, W.1, etc.) modified by the following statements (be careful about the conditions on foreign keys!):
 *
 */
 

START TRANSACTION; -- We don't want to perform the following operations.

UPDATE AUTHOR SET Email = 'Deprecated' WHERE Email LIKE '%isp.net';
-- Query OK, 2 rows affected (0.010 sec)
-- Rows matched: 2  Changed: 2  Warnings: 0
-- This changed A.1 and A.2

UPDATE WORK SET Title = "How to eat" WHERE Title = "What to eat";
-- Rows matched: 1  Changed: 1  Warnings: 0
-- SQL returns only the number of row changed in the WORK table,
-- but other rows have been changed as well.
-- This changed W.1, B.1, E.1.

DELETE FROM WORK;
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`HW_EXAM_1`.`BOOK`, CONSTRAINT `BOOK_ibfk_1` FOREIGN KEY (`Work`) REFERENCES `WORK` (`Title`) ON UPDATE CASCADE)
-- Does not change any row.

DELETE FROM AUTHOR WHERE Name = "Virginia W.";
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`HW_EXAM_1`.`BOOK`, CONSTRAINT `BOOK_ibfk_1` FOREIGN KEY (`Work`) REFERENCES `WORK` (`Title`) ON UPDATE CASCADE)
-- Does not change any row.

ROLLBACK; -- We go back to the previous state.

/*
 *
 * You can now assume that there is more data than what we inserted, if that helps you. Write a command that selects …
 *
 */
 
-- We insert some dummy values for this next part.
INSERT INTO WORK VALUES("My Life", "Paul B."), ("What to eat, 2", "Virginia W.");
INSERT INTO BOOK VALUES(15355627, "My Life", DATE'20180219', 15.00), (12912912, "What to eat, 2", DATE'20200101', 13);
INSERT INTO EBOOK VALUES(15150628, "My Life", DATE'20190215', 10.89), (42912912, "What to eat, 2", DATE'20200115', 12);

-- … the price of all the ebooks.
SELECT Price FROM EBOOK;

-- … the (distinct) names of the authors who have authored a piece of work.
SELECT DISTINCT Author FROM WORK;

-- … the name of the authors using fai.fr for their email.
SELECT Name FROM AUTHOR WHERE Email LIKE '%fai.fr';

-- … the price of the ebooks published after 2018.
SELECT Price FROM BOOK WHERE Published >= 20180101;
-- Note that 
-- SELECT Price FROM BOOK WHERE Published > 2018;
-- would return all the prices, along with a warning:
-- Incorrect datetime value: '2018'

-- … the price of the most expensive book.
SELECT MAX(Price) FROM BOOK;

-- … the number of pieces of work written by the author whose name is “Virginia W.”.
SELECT COUNT(*) FROM WORK WHERE WORK.Author = "Virginia W.";

-- … the email of the author who wrote the piece of work called “My Life”.
SELECT Email FROM AUTHOR, WORK WHERE WORK.Title = "My Life" AND WORK.Author = AUTHOR.Name;

-- the isbn(s) of the book containing a work written by the author whose email is "vw@isp.net".
SELECT ISBN FROM BOOK, WORK, AUTHOR WHERE AUTHOR.Email = "vw@isp.net" AND WORK.Author = AUTHOR.Name AND BOOK.Work = WORK.Title;

/*
 * 
 * Write a command that updates the title of all the pieces of work written by the author whose name is “Virginia W. to”BANNED". Is there any reason for this command to be rejected by the system? If yes, explain which one.
 *
 */

UPDATE WORK SET Title = "BANNED" WHERE Author = "Virginia W.";
-- Does not give an error with the that we currently have.
-- However, since "Title" is the primary key in the WORK table, if Virginia W. had authored two pieces of work or more, then this command would give an error.

/*
 *
 * Write one or multiple commands that would delete the work whose title is “My Life”, as well as all of the books and ebooks versions of it.
 *
 */

DELETE FROM WORK WHERE Title = "My Life";
-- Fails
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`HW_EXAM_1`.`BOOK`, CONSTRAINT `BOOK_ibfk_1` FOREIGN KEY (`Work`) REFERENCES `WORK` (`Title`) ON UPDATE CASCADE)
-- We have to first delete the corresponding publications:

DELETE FROM BOOK WHERE Work = "My Life";
DELETE FROM EBOOK WHERE Work = "My Life";
-- And then we can delete the work:
DELETE FROM WORK WHERE Title = "My Life";
-- And, no, we cannot delete "simply" from multiple tables in one command.
-- Some workaround exists, cf. https://stackoverflow.com/q/1233451/ .
