-- Check For Nulls & Duplicates in The Primnary Keys
-- Expectation: No Nulls and No Duplicates


SELECT
customer_id,
COUNT(*) AS duplicates_count
FROM silver.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;


-- Check For Unwanted spaces
-- Expectation: No Leading or Trailing Spaces
SELECT
TRIM(first_name) AS first_name
FROM silver.dim_customers
WHERE first_name <> TRIM(first_name);

-- Check Data Standardization & consistency
-- Expectation: No results
SELECT DISTINCT
gender
FROM silver.dim_customers;

-- Check For Range & Sanity
-- Expectation: No results
SELECT
age_group
FROM silver.dim_customers
WHERE age_group LIKE '-%'
OR age_group LIKE '100%';


-- Domain Check for email

SELECT DISTINCT
SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) 
FROM silver.dim_customers;


SELECT DISTINCT
is_loyalty_member
FROM silver.dim_customers;

SELECT * FROM silver.dim_customers;