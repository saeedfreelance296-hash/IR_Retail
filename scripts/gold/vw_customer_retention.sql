/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Gold Layer — Customer Retention View
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Gold
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This view calculates customer retention by measuring the
                   repeat purchase rate across regions and years.
                   
                   Key Metric: 
                   Repeat Purchase Rate = (Repeat Purchases ÷ Total Transactions) × 100
                   
                   Business Problem Addressed:
                   Problem 02 — Silent Retention Collapse
                   Overall revenue looks healthy because new customers are up.
                   But repeat purchase rate dropped from 41% to 22% between
                   2023 and 2024 — the business is losing existing customers
                   silently.
================================================================================
*/
-- Createing view for customer_retention

CREATE OR ALTER VIEW gold.vw_customer_retention AS

-- ============================================================================
-- Calculating repeat purchase rate by region and year
-- A higher rate means customers are returning — a declining rate is a warning
-- ============================================================================
WITH retunpurchaserate AS (
    SELECT
    region_code,
    [year],
    SUM(CAST(is_return_purchase AS INT)) AS return_pruchase,
    COUNT (transaction_id) AS total_transactoins 
    FROM silver.fact_sales
    GROUP BY region_code, [year]
)

SELECT
region_code,
[year],
return_pruchase,
total_transactoins,
--- Calculating repeat_purchase_rate 
--- FORMULA TO USE : (Repeat Purchase Rate = (SUM of is_return_purchase)
--- ÷ (COUNT of total transactions) × 100)
repeat_purchase_rate = CAST(CAST(return_pruchase AS DECIMAL (10,2)) / total_transactoins * 100 AS DECIMAL(10,2))
FROM retunpurchaserate
