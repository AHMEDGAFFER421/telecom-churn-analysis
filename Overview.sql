SELECT 
    churn_category AS reason,
    contract_type AS contract,
    COUNT(*) AS churn_count,
    COUNT(*)::float / SUM(COUNT(*)) OVER (PARTITION BY contract_type) AS churn_rate,
    AVG(account_length_in_months) AS avg_tenure_months,
    SUM(total_charges) AS total_loss,
    SUM(total_charges)/COUNT(*) AS avg_loss_per_customer
FROM churn
WHERE churn_label = 'Yes'
GROUP BY churn_category, contract_type
ORDER BY total_loss DESC;



--Identify which churn reasons are most common and which contracts are most affected. This helps understand the why behind churn and the revenue impact.
