/* code/sql/HW_COMPUTER_Variation.sql */


DROP SCHEMA IF EXISTS HW_COMPUTER_Variation;
CREATE SCHEMA HW_COMPUTER_Variation;
USE HW_COMPUTER_Variation;

CREATE TABLE COMPUTER(
    ID VARCHAR(20) PRIMARY KEY,
    Model VARCHAR(20)
);
CREATE TABLE PERIPHERAL(
    ID VARCHAR(20) PRIMARY KEY,
    Model VARCHAR(20),
    Type ENUM('mouse', 'keyboard',
          'screen', 'printer')
);
CREATE TABLE CONNEXION(
    Computer VARCHAR(20),
    Peripheral VARCHAR(20),
    PRIMARY KEY(Computer, Peripheral),
    FOREIGN KEY (Computer)
        REFERENCES COMPUTER(ID),
    FOREIGN KEY (Peripheral)
        REFERENCES PERIPHERAL(ID)
);
INSERT INTO COMPUTER VALUES
    ('A', 'Apple IIc Plus'),
    ('B', 'Commodore SX-64');
INSERT INTO PERIPHERAL VALUES
    ('12', 'Trendcom Model', 'printer'),
    ('14', 'TP-10 Thermal Matrix', 'printer'),
    ('15', 'IBM Selectric', 'keyboard');
INSERT INTO CONNEXION VALUES
    ('A', '12'), ('B', '14'), ('A', '15'); 
