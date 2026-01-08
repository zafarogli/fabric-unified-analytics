CREATE TABLE DimFX (
    DateKey INT NOT NULL,
    FxDate DATE NOT NULL,
    UsdEurRate FLOAT NULL
);

INSERT INTO DimFX (DateKey, FxDate, UsdEurRate)
SELECT
    (YEAR(fx_date)*10000 + MONTH(fx_date)*100 + DAY(fx_date)) AS DateKey,
    fx_date AS FxDate,
    usd_eur_rate AS UsdEurRate
FROM silver_fx_daily
WHERE fx_date BETWEEN '2024-01-01' AND '2024-12-31';
