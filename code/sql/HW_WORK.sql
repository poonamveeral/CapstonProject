/* code/sql/HW_WORK.sql */

DROP SCHEMA IF EXISTS HW_WORK;
CREATE SCHEMA HW_WORK;
USE HW_WORK;

CREATE TABLE AUTHOR(
    Name VARCHAR(30) PRIMARY KEY,
    Email VARCHAR(30)
);

CREATE TABLE WORK(
    Title VARCHAR(30) PRIMARY KEY,
    Author VARCHAR(30),
    FOREIGN KEY (Author)
    REFERENCES AUTHOR(Name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE BOOK(
    ISBN INT PRIMARY KEY,
    Work VARCHAR(30),
    Published DATE,
    Price DECIMAL(10, 2),
    FOREIGN KEY (Work)
        REFERENCES WORK(Title)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE EBOOK(
    ISBN INT PRIMARY KEY,
    Work VARCHAR(30),
    Published DATE,
    Price DECIMAL(10, 2),
    FOREIGN KEY (Work)
        REFERENCES WORK(Title)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

INSERT INTO AUTHOR VALUES
    ("Virginia W.", "vw@isp.net"), -- A.1
    ("Paul B.", "pb@isp.net"),     -- A.2
    ("Samantha T.", "st@fai.fr")   -- A.3
;
INSERT INTO WORK VALUES
    ("What to eat", "Virginia W.") -- W.1
;
INSERT INTO BOOK VALUES
    (15155627, "What to eat", DATE'20170219', 12.89) -- B.1
;
INSERT INTO EBOOK VALUES
    (15155628, "What to eat", DATE'20170215', 9.89) -- E.1
;
