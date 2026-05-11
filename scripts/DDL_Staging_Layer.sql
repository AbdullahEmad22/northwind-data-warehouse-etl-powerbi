-- =============================================================================
-- DDL Script: Northwind Staging Database (Raw Data Layer)
-- =============================================================================

USE master;
GO

-- Create the 'NORTHWIND_STAGING_DB' database
CREATE DATABASE NORTHWIND_STAGING_DB;
GO

USE NORTHWIND_STAGING_DB;
GO

-- Create the 'stg' schema
CREATE SCHEMA stg;
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.categories;
GO

CREATE TABLE stg.categories(
	category_id INT,
	category_name NVARCHAR(15),
	description NTEXT,
	picture IMAGE,
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.customer_customer_demo;
GO

CREATE TABLE stg.customer_customer_demo(
	customer_id NCHAR(5),
	customer_type_id NCHAR(10),
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.customer_demographics;
GO

CREATE TABLE stg.customer_demographics(
	customer_type_id NCHAR(10),
	customer_desc NTEXT,
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.customers;
GO

CREATE TABLE stg.customers(
	customer_id NCHAR(5),
	company_name NVARCHAR(40),
	contact_name NVARCHAR(30),
	contact_title NVARCHAR(30),
	address NVARCHAR(60),
	city NVARCHAR(15),
	region NVARCHAR(15),
	postal_code NVARCHAR(10),
	country NVARCHAR(15),
	phone NVARCHAR(24),
	fax NVARCHAR(24),
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.employees;
GO

CREATE TABLE stg.employees(
	employee_id INT,
	last_name NVARCHAR(20),
	first_name NVARCHAR(10),
	title NVARCHAR(30),
	title_of_courtesy NVARCHAR(25),
	birth_date DATETIME,
	hire_date DATETIME,
	address NVARCHAR(60),
	city NVARCHAR(15),
	region NVARCHAR(15),
	postal_code NVARCHAR(10),
	country NVARCHAR(15),
	home_phone NVARCHAR(24),
	extension NVARCHAR(4),
	photo IMAGE,
	notes NTEXT,
	reports_to INT,
	photo_path NVARCHAR(255),
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.employee_territories;
GO

CREATE TABLE stg.employee_territories(
	employee_id INT,
	territory_id NVARCHAR(20),
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.order_details;
GO

CREATE TABLE stg.order_details(
	order_id INT,
	product_id INT,
	unit_price MONEY,
	quantity SMALLINT,
	discount REAL,
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.orders;
GO

CREATE TABLE stg.orders(
	order_id INT,
	customer_id NCHAR(5),
	employee_id INT,
	order_date DATETIME,
	required_date DATETIME,
	shipped_date DATETIME,
	ship_via INT,
	freight MONEY,
	ship_name NVARCHAR(40),
	ship_address NVARCHAR(60),
	ship_city NVARCHAR(15),
	ship_region NVARCHAR(15),
	ship_postal_code NVARCHAR(10),
	ship_country NVARCHAR(15),
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.products;
GO

CREATE TABLE stg.products(
	product_id INT,
	product_name NVARCHAR(40),
	supplier_id INT,
	category_id INT,
	quantity_per_unit NVARCHAR(20),
	unit_price MONEY,
	units_in_stock SMALLINT,
	units_on_order SMALLINT,
	reorder_level SMALLINT,
	discontinued BIT,
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.region;
GO

CREATE TABLE stg.region(
	region_id INT,
	region_description NCHAR(50),
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.shippers;
GO

CREATE TABLE stg.shippers(
	shipper_id INT,
	company_name  NVARCHAR(40),
	phone NVARCHAR(24),
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.suppliers;
GO

CREATE TABLE stg.suppliers(
	supplier_id INT,
	company_name NVARCHAR(40),
	contact_name NVARCHAR(30),
	contact_title NVARCHAR(30),
	address NVARCHAR(60),
	city NVARCHAR(15),
	region NVARCHAR(15),
	postal_code NVARCHAR(10),
	country NVARCHAR(15),
	phone NVARCHAR(24),
	fax NVARCHAR(24),
	home_page NTEXT,
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
DROP TABLE IF EXISTS stg.territories;
GO

CREATE TABLE stg.territories(
	territory_id NVARCHAR(20),
	territory_description NCHAR(50),
	region_id INT,
	stg_insert_date DATETIME2 DEFAULT GETDATE()
);
GO
