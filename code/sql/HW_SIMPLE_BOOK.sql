/* code/sql/HW_SIMPLE_BOOK.sql */

DROP SCHEMA IF EXISTS HW_SIMPLE_BOOK;
CREATE SCHEMA HW_SIMPLE_BOOK;
USE HW_SIMPLE_BOOK;

CREATE TABLE AUTHOR(
    FName VARCHAR(30),
    LName VARCHAR(30),
    Id INT PRIMARY KEY
);

CREATE TABLE PUBLISHER(
    Name VARCHAR(30),
    City VARCHAR(30),
    PRIMARY KEY (Name, City)
    );


CREATE TABLE BOOK(
    Title VARCHAR(30),
    Pages INT,
    Published DATE,
    PublisherName VARCHAR(30),
    PublisherCity VARCHAR(30),
    FOREIGN KEY (PublisherName, PublisherCity)
        REFERENCES PUBLISHER(Name, City),
    Author INT,
    FOREIGN KEY (Author)
        REFERENCES AUTHOR(Id),
    PRIMARY KEY (Title, Published)
);

INSERT INTO AUTHOR VALUES
    ("Virginia", "Wolve", 01),
    ("Paul", "Bryant", 02),
    ("Samantha", "Carey", 03);

INSERT INTO PUBLISHER VALUES
    ("Gallimard", "Paris"),
    ("Gallimard", "New-York"),
    ("Jobs Pub.", "New-York");

INSERT INTO BOOK VALUES
    ("What to eat", 213, DATE'20170219', "Gallimard", "Paris", 01),
    ("Where to live", 120, DATE'20130212', "Gallimard", "New-York", 02),
    ("My Life, I", 100, DATE'18790220', "Gallimard", "Paris", 03),
    ("My Life, II", 100, DATE'18790219', "Jobs Pub.", "New-York", 03);
