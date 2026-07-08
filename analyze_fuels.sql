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
WHERE country Is ''     
GROUP BY subsidy_level, region
ORDER BY  region

/*-------------------------------
 The trends changes over the time
 __________________________________
 the global prices of petrol are keep increasing 
 100% from 2020 to Q1 2026
 */

 SELECT
    Year(date) the_year,
    MONTH(date) the_month,
    ROUND(AVG(petrol_usd_liter),2) ptrol_prices,
    ROUND(AVG(tax_percentage),2) taxes

FROM global_fuel_prices_2020_2026
GROUP BY year(date)  , MONTH(date) 
ORDER BY the_year, the_month

/* Count to countries of each subside level*/

SELECT
    region,
    subsidy_level,
    COUNT(distinct(country)) quantity_of_countries,
    ROUND(AVG(petrol_usd_liter),2) pertol_prices

FROM global_fuel_prices_2020_2026    
GROUP BY region, subsidy_level
ORDER BY region



 