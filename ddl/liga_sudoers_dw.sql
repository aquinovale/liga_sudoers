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