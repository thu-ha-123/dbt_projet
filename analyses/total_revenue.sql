select 
    sum(
        case
        when payment_status = 'success' then payment_amount
        else null) as total_revenue
from {{ ref('stg_stripe__payments') }}
