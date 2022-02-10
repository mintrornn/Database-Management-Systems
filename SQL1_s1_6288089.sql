/* --------------------------------------------------------------
--   Please fill in your information in this comment block --  
--   Student ID: 
--   Fullname: 
--   Section: 
------------------------------------------------------------- */
DROP DATABASE IF EXISTS tinycompany; 
CREATE DATABASE IF NOT EXISTS tinycompany;
USE tinycompany;
-- Department Table 
CREATE TABLE department(
	dnumber		INT 		 PRIMARY KEY,  -- dnumber is a primary key
	dname		VARCHAR(20)  NOT NULL,
	location	VARCHAR(100), -- location is nullable 
	CONSTRAINT chk_dnumber CHECK (dnumber >= 1 AND dnumber <=20 ) -- dnumber range from 1 to 20
);

-- Project Table 
CREATE TABLE project(
	pnumber		INT 		 PRIMARY KEY,  -- dnumber is a primary key
	pname		VARCHAR(50)  NOT NULL,
	dept_no	 	INT 		 NOT NULL,
	CONSTRAINT FK_DeptProj FOREIGN KEY (dept_no) REFERENCES department(dnumber)
);

-- Write your DDL for employee and assignment here 
-- Hint: Review the CREATE sequence, i.e., which tables should be created first
USE tinycompany;
CREATE TABLE employee(
	fname		varchar(20)	NOT NULL,
    lname		varchar(20)	NOT NULL,
    ssn			char(9)		primary key,
    bdate		date		NOT NULL,
    sex			char(1)		NOT NULL,
    salary		decimal(12,2),	
    dept_no		int,
    constraint FK_DeptEmp foreign key (dept_no) references department(dnumber),
    constraint CHK_gender check (sex in ('M', 'F'))
);

CREATE TABLE assignment(
	essn		char(9)		NOT NULL,
    proj_no		int			NOT NULL,
    hours		decimal(9,2),
    hourly_rate	decimal(9,2),		
	constraint PK_assignment primary key (essn, proj_no),
	constraint FK_EmpAssign foreign key (essn) references employee(ssn),
    constraint FK_ProjAssign foreign key (proj_no) references project(pnumber)
);


