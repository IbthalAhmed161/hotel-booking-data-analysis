CREATE DATABASE hotel;

--========================================================================================
--creates tables
--========================================================================================

CREATE TABLE Guest (
    guestID INT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(100) unique,
	city varchar(30),
	gender bit,
	n_id BIGINT UNIQUE NOT NULL,
	age int,
	no_companios int

);

CREATE TABLE RoomType (
    RoomTypeID INT PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL , --NVARCHAR: Translation of multiple languages ​​(such as Arabic and English)
    NightlyRate DECIMAL(10,2)NOT NULL,
    capacity INT NOT NULL
);



CREATE TABLE Room (
    RoomID INT PRIMARY KEY,
    RoomNumber INT NOT NULL,
	FloorNumber int NOT NULL,
    RoomTypeID INT,
    Status VARCHAR(15),
	constraint CK_Room_Status
	CHECK (Status IN ('Available','Occupied','Maintenance')),

    FOREIGN KEY (RoomTypeID)
    REFERENCES RoomType(RoomTypeID)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(50)NOT NULL,
    salary int NOT NULL,
	HireDate date NOT NULL
);


CREATE TABLE Reservation (
    ReservationID INT PRIMARY KEY,
    GuestID INT,
    RoomID INT,
	StaffID INT,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
	status varchar(20),
	CancellationReason varchar(200),
	   
	constraint  CK_Reservation_Status
	CHECK (status IN ('Booked','CheckedIn','CheckedOut','Cancelled')),

    FOREIGN KEY (guestID)
    REFERENCES Guest(guestID)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,

    FOREIGN KEY (RoomID)
    REFERENCES Room(RoomID)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	
	FOREIGN KEY (StaffID)
    REFERENCES Staff(StaffID)
	ON DELETE NO ACTION 
	ON UPDATE NO ACTION
);


CREATE TABLE Service (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100),
    Price DECIMAL(10,2) NOT NULL
);




CREATE TABLE ServiceUsage (
    UsageID INT PRIMARY KEY,
    ReservationID INT,
    ServiceID INT,
    Quantity INT NOT NULL,
    UsageDate DATE,

    FOREIGN KEY (ReservationID)
    REFERENCES Reservation(ReservationID)
	ON DELETE NO ACTION 
	ON UPDATE NO ACTION,

    FOREIGN KEY (ServiceID)
    REFERENCES Service(ServiceID)
	ON DELETE NO ACTION 
	ON UPDATE NO ACTION
);


CREATE TABLE Invoice (
    InvoiceID INT PRIMARY KEY,
    ReservationID INT,
	DiscountAmount DECIMAL(10,2),
    TotalAmount DECIMAL(10,2) NOT NULL,
	NetAmount DECIMAL(10,2),
	Status varchar(15),
    InvoiceDate DATE,

	constraint FK_Invoice_Status
	CHECK (Status IN ('Paid','Unpaid','Partial')),

    FOREIGN KEY (ReservationID)
    REFERENCES Reservation(ReservationID)
	ON DELETE NO ACTION  
	ON UPDATE NO ACTION
);


CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    InvoiceID INT,
	StaffID INT,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50),
	PaymentStatus VARCHAR(50),

	constraint CK_Payment_Method
	CHECK (PaymentMethod IN ('Cash','Card','Online','Company')),
	constraint CK_Payment_Status
	CHECK (PaymentStatus IN ('Success','Failed','Refunded')),

    FOREIGN KEY (InvoiceID)
    REFERENCES Invoice(InvoiceID)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,

	FOREIGN KEY (StaffID)
    REFERENCES Staff(StaffID)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);





CREATE TABLE HousekeepingLog (
    LogID INT PRIMARY KEY,
    RoomID INT,
    StaffID INT,
    CleanDate DATE NOT NULL,
    status VARCHAR(10),
	StartTime DATETIME NOT NULL,
	EndTime DATETIME NOT NULL,

	constraint CK_Housekeeping_Status
	CHECK (status IN ('Completed','Late')),

    FOREIGN KEY (RoomID)
    REFERENCES Room(RoomID)
	ON DELETE NO ACTION
	ON UPDATE CASCADE,

    FOREIGN KEY (StaffID)
    REFERENCES Staff(StaffID)
	ON DELETE CASCADE 
	ON UPDATE CASCADE
);
--============================================================
--INSERT Valus into Tables by using three types of inserting
--============================================================

