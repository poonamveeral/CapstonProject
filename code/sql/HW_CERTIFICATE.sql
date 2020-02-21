/* code/sql/HW_CERTIFICATE.sql */

DROP SCHEMA IF EXISTS HW_CERTIFICAT;
CREATE SCHEMA HW_CERTIFICAT;
USE HW_CERTIFICAT;

/*
SN = Serial Number
CN = Common Name
CA = Certificate Authority
*/

CREATE TABLE ORGANIZATION(
	SN VARCHAR(30) PRIMARY KEY,
	CN VARCHAR(30)
);

CREATE TABLE CA(
    SN VARCHAR(30) PRIMARY KEY,
    CN VARCHAR(30),
    Trusted BOOL
);
CREATE TABLE CERTIFICATE(
	SN VARCHAR(30) PRIMARY KEY,
	CN Varchar(30) NOT NULL,
	Org VARCHAR(30) NOT NULL,
	Issuer VARCHAR(30),
	Valid_Since DATE,
	Valid_Until DATE,
    FOREIGN KEY (Org) 
        REFERENCES ORGANIZATION(SN)
        ON DELETE CASCADE,
    FOREIGN KEY (Issuer)
        REFERENCES CA(SN)
);

INSERT INTO ORGANIZATION VALUES
	('01', 'Wikimedia Foundation'),
	('02', 'Free Software Foundation');
	
INSERT INTO CA VALUES
	('A', "Let's Encrypt", true),
	('B', 'Shady Corp.', false),
	('C', 'NewComer Ltd.', NULL);
	
INSERT INTO CERTIFICATE VALUES
	('a', '*.wikimedia.org', '01', 'A', 20180101, 20200101),
	('b', '*.fsf.org', '02', 'A', 20180101, 20191010),
	('c', '*.shadytest.org', '02', 'B', 20190101, 20200101),
	('d', '*.wikipedia.org', '01', 'C', 20200101, 20220101);

-- CN of all certificates.
SELECT CN FROM CERTIFICATE;
-- (*.wikimedia.org | *.fsf.org | *.shadytest.org | *.wikipedia.org)

-- The SN of the organizations whose CN contains "Foundation"
SELECT SN FROM ORGANIZATION WHERE CN LIKE "%Foundation%";
-- (01 | 02)

-- The CN and expiration date of all the certificates that expired (assuming we are the 6th of December 2019).
SELECT CN, Valid_Until FROM CERTIFICATE WHERE Valid_Until < DATE'20191206';
-- (*.fsf.org,  2019-10-10)

-- The CN of the CA that are not trusted.
SELECT CN FROM CA WHERE Trusted IS NOT TRUE;
-- (Shady Corp. |  NewComer Ltd.)

-- The CN of the certificates that are signed by a CA that is not trusted.
SELECT CERTIFICATE.CN FROM CERTIFICATE, CA 
    WHERE Trusted IS NOT TRUE
        AND CA.SN = CERTIFICATE.Issuer;
-- (Shady Corp. | NewComer Ltd.)
        
-- The number of certificates signed by the CA whose CN is "Let's encrypt".
SELECT COUNT(CERTIFICATE.SN) AS "Number of certificates signed by Let's encrypt"
    FROM CERTIFICATE, CA
    WHERE CERTIFICATE.Issuer = CA.SN
        AND CA.CN = "Let's encrypt";
-- (2)

-- A table listing the CN of the organizations along with the CN of their certificates.
SELECT ORGANIZATION.CN AS Organization, CERTIFICATE.CN AS Certificate
    FROM ORGANIZATION, CERTIFICATE WHERE
    CERTIFICATE.Org = ORGANIZATION.SN;
-- ( Wikimedia Foundation,  *.wikimedia.org | Free Software Foundation, *.fsf.org | Free Software Foundation , *.shadytest.org | Wikimedia Foundation , *.wikipedia.org )


/* 
DELETE FROM CA WHERE SN = 'A';
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`HW_CERTIFICAT`.`CERTIFICATE`, CONSTRAINT `CERTIFICATE_ibfk_2` FOREIGN KEY (`Issuer`) REFERENCES `CA` (`SN`))

=> Rejected, because an entry in CERTIFICATE references this tuple (referential integrity constraint).

UPDATE ORGANIZATION SET CN = "FSF" WHERE SN = '02';
Query OK, 1 row affected (0.008 sec)
Rows matched: 1  Changed: 1  Warnings: 0

=> Ok, change 
('02', 'Free Software Foundation');
into
('02', 'FSF');
in ORGANIZATION

MariaDB [HW_CERTIFICAT]> UPDATE ORGANIZATION SET SN = "01" WHERE SN = '02';
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`HW_CERTIFICAT`.`CERTIFICATE`, CONSTRAINT `CERTIFICATE_ibfk_1` FOREIGN KEY (`Org`) REFERENCES `ORGANIZATION` (`SN`) ON DELETE CASCADE)

=> Rejected, because an entry in CERTIFICATE references this tuple (referential integrity constraint). 
This query would have been rejected even if this tuple was not referenced, since it would have violated the entity integrity constraint.

DELETE FROM ORGANIZATION;

=> Deletes all the content of organization and of certificate.
*/
