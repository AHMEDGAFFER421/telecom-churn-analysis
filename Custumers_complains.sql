WITH Cte AS (SELECT
				customer_id,
				churn_label,
    			contract_type AS contract,
				customer_service_calls,
				account_length_in_months,
   		 		CASE 
        			WHEN account_length_in_months < 6 THEN 'half_year'
        			WHEN account_length_in_months BETWEEN 6 AND 12 THEN 'year'
        			WHEN account_length_in_months BETWEEN 13 AND 24 THEN 'two_year'
        			ELSE 'more_than_2y'
    			END AS tenure,
				customer_service_calls::float / NULLIF(account_length_in_months, 0) AS avg_complaints_per_month
				FROM churn),
customer_complaints AS	(SELECT
				tenure,
				contract,
   				COUNT(*) AS total_customers,
    			COUNT(*) FILTER (WHERE churn_label = 'Yes') AS churn_count,
    			COUNT(*) FILTER (WHERE churn_label = 'Yes')::float / COUNT(*) AS churn_rate,
    			SUM(avg_complaints_per_month) FILTER (WHERE churn_label = 'Yes') AS total_complaints_per_month_churned,
    			AVG(avg_complaints_per_month) FILTER (WHERE churn_label = 'Yes') AS avg_complaints_per_month_churned,
    			SUM(avg_complaints_per_month) FILTER (WHERE churn_label = 'No') AS total_complaints_per_month_churned,
    			AVG(avg_complaints_per_month) FILTER (WHERE churn_label = 'No') AS avg_complaints_per_month_non_churned
				FROM Cte  
				GROUP BY contract, tenure
				ORDER BY avg_complaints_per_month_churned DESC)
SELECT *,
       RANK() OVER (PARTITION BY contract ORDER BY churn_rate DESC) AS rank_usage
FROM customer_complaints
ORDER BY contract, rank_usage;

--Investigate whether higher customer service calls are associated with churn, across contract types and tenure.
