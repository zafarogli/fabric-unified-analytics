CREATE TABLE DimGDP (
    CountryCode VARCHAR(10) NOT NULL,
    GdpYear INT NOT NULL,
    GdpUsd FLOAT NULL
);

INSERT INTO DimGDP (CountryCode, GdpYear, GdpUsd)
SELECT
    country_code AS CountryCode,
    gdp_year AS GdpYear,
    gdp_usd AS GdpUsd
FROM silver_gdp_yearly
WHERE gdp_year BETWEEN 2010 AND 2024;
