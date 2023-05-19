--GROUP Deliverable- Relational Database

DROP TABLE IF EXISTS "raw_data";
DROP TABLE IF EXISTS "Department";
DROP TABLE IF EXISTS "Employee";
DROP TABLE IF EXISTS "claim";
DROP TABLE IF EXISTS "Finance";
DROP TABLE IF EXISTS "Incident_employee";
DROP TABLE IF EXISTS "Injury";
SET search_path TO 'public';



CREATE TABLE "raw_data" (
  "EmpID" int4,
  "LastName" varchar,
  "FirstName" varchar,
  "Gender" varchar,
  "EmploymentStatus" varchar,
  "HireDate" date,
  "Position" varchar,
  "CurrentUnion" varchar,
  "Department" varchar,
  "VacDaysAllotted" int4,
  "VacDaysTaken" int4,       
  "IncidentDate" date,
  "DateReported" date,
  "DateReturned" date,
  "ClaimNo" int4,
  "IncidentTypeDescription" VARCHAR,
  "CauseDescription" VARCHAR,
  "ActionDescription" VARCHAR,
  "InjuryDescription" VARCHAR,
  "Location" VARCHAR,
  "DaysLost" int4,
  "WCBCosts" REAL,
  "OtherCosts" real,
  "ClaimStatus" VARCHAR
);
SELECT * FROM raw_data ;



CREATE TABLE "claim" (
    
  "ClaimNo" Integer,
  "ClaimStatus" varchar(20),
    PRIMARY KEY ("ClaimNo")
);



SELECT * FROM claim;



CREATE TABLE "Department" (
  "DepartmentID" Serial,
  "Department" Varchar(100),
    PRIMARY KEY ("DepartmentID")
);



CREATE TABLE "Employee" (
  "EmpSerialNo" Serial,
  "ClaimNo" Integer,
  "EmpID" Integer,
  "FirstName" varchar(100),
  "LastName" varchar(100),
  "Gender" varchar(100),
  "EmploymentStatus" varchar(30),
  "HireDate" Date,
  "Position" varchar(50),
  "CurrentUnion" varchar(30),
  "DepartmentID" Serial,
  "InjuryID" Serial,
  "IncidentID" Serial,
  "Department" Varchar(100),
    PRIMARY KEY ("EmpSerialNo"),
    FOREIGN KEY ("ClaimNo")REFERENCES "claim"("ClaimNo"),
    FOREIGN KEY ("DepartmentID")REFERENCES "Department"("DepartmentID"),
    FOREIGN KEY ("InjuryID") REFERENCES "Injury"("InjuryID"),
    FOREIGN KEY ("IncidentID") REFERENCES "Incident"("IncidentID")
);






SELECT * FROM "Employee";



CREATE TABLE "Injury" (
  "InjuryID" Serial,
  "InjuryDescription" varchar(100),
    PRIMARY KEY ("InjuryID")
);


SELECT * FROM "Injury";



CREATE TABLE "Incident" (
  "IncidentID" Serial,
  "IncidentDate" Date,
  "DateReported" Date,
  "DateReturned" Date,
  "IncidentTypeDescription" varchar(100),
  "Location" varchar(100),
    "EmpID" Integer,
    PRIMARY KEY ("IncidentID")
);




SELECT * FROM "Incident";


/*
CREATE TABLE "Finance" (
  "FinanceID" Serial,
  "ClaimNo" Integer,
  "WCBCosts" Integer,
  "OtherCosts" Integer,
    PRIMARY KEY ("FinanceID")
);
*/




SELECT * FROM "Employee";



--Populating Employee table
INSERT INTO "Employee"("ClaimNo","EmpID","FirstName","LastName","Gender","EmploymentStatus","HireDate","Position","CurrentUnion","DepartmentID","InjuryID","IncidentID","Department")
SELECT "claim"."ClaimNo"
,"Incident"."EmpID"
,"FirstName"
,"LastName"
,"Gender"
,"EmploymentStatus"
,"HireDate"
,"Position"
,"CurrentUnion"
,"Department"."DepartmentID"
,"Injury"."InjuryID"
,"Incident"."IncidentID"
,"Department"."Department"
FROM "raw_data"
INNER JOIN "claim"
      ON "claim"."ClaimNo" = "raw_data"."ClaimNo"
INNER JOIN "Department"
      ON "Department"."Department" = "raw_data"."Department"
INNER JOIN "Injury"
      ON "Injury"."InjuryDescription" = "raw_data"."InjuryDescription"
