--Section I. Functions and Procedures
--Part 1. Queries for SoftUni Database
--Problem 1. Employees with Salary Above 35000

--USE SoftUni

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary >= 35000

END

--EXEC usp_GetEmployeesSalaryAbove35000

--Problem 2. Employees with Salary Above Number

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@salary DECIMAL(18,4))
AS
BEGIN
	
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary >= @salary

END

--EXEC usp_GetEmployeesSalaryAboveNumber 48100

--Problem 3. Town Names Starting With

CREATE PROCEDURE usp_GetTownsStartingWith(@NameStartWith VARCHAR(MAX))
AS
BEGIN
	SELECT Name AS Town
	FROM Towns
	WHERE Name LIKE @NameStartWith +'%'
END

--EXEC usp_GetTownsStartingWith 'b'

--Problem 4. Employees from Town

--SELECT * FROM Employees
--SELECT * FROM Addresses
--SELECT * FROM Towns

CREATE PROCEDURE usp_GetEmployeesFromTown(@townName NVARCHAR(50))
AS
BEGIN
	
	DECLARE @townNameId INT = (SELECT TownID FROM Towns WHERE @townName = Name);

	SELECT e.FirstName, e.LastName
	FROM Employees AS e
	JOIN Addresses AS a
	ON e.AddressID = a.AddressID
	WHERE a.TownID = @townNameId
END

--EXEC usp_GetEmployeesFromTown 'Sofia'

--Problem 5. Salary Level Function

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18, 4))
RETURNS VARCHAR(10)
AS
BEGIN
	
	DECLARE @SalaryLevel VARCHAR(10);

	IF (@salary < 30000) SET @SalaryLevel = 'Low'
	ELSE IF (@salary BETWEEN 30000 AND 50000) SET @SalaryLevel = 'Average'
	ELSE SET @SalaryLevel = 'High'
	
	RETURN @SalaryLevel

END

--SELECT dbo.ufn_GetSalaryLevel(13500.00)
--SELECT dbo.ufn_GetSalaryLevel(43300.00)
--SELECT dbo.ufn_GetSalaryLevel(125500.00)


--Another solution

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18, 4))
RETURNS VARCHAR(10)
AS
BEGIN
	
	DECLARE @SalaryLevel VARCHAR(10);

	SET @SalaryLevel = CASE
		WHEN @salary < 30000 THEN 'Low'
		WHEN @salary <= 50000 THEN 'Average'
		ELSE 'High'
	END
	
	RETURN @SalaryLevel

END

--Problem 6. Employees by Salary Level

CREATE PROC usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(10))
AS
BEGIN
	
	SELECT FirstName, LastName
	FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

END

--EXEC usp_EmployeesBySalaryLevel 'High'

--Problem 7. Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
AS
BEGIN
	DECLARE @counter INT = 1;
	DECLARE @currentLetter CHAR;

	WHILE(@counter <= LEN(@word))
	BEGIN
		SET @currentLetter = SUBSTRING(@word, @counter, 1)
		DECLARE @charIndex INT = CHARINDEX(@currentLetter, @setOfLetters);
		iF (@charIndex <= 0) RETURN 0;
		SET @counter += 1;
	END
		
	RETURN 1;
END

--SElECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')
--SElECT dbo.ufn_IsWordComprised('oistmiahf', 'halves')

--Problem 8. * Delete Employees and Departments
SELECT * FROM EmployeesProjects
SELECT * FROM Employees

CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID = @departmentId)

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID = @departmentId)

	ALTER TABLE Departments
	ALTER COLUMN ManagerId INT

	UPDATE Departments
	SET ManagerID = NULL
	WHERE DepartmentID = @departmentId

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) FROM Employees
	WHERE DepartmentID = @departmentId
END

--Part 2. Queries for Bank Database
--Problem 9. Find Full Name

USE Bank

CREATE PROC usp_GetHoldersFullName
AS
BEGIN
	
	SELECT FirstName + ' ' + LastName AS [Full Name]
	FROM AccountHolders

END

--Problem 10. People with Balance Higher Than

CREATE PROC usp_GetHoldersWithBalanceHigherThan (@number DECIMAL(20, 2))
AS
BEGIN
	SELECT FirstName, LastName
	FROM (
	SELECT FirstName, LastName, SUM(a.Balance) AS [Total]
	FROM AccountHolders AS ah
	JOIN Accounts AS a
	ON ah.Id = a.AccountHolderId
	GROUP BY AccountHolderId, ah.FirstName, ah.LastName) AS tempTable
	WHERE Total >= @number
	ORDER BY FirstName, LastName
	
END
GO

--EXEC usp_GetHoldersWithBalanceHigherThan 7000

--Problem 11. Future Value Function

CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(30, 4), @rate FLOAT, @years INT)
RETURNS DECIMAL(30, 4)
AS
BEGIN
	DECLARE @futureValue DECIMAL(30, 4) =
		@sum * POWER((1 + @rate), @years);

	RETURN @futureValue
END

GO

--SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

--Problem 12. Calculating Interest

SELECT * FROM AccountHolders
SELECT * FROM Accounts

CREATE PROC usp_CalculateFutureValueForAccount(@AccountID INT, @InterestRate FLOAT)
AS
BEGIN
	SELECT ah.Id AS [Account Id],
	ah.FirstName AS [First Name],
	ah.LastName AS [Last Name],
	a.Balance AS [Current Balance],
	CAST(dbo.ufn_CalculateFutureValue(a.Balance, @InterestRate, 5) AS DECIMAL(30, 4))
	FROM Accounts AS a
	JOIN AccountHolders AS ah
	ON a.AccountHolderId = a.Id
	WHERE ah.Id = @AccountID
END