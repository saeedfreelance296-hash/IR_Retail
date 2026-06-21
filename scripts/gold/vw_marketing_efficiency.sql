/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Gold Layer — Marketing Efficiency View
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Gold
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This view calculates marketing efficiency by region and year.
                   It combines marketing spend from fact_marketing_spend with
                   revenue from fact_sales to calculate Marketing ROI.
                   
                   Key Metric:
                   Marketing ROI = Total Revenue ÷ Total Marketing Spend
                   
                   Business Problem Addressed:
                   Problem 1 — Egypt Marketing Black Hole
                   Egypt received the highest marketing budget increase but
                   revenue flatlined. This view exposes which regions generate
                   the most revenue per dollar spent on marketing.
================================================================================
*/
-- Createing view for marketing annalysis
CREATE OR ALTER VIEW gold.vw_marketing_efficiency AS 
-- ============================================================================
-- Aggregating marketing spend by region and year
-- ============================================================================
    WITH marketinspend AS (
    SELECT
        region_code,
        [year],
        SUM(spend_usd) AS marketing_spend_by_region  ---- the marketing spend is calculated in USD
    FROM silver.fact_marketing_spend
    GROUP BY region_code, [year]
    ),
-- ============================================================================
-- Aggregating revenue by region and year
-- ============================================================================
    revenuebyregion AS (
    SELECT
        region_code,
        [year],
        SUM(revenue_usd) AS revenue_by_region --- the revenue is calcluated in USD
    FROM silver.fact_sales
    GROUP BY region_code, [year]
    ) 
-- ============================================================================
-- Joining spend and revenue to calculate Marketing ROI
-- ============================================================================
    SELECT
        ms.region_code,
        ms.[year],
        CAST(rr.revenue_by_region / ms.marketing_spend_by_region  AS DECIMAL (10,2)) AS ROI_by_region
    FROM marketinspend ms 
    JOIN revenuebyregion rr ON rr.region_code = ms.region_code
                            AND rr.[year] = ms.[year]






