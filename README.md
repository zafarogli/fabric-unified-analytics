# Microsoft Fabric Unified Analytics Project
### Medallion Architecture + Warehouse Star Schema + Power BI

## 1. Project Overview
This project implements an **end-to-end analytics pipeline in Microsoft Fabric**, combining multiple real-world datasets across **mobility, air quality, and economic indicators**.  
The solution follows a **Medallion (Bronze/Silver/Gold) architecture** in a Fabric Lakehouse and a **star schema** in Fabric Warehouse, with final analytics delivered through **Power BI**.

The primary analytical goal is to explore the relationship between **NYC taxi activity** and **air quality (PM2.5)**, while demonstrating production-style data engineering practices.

---

## 2. Technology Stack
- **Microsoft Fabric**
  - Lakehouse
  - Dataflow Gen2
  - Pipelines
  - Notebooks (PySpark)
  - Warehouse (SQL)
  - Power BI
- **Storage format:** Delta Lake
- **Modeling:** Star Schema (Facts & Dimensions)

---

## 3. Data Sources
| Domain | Source | Description |
|-----|------|-----------|
| Mobility | NYC Taxi Trips | Daily taxi trip volume and fare metrics |
| Air Quality | OpenAQ API v3 | PM2.5 daily measurements for NYC |
| Economy | ECB FX | Daily USD/EUR exchange rates |
| Economy | World Bank GDP | Yearly GDP by country |

---

## 4. Architecture Overview

### 4.1 Medallion Architecture (Lakehouse)

**Bronze (Raw Ingestion)**
- `bronze_taxi_trips`
- `bronze_openaq`
- `bronze_ecb_fx`
- `bronze_worldbank_gdp`

**Silver (Cleaned & Typed)**
- `silver_taxi_trips`
- `silver_airquality_daily`
- `silver_fx_daily`
- `silver_gdp_yearly`

**Gold (Aggregated & Analytics-Ready)**
- `gold_taxi_daily`
- `gold_airquality_daily`
- `gold_taxi_daily_eur`

Bronze and Silver layers preserve raw data integrity, while Gold applies business-ready aggregations.

---

## 5. Warehouse Data Modeling (Star Schema)

### 5.1 Fact Tables
- **FactTaxiDaily**
  - Daily trip count
  - Total & average fare (USD / EUR)
  - Average trip distance
- **FactAirQualityDaily**
  - Daily PM2.5 metrics (NYC-level aggregation)

### 5.2 Dimension Tables
- **DimDate** – Calendar dimension (2024, 366 rows)
- **DimFX** – USD/EUR exchange rates by date
- **DimGDP** – GDP by country and year

### 5.3 Design Decision: DimZone
Air quality data was intentionally modeled at **city-level (NYC)** instead of zone-level to:
- Avoid sparse fact tables
- Reduce sensor-level instability
- Ensure clean cross-domain joins with mobility data

Zone-level modeling can be added later by changing fact grain and introducing `DimZone`.

---


## 6. Final Reporting View
A reporting-ready view was created in the Warehouse:

- **`vw_MobilityAirDaily`**
  - Joins FactTaxiDaily and FactAirQualityDaily via DimDate
  - Applies data quality filters
  - Used directly by Power BI

---


## 7. Power BI Reporting
Power BI report built on `vw_MobilityAirDaily` includes:
1. Daily Taxi Trips (Line Chart)
2. Daily PM2.5 Levels (Line Chart)


---

## 8. Orchestration & Ingestion
- **Dataflow Gen2**
  - ECB FX ingestion
  - World Bank GDP ingestion
- **Fabric Pipeline**
  - Taxi data ingestion to Bronze

# Dataflow Gen2 – Ingestion Layer

This project uses **Microsoft Fabric Dataflow Gen2** to ingest external reference data
into the Lakehouse Bronze layer.

## Dataflow: bronze_ecb_fx
**Purpose:** Ingest daily USD/EUR foreign exchange rates.

- Source: European Central Bank (ECB)
- Type: REST / CSV
- Refresh mode: Manual
- Destination: Lakehouse → Bronze
- Output table: bronze_ecb_fx

**Transformations:**
- Parsed date column
- Cast exchange rate to numeric
- Filtered null values

---

## Dataflow: bronze_worldbank_gdp
**Purpose:** Ingest yearly GDP data by country.

- Source: World Bank API
- Type: REST / JSON
- Refresh mode: Manual
- Destination: Lakehouse → Bronze
- Output table: bronze_worldbank_gdp

**Transformations:**
- Expanded nested JSON records
- Selected country code, year, GDP value
- Filtered null GDP values
