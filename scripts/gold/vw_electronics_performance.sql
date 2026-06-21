/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Gold Layer — Electronics Performance View
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Gold
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This view tracks Electronics revenue by region, year and
                   quarter to identify the decline pattern in UAE.
                   
                   Key Metric:
                   Year over Year Revenue Growth Rate
                   = (2024 Revenue - 2023 Revenue) ÷ 2023 Revenue × 100
                   
                   Business Problem Addressed:
                   Problem 04 — The Fading Star
                   Electronics revenue in UAE dropped sharply in Q3 and Q4
                   of 2024 — IR Retail's most profitable market and category
                   combination is quietly collapsing.
================================================================================
*/

CREATE OR ALTER VIEW gold.vw_electronics_performance AS

-- ============================================================================
-- Tracking Electronics revenue by region, year and quarter
-- Filtering to category level to isolate the decline pattern
-- ============================================================================
WITH revenuebyquarter AS (
    SELECT 
    [year],
    [quarter],
    SUM(revenue_usd) AS revenue_by_quarter
    FROM silver.fact_sales
    WHERE region_code = 'UAE' AND category = 'Electronics & Appliances'
    GROUP BY  [year], [quarter]
)

SELECT
    [year],
    [quarter],
    revenue_by_quarter,
    COALESCE(LAG(revenue_by_quarter) OVER(PARTITION BY [quarter] ORDER BY [year]),
            0) AS YOY_growth,
    COALESCE(CAST((revenue_by_quarter -LAG(revenue_by_quarter) OVER(PARTITION BY [quarter] ORDER BY [year]))  /
                        NULLIF(LAG(revenue_by_quarter) OVER(PARTITION BY [quarter] ORDER BY [year]),0) * 100
                        AS DECIMAL (10,2)), 0)  AS YOY_growth_pct
FROM revenuebyquarter

