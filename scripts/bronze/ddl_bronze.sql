--Bronze layer: Fetching data from source
--First, we'll understand the data and create tables accordingly. 
--But before that we'll check for each table if it exists already. If it does, we'll delete that and recreate that.

if object_id('bronze.crm_cust_info', 'u') is not null
	drop table bronze.crm_cust_info;
go

create table bronze.crm_cust_info(
	cst_id int,
	cst_key varchar(50),
	cst_firstname varchar(50),
	cst_lastname varchar(50),
	cst_marital_status varchar(50),
	cst_gndr varchar(50),
	cst_create_date date
);
go

if object_id('bronze.crm_prd_info', 'u') is not null
	drop table bronze.crm_prd_info;
go

create table bronze.crm_prd_info(
	prd_id int,
	prd_key varchar(50),
	prd_nm varchar(100),
	prd_cost int,
	prd_line varchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
);
go

if object_id('bronze.crm_sales_details', 'u') is not null
	drop table bronze.crm_sales_details;
go

create table bronze.crm_sales_details(
	sls_ord_num varchar(50),
	sls_prd_key varchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);
go

if object_id('bronze.erp_cust_az12', 'u') is not null
	drop table bronze.erp_cust_az12;
go

create table bronze.erp_cust_az12(
	cid varchar(50),
	bdate date,
	gen varchar(50)
);
go

if object_id('bronze.erp_loc_a101', 'u') is not null
	drop table bronze.erp_loc_a101;
go

create table bronze.erp_loc_a101(
	cid varchar(50),
	cntry varchar(50)
);
go

if object_id('bronze.erp_px_cat_g1v2', 'u') is not null
	drop table bronze.erp_px_cat_g1v2;
go

create table bronze.erp_px_cat_g1v2(
	id varchar(50),
	cat varchar(50),
	subcat varchar(50),
	maintenance varchar(50)
);
go
