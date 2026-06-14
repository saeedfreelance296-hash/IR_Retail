/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    Exploratory Data Analysis (EDA) — Bronze Layer
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Bronze
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This script performs a comprehensive exploratory data analysis
                   on all 7 tables in the Bronze layer. The analysis is structured
                   into 4 key checks:
                        1. Row Count Validation
                        2. Null Audit
                        3. Duplicate Check
                        4. Range & Sanity Check
                        5. Referential Integrity Check
================================================================================
    WARNING: This script is read-only. No data is modified.
================================================================================
*/

USE IR_Retail_DW;
GO

-- ==============================================================================
-- STEP 1: ROW COUNT VALIDATION
-- Purpose : Verify that all tables loaded correctly from source CSV files.
--           Expected counts are based on the original source system exports.
-- ==============================================================================

SELECT 'dim_customers'       AS table_name, COUNT(*) AS row_count, 25000  AS expected_count FROM bronze.dim_customers
UNION ALL
SELECT 'dim_dates',                          COUNT(*),              731                       FROM bronze.dim_dates
UNION ALL
SELECT 'dim_products',                       COUNT(*),              120                       FROM bronze.dim_products
UNION ALL
SELECT 'dim_stores',                         COUNT(*),              116                       FROM bronze.dim_stores
UNION ALL
SELECT 'fact_inventory',                     COUNT(*),              13920                     FROM bronze.fact_inventory
UNION ALL
SELECT 'fact_marketing_spend',               COUNT(*),              720                       FROM bronze.fact_marketing_spend
UNION ALL
SELECT 'fact_sales',                         COUNT(*),              480000                    FROM bronze.fact_sales
ORDER BY table_name;

-- ==============================================================================
-- STEP 2: NULL AUDIT
-- Purpose : Identify missing values in critical columns across all tables.
--           Only priority columns are audited — primary keys, foreign keys,
--           financial fields and critical categorical columns.
--           Non-critical columns such as holiday_name are excluded as
--           nulls are expected by design.
-- ==============================================================================

SELECT
    'dim_customers'      AS table_name,
    'customer_id'        AS column_name,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_count
