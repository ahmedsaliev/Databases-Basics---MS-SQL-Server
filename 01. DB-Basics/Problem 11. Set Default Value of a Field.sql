ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime
DEFAULT GETDATE() FOR LastLoginTime

USE Minions
INSERT INTO Users (UserName, [Password], ProfilePicture, IsDeleted)	VALUES
	('Trendafil', 'abc123', NULL, 1)

SELECT * FROM Users