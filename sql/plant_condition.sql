-- Integrated Plant Health/ Condition
WITH PlantHealth AS
(
SELECT
k.Date,
k.Production_Tonnes,
k.Achievement_Percent,
k.Yield_Percent,
k.Profit_per_Tonne_INR,
d.Total_Downtime_Hours,
ROUND(
k.Production_Tonnes*k.Profit_per_Tonne_INR,2
)
AS Daily_Profit
FROM daily_steel_plant_kpi_2025 k
JOIN downtime_reason_breakdown_2025 d
ON k.Date=d.Date)

SELECT
Date,
Daily_Profit,
Total_Downtime_Hours,
RANK() OVER(
ORDER BY Daily_Profit DESC
) Profit_Rank,
CASE
WHEN Achievement_Percent>=95 THEN 'Excellent'
WHEN Achievement_Percent>=90 THEN 'Good'
ELSE 'Poor'
END Plant_Status
FROM PlantHealth;
-- Monthy Dashboard
SELECT
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    SUM(Production_Tonnes) AS Production,
    ROUND(AVG(Yield_Percent),2) AS Yield,
    ROUND(AVG(Achievement_Percent),2) AS Achievement,
    SUM(Revenue_INR) AS Revenue,
    ROUND(SUM(Production_Tonnes * Profit_per_Tonne_INR),2) AS Profit
FROM daily_steel_plant_kpi_2025
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY Month;
-- Monthly Business Performance
SELECT
    DATE_FORMAT(Date,'%Y-%m') AS Month,
    SUM(Production_Tonnes) AS Production,
    SUM(Revenue_INR) AS Revenue,
    SUM(Total_Manufacturing_Cost_INR) AS Cost,
    ROUND(SUM(Production_Tonnes * Profit_per_Tonne_INR),2) AS Profit
FROM daily_steel_plant_kpi_2025
GROUP BY DATE_FORMAT(Date,'%Y-%m')
ORDER BY Month;