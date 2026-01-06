# telecom-churn-analysis
SQL project analyzing customer churn
# Telecom Churn Analysis – SQL Portfolio Project

## Project Overview

This project analyzes customer churn in a telecom dataset using SQL. The goal is to identify **who churns, why they churn, and which segments cause the highest revenue loss**, using realistic business-oriented metrics.

The analysis focuses on:

* Contract type and customer tenure
* Customer service interactions
* Data and international plan usage
* Revenue impact of churn

---

## Dataset

**Table:** `churn`

Key columns used:

* `churn_label`
* `contract_type`
* `account_length_in_months`
* `monthly_charge`, `total_charges`
* `customer_service_calls`
* `unlimited_data_plan`, `avg_monthly_gb_download`, `extra_data_charges`
* `intl_plan`, `intl_calls`, `intl_mins`, `extra_international_charges`
* `churn_category`

---

## 1. Churn Reasons by Contract Type

**Question:** Which churn reasons occur most frequently, and which cause the highest revenue loss?

**Key Metrics:**

* Churn count
* Average tenure
* Total revenue lost

**Insight:**
Month-to-Month contracts dominate most churn categories and account for the highest cumulative revenue loss.

---

## 2. Churn by Tenure and Contract Type

**Question:** How does customer tenure affect churn and revenue loss?

**Key Metrics:**

* Churn count
* Churn rate per contract
* Total revenue lost
* Average revenue per churned customer

**Insight:**
Short-tenure, Month-to-Month customers churn most frequently, while long-tenure customers contribute higher loss per churn event.

---

## 3. Customer Service Calls vs Churn

**Question:** Do frequent service calls correlate with churn?

**Key Metrics:**

* Average calls (churned vs retained)
* Churn rate by contract and tenure

**Insight:**
Churned customers consistently make more service calls, especially in Month-to-Month contracts, indicating dissatisfaction prior to churn.

---

## 4. Unlimited Data Plan & Usage Analysis

**Question:** How does data usage and plan type relate to churn?

**Key Metrics:**

* Unlimited vs limited plan churn counts
* Usage tiers (low / mid / high)
* Average monthly charges
* Total GB usage

**Insight:**
Low-usage customers with unlimited plans churn the most, suggesting overpayment or misaligned plans.

---

## 5. International Plan & Usage Analysis

**Question:** How does international usage affect churn?

**Key Metrics:**

* International plan adoption
* International call minutes and calls
* Extra international charges

**Insight:**
Customers without international plans but with moderate to high international usage show higher churn, likely due to unexpected extra charges.

---

## Overall Business Insights

* **Month-to-Month contracts are the highest churn risk across all dimensions**
* **Customer dissatisfaction (service calls) is a strong churn indicator**
* **Plan mismatch (low usage on unlimited plans) contributes to churn**
* **Unexpected extra charges increase churn likelihood**

---

## Skills Demonstrated

* Conditional aggregation using `FILTER`
* Customer segmentation with `CASE`
* Window functions (`RANK`, churn rate calculations)
* Revenue-based analysis
* Business-focused SQL storytelling

---

## Next Steps

* Visualize churn rate and revenue loss using Power BI or Tableau
* Add predictive features for churn modeling
* Publish results on LinkedIn / GitHub as a portfolio project

---

*This project represents my first complete SQL analysis and demonstrates growth from basic querying to insight-driven analysis.*
