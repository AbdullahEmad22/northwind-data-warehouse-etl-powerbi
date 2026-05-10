-- =============================================================================
-- DDL Script: Northwind Data Warehouse (Star Schema & Date Dimension)
-- =============================================================================

USE master;
GO

-- Create the 'NORTHWIND_DWH' database
CREATE DATABASE NORTHWIND_DWH;
GO

USE NORTHWIND_DWH;
GO

-- Create the 'dwh' schema
CREATE SCHEMA dwh;
GO

-- =============================================================================
-- Create Dimension Table: dwh.dim_customers
-- =============================================================================
DROP TABLE IF EXISTS dwh.dim_customers;
GO

CREATE TABLE dwh.dim_customers(
	customer_key INT IDENTITY(1,1) PRIMARY KEY,		-- Surrogate key
	customer_id NVARCHAR(10) NOT NULL,				-- Business key (Natural Key)
	company_name NVARCHAR(50) NOT NULL,
	city NVARCHAR(50),
	region NVARCHAR(50),
	country NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- Create Dimension Table: dwh.dim_shippers
-- =============================================================================
DROP TABLE IF EXISTS dwh.dim_shippers;
GO

CREATE TABLE dwh.dim_shippers(
	shipper_key INT IDENTITY(1,1) PRIMARY KEY,		-- Surrogate key
	shipper_id INT NOT NULL,						-- Business key (Natural Key)
	company_name NVARCHAR(50) NOT NULL,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- Create Dimension Table: dwh.dim_suppliers
-- =============================================================================
DROP TABLE IF EXISTS dwh.dim_suppliers;
GO

CREATE TABLE dwh.dim_suppliers(
	supplier_key INT IDENTITY(1,1) PRIMARY KEY,		-- Surrogate key
	supplier_id INT NOT NULL,						-- Business key (Natural Key)
	company_name NVARCHAR(50) NOT NULL,
	city NVARCHAR(50),
	region NVARCHAR(50),
	country NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- Create Dimension Table: dwh.dim_products
-- =============================================================================
DROP TABLE IF EXISTS dwh.dim_products;
GO

CREATE TABLE dwh.dim_products(
	product_key INT IDENTITY(1,1) PRIMARY KEY,		-- Surrogate key
	product_id INT NOT NULL,						-- Business key (Natural Key)
	product_name NVARCHAR(50) NOT NULL,
	category_name NVARCHAR(50) NOT NULL,
	quantity_per_unit NVARCHAR(50),
	unit_price DECIMAL(10,2),
	units_in_stock SMALLINT,
	units_on_order SMALLINT,
	reorder_level SMALLINT,
	discontinued BIT NOT NULL,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- Create Dimension Table: dwh.dim_employees
-- =============================================================================
DROP TABLE IF EXISTS dwh.dim_employees;
GO

CREATE TABLE dwh.dim_employees(
	employee_key INT IDENTITY(1,1) PRIMARY KEY,		-- Surrogate key
	employee_id INT NOT NULL,						-- Business key (Natural Key)
	last_name NVARCHAR(50) NOT NULL,
	first_name NVARCHAR(50) NOT NULL,
	title NVARCHAR(50),
	birth_date DATE,
	hire_date DATE,
	city NVARCHAR(50),
	region NVARCHAR(50),
	country NVARCHAR(50),
	reports_to INT,
	manager_name NVARCHAR(100),						-- Derived from self-join (reports_to)
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- Create Dimension Table: dwh.dim_ship_info
-- =============================================================================
DROP TABLE IF EXISTS dwh.dim_ship_info;
GO

CREATE TABLE dwh.dim_ship_info(
	ship_info_key INT IDENTITY(1,1) PRIMARY KEY,	-- Surrogate key
	ship_city NVARCHAR(50),
	ship_region NVARCHAR(50),
	ship_country NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- Create Dimension Table: dwh.dim_date
-- =============================================================================
DROP TABLE IF EXISTS dwh.dim_date;
GO

CREATE TABLE dwh.dim_date(
	date_key INT PRIMARY KEY,		-- Surrogate key (YYYYMMDD)
	full_date DATE NOT NULL,
	year INT NOT NULL,
	quarter SMALLINT NOT NULL,
	month SMALLINT NOT NULL,
	month_name NVARCHAR(50) NOT NULL,
	week_of_year SMALLINT NOT NULL,
	day_of_month SMALLINT NOT NULL,
	day_name NVARCHAR(50) NOT NULL,
	is_weekend BIT NOT NULL
);
GO

-- =============================================================================
-- Script: Populate Date Dimension (dwh.dim_date)
-- =============================================================================
DECLARE @start_date DATE = '1990-01-01';
DECLARE @end_date DATE = '2030-12-31';

WHILE @start_date <= @end_date
BEGIN
	INSERT INTO dwh.dim_date (
		date_key,
		full_date,
		year,
		quarter,
		month,
		month_name,
		week_of_year,
		day_of_month,
		day_name,
		is_weekend
	)
	SELECT
		CAST(FORMAT(@start_date, 'yyyyMMdd') AS INT),
		@start_date,
		YEAR(@start_date),
		DATEPART(QUARTER, @start_date),
		MONTH(@start_date),
		DATENAME(MONTH, @start_date),
		DATEPART(WEEK, @start_date),
		DAY(@start_date),
		DATENAME(WEEKDAY, @start_date),
		CASE
			WHEN DATENAME(WEEKDAY, @start_date) IN ('Saturday', 'Sunday') THEN 1
			ELSE 0
		END;

	SET @start_date = DATEADD(DAY, 1, @start_date);
END;
GO

-- =============================================================================
-- Create Fact Table: dwh.fact_sales
-- =============================================================================
DROP TABLE IF EXISTS dwh.fact_sales;
GO

CREATE TABLE dwh.fact_sales(
	order_id INT NOT NULL,
	customer_key INT NOT NULL,
	shipper_key INT NOT NULL,
	supplier_key INT NOT NULL,
	product_key INT NOT NULL,
	employee_key INT NOT NULL,
	ship_info_key INT NOT NULL,
	order_date_key INT NOT NULL,
	required_date_key INT,
	shipped_date_key INT,
	freight DECIMAL(10,2),
	quantity SMALLINT NOT NULL,
	unit_price DECIMAL(10,2) NOT NULL,
	discount DECIMAL(5,2) NOT NULL,
	sales_amount DECIMAL(10,2) NOT NULL,	-- sales_amount = quantity * unit_price * (1 - discount)
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- CREATE FOREIGN KEY CONSTRAINTS (Fact to Dimensions)
-- ============================================================================= 
ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT fk_fact_sales_dim_customers
	FOREIGN KEY (customer_key)
	REFERENCES dwh.dim_customers (customer_key);

ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT fk_fact_sales_dim_shippers
	FOREIGN KEY (shipper_key)
	REFERENCES dwh.dim_shippers (shipper_key);

ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT fk_fact_sales_dim_suppliers
	FOREIGN KEY (supplier_key)
	REFERENCES dwh.dim_suppliers (supplier_key);

ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT fk_fact_sales_dim_products
	FOREIGN KEY (product_key)
	REFERENCES dwh.dim_products (product_key);

ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT fk_fact_sales_dim_employees
	FOREIGN KEY (employee_key)
	REFERENCES dwh.dim_employees (employee_key);

ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT fk_fact_sales_dim_ship_info
	FOREIGN KEY (ship_info_key)
	REFERENCES dwh.dim_ship_info (ship_info_key);

ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT order_fk_fact_sales_dim_date
	FOREIGN KEY (order_date_key)
	REFERENCES dwh.dim_date (date_key);

ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT required_fk_fact_sales_dim_date
	FOREIGN KEY (required_date_key)
	REFERENCES dwh.dim_date (date_key);

ALTER TABLE dwh.fact_sales
	ADD CONSTRAINT shipped_fk_fact_sales_dim_date
	FOREIGN KEY (shipped_date_key)
	REFERENCES dwh.dim_date (date_key);