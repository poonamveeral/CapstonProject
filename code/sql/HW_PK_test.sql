/* code/sql/HW_PK_test.sql */

DROP SCHEMA IF EXISTS HW_PK_test;
CREATE SCHEMA HW_PK_test;
USE HW_PK_test;

CREATE TABLE TEST(
    A INT,
    B INT,
    PRIMARY KEY (A,B)
);
