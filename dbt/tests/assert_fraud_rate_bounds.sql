select
    'mart_fraud_by_category' as model_name,
    cat_id as entity
from {{ ref('mart_fraud_by_category') }}
where fraud_rate < 0 or fraud_rate > 1

union all

select
    'mart_fraud_by_state' as model_name,
    us_state as entity
from {{ ref('mart_fraud_by_state') }}
where fraud_rate < 0 or fraud_rate > 1
