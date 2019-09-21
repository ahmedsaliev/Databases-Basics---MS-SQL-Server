USE Minions
GO

CREATE TABLE People (
	Id BIGINT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY(MAX), CHECK(DATALENGTH(Picture) <= 2097152),
	Height DECIMAL(3, 2),
	[Weight] DECIMAL(5, 2),
	Gender CHAR(1) NOT NULL, CHECK(Gender = 'm' OR Gender = 'f'),
	BirthDate DATE NOT NULL,
	Biography NTEXT
)

INSERT INTO People([Name], Picture, Height, [Weight], Gender, BirthDate, Biography) VALUES
('Gesho', NULL, 1.75, 64.2, 'm', '1978-01-01', NULL),
('Lisa', NULL, 1.63, 46.2, 'f', '1986-12-11', NULL),
('Pino', NULL, 1.82, 72.0, 'm', '2000-07-09', NULL),
('Leya', NULL, 1.58, 51.36, 'f', '1995-11-13', NULL),
('Dodo', NULL, 1.90, 86, 'm', '2005-06-23', NULL)