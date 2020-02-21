/* code/sql/HW_EBOOKSHOP.sql */

DROP SCHEMA IF EXISTS HW_EBOOKSHOP;
CREATE DATABASE HW_EBOOKSHOP;
USE HW_EBOOKSHOP;

CREATE TABLE BOOKS (
    ID INT PRIMARY KEY,
    title VARCHAR(50),
    author VARCHAR(50),
    price DECIMAL(10, 2),
    qty INT
);

/* Cf. https://en.wikipedia.org/wiki/List_of_best-selling_books */

INSERT INTO BOOKS VALUES (1, 'The Communist Manifesto', 'Karl Marx and Friedrich Engels', 11.11, 11);
INSERT INTO BOOKS VALUES (2, 'Don Quixote', 'Miguel de Cervantes', 22.22, 22);
INSERT INTO BOOKS VALUES (3, 'A Tale of Two Cities', 'Charles Dickens', 33.33, 33);
INSERT INTO BOOKS VALUES (4, 'The Lord of the Rings', 'J. R. R. Tolkien', 44.44, 44);
INSERT INTO BOOKS VALUES (5, 'Le Petit Prince', 'Antoine de Saint-Exupéry', 55.55, 55);

SELECT * FROM BOOKS;
