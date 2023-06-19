USE namaste_sql;

CREATE TABLE icc_world_cup(
Team_1  VARCHAR(20),
Team_2 VARCHAR(20),
Winner VARCHAR(20)
)ENGINE = InnoDB , CHAR SET = utf8mb4;

INSERT INTO icc_world_cup values('India','Sri lanka','India');
INSERT INTO icc_world_cup values('Sri lanka','Australia','Australia');
INSERT INTO icc_world_cup values('South Africa','England','England');
INSERT INTO icc_world_cup values('England','Newzeland','Newzeland');
INSERT INTO icc_world_cup values('Australia','India','India');

COMMIT;



/* Write a query to represent th poin table of the tournament. As Below
Team_name || No_of_match_played || No_of_ wins || No_of_Losses || Point
*/


SELECT * FROM icc_world_cup;

WITH CTE1 AS (
SELECT Team_1 AS Team,
CASE  WHEN Team_1 = Winner THEN 1  ELSE 0 END AS Win_flag
FROM icc_world_cup
UNION ALL
SELECT Team_2 AS Team,
CASE WHEN Team_2 = Winner THEN 1 ELSE 0 END AS Win_flag
FROM icc_world_cup)
SELECT Team,
COUNT(*) AS No_of_match_played,
SUM(Win_flag) AS No_of_wins,
COUNT(*) - SUM(Win_flag) AS No_of_Losses,
SUM(Win_flag)*2 AS Points
FROM CTE1
GROUP BY Team;
