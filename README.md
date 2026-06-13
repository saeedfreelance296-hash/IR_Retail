# IR Retail Analytics Project
### End-to-End Data Analytics Portfolio Project

---

## 📌 Business Problem

IR Retail Group is an international hypermarket chain operating across **5 global markets** with **116 stores** and an estimated **$2.1 billion USD** in annual revenue. Despite healthy top-line growth, the CEO suspects the business is leaving serious money on the table.

> *"We are spending more than ever before — on marketing, on new stores, on staff — and yet something feels deeply off. I need someone to go into our data, find out what is really happening, and tell me where to focus next year."*
> — CEO, IR Retail Group

This project investigates IR Retail's 2-year sales data (2023–2024) to uncover hidden business problems and deliver data-backed recommendations.

---

## 🎯 Core Business Question

> **Is IR Retail growing profitably and sustainably across all markets — and if not, where are the leaks, why are they happening, and where should the business focus its investment in 2025?**

---

## 🏢 Company Profile

| Field | Detail |
|---|---|
| Company | IR Retail Group |
| Industry | International Hypermarket Chain |
| Inspired By | Carrefour International |
| Markets | UAE, France, Egypt, Pakistan, Brazil |
| Total Stores | 116 globally |
| Data Coverage | January 2023 — December 2024 |

---

## 🔍 Key Business Problems Investigated

| # | Problem | Description |
|---|---|---|
| 1 | 📢 The Marketing Black Hole | Egypt received 34% more marketing budget but revenue flatlined at -0.2% growth |
| 2 | 📉 The Silent Collapse | Customer retention dropped from 41% to 22% — hidden behind healthy new customer numbers |
| 3 | 👻 The Ghost Category | Sports & Leisure contributes under 2% revenue in UAE, Egypt and Pakistan despite full shelf space and staffing |
| 4 | ⚡ The Fading Star | Electronics declined 33% in Q3/Q4 2024 in UAE — IR Retail's most profitable market |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| SQL Server | Data warehouse and analysis |
| VS Code | Script development and project management |
| Power BI | Dashboard and visualization |
| Git & GitHub | Version control and portfolio publishing |
| Notion | Project management and documentation |
| Lucidchart | Architecture and flow diagrams |

---

## 🏗️ Architecture

This project follows the **Medallion Architecture** — an industry standard data warehouse pattern:

```
Source CSVs (Raw Data)
      ↓
  BRONZE Layer  →  Raw data, loaded as-is, no transformations
      ↓
  SILVER Layer  →  Cleaned, standardized, proper data types
      ↓
  GOLD Layer    →  Analytical views, aggregations, business metrics
      ↓
  Power BI Dashboard  →  Executive insights and recommendations
```

---

## 📁 Project Structure

```
IR_Retail/
│
├── scripts/
│   ├── 01_init_database.sql          ← Database and schema creation
│   ├── bronze_DDL.sql                ← Bronze layer table definitions
│   ├── bronze_bulk_insert.sql        ← Data loading scripts
│   ├── 02_EDA/
│   │   └── eda_bronze_layer.sql      ← Exploratory data analysis
│   ├── 03_Cleaning/                  ← Silver layer transformation scripts
│   ├── 04_Analysis/                  ← Business analysis SQL queries
│   └── 05_PowerBI/                   ← Power BI dashboard file
│
├── .gitignore
├── LICENSE
└── README.md
```

---

## 📊 Dataset Overview

| Table | Type | Rows | Description |
|---|---|---|---|
| dim_customers | Dimension | 25,000 | Customer master data |
| dim_dates | Dimension | 731 | Calendar reference table |
| dim_products | Dimension | 120 | Product catalogue |
| dim_stores | Dimension | 116 | Store master data |
| fact_sales | Fact | 480,000 | Core sales transactions |
| fact_marketing_spend | Fact | 720 | Monthly marketing budget by region |
| fact_inventory | Fact | 13,920 | Stock levels by store and product |

---

## 📈 Key Findings

> *To be updated upon completion of analysis phase.*

---

## 💡 Recommendations

> *To be updated upon completion of analysis phase.*

---

## 👤 Author

**Saeed Ahmad**
Lead Business Analyst

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/saeed-ahmad-1a8992350)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black)](https://github.com/saeedfreelance296-hash)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.