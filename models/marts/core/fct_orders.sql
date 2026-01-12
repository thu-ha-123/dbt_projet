
{{
    config(
        materialized='incremental',
        on_schema_change='append_new_columns',
        unique_key = 'order_id',
        incremental_strategy = 'merge',
    )
}}

with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
), 
customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),
payments as (
    select * from {{ ref('stg_stripe__payments') }}
),
order_payments as (
    select 
        order_id,
        sum(case when payment_status = 'success' then payment_amount end) as amount
    from payments
    group by 1
), 
final as (
    select
        orders.order_id,
        orders.customer_id,
        -- adusting fct_orders
        orders.order_placed_at,
        coalesce(order_payments.amount, 0) as amount
    from orders 
    left join order_payments using (order_id)
)
select * from final 

{% if is_incremental() %}
where
order_placed_at >= (select max(order_placed_at) from {{this}})
{% endif %}

