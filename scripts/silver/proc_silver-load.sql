/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    DDL Script — Silver Layer
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Silver
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This script creates all 7 tables in the Silver layer.
                   Silver layer contains cleaned, standardized and properly
                   typed data transformed from the Bronze layer.
                   
                   Dimension Tables:
                        - silver.dim_customers
                        - silver.dim_dates
                        - silver.dim_products
                        - silver.dim_stores
                   Fact Tables:
                        - silver.fact_inventory
                        - silver.fact_marketing_spend
                        - silver.fact_sales

    Load Strategy : Full Load (Drop and Recreate)
================================================================================
    WARNING: This script drops and recreates all Silver tables.
             Existing data will be lost on every execution.
================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS  
BEGIN 
    DECLARE @startTime DATETIME, @endTime DATETIME, @batch_startTime DATETIME, @batch_endTime DATETIME;
    BEGIN TRY
    SET @batch_startTime = GETDATE();
     PRINT '==========================================================='
     PRINT 'Loading silver layer...'
     PRINT '==========================================================='
    
    PRINT '-----------------------------------------------------------'
    PRINT 'Loading dimension tables...'
    PRINT '-----------------------------------------------------------'

    SET @startTime =  GETDATE();
    PRINT '>> Truncating & Inserting  cleaned data into silver.dim_customers'
    TRUNCATE TABLE silver.dim_customers;

    PRINT 'Inserting Data Into: silver.dim_customers'
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
    SELECT * FROM  silver.dim_customers

    SET @endTime = GETDATE();
        PRINT 'Loading dim_customers took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'

    SET @startTime =  GETDATE();
    PRINT '>> Truncating & Inserting cleaned into silver.dim_dates'
    TRUNCATE TABLE silver.dim_dates;

    PRINT 'Inserting Data Into: silver.dim_dates'
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

    SET @endTime = GETDATE();
        PRINT 'Loading dim-dates took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'

    SET @startTime =  GETDATE();
    PRINT '>> Truncating & Inserting cleaned into silver.dim_products'
    TRUNCATE TABLE silver.dim_products;

    PRINT 'Inserting Data Into: silver.dim_products'
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

    SET @endTime = GETDATE();
        PRINT 'Loading dim_products took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'

    SET @startTime =  GETDATE();
    PRINT '>> Truncating & Inserting cleaned into silver.dim_stores'
    TRUNCATE TABLE silver.dim_stores;

    PRINT 'Inserting Data Into: silver.dim_stores'
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

    
        PRINT '-----------------------------------------------------------'
        PRINT 'Loading fact tables...'
        PRINT '-----------------------------------------------------------'    
    SET @endTime = GETDATE();
        PRINT 'Loading dim_stores took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'
    SET @startTime =  GETDATE();
    PRINT '>>  Truncating & Inserting cleaned into silver.fact_inventory'
    TRUNCATE TABLE silver.fact_inventory;

    PRINT 'Inserting Data Into: silver.fact_inventory'
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

     SET @endTime = GETDATE();
        PRINT 'Loading fact_inventory took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'

    SET @startTime =  GETDATE();
    PRINT '>> Truncating & Inserting cleaned into silver.fact_marketing_spend'
    TRUNCATE TABLE silver.fact_marketing_spend;

    PRINT 'Inserting Data Into: silver.fact_marketing-spend'
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

     SET @endTime = GETDATE();
        PRINT 'Loading fact_marketing_spend took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'

    SET @startTime =  GETDATE();
    PRINT '>> Truncating & Inserting cleaned into silver.fact_sales'
    TRUNCATE TABLE silver.fact_sales;

    PRINT 'Inserting Data Into: silver.fact-sales'
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
        product_name,
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
        TRIM(product_name) AS product_name,
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


    SET @endTime = GETDATE();
        PRINT 'Loading fact_sales took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'
        SET @batch_endTime = GETDATE();
        PRINT '==========================================================='
        PRINT 'Finished loading silver layer.'
        PRINT 'Total time taken to load silver layer is ' + CAST(DATEDIFF(SECOND, @batch_startTime, @batch_endTime) AS NVARCHAR) + ' seconds' 

        PRINT '==========================================================='

        END TRY
        BEGIN CATCH
        PRINT '==================================================================='
        PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==================================================================='
        END CATCH
END


