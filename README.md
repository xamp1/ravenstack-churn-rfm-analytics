# ravenstack-churn-rfm-analytics

This project analyzes customer churn in the fictional SaaS platform **RavenStack** and identifies customers who are at risk of leaving using **RFM (Recency, Frequency, Monetary)** segmentation.

The data was processed with **Google BigQuery**, and the results were presented in a responsive dashboard built with **Tailwind CSS**.

## Business Problem

RavenStack has an overall churn rate of **22%** across all subscription plans (Basic, Pro, and Enterprise). While the churn rate is consistent across tiers, Enterprise customers deserve special attention due to their higher business value.

## Key Findings

### Enterprise Customers

* Longest average support resolution time (**15.2 hours**).
* Lowest customer satisfaction score (**2.0/5.0**).
* Almost no recorded product errors, suggesting a possible case of **silent churn**, where customers stop using the product before meaningful usage data is generated.

### Basic Customers

* Highest product error rate (**15.31%**).
* Many users leave the platform without submitting support tickets, indicating technical frustration rather than service-related issues.

### RFM Segmentation

The current active customer base consists of **390 accounts**:

| Segment                     | Accounts |
| --------------------------- | -------: |
| Hibernating / At Risk       |      138 |
| Loyal Customers             |       96 |
| Can't Lose Them             |       58 |
| Low Spender / Highly Active |       58 |
| Champions                   |       40 |

The **Can't Lose Them** segment is the highest priority since these customers generate strong business value but show declining engagement.

## Tech Stack

* Google BigQuery
* SQL (CTEs, JOINs, NTILE)
* Tailwind CSS
* HTML & JavaScript

## Analysis Included

* Churn analysis by subscription plan
* Product error rate analysis
* Support SLA and customer satisfaction analysis
* RFM segmentation using `NTILE()`
* Customer behavior analysis by combining product usage and support activity

## Notes

One challenge in this dataset is that the `feature_usage` table does not contain an `account_id`. To analyze customer behavior, product usage data is linked through the `subscriptions` table using `subscription_id` before joining with the `accounts` table.

