WITH customer_base AS (
    SELECT
        customer_id,
        contract_type AS contract,
        churn_label,
        account_length_in_months,
        intl_mins,
        intl_calls,
        monthly_charge,
        total_charges,
        intl_mins::float / NULLIF(account_length_in_months, 0) AS avg_local_mins_per_month,
        CASE 
            WHEN intl_mins < 400 THEN 'low_usage'
            WHEN intl_mins < 800 THEN 'mid_usage'
            ELSE 'high_usage'
        END AS tier
    FROM churn
)
, local_usage AS (
    SELECT
        contract,
        tier,
        COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churn_count,
        COUNT(*) FILTER (WHERE churn_label = 'No') AS non_churn_count,
        COUNT(*) FILTER (WHERE churn_label = 'Yes')::float / COUNT(*) AS churn_rate,
        AVG(avg_local_mins_per_month) FILTER (WHERE churn_label = 'Yes') AS avg_mins_pm_churn,
        AVG(avg_local_mins_per_month) FILTER (WHERE churn_label = 'No') AS avg_mins_pm_non_churn,
        SUM(total_charges) FILTER (WHERE churn_label = 'Yes') AS losses,
        SUM(total_charges) FILTER (WHERE churn_label = 'No') AS profits
    FROM customer_base
    GROUP BY contract, tier
)
SELECT *,
       RANK() OVER (PARTITION BY contract ORDER BY churn_rate DESC) AS rank_usage
FROM local_usage
ORDER BY contract, rank_usage;
