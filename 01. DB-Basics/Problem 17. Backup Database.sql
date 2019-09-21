USE SoftUni;
GO

BACKUP DATABASE SoftUni
TO DISK = 'f:\softuni-backup.bak';
GO

USE master

DROP DATABASE SoftUni

RESTORE DATABASE SoftUni
  FROM DISK = 'f:\softuni-backup.bak';