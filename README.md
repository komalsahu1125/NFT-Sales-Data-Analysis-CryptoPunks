# 🧠 NFT Sales Data Analysis – CryptoPunks

## 📊 Project Overview

This project explores and analyzes **real-world NFT sales data** from one of the most iconic NFT collections: **CryptoPunks**. The dataset consists of transactional data from the Ethereum blockchain.

The objective is to uncover meaningful insights about transaction patterns, pricing trends, and participant behavior in the NFT space using SQL queries and visual analysis.

---

## 🧾 Dataset Description

Each row in the dataset represents the sale of a CryptoPunk NFT and includes the following fields:

- `buyer_address`: Wallet address of the buyer
- `seller_address`: Wallet address of the seller
- `eth_price`: Price of the NFT in ETH
- `usd_price`: Price of the NFT in USD
- `event_date`: Date of the transaction
- `token_id`: Unique identifier of the NFT
- `transaction_hash`: Transaction ID on the blockchain
- `name`: The name of the NFT (e.g., "CryptoPunk #1139")

---

## 🧠 Analysis Goals

The following prompts were used to guide the analysis:

1. **Total Sales**  
   - Count the total number of NFT sales in the dataset.

2. **Top 5 Most Expensive Sales**  
   - Return the top 5 transactions by USD price with columns: `nft_name`, `eth_price`, `usd_price`, and `date`.

3. **Moving Average of USD Price**  
   - Create a table showing each transaction with `event`, `usd_price`, and a 50-transaction moving average of USD price.

4. **Average Sale Price per NFT**  
   - Return all NFT names and their average sale price in USD, sorted in descending order. Name the column as `average_price`.

5. **Sales by Day of the Week**  
   - Return each weekday with the number of transactions and average ETH price. Sort by count in ascending order.

6. **Summary Column**  
   - Construct a `summary` column for each transaction in this format:  
     `"CryptoPunk #1139 was sold for $194000 to 0xBUYER from 0xSELLER on 2022-01-14"`

7. **Create View for Specific Buyer**  
   - Create a SQL view called `1919_purchases` where the buyer is `0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685`.

8. **ETH Price Histogram**  
   - Generate a histogram of ETH price ranges, rounded to the nearest hundred.

9. **Highest and Lowest Price Comparison**  
   - Return a unioned query of each NFT's highest and lowest sale price, with a `status` column (`highest` or `lowest`), and order by `nft_name` and `status`.

10. **Most Sold NFT Per Month/Year**  
    - For each month/year, return the most sold NFT name and its price in USD, ordered chronologically.

11. **Monthly Volume**  
    - Calculate the total monthly volume (USD sales), rounded to the nearest hundred.

12. **Wallet Activity**  
    - Count how many transactions the wallet `0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685` had over the time period.

13. **Estimated Average Value Calculator**  
    a. Create a subquery with `date`, `usd_price`, and the average USD price per day using a window function.  
    b. Exclude transactions where `usd_price` is less than 10% of the daily average, and return the new estimated average price per day.

---

## 🛠 Tools & Technologies

- SQL ( MySQL)
- Optional: Python, Pandas, Matplotlib, or any BI tool for visualizations

---

## 📈 Expected Insights

- Identification of high-value NFT assets
- Buyer behavior and wallet-level analysis
- Daily/weekly/monthly transaction trends
- Detection of pricing outliers and trend shifts
- Adjusted fair market value calculation per day

---

