USE SoftUni

SELECT e.DepartmentID, SUM(e.Salary) AS TotalSalary
  FROM Employees AS e
GROUP BY e.DepartmentID
ORDER BY e.DepartmentID

SELECT e.DepartmentID, MIN(e.Salary) AS MinSalary
FROM Employees AS e
GROUP BY e.DepartmentID

SELECT e.DepartmentID, COUNT(e.Salary) AS SalaryCount
FROM Employees AS e
GROUP BY e.DepartmentID

SELECT e.DepartmentID, MAX(e.Salary) AS MaxSalary
FROM Employees AS e
GROUP BY e.DepartmentID

SELECT e.DepartmentID, MIN(e.Salary) AS MinSalary
FROM Employees AS e
GROUP BY e.DepartmentID

SELECT e.DepartmentID, AVG(e.Salary) AS AvgSalary
FROM Employees AS e
GROUP BY e.DepartmentID

