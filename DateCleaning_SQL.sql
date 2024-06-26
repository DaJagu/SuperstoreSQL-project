----portfolio project in SQL .
--Q1  Establish the relationship beteen the tables as per the ER Diagram.

ALTER TABLE OrdersList
ADD CONSTRAINT PK_ORDER PRIMARY KEY (OrderID ) 

ALTER TABLE OrdersList 
ALTER COLUMN OrderID nvarchar(255) not null;

ALTER TABLE EachOrderBreakdown
ALTER COLUMN OrderID nvarchar(255) not null;

ALTER TABLE EachOrderBreakdown
ADD CONSTRAINT fk_orderid FOREIGN KEY (Orderid) REFERENCES OrdersList (Orderid)

--Q2 split citystate country into 3 indiviual columns namely city ,state , country

ALTER TABLE OrdersList 
ADD CITY nvarchar(255),
    STATE nvarchar(255),
	COUNTRY nvarchar(255);

UPDATE OrdersList
SET CITY = PARSENAME(REPLACE( [City State Country], ',','.'),3),
	STATE = PARSENAME (REPLACE ( [city state country],',','.'),2),
	COUNTRY = PARSENAME(REPLACE( [City State Country], ',','.'),1);

ALTER  TABLE ORDERSLIST
DROP COLUMN [City State Country];

SELECT * FROM  ORDERSLIST;
--Q3---add new category colunm using the following mapping as per the first 3 characters in the product name column:
---A TEC - Technology 
---B OFC- Office supplies 
---C FUR - Furniture.

ALTER TABLE EachOrderBreakdown
ADD Category nvarchar(255);

select * from EachOrderBreakdown

update EachOrderBreakdown
set category = CASE WHEN LEFT(productname,3) = 'OFS' THEN 'office supplies'
                     WHEN LEFT (productname,3) = 'TEC' THEN 'Technology'
					 WHEN LEFT (productname, 3) = 'FUR' THEN 'Furniture'
					 END;
--CHANGING tes to tec in above statment .alter table and then update table again .
alter table  EachOrderBreakdown
 drop column category;

--Q4---DELETE the first 4 characters from the product name column.

update EachOrderBreakdown
set productname = SUBSTRING(productname,5,len(productname)-4);

---Q5--REMOVE DUPLICATE Rows from eachordersbreakdown table , if all colunm values  are matching .

select *, ROW_NUMBER() OVER(PARTITION BY orderid,productname ,discount,sales,profit,quantity,subcategory,category ORDER BY orderid) AS RN
 from EachOrderBreakdown; 

WITH CTE AS (
     SELECT *, ROW_NUMBER() OVER(PARTITION BY orderid,productname ,discount,sales,profit,quantity,subcategory,category ORDER BY orderid) AS RN
     FROM EachOrderBreakdown 
     WHERE  orderid = 'AZ-2011-6674300')
DELETE FROM CTE 
WHERE RN > 1;

--Q6--REPLACE blank with NA in order priority colunm in orderslist table.

SELECT * FROM OrdersList;

UPDATE OrdersList
set OrderPriority ='NA'
WHERE OrderPriority is null;














