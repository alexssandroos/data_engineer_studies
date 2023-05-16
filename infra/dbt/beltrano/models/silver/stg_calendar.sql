with
    source as (
        select
           data_dsc
            , ano
            , mes_num
            , dia
            , dia_semana
            , trimestre_num
            , dia_no_ano
            , dia_semana_dsc
            , dia_semana_dsc_min
        from {{source('stage','dim_calendar')}}
    )
select * from source