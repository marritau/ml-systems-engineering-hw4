with customer_metrics as (
    select
        customer_id,
        count() as transaction_count,
        sum(fraud_flag) as fraud_transaction_count,
        round(avg(fraud_flag), 4) as fraud_rate,
        round(sum(amount), 2) as total_amount,
        max(transaction_time) as last_transaction_time
    from {{ ref('stg_transactions') }}
    group by customer_id
)

select
    *,
    multiIf(
        fraud_transaction_count > 0, 'high',
        transaction_count >= 10, 'medium',
        'low'
    ) as risk_segment
from customer_metrics
