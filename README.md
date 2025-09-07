# SQL DATA WAREHOUSE PROJECT

Welcome to the Data Warehouse and Analytics Project repository! 🚀
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.


<img width="841" height="506" alt="Data Architecture " src="https://github.com/user-attachments/assets/f608e6e8-64d2-4c96-ad1c-2516378b9aa6" />



1.	**Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2.	**Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3.	**Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

-------------------------------------------------------------------------------------------------------------------------------------------------------------

**📖 Project Overview**

This project involves:
1.	**Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
2.	**ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3.	**Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4.	**Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

-------------------------------------------------------------------------------------------------------------------------------------------------------------

**🚀 Project Requirements**

Building the Data Warehouse (Data Engineering)

**Objective**:

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.


**Specifications**:

•	Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.

•	Data Quality: Cleanse and resolve data quality issues prior to analysis.

•	Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.

•	Scope: Focus on the latest dataset only; historization of data is not required.

•	Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

## 📊 Exploratory Data Analysis (EDA)

In the **EDA phase**, we analyze raw and transformed data to understand its structure, quality, and underlying patterns.  
Key tasks include:
- Examining data distributions and statistics
- Exploring date ranges, dimensions, and measures
- Identifying data quality issues
- Ranking and magnitude analysis

These steps help ensure the data is consistent and ready for deeper analytics.

---

## 📈 Advanced Data Analytics

Advanced analytics provides actionable business insights beyond basic reporting.  
Implemented advanced analyses include:
- Change-over-time analysis to detect trends  
- Cumulative and part-to-whole analysis to monitor aggregate growth  
- Data segmentation to identify customer and product clusters  
- Performance analysis for evaluating KPIs  
- Custom reports for customers and product performance  

These analyses support data-driven decision-making and strategic business actions.

---

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # ETL techniques and methods diagram
│   ├── data_architecture.drawio        # Project architecture diagram
│   ├── data_catalog.md                 # Dataset catalog with field descriptions and metadata
│   ├── data_flow.drawio                # Data flow diagram
│   ├── data_models.drawio              # Star schema data models
│   ├── naming-conventions.md           # Naming conventions for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Raw data extraction and load scripts
│   ├── silver/                         # Data cleaning and transformation scripts
│   ├── gold/                           # Analytical data model creation scripts
│
├── exploratory-data-analysis/          # SQL scripts for EDA
│   ├── database_exploration.sql
│   ├── date_range_exploration.sql
│   ├── dimensions_exploration.sql
│   ├── magnitude_analysis.sql
│   ├── measures_exploration.sql
│   ├── ranking_analysis.sql
│
├── advanced-data-analysis/            # SQL scripts for advanced analytics
│   ├── change_over_time_analysis.sql
│   ├── cumulative_analysis.sql
│   ├── data_segmentation_analysis.sql
│   ├── part-to-whole_analysis.sql
│   ├── performance_analysis.sql
│   ├── report_customers.sql
│   ├── report_products.sql
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
└── LICENSE                             # License information for the repository
```
---
