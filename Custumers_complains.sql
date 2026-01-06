SELECT SUM(customer_service_calls) FILTER (WHERE churn_label = 'Yes') AS total_calls_churned,
       SUM(customer_service_calls) FILTER (WHERE churn_label = 'No') AS total_calls_not_churned,
	   AVG(customer_service_calls) FILTER (WHERE churn_label = 'Yes') AS avg_calls_churned,
       AVG(customer_service_calls) FILTER (WHERE churn_label = 'No') AS avg_calls_not_churned,
       contract_type,
	   CASE WHEN account_length_in_months < 6 THEN 'half_year'
	WHEN account_length_in_months  BETWEEN 6 AND 12 THEN 'year'
	WHEN account_length_in_months  BETWEEN 13 AND 24 THEN 'two_year'
	ELSE 'more_than_2y' END AS tenure,
	COUNT(*) AS tot_customers,
	COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churn_count,
	COUNT(*) FILTER (WHERE churn_label = 'Yes')::float / COUNT(*) AS churn_rate,
	SUM(customer_service_calls) FILTER (WHERE churn_label='Yes') / COUNT(*) FILTER (WHERE churn_label='Yes') AS avg_calls_per_churner


	   
FROM churn  
GROUP BY contract_type, tenure
ORDER BY avg_calls_churned DESC