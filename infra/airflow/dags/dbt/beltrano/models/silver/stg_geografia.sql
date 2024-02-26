with
    source as (
        select 
            cidades._airbyte_cidades_hashid as hash_key
            ,cidades.cidade_id
            ,cidades.estado_id
            ,cidades.cidade_nome
            ,estados.estado_nome
        from {{source('stage','cidades')}} as cidades      
        left join {{source('stage','estados')}} as estados using(estado_id)
    )
select * from source 
