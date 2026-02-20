#---------------------INTRODUCTION TO THE DATASET-------------#

CREATE DATABASE vehicles_carbon_emission;
USE vehicles_carbon_emission;

# Display first five rows of dataset
SELECT * FROM vehicles LIMIT 5;

# Total no of Records in the dataset
SELECT COUNT(*) FROM vehicles;

#---------------------DATA PREPROCESSING--------------------#

# Check Missing  values in the dataset

SELECT 
COUNT(*) - COUNT(Brand) as missing_brand,
COUNT(*) - COUNT(Model) as missing_model,
COUNT(*) - COUNT(`Engine_Size(L)`) as missing_engine_size,
COUNT(*) - COUNT(Cylinders) as missing_cylinders,
COUNT(*) - COUNT(Transmission) as missing_Transmission,
COUNT(*) - COUNT(Fuel_type) as missing_Fuel_type,
COUNT(*) - COUNT(`Fuel_consumption_city(L/100 km)`) as missing_Fuel_consumption_city,
COUNT(*) - COUNT(`Fuel_consumption_hwy(L/100 km)`) as missing_Fuel_consumption_hwy,
COUNT(*) - COUNT(`Fuel_consumption_comb(L/100 km)`) as missing_Fuel_consumption_comb,
COUNT(*) - COUNT(`Fuel_consumption_comb(mpg)`) as missing_Fuel_consumption_comb,
COUNT(*) - COUNT(`CO2_emissions(g/km)`) as missing_CO2_emissions
FROM vehicles;
#-----------------------------------------------------------------------------------------------------------------------------

# Check duplicates in the dataset

SELECT Brand, Model, Vehicle_class, `Engine_Size(L)`, Cylinders, Transmission, Fuel_type, COUNT(*) AS dup_count
FROM vehicles
GROUP BY Brand, Model, Vehicle_class, `Engine_Size(L)`, Cylinders, Transmission, Fuel_type
HAVING COUNT(*) > 1;


#----------------------------EXPLORATORY DATA ANALYSIS------------------------------------#

# 1) Total number of unique Brands, Models, Vehicle Classes in the Dataset

SELECT COUNT(*) as Total_records,
COUNT(DISTINCT Brand) as Unique_Brands,
COUNT(DISTINCT Model) as Unique_Models,
COUNT(DISTINCT Vehicle_class) as Unique_Vehicle_Classes
FROM vehicles;
#-----------------------------------------------------------------------------------------------------------------------------

# 2) What are the top 10 vehicle brands with the most unique models?

SELECT Brand, COUNT(DISTINCT Model) as Total_models FROM vehicles 
GROUP BY Brand ORDER BY Total_models DESC LIMIT 10;
#-----------------------------------------------------------------------------------------------------------------------------

# 3) Distribution of Vehicle Classes

SELECT Vehicle_class, COUNT(*) AS count FROM vehicles 
GROUP BY Vehicle_class ORDER BY count DESC;
#-----------------------------------------------------------------------------------------------------------------------------

# 4) Distribution of Fuel Type

SELECT Fuel_type, COUNT(*) AS count FROM vehicles 
GROUP BY Fuel_type ORDER BY count DESC;
#-----------------------------------------------------------------------------------------------------------------------------

# 5) Distribution of Transmission Types

SELECT Transmission, COUNT(*) AS count FROM vehicles 
GROUP BY Transmission ORDER BY count DESC;
#-----------------------------------------------------------------------------------------------------------------------------

# 6) Which are the 10 vehicles with the highest CO2 emissions per kilometer?

SELECT * FROM vehicles ORDER BY `CO2_emissions(g/km)` DESC LIMIT 10;
#-----------------------------------------------------------------------------------------------------------------------------

# 7) What are the 10 vehicles with the lowest CO2 emissions per kilometer?

SELECT * FROM vehicles ORDER BY `CO2_emissions(g/km)` LIMIT 10;
#-----------------------------------------------------------------------------------------------------------------------------

# 8) Top 10 most fuel-efficient Vehicles

SELECT Brand, Model FROM vehicles ORDER BY `Fuel_consumption_comb(L/100 km)` ASC LIMIT 10;
#-----------------------------------------------------------------------------------------------------------------------------

# 9) Which vehicle has the minimum CO2 emissions and maximum fuel efficiency?

SELECT Brand, Model, Vehicle_class, 
MIN(`CO2_emissions(g/km)`) AS min_co2,
MIN(`Fuel_consumption_comb(mpg)`) AS min_fuel
FROM vehicles
GROUP BY Brand, Model, Vehicle_class
ORDER BY min_co2, min_fuel
LIMIT 1;
#-----------------------------------------------------------------------------------------------------------------------------

# 10) Which vehicle has the high CO2 emissions and minimum fuel efficiency?

