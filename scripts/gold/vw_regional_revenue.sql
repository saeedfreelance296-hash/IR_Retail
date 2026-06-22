/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Gold Layer — Regional Revenue & Growth View
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Gold
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This view calculates total revenue by region and year
                   with year over year growth rate to identify which regions
                   are growing, stagnating or declining.
                   
                   Key Metric:
                   YoY Growth % = (Current Year - Previous Year) / Previous Year * 100
                   
                   Business Context:
                   Provides the CEO with a high level view of regional
                   performance to identify where IR Retail is winning
                   and where it is losing ground.
================================================================================
*/

CREATE OR ALTER VIEW gold.vw_regional_revenue AS

-- ============================================================================
-- Calculating total revenue by region and year
-- YoY growth calculated using LAG window function
-- ============================================================================

WITH revenuebyregion AS (
    SELECT 
    [year],
    region_code,
    SUM(revenue_usd) AS revenue_by_region
    FROM silver.fact_sales
    GROUP BY  [year], region_code
)

SELECT

    [year],
    region_code,
    revenue_by_region,
    COALESCE(LAG(revenue_by_region) OVER(PARTITION BY region_code ORDER BY [year]),
            0) AS YOY_growth,
    COALESCE(CAST((revenue_by_region -LAG(revenue_by_region) OVER(PARTITION BY region_code ORDER BY [year]))  /
                        NULLIF(LAG(revenue_by_region) OVER(PARTITION BY region_code ORDER BY [year]),0) * 100
                        AS DECIMAL (10,2)), 0)  AS YOY_growth_pct
FROM revenuebyregion


