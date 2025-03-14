
-- Check for Nulls or Duplicates in Primary Key
--Exception : No Result

SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;

-- Checks for unwanted Spaces
-- Expectation : No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Data Standardization & Cnsistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;


SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT * FROM silver.crm_cust_info;

/* Product table
*/

/* Product table */

SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL;

-- Check for unwanted spaces
-- Exception: No results

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- Check for NULLS or Negative NUmbers
-- Exception: No Result

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost<0 OR prd_cost IS NULL; 

-- Data Standardization & Consistency

SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
SELECT * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT * FROM silver.crm_prd_info;

/* Sales Table*/

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);





-- Check for Invalid date orders 

SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt



-- Check Data Consistency : Between sales , Quantity and price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL,zero or negative.

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales,sls_quantity,sls_price;


SELECT *  FROM silver.crm_sales_details


/* ERP customer table */

SELECT

CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
END AS cid,
bdate,
gen
FROM silver.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
		
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

SELECT * FROM silver.crm_cust_info;


-- Identify out-of-Range Dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency
SELECT DISTINCT
 gen
		
FROM silver.erp_cust_az12

-- ERP location table

-- Data standardization & Consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;

SELECT * FROM silver.erp_loc_a101;

SELECT * FROM silver.erp_px_cat_g1v2;
