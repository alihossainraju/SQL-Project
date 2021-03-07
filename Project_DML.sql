USE TouristAndHospitalityManagement
GO
INSERT INTO TravelAgent 
		VALUES('ABCD','Dhaka','01703 133 361'),
		('EFGH','Chattogram','01879 978 899'),
		('IJKL','Sylhet','01559 482 152'),
		('MNOP','Borishal','01535 402 803'),
		('QRST','Cumilla','01831 103 214')
GO

INSERT INTO Transportation 
VALUES('AC BUS','01751 154 654'),
		('CAR','01751 654 852'),
		('TRAIN','01751 852 789'),
		('PLANE','01751 789 874'),
		('BOAT','01751 753 123')
GO

INSERT INTO TourGuide
VALUES('Iqbal','ctg','01854 456 258','Male'),
		('Arefin','dha','01854 456 258','Male'),
		('Puja','raj','01854 456 258','Female'),
		('Moin','joss','01854 456 258','Male'),
		('Srabonty','shy','01854 456 258','Male')
GO

INSERT INTO Hotel 
VALUES('Tajmahal','AC','Cox Bazar','01412 456 852'),
		('Pahar','AC','Rangamati','01412 789 852'),
		('VIP Resort','AC','Sylhet','01412 456 412'),
		('Hotel 5 Star','AC','Bandarban','01552 456 852'),
		('Hotel Agrabad','AC','Chattogram','01412 632 852')
GO

INSERT INTO Package
VALUES('Rangamati','7 Days',15000,2,2,2),
		('Cox Bazar','7 Days',20000,2,1,1),
		('Jaflong','7 Days',20000,3,3,3),
		('Nilachal','7 Days',25000,2,2,4),
		('CDA','7 Days',15000,2,4,5)
GO

INSERT INTO Tourist
VALUES('Iqbal Hossain','01552 564 123','Kornelhat',18512222,'Bangladeshi',2,2),
		('Ali Hossain','01652 564 123','Laksham',4566456,'Bangladeshi',1,4),
		('Shohid Afridi','01852 564 123','Lahor',2568545,'Pakistan',4,1),
		('Karina Kapor','01952 564 123','Mumbai',9642222,'India',5,3),
		('Sakira','01452 564 123','Johansburg',1585122,'South Africa',3,2)
GO

--========================================================
EXEC spModifytravelagent 6,'ASDF','Jossor','01625 456 159','TravelAgent','Insert'

EXEC spModifytravelagent 6,'ghjk','Rajshahi','01125 456 852','TravelAgent','Update'

EXEC spModifytravelagent  6,'ASDF','Jossor','01625 456 159','TravelAgent','Delete'

SELECT * FROM TravelAgent
GO

SELECT * FROM TravelAgent
SELECT * FROM Transportation
SELECT * FROM TourGuide
SELECT * FROM Hotel
SELECT * FROM Package
SELECT * FROM Tourist
GO
--Drop Table
DROP TABLE Transportation
GO
--Truncate Table
TRUNCATE TABLE TourGuide
GO
-- Basic Six Clauses
--====================================================================
SELECT PackageName,COUNT(PackageID) AS Pkg
FROM Package
WHERE PackageName='Nilachal'
GROUP BY PackageName
HAVING COUNT(PackageID)>1
ORDER BY PackageName DESC
GO

--Create Sub Query
--=======================================
SELECT Sum(Vat) AS TotalVat
FROM Package
WHERE Vat in(SELECT Vat FROM Package WHERE PackageID=2)
GO
--Cast and Convert
--==================================================
SELECT 'Today :'+ CAST(GETDATE() as varchar)
SELECT 'Today :'+ CONVERT(varchar,GETDATE())

SELECT 'Today :'+ CONVERT(varchar,GETDATE(),1)
SELECT 'Today :'+ CONVERT(varchar,GETDATE(),2)
GO
--CTE
--==============================================
WITH TravelAgent_CTE (AgentID,AgentName,AgentAddress)
AS
(
SELECT AgentID,AgentName,AgentAddress
FROM TravelAgent 
WHERE AgentID is Not null
)
SELECT * FROM TravelAgent_CTE
Go

--Left Outer Join
SELECT Tourist.TouristID,Tourist.TouristName,Tourist.TouristAddress,Package.PackageID,Package.PackageName,Package.PackagePrice,Package.Vat,Package.TotalCost
FROM Package
LEFT JOIN Tourist
ON Package.PackageID=Tourist.PackageID
GO

