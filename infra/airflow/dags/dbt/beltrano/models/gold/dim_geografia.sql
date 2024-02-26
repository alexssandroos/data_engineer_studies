with
    stage as (
        select *
        from {{ref('stg_geografia')}}
    ),
    final as (
        select *
        from stage
    )
select * from final