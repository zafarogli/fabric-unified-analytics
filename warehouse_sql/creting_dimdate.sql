CREATE TABLE DimDate (
    DateKey INT NOT NULL,
    [Date] DATE NOT NULL,
    [Year] INT NOT NULL,
    [Month] INT NOT NULL,
    [Day] INT NOT NULL,
    MonthName VARCHAR(20) NOT NULL,
    DayOfWeek INT NOT NULL,
    DayName VARCHAR(20) NOT NULL
);


INSERT INTO DimDate (DateKey, [Date], [Year], [Month], [Day], MonthName, DayOfWeek, DayName)
SELECT 
    (YEAR(DateValue) * 10000) + (MONTH(DateValue) * 100) + DAY(DateValue) AS DateKey,
    DateValue AS [Date],
    YEAR(DateValue) AS [Year],
    MONTH(DateValue) AS [Month],
    DAY(DateValue) AS [Day],
    DATENAME(month, DateValue) AS MonthName,
    DATEPART(weekday, DateValue) AS DayOfWeek,
    DATENAME(weekday, DateValue) AS DayName
FROM (
    SELECT DATEADD(day, value, '2024-01-01') AS DateValue
    FROM GENERATE_SERIES(0, 365)
) AS DateSeries;
