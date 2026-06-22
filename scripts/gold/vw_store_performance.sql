/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Gold Layer — Store Performance Ranking View
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Gold
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This view ranks stores by revenue within each region
                   to identify top and bottom performing stores.
                   Store level analysis helps the CEO pinpoint exactly
                   which locations are driving or dragging regional performance.
                   
                   Key Metric:
                   Revenue Rank = RANK() by revenue within each region
                   
                   Business Context:
                   Regional averages can hide individual store problems.
                   A single underperforming store can drag an entire
                   region's numbers down without being visible at
                   the regional level.
================================================================================
*/
CREATE OR ALTER VIEW gold.vw_store_performance AS

-- ============================================================================
-- Ranking stores by total revenue within each region
-- Using RANK window function partitioned by region
-- ============================================================================
WITH revenuebystore AS (
    SELECT
    region_code,
    store_id,
    SUM(revenue_usd) AS revenue_by_store
    FROM silver.fact_sales 
    GROUP BY region_code,  store_id

)

SELECT
rs.region_code,
rs.store_id,
ds.store_name,
rs.revenue_by_store,
RANK() OVER(PARTITION BY rs.region_code ORDER BY revenue_by_store DESC) AS [rank]
FROM revenuebystore rs 
LEFT JOIN silver.dim_stores ds
         ON ds.store_id = rs.store_id
         AND ds.region_code = rs.region_code


