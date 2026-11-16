select
    cat_id,
    count() as transaction_count,
    sum(fraud_flag) as fraud_transaction_count,
    round(avg(fraud_flag), 4) as fraud_rate,
    round(sum(amount), 2) as total_amount,
    round(avg(amount), 2) as average_amount
from {{ ref('stg_transactions') }}
group by cat_id