-------------------------
--RoomType(basic insert)
-------------------------
INSERT INTO RoomType (RoomTypeID,TypeName, NightlyRate, capacity)
VALUES
(1,'Single',80,1),
(2,'Double',120,2),
(3,'Triple',160,3),
(4,'Suite',300,4);

-------------------------
--Service(basic insert)
-------------------------
INSERT INTO Service (ServiceID,ServiceName, Price)
VALUES
(1,'Breakfast',10),
(2,'Room Service',20),
(3,'Laundry',15),
(4,'Spa',50),
(5,'Airport Pickup',40);

----------------------------------------------------------
--Staff(create and insert data inside the SQL by loops)
----------------------------------------------------------

DECLARE @i INT = 1

WHILE @i <= 50
BEGIN

INSERT INTO Staff(StaffID, name, role, salary, HireDate)
VALUES(
@i,
'Staff_' + CAST(@i AS VARCHAR),
CASE 
WHEN @i % 3 = 0 THEN 'Receptionist'
WHEN @i % 3 = 1 THEN 'Manager'
ELSE 'Housekeeping'
END,
4000 + (@i * 100),
DATEADD(DAY, -@i * 10, GETDATE())
)

SET @i = @i + 1
END;

--*****************************************************************************************************************
--the rest of tables create data by python Fake function for create many data in csv and insert by (BULK INSERT)
--*****************************************************************************************************************

--------------------
-- Guest (500 rows)
--------------------

BULK INSERT Guest
FROM 'C:\Temp\Guest.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
);

--------------------
-- Room (200 rows)
--------------------

BULK INSERT Room
FROM 'C:\Temp\Room.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
);

----------------------------
-- Reservation (1000 rows)
----------------------------

BULK INSERT Reservation
FROM 'C:\Temp\Reservation.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
);

----------------------------
-- ServiceUsage (1528 rows)
----------------------------

BULK INSERT ServiceUsage
FROM 'C:\Temp\ServiceUsage.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2
);

----------------------
-- Invoice (267 rows)
----------------------

bulk insert Invoice
from 'C:\Temp\invoice.csv'
with(fieldterminator=',', rowterminator= '\n', firstrow=2);

----------------------
-- Payment (267 rows)
----------------------

bulk insert Payment
from 'C:\Temp\payment.csv'
with(fieldterminator=',', rowterminator= '\n', firstrow=2);

------------------------------
-- HousekeepingLog (400 rows)
------------------------------

bulk insert HousekeepingLog
from 'C:\Temp\HousekeepingLog.csv'
with(fieldterminator=',', rowterminator= '\n', firstrow=2);

/*
=========================================================================================
 Explor Data Analysis
=========================================================================================
*/

-- show tables
select * from Guest; 
select * from Reservation;
select * from Room;
select * from RoomType;
select * from Service;
select * from ServiceUsage;
select * from Payment;
select * from Staff;
select * from Invoice;
select * from HousekeepingLog; -- is it all staff work for cleaning room? ...lol

select distinct StaffID from HousekeepingLog; --yes it's

/* data cleaning :
                  to fixed it makes all frist 50 rows Housekeeping*/


--UPDATE Staff by made all 50 work as Housekeeping

UPDATE Staff
SET role = 'Housekeeping';

--to insure 
SELECT role, COUNT(*) as no_of_worker
FROM Staff
GROUP BY role;

--install the set of role

DECLARE @i INT = 51

WHILE @i <= 150
BEGIN

INSERT INTO Staff (StaffID, name, role, salary, HireDate)
VALUES(
@i,
'Staff_' + CAST(@i AS VARCHAR),

CASE
WHEN @i % 3 = 0 THEN 'Admin'
WHEN @i % 3 = 1 THEN 'Reception'
ELSE 'Billing'
END,

5000 + (@i * 120),

DATEADD(DAY, -@i * 5, GETDATE())
)