SELECT Brand, Model, Vehicle_class, 
MAX(`CO2_emissions(g/km)`) AS max_co2,
MAX(`Fuel_consumption_comb(mpg)`) AS max_fuel
FROM vehicles
GROUP BY Brand, Model, Vehicle_class
ORDER BY max_co2 DESC, max_fuel DESC
LIMIT 1;

#-----------------------------------------VEHICLES PERFORMANCE ANALYSIS--------------------------------------------#

# 11) Average co2 emission and Fuel Consumption by Brand

SELECT Brand, ROUND(AVG(`Fuel_consumption_comb(L/100 km)`), 2) as avg_fuel_consumption,
ROUND(AVG(`CO2_emissions(g/km)`), 2) AS avg_CO2_g_per_km
FROM vehicles
GROUP BY Brand
ORDER BY avg_fuel_consumption DESC;
#-----------------------------------------------------------------------------------------------------------------------------

# 12) Average co2 emission and Fuel Consumption by Cylinders

SELECT Cylinders, COUNT(*) as vehicle_count,
ROUND(AVG(`Engine_Size(L)`), 2) as avg_engine_size,
ROUND(AVG(`Fuel_consumption_comb(L/100 km)`), 2) as avg_fuel_consumption,
ROUND(AVG(`CO2_emissions(g/km)`), 2) as avg_co2_emissions
FROM vehicles
GROUP BY Cylinders
ORDER BY Cylinders;

# 13) Average CO₂ Emissions by Fuel Type

SELECT Fuel_type, ROUND(AVG(`CO2_emissions(g/km)`), 2) AS avg_CO2_g_per_km
FROM vehicles GROUP BY Fuel_type ORDER BY avg_CO2_g_per_km  ;
#-----------------------------------------------------------------------------------------------------------------------------

# 14) Find the Average CO₂ Emissions by Vehicle Class

SELECT Vehicle_class, 
ROUND(AVG(`Fuel_consumption_comb(L/100 km)`), 2) as avg_fuel_consumption,
ROUND(AVG(`CO2_emissions(g/km)`), 2) AS avg_CO2_g_per_km
FROM vehicles
GROUP BY Vehicle_class ORDER BY avg_CO2_g_per_km DESC;
#-----------------------------------------------------------------------------------------------------------------------------

# 15) Average Fuel Consumption and CO2 Emission by Transmission Type

SELECT Transmission,
ROUND(AVG(`Fuel_consumption_comb(L/100 km)`), 2) AS avg_fuel_consumption, 
ROUND(AVG(`CO2_emissions(g/km)`), 2) AS avg_CO2_g_per_km
FROM vehicles
GROUP BY Transmission ORDER BY avg_CO2_g_per_km, avg_fuel_consumption;
#-----------------------------------------------------------------------------------------------------------------------------

# 16) Find the Correlation Between Engine Size and CO₂ Emissions and fuel consumption

SELECT `Engine_Size(L)`, 
ROUND(AVG(`CO2_emissions(g/km)`), 2) AS avg_CO2_g_per_km,
ROUND(AVG(`Fuel_consumption_comb(L/100 km)`), 2) AS avg_fuel_consumption
FROM vehicles 
GROUP BY `Engine_Size(L)` 
ORDER BY `Engine_Size(L)`;
#-----------------------------------------------------------------------------------------------------------------------------

# 17) Average fuel consumption by fuel type

SELECT Fuel_type, ROUND(AVG(`Fuel_consumption_comb(L/100 km)`), 2) AS avg_fuel_consumption
FROM vehicles GROUP BY Fuel_type ORDER BY avg_fuel_consumption;
#-----------------------------------------------------------------------------------------------------------------------------

# 18) How do CO2 emissions and fuel consumption vary by vehicle class and engine size?

WITH engine_grp AS (
SELECT *,
CASE
WHEN `Engine_Size(L)` < 1.5 THEN 'Small'
WHEN `Engine_Size(L)` BETWEEN 1.5 AND 2.5 THEN 'Medium'
ELSE 'Large'
END AS engine_cat
FROM vehicles
)
SELECT
engine_cat, Vehicle_class,
ROUND(AVG(`CO2_emissions(g/km)`), 2) AS avg_co2,
ROUND(AVG(`Fuel_consumption_comb(L/100 km)`), 2) AS avg_fuel
FROM engine_grp
GROUP BY engine_cat, Vehicle_class
ORDER BY engine_cat, avg_co2 DESC;
#-----------------------------------------------------------------------------------------------------------------------------

# 19) Compare City vs Highway Efficiency per Vehicle

SELECT Brand, Model,
`Fuel_consumption_city(L/100 km)`, `Fuel_consumption_hwy(L/100 km)`,
`Fuel_consumption_city(L/100 km)` - `Fuel_consumption_hwy(L/100 km)` AS diff_city_hwy,
RANK() OVER (
ORDER BY (`Fuel_consumption_city(L/100 km)` - `Fuel_consumption_hwy(L/100 km)`) DESC) AS rank_biggest_diff
FROM vehicles;
#-----------------------------------------------------------------------------------------------------------------------------

