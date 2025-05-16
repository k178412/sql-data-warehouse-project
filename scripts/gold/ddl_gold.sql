/*
Script: ddl_gold.sql

Purpose:
This script defines views in the gold schema, which holds final dimension and fact tables following the 
Star Schema approach. 
These views transform and combine data from the silver schema into structured datasets ready for analytics and reporting.

Key Features:
	Builds clean, structured, business-ready datasets for reporting.
	Establishes dimension tables (dim_customers, dim_products) for analysis.
	Creates a fact table (fact_sales) with transactional details.

This prepares the gold layer for streamlined querying and analytics.
*/

if objectid(gold.dim_customers, 'v') is not null
	drop view gold.dim_customers;
go
create or alter view gold.dim_customers as
select
	row_number() over(order by c.cst_id) as customer_key,
	c.cst_id as customer_id,
	c.cst_key as customer_number,
	c.cst_firstname as first_name,
	c.cst_lastname as last_name,
	case when c.cst_gndr != 'n/a' then c.cst_gndr
			  else coalesce(b.gen, 'n/a')
	end as gender,
	c.cst_marital_status as marital_status,
	b.bdate as birth_date,
	l.cntry as country,
	c.cst_create_date as create_date
from silver.crm_cust_info c
left join silver.erp_cust_az12 b on c.cst_key = b.cid
left join silver.erp_loc_a101 l on c.cst_key = l.cid;
go

if objectid(gold.dim_products, 'v') is not null
	drop view gold.dim_products;
go
create or alter view gold.dim_products as
select
	row_number() over(order by p.prd_start_dt, p.prd_key) as product_key,
	p.prd_id as product_id,
	p.prd_key as product_number,
	p.prd_nm as product_name,
	p.cat_id category_id,
	c.cat as category_name,
	c.subcat as subcategory,
	c.maintenance,
	p.prd_cost as cost,
	p.prd_line as product_line,
	p.prd_start_dt as start_date
from silver.crm_prd_info p
left join silver.erp_px_cat_g1v2 c on p.cat_id = c.id
where p.prd_end_dt is null;
go

if objectid(gold.fact_sales, 'v') is not null
	drop view gold.fact_sales;
go
create or alter view gold.fact_sales as
select
	sls_ord_num as order_number,
	p.product_key,
	c.customer_key,
	sls_order_dt as order_date,
	sls_ship_dt as ship_date,
	sls_due_dt as due_date,
	sls_sales as sales_amount,
	sls_quantity as quantity,
	sls_price as price
from silver.crm_sales_details s
left join gold.dim_customers c on s.sls_cust_id = c.customer_id
left join gold.dim_products p on s.sls_prd_key = p.product_number;
go
