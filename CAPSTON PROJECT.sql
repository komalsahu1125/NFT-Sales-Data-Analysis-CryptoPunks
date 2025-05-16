/* PROJECT =

Over the past 18 months, an emerging technology has caught the attention of the world; the NFT. What is an NFT? They are digital assets stored on the blockchain. And over $22 billion was spent last year on purchasing NFTs. Why? People enjoyed the art, the speculated on what they might be worth in the future, and people didn’t want to miss out. 
 
The future of NFT’s is unclear as much of the NFT’s turned out to be scams of sorts since the field is wildly unregulated. They’re also contested heavily for their impact on the environment.
 
Regardless of these controversies, it is clear that there is money to be made in NFT’s. And one cool part about NFT’s is that all of the data is recorded on the blockchain, meaning anytime something happens to an NFT, it is logged in this database. 
 
In this project, you’ll be tasked to analyze real-world NFT data. 
That data set is a sales data set of one of the most famous NFT projects, Cryptopunks. Meaning each row of the data set represents a sale of an NFT. The data includes sales from January 1st, 2018 to December 31st, 2021. The table has several columns including the buyer address, the ETH price, the price in U.S. dollars, the seller’s address, the date, the time, the NFT ID, the transaction hash, and the NFT name.
You might not understand all the jargon around the NFT space, but you should be able to infer enough to answer the following prompts.
 
1.  many sales occurred during this time period? 
2. Return the top 5 most expensive transactions (by USD price) for this data set. Return the name, ETH price, and USD price, as well as the date.
3. Return a table with a row for each transaction with an event column, a USD price column, and a moving average of USD price that averages the last 50 transactions.
4. Return all the NFT names and their average sale price in USD. Sort descending. Name the average column as average_price.
5. Return each day of the week and the number of sales that occurred on that day of the week, as well as the average price in ETH. Order by the count of transactions in ascending order.
6. Construct a column that describes each sale and is called summary. The sentence should include who sold the NFT name, who bought the NFT, who sold the NFT, the date, and what price it was sold for in USD rounded to the nearest thousandth.
 Here’s an example summary:
 “CryptoPunk #1139 was sold for $194000 to 0x91338ccfb8c0adb7756034a82008531d7713009d from 0x1593110441ab4c5f2c133f21b0743b2b43e297cb on 2022-01-14”
7. Create a view called “1919_purchases” and contains any sales where “0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685” was the buyer.
8. Create a histogram of ETH price ranges. Round to the nearest hundred value. 
9. Return a unioned query that contains the highest price each NFT was bought for and a new column called status saying “highest” with a query that has the lowest price each NFT was bought for and the status column saying “lowest”. The table should have a name column, a price column called price, and a status column. Order the result set by the name of the NFT, and the status, in ascending order. 
10. What NFT sold the most each month / year combination? Also, what was the name and the price in USD? Order in chronological format. 
11. Return the total volume (sum of all sales), round to the nearest hundred on a monthly basis (month/year).
12. Count how many transactions the wallet "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685"had over this time period.
13. Create an “estimated average value calculator” that has a representative price of the collection every day based off of these criteria:
 - Exclude all daily outlier sales where the purchase price is below 10% of the daily average price
 - Take the daily average of remaining transactions
 a) First create a query that will be used as a subquery. Select the event date, the USD price, and the average USD price for each day using a window function. Save it as a temporary table.
 b) Use the table you created in Part A to filter out rows where the USD prices is below 10% of the daily average and return a new estimated value which is just the daily average of the filtered data.
 
 */
 USE cryptopunk;
 select * from pricedata;
 
 
 -- 1. How many sales occurred during this time period?
SELECT COUNT(*) AS total_sales
FROM pricedata;

-- 2. Return the top 5 most expensive transactions (by USD price) for this data set. Return the name, ETH price, and USD price, as well as the date.
SELECT name, eth_price, usd_price, event_date
FROM pricedata
ORDER BY usd_price DESC
LIMIT 5;

-- 3. Return a table with a row for each transaction with an event column, a USD price column, and a moving average of USD price that averages the last 50 transactions.
SELECT transaction_hash AS event, 
       usd_price, 
       AVG(usd_price) OVER (ORDER BY event_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS moving_avg_usd_price
FROM pricedata;

-- 4. Return all the NFT names and their average sale price in USD, sorted descending by the average price.
SELECT name, 
       AVG(usd_price) AS average_price
FROM pricedata
GROUP BY name
ORDER BY average_price DESC;

-- 5. Return each day of the week and the number of sales that occurred on that day of the week, as well as the average price in ETH. Order by the count of transactions in ascending order.
SELECT DAYOFWEEK(event_date) AS day_of_week, 
       COUNT(*) AS num_sales, 
       AVG(eth_price) AS avg_eth_price
FROM pricedata
GROUP BY day_of_week
ORDER BY num_sales ASC;

-- 6. Construct a column that describes each sale and is called summary.
SELECT CONCAT(name, ' was sold for $', ROUND(usd_price, 3), ' to ', buyer_address, ' from ', seller_address, ' on ', utc_timestamp) AS summary
FROM pricedata;

-- 7. Create a view called "1919_purchases" that contains any sales where "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685" was the buyer.
CREATE VIEW 1919_purchases AS
SELECT *
FROM pricedata
WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

-- 8. Create a histogram of ETH price ranges. Round to the nearest hundred value.
SELECT ROUND(eth_price, -2) AS eth_price_range, 
       COUNT(*) AS count
FROM pricedata
GROUP BY eth_price_range
ORDER BY eth_price_range;

-- 9. Return a unioned query that contains the highest price each NFT was bought for and the lowest price, with a status column.
SELECT name, MAX(usd_price) AS price, 'highest' AS status
FROM pricedata
GROUP BY name
UNION
SELECT name, MIN(usd_price) AS price, 'lowest' AS status
FROM pricedata
GROUP BY name
ORDER BY name, status;

-- 10. What NFT sold the most each month/year combination, and what was the name and the price in USD?
WITH sales_by_month_year AS (
    SELECT name, 
           DATE_FORMAT(event_date, '%Y-%m') AS month_year, 
           SUM(usd_price) AS total_sales
    FROM pricedata
    GROUP BY name, month_year
)
SELECT month_year, name, MAX(total_sales) AS usd_price
FROM sales_by_month_year
GROUP BY month_year
ORDER BY month_year;

/* 11.Return the total volume (sum of all sales), round to the nearest hundred on a monthly basis (month/year).
Count how many transactions the wallet */
SELECT DATE_FORMAT(event_date, '%Y-%m') AS month_year, 
       ROUND(SUM(usd_price), -2) AS total_volume
FROM pricedata
GROUP BY month_year
ORDER BY month_year;

-- 12. Count how many transactions the wallet "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685" had over this time period.
SELECT COUNT(*) AS num_transactions
FROM pricedata
WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685' 
   or seller_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

--  13. Create an "estimated average value calculator" that has a representative price of the collection every day based on specific criteria.
-- A) Create a query to select the event date, USD price, and the average USD price for each day.
WITH daily_avg AS (
    SELECT event_date, 
           usd_price, 
           AVG(usd_price) OVER (PARTITION BY event_date) AS avg_usd_price
    FROM pricedata
)

-- B) Filter out rows where the USD price is below 10% of the daily average and return the new estimated value.
SELECT event_date, 
       AVG(usd_price) AS estimated_avg_price
FROM daily_avg
WHERE usd_price >= 0.10 * avg_usd_price
GROUP BY event_date;


 select * from pricedata;