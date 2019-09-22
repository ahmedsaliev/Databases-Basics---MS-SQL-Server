CREATE DATABASE Hotel

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName  NVARCHAR(50) NOT NULL,
	Title NVARCHAR(50),
	Notes TEXT
	)

CREATE TABLE Customers (
	AccountNumber INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	PhoneNumber NVARCHAR(20) NOT NULL,
	EmergencyName NVARCHAR(50),
	EmergencyNumber NVARCHAR(20),
	Notes TEXT)

CREATE TABLE RoomStatus (
	RoomStatus NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes TEXT)

CREATE TABLE RoomTypes (
	RoomType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes TEXT
	)

CREATE TABLE BedTypes (
	BedType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes TEXT
	)

CREATE TABLE Rooms (
	RoomNumber INT PRIMARY KEY NOT NULL,
	RoomType NVARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType),
	BedType NVARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType),
	Rate DECIMAL (6, 2) NOT NULL,
	RoomStatus BIT NOT NULL,
	Notes TEXT
	)

CREATE TABLE Payments (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	PaymentDate DATETIME NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	FirstDateOccupied DATETIME NOT NULL,
	LastDateOccupied DATETIME NOT NULL,
	TotalDays AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied),
	AmountCharged DECIMAL (6, 2),
	TaxRate DECIMAL (6, 2),
	TaxAmount AS AmountCharged * TaxRate,
	PaymentTotal AS AmountCharged + AmountCharged * TaxRate,
	Notes TEXT
	)

CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATE NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
	RateApplied DECIMAL(6, 2) NOT NULL,
	PhoneCharge DECIMAL(6, 2) NOT NULL,
	Notes TEXT
)

INSERT INTO Employees(FirstName, LastNAme) VALUES
	('Иво', 'Донев'),
	('Петър', 'Динков'),
	('Рая', 'Нешкова')

INSERT INTO Customers(FirstName, LastName, PhoneNumber) VALUES
	('Динко', 'Донев', '+359 888 666 555'),
	('Лили', 'Нейкова', '+359 666 333 111'),
	('Ради', 'Иванов', '+359 111 222 333')

INSERT INTO RoomStatus(RoomStatus) VALUES
	('заета'),
	('свободна'),
	('в ремонт')

INSERT INTO RoomTypes(RoomType) VALUES
	('single'),
	('double'),
	('appartment')

INSERT INTO BedTypes(BedType) VALUES
	('single'),
	('double'),
	('couch')

INSERT INTO Rooms(RoomNumber, RoomType, BedType, Rate, RoomStatus) VALUES
	(201, 'single', 'single', 40.0, 1),
	(205, 'double', 'double', 70.0, 0),
	(208, 'appartment', 'double', 110.0, 1)

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, AmountCharged, TaxRate) VALUES
	(1, '2011-11-25', 2, '2017-11-30', '2017-12-04', 250.0, 0.2),
	(3, '2014-06-03', 3, '2014-06-06', '2014-06-09', 340.0, 0.2),
	(3, '2016-02-25', 2, '2016-02-27', '2016-03-04', 500.0, 0.2)

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge) VALUES
	(2, '2011-02-04', 3, 205, 70.0, 12.54),
	(2, '2015-04-09', 1, 201, 40.0, 11.22),
	(3, '2012-06-08', 2, 208, 110.0, 10.05)