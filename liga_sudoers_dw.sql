--CREATE DATABASE liga_sudoers_dw WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


--ALTER DATABASE liga_sudoers_dw OWNER TO sudoers;

--\connect liga_sudoers_dw

CREATE TABLE dim_produtos (
    sk_produto SERIAL PRIMARY KEY,
    id INTEGER NOT NULL,
    cat_desc character varying(255),
    descricao character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

CREATE TABLE dim_pessoas (
    sk_pessoa SERIAL PRIMARY KEY,
    id BIGINT NOT NULL,
    nome character varying(255),
    sexo character varying(1),
    dt_nasc DATE,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

CREATE TABLE stg_pessoas (    
    id BIGINT NOT NULL,
    nome character varying(255),
    sexo character varying(1),
    dt_nasc DATE,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

CREATE TABLE stg_produtos (
    id integer NOT NULL,
    cat_desc character varying(255) NOT NULL,
    descricao character varying(255) NOT NULL,    
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


CREATE TABLE stg_pedidos (    
    id_pedido integer NOT NULL,
    id_pessoa bigint NOT NULL,
    id_produto integer NOT NULL,
    dispositivo character varying(50) NOT NULL,
    geohash character varying(50) NOT NULL,
    telefone character varying(20) NOT NULL,
    dt_venda timestamp without time zone NOT NULL,
    qtde integer NOT NULL,
    valor_unit numeric(10,2) NOT NULL,
    valor_total numeric(10,2) NOT NULL
);



CREATE TABLE fato_pedidos (
    sk_id SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL,
    sk_pessoa BIGINT NOT NULL,
    sk_produto INTEGER NOT NULL,
    dispositivo character varying(50) NOT NULL,
    geohash character varying(50) NOT NULL,
    telefone character varying(20) NOT NULL,
    dt_venda timestamp without time zone NOT NULL,
    qtde INTEGER,
    valor_unit numeric(10,2),
    total numeric(10,2),
    CONSTRAINT fk_pessoa FOREIGN KEY (sk_pessoa) REFERENCES dim_pessoas (sk_pessoa),
    CONSTRAINT fk_produto FOREIGN KEY (sk_produto) REFERENCES dim_produtos (sk_produto)
);

/*

INSERT INTO stg_pessoas(id, nome, sexo, dt_nasc, created_at, updated_at) SELECT * FROM pessoas;

INSERT INTO dim_pessoas (id, nome, sexo, dt_nasc, created_at, updated_at)
SELECT id, nome, sexo, dt_nasc, created_at, updated_at
FROM stg_pessoas
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_pessoas
    WHERE dim_pessoas.id = stg_pessoas.id
      AND dim_pessoas.nome = stg_pessoas.nome
      AND dim_pessoas.sexo = stg_pessoas.sexo
      AND dim_pessoas.dt_nasc = stg_pessoas.dt_nasc
      AND dim_pessoas.created_at = stg_pessoas.created_at
      AND dim_pessoas.updated_at = stg_pessoas.updated_at
);


INSERT INTO stg_produtos(id, cat_desc, descricao, created_at, updated_at) SELECT p.id, c.descricao, p.descricao, p.created_at, p.updated_at FROM produtos p INNER JOIN categorias c ON c.id = p.id_categoria;

INSERT INTO dim_produtos(id, cat_desc, descricao, created_at, updated_at) SELECT * FROM stg_produtos;

INSERT INTO stg_pedidos (id_pedido, id_pessoa, id_produto, dispositio, geohash, telefone, dt_venda, qtde, valor_unit, valor_total) AS 
    SELECT p.id AS id_pedido, p.id_pessoa, i.id_produto, a.dispositivo, a.geohash, a.telefone, p.dt_venda, i.qtde, i.valor_total AS valor_unit, p.valor_total 
    FROM pedidos p 
        INNER JOIN itens_pedidos i 
        ON p.id = i.id_pedido 
        INNER JOIN auditoria_pedidos a 
        ON p.id = a.id_pedido; 

INSERT INTO fato_pedidos(id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, total) SELECT * FROM stg_pedidos s WHERE NOT EXISTS (SELECT 1 FROM fato_pedido f WHEREfs.id_pedido = s.id);
            
---------------------- LOCAL 
INSERT INTO fato_pedidos(id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, total) 
    SELECT s.id_pedido, sk_pessoa, sk_produto, dispositivo, geohash, telefone, dt_venda, qtde, valor_unit, valor_total 
        FROM stg_pedidos s 
            INNER JOIN dim_pessoas dp 
                ON dp.id = s.id_pessoa 
            INNER JOIN dim_produtos pr 
                ON pr.id = s.id_produto;
*/                