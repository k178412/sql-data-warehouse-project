/*
----------------------------------------------------------
Create Database and Schemas
----------------------------------------------------------

Purpose: 
This script will create a new database name 'DataWarehouse' after checking if it already exists. If it does, it will 
drop that first and will recreate that.
Further, this script will create three schemas under the same database named 'bronze', 'silver', and 'gold'.

Warning: 
Running this script will delete the database named 'DataWarehouse' if it exists. This will delete all the data associated 
with it permanently. Proceed with caution and make sure to have the backup before running this script.
*/

use master;
go

--Checking if database already exists with the same name and if it does, deleting then.
if exists(select 1 from sys.databases where name = 'DataWarehouse')
begin
	alter database DataWarehouse set single_user with rollback immediate;
	drop database DataWarehouse;
end;
go

--Create database
create database DataWarehouse;
go

--Use database
use DataWarehouse;
go

--Create schemas
create schema bronze;
go

create schema silver;
go

create schema gold;
go
