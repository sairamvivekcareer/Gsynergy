# Gsynergy
This Repository is created to maintain the scripts and documents of the Gsynergy Data warehouse challenge Project. 

AWS s3 and Redshift services are used for the challenge 

1. The Gsynergy-ERD-Diagram.pdf file show the Entity Relationship Diagram for the Fact and Hierachy tables
   
2. There are three .sql scripts in the repository as below:
   
**Gsynergy-Reshift-Landing-DDL.sql :**  This file has the sql code to define the tables in AWS Redshift server and copy the files from s3 to tables in the landing schema created
                                           In the Landing schema the 10 tables 2 fact tables and the 8 hier tables are created as it is and data types are considered as varchar.

   
**Gsynergy-Staging-Redshift-DDL.sql:**  This file has the sql code to define the tables in AWSRedshift in the staging schema and load the data from the landing tables already 
                                           created.
                                           In staging schema the I have taken 1 hier table (prod) and Normalized it into multiple tables, Also the data types are customized to data 
                                           along with the defined constraintsbetween the hier tables and the fact tables.

                                           
**Gsynergy-Analytical-Redshift-DDL.sql:** This file has the sql code to create the refined table called mview_weekly_sales in the anlaytical schema which aggregates sales_units, 
                                          sales_dollars, and disocunt_dollars by pos_site_id, sku_id,fsclwk_id, price_substate_id and type.

   