INNER JOIN "Incident"
      ON "Incident"."EmpID" = "raw_data"."EmpID";



--Populating Claim table
INSERT INTO "claim"("ClaimNo","ClaimStatus")
SELECT "ClaimNo","ClaimStatus" FROM raw_data;



--Populating Department table
INSERT INTO "Department"("Department")
SELECT DISTINCT "Department" FROM raw_data;



--Populating Finance table
--INSERT INTO "Finance"("ClaimNo","WCBCosts","OtherCosts")
--SELECT "ClaimNo","WCBCosts","OtherCosts" FROM raw_data;



--Populating Incident table
INSERT INTO "Incident"("IncidentDate","DateReported","DateReturned","IncidentTypeDescription","Location","EmpID")
SELECT "IncidentDate","DateReported","DateReturned","IncidentTypeDescription","Location","EmpID" FROM raw_data;



--Populating Injury table
INSERT INTO "Injury"("InjuryDescription")
SELECT DISTINCT "InjuryDescription" FROM raw_data;



--DML
-- INSERTION Query to insert a claim record into the claim table for the Employee ID : 1168
INSERT INTO "claim"("ClaimNo","ClaimStatus","EmpID")
VALUES ('25101306', 'Approved', '1168');



SELECT * FROM claim WHERE "ClaimNo" ='25101306' ;



-- DELETION Query: Delete the employee record for Josh Parker
DELETE FROM "Employee" WHERE "FirstName"='Josh';



select count("FirstName") FROM "Employee" WHERE "FirstName"='Josh';



--Updation Query: Update the claim table employee ID 1089 to approve all the claims
UPDATE "claim"
SET "ClaimStatus"='Approved'
WHERE "EmpID"='1089';


SELECT "ClaimStatus" FROM "claim" WHERE "EmpID"='1089';


SELECT * FROM "Injury" ;

SELECT * FROM "Vacation" ;

select * from "Injury" where "ClaimNo" = '31012105';


CREATE VIEW EmployeeClaimStatus AS
SELECT e."EmpID", e."FirstName", e."LastName", cl."ClaimStatus", i."IncidentTypeDescription"
FROM 
	"Employee" as e,
	"claim" as cl, "Incident" as i
	WHERE e."ClaimNo" = cl."ClaimNo" 
	AND e."EmpID" = i."EmpID";
	
	
	
Create View EmployeeClaimInjuryStatus as
Select DISTINCT e."EmpID", e."FirstName", e."LastName", cl."ClaimStatus", i."IncidentTypeDescription", inj."InjuryDescription"
From
    "Employee" as e
    INNER JOIN "claim" as cl ON e."ClaimNo" = cl."ClaimNo" 
    INNER JOIN "Incident" as i ON e."EmpID" = i."EmpID"
	INNER JOIN "Injury" as inj ON e."InjuryID" = inj."InjuryID";
SELECT * from EmployeeClaimInjuryStatus;


--DML on View

-- create a copy of the result of view_a
CREATE TABLE "EmployeeClaimInjuryStatusTable" AS SELECT * FROM EmployeeClaimInjuryStatus;

Select * from "EmployeeClaimInjuryStatusTable" where "EmpID"=1330;

-- redefine view_a to its own result
CREATE OR REPLACE VIEW EmployeeClaimInjuryStatus AS SELECT * FROM "EmployeeClaimInjuryStatusTable";

--Insertion

Insert into "EmployeeClaimInjuryStatusTable"("EmpID", "FirstName", "LastName", "ClaimStatus", "IncidentTypeDescription", "InjuryDescription" ) 
Values(1330, 'Park','Benz','Approved', 'Struck Against or Contact With', 'lt toe contusion'); 

--Updation

UPDATE "EmployeeClaimInjuryStatusTable"
SET "ClaimStatus"='Denied'
WHERE "EmpID"=1330;

--Delete the record of employee Josh Parker of Employee ID 1015

DELETE FROM "EmployeeClaimInjuryStatusTable" WHERE "EmpID"=1330;
----DML


INSERT INTO "claim"("ClaimNo","ClaimStatus")
VALUES ('25101306', 'Approved');


Select * from "Employee" where "ClaimNo" = 25101306;


INSERT INTO "Employee"("ClaimNo","EmpID","FirstName","LastName","Gender","EmploymentStatus","HireDate","Position","CurrentUnion","DepartmentID","InjuryID","IncidentID","Department")
VALUES (25101306, 1056,'Mini','Shawn','F', 'P_Fulltime','1989-06-30','Baker','UNION_A',4,140,364,'Administration');

