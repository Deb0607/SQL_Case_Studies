CREATE SCHEMA NamasteSQL DEFAULT CHAR SET = utf8mb4;

USE NamasteSQL;

create table drivers(
id varchar(10), 
start_time time, 
end_time time, 
start_loc varchar(10), 
end_loc varchar(10)
);
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

-- Windows Function ----
WITH Ride_status AS(
SELECT *,
LEAD(start_loc) OVER (PARTITION BY id ORDER BY start_time) AS Next_start_ride_lOC
FROM drivers)
SELECT id, count(*) AS No_of_ride,
SUM(CASE WHEN end_loc = Next_start_ride_lOC THEN 1 ELSE 0 END) AS Profit_rides
FROM Ride_status
GROUP BY id;

-- Self Join ----
