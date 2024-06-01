--Creating database
CREATE DATABASE corona_virus

--Creating a null table
CREATE TABLE coviddata5 (
    Province VARCHAR(255),
    CountryRegion VARCHAR(255),
    Latitude FLOAT,
    Longitude FLOAT,
    Date DATE,
    Confirmed INT,
    Deaths INT,
    Recovered INT
);

--Importing from csv to null table
LOAD DATA INFILE "C:/Users/ADMIN/Downloads/Corona Virus Dataset (1).csv"
INTO TABLE coviddata5
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Province, CountryRegion, Latitude, Longitude, @Date, Confirmed, Deaths, Recovered)
SET Date = STR_TO_DATE(@Date, '%d-%m-%Y');

-- Q1. Write a code to check NULL values
SELECT *
FROM coviddata5
WHERE Province IS NULL
   OR 'Country/Region' IS NULL
   OR Latitude IS NULL
   OR Longitude IS NULL
   OR Date IS NULL
   OR Confirmed IS NULL
   OR Deaths IS NULL
   OR Recovered IS NULL;

--Q2. If NULL values are present, update them with zeros for all columns. 
UPDATE coviddata5
SET 
    Province = COALESCE(Province, ''),
    `Country/Region` = COALESCE(`Country/Region`, ''),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date = COALESCE(Date, ''),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);

-- Q3. check total number of rows
SELECT COUNT(*) FROM coviddata5;

-- Q4. Check what is start_date and end_date
SELECT MIN(Date) AS `start_date`,MAX(Date) AS `end_date` FROM coviddata5;

-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT DATE_FORMAT(Date, '%Y-%m')) AS Number_of_Months FROM coviddata5;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    DATE_FORMAT(Date, '%b') AS Month,
    AVG(Confirmed) AS Avg_Confirmed,
    AVG(Deaths) AS Avg_Deaths,
    AVG(Recovered) AS Avg_Recovered
FROM 
    coviddata5
GROUP BY 
    MONTH(Date)
ORDER BY 
    MONTH(Date);

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
    DATE_FORMAT(Date, '%b') AS Month,
    MAX(Confirmed) AS MostFrequentConfirmed,
    MAX(Deaths) AS MostFrequentDeaths,
    MAX(Recovered) AS MostFrequentRecovered
FROM 
    coviddata5
GROUP BY 
    MONTH(Date) 
ORDER BY 
    MONTH(Date);

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS Year,
    MIN(Confirmed) AS Min_Confirmed,
    MIN(Deaths) AS Min_Deaths,
    MIN(Recovered) AS Min_Recovered
FROM 
    coviddata5
GROUP BY 
    YEAR(Date);

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS Year,
    MAX(Confirmed) AS Max_Confirmed,
    MAX(Deaths) AS Max_Deaths,
    MAX(Recovered) AS Max_Recovered
FROM 
    coviddata5
GROUP BY 
    YEAR(Date);

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    DATE_FORMAT(Date, '%b') AS Month,
    SUM(Confirmed) AS TotalConfirmed,
    SUM(Deaths) AS TotalDeaths,
    SUM(Recovered) AS TotalRecovered
FROM 
    coviddata5
GROUP BY 
    MONTH(Date)
ORDER BY 
  MONTH(Date);

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    COUNT(*) AS TotalConfirmedCases,
    AVG(Confirmed) AS AverageConfirmedCases,
    VARIANCE(Confirmed) AS ConfirmedVariance,
    STDDEV(Confirmed) AS ConfirmedStandardDeviation
FROM 
    coviddata5;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    DATE_FORMAT(Date, '%b') AS Month,
    COUNT(*) AS TotalDeathCases,
    AVG(Deaths) AS AverageDeathCases,
    VARIANCE(Deaths) AS DeathVariance,
    STDDEV(Deaths) AS DeathStandardDeviation
FROM 
    coviddata5
GROUP BY 
    MONTH(Date)
ORDER BY 
  MONTH(Date);

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    COUNT(*) AS TotalRecoveredCases,
    AVG(Recovered) AS AverageRecoveredCases,
    VARIANCE(Recovered) AS RecoveredVariance,
    STDDEV(Recovered) AS RecoveredStandardDeviation
FROM 
    coviddata5;

-- Q14. Find Country having highest number of the Confirmed case
SELECT 
    CountryRegion,
    MAX(Confirmed) AS HighestConfirmedCases
FROM 
   coviddata5
GROUP BY 
    CountryRegion
ORDER BY 
    HighestConfirmedCases DESC;

-- Q15. Find Country having lowest number of the death case
SELECT 
    CountryRegion,
    MIN(COALESCE(Deaths, 0)) AS LowestDeathCases
FROM 
   coviddata5
GROUP BY 
    CountryRegion
ORDER BY 
    LowestDeathCases ASC;

-- Q16. Find top 5 countries having highest recovered case
SELECT 
    CountryRegion,
    SUM(Recovered) AS TotalRecoveredCases
FROM 
    coviddata5
GROUP BY 
    CountryRegion
ORDER BY 
    TotalRecoveredCases DESC
LIMIT 5;