# 20) CO₂ per Liter of Engine (Emission Intensity Ratio)

SELECT
  Brand, Model, `Engine_Size(L)`,
  ROUND(`CO2_emissions(g/km)` / `Engine_Size(L)`, 2) AS co2_per_liter,
  RANK() OVER (
    ORDER BY `CO2_emissions(g/km)` / `Engine_Size(L)` ASC
  ) AS rank_most_efficient_ratio
FROM vehicles;
#-----------------------------------------------------------------------------------------------------------------------------

# 21) What is the distribution of vehicles by their CO2 emission levels, categorized as Low, Moderate, Medium, High, Very High, and Extremely High Emission?

WITH categories AS (
SELECT Brand, Model, `CO2_emissions(g/km)`,
CASE 
WHEN `CO2_emissions(g/km)` <= 100 THEN 'Low Emission'
WHEN `CO2_emissions(g/km)` BETWEEN 101 AND 150 THEN 'Moderate Emission'
WHEN `CO2_emissions(g/km)` BETWEEN 151 AND 200 THEN 'Medium Emission'
WHEN `CO2_emissions(g/km)` BETWEEN 201 AND 250 THEN 'High Emission'
WHEN `CO2_emissions(g/km)` BETWEEN 251 AND 300 THEN 'Very High Emission'
ELSE 'Extremely High Emission'
END AS emission_category
FROM vehicles
)
SELECT emission_category, COUNT(*) AS number_of_vehicles
FROM categories
GROUP BY emission_category
ORDER BY emission_category;
#-----------------------------------------------------------------------------------------------------------------------------

# 22) Total percentage of vehicles where co2 emission > 200

WITH high_emissions AS (
SELECT COUNT(*) AS count_high_emissions
FROM vehicles
WHERE `CO2_emissions(g/km)` > 200
)
SELECT ROUND((count_high_emissions / (SELECT COUNT(*) FROM vehicles)) * 100, 2) AS percentage_high_emissions
FROM high_emissions;
#-----------------------------------------------------------------------------------------------------------------------------

# 23) Total percentage of vehicles where co2 emission <150

WITH low_emissions AS (
SELECT COUNT(*) AS count_low_emissions
FROM vehicles
WHERE `CO2_emissions(g/km)` <= 150
)
SELECT ROUND((count_low_emissions / (SELECT COUNT(*) FROM vehicles)) * 100, 2) AS percentage_low_emissions
FROM low_emissions;
#-----------------------------------------------------------------------------------------------------------------------------

# 24) Categorize the vehicles based on fuel efficiency

SELECT Brand, Model, `Fuel_consumption_comb(L/100 km)`,
CASE
WHEN `Fuel_consumption_comb(L/100 km)` <= 5 THEN 'Excellent'
WHEN `Fuel_consumption_comb(L/100 km)` BETWEEN 5 AND 7 THEN 'Good'
WHEN `Fuel_consumption_comb(L/100 km)` BETWEEN 7 AND 10 THEN 'Fair'
ELSE 'Poor'
END AS fuel_efficiency_rating
FROM vehicles;
#-----------------------------------------------------------------------------------------------------------------------------

#25) Find the number of vehicles coming under different fuel_efficiency category

SELECT fuel_efficiency_rating, COUNT(*) AS count
FROM (
SELECT Brand, Model, `Fuel_consumption_comb(L/100 km)`,
CASE
WHEN `Fuel_consumption_comb(L/100 km)` <= 5 THEN 'Excellent'
WHEN `Fuel_consumption_comb(L/100 km)` BETWEEN 5 AND 7 THEN 'Good'
WHEN `Fuel_consumption_comb(L/100 km)` BETWEEN 7 AND 10 THEN 'Fair'
ELSE 'Poor'
END AS fuel_efficiency_rating
FROM vehicles
) AS efficiency
GROUP BY fuel_efficiency_rating;
#--------------------------------------------------------------

#26) Which engine size category offers the best balance between performance and fuel economy?

WITH engine_categorized AS (
SELECT Brand, Model, `Engine_Size(L)`, `Fuel_consumption_comb(L/100 km)`, `CO2_emissions(g/km)`,
CASE 
WHEN `Engine_Size(L)` <= 1.5 THEN 'Small (≤1.5L)'
WHEN `Engine_Size(L)` <= 3.0 THEN 'Medium (1.5-3.0L)'
WHEN `Engine_Size(L)` <= 5.0 THEN 'Large (3.0-5.0L)'
ELSE 'Very Large (>5.0L)'
END as engine_category
FROM vehicles
)
SELECT engine_category, COUNT(*) as vehicle_count,
ROUND(AVG(`Fuel_consumption_comb(L/100 km)`), 2) as avg_fuel_consumption,
ROUND(AVG(`CO2_emissions(g/km)`), 2) as avg_co2_emissions
FROM engine_categorized
GROUP BY engine_category
ORDER BY avg_fuel_consumption;










