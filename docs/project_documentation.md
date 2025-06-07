# Data Warehouse Project - Documentation

## Project Overview
This project builds a SQL-based Data Warehouse, structured using Medallion Architecture (Bronze, Silver, and Gold layers). 
It integrates CRM and ERP datasets, processes data using ETL pipelines, and prepares business-ready views for analytics and 
reporting.  
The goal was to simulate a real-world data warehousing scenario where raw operational data is transformed into structured models suitable for dashboards and insights.

---

## Data Architecture
This data warehouse follows a layered architecture for efficient data management and structured processing.

1. **Bronze Layer** (Raw Data Storage)
- Stores raw data directly from the source (CSV files from CRM and ERP systems).
- No transformations or filtering. Data is ingested as-is.
3. **Silver Layer** (Transformed Data)
- Cleans, standardizes, and normalizes data for accuracy.
- Handles nulls, missing values, duplicates, derived attributes, and format corrections.
- Uses truncate & insert strategy to refresh data.
4. **Gold Layer** (Business-Ready Data)
- Creates structured views optimized for reporting, analytics, and queries.
- Implements Star Schema (Fact & Dimension tables) for efficient analysis.

---

## ETL Process (Extract, Transform, Load)
The ETL process moves data across layers while cleaning and structuring it.

1. Extract
- Loads CRM & ERP datasets from CSV files into Bronze Layer tables using Bulk Insert.
- Data is ingested without changes to preserve original structure.
2. Transform
- Cleans data using by removing inconsistencies, handling nulls, missing values, and standardizing formats.
- Implements data transformation logics in SQL procedures.
- Moves data from Bronze → Silver Layer.
3. Load
- Loads structured Silver Layer data into Gold Views, ready for analytics.
- Applies business rules, aggregations, and relationships (joins across datasets).

---

## Data Model (Star Schema)
This warehouse follows a Star Schema, where:

1. Dimension Tables (Descriptive Data)
- Customers → Stores customer profiles from CRM & ERP systems.
- Products → Holds product details with category mapping.

3. Fact Table (Transactional Data)
- Sales Transactions → Records purchases, sales amounts, quantities, and sales dates.

Keys like customer_key and product_key link dimensions to the fact table, supporting efficient joins and analysis.

---

## Analytics & Reporting
The Gold Layer views help generate:

- Customer insights (customer segmentation, purchase behavior, location-based analysis).
- Sales trends (monthly revenue, product performance, order frequency).

These views can be connected to BI tools (like Power BI or Tableau) or queried directly using SQL for ad hoc reporting.
