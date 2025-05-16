/*
Script: ddl_silver.sql

Purpose:
This script defines and creates the core tables within the silver schema. 
Before creating new structures, it verifies existing tables and removes them to ensure a clean setup.
*/

if object_id('silver.crm_cust_info', 'u') is not null
	drop table silver.crm_cust_info;
go

create table silver.crm_cust_info(
	cst_id int,
	cst_key varchar(50),
	cst_firstname varchar(50),
	cst_lastname varchar(50),
	cst_marital_status varchar(50),
	cst_gndr varchar(50),
	cst_create_date date,
	dwh_create_date datetime2 default getdate()
);
go

if object_id('silver.crm_prd_info', 'u') is not null
	drop table silver.crm_prd_info;
go

create table silver.crm_prd_info(
	prd_id int,
	cat_id varchar(50),
	prd_key varchar(50),
	prd_nm varchar(100),
	prd_cost int,
	prd_line varchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);
go

if object_id('silver.crm_sales_details', 'u') is not null
	drop table silver.crm_sales_details;
go

create table silver.crm_sales_details(
	sls_ord_num varchar(50),
	sls_prd_key varchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date datetime2 default getdate()
);
go

if object_id('silver.erp_cust_az12', 'u') is not null
	drop table silver.erp_cust_az12;
go

create table silver.erp_cust_az12(
	cid varchar(50),
	bdate date,
	gen varchar(50),
	dwh_create_date datetime2 default getdate()
);
go

if object_id('silver.erp_loc_a101', 'u') is not null
	drop table silver.erp_loc_a101;
go

create table silver.erp_loc_a101(
	cid varchar(50),
	cntry varchar(50),
	dwh_create_date datetime2 default getdate()
);
go

if object_id('silver.erp_px_cat_g1v2', 'u') is not null
	drop table silver.erp_px_cat_g1v2;
go

create table silver.erp_px_cat_g1v2(
	id varchar(50),
	cat varchar(50),
	subcat varchar(50),
	maintenance varchar(50),
	dwh_create_date datetime2 default getdate()
);
go
