CREATE SCHEMA IF NOT EXISTS staging;

--CREATE TABLE FOR clnd
DROP TABLE IF EXISTS dev.staging.clnd;
CREATE TABLE IF NOT EXISTS dev.staging.clnd (
	fscldt_id	INT	,
	fscldt_label	VARCHAR(512) NOT NULL	,
	fsclwk_id	INT	,
	fsclwk_label	VARCHAR(512) NULL	,
	fsclmth_id	INT	,
	fsclmth_label	VARCHAR(512)	,
	fsclqrtr_id	INT	,
	fsclqrtr_label	VARCHAR(512)	,
	fsclyr_id	INT	,
	fsclyr_label	VARCHAR(512)	,
	ssn_id	VARCHAR(512)	,
	ssn_label	VARCHAR(512)	,
	ly_fscldt_id	INT	,
	lly_fscldt_id	INT	,
	fscldow	INT,
	fscldom	INT	,
	fscldoq	INT	,
	fscldoy	INT	,
	fsclwoy	INT	,
	fsclmoy	INT	,
	fsclqoy	INT	,
	date	DATE,
	PRIMARY KEY (fscldt_id)
	)
	DISTKEY(fscldt_id)
;
	
--INSERT DATA INTO CLND	
INSERT INTO dev.staging.clnd
SELECT 
	fscldt_id::	INT	,
	fscldt_label,
	fsclwk_id::	INT	,
	fsclwk_label,
	fsclmth_id::	INT	,
	fsclmth_label,
	fsclqrtr_id::	INT	,
	fsclqrtr_label,
	fsclyr_id::	INT	,
	fsclyr_label ,
	ssn_id	,
	ssn_label,
	ly_fscldt_id::	INT	,
	lly_fscldt_id::	INT	,
	fscldow	::INT,
	fscldom	::INT	,
	fscldoq	::INT	,
	fscldoy	::INT	,
	fsclwoy	::INT	,
	fsclmoy	::INT	,
	fsclqoy	::INT	,
	date	::DATE
 FROM dev.landing.clnd
;


--CREATE TABLE prod_dept(Normalized table created from the prod hier table)
DROP TABLE IF EXISTS dev.staging.prod_dept;
CREATE TABLE IF NOT EXISTS dev.staging.prod_dept(
	dept_id INT,
	dept_label 	VARCHAR(512),
	PRIMARY KEY (dept_id)
	)
	DISTKEY(dept_id)
;

--INSERT DATA INTO prod_dept	
INSERT INTO dev.staging.prod_dept
SELECT 
	dept_id :: INT,
	dept_label 
FROM dev.landing.prod
;

--CREATE TABLE prod_cat(Normalized table created from the prod hier table)
DROP TABLE IF EXISTS dev.staging.prod_cat;
CREATE TABLE IF NOT EXISTS dev.staging.prod_cat(
	cat_id INT,
	cat_label 	VARCHAR(512),
	dept_id INT,
	PRIMARY KEY (cat_id),
	CONSTRAINT fk_cat_dept_dept_id
		FOREIGN KEY (dept_id)
		REFERENCES prod_dept(dept_id)
	)
	DISTKEY(cat_id)
;

--INSERT DATA INTO prod_cat	
INSERT INTO dev.staging.prod_cat
SELECT 
	cat_id:: INT,
	cat_label,
	dept_id:: INT
FROM dev.landing.prod
;


--CREATE TABLE prod_subcat(Normalized table created from the prod hier table)
DROP TABLE IF EXISTS dev.staging.prod_subcat;
CREATE TABLE IF NOT EXISTS dev.staging.prod_subcat(
	subcat_id INT,
	subcat_label VARCHAR(512),
	cat_id INT,
	PRIMARY KEY (subcat_id),
	CONSTRAINT fk_subcat_cat_cat_id
		FOREIGN KEY (cat_id)
		REFERENCES prod_cat(cat_id)
	
	)
	DISTKEY(subcat_id)
;

--INSERT DATA INTO prod_subcat	
INSERT INTO dev.staging.prod_subcat
SELECT 
	subcat_id:: INT,
	subcat_label,
	cat_id:: INT
FROM dev.landing.prod
;

--CREATE TABLE prod_styl(Normalized table created from the prod hier table)
DROP TABLE IF EXISTS dev.staging.prod_styl;
CREATE TABLE IF NOT EXISTS dev.staging.prod_styl(
	styl_id  INT,
	styl_label VARCHAR(512),
	subcat_id INT,
	PRIMARY KEY (styl_id),
	CONSTRAINT fk_styl_subcat_subcat_id
		FOREIGN KEY (subcat_id)
		REFERENCES prod_subcat(subcat_id)
	
	)
	DISTKEY(styl_id)
