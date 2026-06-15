

-- Check For Nulls & Duplicates in The Primnary Keys
-- And range and sanity check 
-- Expectation: No Nulls and No Duplicates and dates lies with in the real range



SELECT
holiday_name,
ISNULL(holiday_name, 'n/a')
FROM bronze.dim_dates

SELECT * FROM silver.dim_dates;


-- Check For Unwanted spaces
-- Expectation: No Leading or Trailing Spaces
SELECT
TRIM(first_name) AS first_name
FROM bronze.dim_customers
WHERE first_name <> TRIM(first_name);

-- Check Data Standardization & consistency
-- Expectation: No results
SELECT DISTINCT
gender
FROM bronze.dim_customers;

-- Check For Range & Sanity
-- Expectation: No results
SELECT
age_group
FROM bronze.dim_customers
WHERE age_group LIKE '-%'
OR age_group LIKE '100%';


-- Domain Check for email

SELECT DISTINCT
SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) 
FROM bronze.dim_customers;


SELECT DISTINCT
is_loyalty_member
FROM bronze.dim_customers;