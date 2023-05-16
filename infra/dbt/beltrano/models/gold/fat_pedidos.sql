with
    dim_clientes as (
        select *
        from {{ref('dim_clientes')}}
    ),
    dim_calendar as (
        select *
        from {{ref('dim_calendar')}}
    ),
    dim_cursos as (
        select *
        from {{ref('dim_cursos')}}
    ),
    dim_empregados as (
        select *
        from {{ref('dim_empregados')}}
    ),
    dim_geografia as (
        select *
        from {{ref('dim_geografia')}}
    ),
    stg_pedidos as (
        select *
        from {{ref('stg_pedidos')}}
    ),
    final as (
        select 
            stg_pedidos.pedido_id
            ,dim_clientes.hash_key as cliente_fk
            ,dim_empregados.hash_key as empregado_fk
            ,dim_cursos.hash_key as curso_fk 
            ,calendario_faturamento.calendar_sk as calendario_fat_fk 
            ,calendario_turma.calendar_sk as calendario_trm_fk 
            ,stg_pedidos.turma_id
            ,stg_pedidos.pagamento_tipo
            ,stg_pedidos.total_item
            ,stg_pedidos.preco_unitario
            ,stg_pedidos.desconto
            ,stg_pedidos.quantidade
        from stg_pedidos 
        left join dim_clientes on stg_pedidos.cliente_id = dim_clientes.cliente_id
        left join dim_cursos on stg_pedidos.curso_id = dim_cursos.curso_id
        left join dim_empregados on stg_pedidos.vendedor_id = dim_empregados.empregado_id
        left join dim_calendar as calendario_faturamento on stg_pedidos.data_pedido = calendario_faturamento.data_dsc
        left join dim_calendar as calendario_turma on stg_pedidos.data_pedido = calendario_turma.data_dsc
    )

select * from final
