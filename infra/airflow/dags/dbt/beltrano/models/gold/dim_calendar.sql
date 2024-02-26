with
    stage as (
        select *
        from {{ref('stg_calendar')}}
    ),
    final as (
        select 
            row_number() over (order by data_dsc) as calendar_sk
            , data_dsc
            , ano
            , mes_num
            , dia
            , dia_semana
            , trimestre_num
            , dia_no_ano
            , dia_semana_dsc
            , dia_semana_dsc_min
        from stage
    )
select * from final