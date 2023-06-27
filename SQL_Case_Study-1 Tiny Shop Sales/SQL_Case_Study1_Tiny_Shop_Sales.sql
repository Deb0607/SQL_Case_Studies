CREATE SCHEMA Tiny_shop_sales DEFAULT CHAR SET = utf8mb4;

USE Tiny_shop_sales;

SELECT @@SQL_MODE;

SET @@SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
COMMIT;

CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');
COMMIT;

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);
COMMIT;

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');
COMMIT;

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);
COMMIT;

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;


/* 1. Which product has the highest price? Only return a single row. */
WITH product_highest_price AS(
SELECT *,
DENSE_RANK() OVER (ORDER BY price DESC) as rnk
FROM products)
SELECT product_name AS Product FROM product_highest_price
WHERE rnk = 1;


/* 2. Which customer has made the most orders ? */
WITH Most_ordered_customer AS (
SELECT 
CONCAT(c.first_name," ",c.last_name) AS Customer_name,
COUNT(o.order_id) AS No_of_order,
RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS rnk
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id)
SELECT Customer_name, No_of_order 
FROM Most_ordered_customer WHERE rnk = 1;

/* 3. What’s the total revenue per product? */

WITH Revenue AS(
SELECT
p.product_id AS Product_id,
p.product_name AS Product_name , p.price AS Price,
oi.quantity AS qty
FROM products AS p
LEFT JOIN order_items AS oi
	ON  oi.product_id = p.product_id)
SELECT Product_name,
SUM(Price * qty) AS Total_revenue
FROM Revenue
Group by Product_name;

/* 4. Find the day with the highest revenue */
WITH Order_details AS(
SELECT 
DAYNAME(o.order_date) AS Order_date,
oi.order_id, oi.product_id, SUM(oi.quantity) AS Total_qty,
SUM(p.price * oi.quantity) AS Total_Revenue
FROM order_items AS oi
LEFT JOIN orders AS o
	ON o.order_id = oi.order_id
LEFT JOIN products AS p
	ON p.product_id = oi.product_id
GROUP BY Order_date), 
Most_revenue AS(
SELECT Order_date, Total_Revenue,
ROW_NUMBER() OVER (ORDER BY Total_Revenue DESC) AS rn
FROM Order_details)
SELECT Order_date, Total_Revenue
FROM Most_revenue
where rn = 1;

/* 5. Find the first order (by date) for each customer */
WITH First_order_date AS(
SELECT
o.customer_id,
o.order_date AS fisrt_order_date,
o.order_id,
i.product_id,
ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS rn
FROM order_items AS i
LEFT JOIN orders AS o
	ON i.order_id = o.order_id)
SELECT CONCAT(c.first_name," ",c.last_name) AS Customer_name,
p.product_name , fisrt_order_date
FROM First_order_date AS f
LEFT JOIN customers AS c
	ON f.customer_id = c.customer_id
LEFT JOIN products AS p
	ON f.product_id = p.product_id
WHERE rn = 1;

/* 6. Find the top 3 customers who have ordered the most distinct products */
WITH CTE1 AS (
SELECT
o.customer_id,
oi.order_id, COUNT(DISTINCT oi.product_id) AS no_of_products
FROM order_items AS oi
LEFT JOIN orders AS o
	ON o.order_id = oi.order_id
GROUP BY 1), CTE2 AS (
SELECT CTE1.customer_id,
CONCAT(C.first_name, " ",C.last_name) AS Customer_Name,
no_of_products,
ROW_NUMBER() OVER (ORDER BY no_of_products DESC) AS rn
FROM CTE1
LEFT JOIN customers AS C
	ON C.customer_id = CTE1.customer_id)
SELECT customer_id,
Customer_Name, no_of_products FROM CTE2 WHERE CTE2.rn < 4;

/* 7. Which product has been bought the least in terms of quantity? */

SELECT
DISTINCT p.product_name  AS Product_Name,
SUM(i.quantity) OVER (PARTITION BY p.product_name) AS Qty
FROM order_items AS i
LEFT JOIN products AS p
	ON i.product_id = p.product_id
ORDER BY Qty
LIMIT 1;

/* 8. What is the median order total? */
WITH Order_wise_amount AS (
SELECT i.order_id, SUM(i.quantity * p.price) AS Amount
FROM order_items AS i
LEFT JOIN products  AS p
	ON i.product_id = p.product_id
GROUP BY 1) 
SELECT FLOOR(AVG(A.Amount)) AS median_of_order_total FROM (
SELECT d.Amount , @ROWNUM := @ROWNUM + 1 AS `row_number`,
@TOTAL_ROWS := @ROWNUM AS Total_row FROM Order_wise_amount AS d , (SELECT @ROWNUM := 0) r
WHERE Amount IS NOT NULL
ORDER BY Amount
) AS A WHERE A.row_number IN (FLOOR((@TOTAL_ROWS+1)/2),FLOOR((@TOTAL_ROWS+2)/2));


/* 9. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100)
, or ‘Cheap’. */
WITH Order_details AS(
SELECT
i.order_id AS Order_id,
SUM(i.quantity * p.price) AS Order_Amount
FROM order_items AS i
LEFT JOIN products AS p
	ON i.product_id = p.product_id
GROUP BY 1)
SELECT Order_id , Order_Amount,
CASE 
	WHEN Order_Amount > 300 THEN 'Expensive'
    WHEN Order_Amount > 100 THEN  'Affordable'
    ELSE 'Cheap' END AS Type
FROM Order_details;

/* 10. Find customers who have ordered the product with the highest price. */

SELECT 
DISTINCT i.order_id, 
CONCAT(c.first_name," ",c.last_name) AS Customer_name,
i.quantity
FROM order_items AS i
LEFT JOIN products AS p
	ON i.product_id = p.product_id
LEFT JOIN orders AS o
	ON i.order_id = o.order_id
LEFT JOIN customers AS c
	ON o.customer_id = c.customer_id
WHERE i.product_id = (SELECT product_id FROM products ORDER BY PRICE DESC LIMIT 1);
