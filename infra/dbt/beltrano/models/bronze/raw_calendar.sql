{{  config( pre_hook="SET lc_time  = 'en_US.utf8'") }}

with 
    month_names as (
        select 
            aux_number
            ,month_name
            ,month_name_short
        from {{ref('seed_date_aux2')}}
    ),
    week_names as (
        select distinct
            aux_number
            ,week_name
            ,week_name_short
        from {{ref('seed_date_aux2')}}
    ),
    date_spine as (
        {{  dbt_utils.date_spine(    
                datepart="day",
                start_date="cast('2000-01-01' as date)",
                end_date="cast('2030-01-01' as date)"
            )
        }}
    ),
    dates as (
        select
            CAST(DATE_DAY AS DATE) AS DATE_KEY
        from date_spine
    ),
    final as (
        SELECT
            extract(epoch from date_key) as epoch 
            , date_key
            ,date_part('month', date_key) as month_number
            ,date_part('year', date_key) as year_number
            ,date_part('day', date_key) as day_number
            ,date_part('dow', date_key)+1  as dow 
            ,date_part('doy', date_key)+1  as doy 
            ,extract(week from date_key) as week_number
            ,month_names.month_name 
            ,month_names.month_name_short
            ,week_names.week_name
            ,week_names.week_name_short
        from dates
        left join month_names on date_part('month', date_key) = month_names.aux_number
        left join week_names on date_part('dow', date_key)+1 = week_names.aux_number
    )

select * from final