SPOOL project.txt
SET ECHO ON
/*
CIS 353 - Database Design Project
Fortune Dessin
Alex Johnson
Nikki Noble
Eric Weber
*/
--
-- Drop tables if they exist
-- 
DROP TABLE Clients CASCADE CONSTRAINTS;
DROP TABLE Locations CASCADE CONSTRAINTS;
DROP TABLE Employees CASCADE CONSTRAINTS;
DROP TABLE Equipment CASCADE CONSTRAINTS;
DROP TABLE AccessPoints CASCADE CONSTRAINTS;
DROP TABLE Cameras CASCADE CONSTRAINTS;
DROP TABLE Patrols CASCADE CONSTRAINTS;
DROP TABLE AccessLog CASCADE CONSTRAINTS;
DROP TABLE Representative CASCADE CONSTRAINTS;
-- ------------------------------------------
-- 
-- Create Tables
-- 
-- CLIENTS TABLE (Fourtune Dessin)
--
CREATE TABLE Clients
(
clientId		 INTEGER PRIMARY KEY,
clientName		 CHAR(30) NOT NULL,
repID            INTEGER NOT NULL
);
-- 
-- REPRESENTATIVE TABLE (Fourtune Dessin)
--
CREATE TABLE Representative
(
repID INTEGER PRIMARY KEY,
repName CHAR(30),
repPhone CHAR(10)
);
--
-- LOCATIONS TABLE (Alex Johnson)
--
CREATE TABLE Locations
(
address			CHAR(128) PRIMARY KEY,
clientId		INTEGER,
sqFootage		INTEGER,
maxFloors		INTEGER,
--
-- Constraints
CONSTRAINT lIC1 CHECK (maxFloors > 0),
CONSTRAINT lIC2 CHECK (sqFootage > 0)
);
-- 
-- EMPLOYEES TABLE (Alex Johnson)
--
CREATE TABLE Employees
(
empId			INTEGER PRIMARY KEY,
eName			CHAR(64) NOT NULL,
title			CHAR(32) NOT NULL,
phone			CHAR(10) NOT NULL,
accessLevel		INTEGER,
equipSerialNum	INTEGER,
--
-- Constraints
CONSTRAINT emIC1 CHECK 
    ((accessLevel > 0 AND accessLevel < 4 AND (title != 'Guard' OR title != 'guard') OR 
    accessLevel > 3 AND accessLevel < 11 AND (title = 'Guard' OR title = 'guard')))
);
-- 
-- EQUIPMENT TABLE (Nikki J. Noble)
--
CREATE TABLE Equipment
(
serialNum		INTEGER NOT NULL,
eType			CHAR(64) NOT NULL,
--
-- Constraints
CONSTRAINT eqIC1 PRIMARY KEY (serialNum),
CONSTRAINT eqIC2 CHECK (serialNum > 0)
);
-- 
-- ACCESSPOINTS TABLE (Eric Weber)
--
CREATE TABLE AccessPoints
(
doorId			INTEGER NOT NULL,
address			CHAR(128) NOT NULL,
reqAccessLevel	INTEGER,
onFloor			INTEGER NOT NULL,
--
-- Constraints
CONSTRAINT apIC1 PRIMARY KEY (doorid),
CONSTRAINT apIC2 CHECK (reqAccessLevel > 0 AND reqAccessLevel < 11)
);
-- 
-- CAMERAS TABLE (Fourtune Dessin)
--
CREATE TABLE Cameras
(
address			CHAR(128),
cameraName		CHAR(64),
--
-- KEY
PRIMARY KEY(address, cameraName)
);
-- 
--
-- PATROLS TABLE (Alex Johnson)
--
CREATE TABLE Patrols
(
empId			INTEGER,
address			CHAR(120),
routeDuration	NUMBER,
--
-- KEY
PRIMARY KEY(empId, address)
);
-- 
-- ACCESSLOG TABLE (Nikki J. Noble)
--
CREATE TABLE AccessLog
(
doorId			INTEGER,
empId			INTEGER,
alTimestamp		TIMESTAMP,
-- 
-- KEY
CONSTRAINT alIC1 PRIMARY KEY(doorId, empId, alTimestamp)
);
-- ------------------------------------------
-- 
-- FOREIGN KEYS
-- 
ALTER TABLE Locations ADD FOREIGN KEY (clientId) REFERENCES Clients(clientId) ON DELETE CASCADE;
ALTER TABLE Employees ADD FOREIGN KEY (equipSerialNum) REFERENCES Equipment(serialNum) ON DELETE CASCADE;
ALTER TABLE AccessPoints ADD FOREIGN KEY (address) REFERENCES Locations(address) ON DELETE CASCADE;
ALTER TABLE Cameras ADD FOREIGN KEY (address) REFERENCES Locations(address) ON DELETE CASCADE;
ALTER TABLE Patrols ADD FOREIGN KEY (empId) REFERENCES Employees(empId) ON DELETE CASCADE;
ALTER TABLE AccessLog ADD FOREIGN KEY (doorId) REFERENCES AccessPoints(doorId) ON DELETE CASCADE;
ALTER TABLE AccessLog ADD FOREIGN KEY (empId) REFERENCES Employees(empId) ON DELETE CASCADE;
ALTER TABLE Clients ADD CONSTRAINT FK_Rep FOREIGN KEY(repID) REFERENCES Representative(repID);
-- -------------------------------------------
SET FEEDBACK OFF
-- 
-- INSERT statements
-- 
-- Clients Inserts
--
INSERT INTO Representative VALUES (20, 'Love Quinn', '6161234567');
INSERT INTO Representative VALUES (25, 'Joe Goldberg', '6161234567');
INSERT INTO Representative VALUES (30, 'Jessica Morgan', '6161234567');
INSERT INTO Representative VALUES (35, 'John Smith', '6161234567');
-- 
-- Clients Inserts
--
INSERT INTO Clients VALUES (1, 'Rentsville Armory', 20);
INSERT INTO Clients VALUES (2, 'Tamron Foods', 25);
INSERT INTO Clients VALUES (4, 'Gentech Research', 30);
INSERT INTO Clients VALUES (8, 'Testing Technologies', 35);
--
-- Locations Inserts
--
INSERT INTO Locations VALUES ('1234 Ross St', 1, 10000, 1);
INSERT INTO Locations VALUES ('2222 Cross Ave', 1, 15000, 1);
INSERT INTO Locations VALUES ('4444 Circle Dr', 2, 30000, 1);
INSERT INTO Locations VALUES ('5555 Cent Dr', 4, 100000, 5);
INSERT INTO Locations VALUES ('8888 Patent Ave', 8, 120000, 6);
--
-- Equipment Inserts
--
INSERT INTO Equipment VALUES (20, 'Club');
INSERT INTO Equipment VALUES (12, 'Firearm');
INSERT INTO Equipment VALUES (15, 'Firearm');
INSERT INTO Equipment VALUES (34, 'Taser');
INSERT INTO Equipment VALUES (41, 'Taser');
--
-- Employees Inserts
--
INSERT INTO Employees VALUES (15, 'Jim James', 'Human Resources', '1112223333', 1, NULL);
INSERT INTO Employees VALUES (23, 'Alex Johnson', 'Guard', '2223334444', 8, 34);
INSERT INTO Employees VALUES (34, 'Clara Reed', 'Guard', '3334445555', 4, 20);
INSERT INTO Employees VALUES (35, 'Kim Road', 'IT Analyist', '4445556666', 1, NULL);
INSERT INTO Employees VALUES (46, 'Jordan Mccinnis', 'Guard', '5556667777', 10, 12);
INSERT INTO Employees VALUES (47, 'Jen Fetch', 'Administrative Assistant', '6667778888', 2, NULL);
INSERT INTO Employees VALUES (48, 'Kyle Farms', 'Administrative Assistant', '7778889999', 3, NULL);
INSERT INTO Employees VALUES (52, 'Peter Fram', 'Guard', '8889990000', 5, NULL);
--
-- AccessPoints Inserts
--
INSERT INTO AccessPoints VALUES (101, '1234 Ross St', 1, 1);
INSERT INTO AccessPoints VALUES (102, '1234 Ross St', 1, 1);
INSERT INTO AccessPoints VALUES (103, '1234 Ross St', 4, 1);
INSERT INTO AccessPoints VALUES (201, '2222 Cross Ave', 1, 1);
INSERT INTO AccessPoints VALUES (202, '2222 Cross Ave', 1, 1);
INSERT INTO AccessPoints VALUES (203, '2222 Cross Ave', 4, 1);
INSERT INTO AccessPoints VALUES (204, '2222 Cross Ave', 4, 1);
INSERT INTO AccessPoints VALUES (301, '4444 Circle Dr', 1, 1);
INSERT INTO AccessPoints VALUES (302, '4444 Circle Dr', 2, 1);
INSERT INTO AccessPoints VALUES (401, '5555 Cent Dr', 1, 1);
INSERT INTO AccessPoints VALUES (402, '5555 Cent Dr', 4, 2);
INSERT INTO AccessPoints VALUES (403, '5555 Cent Dr', 6, 3);
INSERT INTO AccessPoints VALUES (404, '5555 Cent Dr', 8, 4);
INSERT INTO AccessPoints VALUES (501, '8888 Patent Ave', 1, 1);
INSERT INTO AccessPoints VALUES (502, '8888 Patent Ave', 10, 4);
--
-- Cameras Inserts
--
INSERT INTO Cameras VALUES ('1234 Ross St', 'Front Entry 1');
INSERT INTO Cameras VALUES ('1234 Ross St', 'Back Entry 1');
INSERT INTO Cameras VALUES ('8888 Patent Ave', 'Front Entry 1');
INSERT INTO Cameras VALUES ('8888 Patent Ave', 'Second Floor Labs');
INSERT INTO Cameras VALUES ('8888 Patent Ave', 'Radiation Lab');
--
-- Patrols Inserts
--
INSERT INTO Patrols VALUES (23, '1234 Ross St', 1);
INSERT INTO Patrols VALUES (23, '2222 Cross Ave', 2.5);
INSERT INTO Patrols VALUES (34, '5555 Cent Dr', 4);
INSERT INTO Patrols VALUES (46, '8888 Patent Ave', 7.5);
INSERT INTO Patrols VALUES (52, '4444 Circle Dr', 6);
--
-- AccessLog Inserts
--
INSERT INTO AccessLog VALUES (101, 23, TO_TIMESTAMP('2020-11-02 07:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (101, 21, TO_TIMESTAMP('2020-11-02 07:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (101, 23, TO_TIMESTAMP('2020-11-02 07:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (101, 33, TO_TIMESTAMP('2020-11-02 07:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (102, 23, TO_TIMESTAMP('2020-11-02 07:30:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (103, 23, TO_TIMESTAMP('2020-11-02 07:45:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (201, 23, TO_TIMESTAMP('2020-11-04 10:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (202, 23, TO_TIMESTAMP('2020-11-04 10:50:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (202, 23, TO_TIMESTAMP('2020-11-04 10:30:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (203, 23, TO_TIMESTAMP('2020-11-04 10:45:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (301, 52, TO_TIMESTAMP('2020-11-15 12:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (402, 52, TO_TIMESTAMP('2020-11-15 12:30:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (403, 46, TO_TIMESTAMP('2020-11-15 17:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (501, 46, TO_TIMESTAMP('2020-11-15 17:30:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO AccessLog VALUES (502, 46, TO_TIMESTAMP('2020-11-15 18:20:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
--
SET FEEDBACK ON
COMMIT;
--
-- -------------------------------------------
--
-- Show Tables 
--
SELECT * FROM Clients;
SELECT * FROM Locations;
SELECT * FROM Employees;
SELECT * FROM Equipment;
SELECT * FROM AccessPoints;
SELECT * FROM Cameras;
SELECT * FROM Patrols;
SELECT * FROM AccessLog;
--
-- -------------------------------------------
--
-- Queries
--
-- Q1 String Manipulation
-- return the rows that contain Taser as the type 
SELECT *
FROM Equipment
WHERE eType LIKE '%e%';
--
-- Q2 Null Values 
-- return all equipment row in which the serialNum is not null 
SELECT serialNum, eType
FROM Equipment
WHERE serialNum IS NOT NULL;
-- 
-- Q3 Join Tables 
--  return employee name, ID and equipment type if an employee is equipt with a firearm and are in the access log table (they have passed throught an access point)
SELECT DISTINCT E.eName, E.empID, EQ.eType
FROM AccessLog A, Employees E, Equipment EQ
WHERE EQ.eType = 'Firearm' AND
      A.empID = E.empID;
--
-- Q4 Self Join 
-- return 2 different employees have the title Guard
SELECT DISTINCT E1.ename, E2.ename, E1.title, E2.title
FROM Employees E1, Employees E2
WHERE E1.title = 'Guard' AND
      E2.title = E1.title AND
      E2.empID > E1.empID;
--
-- Q5 Remove Duplicates 
-- Find the all types of equipment available remove duplicates
--
SELECT DISTINCT e.etype
FROM Equipment e;
--
-- Q6 UNION
-- Find the client ID and client name for clients having more than one location. 
--
SELECT c.clientId, c.clientName, COUNT(*)
FROM LOCATIONS l, CLIENTS c
WHERE l.clientID = c.clientID 
GROUP BY c.clientID, c.clientName
HAVING COUNT(*) > 1;
--
-- Q7 MINUS
-- Find the employees titled guards that are not assigned any equipment
--
SELECT emp.empId, emp.eName, emp.equipSerialNum
FROM Employees emp
WHERE emp.title = 'Guard' 
MINUS
SELECT emp.empId, emp.eName, emp.equipSerialNum
FROM Employees emp, Equipment eq
WHERE emp.equipSerialNum = eq.serialNum;
--
-- Q8 Non-Coorelated
-- Find the employees titled guards that are assigned equipment
--
SELECT emp.empId, emp.eName, emp.equipSerialNum
FROM Employees emp
WHERE emp.title = 'Guard' AND
	  emp.equipSerialNum IN (SELECT eq.serialNum
							 FROM Equipment eq);
--
-- Q9 Coorelated 
-- All employees who are guards with an access level less than 6 who do not have any door access records
SELECT E.empId, E.eName
FROM Employees E
WHERE E.accessLevel < 6 AND E.title = 'Guard' AND
    NOT EXISTS (SELECT AL.empId
                FROM AccessLog AL
                WHERE E.empId = AL.empId);
--
-- Q10 Set Comparison - ALL, ANY, or SOME
-- Address and square footage for all locations with a greater square footage than every location with less than 5 floors
SELECT L.address, L.sqFootage
FROM Locations L
WHERE L.sqFootage > ALL
    (SELECT L.sqFootage
    FROM Locations L
    WHERE L.maxFloors < 5);
--
-- Q11 Aggregation - MAX, AVG, or MIN
-- Average route duration for all buildings with one floor
SELECT AVG(P.routeDuration)
FROM Patrols P, Locations L
WHERE L.address = P.address AND L.maxFloors = 1;
--
-- Q12 GROUP BY / Counting
-- Count the number of access records and group by clientId and client name
SELECT Cl.clientId, Cl.clientName, COUNT(*)
FROM Clients Cl, Locations L, AccessPoints Ap, AccessLog Al
WHERE Cl.clientId = L.clientId AND L.address = Ap.address AND Ap.doorId = Al.doorId
GROUP BY Cl.clientId, Cl.clientName;
--
-- Q13 HAVING 
-- ClientIds and client names for all with more than 5 access records
SELECT Cl.clientId, Cl.clientName, COUNT(*)
FROM Clients Cl, Locations L, AccessPoints Ap, AccessLog Al
WHERE Cl.clientId = L.clientId AND L.address = Ap.address AND Ap.doorId = Al.doorId
GROUP BY Cl.clientId, Cl.clientName
HAVING COUNT(*) > 5;
INSERT INTO AccessLog VALUES (502, 52, TO_TIMESTAMP('2020-11-15 22:30:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
--
-- Q14 LEFT OUTER Join
-- [Find the empID, name, routeAddress, and routeDuration of every employee. Also show the route of every employee who was on patrol.]
SELECT E.empid, E.ename, P.address, P.routeduration
FROM Employees E LEFT OUTER JOIN Patrols P ON E.empid = P.empid;
--
-- Q15 TOP-N
-- [Find the empid, ename, title, and accessLevel of the top 3 employees with the highest access level.]
SELECT empId, eName, title, accessLevel   
FROM (SELECT * FROM Employees ORDER BY accessLevel DESC)
WHERE ROWNUM < 4;
--
-- Q16 RANK
-- [Find the rank of reqaccessLevel 4 among all reqaccessLevel in AccessPoints.]
SELECT RANK(4) WITHIN GROUP
(ORDER BY reqaccessLevel) "Rank of 4"
FROM AccessPoints;
--
-- Q17 DENSE_RANK
-- [Find the dense rank of reqaccessLevel 4 among all reqaccessLevel in AccessPoints.]
SELECT DENSE_RANK(4) WITHIN GROUP
(ORDER BY reqaccessLevel) "Dense Rank of 4"
FROM AccessPoints;
--
-- Q18 DIVISION
-- Finds all employees who has accessed all of the access points at the location 8888 Patent Ave
SELECT E.empId, E.eName
FROM Employees E
WHERE NOT EXISTS ((SELECT Ap.doorId
                FROM AccessPoints Ap
                WHERE Ap.address = '8888 Patent Ave')
                MINUS
                (SELECT Al.doorId
                FROM AccessLog Al
                WHERE E.empId = Al.empId));
-- -------------------------------------------
--
-- Testing Locations CONSTRAINTS
--
-- Testing foreign key
INSERT INTO Locations VALUES ('Testing Foreign Key', 10, 120, 3);
-- Testing lIC1
INSERT INTO Locations VALUES ('Testing lIC1', 1, 100, -1); 
-- Testing lIC2
INSERT INTO Locations VALUES ('Testing lIC2', 1, -100, 1);
-- 
-- Testing Equipment CONSTRAINTS
-- 
-- Testing eqIC2
INSERT INTO Equipment VALUES (-1, 'Testing Negative Key');
--
-- Testing Employees CONSTRAINTS
--
-- Testing FOREIGN KEY
INSERT INTO Employees VALUES (90, 'Testing Foreign Key', 'T', 'T', 1, 999999);
-- Testing emIC1 (guard lower than 4)
INSERT INTO Employees VALUES (100, 'Testing eIC1', 'Guard', 'T', 3, NULL);
-- Testing emIC1 (guard higher than 10)
INSERT INTO Employees VALUES (110, 'Testing eIC1', 'Guard', 'T', 11, NULL);
-- Testing emIC1 (non guard lower than 1)
INSERT INTO Employees VALUES (120, 'Testing eIC1', 'Testing', 'T', 0, NULL);
-- Testing emIC1 (guard higher than 3)
INSERT INTO Employees VALUES (130, 'Testing eIC1', 'Testing', 'T', 4, NULL);
--
-- Testing AccessPoints CONSTRAINTS
--
-- Testing FOREIGN KEY
INSERT INTO AccessPoints VALUES (60, 'Testing Foreign Key', 1, 1);
-- Testing apIC2
INSERT INTO AccessPoints VALUES (50, '8888 Patent Ave', 0, 1);
INSERT INTO AccessPoints VALUES (51, '8888 Patent Ave', 11, 1); 
-- 
COMMIT;
--
SPOOL OFF