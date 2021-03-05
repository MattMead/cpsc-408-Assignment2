--1
CREATE TABLE Player(
    pID SMALLINT NOT NULL,
    name VARCHAR(30) NOT NULL,
    teamName VARCHAR(30),
    PRIMARY KEY (pID)
);

--2
ALTER TABLE Player
ADD age TINYINT;

--3
INSERT INTO Player VALUES
    (1,'Player 1', 'Team A', 23),
    (2,'Player 2', 'Team A',NULL),
    (3,'Player 3', 'Team B', 28),
    (4,'Player 4', 'Team B',NULL);

--4
DELETE FROM Player
WHERE pID = 2;

--5
UPDATE Player
SET age = 25
WHERE age IS NULL;

--6
SELECT COUNT(*) NumberTuples, AVG(age) AvgAge
FROM Player;

--7
DROP TABLE Player;

--8
SELECT AVG(Total) AverageTotal
FROM Invoice
WHERE BillingCountry = 'Brazil';

--9
SELECT BillingCity , AVG(Total) AverageTotal
FROM Invoice
WHERE BillingCountry = 'Brazil'
GROUP BY BillingCity;

--10
SELECT Title, COUNT(*) Tracks
FROM Track , Album
WHERE Track.AlbumId = Album.AlbumId
GROUP BY Title
HAVING COUNT(*) > 20;

--11
SELECT COUNT(*) Invoices2010
FROM Invoice
WHERE strftime('%Y', InvoiceDate) = '2010';


--12
SELECT  BillingCountry , COUNT(DISTINCT BillingCity)
FROM Invoice
GROUP BY BillingCountry
ORDER BY COUNT(DISTINCT BillingCity) DESC;

--13
SELECT Album.Title  AS AlbumTitle, Track.Name AS TrackName, MediaType.Name AS MediaType
FROM Album, Track, MediaType
WHERE Album.AlbumId = Track.AlbumId
AND Track.MediaTypeId = MediaType.MediaTypeId;

--14
SELECT COUNT(*) JaneSales
FROM Invoice
WHERE Invoice.CustomerId IN
      (SELECT Customer.CustomerID
       FROM Customer, Employee
       WHERE Customer.SupportRepId = Employee.EmployeeId
       AND Employee.FirstName = 'Jane'
       AND Employee.LastName = 'Peacock'
       AND Employee.Title LIKE '%Support%');

--Bonus
/*
 Plan:
 1. Cannot nest AVG() so I will make a new column calculating the
 difference between the invoice total and the mean of totals
 2. Will then use aggregate functions to calculate the standard deviation
 */

-- 1) Column called STDNumber
ALTER TABLE Invoice
ADD STDNumber FLOAT;

-- 2) Average of total is 5.651941747572825
SELECT AVG(Total)
FROM Invoice;

-- 3) Update the new column with the difference of total and the average
UPDATE Invoice
SET STDNumber = Total - 5.651941747572825
WHERE STDNumber IS NULL;

-- 4) Checking the true standard deviation
SELECT STDEV(Total)
FROM Invoice;
-- Standard deviation = 4.745319693568106

-- 5) Checking the standard deviation that I calculated manually
SELECT SQRT(SUM(SQUARE(STDNumber))/COUNT(*)) StandardDeviation
FROM Invoice;
-- Standard Deviation = 4.739557311729622

