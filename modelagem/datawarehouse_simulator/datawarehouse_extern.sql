-- Adiciona pessoas na dim_pessoas caso não existem em dim_pessoas, e adiciona a mesma pessoa - em um sk_pessoa novo - caso tenha existido alguma mudança nos campos
-- Em ambiente maiores, é importante que essa movimentação seja feita por período de data, normalmente diário. Daí o termo D-1.
INSERT INTO dim_pessoas (id, nome, sexo, dt_nasc, created_at, updated_at)
    SELECT id, nome, sexo, dt_nasc, created_at, updated_at
    FROM stg_pessoas s
    WHERE NOT EXISTS (
        SELECT 1
        FROM dim_pessoas d
        -- Preciso adaptar o id para id_pessoa
        WHERE s.id = d.id
        AND s.nome = d.nome
        AND s.sexo = d.sexo
        AND s.dt_nasc = d.dt_nasc
        AND s.created_at = d.created_at
        AND s.updated_at = d.updated_at
    );


-- Adiciona protudos na dim_produtos caso não existem em dim_produtos, e adiciona o mesmo protudo - em um sk_produto novo - caso tenha existido alguma mudança nos campos
INSERT INTO dim_produtos(id, cat_desc, descricao, created_at, updated_at) 
    SELECT id, cat_desc, descricao, created_at, updated_at 
    FROM stg_produtos p 
    WHERE NOT EXISTS (
        SELECT 1
        FROM dim_produtos dp
        WHERE p.id = dp.id
        AND p.cat_desc = dp.cat_desc
        AND p.descricao = dp.descricao
        AND p.created_at = dp.created_at
        AND p.updated_at = dp.updated_at
);


-- O processo da fato já é diferente, pois é necessário registrar todo o histórico dos pedidos, e gerenciar chaves de dimensões diferentes. Então é preciso encontrar essas chaves para que seja possível rastrear todas as mudanças no dado. 
-- Por ser uma staging, que armazenará dados temporiamente, faço dessa tabela uma ferramenta para transformar os dados em informação. 
TRUNCATE stg_pedidos;

-- Na fato, eu armazeno sua chave sk_, dando uma amplitude na dimensão e facilidando uma leitura sobre as mudanças.
INSERT INTO fato_pedidos(id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, total) 
    SELECT s.id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, valor_total 
        FROM stg_pedidos s 
            INNER JOIN dim_pessoas dp 
                ON dp.id = s.id_pessoa 
            INNER JOIN dim_produtos pr 
                ON pr.id = s.id_produto
WHERE NOT EXISTS (
    SELECT 1
    FROM fato_pedidos fp
    WHERE fp.id_pedido = s.id_pedido
      AND fp.sk_pessoa = dp.sk_pessoa
      AND fp.sk_produto = pr.sk_produto
      AND fp.dt_venda = s.dt_venda
      AND fp.total = s.valor_total
);    

                
-- Para facilitar alguns criam VIEWS, evitando assim reconstruir essa estrura de visão dimensional. 
SELECT *
FROM pedidos p
        INNER JOIN pessoas pes ON pes.id = p.id_pessoa                
        INNER JOIN auditoria_pedidos a ON a.id_pedido = p.id
        INNER JOIN itens_pedidos ip 
            INNER JOIN produtos pr 
                INNER JOIN categorias c ON c.id = pr.id_categoria
            ON pr.id = ip.id_produto
        ON ip.id_pedido = p.id;            

