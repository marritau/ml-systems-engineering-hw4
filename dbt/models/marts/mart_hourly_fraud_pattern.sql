select
    day_of_week_name,
    transaction_hour,
    count() as transaction_count,
    sum(fraud_flag) as fraud_transaction_count,
    round(avg(fraud_flag), 4) as fraud_rate,
    round(avg(amount), 2) as average_amount
from {{ ref('stg_transactions') }}
group by day_of_week_name, transaction_hour
