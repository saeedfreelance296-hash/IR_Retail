/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Gold Layer — Profitability Analysis View
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Gold
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This view analyzes profitability by region and category
                   to identify where IR Retail makes and loses money.
                   It calculates profit margin percentage to show which
                   regions and categories are most and least profitable.
                   
                   Key Metrics:
                   Total Profit    = SUM(profit_usd)
                   Profit Margin % = (Total Profit / Total Revenue) * 100
                   
                   Business Context:
                   Revenue alone does not tell the full story. A region
                   can generate high revenue but low profit due to
                   aggressive discounting or high operating costs.
                   This view separates high revenue from high profitability.
================================================================================
*/

--- CREATE OR ALTER VIEW gold.vw_profitability AS

-- ============================================================================
-- Calculating profit and profit margin by region and category
-- Profit margin reveals true business health beyond revenue numbers
-- ============================================================================
SE:/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Gold Layer — Profitability Analysis View
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Gold
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This view analyzes profitability by region and category
                   to identify where IR Retail makes and loses money.
                   It calculates profit margin percentage to show which
                   regions and categories are most and least profitable.
                   
                   Key Metrics:
                   Total Profit    = SUM(profit_usd)
                   Profit Margin % = (Total Profit / Total Revenue) * 100
                   
                   Business Context:
                   Revenue alone does not tell the full story. A region
                   can generate high revenue but low profit due to
                   aggressive discounting or high operating costs.
                   This view separates high revenue from high profitability.
================================================================================
*/
GO
CREATE OR ALTER VIEW gold.vw_profitability AS

-- ============================================================================
-- Calculating profit and profit margin by region and category
-- Profit margin reveals true business health beyond revenue numbers
-- ===========================================================================

    SELECT
    region_code,
    category,
    total_profit,
    total_revenue,
    profit_margin,
    -- ranking categories by profit margin
    RANK() OVER(PARTITION BY region_code ORDER BY profit_margin DESC) AS profit_rank
    FROM (
     SELECT
    region_code,
    category,
    SUM(profit_usd) AS total_profit,
    SUM(revenue_usd) AS total_revenue,
    CAST((SUM(profit_usd) / SUM(revenue_usd)) * 100  AS DECIMAL(10,2)) AS profit_margin
    FROM silver.fact_sales
    GROUP BY region_code, category
    
) pft
