--Database Create With Propertise
USE master
DROP DATABASE IF EXISTS TouristAndHospitalityManagement
CREATE DATABASE TouristAndHospitalityManagement
GO
--===============================================
IF  NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'TouristAndHospitalityManagement')
    BEGIN
        CREATE DATABASE [TouristAndHospitalityManagement]
    END;
GO
--========================================
ALTER DATABASE TouristAndHospitalityManagement MODIFY FILE 
(NAME=N'TouristAndHospitalityManagement_DATA', Size=25MB, MaxSize=100MB, FileGrowth=5% )
GO
ALTER DATABASE TouristAndHospitalityManagement MODIFY FILE 
( NAME=N'TouristAndHospitalityManagement_LOG', Size = 10MB, MaxSize = 100MB, FileGrowth = 1MB)
GO
--==================================
CREATE DATABASE TouristAndHospitalityManagement
ON PRIMARY
(
Name='TouristAndHospitalityManagement_DATA',FileName='C:\Users\IDB_C#\TouristAndHospitalityManagement.mdf',Size=10mb,maxsize=100mb,FileGrowth=5%
)
LOG ON
(
Name='TouristAndHospitalityManagement_LOG',FileName='C:\Users\IDB_C#\TouristAndHospitalityManagement.ldf',Size=1mb,maxsize=10mb,FileGrowth=1%
)
GO
--Create Table
--==============================================================
USE TouristAndHospitalityManagement
CREATE TABLE TravelAgent
(
AgentID int primary key identity,
AgentName varchar(20) not null,
AgentAddress varchar(50) not null,
AgentPhoneNumber Char(15) Not Null  Check ((AgentPhoneNumber Like '[0][1][1-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]'))
)
GO

USE TouristAndHospitalityManagement
CREATE TABLE Transportation
(
TransportationID int primary key identity,
TransportationType varchar(20) not null,
TransportationHelpline Char(15) Not Null  Check ((TransportationHelpline Like '[0][1][1-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')),
)
Go

USE TouristAndHospitalityManagement
CREATE TABLE TourGuide
(
GuideID int primary key identity,
GuideName varchar(20) not null,
GuideAddress varchar(50),
GuidePhone Char(15) Not Null  Check ((GuidePhone Like '[0][1][1-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')),
GuideGender varchar(10)
)
GO

USE TouristAndHospitalityManagement
CREATE TABLE Hotel
(
HotelID int primary key identity,
HotelName varchar(20) SPARSE null,
HotelRoomType varchar(20) not null,
HotelAddress varchar(50) not null,
HotelPhoneNumber Char(15) Not Null  Check ((HotelPhoneNumber Like '[0][1][1-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]'))
)
GO

USE TouristAndHospitalityManagement
CREATE TABLE Package
(
PackageID int primary key identity,
PackageName varchar(20) not null,
PackageDuration nvarchar(10) not null,
PackagePrice money,
Vat as (PackagePrice*.15),
TotalCost as ((PackagePrice*.15)+PackagePrice),
AgentID int Foreign key references TravelAgent(AgentID),
TransportationID int Foreign key references Transportation(TransportationID),
HotelID int Foreign key references Hotel(HotelID)
)
GO

USE TouristAndHospitalityManagement
CREATE TABLE Tourist
(
TouristID int primary key identity,
TouristName varchar(20) not null,
TouristPhoneNumber Char(15) Not Null  Check ((TouristPhoneNumber Like '[0][1][1-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')),
TouristAddress varchar(20) not null,
TouristNidPassportNumber int,
Nationlity varchar(15) not null,
GuideID int Foreign key references TourGuide(GuideID) ON UPDATE CASCADE,
PackageID int Foreign key references Package(PackageID) ON DELETE CASCADE,
)
GO
--Alter table(Add and Delete)
ALTER TABLE TourGuide
ADD NID nvarchar(20);
GO
ALTER TABLE TourGuide
DROP COLUMN NID;
GO
--Temporary Table, Getdate, Default, Check
--======================================================
CREATE TABLE #Cheek
(
ID int identity ,
Address Varchar(30) CONSTRAINT CN_Defaultaddress DEFAULT ('UNKNOWN'),
Phone Char(15) Not Null  CHECK ((Phone Like '[0][1][1-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]' )),
DateInSystem DATE Not Null CONSTRAINT CN_dateinsystem DEFAULT (GETDATE())
)
GO
--Global Table
--==========================================================
CREATE TABLE ##Cheek2
(
ID int identity ,
Address Varchar(30) CONSTRAINT CN_Dfltaddress DEFAULT ('UNKNOWN'),
Phone Char(15) Not Null  CHECK ((Phone Like '[0][1][1-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]' )),
DateInSystem DATE Not Null CONSTRAINT CN_dateinmethod DEFAULT (GETDATE())
)
GO
--Clustered and Non-clustered index
--=========================================================
CREATE CLUSTERED INDEX CI_ID ON #Cheek(ID)
GO
CREATE NONCLUSTERED INDEX NCI_PN ON #Cheek(Phone)
GO
--============================
DROP TABLE #Cheek
GO
--============================
DROP TABLE ##Cheek2
GO
--Store Procedure
--=======================================
CREATE PROC spModifytravelagent
@agentid int,
@agentname varchar(20),
@agentaddress varchar(50),
@agentphonenumber char(15),
@tablename varchar(25),
@operationname varchar(25)
AS
BEGIN
	IF(@tablename='TravelAgent' AND @operationname='INSERT')
		BEGIN
			INSERT TravelAgent VALUES (@agentname,@agentaddress,@agentphonenumber)
		END
	IF(@tablename='TravelAgent' AND @operationname='UPDATE')
		BEGIN
			UPDATE TravelAgent SET AgentName=@agentname WHERE AgentID=@agentid
		END
	IF(@tablename='TravelAgent' AND @operationname='DELETE')
		BEGIN
			DELETE FROM TravelAgent WHERE AgentID=@agentid
		END
