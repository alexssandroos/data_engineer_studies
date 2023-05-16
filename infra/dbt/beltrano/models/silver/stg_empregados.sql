with
    source as (
        select
            _airbyte_empregados_hashid as hash_key
            , empregado_id
            , cidade_id
            , nome
            , sobrenome
            , cpf
            , data_nasc
            , cargo
            , departamento
            , data_contratacao
            ,data_demissao
            , ramal
            , cep
            , endereco
            , tel_res
            , chefe
            , comentarios
            , _airbyte_normalized_at as updated_time
        from {{source('stage','empregados')}}
    )

select * from source