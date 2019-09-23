USE SoftUni

--Problem 1. Find Names of All Employees by First Name
SELECT FirstName, LastName
  FROM Employees
 WHERE LEFT(FirstName, 2) = 'Sa'

--Another Solution
SELECT FirstName, LastName
  FROM Employees
 WHERE FirstName LIKE 'Sa%'

--Problem 2. Find Names of All employees by Last Name
SELECT FirstName, LastName
  FROM Employees
 WHERE NOT (CHARINDEX('ei', LastName) = 0)

--Exercises
SELECT DATENAME(WEEKDAY, '2019/09/23') --Monday
SELECT DATENAME(WEEKDAY, '1978/02/02') --Thursday
SELECT DATEDIFF(YEAR,'1978/02/02', '2019/09/23') --41
SELECT DATEDIFF(DAY, '1978/02/02', '2019/09/23') --15208
SELECT GETDATE() --2019-09-23 17:42:16.243
SELECT EOMONTH('2019/09/23') --2019-09-30

--Problem 3. Find First Names of All Employees
SELECT FirstName
  FROM Employees
 WHERE DepartmentID IN (3, 10)
	   AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

--Problem 4. Find All Employees Except Engineers
SELECT FirstName, LastName
  FROM Employees
 WHERE CHARINDEX('engineer', JobTitle) = 0

--Problem 5. Find Towns with Name Length
SELECT Name
  FROM Towns
 WHERE LEN(Name) IN (5, 6)
ORDER BY Name

--Problem 6. Find Towns Starting With
SELECT TownId, Name
  FROM Towns
 WHERE LEFT(Name, 1) IN ('M', 'K', 'B', 'E')
ORDER BY Name

--Problem 7. Find Towns Not Starting With
SELECT TownId, Name
  FROM Towns
 WHERE LEFT(Name, 1) NOT IN ('R', 'D', 'B')
ORDER BY Name

--Problem 8. Create View Employees Hired After 2000 Year
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
  FROM Employees
 WHERE DATEPART(YEAR, HireDate) > 2000

--Problem 9. Length of Last Name
SELECT FirstName, LastName
  FROM Employees
 WHERE LEN(LastName) = 5

--Problem 10. Rank Employees by Salary

--Problem 11. Find All Employees with Rank 2

--Problem 12. Countries Holding 'A'
USE Geography

SELECT CountryName, IsoCode
  FROM Countries
 WHERE LOWER(CountryName) LIKE'%a%a%a%'
ORDER BY ISOCode

--Problem 13. Mix of Peak and River Names 
SELECT PeakName,
	   RiverName,
	   LOWER(PeakName + SUBSTRING(RiverName, 2, LEN(RiverName) - 1)) AS Mix 
FROM Peaks
JOIN Rivers
ON RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix

--Problem 14. Games from 2011 and 2012 year
USE Diablo

SELECT TOP(50) Name, FORMAT(Start, 'yyyy-MM-dd') AS 'Start'
  FROM Games
 WHERE DATEPART(YEAR, Start) IN (2011, 2012)
 ORDER BY Start, Name

--Problem 15. User Email Providers
SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email, 1) + 1, LEN(Email)) AS [Email Provider]
  FROM Users
ORDER BY [Email Provider], Username

--Problem 16. Get Users with IPAddress Like Pattern
SELECT Username, IpAddress
  FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--Problem 17. Show All Games with Duration
SELECT Name AS Game,
	[Part of the Day] = 
		CASE 
			WHEN DATEPART(HOUR, Start) < 12 THEN 'Morning'
			WHEN DATEPART(HOUR, Start) < 18 THEN 'Afternoon'
			ELSE 'Evening'
		END,
	Duration =
		CASE
			WHEN Duration <= 3 THEN 'Extra Short'
			WHEN Duration <= 6 THEN 'Short'
			WHEN Duration > 6 THEN 'Long'
			ELSE 'Extra Long'
		END
FROM Games
ORDER BY Game, Duration, [Part of the Day]

--Problem. 18. Orders Table
USE Orders

SELECT ProductName,
	   OrderDate,
	   DATEADD(DAY, 3, OrderDate) AS 'Pay Due',
	   DATEADD(MONTH, 1, OrderDate) AS 'Deliever Due'
FROM Orders

--Problem 19. People Table
CREATE TABLE People (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL,
	Birthdate DATETIME NOT NULL
)

INSERT INTO People VALUES
('Viktor', '2000-12-07'),
('Steven', '1992-09-10'),
('Stephen', '1910-09-19'),
('John', '2010-01-06')

SELECT Name,
	DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years],
	DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],
	DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days],
	DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes]
 FROM People