SET @i = @i + 1
END;
--to insure
SELECT role, COUNT(*) as no_of_staff
FROM Staff
GROUP BY role

--UPDATE table Reservation to made staff Reception work in this table 


UPDATE Reservation
SET StaffID = (
    SELECT StaffID
    FROM (
        SELECT StaffID,
               ROW_NUMBER() OVER (ORDER BY StaffID) AS rn
        FROM Staff
        WHERE Role = 'Reception'
    ) s
    WHERE s.rn = (Reservation.ReservationID % 
                 (SELECT COUNT(*) FROM Staff WHERE Role='Reception')) + 1
);


--  to insure
SELECT StaffID, COUNT(*) AS ReservationsCount
FROM Reservation
GROUP BY StaffID
ORDER BY ReservationsCount DESC;


--UPDATE table Payment to made staff Billing work in this table 
UPDATE Payment
SET StaffID = (
    SELECT StaffID
    FROM (
        SELECT StaffID,
               ROW_NUMBER() OVER (ORDER BY StaffID) AS rn
        FROM Staff
        WHERE Role = 'Billing'
    ) s
    WHERE s.rn = (Payment.PaymentID % 
                 (SELECT COUNT(*) FROM Staff WHERE Role='Billing')) + 1
);
--
SELECT StaffID, COUNT(*) AS PaymentCount
FROM Payment
GROUP BY StaffID
ORDER BY PaymentCount DESC;
-- con. EDA


-- COUNT Rows
SELECT COUNT(*) AS NO_OF_ROW_Guest FROM Guest;
SELECT COUNT(*) AS NO_OF_ROW_Reservation FROM Reservation;
SELECT COUNT(*) AS NO_OF_ROW_Room FROM Room;
SELECT COUNT(*) AS NO_OF_ROW_RoomType FROM RoomType;
SELECT COUNT(*) AS NO_OF_ROW_ServiceUsage FROM ServiceUsage;
SELECT COUNT(*) AS NO_OF_ROW_Payment FROM Payment;
SELECT COUNT(*) AS NO_OF_ROW_Staff FROM Staff;
SELECT COUNT(*) AS NO_OF_ROW_HousekeepingLog FROM HousekeepingLog;
SELECT COUNT(*) AS NO_OF_ROW_Invoice FROM Invoice;
SELECT COUNT(*) AS NO_OF_ROW_Service FROM Service;

-- SHOW SAMPLE FRISR 10 ROWS
SELECT TOP 10 * FROM Guest;
SELECT TOP 10 * FROM Reservation;
SELECT TOP 10 * FROM Room;
SELECT TOP 10 * FROM RoomType;
SELECT TOP 10 * FROM ServiceUsage;
SELECT TOP 10 * FROM Payment;
SELECT TOP 10 * FROM Staff;
SELECT TOP 10 * FROM HousekeepingLog;
SELECT TOP 10 * FROM Invoice;
SELECT TOP 10 * FROM Service;

--Missing Values
SELECT *
FROM Guest
WHERE email IS NULL;

SELECT *
FROM Reservation
WHERE CheckOutDate IS NULL;
-------------------
--Guest Analysis
-------------------
--no. of guest accourding to the city
SELECT city, COUNT(*) AS GuestCount
FROM Guest
GROUP BY city
ORDER BY GuestCount DESC;

--Gender Analysis
SELECT 
CASE 
WHEN gender = 1 THEN 'Male'
WHEN gender = 0 THEN 'Female'
END AS Gender,
COUNT(*) AS Count
FROM Guest
GROUP BY gender;

-- Age Analysis
SELECT 
AVG(age) AS AvgAge,
MIN(age) AS Youngest,
MAX(age) AS Oldest
FROM Guest;

-------------------
--Room Analysis
-------------------
-- no. of rooms accourding to the type
SELECT 
rt.TypeName,
COUNT(r.RoomID) AS TotalRooms
FROM Room r
JOIN RoomType rt
ON r.RoomTypeID = rt.RoomTypeID
GROUP BY rt.TypeName;

