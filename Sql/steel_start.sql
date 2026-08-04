SHOW TABLES;
DESCRIBE daily_steel_plant_kpi_2025;
-- Count Stats
SELECT COUNT(*) AS Total_Rows
FROM daily_steel_plant_kpi_2025;
SELECT COUNT(*) AS Total_Rows
FROM shift_wise_production_2025;
SELECT COUNT(*) AS Total_Rows
FROM downtime_reason_breakdown_2025;
SELECT COUNT(*) AS Total_Rows
FROM monthly_raw_material_prices_2025;
-- Production Stats 
SELECT
SUM(Production_Tonnes) AS Total_Production ,
MAX(Production_Tonnes) AS Highest_Production,
AVG(Production_Tonnes) AS Average_Production,
Min(Production_Tonnes) AS Min_Production
FROM daily_steel_plant_kpi_2025;

-- Production Target Analysis 

SELECT
AVG(Target_Tonnes) AS Average_Target,
AVG(Achievement_Percent) AS Average_Achievement,
MIN(Achievement_Percent) AS Lowest_Achievement,
MAX(Achievement_Percent) AS Highest_Achievement
FROM daily_steel_plant_kpi_2025;

-- Financial Overview
SELECT
SUM(Revenue_INR) AS Total_Revenue,
SUM(Total_Manufacturing_Cost_INR) AS Total_Manufacturing_Cost,
AVG(Profit_per_Tonne_INR) AS Average_Profit_Per_Tonne,
MAX(Profit_per_Tonne_INR) AS Highest_Profit_Per_Tonne
FROM daily_steel_plant_kpi_2025;

-- Utility Consumption
SELECT
AVG(Energy_Consumption_MWh) AS Avg_Energy,
AVG(Coal_Consumption_Tonnes) AS Avg_Coal,
AVG(Steam_Consumption_Tonnes) AS Avg_Steam,
AVG(Water_Consumption_KL) AS Avg_Water
FROM daily_steel_plant_kpi_2025;
-- Quality Analysis
SELECT
AVG(Yield_Percent) AS Average_Yield,
AVG(Defect_Percent) AS Average_Defect,
SUM(Defect_Tonnes) AS Total_Defect_Tonnes
FROM daily_steel_plant_kpi_2025;
-- Downtime Analysis
SELECT
AVG(Downtime_Hours) AS Average_Downtime,
MAX(Downtime_Hours) AS Maximum_Downtime,
MIN(Downtime_Hours) AS Minimum_Downtime
FROM daily_steel_plant_kpi_2025;
-- Check
SELECT
COUNT(*) AS Total_Records,
COUNT(Production_Tonnes) AS Production_Not_Null,
COUNT(Target_Tonnes) AS Target_Not_Null,
COUNT(Revenue_INR) AS Revenue_Not_Null,
COUNT(Profit_per_Tonne_INR) AS Profit_Not_Null
FROM daily_steel_plant_kpi_2025;