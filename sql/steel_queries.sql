-- Daily Executive KPI
use steel;
SELECT
SUM(Production_Tonnes) AS Total_Production,
ROUND(AVG(Achievement_Percent),2) AS Avg_Achievement,
ROUND(AVG(Yield_Percent),2) AS Avg_Yield,
SUM(Revenue_INR) AS Total_Revenue,
SUM(Total_Manufacturing_Cost_INR) AS Total_Cost,
ROUND(SUM(Production_Tonnes*Profit_per_Tonne_INR),2) AS Total_Profit
FROM daily_steel_plant_kpi_2025;

-- Monthly Business Performance
SELECT
DATE_FORMAT(STR_TO_DATE(Date,'%d %M %Y'),'%Y-%m') AS Month,
SUM(Production_Tonnes) Production,
SUM(Revenue_INR) Revenue,
SUM(Total_Manufacturing_Cost_INR) Cost,
SUM(Production_Tonnes*Profit_per_Tonne_INR) Profit
FROM daily_steel_plant_kpi_2025
GROUP BY Month
ORDER BY Month;
-- Shift Performance Comparison
SELECT
ROUND(AVG(Shift_A_0600_1400_Tonnes),2) Shift_A,
ROUND(AVG(Shift_B_1400_2200_Tonnes),2) Shift_B,
ROUND(AVG(Shift_C_2200_0600_Tonnes),2) Shift_C,
ROUND(AVG(Shift_A_Downtime_Hours),2) ShiftA_Downtime,
ROUND(AVG(Shift_B_Downtime_Hours),2) ShiftB_Downtime,
ROUND(AVG(Shift_C_Downtime_Hours),2) ShiftC_Downtime
FROM shift_wise_production_2025;

-- Downtime Breakdown
SELECT
SUM(Mechanical_Failure) Mechanical,
SUM(Electrical_Fault) Electrical,
SUM(Power_Grid_Outage) PowerGrid,
SUM(Raw_Material_Shortage) RawMaterial,
SUM(Planned_Maintenance) Maintenance,
SUM(Quality_Hold) Quality,
SUM(Labour_Shift_Change) Labour
FROM downtime_reason_breakdown_2025;
-- Profit Margin
SELECT
Date,
ROUND(
((Revenue_INR-Total_Manufacturing_Cost_INR)
/Revenue_INR)*100,2)
AS Profit_Margin
FROM daily_steel_plant_kpi_2025;

-- Running Production (Window Function)
SELECT
Date,
Production_Tonnes,
round(SUM(Production_Tonnes)
OVER(
ORDER BY STR_TO_DATE(Date,'%d %M %Y')
),2)
Running_Production
FROM daily_steel_plant_kpi_2025;

-- Rolling 7-Day Production
SELECT
Date,
Production_Tonnes,
ROUND(
AVG(Production_Tonnes)
OVER(
ORDER BY STR_TO_DATE(Date,'%d %M %Y')
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
),2)
Rolling_Production
FROM daily_steel_plant_kpi_2025;

-- Daily Production Change (LAG)
SELECT
Date,
Production_Tonnes,
Production_Tonnes-
LAG(Production_Tonnes)
OVER(
ORDER BY STR_TO_DATE(Date,'%d %M %Y')
)
AS Daily_Change
FROM daily_steel_plant_kpi_2025;

-- Plant Performance Category
with perf as (
SELECT
Date,
Achievement_Percent,
CASE
WHEN Achievement_Percent>=95 THEN 'Excellent'
WHEN Achievement_Percent>=90 THEN 'Good'
ELSE 'Needs Attention'
END AS Performance
FROM daily_steel_plant_kpi_2025)
select performance ,count(performance)as No_of_days from perf
group by performance;


--  Production + Downtime
SELECT
k.Date,
k.Production_Tonnes,
k.Yield_Percent,
d.Total_Downtime_Hours,
d.Mechanical_Failure,
d.Electrical_Fault
FROM daily_steel_plant_kpi_2025 k
JOIN downtime_reason_breakdown_2025 d
ON k.Date =d.Date;

-- Production + Raw Material Prices
SELECT
    k.Date,
    k.Manufacturing_Cost_per_Tonne_INR,
    r.Iron_Ore_Price_INR_per_Tonne,
    r.Coal_Coke_Price_INR_per_Tonne
FROM daily_steel_plant_kpi_2025 k
JOIN monthly_raw_material_prices_2025 r
ON DATE_FORMAT(k.Date, '%Y-%m') = r.Month;  -- Not working /////// 
-- Top 10 Most Profitable Days
WITH ProfitCTE AS
(
SELECT
Date,
ROUND(
Production_Tonnes*Profit_per_Tonne_INR,2
)
AS Profit
FROM daily_steel_plant_kpi_2025
)
SELECT *
FROM ProfitCTE
ORDER BY Profit DESC
LIMIT 10;

-- RANK Best Production Days
SELECT
Date,
Production_Tonnes,
RANK() OVER(
ORDER BY Production_Tonnes DESC
) Production_Rank
FROM daily_steel_plant_kpi_2025;
