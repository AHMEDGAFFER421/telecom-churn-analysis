WITH churn_by_tenure AS	(SELECT
    			COUNT(*) AS churn_count,
    			CASE 
        			WHEN account_length_in_months < 6 THEN 'half_year'
       			 	WHEN account_length_in_months BETWEEN 6 AND 12 THEN 'year'
        			WHEN account_length_in_months BETWEEN 13 AND 24 THEN 'two_year'
        			ELSE 'more_than_2y'
    			END AS tenure,
    			contract_type AS contract,
    			SUM(total_charges) AS total_loss,
    			AVG(monthly_charge) AS avg_monthly_charge,
    			SUM(total_charges)/COUNT(*) AS avg_loss_per_customer,
    			COUNT(*)::float / SUM(COUNT(*)) OVER (PARTITION BY contract_type) AS churn_rate
				FROM churn
				WHERE churn_label = 'Yes'
				GROUP BY tenure, contract_type
				ORDER BY total_loss DESC)

SELECT *,
	   AVG(total_loss) OVER (PARTITION BY contract) AS avg_loss_per_contract,
	   RANK() OVER (PARTITION BY contract) AS rank_losses 

	   
FROM churn_by_tenure 
-- Show how customer tenure and contract type relate to churn, total revenue lost, and churn rate.
