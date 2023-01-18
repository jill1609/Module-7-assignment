--Creating tables
CREATE TABLE card_holder(
id INT PRIMARY KEY,
name VARCHAR (30)
); 

CREATE TABLE credit_card(
card VARCHAR (20) PRIMARY KEY,
cardholder_id INT,
FOREIGN KEY (cardholder_id) REFERENCES card_holder(id)
);

CREATE TABLE merchant(
id INT PRIMARY KEY,
name VARCHAR (30),
id_merchant_category INT NOT NULL 
);

CREATE TABLE merchant_category(
id INT PRIMARY KEY,
name VARCHAR (30) NOT NULL
);

CREATE TABLE transaction(
id INT PRIMARY KEY,
date TIMESTAMP,
amount DECIMAL,
card VARCHAR (20),
id_merchant INT NOT NULL,
FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);


--Displaying tables
SELECT * FROM card_holder

SELECT * FROM credit_card

SELECT * FROM merchant

SELECT * FROM merchant_category

SELECT * FROM transaction


--Data Ananlysis through query
--How can you isolate (or group) the transactions of each cardholder?
SELECT transaction.date, transaction.amount, credit_card.card, card_holder.name
FROM transaction
INNER JOIN credit_card ON transaction.card=credit_card.card
INNER JOIN card_holder ON credit_card.cardholder_id=card_holder.id
ORDER BY card_holder.name;

--Count the transactions that are less than $2.00 per cardholder.
SELECT COUNT(amount)
FROM transaction 
WHERE amount<2.00

--Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
--It does appear that credit cards have been have hacked, since the there are 350 transactions that are less than $2.00.

--What are the top 100 highest transactions made between 7:00 am and 9:00 am?   
SELECT *
FROM transaction AS t
WHERE date_part('hour', t.date) >= 7 AND date_part('hour', t.date) <= 8
ORDER BY amount DESC
LIMIT 100;

--Do you see any anomalous transactions that could be fraudulent?
--No fraudulent transaction has been recorded between this timeframe of 7:00 am to 9:00 am.

--Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
SELECT *
FROM transaction
WHERE amount<2.00
ORDER BY amount ASC
 --No, the timeframe of 7:00 am to 9:00 am has fewer fraudulent transactions than rest of the day.
 
--What are the top 5 merchants prone to being hacked using small transactions?
SELECT COUNT(t.amount), t.id_merchant, m.name, m.id 
FROM transaction AS t
INNER JOIN merchant AS m ON t.id_merchant=m.id
WHERE amount<2.00
GROUP BY t.id_merchant, m.name, m.id 
ORDER BY COUNT(t.amount) DESC
LIMIT 5

--Create a view for each of your queries.
CREATE VIEW cardholder_transactions AS
SELECT transaction.date, transaction.amount, credit_card.card, card_holder.name
FROM transaction
INNER JOIN credit_card ON transaction.card=credit_card.card
INNER JOIN card_holder ON credit_card.cardholder_id=card_holder.id
ORDER BY card_holder.name;

CREATE VIEW fraudulent_transactions AS
SELECT COUNT(amount)
FROM transaction 
WHERE amount<2.00

CREATE VIEW morning_transactions AS
SELECT *
FROM transaction AS t
WHERE date_part('hour', t.date) >= 7 AND date_part('hour', t.date) <= 8
ORDER BY amount DESC
LIMIT 100;

CREATE VIEW allday_fraudulent_transactions AS
SELECT *
FROM transaction
WHERE amount<2.00
ORDER BY amount ASC

CREATE VIEW top_5_merchants_hacked AS
SELECT COUNT(t.amount), t.id_merchant, m.name, m.id 
FROM transaction AS t
INNER JOIN merchant AS m ON t.id_merchant=m.id
WHERE amount<2.00
GROUP BY t.id_merchant, m.name, m.id 
ORDER BY COUNT(t.amount) DESC
LIMIT 5
--

--query for cardholder 2
SELECT * FROM transaction t
INNER JOIN credit_card c
ON t.card = c.card
WHERE cardholder_id = 2;

--query for cardholder 18
SELECT * FROM transaction t
INNER JOIN credit_card c
ON t.card = c.card
WHERE cardholder_id = 18;

--query for cardholder 25
SELECT *
FROM transaction t
INNER JOIN credit_card c 
ON t.card = c.card
WHERE date BETWEEN '2018-01-01 00:00:00' AND '2018-06-30 23:59:59'
AND cardholder_id = 25;