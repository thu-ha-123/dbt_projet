with payments as (
    select *
    from {{ ref('stg_stripe__payments') }}
),
aggregated as (
    select
        sum(
            case
            when payment_status = 'success' then payment_amount
            else null 
            end) as total_revenue 
    from payments
)

select * from aggregated