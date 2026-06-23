WITH user_error_stats AS (
    SELECT 
        sub.account_id,
        SUM(f.usage_count) AS total_usage,
        SUM(f.error_count) AS total_errors,
        CASE 
            WHEN SUM(f.usage_count) = 0 THEN 0 
            ELSE ROUND(SUM(f.error_count) * 100.0 / SUM(f.usage_count), 2) 
        END AS error_rate_percentage
    FROM 
        `playground-500314.ravenstack.feature_usage` f
   
    JOIN 
        `playground-500314.ravenstack.subscriptions` sub ON f.subscription_id = sub.subscription_id
    GROUP BY 
        sub.account_id
),
user_support_stats AS (
    SELECT 
        st.account_id,
        ROUND(AVG(st.resolution_time_hours), 1) AS avg_resolution_hours,
        ROUND(AVG(st.satisfaction_score), 1) AS avg_satisfaction
    FROM 
        `playground-500314.ravenstack.support_tickets` st
    GROUP BY 
        st.account_id
)
SELECT 
    a.plan_tier,
    a.churn_flag,
    COUNT(a.account_id) AS total_accounts,
    ROUND(AVG(e.error_rate_percentage), 2) AS avg_error_rate_pct,
    ROUND(AVG(s.avg_resolution_hours), 1) AS avg_resolution_time_hours,
    ROUND(AVG(s.avg_satisfaction), 1) AS avg_customer_satisfaction
FROM 
    `playground-500314.ravenstack.accounts` a
LEFT JOIN 
    user_error_stats e ON a.account_id = e.account_id
LEFT JOIN 
    user_support_stats s ON a.account_id = s.account_id
GROUP BY 
    a.plan_tier, 
    a.churn_flag
ORDER BY 
    a.plan_tier, 
    a.churn_flag;