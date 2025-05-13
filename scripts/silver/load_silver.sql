/*
----------------------------------------------------------
Stored Procedure: Load Data Into Silver Tables (Bronze -> Silver)
----------------------------------------------------------

Purpose: 
This stored procedure performs the ETL (Extract, Transformat, Load) process to populate 'silver' schema tables from the 
'bronze' schema.
It does following things:
	Truncates 'silver' tables.
	Inserts transformed and cleansed data into 'silver' tables.

Parameters:
None.
This stored procedure does not take any parameter or return any value.

Usage Example:
EXEC silver.load_silver;

*CHAR(10): Adds a new line.
*CHAR(9): Adds a tab space.
*/

create or alter procedure silver.load_silver as
begin
	declare @start_time datetime,
		@end_time datetime,
		@batch_start_time datetime,
		@batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
		print '========================================';
		print '          Loading Silver Layer';
		print '========================================';

		print '          Loading CRM Tables';     
		print '----------------------------------------';

		set @start_time = getdate();
		print '> Truncating Table: silver.crm_cust_info';
		truncate table silver.crm_cust_info;
		print '> Inserting Data Into: silver.crm_cust_info';
		insert into silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		select
			cst_id,
			trim(cst_key) as cst_key,
			trim(cst_firstname) as cst_firstname,
			trim(cst_lastname) as cst_lastname,
			case when upper(trim(cst_marital_status)) = 'M' then 'Married'
					  when upper(trim(cst_marital_status)) = 'S' then 'Single'
					  else 'n/a'
			end as cst_marital_status,
			case when upper(trim(cst_gndr)) = 'M' then 'Male'
					  when upper(trim(cst_gndr)) = 'F' then 'Female'
					  else 'n/a'
			end as cst_gndr,
			cst_create_date
		from(
		select
			*,
			row_number() over(partition by cst_id order by cst_create_date desc) as rn
		from bronze.crm_cust_info
		where cst_id is not null)x
		where rn = 1;
		set @end_time = getdate();
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		print '---------------';

		set @start_time = getdate();
		print '> Truncating Table: silver.crm_prd_info';
		truncate table silver.crm_prd_info;
		print '> Inserting Data Into: silver.crm_prd_info';
		insert into silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		select
			prd_id,
			replace(left(prd_key, charindex('-', prd_key, charindex('-', prd_key)+1)-1), '-', '_') as cat_id,
			right(prd_key, len(prd_key)-charindex('-', prd_key, charindex('-', prd_key)+1)) as prd_key,
			trim(prd_nm) as prd_nm,
			coalesce(prd_cost, 0) as prd_cost,
			case when upper(trim(prd_line)) = 'M' then 'Mountain'
					  when upper(trim(prd_line)) = 'R' then 'Road'
					  when upper(trim(prd_line)) = 'S' then 'Other Sales'
					  when upper(trim(prd_line)) = 'T' then 'Touring'
					  else 'n/a'
			end as prd_line,
			cast(prd_start_dt as date) as prd_start_dt,
			cast(dateadd(day, -1, lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)) as date) as prd_end_dt
		from bronze.crm_prd_info;
		set @end_time = getdate();
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		print '---------------';

		set @start_time = getdate();
		print '> Truncating Table: silver.crm_sales_details';
		truncate table silver.crm_sales_details;
		print '> Inserting Data Into: silver.crm_sales_details';
		insert into silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		select
			trim(sls_ord_num) as sls_ord_num,
			trim(sls_prd_key) as sls_prd_key,
			sls_cust_id,
			case when sls_order_dt <= 0 or len(sls_order_dt) != 8 then null
					  else cast(cast(sls_order_dt as varchar) as date)
			end as sls_order_dt,
			case when sls_ship_dt <= 0 or len(sls_ship_dt) != 8 then null
					  else cast(cast(sls_ship_dt as varchar) as date)
			end as sls_ship_dt,
			case when sls_due_dt <= 0 or len(sls_due_dt) != 8 then null
					  else cast(cast(sls_due_dt as varchar) as date)
			end as sls_due_dt,
			case when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * sls_price then sls_quantity * abs(sls_price)
					  else sls_sales
			end as sls_sales,
			sls_quantity,
			case when sls_price <= 0 or sls_price is null then sls_sales/nullif(sls_quantity, 0)
					  else sls_price
			end as sls_price
		from bronze.crm_sales_details;
		set @end_time = getdate();
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';

		print char(10) + '          Loading ERP Tables';     
		print '----------------------------------------';

		set @start_time = getdate();
		print '> Truncating Table: silver.erp_cust_az12';
		truncate table silver.erp_cust_az12;
		print '> Inserting Data Into: silver.erp_cust_az12';
		insert into silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)
		select 
			right(cid, 10) as cid,
			case when bdate > getdate() then null
					  else bdate
			end as bdate,
			case when upper(trim(gen)) in ('M', 'MALE') then 'Male'
					  when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
					  else 'n/a'
			end as gen
		from bronze.erp_cust_az12;
		set @end_time = getdate();
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		print '---------------';

		set @start_time = getdate();
		print '> Truncating Table: silver.erp_loc_a101';
		truncate table silver.erp_loc_a101;
		print '> Inserting Data Into: silver.erp_loc_a101';
		insert into silver.erp_loc_a101 (
			cid,
			cntry
		)
		select
			replace(cid, '-', '') as cid,
			case when trim(cntry) = 'DE' then 'Germany'
					  when trim(cntry) in ('US', 'USA') then 'United States'
					  when trim(cntry) is null or trim(cntry) = '' then 'n/a'
					  else trim(cntry)
			end as cntry
		from bronze.erp_loc_a101;
		set @end_time = getdate();
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		print '---------------';

		set @start_time = getdate();
		print '> Truncating Table: silver.erp_px_cat_g1v2';
		truncate table silver.erp_px_cat_g1v2;
		print '> Inserting Data Into: silver.erp_px_cat_g1v2';
		insert into silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
		)
		select
			trim(id) as id,
			trim(cat) as cat,
			trim(subcat) as subcat,
			trim(maintenance) as maintenance
		from bronze.erp_px_cat_g1v2;
		set @end_time = getdate();
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';

		set @batch_end_time = getdate();
		print '========================================';
		print 'Silver Layer Loading Is Completed';
		print 'Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as varchar) + ' second(s)';
		print '========================================';
	end try
	begin catch
		print '========================================';
		print 'Error Occured During Loading Silver Layer';
		print 'Error Message: ' + error_message();
		print 'Error Number: ' + cast(error_number() as varchar);
		print 'Error State: ' + cast(error_state() as varchar);
		print '========================================';
	end catch
end;
