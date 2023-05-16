with 
    source as (
        select
            _airbyte_unique_key as hash_key
            , cliente_id
            , cidade_id
            , cnpj
            , cliente
            , contato
            , cargo_contato
            , fax
            , telefone
            , endereco
            , cep
            , _airbyte_normalized_at as updated_time
        from {{source('stage','beltrano_clientes_pj')}}
    )

select * from source