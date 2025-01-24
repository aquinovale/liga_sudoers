-- Consulta operacional
SELECT * FROM pessoas WHERE id = 1;

SELECT p.nome, MAX(pe.dt_venda)
FROM pessoas p INNER JOIN pedidos pe ON pe.id_pessoa = p.id
WHERE dt_venda >= now() - interval '2 days'
GROUP BY 1 LIMIT 10;

-- Consulta analitica simples
-- Total por cliente nos últimos 7 dias
SELECT pes.nome, sum(p.valor_total)
FROM pedidos p
        INNER JOIN pessoas pes ON pes.id = p.id_pessoa                
WHERE dt_venda >= now() - interval '7 days'        
GROUP BY 1 ORDER BY 2 DESC LIMIT 10;



-- Query Analitica buscando as informações em uma modelagem transacional
-- Valor total e média por mês, categoria e geohash
-- Para facilitar alguns criam VIEWS, evitando assim reconstruir essa estrura de visão dimensional. 
SELECT geohash, cat_desc, EXTRACT(MONTH FROM dt_venda) as mes, avg(COALESCE(valor_unit, 0 )) as media, sum(COALESCE(valor_unit, 0 )) as total
FROM ( -- VIEW
    SELECT c.descricao as cat_desc, *
    FROM pedidos p            
            INNER JOIN auditoria_pedidos a ON a.id_pedido = p.id
            INNER JOIN itens_pedidos ip 
                INNER JOIN produtos pr 
                    INNER JOIN categorias c ON c.id = pr.id_categoria
                ON pr.id = ip.id_produto
            ON ip.id_pedido = p.id                        
) fato_pedidos
GROUP BY 1, 2, 3, mes
ORDER BY 1, 3, 2, mes;














-- Adiciona pessoas na dim_pessoas caso não existem em dim_pessoas, e adiciona a mesma pessoa - em um sk_pessoa novo - caso tenha existido alguma mudança nos campos
-- Em ambiente maiores, é importante que essa movimentação seja feita por período de data, normalmente diário. Daí o termo D-1.
INSERT INTO dw.dim_pessoas (id, nome, sexo, dt_nasc, created_at, updated_at)
    SELECT id, nome, sexo, dt_nasc, created_at, updated_at
    FROM pessoas
    WHERE NOT EXISTS (
        SELECT 1
        FROM dw.dim_pessoas
        WHERE pessoas.id = dw.dim_pessoas.id
        AND pessoas.nome = dw.dim_pessoas.nome
        AND pessoas.sexo = dw.dim_pessoas.sexo
        AND pessoas.dt_nasc = dw.dim_pessoas.dt_nasc
        AND pessoas.created_at = dw.dim_pessoas.created_at
        AND pessoas.updated_at = dw.dim_pessoas.updated_at
    );


-- Adiciona protudos na dim_produtos caso não existem em dim_produtos, e adiciona o mesmo protudo - em um sk_produto novo - caso tenha existido alguma mudança nos campos
INSERT INTO dw.dim_produtos(id, cat_desc, descricao, created_at, updated_at) 
    SELECT p.id, c.descricao, p.descricao, p.created_at, p.updated_at 
    FROM produtos p 
        INNER JOIN categorias c ON c.id = p.id_categoria
    WHERE NOT EXISTS (
        SELECT 1
        FROM dw.dim_produtos
        WHERE p.id = dw.dim_produtos.id
        AND c.descricao = dw.dim_produtos.cat_desc
        AND p.descricao = dw.dim_produtos.descricao
        AND p.created_at = dw.dim_produtos.created_at
        AND p.updated_at = dw.dim_produtos.updated_at
);


-- O processo da fato já é diferente, pois é necessário registrar todo o histórico dos pedidos, e gerenciar chaves de dimensões diferentes. Então é preciso encontrar essas chaves para que seja possível rastrear todas as mudanças no dado. 
-- Por ser uma staging, que armazenará dados temporiamente, faço dessa tabela uma ferramenta para transformar os dados em informação. 
TRUNCATE dw.stg_pedidos;

