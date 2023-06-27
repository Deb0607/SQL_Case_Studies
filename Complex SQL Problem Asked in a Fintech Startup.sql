CREATE DATABASE namastesql;
USE namastesql;

Create Table Trade_tbl(
TRADE_ID varchar(20),
Trade_Timestamp time,
Trade_Stock varchar(20),
Quantity int,
Price Float
);

Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20)
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15)
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30)
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32)
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19)
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19)


/* Write a SQL to find trade couples satisfying following conditions for each stock :
1- The trades should be within 10 seconds of window
2- The prices difference between the trades should be more than 10% */


SELECT T1.TRADE_ID,T2.TRADE_ID,
T1.Trade_Timestamp,T2.Trade_Timestamp,
T1.Price,T2.Price,
FLOOR((ABS((T1.Price-T2.Price)/T1.Price)*100)) AS Price_Diff
FROM Trade_tbl AS T1
INNER JOIN Trade_tbl AS T2
	ON T1.TRADE_ID != T2.TRADE_ID
	AND T1.Trade_Timestamp < T2.Trade_Timestamp
	AND DATEDIFF(SECOND,T1.Trade_Timestamp,T2.Trade_Timestamp)<10
WHERE FLOOR((ABS((T1.Price-T2.Price)/T1.Price)*100))>10
ORDER BY T1.TRADE_ID	