SELECT 
    contract_type AS contract,
    COUNT(*) FILTER (WHERE intl_plan = 'yes') AS intl_plan_churned,
    COUNT(*) FILTER (WHERE intl_plan = 'no') AS no_intl_plan_churned,
    AVG(monthly_charge) FILTER (WHERE intl_plan = 'yes') AS avg_monthly_charge_intl,
    AVG(monthly_charge) FILTER (WHERE intl_plan = 'no') AS avg_monthly_charge_no_intl,
    AVG(extra_international_charges) FILTER (WHERE intl_plan = 'no') AS avg_extra_intl_charge_no_plan,
    AVG(intl_calls) FILTER (WHERE intl_plan = 'yes') AS avg_intl_calls_plan,
    AVG(intl_calls) FILTER (WHERE intl_plan = 'no') AS avg_intl_calls_no_plan,
    AVG(intl_mins) FILTER (WHERE intl_plan = 'yes') AS avg_intl_mins_plan,
    AVG(intl_mins) FILTER (WHERE intl_plan = 'no') AS avg_intl_mins_no_plan,
    CASE 
        WHEN intl_mins < 400 THEN 'low_usage'
        WHEN intl_mins >= 400 AND intl_mins < 800 THEN 'mid_usage'
        ELSE 'high_usage'
    END AS usage_tier,
    COUNT(*) FILTER (WHERE intl_plan='yes')::float / COUNT(*) AS intl_plan_churn_rate
FROM churn
WHERE churn_label = 'Yes'
GROUP BY contract_type, usage_tier
ORDER BY intl_plan_churned DESC;
