WITH rfm_base AS (  
    SELECT 
        a.account_id, 
        a.plan_tier, 
        a.churn_flag, 
        COALESCE(SUM(f.usage_count), 0) AS frequency_value, 
        COALESCE(SUM(sub.mrr_amount), 0) AS monetary_value 
    FROM 
        `playground-500314.ravenstack.accounts` a 
    LEFT JOIN 
        `playground-500314.ravenstack.subscriptions` sub ON a.account_id = sub.account_id 
    LEFT JOIN 
        `playground-500314.ravenstack.feature_usage` f ON sub.subscription_id = f.subscription_id 
    WHERE 
        a.churn_flag = FALSE 
    GROUP BY 
        a.account_id, a.plan_tier, a.churn_flag 
), 
rfm_scores AS (  
    SELECT 
        account_id, 
        plan_tier, 
        frequency_value, 
        monetary_value, 
        NTILE(4) OVER (ORDER BY frequency_value ASC) AS f_score, 
        NTILE(4) OVER (ORDER BY monetary_value ASC) AS m_score 
    FROM 
        rfm_base 
) 
SELECT 
    account_id, 
    plan_tier, 
    frequency_value, 
    monetary_value, 
    f_score, 
    m_score, 
    CASE 
        WHEN f_score = 4 AND m_score = 4 THEN 'Champions (Sangat Aktif & Nilai Tinggi)' 
        WHEN f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers (Setia & Sering Pakai)' 
        WHEN f_score <= 2 AND m_score >= 3 THEN 'Can\'t Lose Them (Pendapatan Besar tapi Jarang Aktif - Rawan Churn!)' 
        WHEN f_score >= 3 AND m_score <= 2 THEN 'Low Spender / Highly Active (Sering Pakai tapi Paket Murah)' 
        ELSE 'Hibernating / At Risk (Jarang Pakai & Nilai Rendah)' 
    END AS customer_segment 
FROM 
    rfm_scores 
ORDER BY 
    monetary_value DESC, frequency_value DESC;