FROM bronze.dim_customers
UNION ALL
SELECT 'dim_customers', 'region_code',
    SUM(CASE WHEN region_code IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_customers
UNION ALL
SELECT 'dim_customers', 'customer_segment',
    SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_customers
UNION ALL
SELECT 'dim_customers', 'join_date',
    SUM(CASE WHEN join_date IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_customers

-- dim_dates
UNION ALL
SELECT 'dim_dates', 'date',
    SUM(CASE WHEN [date] IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_dates
UNION ALL
SELECT 'dim_dates', 'year',
    SUM(CASE WHEN [year] IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_dates
UNION ALL
SELECT 'dim_dates', 'month',
    SUM(CASE WHEN [month] IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_dates

-- dim_products
UNION ALL
SELECT 'dim_products', 'product_id',
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_products
UNION ALL
SELECT 'dim_products', 'category',
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_products
UNION ALL
SELECT 'dim_products', 'cost_price_usd',
    SUM(CASE WHEN cost_price_usd IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_products
UNION ALL
SELECT 'dim_products', 'selling_price_usd',
    SUM(CASE WHEN selling_price_usd IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_products

-- dim_stores
UNION ALL
SELECT 'dim_stores', 'store_id',
    SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_stores
UNION ALL
SELECT 'dim_stores', 'region_code',
    SUM(CASE WHEN region_code IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_stores
UNION ALL
SELECT 'dim_stores', 'country',
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END)
FROM bronze.dim_stores

-- fact_inventory
UNION ALL
SELECT 'fact_inventory', 'store_id',
    SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_inventory
UNION ALL
SELECT 'fact_inventory', 'product_id',
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_inventory
UNION ALL
SELECT 'fact_inventory', 'stock_quantity',
    SUM(CASE WHEN stock_quantity IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_inventory

-- fact_marketing_spend
UNION ALL
SELECT 'fact_marketing_spend', 'region_code',
    SUM(CASE WHEN region_code IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_marketing_spend
UNION ALL
SELECT 'fact_marketing_spend', 'spend_usd',
    SUM(CASE WHEN spend_usd IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_marketing_spend
UNION ALL
SELECT 'fact_marketing_spend', 'year',
    SUM(CASE WHEN [year] IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_marketing_spend
UNION ALL
SELECT 'fact_marketing_spend', 'month',
    SUM(CASE WHEN [month] IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_marketing_spend

-- fact_sales
UNION ALL
SELECT 'fact_sales', 'transaction_id',
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_sales
UNION ALL
SELECT 'fact_sales', 'date',
    SUM(CASE WHEN [date] IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_sales
UNION ALL
SELECT 'fact_sales', 'customer_id',
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_sales
UNION ALL
SELECT 'fact_sales', 'revenue_usd',
    SUM(CASE WHEN revenue_usd IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_sales
UNION ALL
SELECT 'fact_sales', 'profit_usd',
    SUM(CASE WHEN profit_usd IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_sales
UNION ALL
SELECT 'fact_sales', 'quantity',
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END)
FROM bronze.fact_sales
ORDER BY table_name;

-- ==============================================================================
-- STEP 3: DUPLICATE CHECK
-- Purpose : Verify that each table's primary key is unique.
--           A result with no rows means no duplicates were found — which is
--           the expected and desired outcome.
-- ==============================================================================

SELECT 'dim_customers'      AS table_name, customer_id              AS primary_key, COUNT(*) AS occurrences FROM bronze.dim_customers      GROUP BY customer_id       HAVING COUNT(*) > 1
UNION ALL
SELECT 'dim_dates',                        CAST([date] AS NVARCHAR),                COUNT(*)               FROM bronze.dim_dates          GROUP BY [date]            HAVING COUNT(*) > 1
UNION ALL
SELECT 'dim_products',                     product_id,                              COUNT(*)               FROM bronze.dim_products       GROUP BY product_id        HAVING COUNT(*) > 1
UNION ALL
SELECT 'dim_stores',                       store_id,                                COUNT(*)               FROM bronze.dim_stores         GROUP BY store_id          HAVING COUNT(*) > 1
UNION ALL
SELECT 'fact_inventory',                   inventory_id,                            COUNT(*)               FROM bronze.fact_inventory     GROUP BY inventory_id      HAVING COUNT(*) > 1
UNION ALL
SELECT 'fact_marketing_spend',             record_id,                               COUNT(*)               FROM bronze.fact_marketing_spend GROUP BY record_id       HAVING COUNT(*) > 1
UNION ALL
SELECT 'fact_sales',                       transaction_id,                          COUNT(*)               FROM bronze.fact_sales         GROUP BY transaction_id    HAVING COUNT(*) > 1;

-- ==============================================================================
-- STEP 4: RANGE & SANITY CHECK
-- Purpose : Validate that values fall within logical business boundaries.
--           These checks answer the question: "Do the numbers make sense
--           for a retail business?"
--           A Pass means no violations were found.
--           A Fail requires investigation before moving to Silver layer.
-- ==============================================================================

SELECT
    'Negative or Zero Quantity'     AS check_name,
    COUNT(*)                        AS issue_count,
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END AS status
FROM bronze.fact_sales
WHERE quantity <= 0

UNION ALL
SELECT
    'Negative or Zero Revenue',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_sales
WHERE revenue_usd <= 0

UNION ALL
SELECT
    'Negative or Zero Unit Price',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_sales
WHERE unit_price_usd <= 0

UNION ALL
SELECT
    'Discount Percentage Over 100',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_sales
WHERE discount_pct > 100

UNION ALL
SELECT
    -- Note: Negative profit is not necessarily an error in retail.
    -- It may indicate aggressive discounting and will be investigated
    -- during the analysis phase as a potential business problem.
    'Negative Profit (Flagged for Review)',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Review' ELSE 'Review' END
FROM bronze.fact_sales
WHERE profit_usd < 0

UNION ALL
SELECT
    'Sales Date Outside 2023-2024 Range',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_sales
WHERE [date] < '2023-01-01' OR [date] > '2024-12-31'

UNION ALL
SELECT
    'Negative Marketing Spend',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_marketing_spend
WHERE spend_usd <= 0

UNION ALL
SELECT
    'Negative Stock Quantity',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_inventory
WHERE stock_quantity < 0

UNION ALL
SELECT
    'Selling Price Lower Than Cost Price',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.dim_products
WHERE selling_price_usd < cost_price_usd;

-- ==============================================================================
-- STEP 5: REFERENTIAL INTEGRITY CHECK
-- Purpose : Verify that all foreign keys in fact tables have matching records
--           in their corresponding dimension tables.
--           Orphaned records (no match in dimension) will cause incorrect
--           aggregations and must be resolved before analysis begins.
-- ==============================================================================

SELECT
    'fact_sales → dim_stores'       AS check_name,
    COUNT(*)                        AS orphaned_records,
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END AS status
FROM bronze.fact_sales f
LEFT JOIN bronze.dim_stores s ON f.store_id = s.store_id
WHERE s.store_id IS NULL

UNION ALL
SELECT
    'fact_sales → dim_products',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_sales f
LEFT JOIN bronze.dim_products p ON f.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL
SELECT
    'fact_sales → dim_customers',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_sales f
LEFT JOIN bronze.dim_customers c ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL
SELECT
    'fact_sales → dim_dates',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_sales f
LEFT JOIN bronze.dim_dates d ON f.[date] = d.[date]
WHERE d.[date] IS NULL

UNION ALL
SELECT
    'fact_inventory → dim_stores',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_inventory i
LEFT JOIN bronze.dim_stores s ON i.store_id = s.store_id
WHERE s.store_id IS NULL

UNION ALL
SELECT
    'fact_inventory → dim_products',
    COUNT(*),
    CASE WHEN COUNT(*) = 0 THEN 'Pass' ELSE 'Fail' END
FROM bronze.fact_inventory i
LEFT JOIN bronze.dim_products p ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

/*
================================================================================
    END OF EDA SCRIPT
    Next Step: Silver Layer — Data Cleaning & Transformation
================================================================================
*/