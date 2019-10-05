--Problem 1. One-To-One Relationship

CREATE DATABASE TableRelations

USE TableRelations

CREATE TABLE Passports (
	PassportID INT PRIMARY KEY,
	PassportNumber CHAR(8)
)

CREATE TABLE Persons (
	PersonId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL,
	Salary DECIMAL(10, 2),
	PassportID INT UNIQUE,
	CONSTRAINT FK_PassportID
	FOREIGN KEY (PassportID)
	REFERENCES Passports(PassportID)
)

INSERT INTO Passports(PassportID, PassportNumber)
VALUES (101, 'N34FG21B')

INSERT INTO Passports(PassportID, PassportNumber)
VALUES (102, 'K65LO4R7')

INSERT INTO Passports(PassportID, PassportNumber)
VALUES (103, 'ZE657QP2')

INSERT INTO Persons(FirstName, Salary, PassportID) VALUES
	('Roberto', 43300.00, 102),
	('Tom', 56100.00, 103),
	('Yana', 60200.00, 101)

--Problem 2. One-To-Many Relationship

CREATE TABLE Manufacturers (
	ManufacturerID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL,
	EstablishedOn DATETIME
)

CREATE TABLE Models (
	ModelID INT PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	ManufacturerID INT,
	CONSTRAINT FK_Models_Manufacurers
	FOREIGN KEY (ManufacturerID)
	REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers(Name, EstablishedOn) VALUES
	('BMW', '07/03/1916'),
	('Tesla', '01/01/2003'),
	('Lada', '01/05/1966')

INSERT INTO Models(ModelID, Name, ManufacturerID) VALUES
	(101, 'X1', 1),
	(102, 'i6', 1),
	(103, 'Model S', 2),
	(104, 'Model X', 2),
	(105, 'Model 3', 2),
	(106, 'Nova', 3)

--Problem 3. Many-To-Many Relationship

CREATE TABLE Students (
	StudentID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Exams (
	ExamID INT PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE StudentsExams (
	StudentID INT,
	ExamID INT,
	
	CONSTRAINT PK_StudentsExams
	PRIMARY KEY (StudentID, ExamID),
	
	CONSTRAINT FK_PK_StudentsExams_Students
	FOREIGN KEY (StudentID)
	REFERENCES Students(StudentID),

	CONSTRAINT FK_PK_StudentsExams_Exams
	FOREIGN KEY (ExamID)
	REFERENCES Exams(ExamID)
)

INSERT INTO Students(Name) VALUES
	('Mila'), ('Toni'), ('Ron')

INSERT INTO Exams(ExamID, Name) VALUES
	(101, 'SpringMVC'),
	(102, 'Neo4j'),
	(103, 'Oracle 11g')

INSERT INTO StudentsExams(StudentID, ExamID) VALUES
	(1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2, 103)

--Problem 4. Self-Referencing

CREATE TABLE Teachers (
	TeacherID INT PRIMARY KEY,
	Name VARCHAR(50),
	ManagerID INT,
	CONSTRAINT FK_ManagerID
	FOREIGN KEY (ManagerID)
	REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers (TeacherID, Name, ManagerID) VALUES
	(101, 'John', NULL),
	(102, 'Maya', 106),
	(103, 'Silvia', 106),
	(104, 'Ted', 105),
	(105, 'Mark', 101),
	(106, 'Greta', 101)

--Problem 6. University Database

CREATE DATABASE University

USE University

CREATE TABLE Majors(
	MajorID INT PRIMARY KEY,
	[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Students(
	StudentID INT PRIMARY KEY,
	StudentNumber NVARCHAR(15) NOT NULL,
	StudentName NVARCHAR(60) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID) NOT NULL
)

CREATE TABLE Payments(
	PaymentID INT PRIMARY KEY,
	PaymentDate SMALLDATETIME NOT NULL,
	PaymentAmount DECIMAL(10, 2) NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Subjects(
	SubjectID INT PRIMARY KEY,
	SubjectName NVARCHAR(30) NOT NULL,
)

CREATE TABLE Agenda(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
	CONSTRAINT PK_Composite_StudentID_SubjectID
	PRIMARY KEY(StudentID, SubjectID)
)

--Problem 9. *Peaks in Rila

USE [Geography]

--First Solution

SELECT m.MountainRange, p.PeakName, p.Elevation
FROM Mountains AS m
JOIN Peaks AS p ON m.Id = p.MountainId
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC

--Second Solution

SELECT m.MountainRange, p.PeakName, p.Elevation
FROM Peaks AS p
JOIN Mountains AS m
ON p.MountainId = m.Id
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC

--Third Solution

SELECT m.MountainRange, p.PeakName, p.Elevation
FROM Peaks AS p, Mountains AS m
WHERE m.MountainRange = 'Rila' AND p.MountainId = m.Id 
ORDER BY p.Elevation DESC