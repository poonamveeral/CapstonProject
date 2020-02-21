/* code/sql/HW_CONSTRAINTS_PART1.sql */

DROP SCHEMA IF EXISTS HW_CONSTRAINTS_PART1;
CREATE SCHEMA HW_CONSTRAINTS_PART1;
USE HW_CONSTRAINTS_PART1;

CREATE TABLE HURRICANE(
    Name VARCHAR(25) PRIMARY KEY,
    WindSpeed INT DEFAULT 76 CHECK (WindSpeed > 74 AND WindSpeed < 500),
    -- 75mph is the minimum to be considered as a hurricane
    -- cf. https://www.hwn.org/resources/bws.html
    Above VARCHAR(25)
);

CREATE TABLE STATE(
    Name VARCHAR(25) UNIQUE,
    Postal_abbr CHAR(2) NOT NULL
);