;

--INSERT DATA INTO prod_styl	
INSERT INTO dev.staging.prod_styl
SELECT 
	styl_id:: INT,
	styl_label,
	subcat_id:: INT
FROM dev.landing.prod
;


--CREATE TABLE prod_stylclr(Normalized table created from the prod hier table)
DROP TABLE IF EXISTS dev.staging.prod_stylclr;
CREATE TABLE IF NOT EXISTS dev.staging.prod_stylclr(
	stylclr_id INT,
	stylclr_label VARCHAR(512),
	styl_id INT,
	PRIMARY KEY (stylclr_id),
	CONSTRAINT fk_stylclr_styl_styl_id
		FOREIGN KEY (styl_id)
		REFERENCES prod_styl(styl_id)
	)
	DISTKEY(stylclr_id)
;

--INSERT DATA INTO prod_stylclr	
INSERT INTO dev.staging.prod_stylclr
SELECT 
	stylclr_id:: INT,
	stylclr_label,
	styl_id :: INT
FROM dev.landing.prod
;
 
--CREATE TABLE prod_sku(Normalized table created from the prod hier table)
DROP TABLE IF EXISTS dev.staging.prod_sku;
CREATE TABLE IF NOT EXISTS dev.staging.prod_sku(
	sku_id  VARCHAR(512),
	sku_label VARCHAR(512),
	stylclr_id INT,
	issvc INT,
	isasmbly INT,
	isnfs INT,
	PRIMARY KEY (sku_id),
	CONSTRAINT fk_sku_stylclr_stylclr_id
		FOREIGN KEY (stylclr_id)
		REFERENCES prod_stylclr(stylclr_id)
	)
	DISTKEY(sku_id)
;

--INSERT DATA INTO prod_sku	
INSERT INTO dev.staging.prod_sku
SELECT 
	sku_id,
	sku_label,
	stylclr_id:: INT,
	issvc:: INT,
	isasmbly:: INT,
	isnfs:: INT	
FROM dev.landing.prod
;

-- Create the average_costs table
DROP TABLE IF EXISTS dev.staging.average_costs;
CREATE TABLE IF NOT EXISTS dev.staging.average_costs (
    fscldt_id INT,
    sku_id VARCHAR(512),
    average_unit_standardcost DECIMAL(10,2),
    average_unit_landedcost DECIMAL(10,2),
	PRIMARY KEY (fscldt_id, sku_id),
    CONSTRAINT fk_average_costs_clnd_fscldt_id
        FOREIGN KEY (fscldt_id)
        REFERENCES clnd(fscldt_id),
    CONSTRAINT fk_average_costs_prod_sku_sku_id
        FOREIGN KEY (sku_id)
        REFERENCES prod_sku(sku_id)
	
)
	DISTKEY(fscldt_id);

-- Insert data to average_costs table
INSERT INTO dev.staging.average_costs
SELECT 
	fscldt_id :: INT,
    sku_id,
    average_unit_standardcost :: DECIMAL(10,2),
    average_unit_landedcost :: DECIMAL(10,2)
FROM dev.landing.average_costs
;


-- Create the possite table
DROP TABLE IF EXISTS dev.staging.possite;
CREATE TABLE IF NOT EXISTS dev.staging.possite (
    site_id INT, 
	site_label VARCHAR(512),
	subchnl_id VARCHAR(512),
	subchnl_label VARCHAR(512),
	chnl_id VARCHAR(512),
	chnl_label VARCHAR(512),
	PRIMARY KEY (site_id)	
)
	DISTKEY(site_id);

-- Insert data to possite table
INSERT INTO dev.staging.possite
SELECT 
	site_id :: INT, 
	site_label ,
	subchnl_id ,
	subchnl_label,
	chnl_id ,
	chnl_label
FROM dev.landing.possite
;

-- Create the pricestate table
DROP TABLE IF EXISTS dev.staging.pricestate;
CREATE TABLE IF NOT EXISTS dev.staging.pricestate (
    substate_id VARCHAR,
	substate_label VARCHAR,
	state_id VARCHAR,
	state_label VARCHAR,
    PRIMARY KEY(substate_id)	
)
	DISTKEY(substate_id);

-- Insert data to pricestate table
INSERT INTO dev.staging.pricestate
SELECT 
	substate_id,
	substate_label,
	state_id,
	state_label
