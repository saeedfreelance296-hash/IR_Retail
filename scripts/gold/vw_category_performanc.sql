/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Gold Layer — Category Performance View
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Gold
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This view analyzes category performance by region to identify
                   categories consuming resources but generating minimal revenue.
                   
                   Key Metric:
                   Revenue to Cost of Carry Ratio = Revenue ÷ Cost of Carry
                   A ratio below 1 means the category is losing money.
                   
                   Business Problem Addressed:
                   Problem 03 — Ghost Category
                   Sports & Leisure allocated full shelf space, staff and
                   inventory in UAE, Egypt and Pakistan but contributes
                   under 2% of total revenue in those regions.
================================================================================
*/

CREATE OR ALTER VIEW gold.vw_category_performance AS

-- ============================================================================
-- Calculating revenue and cost of carry by category and region
-- Joining fact_sales and fact_inventory through shared keys
-- ============================================================================
WITH revenuebycateg AS (
    SELECT
    region_code,
    category,
    SUM(revenue_usd) as revenue_by_categ
    FROM silver.fact_sales
    GROUP BY region_code, category
),
costofcarry AS(
    SELECT
    region_code,
    category,
    SUM(monthly_cost_of_carry_usd) cost_of_carry_by_categ
    FROM silver.fact_inventory
    GROUP BY region_code, category
)

SELECT
rc.region_code,
rc.category,
rc.revenue_by_categ,
cc.cost_of_carry_by_categ,
revenue_to_cost_ratio = 
    CAST(CAST(revenue_by_categ AS DECIMAL(20,2)) 
    / cost_of_carry_by_categ AS DECIMAL (10,2)),
SUM(revenue_by_categ) OVER (PARTITION BY rc.region_code) AS total_region_revenue,
CAST(CAST(revenue_by_categ AS DECIMAL(20,2)) 
/ SUM(revenue_by_categ) OVER (PARTITION BY rc.region_code) * 100 AS DECIMAL(10,2)) AS revenue_contribution_pct
FROM revenuebycateg rc 
JOIN costofcarry cc  ON cc.category = rc.category
                    AND cc.region_code = rc.region_code
