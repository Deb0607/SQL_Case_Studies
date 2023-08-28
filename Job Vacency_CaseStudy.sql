USE namastesql;

CREATE TABLE IF NOT EXISTS job_positions(
id INT,
title VARCHAR(100),
`groups` VARCHAR(10),
levels VARCHAR(10),
payscale INT,
totalpost INT);

insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1);
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5);
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);


CREATE TABLE IF NOT EXISTS job_employees(
id INT,
Name VARCHAR(100),
position_id INT);

insert into job_employees values (1, 'John Smith', 1);
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2);
insert into job_employees values (5, 'William Lee', 3);
insert into job_employees values (6, 'Jessica Clark', 3);
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3);

SELECT * FROM job_positions;
SELECT *,
ROW_NUMBER() OVER (PARTITION BY position_id ORDER BY id) AS rn FROM job_employees;

WITH RECURSIVE Total_job_positions AS(
SELECT
	id AS position_id, 1 AS p_index,
    totalpost
FROM job_positions
UNION ALL
SELECT
	tjp.position_id, tjp.p_index + 1, jp.totalpost
FROM Total_job_positions AS tjp
LEFT JOIN job_positions AS jp
	ON tjp.position_id = jp.id
WHERE tjp.p_index < jp.totalpost),
Position_with_Title AS(
SELECT p.id, p.title, p.groups, p.levels,tjp.totalpost,tjp.p_index
FROM job_positions AS p
JOIN Total_job_positions AS tjp
	ON p.id = tjp.position_id)
SELECT pwt.title AS Title, pwt.groups AS Scale_Group,pwt.levels AS Scale_levels, COALESCE(je.Name,'Vacent') AS Employee_Name
FROM Position_with_Title AS pwt
LEFT JOIN (SELECT *,
			ROW_NUMBER() OVER(PARTITION BY position_id ORDER BY id) AS rn FROM job_employees) AS je
ON je.rn = pwt.p_index AND je.position_id = pwt.id
ORDER BY Scale_Group;