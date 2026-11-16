select
    transaction_date,
    us_state,
    count() as transaction_count,
    round(sum(amount), 2) as total_amount,
    round(avg(amount), 2) as average_amount,
    round(quantile(0.95)(amount), 2) as p95_amount,
    round(avg(amount_bucket in ('high', 'very_high')), 4) as large_transaction_share
from {{ ref('stg_transactions') }}
{{ dbt_utils.group_by(2) }}
