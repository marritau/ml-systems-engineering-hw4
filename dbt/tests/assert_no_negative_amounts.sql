select
    transaction_time,
    amount
from {{ ref('stg_transactions') }}
where amount <= 0
