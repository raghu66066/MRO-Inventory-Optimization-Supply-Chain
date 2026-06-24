# MRO Inventory Optimization & Supply Chain Risk Dashboard


Interactive MRO Inventory Optimization in Power BI

![Alt text](https://github.com/raghu66066/MRO-Inventory-Optimization-Supply-Chain/blob/dcbc030c67b02eb116d779f917b16bb7a964dc52/Images/MRO%20dashboard.png)

An end-to-end data analytics and master data management (MDM) project that transforms raw, unstandardized MRO (Maintenance, Repair, and Operations) inventory data into a highly compressed relational star schema and an actionable, exception-driven Power BI control center.

## 📌 Project Overview
Industrial manufacturing plants rely heavily on spare parts availability. When critical catalog data (like manufacturer part numbers) is missing, procurement lead times spike, creating severe operational risks. 

This project takes raw operational inventory logs, runs them through an extraction and data-cleansing pipeline in **SQL Server**, and deploys an interactive analytics suite in **Power BI** optimized for supply chain leaders and material planners.

## 🛠️ Tech Stack & Architecture
- **Data Layer:** SQL Server (T-SQL) for data cleaning, date standardization, and ETL transformations.
- **Data Modeling:** Star Schema Design (1-to-Many single-directional relationships).
- **BI & Analytics Layer:** Power BI Desktop, DAX (Data Analysis Expressions).
- **UI/UX Design:** Exception-based reporting, conditional formatting heat maps, dynamic summary narratives, and targeted drill-through modules.

---

## 🗂️ Database Architecture & Modeling
To maximize the Power BI VertiPaq engine's compression and query speed, the raw flat-file database was decomposed into a standard **Star Schema** using efficient integer surrogate keys (`_SK`).

### Star Schema Map
- **`Fact_Material_Inventory`**: Central table mapping relationships between plants, components, and workflow tracking alongside manufacturer parts.
- **`Dim_Plant`**: Physical locations, plant groups, and regional identifiers.
- **`Dim_Material_Master`**: Component inventory descriptions, upper-case standardized taxonomy (`Noun`/`Modifier`), and priority flags.
- **`Dim_Submission_Audit`**: Operational workflow logging, QA status checking, and audit-level assignments.

---

## 🚀 Execution Steps

### 1. Data Cleaning & Extraction (SQL Server)
The raw data contained unstructured strings, missing entries, and complex timestamp formats. The database script handles:
- Combining duplicated schema columns into standardized single-attribute text fields.
- Truncating high-cardinality metadata timestamps to optimize overall row processing.
- Isolating structural data using `SELECT DISTINCT` to auto-populate individual dimensional tables.

### 2. Business Intelligence Layer (DAX)
Calculations were restricted to explicit measures inside a dedicated container table to keep the workbook lightweight. Core metrics include:
- **Total Materials:** Core counter tracking record volume across the organization.
- **Cleaned Materials vs Backlog:** Active segmentation to quantify data enrichment progress.
- **Project Progress %:** Running metric indicating total percentage of database health compliance.
- **Dynamic Narrative Blocks:** Automated context metrics using string concatenation to call out top bottleneck nouns and highest-risk plants instantly without forcing user calculation lookup.

### 3. Dashboard Interface Principles
- **Executive Summary Stripe:** Top-level KPI cards reporting project completion rates and volume thresholds instantly.
- **Bottleneck Matrix Heat Map:** A cross-tabulation visual showing parts categories against factories, utilizing background color gradients to draw focus immediately to data logjams.
- **Granular Drill-Through Paths:** Allows operational auditing teams to right-click a bottleneck area and leap to an itemized inventory list pre-filtered to that specific factory layout.

---

## 📥 How To Use This Repository
1. **Database Setup:** Execute the script provided in `/sql_queries/mro_transformation.sql` on your SQL Server instance to generate the relational environment.
2. **Data Ingestion:** Load your corresponding inventory flat file into the staging configuration block.
3. **Open the Report:** Launch the `.pbix` file located in `/dashboard/` and adjust your local server credentials via the Data Source Settings panel to observe the dashboard live.
