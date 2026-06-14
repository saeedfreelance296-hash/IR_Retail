
/*
================================================================================
    IR RETAIL ANALYTICS PROJECT
    ETL Script — Bronze Layer Load Procedure
================================================================================
    Author       : Saeed Ahmad
    Project      : IR Retail Analytics
    Layer        : Bronze
    Database     : IR_Retail_DW
    Created      : 2025
    Description  : This stored procedure loads all 7 tables in the Bronze layer
                   by truncating existing data and performing a full reload
                   from the source CSV files.
                   
                   The following tables are loaded:
                   Dimension Tables:
                        - bronze.dim_customers
                        - bronze.dim_dates
                        - bronze.dim_products
                        - bronze.dim_stores
                   Fact Tables:
                        - bronze.fact_inventory
                        - bronze.fact_marketing_spend
                        - bronze.fact_sales

    Load Strategy : Full Load (Truncate and Reload)
    Exec Command  : EXEC bronze.load_bronze;
================================================================================
    WARNING: This procedure truncates all Bronze tables before reloading.
             Existing data will be lost on every execution.
================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @startTime DATETIME , @endTime DATETIME, @batch_start_time DATETIME , @batch_end_time DATETIME;
    BEGIN TRY 
        SET @batch_start_time = GETDATE();
        PRINT '==========================================================='
        PRINT 'Loading Bronze layer...'
        PRINT '==========================================================='

        PRINT '-----------------------------------------------------------'
        PRINT 'Loading dimension tables...'
        PRINT '-----------------------------------------------------------'

        SET @startTime =  GETDATE();
        PRINT '>>Truncating Table: dim_customers'
        TRUNCATE TABLE bronze.dim_customers;

        PRINT '>>Inserting Data Into Table: dim_customers'
        BULK INSERT bronze.dim_customers
        FROM 'C:\Projects\p-01_IR_Retail\source_data\dimension\dim_customers.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\r\n',
            TABLOCK
        );
        SET @endTime = GETDATE();
        PRINT 'Loading dim_customers took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'


        SET @startTime =  GETDATE();
        PRINT '>>Truncating Table: dim_dates'
        TRUNCATE TABLE bronze.dim_dates;

        PRINT '>>Inserting Data Into Table: dim_dates'
        BULK INSERT bronze.dim_dates
        FROM 'C:\Projects\p-01_IR_Retail\source_data\dimension\dim_dates.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\r\n',
            TABLOCK
        );
        SET @endTime = GETDATE();
        PRINT 'Loading dim_dates took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'    

        SET @startTime =  GETDATE();
        PRINT '>>Truncating Table: dim_products'
        TRUNCATE TABLE bronze.dim_products;

        PRINT '>>Inserting Data Into Table: dim_products'
        BULK INSERT bronze.dim_products
        FROM 'C:\Projects\p-01_IR_Retail\source_data\dimension\dim_products.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\r\n',
            TABLOCK
        );
        SET @endTime = GETDATE();
        PRINT 'Loading dim_products took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'

        SET @startTime =  GETDATE();
        PRINT '>>Truncating Table: dim_stores'
        TRUNCATE TABLE bronze.dim_stores;

        PRINT '>>Inserting Data Into Table: dim_stores'
        BULK INSERT bronze.dim_stores
        FROM 'C:\Projects\p-01_IR_Retail\source_data\dimension\dim_stores.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\r\n',
            TABLOCK
        );
        SET @endTime = GETDATE();
        PRINT 'Loading dim_stores took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'


        PRINT '-----------------------------------------------------------'
        PRINT 'Loading fact tables...'
        PRINT '-----------------------------------------------------------'
        PRINT '>>Truncating Table: fact_inventory'
        TRUNCATE TABLE bronze.fact_inventory;

        SET @startTime =  GETDATE();
        PRINT '>>Inserting Data Into Table: fact_inventory'
        BULK INSERT bronze.fact_inventory
        FROM 'C:\Projects\p-01_IR_Retail\source_data\fact\fact_inventory.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\r\n',
            TABLOCK
        );
        SET @endTime = GETDATE();
        PRINT 'Loading fact_inventory took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'

        SET @startTime =  GETDATE();
        PRINT '>>Truncating Table: fact_marketing_spend'
        TRUNCATE TABLE bronze.fact_marketing_spend;

        PRINT '>>Inserting Data Into Table: fact_marketing_spend'
        BULK INSERT bronze.fact_marketing_spend
        FROM 'C:\Projects\p-01_IR_Retail\source_data\fact\fact_marketing_spend.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\r\n',
            TABLOCK
        );
        SET @endTime = GETDATE();
        PRINT 'Loading fact_marketing_spend took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'


        SET @startTime =  GETDATE();
        PRINT '>>Truncating Table: fact_sales'
        TRUNCATE TABLE bronze.fact_sales;

        PRINT '>>Inserting Data Into Table: fact_sales'
        BULK INSERT bronze.fact_sales
        FROM 'C:\Projects\p-01_IR_Retail\source_data\fact\fact_sales.csv'
        WITH 
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\r\n',
            TABLOCK
        );
        SET @endTime = GETDATE();
        PRINT 'Loading fact_sales took ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' seconds'
        PRINT '------------------------------------------------------------'
        SET @batch_end_time = GETDATE();
        PRINT '==========================================================='
        PRINT 'Finished loading Bronze layer.'
        PRINT 'Total time taken to load bronze layer is ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds' 
        PRINT '==========================================================='

    END TRY
    BEGIN CATCH 
        PRINT '==================================================================='
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==================================================================='

    END CATCH

END