-- room's status
SELECT Status, COUNT(*) AS Total
FROM Room
GROUP BY Status;

-----------------------
--Reservation Analysis
-----------------------
-- no. of reservations accourding to the status
SELECT status, COUNT(*) AS Total
FROM Reservation
GROUP BY status;

--Length of stay
SELECT 
ReservationID,
DATEDIFF(day, CheckInDate, CheckOutDate) AS NightsStayed
FROM Reservation;

--Average' length of stay
SELECT  
AVG(DATEDIFF(day, CheckInDate, CheckOutDate)) AS AvgStay
FROM Reservation
WHERE CheckOutDate IS NOT NULL;

-------------------
--Revenue Analysis
-------------------
--total Revenue

SELECT SUM(NetAmount) AS TotalRevenue
FROM Invoice;
-- per month Revenue
SELECT 
YEAR(InvoiceDate) AS Year,
MONTH(InvoiceDate) AS Month,
SUM(NetAmount) AS MonthlyRevenue
FROM Invoice
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year, Month;

-------------------
--Service Analysis
-------------------
-- the most service use
SELECT 
s.ServiceName,
SUM(su.Quantity) AS TotalUsage
FROM ServiceUsage su
JOIN Service s
ON su.ServiceID = s.ServiceID
GROUP BY s.ServiceName
ORDER BY TotalUsage DESC;
-- revenue from those service
SELECT 
s.ServiceName,
SUM(su.Quantity * s.Price) AS ServiceRevenue
FROM ServiceUsage su
JOIN Service s
ON su.ServiceID = s.ServiceID
GROUP BY s.ServiceName
ORDER BY ServiceRevenue DESC;

-------------------
--Payment Analysis
-------------------
-- the most payment method used
SELECT 
PaymentMethod,
COUNT(*) AS TotalPayments
FROM Payment
GROUP BY PaymentMethod;

--total payment
-- completed 
SELECT SUM(Amount) AS TotalPaid
FROM Payment
WHERE PaymentStatus = 'Success';
--Failed
SELECT SUM(Amount) AS TotalPaid
FROM Payment
WHERE PaymentStatus = 'Failed';
--Refunded
SELECT SUM(Amount) AS TotalPaid
FROM Payment
WHERE PaymentStatus = 'Refunded';

-------------------
--Top Guests
-------------------
SELECT 
g.name,
SUM(i.NetAmount) AS TotalSpent
FROM Guest g
JOIN Reservation r ON g.guestID = r.GuestID
JOIN Invoice i ON r.ReservationID = i.ReservationID
GROUP BY g.name
ORDER BY TotalSpent DESC;
--or
SELECT name,
(
SELECT SUM(NetAmount)
FROM Invoice
JOIN Reservation 
ON Invoice.ReservationID = Reservation.ReservationID
WHERE Reservation.GuestID = Guest.guestID
) AS TotalSpent
FROM Guest;

--top 10
SELECT TOP 10 g.name,
SUM(i.NetAmount) AS TotalSpent
FROM Guest g
JOIN Reservation r ON g.guestID = r.GuestID
JOIN Invoice i ON r.ReservationID = i.ReservationID
GROUP BY g.name
ORDER BY TotalSpent DESC;

-------------------
--Occupancy Rate
-------------------
SELECT 
COUNT(DISTINCT RoomID) AS OccupiedRooms
FROM Reservation
WHERE status = 'CheckedIn';
------------------
--HousekeepingLog
------------------
-- best employee

select distinct StaffID, count(StaffID) as no_of_cleaning
				from HousekeepingLog
				group by StaffID
				order by no_of_cleaning desc;

--=========================================================================
-- Answer the Owenr's Questions (Statements / Views)
--=========================================================================

--Q1  Guest Master View
-- CREAT TABLE VIWE

CREATE VIEW vw_GuestMaster AS
SELECT
    g.guestID,
    g.name                                   AS FullName,
    g.n_id                                   AS NationalID,
    g.phone                                  AS Phone,
    g.email                                  AS Email,
    g.city                                   AS City,

    -- count only completed stays
    COUNT(DISTINCT CASE WHEN r.status = 'CheckedOut'
               THEN r.ReservationID END)   AS TotalStays,

    -- sum only amounts tied to paid invoices
    COALESCE(SUM(CASE WHEN i.Status = 'Paid'
               THEN p.Amount END), 0)       AS LifetimeSpend

