USE Gringotts

--Problem 01. Records’ Count
--Import the database and send the total count of records from the one and only table to Mr. Bodrog. Make sure nothing got lost.

SELECT COUNT(w.Id)
  FROM WizzardDeposits AS w

--Problem 02. Longest Magic Wand
--Select the size of the longest magic wand. Rename the new column appropriately.

SELECT MAX(w.MagicWandSize) AS LongestMagicWand
  FROM WizzardDeposits AS w

--Problem 03. Longest Magic Wand per Deposit Groups
--For wizards in each deposit group show the longest magic wand. Rename the new column appropriately.

SELECT w.DepositGroup, MAX(w.MagicWandSize) AS [LongestMagicWand]
  FROM WizzardDeposits AS w
GROUP BY w.DepositGroup

--Problem 04. * Smallest Deposit Group per Magic Wand Size
--Select the two deposit groups with the lowest average wand size.

SELECT TOP(2) w.DepositGroup
  FROM WizzardDeposits AS w
GROUP BY w.DepositGroup
ORDER BY AVG(w.MagicWandSize)

--Problem 05. Deposits Sum
--Select all deposit groups and their total deposit sums.

SELECT w.DepositGroup, SUM(w.DepositAmount) AS [TotalSum]
  FROM WizzardDeposits AS w
GROUP BY w.DepositGroup

--Problem 06. Deposits Sum for Ollivander Family
--Select all deposit groups and their total deposit sums but only for the wizards who have their magic wands crafted by Ollivander family.

SELECT w.DepositGroup, SUM(w.DepositAmount) AS [TotalSum]
  FROM WizzardDeposits AS w
 WHERE w.MagicWandCreator = 'Ollivander family'
GROUP BY w.DepositGroup

--Problem 07. Deposits Filter
--Select all deposit groups and their total deposit sums but only for the wizards who have their magic wands crafted by Ollivander family.
--Filter total deposit amounts lower than 150000. Order by total deposit amount in descending order.

SELECT w.DepositGroup, SUM(w.DepositAmount) AS [TotalSum]
  FROM WizzardDeposits AS w
 WHERE w.MagicWandCreator = 'Ollivander family'
GROUP BY w.DepositGroup
HAVING SUM(w.DepositAmount) <= 150000
ORDER BY SUM(w.DepositAmount) DESC

--Problem 08. Deposit Charge
--Create a query that selects: Deposit group, Magic wand creator, Minimum deposit charge for each group 
--Select the data in ascending ordered by MagicWandCreator and DepositGroup.

SELECT w.DepositGroup, w.MagicWandCreator, MIN(w.DepositCharge) AS [MinDepositCharge]
  FROM WizzardDeposits AS w
GROUP BY w.DepositGroup, w.MagicWandCreator
ORDER BY w.MagicWandCreator, w.DepositGroup

--Problem 09. Age Groups
--Write down a query that creates 7 different groups based on their age.
--Age groups should be as follows: [0-10], [11-20], [21-30], [31-40], [41-50], [51-60], [61+]
--The query should return: Age groups, Count of wizards in it

SELECT AgeGroup, COUNT(AgeGroup) AS WizardCount
  FROM
(SELECT
	CASE
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END AS [AgeGroup]
  FROM WizzardDeposits) AS newTable
GROUP BY AgeGroup
ORDER BY AgeGroup

--Problem 10. First Letter
--Write a query that returns all unique wizard first letters of their first names only if they have deposit of type Troll Chest.
--Order them alphabetically. Use GROUP BY for uniqueness.

SELECT LEFT(FirstName, 1) AS 'FirstLetter'
  FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
--ORDER BY FirstLetter

--Problem 11. Average Interest 
--Mr. Bodrog is highly interested in profitability.
--He wants to know the average interest of all deposit groups split by whether the deposit has expired or not.
--But that’s not all. He wants you to select deposits with start date after 01/01/1985.
--Order the data descending by Deposit Group and ascending by Expiration Flag.

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS 'AverageInterest'
  FROM WizzardDeposits
--WHERE DepositStartDate >= '1985-01-01'
  WHERE YEAR(DepositStartDate) >= 1985
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