DELETE FROM "Employee" WHERE "ClaimNo"=25101306;

UPDATE "claim"
SET "ClaimStatus"='Denied'
WHERE "ClaimNo"=25101306;




--Extension 1


CREATE TABLE "Finance" (
  "FinanceID" Serial,
  "ClaimNo" Int4,
  "WCBCosts" REAL,
  "OtherCosts" REAL,
	PRIMARY KEY ("FinanceID"),
	FOREIGN KEY ("ClaimNo") REFERENCES "claim"("ClaimNo")
);

--Populating Finance table
INSERT INTO "Finance"("ClaimNo","WCBCosts","OtherCosts")
SELECT "claim"."ClaimNo","WCBCosts","OtherCosts" FROM raw_data
JOIN "claim"
ON "claim"."ClaimNo" = raw_data."ClaimNo";


-- DML on Finance table

-- INSERTION Query to insert a finance record into the finance table for the Employee ID : 20101010
INSERT INTO "claim"("ClaimNo","ClaimStatus")
VALUES ('20101010', 'Pending');

INSERT INTO "Finance"("ClaimNo","WCBCosts","OtherCosts")
VALUES ('20101010', '117.30', '20.50');

SELECT * FROM "Finance" WHERE "ClaimNo" = '20101010' ;

-- DELETION Query: Delete the employee record for Josh Parker
DELETE FROM "Finance" WHERE "FinanceID"='366';

select count("FirstName") FROM "Employee" WHERE "FirstName"='Josh';

--Updation Query: Update the claim table employee ID 1089 to approve all the claims
UPDATE "Finance"
SET "WCBCosts"='1173.50'
WHERE "ClaimNo"='20101010';

--Individual view

Create View EmployeeClaimCost as
Select DISTINCT e."EmpID", e."FirstName", e."LastName",cl."ClaimNo", cl."ClaimStatus", f."WCBCosts", f."OtherCosts"
From
    "Employee" as e
    INNER JOIN "claim" as cl ON e."ClaimNo" = cl."ClaimNo"
    INNER JOIN "Finance" as f ON cl."ClaimNo" = f."ClaimNo";			

SELECT * from EmployeeClaimCost;

-- create a copy of the result of view_a
CREATE TABLE "EmployeeClaimCost" AS SELECT * FROM EmployeeClaimCost;
	Select * from "EmployeeClaimCost";


--Insertion

Insert into "EmployeeClaimCost"("EmpID", "FirstName", "LastName", "ClaimNo","ClaimStatus", "WCBCosts","OtherCosts" )
Values(1371, 'Park','Benz','27061111', 'Pending', '2810.1','0.0');



--Updation

UPDATE "EmployeeClaimCost"
SET "ClaimStatus"='Approved'
WHERE "EmpID"=1371;

--Delete the record of employee with Employee ID 1371

DELETE FROM "EmployeeClaimCost" WHERE "EmpID"=1371;



--Extension 2

CREATE TABLE "Vacation" (
  "VacationID" Serial,
  "VacDaysAllotted" Integer,
  "VacDaysTaken" Integer,
   "EmpID" Integer,
	PRIMARY KEY ("VacationID")
);


--Populating Vacation table
INSERT INTO "Vacation"("VacDaysAllotted","VacDaysTaken","EmpID" )
SELECT DISTINCT "VacDaysAllotted","VacDaysTaken","EmpID" FROM raw_data;

select * from "Vacation";

--VIEW

Create View EmployeeVacation as
Select DISTINCT e."EmpID", e."FirstName", e."LastName", v."VacDaysAllotted", inj."InjuryDescription"
From
    "Employee" as e
    INNER JOIN "Vacation" as v ON e."VacationID" = v."VacationID" 
	INNER JOIN "Injury" as inj ON e."InjuryID" = inj."InjuryID";
SELECT * from EmployeeVacation;

--DML on view
-- create a copy of the result of view_a
CREATE TABLE "EmployeeVacationTable" AS SELECT * FROM EmployeeVacation;

Select * from "EmployeeVacationTable" where "EmpID"= 1331;


--Insertion

Insert into "EmployeeVacationTable"("EmpID", "FirstName", "LastName", "VacDaysAllotted", "InjuryDescription" ) 
Values(1331, 'Gem','Mark', 12, 'lt toe contusion'); 

--Updation

UPDATE "EmployeeVacationTable"
SET "VacDaysAllotted"=30
WHERE "EmpID"=1331;

