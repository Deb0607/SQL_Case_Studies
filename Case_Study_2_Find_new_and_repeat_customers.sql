USE namaste_sql;

CREATE TABLE IF NOT EXISTS Customer_orders (
order_id INT NOT NULL,
customer_id INT NOT NULL,
Order_date DATE,
Order_amount BIGINT,
PRIMARY KEY (order_id)
) ENGINE = InnoDB , CHAR SET = utf8mb4;

SELECT * FROM Customer_orders;

INSERT INTO Customer_orders (order_id,customer_id,Order_date,Order_amount)
VALUES
(1,100,CAST('2022-01-01' AS Date),2000),
(2,200,CAST('2022-01-01' AS Date),2500),
(3,300,CAST('2022-01-01' AS Date),2100),
(4,100,CAST('2022-01-02' AS Date),2000),
(5,400,CAST('2022-01-02' AS Date),2200),
(6,500,CAST('2022-01-02' AS Date),2700),
(7,100,CAST('2022-01-03' AS Date),3000),
(8,400,CAST('2022-01-03' AS Date),1000),
(9,600,CAST('2022-01-03' AS Date),3000);
COMMIT;


-- 1st Apporch
WITH First_visit AS(
SELECT
customer_id,
MIN(Order_date) AS First_visit_date
FROM Customer_orders
GROUP BY customer_id),
Visit_flag AS(
SELECT c.* , f.First_visit_date,
CASE WHEN c.Order_date = f.First_visit_date THEN 1 ELSE 0 END AS first_visit_flag,
CASE WHEN c.Order_date != f.First_visit_date THEN 1 ELSE 0 END AS repeat_visit_flag
FROM Customer_orders AS c
LEFT JOIN First_visit AS f
	ON c.customer_id = f.customer_id)
SELECT
Order_date,
SUM(first_visit_flag) AS No_of_first_visit,
SUM(repeat_visit_flag) AS No_of_repeat_visit
FROM Visit_flag
GROUP BY Order_date;


-- 2nd Approch

SELECT 
Order_date,
COUNT(CASE WHEN Order_date = First_visit_date THEN customer_id ELSE NULL END) AS No_of_first_visit,
COUNT(CASE WHEN Order_date != First_visit_date THEN customer_id ELSE NULL END) AS No_of_repeat_visit
FROM (SELECT customer_id,Order_date,
MIN(Order_date) OVER (PARTITION BY customer_id) AS First_visit_date FROM Customer_orders) AS co
GROUP BY Order_date;

