

-- =======================================================================
-- Truncating & Inserting  cleaned data into silver.dim_customers
TRUNCATE TABLE silver.dim_customers;
GO
INSERT INTO silver.dim_customers(
    customer_id,
    first_name,
    last_name,
    full_name,
    gender,
    age_group,
    region_code,
    country,
    customer_segment,
    join_date,
    email,
    is_loyalty_member
)

-- Cleaning and transforming data from bronze.dim_customers
SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) As last_name,
    TRIM(full_name) AS full_name,
    TRIM(gender) AS gender,
    age_group,
    UPPER(region_code) AS region_code,
    TRIM(country) As country,
    TRIM(customer_segment) As customer_segment,
    join_date,
    lower(email) AS email,
    is_loyalty_member

FROM bronze.dim_customers;

-- =============================================================================
-- Truncating & Inserting cleaned into silver.dim_dates
TRUNCATE TABLE silver.dim_dates;
GO
INSERT INTO silver.dim_dates(
    [date],
    [year],
    [quarter],
    [month],
    month_name,
    [week],
    day_of_week,
    day_name,
    is_weekend,
    is_month_end,
    fiscal_year,
    fiscal_quarter,
    is_holiday,
    holiday_name

)


-- Cleaning and transforming data from bronze.dim_dates
SELECT
    [date] AS [date],
    [year] AS [year],
    [quarter] As [quarter],
    [month] AS [month],
    TRIM(month_name) AS month_name,
    [week] AS [week],
    day_of_week AS day_of_week,
    TRIM(day_name) AS day_name,
    is_weekend  AS is_weekend,
    is_month_end AS is_month_end,
    fiscal_year,
    ROUND(fiscal_quarter,0) AS fiscal_quarter,
    is_holiday,
    ISNULL(holiday_name, 'n/a') AS holiday_name
FROM bronze.dim_dates;


-- =============================================================================
-- Truncating & Inserting cleaned into silver.dim_dates
TRUNCATE TABLE silver.dim_products;
GO
INSERT INTO silver.dim_products(
    product_id,
    product_name,
    category,
    category_code,
    cost_price_usd,
    selling_price_usd,
    gross_margin_pct,
    is_perishable
)

-- Cleaning and transforming data from bronze.dim_products
SELECT 
    product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    UPPER(category_code) AS category_code,
    ROUND(cost_price_usd, 3) AS cost_price,
    ROUND(selling_price_usd, 3) AS selling_price,
    ROUND(gross_margin_pct, 3) AS gross_margin_pct,
    is_perishable

FROM bronze.dim_products;


-- =============================================================================
-- Truncating & Inserting cleaned into silver.dim_stores
TRUNCATE TABLE silver.dim_stores;
GO
INSERT INTO silver.dim_stores (
    store_id,
    store_name,
    region_code,
    country,
    city,
    currency,
    usd_rate,
    store_format,
    market_maturity,
    opening_year,
    total_floor_sqm

)


-- Cleaning and transforming data from bronze.dim_stores
SELECT
    store_id,
    TRIM(store_name) AS store_name,
    UPPER(region_code) AS region_code,
    TRIM(country) AS country,
    TRIM(city) AS city,
    UPPER(currency) AS currency,
    ROUND(usd_rate, 3) AS usd_rate,
    TRIM(store_format) AS store_format,
    market_maturity,
    opening_year,
    total_floor_sqm 
FROM bronze.dim_stores;

-- =============================================================================
-- Truncating & Inserting cleaned into silver.fact_inventory
INSERT INTO silver.fact_inventory (
    inventory_id,
    store_id,
    region_code,
    product_id,
    category,
    stock_quantity,
    reorder_point,
    days_cover,
    last_restock_date,
    is_low_stock,
    is_ghost_stock,
    monthly_cost_of_carry_usd
)

-- Cleaning and transforming data from bronze.fact_inventory
SELECT
    inventory_id,
    store_id,
    UPPER(region_code) AS region_code,
    product_id,
    TRIM(category) AS category,
    stock_quantity,
    reorder_point,
    days_cover,
    last_restock_date,
    is_low_stock,
    is_ghost_stock,
    ROUND(monthly_cost_of_carry_usd, 3) AS monthly_cost_of_carry_usd

FROM bronze.fact_inventory;

-- =============================================================================
-- Truncating & Inserting cleaned into silver.fact_marketing_spend
TRUNCATE TABLE silver.fact_marketing_spend;
GO
INSERT INTO silver.fact_marketing_spend (
    record_id,
    region_code,
    country,
    [year],
    [month],
    channel,
    spend_usd,
    spend_local,
    currency

)
-- Cleaning and transforming data from bronze.fact_marketing_spend
SELECT
    record_id,
    region_code,
    TRIM(country) AS country,
    year,
    month,
    TRIM(channel) AS channel,
    ROUND(spend_usd, 3) AS spend_usd,
    ROUND(spend_local, 3) AS spend_local,
    UPPER(currency) AS currency

FROM bronze.fact_marketing_spend;

-- =============================================================================
-- Truncating & Inserting cleaned into silver.fact_sales
TRUNCATE TABLE silver.fact_sales;
GO
INSERT INTO silver.fact_sales (
    transaction_id,
    [date],
    [year],
    [month],
    [quarter],
    store_id,
    region_code,
    customer_id,
    product_id,
    category,
    quantity,
    unit_price_usd,
    unit_price_local,
    discount_pct,
    discount_amount_usd,
    revenue_usd,
    revenue_local,
    cost_usd,
    profit_usd,
    currency,
    is_return_purchase,
    payment_method
)


-- Cleaning and transforming data from bronze.fact_sales
SELECT
    transaction_id,
    [date],
    [year],
    [month],
    ROUND([quarter], 0) AS [quarter],
    store_id,
    UPPER(region_code) AS region_code,
    customer_id,
    product_id,
    TRIM(category) AS category,
    quantity,
    ROUND(unit_price_usd, 3) AS unit_price_usd,
    ROUND(unit_price_local, 3) AS unit_price_local,
    discount_pct,
    ROUND(discount_amount_usd, 3) AS  discount_amount_usd,
    ROUND(revenue_usd, 3) AS revenue_usd,
    ROUND(revenue_local, 3) AS revenue_local,
    ROUND(cost_usd, 3) AS cost_usd,
    ROUND(profit_usd, 3) AS profit_usd,
    UPPER(currency) AS currency,
    is_return_purchase,
    payment_method

FROM bronze.fact_sales;