with 
    source as (
        select
        	_airbyte_unique_key as hash_key
            , cliente_id
            , nome
            , sobrenome
            , sexo
            , cidade_id
            , endereco
            , telefone
            , cpf
            , celular
            , fax
            , cep
            , _airbyte_normalized_at as updated_time
        from {{source('stage','beltrano_clientes_pf')}}
    )

select * from source