ALTER TABLE Users
DROP CONSTRAINT PK_CompositeIdUserName

ALTER TABLE Users
ADD CONSTRAINT PK_SetPrimaryKey
PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT UserNameLengthCheck
UNIQUE (UserName), CHECK(LEN(UserName) >= 3)

SELECT * FROM Users

--The user name is OK
INSERT INTO Users(UserName, [Password], ProfilePicture, IsDeleted) VALUES
('Trayan', '123=-0', NULL, 1)

--Short name is not accepted
INSERT INTO Users(UserName, [Password], ProfilePicture, IsDeleted) VALUES
('To', '123=-0', NULL, 1)

--The name is OK
INSERT INTO Users(UserName, [Password], ProfilePicture, IsDeleted) VALUES
('Tro', '123=-0', NULL, 1)

--Name is not unique
INSERT INTO Users(UserName, [Password], ProfilePicture, IsDeleted) VALUES
('Tro', '15478', NULL, 0)