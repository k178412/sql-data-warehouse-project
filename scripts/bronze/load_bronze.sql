/*
Script: load_bronze.sql

Purpose:
This stored procedure automates the data loading process into the bronze tables from external CSV files. 
It follows a systematic approach to ensure a clean and efficient load.

Process Overview:
	Clears existing data by truncating tables.
	Bulk inserts data from structured CSV sources.
	Logs execution details, including processing time and error handling.

Execution & Error Handling:
	Captures start and end timestamps for performance tracking.
	Provides status messages throughout execution.
	Implements error handling to log failures efficiently.

This procedure ensures a reliable data ingestion process within the bronze layer.

Usage Example:
	EXEC bronze.load_bronze;

*CHAR(10): Adds a new line.
*CHAR(9): Adds a tab space.
*/

create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime,
		@end_time datetime,
		@batch_start_time datetime,
		@batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
		print '========================================';
		print '          Loading Bronze Layer';
		print '========================================';

		print '          Loading CRM Tables';     
		print '----------------------------------------';

		set @start_time = getdate();
		print '> Truncating table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;
		print '> Inserting data into: bronze.crm_cust_info';
		bulk insert  bronze.crm_cust_info
		from 'D:\Skills\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' 
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '\n'
		);
		set @end_time = getdate()
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		print '---------------';

		set @start_time = getdate();
		print '> Truncating table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		print '> Inserting data into: bronze.crm_prd_info';
		bulk insert  bronze.crm_prd_info
		from 'D:\Skills\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' 
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '\n'
		);
		set @end_time = getdate()
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		print '---------------';

		set @start_time = getdate();
		print '> Truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		print '> Inserting data into: bronze.crm_sales_details';
		bulk insert  bronze.crm_sales_details
		from 'D:\Skills\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' 
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '\n'
		);
		set @end_time = getdate()
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';

		print char(10) + '          Loading ERP Tables';
		print '----------------------------------------';

		set @start_time = getdate();
		print '> Truncating table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;
		print '> Inserting data into: bronze.erp_cust_az12';
		bulk insert  bronze.erp_cust_az12
		from 'D:\Skills\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv' 
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '\n'
		);
		set @end_time = getdate()
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		print '---------------';

		set @start_time = getdate();
		print '> Truncating table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		print '> Inserting data into: bronze.erp_loc_a101';
		bulk insert  bronze.erp_loc_a101
		from 'D:\Skills\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv' 
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '\n'
		);
		set @end_time = getdate()
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		print '---------------';

		set @start_time = getdate();
		print '> Truncating table: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;
		print '> Inserting data into: bronze.erp_px_cat_g1v2';
		bulk insert  bronze.erp_px_cat_g1v2
		from 'D:\Skills\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv' 
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '\n'
		);
		set @end_time = getdate()
		print 'Load Duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' second(s)';
		
		set @batch_end_time = getdate();
		print char(10) + '========================================';
		print 'Bronze Layer Loading Is Completed';
		print 'Total Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as varchar) + ' second(s)';
		print '========================================';
	end try
	begin catch
		print '========================================';
		print 'Error Occured During Loading Bronze Layer';
		print 'Error_Message: ' + error_message();
		print 'Error_Number: ' + cast(error_number() as varchar);
		print 'Error_State: ' + cast(error_state() as varchar);
		print '========================================';
	end catch
end;
