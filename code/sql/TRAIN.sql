/* code/sql/TRAIN.sql */

-- Question 1:

CREATE TABLE TRAIN(
    Id VARCHAR(30) PRIMARY KEY, -- This line was changed.
    Model VARCHAR(30),
    ConstructionYear YEAR(4)
);

-- Question 2 :

CREATE TABLE CONDUCTOR(
    Id VARCHAR(20),
    Name VARCHAR(20),
    ExperienceLevel VARCHAR(20)
);

ALTER TABLE CONDUCTOR
    ADD PRIMARY KEY (Id);

-- Question 3

CREATE TABLE ASSIGNED_TO(
    TrainId VARCHAR(20),
    ConductorId VARCHAR(20),
    Day DATE,
    PRIMARY KEY(TrainId, ConductorId),
    FOREIGN KEY (TrainId) REFERENCES TRAIN(Id), -- This line was changed
    FOREIGN KEY (ConductorId) REFERENCES CONDUCTOR(Id) -- This line was changed
);

-- Question 4:

/* 
 * We insert more than one tuple, to make
 * the SELECT statements that follow easier
 * to test and debug.
 */

INSERT INTO TRAIN VALUES ('K-13', 'SurfLiner', 2019), ('K-12', 'Regina', 2015);
INSERT INTO CONDUCTOR VALUES ('GP1029', 'Bill', 'Junior'), ('GP1030', 'Sandrine', 'Junior');
INSERT INTO ASSIGNED_TO VALUES ('K-13', 'GP1029', DATE'2015/12/14'), ('K-12', 'GP1030', '20120909');
 
-- Question 5:

UPDATE CONDUCTOR SET ExperienceLevel = 'Senior' WHERE Id = 'GP1029';

-- Question 6:
-- 1.
SELECT Id FROM TRAIN;

-- 2.
SELECT Name FROM CONDUCTOR WHERE ExperienceLevel = 'Senior';

-- 3.
SELECT ConstructionYear FROM TRAIN WHERE Model='SurfLiner' OR Model='Regina';

--4.
SELECT ConductorId FROM ASSIGNED_TO WHERE TrainId = 'K-13' AND Day='2015/12/14';

--5.
SELECT Model FROM TRAIN, ASSIGNED_TO WHERE ConductorID = 'GP1029' AND TrainId = TRAIN.ID;
