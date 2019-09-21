CREATE DATABASE Movies

CREATE TABLE Directors (
	Id INT PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(50) NOT NULL,
	Notes TEXT
)

CREATE TABLE Genres (
	Id INT PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(30) NOT NULL UNIQUE,
	Notes TEXT
)

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(30) NOT NULL UNIQUE,
	Notes TEXT
)

CREATE TABLE Movies (
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(200) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear INT NOT NULL,
	[Length] TIME,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating DECIMAL(2, 1) NOT NULL,
	Notes TEXT
)

INSERT INTO Directors(DirectorName) VALUES
	('Steven Spielberg'),
	('Sir Ridley Scott'),
	('Martin Scorsese'),
	('Michael Mann'),
	('Antoine Fuqua')

INSERT INTO Genres VALUES
	('Action', NULL),
	('Drama', NULL),
	('Fantasy', NULL),
	('Thriller', NULL),
	('Mistery', NULL)

INSERT INTO Categories (CategoryName) VALUES
	('Animation'),
	('Adventure'),
	('Horror'),
	('Comedy'),
	('Superhero')

INSERT INTO Movies VALUES
('Captain America', 1, 1988, '1:22:00', 1, 5, 9.5, 'Superhero'),
('Mean Machine', 1, 1998, '1:40:00', 2, 4, 8.0, 'Prison'),
('Little Cow', 2, 2007, '1:35:55', 3, 3, 2.3, 'Agro'),
('Smoked Almonds', 5, 2013, '2:22:25', 4, 2, 7.8, 'Whiskey in the Jar'),
('I''m very mad!', 4, 2018, '1:30:02', 5, 1, 9.9, 'Rating 10 not supported')