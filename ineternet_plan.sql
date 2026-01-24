WITH customer_plan AS (SELECT
						customer_id,
						contract_type AS contract,
						account_length_in_months,
						avg_monthly_gb_download,
						unlimited_data_plan,
						monthly_charge,
						extra_data_charges,
						avg_monthly_gb_download::float / NULLIF(account_length_in_months, 0) AS gb_per_month,
						CASE 
            				WHEN avg_monthly_gb_download < 15 THEN 'low_usage'
            				WHEN avg_monthly_gb_download BETWEEN 15 AND 30 THEN 'mid_usage'
            				ELSE 'high_usage'
        					END AS usage_tier
						FROM churn
						WHERE churn_label = 'Yes'),
data_plan AS (
    SELECT 
        contract,
		usage_tier,
        COUNT(*) FILTER (WHERE unlimited_data_plan = 'Yes') AS unlimited_plan_churned,
        COUNT(*) FILTER (WHERE unlimited_data_plan = 'No') AS limited_plan_churned,
        AVG(monthly_charge) FILTER (WHERE unlimited_data_plan = 'Yes') AS avg_monthly_charge_unlimited,
        AVG(monthly_charge) FILTER (WHERE unlimited_data_plan = 'No') AS avg_monthly_charge_limited,
        AVG(extra_data_charges) FILTER (WHERE unlimited_data_plan = 'No') AS avg_extra_data_limited,
        SUM(gb_per_month) FILTER (WHERE unlimited_data_plan = 'Yes') AS total_gb_unlimited,
        SUM(gb_per_month) FILTER (WHERE unlimited_data_plan = 'No') AS total_gb_limited
        
    FROM customer_plan
    
    GROUP BY contract, usage_tier
)
SELECT *,
       RANK() OVER (PARTITION BY usage_tier ORDER BY total_gb_unlimited DESC) AS gb_rank
FROM data_plan
ORDER BY unlimited_plan_churned DESC;
--Analyze churn patterns for unlimited vs limited data plans, segmented by usage tiers and contract types.
