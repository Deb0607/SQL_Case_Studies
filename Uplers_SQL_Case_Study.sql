Create table candidates_testcase1(
id int primary key,
positions varchar(10) not null,
salary int not null);

insert into candidates_testcase1 values(1,'junior',5000);
insert into candidates_testcase1 values(2,'junior',7000);
insert into candidates_testcase1 values(3,'junior',7000);
insert into candidates_testcase1 values(4,'senior',10000);
insert into candidates_testcase1 values(5,'senior',30000);
insert into candidates_testcase1 values(6,'senior',20000);

-- Test Case-1
WITH running_cte AS(
SELECT *,
SUM(salary) OVER (PARTITION BY positions ORDER BY salary, id ASC) AS running_sal
FROM candidates_testcase1),
Senior_CTE AS (
SELECT * 
FROM running_cte 
WHERE positions = 'senior' AND running_sal <= 50000),
Junior_CTE AS
(SELECT *
FROM running_cte
WHERE positions = 'junior' AND running_sal <= 50000 - (SELECT SUM(salary) FROM Senior_CTE)),
Final_Salary_Structure AS
(SELECT * FROM Junior_CTE
UNION ALL
SELECT * FROM Senior_CTE)
SELECT 
COUNT(CASE WHEN positions = 'junior' THEN id ELSE NULL END) AS Juniors,
COUNT(CASE WHEN positions = 'senior' THEN id ELSE NULL END) AS Seniors
FROM Final_Salary_Structure;

Create table candidates_testcase2(
id int primary key,
positions varchar(10) not null,
salary int not null);

insert into candidates_testcase2 values(20,'junior',10000);
insert into candidates_testcase2 values(30,'senior',15000);
insert into candidates_testcase2 values(40,'senior',30000);

-- Test Case-2
WITH running_cte AS(
SELECT *,
SUM(salary) OVER (PARTITION BY positions ORDER BY salary) AS running_sal
FROM candidates_testcase2),
Senior_CTE AS
(SELECT *
FROM running_cte
WHERE positions = 'senior' AND running_sal <= 50000),
Junior_CTE AS
(SELECT *
FROM running_cte
WHERE positions = 'junior' AND running_sal <= 50000 - (SELECT SUM(salary) FROM Senior_CTE)),
Final_Salary_Structure AS
(SELECT * FROM Junior_CTE
UNION ALL
SELECT * FROM Senior_CTE)
SELECT 
COUNT(CASE WHEN positions = 'junior' THEN id ELSE NULL END) AS Juniors,
COUNT(CASE WHEN positions = 'senior' THEN id ELSE NULL END) AS Seniors
FROM Final_Salary_Structure;

-- Test Case-3

Create table candidates_testcase3(
id int primary key,
positions varchar(10) not null,
salary int not null);

insert into candidates_testcase3 values(1,'junior',15000);
insert into candidates_testcase3 values(2,'junior',15000);
insert into candidates_testcase3 values(3,'junior',20000);
insert into candidates_testcase3 values(4,'senior',60000);

WITH running_cte AS(
SELECT *,
SUM(salary) OVER (PARTITION BY positions ORDER BY salary) AS running_sal
FROM candidates_testcase3),
Senior_CTE AS
(SELECT *
FROM running_cte
WHERE positions = 'senior' AND running_sal <= 50000),
Junior_CTE AS
(SELECT *
FROM running_cte
WHERE positions = 'junior' AND running_sal <= 50000 - (SELECT COALESCE(SUM(salary),0) FROM Senior_CTE)),
Final_Salary_Structure AS
(SELECT * FROM Junior_CTE
UNION ALL
SELECT * FROM Senior_CTE)
SELECT 
COUNT(CASE WHEN positions = 'junior' THEN id ELSE NULL END) AS Juniors,
COUNT(CASE WHEN positions = 'senior' THEN id ELSE NULL END) AS Seniors
FROM Final_Salary_Structure;

-- Test Case-4
Create table candidates_testcase4(
id int primary key,
positions varchar(10) not null,
salary int not null;

insert into candidates_testcase4 values(10,'junior',10000);
insert into candidates_testcase4 values(40,'junior',10000);
insert into candidates_testcase4 values(20,'senior',15000);
insert into candidates_testcase4 values(30,'senior',30000);
insert into candidates_testcase4 values(50,'senior',15000);

WITH running_cte AS(
SELECT *,
SUM(salary) OVER (PARTITION BY positions ORDER BY salary) AS running_sal
FROM candidates_testcase4),
Senior_CTE AS
(SELECT *
FROM running_cte
WHERE positions = 'senior' AND running_sal <= 50000),
Junior_CTE AS
(SELECT *
FROM running_cte
WHERE positions = 'junior' AND running_sal <= 50000 - (SELECT SUM(salary) FROM Senior_CTE)),
Final_Salary_Structure AS
(SELECT * FROM Junior_CTE
UNION ALL
SELECT * FROM Senior_CTE)
SELECT 
COUNT(CASE WHEN positions = 'junior' THEN id ELSE NULL END) AS Juniors,
COUNT(CASE WHEN positions = 'senior' THEN id ELSE NULL END) AS Seniors
FROM Final_Salary_Structure;