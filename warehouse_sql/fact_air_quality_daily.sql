CREATE TABLE FactAirQualityDaily (
    DateKey INT NOT NULL,
    Pm25AvgNyc FLOAT NULL,
    Pm25MinNyc FLOAT NULL,
    Pm25MaxNyc FLOAT NULL,
    AvgCoveragePct FLOAT NULL
);

INSERT INTO FactAirQualityDaily
(
    DateKey, Pm25AvgNyc, Pm25MinNyc, Pm25MaxNyc, AvgCoveragePct
)
SELECT
    (YEAR(air_date)*10000 + MONTH(air_date)*100 + DAY(air_date)) AS DateKey,
    pm25_avg_nyc AS Pm25AvgNyc,
    pm25_min_nyc AS Pm25MinNyc,
    pm25_max_nyc AS Pm25MaxNyc,
    avg_coverage_pct AS AvgCoveragePct
FROM gold_airquality_daily
WHERE air_date BETWEEN '2024-01-01' AND '2024-12-31';
