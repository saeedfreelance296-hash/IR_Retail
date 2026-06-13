/*
 ================================================================================================
 Creating Data Base IR Retail DW And Schemas Bronze, Silver and Gold
 ================================================================================================
Script Purpose: 
    The scrip purpose is to create the 'IR_Retail_DW' database and the associated schemas: 
    'bronze', 'silver', and 'gold'.
    This script ensures that any existing database with the same name is dropped before creating a new one, 
    and it sets up the necessary schemas for organizing data within the data warehouse.

WARNING:
    - Ensure that you have the necessary permissions to create and drop databases on the SQL Server instance.
    - Running this script will result in the loss of any existing data in the 'IR_Retail_DW' database if it already exists.
    - Always back up any important data before executing scripts that modify databases.

*/
-- Drop and recreate 'IR_Retail_DW' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'IR_Retail_DW')
BEGIN
    DROP DATABASE IF EXISTS [IR_Retail_DW];
END;
GO

-- -------------------------------------------------------------------------------------------------
PRINT 'Creating Data Base IR Retail DW...';
-- -------------------------------------------------------------------------------------------------
CREATE DATABASE [IR_Retail_DW];
-- -------------------------------------------------------------------------------------------------
PRINT 'Data Base IR Retail DW created successfully.';
-- -------------------------------------------------------------------------------------------------
USE [IR_Retail_DW];
-- -------------------------------------------------------------------------------------------------
PRINT 'Creating Schemas...';
-- -------------------------------------------------------------------------------------------------

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

-- -------------------------------------------------------------------------------------------------
PRINT 'Schemas created successfully.';
-- -------------------------------------------------------------------------------------------------