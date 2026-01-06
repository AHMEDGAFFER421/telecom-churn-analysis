WITH data_plan AS (
    SELECT 
        contract_type AS contract,
        COUNT(*) FILTER (WHERE unlimited_data_plan = 'Yes') AS unlimited_plan_churned,
        COUNT(*) FILTER (WHERE unlimited_data_plan = 'No') AS limited_plan_churned,
        AVG(monthly_charge) FILTER (WHERE unlimited_data_plan = 'Yes') AS avg_monthly_charge_unlimited,
        AVG(monthly_charge) FILTER (WHERE unlimited_data_plan = 'No') AS avg_monthly_charge_limited,
        AVG(extra_data_charges) FILTER (WHERE unlimited_data_plan = 'No') AS avg_extra_data_limited,
        SUM(avg_monthly_gb_download) FILTER (WHERE unlimited_data_plan = 'Yes') AS total_gb_unlimited,
        SUM(avg_monthly_gb_download) FILTER (WHERE unlimited_data_plan = 'No') AS total_gb_limited,
        CASE 
            WHEN avg_monthly_gb_download < 15 THEN 'low_usage'
            WHEN avg_monthly_gb_download BETWEEN 15 AND 30 THEN 'mid_usage'
            ELSE 'high_usage'
        END AS usage_tier
    FROM churn
    WHERE churn_label = 'Yes'
    GROUP BY contract_type, usage_tier
)
SELECT *,
       RANK() OVER (PARTITION BY usage_tier ORDER BY total_gb_unlimited DESC) AS gb_rank
FROM data_plan
ORDER BY unlimited_plan_churned DESC;
