SELECT 
	COUNT(*) AS num_of_churned,
	churn_category AS why,
	contract_type AS contract,
	AVG(account_length_in_months) AS avg_month,
	SUM(total_charges) AS tot_losses,
	SUM(total_charges)/COUNT(*) AS avg_loss_per_customer,
    COUNT(*)::float / SUM(COUNT(*)) OVER (PARTITION BY contract_type) AS churn_rate
FROM churn
WHERE churn_label = 'Yes'
GROUP BY churn_category, contract_type
ORDER BY num_of_churned DESC