FROM       Guest       g
LEFT JOIN Reservation r  ON r.GuestID     = g.GuestID
LEFT JOIN Invoice      i  ON i.ReservationID = r.ReservationID
LEFT JOIN Payment      p  ON p.InvoiceID    = i.InvoiceID

GROUP BY
    g.GuestID, g.name, g.n_id,
    g.phone, g.email, g.city;

--SHOW TOP 20 loyal customers
SELECT TOP 20 *
FROM vw_GuestMaster
Where LifetimeSpend !=0
ORDER BY TotalStays DESC;
--SHOW TOP 20 high-value (VIP customers)
SELECT TOP 20 *
FROM vw_GuestMaster
ORDER BY LifetimeSpend DESC;


--Q2  Room Availability View (By Date)

CREATE VIEW vw_RoomAvailability AS
SELECT 
r.RoomID,
r.RoomNumber,


rt.TypeName AS RoomType,
rt.NightlyRate,

res.ReservationID,
res.CheckInDate,
res.CheckOutDate

FROM Room r

JOIN RoomType rt
ON r.RoomTypeID = rt.RoomTypeID

LEFT JOIN Reservation res
ON r.RoomID = res.RoomID;

-- room availabil between '2026-07-01' and '2026-07-05'
DECLARE @StartDate DATE = '2026-07-01';
DECLARE @EndDate DATE = '2026-07-05';

SELECT DISTINCT
RoomID,
RoomNumber,
RoomType,
NightlyRate,
'Available' AS AvailabilityStatus

FROM vw_RoomAvailability

WHERE RoomID NOT IN
(
SELECT RoomID
FROM vw_RoomAvailability
WHERE CheckInDate <= @EndDate
AND CheckOutDate >= @StartDate
);

--Q3  Daily Occupancy Rate

DECLARE @StartDate DATE = '2025-05-24';
DECLARE @EndDate DATE = '2026-01-07';

WITH Dates AS (
    SELECT @StartDate AS StayDate
    UNION ALL
    SELECT DATEADD(DAY,1,StayDate)
    FROM Dates
    WHERE StayDate < @EndDate
)

SELECT 
d.StayDate AS Date,

(SELECT COUNT(*) FROM Room) AS TotalRooms,

COUNT(DISTINCT r.RoomID) AS OccupiedRooms,

CAST(
COUNT(DISTINCT r.RoomID) * 100.0 /
(SELECT COUNT(*) FROM Room)
AS DECIMAL(5,2)
) AS OccupancyRate

FROM Dates d

LEFT JOIN Reservation r
ON d.StayDate >= r.CheckInDate
AND d.StayDate < r.CheckOutDate

GROUP BY d.StayDate
ORDER BY d.StayDate

OPTION (MAXRECURSION 1000);


--Q4  Reservation Details View

--Create the view
CREATE VIEW vw_ReservationDetails AS
SELECT
    r.ReservationID,


    g.name                                        AS GuestName,

    ro.RoomNumber,

    rt.TypeName                                   AS RoomType,

    r.CheckInDate,
    r.CheckOutDate,

    -- number of nights between check-in and check-out
    DATEDIFF(DAY, r.CheckInDate, r.CheckOutDate)  AS Nights,

    r.status                                      AS ReservationStatus,

    -- total room charge = nights × nightly rate
    DATEDIFF(DAY, r.CheckInDate, r.CheckOutDate)
        * rt.NightlyRate                          AS TotalRoomCharge

FROM      Reservation  r
JOIN     Guest        g   ON g.GuestID    = r.GuestID
JOIN     Room         ro  ON ro.RoomID    = r.RoomID
JOIN     RoomType     rt  ON rt.RoomTypeID = ro.RoomTypeID;


--Sample queries on the view
-- All reservations (latest first)
SELECT * FROM vw_ReservationDetails
ORDER BY CheckInDate DESC;