--Problem 12. * Rich Wizard, Poor Wizard
--Mr. Bodrog definitely likes his werewolves more than you.
--This is your last chance to survive! Give him some data to play his favorite game Rich Wizard, Poor Wizard.
--The rules are simple: You compare the deposits of every wizard with the wizard after him.
--If a wizard is the last one in the database, simply ignore it.
--In the end you have to sum the difference between the deposits.
--At the end your query should return a single value: the SUM of all differences.

SELECT SUM(Difference) AS 'SumDifference'
FROM (
SELECT 
	Wiz1.FirstName AS [Host Wizzard], Wiz1.DepositAmount AS [Host Wizzard Deposit],
	Wiz2.FirstName AS [Guest Wizzard], Wiz2.DepositAmount AS [Guest Wizzard Deposit],
	Wiz1.DepositAmount - Wiz2.DepositAmount AS Difference
 FROM WizzardDeposits AS Wiz1
INNER JOIN WizzardDeposits AS Wiz2
ON Wiz1.Id = Wiz2.Id - 1) AS t

--Problem 13. Departments Total Salaries
--That’s it! You no longer work for Mr. Bodrog. You have decided to find a proper job as an analyst in SoftUni. 
--It’s not a surprise that you will use the SoftUni database.
--Things get more exciting here!
--Create a query that shows the total sum of salaries for each department. Order by DepartmentID.

USE SoftUni

SELECT DepartmentID, SUM(Salary) AS 'TotalSalary'
FROM Employees
GROUP BY DepartmentID

--Problem 14. Employees Minimum Salaries
--Select the minimum salary from the employees for departments with ID (2, 5, 7) but only for those hired after 01/01/2000.
--Your query should return:	DepartmentID

SELECT DepartmentID, MIN(Salary)
  FROM Employees
 WHERE DepartmentID IN (2, 5, 7)
GROUP BY DepartmentID

--Problem 15. Employees Average Salaries
--Select all employees who earn more than 30000 into a new table.
--Then delete all employees who have ManagerID = 42 (in the new table).
--Then increase the salaries of all employees with DepartmentID = 1 by 5000.
--Finally, select the average salaries in each department.

SELECT *
INTO EmployeesWithHighSalary
FROM Employees
WHERE Salary > 30000

DELETE FROM EmployeesWithHighSalary
WHERE ManagerID = 42

UPDATE EmployeesWithHighSalary
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary
FROM EmployeesWithHighSalary
GROUP BY DepartmentID

--Problem 16. Employees Maximum Salaries
--Find the max salary for each department. Filter those, which have max salaries NOT in the range 30000 – 70000.

SELECT DepartmentID, MAX(Salary) AS MaxSalary FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--Problem 17. Employees Count Salaries
--Count the salaries of all employees who don’t have a manager.

SELECT COUNT(Salary) AS [Count] FROM Employees
WHERE ManagerID IS NULL

--Problem 18. *3rd Highest Salary
--Find the third highest salary in each department if there is such.

SELECT a.DepartmentId,
(
	SELECT DISTINCT b.Salary FROM Employees AS b
	WHERE b.DepartmentID = a.DepartmentId
	ORDER BY Salary DESC
	OFFSET 2 ROWS
	FETCH NEXT 1 ROWS ONLY
) AS [ThirdHighestSalary]
FROM Employees AS a
WHERE (
	SELECT DISTINCT b.Salary FROM Employees AS b
	WHERE b.DepartmentID = a.DepartmentId
	ORDER BY Salary DESC
	OFFSET 2 ROWS
	FETCH NEXT 1 ROWS ONLY
) IS NOT NULL
GROUP BY a.DepartmentID

--Problem 19. **Salary Challenge
--Write a query that returns: FirstName, LastName, DepartmentID
--Select all employees who have salary higher than the average salary of their respective departments.
--Select only the first 10 rows. Order by DepartmentID.

SELECT TOP(10) FirstName, LastName, DepartmentID
FROM Employees AS e
WHERE Salary > (
	SELECT AVG(Salary) FROM Employees AS avgSalary
	WHERE avgSalary.DepartmentID = e.DepartmentID
	)
ORDER BY DepartmentID