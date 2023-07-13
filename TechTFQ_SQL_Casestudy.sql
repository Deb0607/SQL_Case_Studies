CREATE TABLE IF NOT EXISTS account_balance (
	account_no VARCHAR(20),
	transaction_date DATE,
	transaction_type VARCHAR(10),
	transaction_amount INTEGER
);

insert into account_balance values ('acc_1', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 100);
insert into account_balance values ('acc_1', to_date('2022-01-21', 'YYYY-MM-DD'), 'credit', 500);
insert into account_balance values ('acc_1', to_date('2022-01-22', 'YYYY-MM-DD'), 'credit', 300);
insert into account_balance values ('acc_1', to_date('2022-01-23', 'YYYY-MM-DD'), 'credit', 200);
insert into account_balance values ('acc_2', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 500);
insert into account_balance values ('acc_2', to_date('2022-01-21', 'YYYY-MM-DD'), 'credit', 1100);
insert into account_balance values ('acc_2', to_date('2022-01-22', 'YYYY-MM-DD'), 'debit', 1000);
insert into account_balance values ('acc_3', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 1000);
insert into account_balance values ('acc_4', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 1500);
insert into account_balance values ('acc_4', to_date('2022-01-21', 'YYYY-MM-DD'), 'debit', 500);
insert into account_balance values ('acc_5', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 900);

WITH transaction_amount AS(
SELECT *,
CASE 
WHEN transaction_type = 'debit' THEN transaction_amount * -1 
ELSE transaction_amount END AS updated_transaction_amount
FROM account_balance),   -- Updated Trsansaction amount for crdit & debit
Account_balance AS(
SELECT 
account_no, transaction_date, updated_transaction_amount,
	SUM(updated_transaction_amount) OVER (PARTITION BY account_no ORDER BY transaction_date) 
	AS cuur_account_bal, -- 1. Create cumulative account balance AS Current account balance
	SUM (updated_transaction_amount) OVER (PARTITION BY account_no ORDER BY transaction_date 
										   RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
	AS final_bal, -- 2. Create Final balance After last transaction using frame cluse
	CASE WHEN SUM(updated_transaction_amount) OVER (PARTITION BY account_no ORDER BY transaction_date)>=1000 
		THEN 1 ELSE 0 END AS acc_flag  -- 3. Create flag when account balance reached >=1000
FROM transaction_amount) 	
SELECT account_no , MIN(transaction_date) AS transaction_date  FROM Account_balance
WHERE final_bal >= 1000
	AND acc_flag = 1
GROUP BY account_no;
 