--Delete the record of employee Josh Parker of Employee ID 1015

DELETE FROM "EmployeeVacationTable" WHERE "EmpID"=1331;

 

--DML on Vacation
SELECT * FROM "Employee" where "EmpID"=1245;

--Insertion Query

--An employee newly incident is reported who is at baker position took a vacation of 6 days.
INSERT INTO "Employee"("ClaimNo","EmpID","FirstName","LastName","Gender","EmploymentStatus","HireDate","Position","CurrentUnion","DepartmentID","InjuryID","IncidentID","Department")
VALUES (25101336, 1245,'Van','Turner','M', 'P_Fulltime','1970-06-18','Baker','UNION_A',4,137,356,'Administration');

INSERT INTO "claim"("ClaimNo","ClaimStatus")
VALUES ('25101336', 'Approved');

INSERT INTO "Vacation"("VacationID","VacDaysAllotted","VacDaysTaken","EmpID")
VALUES (85, 17, 6, 1245);

SELECT * FROM "Vacation" WHERE "EmpID"=1245;

--Updation Query

--The employee recovered early and decided to rejoin 1 day before so he his number of days of vacation reduced by 1 day.

UPDATE "Vacation"
SET "VacDaysTaken"= 5
WHERE "EmpID"=1245;

--Deletion Query

--An employee resigned so his recorded are to be deleted from the history

DELETE FROM "Vacation" WHERE "EmpID"=1245;


--Extension 4

/*===== Hiring ======*/
CREATE TABLE "Hiring" (
"HiringID" Serial,
"EmpID" Integer,
"FirstName" varchar(100),
"LastName" varchar(100),
"Position" varchar(50),
"Department" varchar(100),
"HireDate" Date,
PRIMARY KEY ("HiringID")
)
-- Populating “Hiring
INSERT INTO "Hiring"("EmpID","FirstName","LastName","Position","Department","HireDate") 
SELECT DISTINCT "EmpID","FirstName","LastName","Position","Department","HireDate" from  "raw_data" order by "EmpID"

SELECT * FROM "Hiring"
--===== DML Internal Schema ===========
-- == SELECTION ==
select count(*) as "NumberOfEmployees", "Department" from "Hiring" group by "Department" 

-- == INSERTION ==
INSERT INTO "Hiring"("EmpID","FirstName","LastName","Position","Department","HireDate")
values
(1197,'John','Wick','Data Entry Clerk','Administration','2021-01-01')

select * from "Hiring" where "EmpID"=1197

INSERT INTO "Employee"
("EmpID","FirstName","LastName","Gender","EmploymentStatus","HireDate",
 "Position","CurrentUnion","DepartmentID","Department","HiringID")
values
(1197,'John','Wick','M','Full-time','2021-01-01',
'Data Entry Clerk','UNION A',4,'Administration',85)

select * from "Employee" where "EmpID"=1197

-- == UPDATION ==

UPDATE "Hiring"
set "Position"='Associate'
where "EmpID"=1197

UPDATE "Employee"
set "Position"='Associate'
where "EmpID"=1197

-- == DELETION ==
DELETE FROM "Hiring" WHERE "EmpID"=1197;
DELETE FROM "Employee" WHERE "EmpID"=1197;


/* ======== VIEW ========== */
Create View Employee_Reported_Incident_Details as
Select DISTINCT 
e."EmpID", e."FirstName", e."LastName", h."HireDate",h."Department",
i."IncidentDate", i."DateReported",i."IncidentTypeDescription"
From
    "Employee" as e
    INNER JOIN "Hiring" as h ON e."HiringID" = h."HiringID" 
	INNER JOIN "Incident" as i ON e."IncidentID" = i."IncidentID";

select * from Employee_Reported_Incident_Details


CREATE TABLE "Employee_Reported_Incident_Details_Tbl" AS SELECT * FROM Employee_Reported_Incident_Details;

Select * from "Employee_Reported_Incident_Details_Tbl" where "EmpID"=1198;

--DML on view

--Insertion

Insert into "Employee_Reported_Incident_Details_Tbl"
("EmpID", "FirstName", "LastName", "HireDate", "Department","IncidentDate",
"DateReported","IncidentTypeDescription") 
Values
(1198, 'Steve','Lacy','2022-01-01','Finance','2022-06-05','2022-06-06','Over Exertion'); 

--Updation

UPDATE "Employee_Reported_Incident_Details_Tbl"
SET "Department"='Administration'
WHERE "EmpID"=1198;

