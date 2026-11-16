with merchant_metrics as (
    select
        merch,
        cat_id,
        count() as transaction_count,
        sum(fraud_flag) as fraud_transaction_count,
        round(avg(fraud_flag), 4) as fraud_rate,
        round(sum(amount), 2) as total_amount,
        round(avg(amount), 2) as average_amount,
        round(quantile(0.95)(amount), 2) as p95_amount
    from {{ ref('stg_transactions') }}
    group by merch, cat_id
)

select
    *,
    toUInt8(fraud_rate >= 0.05) as is_suspicious_merchant
from merchant_metrics
