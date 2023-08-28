
create table family 
(
person varchar(5),
type varchar(10),
age int
);

insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);

With CTE_Adult As(
select *,
ROW_NUMBER() Over (order by person) as rn
from family
where type ='Adult'), CTE_Child as(
select *,
ROW_NUMBER() Over (order by person) as rn
from family
where type ='Child')
select a.person, b.person
from CTE_Adult as a
left join CTE_Child  as b
	on a.rn = b.rn

/* SQL problem asked in tiger analytics for a data engineer position.
You need to find pairs of adult and child to go for a ride. 
The pair should be in a way that the oldest adult should be with the youngest child and so on. */

With CTE_Adult As(
select *,
ROW_NUMBER() Over (order by age desc) as rn
from family
where type ='Adult'), CTE_Child as(
select *,
ROW_NUMBER() Over (order by age asc) as rn
from family
where type ='Child')
select a.person, b.person
from CTE_Adult as a
left join CTE_Child  as b
	on a.rn = b.rn