--Delete the record of employee 

DELETE FROM "Employee_Reported_Incident_Details_Tbl" WHERE "EmpID"=1198;

DROP TABLE IF EXISTS "Incident_employee";
DROP TABLE IF EXISTS "Incident_Type";
DROP TABLE IF EXISTS "Incident_Cause";
DROP TABLE IF EXISTS "Incident_Action";
DROP TABLE IF EXISTS "Incident_Claims";


--Project-2
--Dimension table
CREATE TABLE "Incident_employee" (
"EmpID" int4,
"ClaimNo" Integer,
"FirstName" varchar,
"LastName" varchar,
"Gender" varchar,
"EmploymentStatus" varchar,
"HireDate" date,
"Position" varchar,
"CurrentUnion" varchar,
"Department" varchar,
PRIMARY KEY ("EmpID", "ClaimNo")
);

SELECT * FROM raw_data;

SELECT * FROM "Incident_employee";

INSERT INTO "Incident_employee" ("EmpID", "ClaimNo", "FirstName", "LastName", "Gender", "EmploymentStatus", "HireDate", "Position", "CurrentUnion", "Department" )
SELECT "EmpID", "ClaimNo", "FirstName", "LastName", "Gender", "EmploymentStatus", "HireDate", "Position", "CurrentUnion", "Department"  FROM raw_data;

--Dimension table
CREATE TABLE "Incident_Type" (
	"IncidentID" serial,
	"IncidentTypeDescription" varchar,
	"InjuryDescription" varchar,
	PRIMARY KEY ("IncidentID")

);
	
INSERT INTO "Incident_Type" ( "IncidentTypeDescription", "InjuryDescription")
SELECT DISTINCT "IncidentTypeDescription", "InjuryDescription" FROM raw_data;

--Dimension table
CREATE TABLE "Incident_Cause" (
	"IncidentCauseID" serial,
	"CauseDescription" varchar,
	PRIMARY KEY ("IncidentCauseID")
);

INSERT INTO "Incident_Cause" ( "CauseDescription")
SELECT DISTINCT "CauseDescription" FROM raw_data;

--Dimension table
 CREATE TABLE "Incident_Action" (
	 "IncidentActionID" serial,
	 "ActionDescription" Varchar,
	 PRIMARY KEY ("IncidentActionID")
 )
 
 
 INSERT INTO "Incident_Action" ( "ActionDescription")
SELECT DISTINCT "ActionDescription" FROM raw_data;

--Dimension table
 CREATE TABLE "Incident_Location" (
	 "IncidentLocationID" serial,
	 "Location" Varchar,
	 PRIMARY KEY ("IncidentLocationID")
 )
	 
INSERT INTO "Incident_Location" ( "Location")
SELECT DISTINCT "Location" FROM raw_data;	 

--Fact Table
CREATE TABLE "Incident_Claims" (
	"ClaimNo" Integer,
	"EmpID" int4,
	"DateReported" date,
	"WCBCosts" REAL,
	"OtherCosts" REAL,
	"ClaimStatus" VARCHAR,
	"IncidentID" Serial,
	"IncidentCauseID" Serial,
	"IncidentActionID" Serial,
	"IncidentLocationID" Serial,
  PRIMARY KEY ("ClaimNo"),
    FOREIGN KEY ("EmpID", "ClaimNo")REFERENCES "Incident_employee"("EmpID", "ClaimNo"),
    FOREIGN KEY ("IncidentID")REFERENCES "Incident_Type"("IncidentID"),
    FOREIGN KEY ("IncidentCauseID") REFERENCES "Incident_Cause"("IncidentCauseID"),
    FOREIGN KEY ("IncidentActionID") REFERENCES "Incident_Action"("IncidentActionID"),
	FOREIGN KEY ("IncidentLocationID") REFERENCES "Incident_Location"("IncidentLocationID")
)
 
 SELECT * FROM "Incident_Claims" 
 
 
 INSERT INTO "Incident_Claims" ("ClaimNo", "EmpID", "DateReported", "WCBCosts", "OtherCosts", "ClaimStatus", "IncidentID", "IncidentCauseID", "IncidentActionID", "IncidentLocationID")
 SELECT "Incident_employee"."ClaimNo",
 		"Incident_employee"."EmpID",
		"DateReported",
		"WCBCosts",
		"OtherCosts",
		"ClaimStatus",
		"Incident_Type"."IncidentID",
		"Incident_Cause"."IncidentCauseID",
		"Incident_Action"."IncidentActionID",
		"Incident_Location"."IncidentLocationID"
		FROM "raw_data"
		RIGHT JOIN "Incident_employee"
		ON "Incident_employee"."ClaimNo" = "raw_data"."ClaimNo"
		JOIN "Incident_Type"
		ON "Incident_Type"."IncidentTypeDescription" = "raw_data"."IncidentTypeDescription"
		JOIN "Incident_Cause"
		ON "Incident_Cause"."CauseDescription" = "raw_data"."CauseDescription"
		JOIN "Incident_Action"
		ON "Incident_Action"."ActionDescription"= "raw_data"."ActionDescription"
		JOIN "Incident_Location"
		ON "Incident_Location". "Location" = "raw_data"."Location"
    ORDER BY "DateReported";

  --Individual deliverable 1  		
 CREATE TABLE "Incident_By_Position" (
	 "PositionID" serial,
	 "Position" Varchar,
	 PRIMARY KEY ("PositionID")
 )
 
 INSERT INTO "Incident_By_Position" ( "Position")
