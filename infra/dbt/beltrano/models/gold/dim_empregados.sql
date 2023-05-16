with
    stage as (
        select *
        from {{ref('stg_empregados')}}
    ),
    final as (
        select *
        from stage
    )
select * from final