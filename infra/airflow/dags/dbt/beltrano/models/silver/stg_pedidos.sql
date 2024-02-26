with
    source as (
        select 
            pedidos_detalhes._airbyte_pedidos_detalhes_hashid as hash_key
            ,pedidos.pedido_id
            ,pedidos.cliente_id
            ,pedidos.vendedor_id
            ,turmas.curso_id
            ,pedidos_detalhes.turma_id
            ,pedidos.data_pedido
            ,turmas.data_turma
            ,pedidos.pagamento_tipo
            ,pedidos_detalhes.total_item
            ,pedidos_detalhes.preco_unitario
            ,pedidos_detalhes.desconto
            ,pedidos_detalhes.quantidade
        from {{source('stage','pedidos_detalhes')}}
        left join {{source('stage','pedidos')}} using(pedido_id)
        left join {{source('stage','turmas')}} using(turma_id)
        --left join stage.dim_calendar cal on cal.data_dsc = pedidos.data_pedido
    )
select * from source