SELECT DISTINCT "Position" FROM raw_data;	

SELECT * FROM public."Incident_By_Position";

--Individual deliverable 2
 CREATE TABLE "Incident_By_Department" (
	 "DepartmentID" serial,
	 "Department" Varchar,
	 PRIMARY KEY ("DepartmentID")
 )
 
  INSERT INTO "Incident_By_Department" ( "Department")
SELECT DISTINCT "Department" FROM raw_data;	
 
 
CREATE TABLE "Incident_Claims_extended" (
	"ClaimNo" Integer,
	"EmpID" int4,
	"DateReported" date,
	"WCBCosts" REAL,
	"OtherCosts" REAL,
	"ClaimStatus" VARCHAR,
	"IncidentID" Serial,
	"IncidentCauseID" Serial,
	"IncidentActionID" Serial,
	"IncidentLocationID" Serial,
	"PositionID" Serial,
	"DepartmentID" Serial,
    FOREIGN KEY ("EmpID", "ClaimNo")REFERENCES "Incident_employee"("EmpID", "ClaimNo"),
    FOREIGN KEY ("IncidentID")REFERENCES "Incident_Type"("IncidentID"),
    FOREIGN KEY ("IncidentCauseID") REFERENCES "Incident_Cause"("IncidentCauseID"),
    FOREIGN KEY ("IncidentActionID") REFERENCES "Incident_Action"("IncidentActionID"),
	FOREIGN KEY ("IncidentLocationID") REFERENCES "Incident_Location"("IncidentLocationID"),
	FOREIGN KEY ("PositionID") REFERENCES "Incident_By_Position"("PositionID"),
	FOREIGN KEY ("DepartmentID") REFERENCES "Incident_By_Department"("DepartmentID")
) 

INSERT INTO "Incident_Claims" ("ClaimNo", "EmpID", "DateReported", "WCBCosts", "OtherCosts", "ClaimStatus", "IncidentID", "IncidentCauseID", "IncidentActionID", "IncidentLocationID", "PositionID", "DepartmentID" )
 SELECT "Incident_employee"."ClaimNo",
 		"Incident_employee"."EmpID",
		"DateReported",
		"WCBCosts",
		"OtherCosts",
		"ClaimStatus",
		"Incident_Type"."IncidentID",
		"Incident_Cause"."IncidentCauseID",
		"Incident_Action"."IncidentActionID",
		"Incident_Location"."IncidentLocationID",
		"Incident_By_Position"."PositionID",
		"Incident_By_Department"."DepartmentID"
		FROM "raw_data"
		RIGHT JOIN "Incident_employee"
		ON "Incident_employee"."ClaimNo" = "raw_data"."ClaimNo"
		INNER JOIN "Incident_Type"
		ON "Incident_Type"."IncidentTypeDescription" = "raw_data"."IncidentTypeDescription"
		INNER JOIN "Incident_Cause"
		ON "Incident_Cause"."CauseDescription" = "raw_data"."CauseDescription"
		INNER JOIN "Incident_Action"
		ON "Incident_Action"."ActionDescription"= "raw_data"."ActionDescription"
		INNER JOIN "Incident_Location"
		ON "Incident_Location". "Location" = "raw_data"."Location"
		INNER JOIN "Incident_By_Position"
		ON "Incident_By_Position". "Position" = "raw_data"."Position"
		INNER JOIN "Incident_By_Department"
		ON "Incident_By_Department". "Department" = "raw_data"."Department";