FROM dev.landing.pricestate
;



-- Create the transactions table
DROP TABLE IF EXISTS dev.staging.transactions;
CREATE TABLE IF NOT EXISTS dev.staging.transactions (
    order_id	INT	,
	line_id	INT	,
	type	VARCHAR(512)	,
	dt	TIMESTAMP	,
	pos_site_id	VARCHAR(512)	,
	sku_id	VARCHAR(512)	,
	fscldt_id	INT	,
	price_substate_id	VARCHAR(512)	,
	sales_units	INT	,
	sales_dollars	DECIMAL(10,2)	,
	discount_dollars	DECIMAL(10,2)	,
	original_order_id	INT	,
	original_line_id	INT,
	PRIMARY KEY (order_id),
    CONSTRAINT fk_transactions_clnd_fscldt_id
        FOREIGN KEY (fscldt_id)
        REFERENCES clnd(fscldt_id),
    CONSTRAINT fk_transactions_prod_sku_sku_id
        FOREIGN KEY (sku_id)
        REFERENCES prod_sku(sku_id),
	CONSTRAINT fk_transactions_possite_site_id
        FOREIGN KEY (pos_site_id)
        REFERENCES possite(site_id),
	CONSTRAINT fk_transactions_pricestate_price_substate_id
        FOREIGN KEY (price_substate_id)
        REFERENCES pricestate(substate_id)
	
)
	DISTKEY(order_id);

-- Insert data to transactions table
INSERT INTO dev.staging.transactions
SELECT
	order_id ::	INT	,
	line_id	:: INT	,
	type,
	dt :: TIMESTAMP	,
	pos_site_id,
	sku_id,
	fscldt_id ::	INT	,
	price_substate_id ,
	sales_units	:: INT	,
	sales_dollars	:: DECIMAL(10,2)	,
	discount_dollars ::	DECIMAL(10,2)	,
	original_order_id ::	INT	,
	original_line_id :: INT
FROM dev.landing.transactions
;

-- Create the rtloc table
DROP TABLE IF EXISTS dev.staging.rtloc;
CREATE TABLE IF NOT EXISTS rtloc (
    str	VARCHAR(512)	,
	str_label	VARCHAR(512)	,
	dstr	INT	,
	dstr_label	VARCHAR(512)	,
	rgn	INT	,
	rgn_label	VARCHAR(512),
	PRIMARY KEY (str)
)
DISTKEY(str)
;

-- Insert data to rtloc table
INSERT INTO dev.staging.rtloc
SELECT
	str	,
	str_label,
	dstr :: INT	,
	dstr_label,
	rgn	:: INT	,
	rgn_label
FROM dev.landing.rtloc
;

-- Create the invstatus table
DROP TABLE IF EXISTS dev.staging.invstatus;
CREATE TABLE IF NOT EXISTS invstatus (
    code_id	VARCHAR(512)	,
	code_label	VARCHAR(512)	,
	bckt_id	VARCHAR(512)	,
	bckt_label	VARCHAR(512)	,
	ownrshp_id	VARCHAR(512)	,
	ownrshp_label	VARCHAR(512),
	PRIMARY KEY(code_id)
)
DISTKEY(code_id)
;

-- Insert data to invstatus table
INSERT INTO dev.staging.invstatus
SELECT
	code_id	,
	code_label,
	bckt_id	,
	bckt_label,
	ownrshp_id,
	ownrshp_label
FROM dev.landing.invstatus
;


-- Create the invloc table
DROP TABLE IF EXISTS dev.staging.invloc;
CREATE TABLE IF NOT EXISTS invloc (
    loc INT,
    loc_label VARCHAR(100),
	loctype  VARCHAR(100),
	loctype_label VARCHAR(100),
	PRIMARY KEY(loc)
)
DISTKEY(loc)
;

--Insert data to invloc table
INSERT INTO dev.staging.invloc
SELECT
	loc :: INT,
    loc_label,
	loctype,
	loctype_label
FROM dev.landing.invloc
;

---- Create the hldy table
DROP TABLE IF EXISTS dev.staging.hldy;
CREATE TABLE IF NOT EXISTS dev.staging.hldy (
    hldy_id VARCHAR(100),
    hldy_label VARCHAR(100),
	PRIMARY KEY (hldy_id)
)
DISTKEY(hldy_id);

--Insert data to invloc hldy
INSERT INTO dev.staging.hldy 
SELECT 
	hldy_id,
    hldy_label
FROM dev.landing.hldy;
