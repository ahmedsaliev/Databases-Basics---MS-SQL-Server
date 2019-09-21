CREATE TABLE Users (
	Id BIGINT PRIMARY KEY IDENTITY,
	UserName VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX),
		CHECK(DATALENGTH(ProfilePicture) <= 921600),
	LastLoginTime DATETIME2,
	IsDeleted BIT NOT NULL
)

INSERT INTO Users(UserName, [Password], ProfilePicture, LastLoginTime, IsDeleted)
	VALUES
	('Pesho', '454fsdf', NULL, NULL, 0),
	('Gosho', 'hfhghf', NULL, NULL, 0),
	('Raya', '585hdsffh', NULL, NULL, 0),
	('Doly', 'gfdhrrc', NULL, NULL, 1),
	('Ivan', 'hhddfh', NULL, NULL, 1)