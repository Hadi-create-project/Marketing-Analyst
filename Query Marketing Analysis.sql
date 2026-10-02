-- DATA CLEANING
-- Buat Table Baru
CREATE TABLE marketing_campaign_clean AS
SELECT *
FROM marketing_campaign
WHERE income IS NOT NULL
AND year_birth >= 1920;

select count(*) from marketing_campaign_clean mcc 

-- AGE
ALTER TABLE marketing_campaign_clean
ADD COLUMN age INT;

UPDATE marketing_campaign_clean
SET age = 2025 - year_birth;

-- Total Spending
ALTER TABLE marketing_campaign_clean
ADD COLUMN total_spending NUMERIC;

UPDATE marketing_campaign_clean
SET total_spending =
mnt_wines
+ mnt_fruits
+ mnt_meat_products
+ mnt_fish_products
+ mnt_sweet_products
+ mnt_gold_prods;

-- Total Purchase
ALTER TABLE marketing_campaign_clean
ADD COLUMN total_purchase INT;

UPDATE marketing_campaign_clean
SET total_purchase =
num_web_purchases
+ num_catalog_purchases
+ num_store_purchases;

-- Total Childern
ALTER TABLE marketing_campaign_clean
ADD COLUMN total_children INT;

UPDATE marketing_campaign_clean
SET total_children =
kidhome + teenhome;

-- KPI ANALYSIS
-- "Secara keseluruhan, bagaimana performa marketing campaign perusahaan?"

-- KPI Total Customer
SELECT COUNT(*) AS total_customer
FROM marketing_campaign_clean;

-- KPI Overal Respon rate
SELECT
ROUND(AVG(response)*100,2) AS response_rate
FROM marketing_campaign_clean;

-- KPI Total Revenue Opportunity
SELECT
SUM(total_spending) AS total_revenue
FROM marketing_campaign_clean;

-- KPI Average Spending
SELECT
ROUND(AVG(total_spending),2) AS avg_spending
FROM marketing_campaign_clean;

-- KPI Average Income
SELECT
ROUND(AVG(income),2) AS avg_income
FROM marketing_campaign_clean;

-- CAMPAIGN PERFORMANCE ANALYSIS
-- "Campaign mana yang paling berhasil?"

-- Campaign Acceptance
SELECT
SUM(accepted_cmp1 ) AS cmp1,
SUM(accepted_cmp2 ) AS cmp2,
SUM(accepted_cmp3 ) AS cmp3,
SUM(accepted_cmp4 ) AS cmp4,
SUM(accepted_cmp5 ) AS cmp5
FROM marketing_campaign_clean;

-- Campaign Response rate
SELECT
'Campaign 1' AS campaign,
ROUND(AVG(accepted_cmp1)*100,2) AS acceptance_rate
FROM marketing_campaign_clean
UNION ALL
SELECT
'Campaign 2',
ROUND(AVG(accepted_cmp2)*100,2)
FROM marketing_campaign_clean
UNION ALL
SELECT
'Campaign 3',
ROUND(AVG(accepted_cmp3)*100,2)
FROM marketing_campaign_clean
UNION ALL
SELECT
'Campaign 4',
ROUND(AVG(accepted_cmp4)*100,2)
FROM marketing_campaign_clean
UNION ALL
SELECT
'Campaign 5',
ROUND(AVG(accepted_cmp5)*100,2)
FROM marketing_campaign_clean;

-- CUSTOMER PROFILE ANALYSIS
-- "Siapa customer yang paling responsif?"

-- Income Vs Response
SELECT
response,
ROUND(AVG(income),2) avg_income
FROM marketing_campaign_clean
GROUP BY response;

-- Hipotesis
Response = 1
Income lebih tinggi

Customer berpendapatan tinggi lebih responsif terhadap campaign marketing.

-- Age Vs Response
SELECT
response,
ROUND(AVG(age),2) avg_age
FROM marketing_campaign_clean
GROUP BY response;

-- Education Vs Response
SELECT
education,
ROUND(AVG(response)*100,2) response_rate
FROM marketing_campaign_clean
GROUP BY education
ORDER BY response_rate DESC;

-- Marital status vs Response
SELECT
marital_status,
ROUND(AVG(response)*100,2) response_rate
FROM marketing_campaign_clean
GROUP BY marital_status
ORDER BY response_rate DESC;

select marital_status, count(*) as jumlah
from marketing_campaign_clean
group by marital_status
order by jumlah

select
CASE
WHEN marital_status IN ('Married','Together')
THEN 'Partner'
WHEN marital_status IN
('Single','Divorced','Widow','Alone','YOLO','Absurd')
THEN 'Single'
end as gruping_martial,
ROUND(AVG(response)*100,2) response_rate
from marketing_campaign_clean mcc 
group by gruping_martial 


-- SPENDING ANALYSIS

-- Spending Vs Response
SELECT
response,
ROUND(AVG(total_spending),2) avg_spending
FROM marketing_campaign_clean
GROUP BY response;

Insight:

Customer dengan spending tinggi memiliki kemungkinan lebih besar menerima campaign.

-- Product Preferences
-- Product apa yang paling diminati
SELECT
SUM(mnt_wines) wines,
SUM(mnt_fruits) fruits,
SUM(mnt_meat_products) meat,
SUM(mnt_fish_products) fish,
SUM(mnt_sweet_products) sweet,
SUM(mnt_gold_prods) gold
FROM marketing_campaign_clean;

-- PURCHASE CHANNEL ANALYSIS

-- Channel performance
-- "Customer yang menerima campaign lebih sering berbelanja melalui channel apa?"
SELECT
response,
ROUND(AVG(num_web_purchases),2) web_purchase,
ROUND(AVG(num_catalog_purchases),2) catalog_purchase,
ROUND(AVG(num_store_purchases),2) store_purchase
FROM marketing_campaign_clean
GROUP BY response;

SELECT
    response,
    ROUND(AVG(num_web_purchases),2) AS web_purchase,
    ROUND(AVG(num_catalog_purchases),2) AS catalog_purchase,
    ROUND(AVG(num_store_purchases),2) AS store_purchase
FROM marketing_campaign_clean
GROUP BY response
ORDER BY response;

-- RECENCY ANALYSIS
SELECT
response,
ROUND(AVG(recency),2) avg_recency
FROM marketing_campaign_clean
GROUP BY response;

Response = 1
Recency lebih rendah

Customer yang baru saja bertransaksi memiliki probabilitas lebih tinggi menerima campaign.

-- CUSTOMER SEGMENTATION
WITH customer_segment AS (
    SELECT *,
           CASE
               WHEN total_spending >= 1000 THEN 'High Value'
               WHEN total_spending >= 500 THEN 'Medium Value'
               ELSE 'Low Value'
           END AS segment
    FROM marketing_campaign_clean
)
SELECT
    segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(response)*100,2) AS response_rate,
    ROUND(AVG(income),2) AS avg_income,
    ROUND(AVG(total_spending),2) AS avg_spending,
    ROUND(AVG(recency),2) AS avg_recency
FROM customer_segment
GROUP BY segment
ORDER BY avg_spending DESC;

-- Rata-rata respon rate secara keseluruhan
SELECT
    COUNT(*) AS customer_count,
    ROUND(AVG(response)*100,2) AS response_rate
	from marketing_campaign_clean mcc 

select * from marketing_campaign_clean mcc 