-- Only Booked reservations
SELECT * FROM vw_ReservationDetails
WHERE  ReservationStatus = 'Booked'
ORDER BY CheckInDate;

-- Reservations for a specific guest
SELECT * FROM vw_ReservationDetails
WHERE  GuestName LIKE '%Jeremy%'
--actul stay and Checkedout
SELECT RoomType, sum(TotalRoomCharge) as TotalRoomCharge
FROM vw_ReservationDetails
where ReservationStatus = 'Checkedout'
group by RoomType
order by TotalRoomCharge desc;


--Q5  Cancellation Analysis  

--Part 1 — Cancellation rate by month
SELECT
    FORMAT(CheckInDate, 'yyyy-MM')         AS YearMonth,
    COUNT(*)                               AS TotalReservations,

    SUM(CASE WHEN status = 'Cancelled'
             THEN 1 ELSE 0 END)          AS CancelledReservations,

    CAST(
        100.0
        * SUM(CASE WHEN status = 'Cancelled'
                   THEN 1.0 ELSE 0 END)
        / COUNT(*)
    AS DECIMAL(5,2))                       AS CancellationRate

FROM  Reservation
GROUP BY FORMAT(CheckInDate, 'yyyy-MM')
ORDER BY YearMonth;
--Part 2 — Top 5 cancellation reasons
SELECT TOP 5
    -- normalise blanks / NULLs into one readable label
    COALESCE(NULLIF(TRIM(CancellationReason), ''), 'No reason provided') AS Cancellation_Reason,

    COUNT(*)                                    AS TotalCancellations,

        CAST(
        100.0
        * SUM(CASE WHEN status = 'Cancelled'
                   THEN 1.0 ELSE 0 END)
        / COUNT(*)
    AS DECIMAL(5,2))                              AS ShareOfCancellations

FROM  Reservation
WHERE status = 'Cancelled'
GROUP BY COALESCE(NULLIF(TRIM(CancellationReason), ''), 'No reason provided')
    
ORDER BY TotalCancellations DESC;



--Q6  Services Revenue View (Room Service / Laundry / Spa)

CREATE VIEW vw_ServiceRevenue AS
SELECT 

s.ServiceName,

FORMAT(su.UsageDate,'yyyy-MM') AS YearMonth,

COUNT(*) AS TotalUsageCount,

ISNULL(SUM(su.Quantity * s.Price),0) AS TotalServiceRevenue

FROM ServiceUsage su

JOIN Service s
ON su.ServiceID = s.ServiceID

GROUP BY 
s.ServiceName,
FORMAT(su.UsageDate,'yyyy-MM');

--SHOW
SELECT 
ServiceName,
SUM(TotalServiceRevenue) AS RevenueFromService

FROM vw_ServiceRevenue

WHERE YearMonth >= FORMAT(DATEADD(MONTH,-3,GETDATE()),'yyyy-MM')

GROUP BY ServiceName

ORDER BY RevenueFromService DESC;

--Q7  Invoice Aging & Outstanding Balances View

CREATE VIEW vw_InvoiceAging AS
SELECT 

i.InvoiceID,

g.name AS GuestName,

i.InvoiceDate,

i.TotalAmount,

-- مجموع المدفوعات
ISNULL(SUM(p.Amount), 0) AS PaidAmount,

-- المتبقي
i.TotalAmount - ISNULL(SUM(p.Amount), 0) AS OutstandingAmount,

-- Aging Bucket
CASE 
    WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) BETWEEN 0 AND 7 THEN '0-7'
    WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) BETWEEN 8 AND 30 THEN '8-30'
    WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) BETWEEN 31 AND 60 THEN '31-60'
    ELSE '60+'
END AS AgingBucket

FROM Invoice i

JOIN Reservation r 
ON i.ReservationID = r.ReservationID

JOIN Guest g 
ON r.GuestID = g.GuestID

LEFT JOIN Payment p 
ON i.InvoiceID = p.InvoiceID

GROUP BY 
i.InvoiceID,
g.name,
i.InvoiceDate,
i.TotalAmount;

--show table
select * from vw_InvoiceAging;
--Q8  Payment Method Breakdown
SELECT 

