CREATE SCHEMA namaste_sql;
USE namaste_sql;
CREATE TABLE IF NOT EXISTS section_data(
section VARCHAR(5),
`number` BIGINT
)ENGINE= InnoDB , CHAR SET = utf8mb4;

TRUNCATE TABLE section_data;
INSERT INTO section_data (section,`number`)
VALUES
('A',5),('A',7),('A',10),('B',7),('B',9),('B',10),('C',9),('C',7),('C',9),('D',10),('D',3),('D',8);
COMMIT;

/* Problem statement : we have a table which stores data of multiple sections. every section has 3 numbers
we have to find top 4 numbers from any 2 sections(2 numbers each) whose addition should be maximum
so in this case we will choose section b where we have 19(10+9) then we need to choose either C or D
because both has sum of 18 but in D we have 10 which is big from 9 so we will give priority to D.*/
WITH CTE1 AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY section ORDER BY number DESC) AS rn
FROM section_data),
CTE2 AS(
SELECT *,
SUM(number) OVER (PARTITION BY section) AS total,
MAX(number) OVER (PARTITION BY section) AS sec_max
FROM CTE1 WHERE rn <=2),
CTE3 AS(
SELECT *,
DENSE_RANK() OVER (ORDER BY total DESC, sec_max DESC) AS sum_rank
FROM CTE2)
SELECT section,number
FROM CTE3 WHERE sum_rank<=2;

WITH CTE1 AS(
SELECT *,
LAG(number) OVER (PARTITION BY section ORDER BY number DESC) AS max_num
FROM section_data),
CTE2 AS(
SELECT section,max_num,
SUM(max_num) OVER (PARTITION BY section) AS sum_of_max_num
FROM CTE1 WHERE max_num IS NOT NULL),
CTE3 AS(
SELECT * FROM CTE2 
WHERE sum_of_max_num > (SELECT MIN(sum_of_max_num) FROM CTE2)
), Final_Output AS(
SELECT *,
MAX(max_num) OVER (PARTITION BY section ) AS new_max_num
FROM CTE3)
SELECT section, max_num AS `number`
FROM Final_Output
WHERE new_max_num >= (SELECT MAX(max_num) FROM Final_Output)
