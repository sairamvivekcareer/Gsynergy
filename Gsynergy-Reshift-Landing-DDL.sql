--Create and Load data for hldy table

CREATE TABLE hldy (
    hldy_id VARCHAR(100),
    hldy_label VARCHAR(100)
)
DISTKEY(hldy_id);

COPY dev.public.hldy 
FROM 's3://gsnyergy-transactions/inbound/hier.hldy.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';

--Create and Load data for invloc table

CREATE TABLE invloc (
    loc INT,
    loc_label VARCHAR(100),
	loctype  VARCHAR(100),
	loctype_label VARCHAR(100)
)
DISTKEY(loc);

COPY dev.public.invloc 
FROM 's3://gsnyergy-transactions/inbound/hier.invloc.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';

----Create and Load data for rtloc table

CREATE TABLE rtloc (
    str	VARCHAR(512)	,
	str_label	VARCHAR(512)	,
	dstr	VARCHAR(512)	,
	dstr_label	VARCHAR(512)	,
	rgn	VARCHAR(512)	,
	rgn_label	VARCHAR(512)	

)
DISTKEY(str);

COPY dev.public.rtloc 
FROM 's3://gsnyergy-transactions/inbound/hier.rtlloc.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';

----Create and Load data for invstatus table

CREATE TABLE invstatus (
code_id	VARCHAR(512)	,
code_label	VARCHAR(512)	,
bckt_id	VARCHAR(512)	,
bckt_label	VARCHAR(512)	,
ownrshp_id	VARCHAR(512)	,
ownrshp_label	VARCHAR(512)	
)
DISTKEY(code_id);

COPY dev.public.invstatus 
FROM 's3://gsnyergy-transactions/inbound/hier.invstatus.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';

----Create and Load data for averagcosts table

CREATE TABLE averagecosts (
fscldt_id	VARCHAR(512)	,
sku_id	VARCHAR(512)	,
average_unit_standardcost	VARCHAR(512)	,
average_unit_landedcost	VARCHAR(512)	
)
DISTKEY(fscldt_id,sku_id);

COPY dev.public.averagecosts 
FROM 's3://gsnyergy-transactions/inbound/fact.averagecosts.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';

----Create and Load data for transactions table

CREATE TABLE transactions (
order_id	VARCHAR(512)	,
line_id	VARCHAR(512)	,
type	VARCHAR(512)	,
dt	VARCHAR(512)	,
pos_site_id	VARCHAR(512)	,
sku_id	VARCHAR(512)	,
fscldt_id	VARCHAR(512)	,
price_substate_id	VARCHAR(512)	,
sales_units	VARCHAR(512)	,
sales_dollars	VARCHAR(512)	,
discount_dollars	VARCHAR(512)	,
original_order_id	VARCHAR(512)	,
original_line_id	VARCHAR(512)	
)
DISTKEY(order_id);

COPY dev.public.transactions 
FROM 's3://gsnyergy-transactions/inbound/fact.transactions.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';


----Create and Load data for possite table

CREATE TABLE possite
 (
site_id	VARCHAR(512)	,
site_label	VARCHAR(512)	,
subchnl_id	VARCHAR(512)	,
subchnl_label	VARCHAR(512)	,
chnl_id	VARCHAR(512)	,
chnl_label	VARCHAR(512)
)
DISTKEY(site_id);

COPY dev.public.possite
 
FROM 's3://gsnyergy-transactions/inbound/hier.possite.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';


----Create and Load data for pricestate table

CREATE TABLE pricestate
 (
substate_id	VARCHAR(512)	,
substate_label	VARCHAR(512)	,
state_id	VARCHAR(512)	,
state_label	VARCHAR(512)

)
DISTKEY(substate_id);

COPY dev.public.pricestate
 
FROM 's3://gsnyergy-transactions/inbound/hier.pricestate.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';


----Create and Load data for clnd table

CREATE TABLE clnd
 (
fscldt_id	VARCHAR(512)	,
fscldt_label	VARCHAR(512)	,
fsclwk_id	VARCHAR(512)	,
fsclwk_label	VARCHAR(512)	,
fsclmth_id	VARCHAR(512)	,
fsclmth_label	VARCHAR(512)	,
fsclqrtr_id	VARCHAR(512)	,
fsclqrtr_label	VARCHAR(512)	,
fsclyr_id	VARCHAR(512)	,
fsclyr_label	VARCHAR(512)	,
ssn_id	VARCHAR(512)	,
ssn_label	VARCHAR(512)	,
ly_fscldt_id	VARCHAR(512)	,
lly_fscldt_id	VARCHAR(512)	,
fscldow	VARCHAR(512)	,
fscldom	VARCHAR(512)	,
fscldoq	VARCHAR(512)	,
fscldoy	VARCHAR(512)	,
fsclwoy	VARCHAR(512)	,
fsclmoy	VARCHAR(512)	,
fsclqoy	VARCHAR(512)	,
date	VARCHAR(512)

)
DISTKEY(fscldt_id);

COPY dev.public.clnd
 
FROM 's3://gsnyergy-transactions/inbound/hier.clnd.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';


----Create and Load data for prod table

CREATE TABLE prod
 (
sku_id	VARCHAR(512)	,
sku_label	VARCHAR(512)	,
stylclr_id	VARCHAR(512)	,
stylclr_label	VARCHAR(512)	,
styl_id	VARCHAR(512)	,
styl_label	VARCHAR(512)	,
subcat_id	VARCHAR(512)	,
subcat_label	VARCHAR(512)	,
cat_id	VARCHAR(512)	,
cat_label	VARCHAR(512)	,
dept_id	VARCHAR(512)	,
dept_label	VARCHAR(512)	,
issvc	VARCHAR(512)	,
isasmbly	VARCHAR(512)	,
isnfs	VARCHAR(512)
)
DISTKEY(sku_id);

COPY dev.public.prod
 
FROM 's3://gsnyergy-transactions/inbound/hier.prod.dlm.gz'
CREDENTIALS 'aws_access_key_id=Mention Acces key here;aws_secret_access_key=Mention SECRET key here'
FORMAT AS CSV
DELIMITER '|'
IGNOREHEADER 1
GZIP
REGION 'us-east-2';