FORMAT(PaymentDate, 'yyyy-MM') AS YearMonth,

-- إجمالي المدفوع
SUM(CASE 
        WHEN PaymentStatus = 'Success' THEN Amount 
        ELSE 0 
    END) AS TotalPaid,

-- حسب طريقة الدفع
SUM(CASE 
        WHEN PaymentMethod = 'Cash' AND PaymentStatus = 'Success' THEN Amount 
        ELSE 0 
    END) AS PaidByCash,

SUM(CASE 
        WHEN PaymentMethod = 'Card' AND PaymentStatus = 'Success' THEN Amount 
        ELSE 0 
    END) AS PaidByCard,

SUM(CASE 
        WHEN PaymentMethod = 'Online' AND PaymentStatus = 'Success' THEN Amount 
        ELSE 0 
    END) AS PaidOnline,

SUM(CASE 
        WHEN PaymentMethod = 'Company' AND PaymentStatus = 'Success' THEN Amount 
        ELSE 0 
    END) AS PaidByCompany,

-- عدد العمليات الفاشلة / المرتجعة
COUNT(CASE 
        WHEN PaymentStatus = 'Failed' THEN 1 
    END) AS FailedCount,

COUNT(CASE 
        WHEN PaymentStatus = 'Refunded' THEN 1 
    END) AS RefundedCount

FROM Payment

GROUP BY FORMAT(PaymentDate, 'yyyy-MM')

ORDER BY YearMonth;



--Q9  Housekeeping & Room Turnover Report
CREATE VIEW vw_HousekeepingPerformance AS
SELECT 

h.RoomID,
h.StaffID,
COUNT(*) AS CleaningCount_Last30Days,

AVG(
    DATEDIFF(MINUTE, h.StartTime, h.EndTime)
) AS AvgCleaningTime_Minutes,


SUM(
    CASE 
        WHEN CAST(h.EndTime AS TIME) > '18:00:00' THEN 1
        ELSE 0
    END
) AS LateCleaningsCount,

SUM(
    CASE 
        WHEN DATEDIFF(MINUTE, StartTime, EndTime) > 40 THEN 1
        ELSE 0
    END
) AS LongCleanings

FROM HousekeepingLog h

WHERE h.CleanDate >= DATEADD(DAY, -30, 2026-3-16)

GROUP BY h.RoomID,
		h.StaffID;


drop view vw_HousekeepingPerformance
--show
SELECT *
		
FROM vw_HousekeepingPerformance

ORDER BY CleaningCount_Last30Days DESC
;

--Q10  Staff Performance View (Reception / Billing)

CREATE VIEW vw_StaffPerformance AS
SELECT 

s.StaffID,
s.name AS StaffName,
s.Role,

-- no. of Reservation occur
COUNT(DISTINCT r.ReservationID) AS ReservationsHandled,

-- Check-ins
SUM(CASE 
        WHEN r.Status = 'CheckedIn' THEN 1 
        ELSE 0 
    END) AS CheckInsProcessed,

-- Check-outs
SUM(CASE 
        WHEN r.Status = 'CheckedOut' THEN 1 
        ELSE 0 
    END) AS CheckOutsProcessed,

-- no.of PaymentsProcessed
COUNT(DISTINCT p.PaymentID) AS TotalPaymentsProcessed,

-- no. of Success in PaymentStatus
ISNULL(SUM(CASE 
        WHEN p.PaymentStatus = 'Success' THEN p.Amount 
        ELSE 0 
    END), 0) AS TotalRevenueProcessed

FROM Staff s

LEFT JOIN Reservation r 
ON s.StaffID = r.StaffID
AND r.CheckInDate >= DATEADD(DAY, -30, GETDATE())

LEFT JOIN Payment p 
ON s.StaffID = p.StaffID
AND p.PaymentDate >= DATEADD(DAY, -30, GETDATE())

GROUP BY 
s.StaffID,
s.name,
s.Role;

drop view vw_StaffPerformance;

select *
from vw_StaffPerformance 
where Role in( 'Reception','Billing')
order by TotalRevenueProcessed desc;
;


