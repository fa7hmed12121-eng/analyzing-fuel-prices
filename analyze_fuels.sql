SELECT * from global_fuel_prices_2020_2026
/*
 Find the average prices for each country
*/
SELECT 
    region,
    income_level,
    --ROUND(AVG(diesel_usd_liter),2) diesel_prices,
    ROUND(AVG(petrol_usd_liter),2) pertol_prices,
    ROUND(AVG(lpg_usd_liter),2) lpg_prices
    --ROUND(AVG(brent_crude_usd),2) brent_prices


FROM global_fuel_prices_2020_2026
GROUP BY income_level    ,region
ORDER BY region

/*Find out the average prices for subsidy_level

the countries that have high subsidy level the average prices are 
much lower tha the countries that have low subsidy 
 */

SELECT 
    region,
    subsidy_level,
    --ROUND(AVG(petrol_usd_liter),2) pertol_prices,
    ROUND(AVG(lpg_usd_liter),2) lpg_prices,
    --ROUND(AVG(diesel_usd_liter),2) diesel_prices,
    ROUND(AVG(tax_percentage),2) taxes
FROM global_fuel_prices_2020_2026   
GROUP BY subsidy_level, region
ORDER BY  region

/*-------------------------------
 The trends changes over the time
 __________________________________
 the global prices of petrol are keep increasing 
 100% from 2020 to Q1 2026
 */

 SELECT
    subsidy_level,
    Year(date) the_year,
    --MONTH(date) the_month,
    ROUND(AVG(petrol_usd_liter),2) ptrol_prices,
    ROUND(AVG(diesel_usd_liter),2) diesel_prices,
    ROUND(AVG(lpg_usd_liter),2) lpg_prices,
    ROUND(AVG(brent_crude_usd),2) brent_prices,
    ROUND(AVG(tax_percentage),2) taxes

FROM global_fuel_prices_2020_2026
WHERE region = 'South America'
GROUP BY year(date)  , subsidy_level
ORDER BY the_year

/* Count to countries of each subside level*/

SELECT
    country,
    subsidy_level, income_level,
   -- COUNT(distinct(country)) quantity_of_countries,
    ROUND(AVG(petrol_usd_liter),2) pertol_prices,
    ROUND(AVG(diesel_usd_liter),2) diesel_prices,
    ROUND(AVG(lpg_usd_liter),2) lpg_prices,
    ROUND(AVG(brent_crude_usd),2) brent_prices,
    ROUND(AVG(tax_percentage),2) taxes

FROM global_fuel_prices_2020_2026    
GROUP BY country, subsidy_level, income_level
ORDER BY country

/* 
 The average prices of country with L
 its income_leve */

 SELECT
    region,
    income_level,
    COUNT(distinct(country)) countries,
    ROUND(AVG(petrol_usd_liter),2) pertol_prices,
    ROUND((AVG(lpg_usd_liter)),2) lpq_prices

FROM global_fuel_prices_2020_2026    
GROUP BY region, income_level
ORDER BY region

/* --------------------------
Find the presantage of prices 
increasing through years ---*/

With yearly_prices As (SELECT a_year, 
    avg_petrol,
    avg_lpq,
    ISNULL(pre_avg_petrol, 0) pre_avg_petrol,
    ISNULL(pre_avg_lpq, 0) pre_avg_lpq

FROM
(SELECT *,
    LAG(avg_petrol) OVER(ORDER BY a_year) pre_avg_petrol,
    LAG(avg_lpq) Over(ORDER BY a_year) pre_avg_lpq

FROM(SELECT 
   
    YEAR(date) a_year,
    ROUND(AVG(petrol_usd_liter),2) avg_petrol,
    ROUND(AVG(lpg_usd_liter),2) avg_lpq

FROM global_fuel_prices_2020_2026    
GROUP BY YEAR(date)
 )f
 )n
 )
SELECT a_year ,
    avg_petrol,
  CONCAT(ROUND((petrol_increasing),3), '%') increasing_presantage,
 avg_lpq, 
  CONCAT(ROUND((lpq_increasing),3), '%') increasing_presantage

FROM( Select 
    a_year,
    avg_petrol , 
    (pre_avg_petrol / avg_petrol ) /100 as petrol_increasing,
    avg_lpq,
    (pre_avg_lpq / avg_lpq)/100 as lpq_increasing

    
 FROM yearly_prices )f