/* code/sql/HW_DB_COFEE.sql */

/*
 * Setting up the data
 */

DROP SCHEMA IF EXISTS HW_DB_COFFEE;
CREATE SCHEMA HW_DB_COFFEE;
USE HW_DB_COFFEE;

CREATE TABLE COFFEE(
    Ref VARCHAR(30) PRIMARY KEY,
    Origin VARCHAR(30),
    TypeOfRoast VARCHAR(30),
    PricePerPound DOUBLE
);
CREATE TABLE CUSTOMER(
    CardNo VARCHAR(30) PRIMARY KEY,
    Name VARCHAR(30),
    Email VARCHAR(30),
    FavCoffee VARCHAR(30),
    FOREIGN KEY (FavCoffee) REFERENCES COFFEE(Ref)  ON UPDATE CASCADE ON DELETE CASCADE
    );
CREATE TABLE PROVIDER(
    Name VARCHAR(30) PRIMARY KEY,
    Email VARCHAR(30)
);
CREATE TABLE SUPPLY(
    Provider VARCHAR(30),
    Coffee VARCHAR(30),
    PRIMARY KEY (Provider, Coffee),
    FOREIGN KEY (Provider) REFERENCES PROVIDER(Name) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Coffee) REFERENCES COFFEE(Ref)  ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO COFFEE VALUES
    (001, 'Brazil', 'Light', 8.9),
    (121, 'Bolivia', 'Dark', 7.5),
    (311, 'Brazil', 'Medium', 9.0),
    (221, 'Sumatra', 'Dark', 10.25);
INSERT INTO CUSTOMER VALUES
    (001, 'Bob Hill', 'b.hill@sip.net', 221),
    (002, 'Ana Swamp', 'swampa@nca.edu', 311),
    (003, 'Mary Sea', 'brig@gsu.gov', 121),
    (004, 'Pat Mount', 'pmount@fai.fr', 121);
INSERT INTO PROVIDER VALUES
    ('Coffee Unl.', 'bob@cofunl.com'),
    ('Coffee Exp.', 'pat@coffeex.dk'),
    ('Johns & Co.', NULL);
INSERT INTO SUPPLY VALUES
    ('Coffee Unl.', 001),
    ('Coffee Unl.', 121),
    ('Coffee Exp.', 311),
    ('Johns & Co.', 221);

-- Question 2:
START TRANSACTION;

INSERT INTO CUSTOMER VALUES(005, Bob Hill, NULL, 001);

INSERT INTO COFFEE VALUES(002, "Peru", "Decaf", 3.00);

INSERT INTO PROVIDER VALUES(NULL, "contact@localcof.com"); -- ERROR 1048 (23000): Column 'Name' cannot be null

INSERT INTO SUPPLY VALUES("Johns & Co.", 121);

INSERT INTO SUPPLY VALUES("Coffee Unl.", 311, 221); -- ERROR 1136 (21S01): Column count doesn't match value count at row 1

--COMMIT;
-- Rest the changes:
ROLLBACK;

-- Question 3:

START TRANSACTION;
UPDATE CUSTOMER SET FavCoffee = 001 WHERE CardNo = 001; -- Rows matched: 1  Changed: 1  Warnings: 0
SELECT * FROM CUSTOMER;
ROLLBACK;

START TRANSACTION;
UPDATE COFFEE SET TypeOfRoast = 'Decaf' WHERE Origin = 'Brazil'; -- Rows matched: 2  Changed: 2  Warnings: 0
SELECT * FROM COFFEE;
ROLLBACK;

START TRANSACTION;
UPDATE PROVIDER SET Name = 'Coffee Unlimited' WHERE Name = 'Coffee Unl.'; -- Rows matched: 1  Changed: 1  Warnings: 0
SELECT * FROM PROVIDER;
SELECT * FROM SUPPLY;
ROLLBACK;

START TRANSACTION;
UPDATE COFFEE SET PricePerPound = 10.00 WHERE PricePerPound > 10.00; -- Rows matched: 1  Changed: 1  Warnings: 0
SELECT * FROM COFFEE;
ROLLBACK;

-- Question 4:

START TRANSACTION;
DELETE FROM CUSTOMER WHERE Name LIKE '%S%'; -- Query OK, 2 rows affected (0.01 sec)
SELECT * FROM CUSTOMER;
ROLLBACK;

START TRANSACTION;
DELETE FROM COFFEE WHERE Ref = 001; -- Query OK, 1 row affected (0.00 sec)
SELECT * FROM COFFEE;
SELECT * FROM SUPPLY;
ROLLBACK;

START TRANSACTION;
DELETE FROM SUPPLY WHERE Provider = 'Coffee Unl.' AND Coffee = '001'; -- Query OK, 1 row affected (0.00 sec)
SELECT* FROM SUPPLY;
ROLLBACK;

START TRANSACTION;
DELETE FROM PROVIDER WHERE Name = 'Johns & Co.'; -- Query OK, 1 row affected (0.00 sec)
SELECT * FROM PROVIDER;
SELECT * FROM SUPPLY;
ROLLBACK;

-- Question 5:

-- 1.
SELECT Origin FROM COFFEE WHERE TypeOfRoast = 'Dark';

-- 2.
SELECT FavCoffee FROM CUSTOMER WHERE Name LIKE 'Bob%';

-- 3.
SELECT Name FROM PROVIDER WHERE Email IS NULL;

-- 4.
SELECT COUNT(*) FROM SUPPLY WHERE Provider = 'Johns & Co.';

-- 5.
SELECT Provider FROM COFFEE, SUPPLY WHERE TypeOfRoast = 'Dark' AND Coffee = Ref;
