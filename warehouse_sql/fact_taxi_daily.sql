CREATE TABLE FactTaxiDaily (
    DateKey INT NOT NULL,
    TripCount BIGINT NOT NULL,
    TotalFareUsd FLOAT NULL,
    AvgFareUsd FLOAT NULL,
    AvgTripDistance FLOAT NULL,
    UsdEurRate FLOAT NULL,
    TotalFareEur FLOAT NULL,
    AvgFareEur FLOAT NULL
);

INSERT INTO FactTaxiDaily
(
    DateKey, TripCount,
    TotalFareUsd, AvgFareUsd, AvgTripDistance,
    UsdEurRate, TotalFareEur, AvgFareEur
)
SELECT
    (YEAR([date])*10000 + MONTH([date])*100 + DAY([date])) AS DateKey,
    trip_count AS TripCount,
    total_fare_usd AS TotalFareUsd,
    avg_fare_usd AS AvgFareUsd,
    avg_trip_distance AS AvgTripDistance,
    usd_eur_rate AS UsdEurRate,
    total_fare_eur AS TotalFareEur,
    avg_fare_eur AS AvgFareEur
FROM gold_taxi_daily_eur
WHERE [date] BETWEEN '2024-01-01' AND '2024-12-31';
