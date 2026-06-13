
BULK INSERT bronze.dim_customers
FROM 'C:\Projects\p-01_IR_Retail\source_data\dimension\dim_customers.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    TABLOCK
);




BULK INSERT bronze.dim_dates
FROM 'C:\Projects\p-01_IR_Retail\source_data\dimension\dim_dates.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    TABLOCK
);


BULK INSERT bronze.dim_products
FROM 'C:\Projects\p-01_IR_Retail\source_data\dimension\dim_products.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    TABLOCK
);


BULK INSERT bronze.dim_stores
FROM 'C:\Projects\p-01_IR_Retail\source_data\dimension\dim_stores.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    TABLOCK
);


BULK INSERT bronze.fact_inventory
FROM 'C:\Projects\p-01_IR_Retail\source_data\fact\fact_inventory.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    TABLOCK
);


BULK INSERT bronze.fact_marketing_spend
FROM 'C:\Projects\p-01_IR_Retail\source_data\fact\fact_marketing_spend.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    TABLOCK
);

BULK INSERT bronze.fact_sales
FROM 'C:\Projects\p-01_IR_Retail\source_data\fact\fact_sales.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    TABLOCK
);
