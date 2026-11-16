with source_transactions as (
    select *
    from {{ source('transactions_source', 'transactions') }}
)

select
    toDateTime(transaction_time) as transaction_time,
    toDate(transaction_time) as transaction_date,
    {{ dbt_date.day_name('toDate(transaction_time)', short=false) }} as day_of_week_name,
    toHour(transaction_time) as transaction_hour,
    merch,
    cat_id,
    toFloat64(amount) as amount,
    {{ amount_bucket('amount') }} as amount_bucket,
    name_1,
    name_2,
    concat(name_1, ' ', name_2, ' | ', street, ' | ', post_code) as customer_id,
    gender,
    street,
    one_city,
    us_state,
    post_code,
    lat,
    lon,
    population_city,
    jobs,
    merchant_lat,
    merchant_lon,
    toUInt8(target) as fraud_flag
from source_transactions
where amount > 0
