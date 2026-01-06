SELECT
	COUNT(*) AS churned,
	CASE WHEN account_length_in_months < 6 THEN 'half_year'
	WHEN account_length_in_months  BETWEEN 6 AND 12 THEN 'year'
	WHEN account_length_in_months  BETWEEN 13 AND 24 THEN 'two_year'
	ELSE 'more_than_2y' END AS tenure,
	SUM(total_charges) AS tot_losses,
	AVG(monthly_charge) AS avg_monthly_charge,
	SUM(total_charges) / COUNT(*) AS avg_loss_per_customer,
    COUNT(*)::float / SUM(COUNT(*)) OVER (PARTITION BY contract_type) AS churn_rate,
	SUM(total_charges)/SUM(account_length_in_months) AS avg_monthly_per_customer,
	
	contract_type AS contract
	
FROM churn
WHERE churn_label = 'Yes'  
GROUP BY tenure, contract_type
ORDER BY tot_losses DESC

	