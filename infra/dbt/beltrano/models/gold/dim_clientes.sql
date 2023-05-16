with 
    clientes_pf as (
        select 
            hash_key
            , cliente_id
            , cidade_id
            , cpf as identificador
            , 'Pessoa Física' as cliente_tipo
            , nome || ' ' || sobrenome as cliente 
            , nome as contato
			, 'Não se aplica' as cargo_contato
            , sexo
            , celular
            , fax
            , telefone
            , endereco
            , cep
            ,updated_time 
        from {{ref('stg_clientes_pf')}} 
    ),
    clientes_pj as (
        select 
            hash_key
            , cliente_id
            , cidade_id
            , cnpj as identificador
            , 'Pessoa Jurídica' as cliente_tipo
            , cliente
            , contato
            , cargo_contato
            , 'Não se aplica' as sexo
            , 'Não se aplica' as celular
            , fax
            , telefone
            , endereco
            , cep
            , updated_time
        from {{ref('stg_clientes_pj')}} 
    ),
    all_clientes as (
        select * from clientes_pf
        union all
        select * from clientes_pj
    ),
    final as (
        select * 
        from all_clientes
    )
select * from final 