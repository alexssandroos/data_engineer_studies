with
    source as (
        select
            _airbyte_cursos_hashid as hash_key
            ,curso_id
            , vagas
            , preco_vaga
            , curso_nome
            , duracao_aula
            , autor_id
            , duracao_total
            , _airbyte_normalized_at as updated_time
        from {{source('stage','cursos')}}
    )
select * from source