-- Meu foco é armazenar os id das tabelas de apoio, registrando seu id operacional, assim eu individualizo a informação.
INSERT INTO dw.stg_pedidos (id_pedido, id_pessoa, id_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, valor_total)  
    SELECT p.id AS id_pedido, p.id_pessoa, i.id_produto, a.dispositivo, a.geohash, a.telefone, p.dt_venda, i.qtde, i.valor_total AS valor_unit, p.valor_total 
    FROM pedidos p 
        INNER JOIN itens_pedidos i 
        ON p.id = i.id_pedido 
        INNER JOIN auditoria_pedidos a 
        ON p.id = a.id_pedido; 

-- Na fato, eu armazeno sua chave sk_, dando uma amplitude na dimensão e facilidando uma leitura sobre as mudanças.
INSERT INTO dw.fato_pedidos(id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, total) 
    SELECT s.id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, valor_total 
        FROM dw.stg_pedidos s 
            INNER JOIN dw.dim_pessoas dp 
                ON dp.id = s.id_pessoa 
            INNER JOIN dw.dim_produtos pr 
                ON pr.id = s.id_produto
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.fato_pedidos
    WHERE dw.fato_pedidos.id_pedido = s.id_pedido
      AND dw.fato_pedidos.sk_pessoa = dp.sk_pessoa
      AND dw.fato_pedidos.sk_produto = pr.sk_produto
      AND dw.fato_pedidos.dt_venda = s.dt_venda
      AND dw.fato_pedidos.total = s.valor_total
);    

                
-- Query Analitica buscando as informações em uma modelagem dimensional
SELECT geohash, cat_desc, EXTRACT(MONTH FROM dt_venda) as mes, avg(COALESCE(valor_unit, 0 )) as media, sum(COALESCE(valor_unit, 0 )) as total
FROM dw.fato_pedidos fp
    INNER JOIN dw.dim_produtos dpr ON dpr.sk_produto = fp.sk_produto
GROUP BY 1, 2, 3, mes
ORDER BY 1, 3, 2, mes;


 

-- Fará a inserção de uma nova pessoa
INSERT INTO dw.dim_pessoas (id, nome, sexo, dt_nasc, created_at, updated_at)
SELECT id, nome, sexo, dt_nasc, created_at, updated_at
FROM (
    SELECT 1 as id, 'Liga Sudoers' as nome, 'M' as sexo, cast('1985-10-01' as date) as dt_nasc, CAST('2025-01-01' as date) created_at, CAST('2025-01-10' as date) updated_at
) pessoas
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_pessoas
    WHERE pessoas.id = dw.dim_pessoas.id
      AND pessoas.nome = dw.dim_pessoas.nome
      AND pessoas.sexo = dw.dim_pessoas.sexo
      AND pessoas.dt_nasc = dw.dim_pessoas.dt_nasc
      AND pessoas.created_at = dw.dim_pessoas.created_at
      AND pessoas.updated_at = dw.dim_pessoas.updated_at
);

-- Mesma query acima, porém dessa vez não dará a inserção de uma nova pessoa
INSERT INTO dw.dim_pessoas (id, nome, sexo, dt_nasc, created_at, updated_at)
SELECT id, nome, sexo, dt_nasc, created_at, updated_at
FROM (
    SELECT 1 as id, 'Liga Sudoers' as nome, 'M' as sexo, cast('1985-10-01' as date) as dt_nasc, CAST('2025-01-01' as date) created_at, CAST('2025-01-10' as date) updated_at
) pessoas
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_pessoas
    WHERE pessoas.id = dw.dim_pessoas.id
      AND pessoas.nome = dw.dim_pessoas.nome
      AND pessoas.sexo = dw.dim_pessoas.sexo
      AND pessoas.dt_nasc = dw.dim_pessoas.dt_nasc
      AND pessoas.created_at = dw.dim_pessoas.created_at
      AND pessoas.updated_at = dw.dim_pessoas.updated_at
);

