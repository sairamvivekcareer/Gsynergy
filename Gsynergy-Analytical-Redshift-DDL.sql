CREATE SCHEMA IF NOT EXISTS analytical;

DROP TABLE IF EXISTS dev.analytical.mview_weekly_sales;
CREATE TABLE IF NOT EXISTS dev.analytical.mview_weekly_sales(
  fsclwk_id INT,
  pos_site_id VARCHAR(512),
  sku_id VARCHAR(512),
  price_substate_id VARCHAR(512),
  type VARCHAR(512),
  wkly_sales_units INT,
  wkly_sales_dollars DECIMAL(10,2),
  wkly_discount_dollars DECIMAL(10,2)
)
;

INSERT INTO dev.analytical.mview_weekly_sales

select fsclwk_id,pos_site_id,sku_id,price_substate_id, type, SUM(sales_units) as wkly_sales_units, SUM(sales_dollars) as wkly_sales_dollars, SUM(discount_dollars) as wkly_discount_dollars

FROM

(select A.fscldt_id, B.fsclwk_id,pos_site_id, sku_id, price_substate_id, type, sales_units, sales_dollars, discount_dollars
FROM dev.staging.transactions A
JOIN dev.staging.clnd B
ON A.fscldt_id = B.fscldt_id )

GROUP BY fsclwk_id,pos_site_id,sku_id,price_substate_id, type

;