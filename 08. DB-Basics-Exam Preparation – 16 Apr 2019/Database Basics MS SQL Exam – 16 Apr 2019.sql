--Section 1. DDL (30 pts)
--1. Database Design
CREATE DATABASE Airport

USE Airport

CREATE TABLE Planes (
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL,
	Seats INT NOT NULL,
	[Range] INT NOT NULL
)

CREATE TABLE Flights(
	Id INT PRIMARY KEY IDENTITY,
	DepartureTime DATETIME,
	ArrivalTime DATETIME,
	Origin VARCHAR(50) NOT NULL,
	Destination VARCHAR(50) NOT NULL,
	PlaneId INT FOREIGN KEY REFERENCES Planes(Id)
)

CREATE TABLE LuggageTypes (
	Id INT PRIMARY KEY IDENTITY,
	[Type] VARCHAR(30) NOT NULL
)

CREATE TABLE Passengers(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Age INT NOT NULL,
	Address VARCHAR(30) NOT NULL,
	PassportId CHAR(11) NOT NULL
)

CREATE TABLE Luggages(
	Id INT PRIMARY KEY IDENTITY,
	LuggageTypeId INT FOREIGN KEY REFERENCES LuggageTypes(Id),
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id)
)

CREATE TABLE Tickets(
	Id INT PRIMARY KEY IDENTITY,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id),
	FlightId INT FOREIGN KEY REFERENCES Flights(Id),
	LuggageId INT FOREIGN KEY REFERENCES Luggages(Id),
	Price DECIMAL(10, 2)
)

--Section 2. DML (10 pts)
--2. Insert

INSERT INTO Planes (Name, Seats, [Range]) VALUES
('Airbus 336', 112, 5132),
('Airbus 330', 432, 5325),
('Boeing 369', 231, 2355),
('Stelt 297', 254, 2143),
('Boeing 338', 165, 5111),
('Airbus 558', 387, 1342),
('Boeing 128', 345, 5541)

INSERT INTO LuggageTypes ([Type]) VALUES
('Crossbody Bag'),
('School Backpack'),
('Shoulder Bag')

--3. Update

UPDATE Tickets
SET Price *= 1.13
WHERE FlightId IN (
	SELECT Id FROM Flights
	WHERE Destination = 'Carlsbad')

--4. Delete

DELETE FROM Tickets
WHERE FlightId IN (
	SELECT Id FROM Flights
	WHERE Destination = 'Ayn Halagim')

DELETE FROM Flights
WHERE Destination = 'Ayn Halagim'


--Section 3. Querying (40 pts)
--5. The "Tr" Planes

SELECT * FROM Planes
WHERE Name LIKE '%tr%'
ORDER BY Id, Name, Seats, [Range]

--6. Flight Profits

SELECT * FROM Tickets
SELECT * FROM Planes
SELECT * FROM Passengers

SELECT f.Id AS [FlightId], SUM(t.Price) AS [Price]
FROM Flights AS f
JOIN Tickets AS t
ON f.Id = t.FlightId
GROUP BY f.Id
ORDER BY [Price] DESC, [FlightId]

--7. Passenger Trips
SELECT p.FirstName + ' ' + p.LastName AS [Full Name], f.Origin, f.Destination
FROM Passengers AS p
JOIN Tickets AS t
ON p.Id = t.PassengerId
JOIN Flights AS f
ON t.FlightId = f.Id
ORDER BY [Full Name], f.Origin, f.Destination

--8. Non Adventures People

--SELECT *
--FROM Passengers AS p
--LEFT OUTER JOIN Tickets AS t
--ON p.Id = t.PassengerId

SELECT p.FirstName, p.LastName, p.Age
FROM Passengers AS p
LEFT JOIN Tickets AS t
ON p.Id = t.PassengerId
WHERE t.PassengerId IS NULL
ORDER BY p.Age DESC, p.FirstName, p.LastName


--9. Full Info

SELECT
	p.FirstName + ' ' + p.LastName AS [Full Name],
	pl.Name AS [Plane Name],
	f.Origin + ' - ' + f.Destination AS [Trip],
	lt.[Type] AS [Luggage Type]
FROM Passengers AS p
JOIN Tickets AS t
ON p.Id = t.PassengerId
JOIN Flights AS f
ON f.Id = t.FlightId
JOIN Luggages AS l
ON t.LuggageId = l.Id
JOIN LuggageTypes AS lt
ON l.LuggageTypeId = lt.Id
JOIN Planes AS pl
ON f.PlaneId = pl.Id
ORDER BY [Full Name], [Plane Name], f.Origin, f.Destination, lt.[Type]


--10. PSP

SELECT 
	p.Name,
	p.Seats,
	COUNT(t.Id) AS [Passengers Count]
FROM Planes AS p
LEFT JOIN Flights AS f
ON p.Id = f.PlaneId
LEFT JOIN Tickets AS t
ON f.Id = t.FlightId
GROUP BY p.Name, p.Seats
ORDER BY [Passengers Count] DESC, p.Name, p.Seats


--Section 4. Programmability (20 pts)
--11. Vacation

CREATE FUNCTION udf_CalculateTickets(
	@origin VARCHAR(50),
	@destination VARCHAR(50),
	@peopleCount INT)
RETURNS VARCHAR(50)
AS
BEGIN
	IF (@peopleCount <= 0)
	BEGIN
		RETURN 'Invalid people count!';
	END

	DECLARE @flightId INT = (SELECT TOP (1) Id FROM Flights
	WHERE Origin = @origin AND Destination = @destination);

	IF (@flightId IS NULL)
	BEGIN
		RETURN 'Invalid flight!';
	END

	DECLARE @pricePerPerson DECIMAL(10, 2) =
	(SELECT TOP (1) Price FROM Tickets
		WHERE FlightId = @flightId);

	DECLARE @totalPrice DECIMAL(24, 2) = @pricePerPerson * @peopleCount;

	RETURN CONCAT('Total price ', @totalPrice);
END

SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', 33)
SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', -1)
SELECT dbo.udf_CalculateTickets('Invalid','Rancabolang', 33)

--12. Wrong Data
CREATE PROCEDURE usp_CancelFlights
AS
BEGIN
	UPDATE Flights
	SET DepartureTime = NULL, ArrivalTime = NULL
	WHERE DATEDIFF(SECOND, DepartureTime, ArrivalTime) > 0
END

EXEC usp_CancelFlights