-- Alteração no cadastro da pessoa
INSERT INTO dw.dim_pessoas (id, nome, sexo, dt_nasc, created_at, updated_at)
SELECT id, nome, sexo, dt_nasc, created_at, updated_at
FROM (
    SELECT 1 as id, 'Vinicius Vale - Sudoers' as nome, 'M' as sexo, cast('1985-10-01' as date) as dt_nasc, CAST('2025-01-01' as date) created_at, CAST('2025-01-18' as date) updated_at
) pessoas
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_pessoas
    WHERE pessoas.id = dw.dim_pessoas.id
      AND pessoas.nome = dw.dim_pessoas.nome
      AND pessoas.sexo = dw.dim_pessoas.sexo
      AND pessoas.dt_nasc = dw.dim_pessoas.dt_nasc
      AND pessoas.created_at = dw.dim_pessoas.created_at
      AND pessoas.updated_at = dw.dim_pessoas.updated_at
);

-- Visualiza o histórico de mudanças na dimensão
SELECT * FROM dw.dim_pessoas WHERE id = 1;


-- Insere dados para analise histórica da dim_pessoa
INSERT INTO dw.fato_pedidos(id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, total) 
SELECT * FROM (SELECT 1, 21, 6, 'dispositivo', 'geohash', 'telefone', CAST('2025-01-10' as date), 1, 2, 4 UNION ALL  SELECT 1, 21, 16, 'dispositivo', 'geohash', 'telefone', CAST('2025-01-10' as date), 1, 2, 4) x;

INSERT INTO dw.fato_pedidos(id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, total) 
SELECT * FROM (SELECT 1, 22, 19, 'dispositivo', 'geohash', 'telefone', CAST('2025-01-10' as date), 1, 3, 6 UNION ALL  SELECT 1, 22, 28, 'dispositivo', 'geohash', 'telefone', CAST('2025-01-18' as date), 1, 3, 6) x;


SELECT dp.id, dp.nome, avg(valor_unit), sum(valor_unit)
    FROM dw.fato_pedidos fp INNER JOIN dw.dim_pessoas dp ON dp.sk_pessoa = fp.sk_pessoa
GROUP BY 1, 2;

SELECT dp.id, max(dp.nome), min(dp.nome), avg(valor_unit), sum(valor_unit)
    FROM dw.fato_pedidos fp INNER JOIN dw.dim_pessoas dp ON dp.sk_pessoa = fp.sk_pessoa
GROUP BY 1;


-- Query Analitica buscando as informações em uma modelagem transacional
SELECT geohash, cat_desc, EXTRACT(MONTH FROM dt_venda) as mes, avg(COALESCE(valor_unit, 0 )) as media, sum(COALESCE(valor_unit, 0 )) as total
FROM (
    SELECT c.descricao as cat_desc, *
    FROM pedidos p            
            INNER JOIN auditoria_pedidos a ON a.id_pedido = p.id
            INNER JOIN itens_pedidos ip 
                INNER JOIN produtos pr 
                    INNER JOIN categorias c ON c.id = pr.id_categoria
                ON pr.id = ip.id_produto
            ON ip.id_pedido = p.id                        
) fato_pedidos
GROUP BY 1, 2, 3, mes
ORDER BY 1, 3, 2, mes LIMIT 5;


-- Query Analitica buscando as informações em uma modelagem dimensional
SELECT geohash, cat_desc, EXTRACT(MONTH FROM dt_venda) as mes, avg(COALESCE(valor_unit, 0 )) as media, sum(COALESCE(valor_unit, 0 )) as total
FROM dw.fato_pedidos fp
    INNER JOIN dw.dim_produtos dpr ON dpr.sk_produto = fp.sk_produto
GROUP BY 1, 2, 3, mes
ORDER BY 1, 3, 2, mes LIMIT 5;