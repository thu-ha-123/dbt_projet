with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),
final as (
    select 
        customer_id, 
        order_placed_at,
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'order_placed_at']) }} as primary_key,
        count(*) as c
    from orders
    group by 1,2,3
)
select * from final 