--Right Outer Join
SELECT Tourist.TouristID,Tourist.TouristName,Tourist.TouristAddress,Package.PackageID,Package.PackageName,Package.PackagePrice,Package.Vat,Package.TotalCost
From Package
RIGHT JOIN Tourist
ON Package.PackageID=Tourist.PackageID
GO

--Full Outer Join
SELECT Tourist.TouristID,Tourist.TouristName,Tourist.TouristAddress,Package.PackageID,Package.PackageName,Package.PackagePrice,Package.Vat,Package.TotalCost
FROM Package
FULL JOIN Tourist
ON Package.PackageID=Tourist.PackageID
GO

--Cross Join
SELECT Tourist.TouristID,Tourist.TouristName,Tourist.TouristAddress,Package.PackageID,Package.PackageName,Package.PackagePrice,Package.Vat,Package.TotalCost
FROM Package
CROSS JOIN Tourist
GO

--Self Join
SELECT TT.TouristID,T.PackageID,t.GuideID
FROM Tourist AS T,Tourist AS TT
WHERE T.TouristID<>TT.TouristID
GO

--Union
SELECT TouristID AS TSID FROM Tourist
UNION 
SELECT PackageID AS PKGID FROM Package
GO

--Union All
SELECT TouristID AS TSID FROM Tourist
UNION All
SELECT PackageID AS PKGID FROM Package
GO

--Distinct
SELECT DISTINCT TouristID,TouristName,TouristAddress,TouristPhoneNumber,TouristNidPassportNumber
FROM Tourist
GO

--WildCard
CREATE VIEW vw_tourist
AS
SELECT *
FROM Tourist
WHERE TouristName Like 'Sak___%'
Or TouristName Like 'Ali _____in%'
With Check Option;
GO
SELECT * FROM vw_tourist

SELECT * FROM Tourist
WHERE TouristName LIKE '[!Iqb]%';

SELECT * FROM Tourist
WHERE TouristName LIKE 'S_k_ra';

--Cube, Rollup, Grouping Set
SELECT PackageID,HotelID,SUM(AgentID) AS Course
FROM Package
GROUP BY PackageID,HotelID WITH CUBE
GO

SELECT PackageID,HotelID, SUM(HotelID) AS Course
FROM Package
GROUP BY PackageID,HotelID WITH ROLLUP
GO

SELECT PackageID,SUM(HotelID) AS Course
FROM Package
GROUP BY GROUPING SETS(
(PackageID,HotelID),
(PackageID)
)
GO
--While Loop
DECLARE @a int
SET @a=5
WHILE @a<=10
BEGIN
		PRINT 'Your Provided Value : ' + CAST(@a as Varchar)
		SET @a=@a+1
END
GO

--Case
SELECT PackageID, PackagePrice,
	CASE
	WHEN PackagePrice >20000 THEN 'The Package in Greater then 20000'
	WHEN PackagePrice=20000 THEN 'The Package is 20000'
	ELSE 'The Package in Under then 20000'
END	AS PackageText 
FROM Package
GO

--Aggregate function
SELECT COUNT (*) FROM Package
SELECT AVG (PackagePrice) FROM Package
SELECT MIN (PackagePrice) FROM Package
SELECT MAX (PackagePrice) FROM Package

--Transection
BEGIN TRAN
DELETE FROM TravelAgent
WHERE AgentID=4
GO

BEGIN TRAN
INSERT INTO TravelAgent VALUES('Tran','USA','01475 369 784')
GO

ROLLBACK TRAN;
GO

BEGIN TRAN
DELETE FROM TravelAgent
WHERE AgentID=4
COMMIT TRAN
GO
--Round,Ceiling,Floor
DECLARE @value int;
SET @value= -10;
SELECT ROUND (@value,2);
SELECT CEILING (@value);
SELECT FLOOR (@value);
GO
--Throw statement
--==============================================
BEGIN TRY
    INSERT INTO TravelAgent(AgentID) VALUES(1);
    --  cause error
    INSERT INTO TravelAgent(AgentID) VALUES(1);
END TRY
BEGIN CATCH
    PRINT('Raise the caught error again');
    THROW;
END CATCH
GO

















