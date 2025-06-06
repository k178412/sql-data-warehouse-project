/*
Script: init_database.sql

Purpose:
This script initializes the DataWarehouse database. 
It first checks if an existing database named DataWarehouse is present, deletes it if necessary, and then creates a new database. 
After that, it creates three new schemas: bronze, silver, and gold.

Warnings:
Dropping the database removes all data permanently.
Ensure backup is taken before running this script.
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
