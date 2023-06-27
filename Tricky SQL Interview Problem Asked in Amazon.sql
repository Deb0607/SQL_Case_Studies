create table purchase_history
(userid int
,productid int
,purchasedate date
);

SET DATEFORMAT DMY;

INSERT INTO purchase_history values
(1,1,'23-01-2012')
,(1,2,'23-01-2012')
,(1,3,'25-01-2012')
,(2,1,'23-01-2012')
,(2,2,'23-01-2012')
,(2,2,'25-01-2012')
,(2,4,'25-01-2012')
,(3,4,'23-01-2012')
,(3,1,'23-01-2012')
,(4,1,'23-01-2012')
,(4,2,'25-01-2012')
;
COMMIT;



/* Amazon interview for a BI Engineer position.
Given the users purchase history write a query to print users 
who have done purchase on more than 1 day and products purchased on a given day are never repeated on any other day. */

SELECT * FROM purchase_history;

-- 1ST APPROCHE--
SELECT userid
FROM purchase_history
GROUP BY userid
HAVING COUNT(DISTINCT purchasedate) > 1
	AND COUNT(productid) = COUNT(DISTINCT productid)

-- 2ND APPROCH --
SELECT userid FROM (
SELECT *,
LAG(p.productid,1) OVER (PARTITION BY userid ORDER BY purchasedate) AS prevproduct,
LAG(p.purchasedate,1) OVER (PARTITION BY userid ORDER BY purchasedate) AS pre_date
FROM purchase_history AS p) A
GROUP BY userid
HAVING COUNT(DISTINCT purchasedate) != COUNT(DISTINCT pre_date) AND COUNT(DISTINCT purchasedate) >= 2

-- 3RD APPROCH --

WITH CTE1 AS(
SELECT userid
FROM purchase_history
GROUP BY userid
HAVING COUNT(DISTINCT purchasedate)>=2),
CTE2 AS (
SELECT userid FROM purchase_history
GROUP BY userid
HAVING COUNT(productid) = COUNT(DISTINCT productid))
SELECT DISTINCT p.userid FROM purchase_history AS p WHERE p.userid IN (
SELECT CTE1.userid FROM CTE1
INNER JOIN CTE2
	ON CTE1.userid = CTE2.userid)