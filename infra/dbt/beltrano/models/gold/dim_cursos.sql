with
    stage as (
        select *
        from {{ref('stg_cursos')}}
    ),
    final as (
        select *
        from stage
    )
select * from final