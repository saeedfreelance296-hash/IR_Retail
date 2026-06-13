/*
===================================================================================================
DDL Script for Bronze Layer
===================================================================================================

Script Purpose:
This script creates the necessary tables in the Bronze layer of the data warehouse after checking and dropping
existing tables. 
The Bronze layer serves as the raw data storage area where data is ingested in its original form
before any transformations are applied. The tables created in this script include dimension tables
for customers, dates, products, and stores, as well as fact tables for inventory, marketing spend, 
and sales transactions.

WARNING: This script will drop existing tables if they exist, which will result in data loss.
*/

-- Create schema if it doesn't exist
-- Note: The schema creation is optional and can be adjusted based on your database design


-- DROP and CREATE tables for Bronze layer
-- Creating dimension tables
IF OBJECT_ID('bronze.dim_customers', 'U') IS NOT NULL
    DROP TABLE bronze.dim_customers;
CREATE TABLE bronze.dim_customers (
    customer_id NVARCHAR(50) PRIMARY KEY,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    full_name NVARCHAR(200),
    gender NVARCHAR(10),
    age_group NVARCHAR(50),
    region_code NVARCHAR(10),
    country NVARCHAR(100),
    customer_segment NVARCHAR(50),
    join_date DATE,
    email NVARCHAR(100),
    is_loyalty_member BIT

) ;

IF OBJECT_ID('bronze.dim_dates', 'U') IS NOT NULL
    DROP TABLE bronze.dim_dates;
CREATE TABLE bronze.dim_dates (
    date DATE PRIMARY KEY,
    year INT,
    quarter INT,
    month INT,
    month_name NVARCHAR(20),
    week INT,
    day_of_week INT,
    day_name NVARCHAR(20),
    is_weekend BIT,
    is_month_end BIT,
    fiscal_year INT,
    fiscal_quarter INT,
    is_holiday BIT,
    holiday_name NVARCHAR(100)

) ;

IF OBJECT_ID('bronze.dim_products', 'U') IS NOT NULL
    DROP TABLE bronze.dim_products;
CREATE TABLE bronze.dim_products (
    product_id NVARCHAR(50) PRIMARY KEY,
    product_name NVARCHAR(100),
    category NVARCHAR(100),
    category_code NVARCHAR(10),
    cost_price_usd DECIMAL(10, 2),
    selling_price_usd DECIMAL(10, 2),
    gross_margin_pct DECIMAL(5, 2),
    is_perishable BIT
    
) ;

IF OBJECT_ID('bronze.dim_stores', 'U') IS NOT NULL
    DROP TABLE bronze.dim_stores;
CREATE TABLE bronze.dim_stores (
   store_id NVARCHAR(50) PRIMARY KEY,
   store_name NVARCHAR(100),
   region_code NVARCHAR(10),
   country NVARCHAR(100),
   city NVARCHAR(100),
   currency NVARCHAR(3),
   usd_rate DECIMAL(10, 2),
   store_format NVARCHAR(50),
   market_maturity NVARCHAR(50),
   opening_year INT,
   total_floor_sqm DECIMAL(10, 2)

) ;

-- Creating fact tables

IF OBJECT_ID('bronze.fact_inventory', 'U') IS NOT NULL
    DROP TABLE bronze.fact_inventory;
CREATE TABLE bronze.fact_inventory (
    inventory_id NVARCHAR(50) PRIMARY KEY,
    store_id NVARCHAR(50),
    region_code NVARCHAR(10),
    product_id NVARCHAR(50),
    category NVARCHAR(100),
    stock_quantity INT,
    reorder_point INT,
    days_cover INT,
    last_restock_date DATE,
    is_low_stock BIT,
    is_ghost_stock BIT,
    monthly_cost_of_carry_usd DECIMAL(10, 2)

);

IF OBJECT_ID('bronze.fact_marketing_spend', 'U') IS NOT NULL
    DROP TABLE bronze.fact_marketing_spend;
CREATE TABLE bronze.fact_marketing_spend (
    record_id NVARCHAR(50) PRIMARY KEY,
    region_code NVARCHAR(10),
    country NVARCHAR(100),
    year INT,
    month INT,
    channel NVARCHAR(50),
    spend_usd DECIMAL(10, 2),
    spend_local DECIMAL(10, 2),
    currency NVARCHAR(3)

);

IF OBJECT_ID('bronze.fact_sales', 'U') IS NOT NULL
    DROP TABLE bronze.fact_sales;
CREATE TABLE bronze.fact_sales (
    transaction_id NVARCHAR(50) PRIMARY KEY,
    date DATE,
    year INT,
    month INT,
    quarter NVARCHAR(10),
    store_id NVARCHAR(50),
    region_code NVARCHAR(10),
    customer_id NVARCHAR(50),
    product_id NVARCHAR(50),
    product_name NVARCHAR(100),
    category NVARCHAR(100),
    quantity INT,
    unit_price_usd DECIMAL(10, 2),
    unit_price_local DECIMAL(10, 2),
    discount_pct DECIMAL(5, 2),
    discount_amount_usd DECIMAL(10, 2),
    revenue_usd DECIMAL(10, 2),
    revenue_local DECIMAL(10, 2),
    cost_usd DECIMAL(10, 2),
    profit_usd DECIMAL(10, 2),
    currency NVARCHAR(3),
    is_return_purchase BIT,
    payment_method NVARCHAR(50)
    
) ;