END
GO
--Create View 
--=======================================
Create View vw_TouristbyPackageID
AS
Select *
From Tourist
GO

Select * From vw_TouristbyPackageID
Where PackageID=2
GO
--VIEW vw_SchemaBind
--==============================
CREATE VIEW vw_SchemaBind
WITH SCHEMABINDING 
AS
SELECT TouristName as name, TotalCost as [Total]
FROM dbo.Tourist join dbo.Package
ON Tourist.TouristID=Package.PackageID
GO
--DROP VIEW vw_SchemaBind
SELECT * FROM vw_SchemaBind
GO
--Create View WITH ENCRYPTION 
--===================================================
CREATE VIEW vw_Tourist
WITH ENCRYPTION 
AS 
SELECT TouristID,TouristName,TouristPhoneNumber,Nationlity,GuideID,PackageID
FROM Tourist
Go

-- INSTEAD OF DELETE Trigger
CREATE TRIGGER trgInsteadOfDelete ON [dbo].[Package] 
INSTEAD OF DELETE
AS
	DECLARE @pkg_id int;
	DECLARE @pkg_name varchar(100);
	DECLARE @pkg_total int;
	
	SELECT @pkg_id=d.PackageID FROM deleted d;
	SELECT @pkg_name=d.PackageName FROM deleted d;
	SELECT @pkg_total=d.TotalCost FROM deleted d;

	BEGIN
		IF(@pkg_total>15000)
		BEGIN
			RAISERROR('Cannot delete where salary > 15000',16,1);
			ROLLBACK;
		END		
	END
GO
-- Try To Delete
DELETE FROM Package WHERE PackageID=2
SELECT * FROM Package
GO
--Scaler Function
--===============================================================
CREATE FUNCTION dbo.fn_TotalVat(@packageid int)
RETURNS int
AS
BEGIN
	RETURN
	(SELECT SUM(Vat) FROM Package WHERE PackageID=@packageid)
END
GO
PRINT dbo.fn_TotalVat(1)
GO
--Tabular Function
--====================================================================
CREATE FUNCTION dbo.fn_TableForNilachal(@pkg varchar(20))
RETURNS TABLE 
AS
RETURN
(SELECT Package.PackageID,Package.PackageName,Package.PackagePrice,Package.TotalCost
FROM Package
Join Tourist
ON Package.PackageID=Tourist.TouristID
WHERE PackageName=@pkg
)
GO
SELECT * FROM dbo.fn_TableForNilachal('Nilachal')
GO
--Operator
SELECT 91+9 AS [Sum]
GO
SELECT 109-9 AS [Substraction]
GO
SELECT 12*9 AS [Multiplication]
GO
SELECT 46/9 AS [Divide]
GO
SELECT 50%9 AS [Remainder]
GO
-- With Loop, If, Else and While
-------==================================
DECLARE @i int=5;
WHILE @i <=10
BEGIN
	IF @i%2=0
		BEGIN
			PRINT @i
		END
	ELSE
		BEGIN
			PRINT CAST(@i AS varchar) + ' Ignone'
		END
	SET @i=@i/2
	Break
END
GO
--Create Sequence
USE TouristAndHospitalityManagement
CREATE SEQUENCE sq_Thm
AS Bigint
START WITH 1 Increment BY 1 Minvalue 1 Maxvalue 99999
NO Cycle Cache 10
GO




























