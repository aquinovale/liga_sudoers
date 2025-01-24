--CREATE DATABASE liga_sudoers WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


--ALTER DATABASE liga_sudoers OWNER TO sudoers;

--\connect liga_sudoers
--
-- Name: auditoria_pedidos; Type: TABLE; Schema: public; Owner: sudoers
--

CREATE TABLE public.auditoria_pedidos (
    id_pedido integer NOT NULL,
    dispositivo character varying(50) NOT NULL,
    geohash character varying(50) NOT NULL,
    telefone character varying(20) NOT NULL
);


ALTER TABLE public.auditoria_pedidos OWNER TO sudoers;

--
-- Name: categorias; Type: TABLE; Schema: public; Owner: sudoers
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.categorias OWNER TO sudoers;

--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: sudoers
--

CREATE SEQUENCE public.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categorias_id_seq OWNER TO sudoers;

--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sudoers
--

ALTER SEQUENCE public.categorias_id_seq OWNED BY public.categorias.id;


--
-- Name: itens_pedidos; Type: TABLE; Schema: public; Owner: sudoers
--

CREATE TABLE public.itens_pedidos (
    id_pedido integer NOT NULL,
    id_produto integer NOT NULL,
    qtde integer NOT NULL,
    valor_total numeric(10,2) NOT NULL
);


ALTER TABLE public.itens_pedidos OWNER TO sudoers;

--
-- Name: pedidos; Type: TABLE; Schema: public; Owner: sudoers
--

CREATE TABLE public.pedidos (
    id integer NOT NULL,
    id_pessoa bigint NOT NULL,
    dt_venda timestamp without time zone NOT NULL,
    valor_total numeric(10,2) NOT NULL
);


ALTER TABLE public.pedidos OWNER TO sudoers;

--
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: sudoers
--

CREATE SEQUENCE public.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedidos_id_seq OWNER TO sudoers;

--
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sudoers
--

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;


--
-- Name: pessoas; Type: TABLE; Schema: public; Owner: sudoers
--

CREATE TABLE public.pessoas (
    id bigint NOT NULL,
    nome character varying(255) NOT NULL,
    sexo character varying(1) DEFAULT 'M'::character varying NOT NULL,
    dt_nasc date NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.pessoas OWNER TO sudoers;

--
-- Name: produtos; Type: TABLE; Schema: public; Owner: sudoers
--

CREATE TABLE public.produtos (
    id integer NOT NULL,
    id_categoria integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor_unit numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.produtos OWNER TO sudoers;

--
-- Name: produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: sudoers
--

CREATE SEQUENCE public.produtos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produtos_id_seq OWNER TO sudoers;

--
-- Name: produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sudoers
--

ALTER SEQUENCE public.produtos_id_seq OWNED BY public.produtos.id;


--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- Name: pedidos id; Type: DEFAULT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);


--
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produtos_id_seq'::regclass);


--
-- Data for Name: auditoria_pedidos; Type: TABLE DATA; Schema: public; Owner: sudoers
--



--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: sudoers
--

INSERT INTO public.categorias VALUES (1, 'Moda Masculina');
INSERT INTO public.categorias VALUES (2, 'Moda Feminina');
INSERT INTO public.categorias VALUES (3, 'Moda Infantil');
INSERT INTO public.categorias VALUES (4, 'Tecnologia');
INSERT INTO public.categorias VALUES (5, 'Veículos');
INSERT INTO public.categorias VALUES (6, 'Construção');
INSERT INTO public.categorias VALUES (7, 'Brinquedos');
INSERT INTO public.categorias VALUES (8, 'Supermecado');
INSERT INTO public.categorias VALUES (9, 'Pet');


--
-- Data for Name: itens_pedidos; Type: TABLE DATA; Schema: public; Owner: sudoers
--



--
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: sudoers
--



--
-- Data for Name: pessoas; Type: TABLE DATA; Schema: public; Owner: sudoers
--

INSERT INTO public.pessoas VALUES (12345678901, 'Carlos Silva', 'M', '1985-05-15', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (23456789012, 'Maria Oliveira', 'F', '1990-03-22', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (34567890123, 'José Santos', 'M', '1978-12-10', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (45678901234, 'Ana Souza', 'F', '1980-07-30', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (56789012345, 'Pedro Lima', 'M', '1992-09-15', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (67890123456, 'Juliana Martins', 'F', '1983-06-25', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (78901234567, 'Ricardo Alves', 'M', '1970-11-05', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (89012345678, 'Fernanda Costa', 'F', '1995-04-12', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (90123456789, 'Paulo Pereira', 'M', '1987-02-19', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (1234567890, 'Camila Rocha', 'F', '1991-01-28', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (11234567891, 'Lucas Araújo', 'M', '1983-08-17', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (21234567892, 'Patrícia Lima', 'F', '1979-10-23', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (31234567893, 'Roberto Nunes', 'M', '1980-05-03', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (41234567894, 'Vanessa Ribeiro', 'F', '1994-07-07', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (51234567895, 'Daniel Teixeira', 'M', '1975-03-12', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (61234567896, 'Larissa Mendes', 'F', '1997-06-30', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (71234567897, 'André Carvalho', 'M', '1993-11-20', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (81234567898, 'Carolina Freitas', 'F', '1986-02-14', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (91234567899, 'Eduardo Gomes', 'M', '1982-09-25', '2025-01-12 20:04:17.585687');
INSERT INTO public.pessoas VALUES (10123456780, 'Aline Barros', 'F', '1998-04-05', '2025-01-12 20:04:17.585687');


--
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: sudoers
--

INSERT INTO public.produtos VALUES (1, 1, 'Camiseta Polo Masculina', 289.58);
INSERT INTO public.produtos VALUES (2, 1, 'Calça Jeans Masculina', 929.20);
INSERT INTO public.produtos VALUES (3, 1, 'Blazer Casual Masculino', 755.58);
INSERT INTO public.produtos VALUES (4, 1, 'Sapato Social', 842.49);
INSERT INTO public.produtos VALUES (5, 1, 'Relógio Esportivo Masculino', 276.24);
INSERT INTO public.produtos VALUES (6, 1, 'Bermuda Cargo Masculina', 837.37);
INSERT INTO public.produtos VALUES (7, 1, 'Jaqueta de Couro', 586.80);
INSERT INTO public.produtos VALUES (8, 1, 'Boné Preto', 572.24);
INSERT INTO public.produtos VALUES (9, 1, 'Cinto de Couro', 399.49);
INSERT INTO public.produtos VALUES (10, 1, 'Luvas de Inverno', 296.75);
INSERT INTO public.produtos VALUES (11, 1, 'Camisa Social Branca', 561.56);
INSERT INTO public.produtos VALUES (12, 1, 'Terno Completo', 756.91);
INSERT INTO public.produtos VALUES (13, 1, 'Cueca Boxer', 705.39);
INSERT INTO public.produtos VALUES (14, 1, 'Meia Esportiva', 506.95);
INSERT INTO public.produtos VALUES (15, 1, 'Óculos de Sol', 178.22);
INSERT INTO public.produtos VALUES (16, 1, 'Mochila Masculina', 933.90);
INSERT INTO public.produtos VALUES (17, 1, 'Carteira de Couro', 482.11);
INSERT INTO public.produtos VALUES (18, 1, 'Gravata Slim', 898.29);
INSERT INTO public.produtos VALUES (19, 1, 'Pulseira de Aço', 603.80);
INSERT INTO public.produtos VALUES (20, 1, 'Chapéu Fedora', 406.04);
INSERT INTO public.produtos VALUES (21, 2, 'Vestido Floral', 222.22);
INSERT INTO public.produtos VALUES (22, 2, 'Blusa de Seda', 529.60);
INSERT INTO public.produtos VALUES (23, 2, 'Saia Plissada', 325.79);
INSERT INTO public.produtos VALUES (24, 2, 'Sandália Salto Alto', 702.24);
INSERT INTO public.produtos VALUES (25, 2, 'Jaqueta Jeans', 743.35);
INSERT INTO public.produtos VALUES (26, 2, 'Óculos de Sol Feminino', 295.89);
INSERT INTO public.produtos VALUES (27, 2, 'Bolsa de Couro', 782.66);
INSERT INTO public.produtos VALUES (28, 2, 'Calça Skinny', 365.95);
INSERT INTO public.produtos VALUES (29, 2, 'Relógio Dourado', 638.26);
INSERT INTO public.produtos VALUES (30, 2, 'Anel de Prata', 872.28);
INSERT INTO public.produtos VALUES (31, 2, 'Colar de Pérolas', 767.87);
INSERT INTO public.produtos VALUES (32, 2, 'Pulseira Feminina', 821.48);
INSERT INTO public.produtos VALUES (33, 2, 'Lenço Estampado', 204.56);
INSERT INTO public.produtos VALUES (34, 2, 'Biquíni Colorido', 507.80);
INSERT INTO public.produtos VALUES (35, 2, 'Camisa Social Feminina', 790.22);
INSERT INTO public.produtos VALUES (36, 2, 'Shorts Jeans Feminino', 193.37);
INSERT INTO public.produtos VALUES (37, 2, 'Blazer Feminino', 786.38);
INSERT INTO public.produtos VALUES (38, 2, 'Cinto Feminino', 826.37);
INSERT INTO public.produtos VALUES (39, 2, 'Macacão de Linho', 214.78);
INSERT INTO public.produtos VALUES (40, 2, 'Chapéu de Praia', 488.14);
INSERT INTO public.produtos VALUES (41, 3, 'Conjunto Infantil', 195.75);
INSERT INTO public.produtos VALUES (42, 3, 'Camisa Polo Infantil', 788.26);
INSERT INTO public.produtos VALUES (43, 3, 'Vestido de Festa Infantil', 394.50);
INSERT INTO public.produtos VALUES (44, 3, 'Tênis Infantil', 498.53);
INSERT INTO public.produtos VALUES (45, 3, 'Boneca de Pano', 810.10);
INSERT INTO public.produtos VALUES (46, 3, 'Carrinho de Controle Remoto', 217.26);
INSERT INTO public.produtos VALUES (47, 3, 'Livro de Colorir', 577.84);
INSERT INTO public.produtos VALUES (48, 3, 'Blusa de Moletom Infantil', 287.81);
INSERT INTO public.produtos VALUES (49, 3, 'Calça de Moletom Infantil', 718.36);
INSERT INTO public.produtos VALUES (50, 3, 'Lancheira Escolar', 143.01);
INSERT INTO public.produtos VALUES (51, 3, 'Mochila Infantil', 961.83);
INSERT INTO public.produtos VALUES (52, 3, 'Fantasia de Super-Herói', 730.63);
INSERT INTO public.produtos VALUES (53, 3, 'Jogo de Tabuleiro Infantil', 504.27);
INSERT INTO public.produtos VALUES (54, 3, 'Kit de Massinha de Modelar', 238.69);
INSERT INTO public.produtos VALUES (55, 3, 'Bicicleta Infantil', 875.65);
INSERT INTO public.produtos VALUES (56, 3, 'Patins Infantil', 971.87);
INSERT INTO public.produtos VALUES (57, 3, 'Quebra-Cabeça Infantil', 370.02);
INSERT INTO public.produtos VALUES (58, 3, 'Camiseta Estampada Infantil', 228.52);
INSERT INTO public.produtos VALUES (59, 3, 'Boné Infantil', 675.14);
INSERT INTO public.produtos VALUES (60, 3, 'Bermuda Infantil', 856.65);
INSERT INTO public.produtos VALUES (61, 4, 'Smartphone XYZ', 160.22);
INSERT INTO public.produtos VALUES (62, 4, 'Notebook ABC', 482.66);
INSERT INTO public.produtos VALUES (63, 4, 'Fone de Ouvido Bluetooth', 303.75);
INSERT INTO public.produtos VALUES (64, 4, 'Monitor Gamer', 843.54);
INSERT INTO public.produtos VALUES (65, 4, 'Teclado Mecânico', 708.43);
INSERT INTO public.produtos VALUES (66, 4, 'Mouse Gamer', 925.73);
INSERT INTO public.produtos VALUES (67, 4, 'Câmera Digital', 607.42);
INSERT INTO public.produtos VALUES (68, 4, 'Impressora Multifuncional', 845.39);
INSERT INTO public.produtos VALUES (69, 4, 'Tablet Android', 992.97);
INSERT INTO public.produtos VALUES (70, 4, 'Caixa de Som Bluetooth', 235.95);
INSERT INTO public.produtos VALUES (71, 4, 'Power Bank', 557.20);
INSERT INTO public.produtos VALUES (72, 4, 'Smartwatch', 323.63);
INSERT INTO public.produtos VALUES (73, 4, 'Placa de Vídeo', 520.33);
INSERT INTO public.produtos VALUES (74, 4, 'HD Externo', 662.56);
INSERT INTO public.produtos VALUES (75, 4, 'Cabo HDMI', 539.63);
INSERT INTO public.produtos VALUES (76, 4, 'Roteador Wi-Fi', 464.82);
INSERT INTO public.produtos VALUES (77, 4, 'Microfone USB', 105.27);
INSERT INTO public.produtos VALUES (78, 4, 'Webcam Full HD', 805.50);
INSERT INTO public.produtos VALUES (79, 4, 'Controle para PC', 976.95);
INSERT INTO public.produtos VALUES (80, 4, 'Estabilizador de Energia', 783.75);
INSERT INTO public.produtos VALUES (81, 5, 'Capacete Moto', 252.67);
INSERT INTO public.produtos VALUES (82, 5, 'Cadeirinha para Bebê', 183.07);
INSERT INTO public.produtos VALUES (83, 5, 'Jogo de Chave de Roda', 769.92);
INSERT INTO public.produtos VALUES (84, 5, 'Filtro de Óleo', 963.55);
INSERT INTO public.produtos VALUES (85, 5, 'Pneu de Carro', 973.86);
INSERT INTO public.produtos VALUES (86, 5, 'Kit Emergência Veicular', 316.68);
INSERT INTO public.produtos VALUES (87, 5, 'Limpador de Parabrisa', 250.16);
INSERT INTO public.produtos VALUES (88, 5, 'Bateria de Carro', 966.64);
INSERT INTO public.produtos VALUES (89, 5, 'Retrovisor Externo', 358.04);
INSERT INTO public.produtos VALUES (90, 5, 'Calota de Roda', 625.90);
INSERT INTO public.produtos VALUES (91, 5, 'Luz de Freio', 547.44);
INSERT INTO public.produtos VALUES (92, 5, 'Óleo de Motor', 634.48);
INSERT INTO public.produtos VALUES (93, 5, 'Chave de Roda', 327.35);
INSERT INTO public.produtos VALUES (94, 5, 'Lanterna de LED', 100.78);
INSERT INTO public.produtos VALUES (95, 5, 'Compressor de Ar Portátil', 332.52);
INSERT INTO public.produtos VALUES (96, 5, 'Extintor de Incêndio', 562.04);
INSERT INTO public.produtos VALUES (97, 5, 'Tapete de Borracha', 903.95);
INSERT INTO public.produtos VALUES (98, 5, 'Capa de Banco', 679.82);
INSERT INTO public.produtos VALUES (99, 5, 'Kit de Ferramentas', 477.83);
INSERT INTO public.produtos VALUES (100, 5, 'Adesivo Decorativo', 352.65);
INSERT INTO public.produtos VALUES (101, 6, 'Furadeira Elétrica', 921.35);
INSERT INTO public.produtos VALUES (102, 6, 'Martelo de Borracha', 751.05);
INSERT INTO public.produtos VALUES (103, 6, 'Chave de Fenda', 576.13);
INSERT INTO public.produtos VALUES (104, 6, 'Serra Circular', 569.80);
INSERT INTO public.produtos VALUES (105, 6, 'Alicate Universal', 796.45);
INSERT INTO public.produtos VALUES (106, 6, 'Nível a Laser', 829.92);
INSERT INTO public.produtos VALUES (107, 6, 'Broca para Concreto', 590.06);
INSERT INTO public.produtos VALUES (108, 6, 'Trena 5m', 238.17);
INSERT INTO public.produtos VALUES (109, 6, 'Esquadro de Aço', 507.03);
INSERT INTO public.produtos VALUES (110, 6, 'Serrote Manual', 180.19);
INSERT INTO public.produtos VALUES (111, 6, 'Pá de Jardinagem', 640.36);
INSERT INTO public.produtos VALUES (112, 6, 'Conjunto de Chaves Allen', 661.63);
INSERT INTO public.produtos VALUES (113, 6, 'Cinto de Ferramentas', 172.77);
INSERT INTO public.produtos VALUES (114, 6, 'Lanterna Tática', 894.32);
INSERT INTO public.produtos VALUES (115, 6, 'Extensão Elétrica', 724.38);
INSERT INTO public.produtos VALUES (116, 6, 'Capacete de Segurança', 619.67);
INSERT INTO public.produtos VALUES (117, 6, 'Luva de Proteção', 931.88);
INSERT INTO public.produtos VALUES (118, 6, 'Máscara de Poeira', 356.61);
INSERT INTO public.produtos VALUES (119, 6, 'Conjunto de Parafusos', 635.24);
INSERT INTO public.produtos VALUES (120, 6, 'Escada Telescópica', 647.77);
INSERT INTO public.produtos VALUES (161, 7, 'Boneca de Pano', 293.38);
INSERT INTO public.produtos VALUES (162, 7, 'Carrinho de Controle Remoto', 253.45);
INSERT INTO public.produtos VALUES (163, 7, 'Jogo de Tabuleiro', 946.51);
INSERT INTO public.produtos VALUES (164, 7, 'Kit de Massinha de Modelar', 953.26);
INSERT INTO public.produtos VALUES (165, 7, 'Cubo Mágico', 562.81);
INSERT INTO public.produtos VALUES (166, 7, 'Quebra-Cabeça 500 Peças', 436.16);
INSERT INTO public.produtos VALUES (167, 7, 'Bola de Futebol', 411.24);
INSERT INTO public.produtos VALUES (168, 7, 'Patins Infantil', 318.11);
INSERT INTO public.produtos VALUES (169, 7, 'Cavalinho de Madeira', 464.59);
INSERT INTO public.produtos VALUES (170, 7, 'Lego Clássico', 789.34);
INSERT INTO public.produtos VALUES (171, 7, 'Fantoches Diversos', 760.79);
INSERT INTO public.produtos VALUES (172, 7, 'Livro de Colorir', 777.43);
INSERT INTO public.produtos VALUES (173, 7, 'Pelúcia Grande', 808.79);
INSERT INTO public.produtos VALUES (174, 7, 'Kit de Ferramentas de Brinquedo', 378.72);
INSERT INTO public.produtos VALUES (175, 7, 'Avião de Controle Remoto', 760.47);
INSERT INTO public.produtos VALUES (176, 7, 'Casa de Bonecas', 670.30);
INSERT INTO public.produtos VALUES (177, 7, 'Jogo de Dominó', 994.99);
INSERT INTO public.produtos VALUES (178, 7, 'Pista de Carrinhos', 517.76);
INSERT INTO public.produtos VALUES (179, 7, 'Trenzinho Elétrico', 107.90);
INSERT INTO public.produtos VALUES (180, 7, 'Jogo da Memória', 961.00);
INSERT INTO public.produtos VALUES (181, 8, 'Arroz 5kg', 22.50);
INSERT INTO public.produtos VALUES (182, 8, 'Feijão Preto 1kg', 10.90);
INSERT INTO public.produtos VALUES (183, 8, 'Macarrão Espaguete 500g', 8.50);
INSERT INTO public.produtos VALUES (184, 8, 'Óleo de Soja 900ml', 11.20);
INSERT INTO public.produtos VALUES (185, 8, 'Açúcar Refinado 1kg', 9.90);
INSERT INTO public.produtos VALUES (186, 8, 'Sal Refinado 1kg', 5.50);
INSERT INTO public.produtos VALUES (187, 8, 'Café 500g', 18.75);
INSERT INTO public.produtos VALUES (188, 8, 'Leite Integral 1L', 6.80);
INSERT INTO public.produtos VALUES (189, 8, 'Margarina 500g', 7.30);
INSERT INTO public.produtos VALUES (190, 8, 'Queijo Mussarela 1kg', 49.00);
INSERT INTO public.produtos VALUES (191, 8, 'Presunto Cozido 1kg', 39.90);
INSERT INTO public.produtos VALUES (192, 8, 'Frango Congelado 1kg', 14.00);
INSERT INTO public.produtos VALUES (193, 8, 'Carne Moída 1kg', 36.50);
INSERT INTO public.produtos VALUES (194, 8, 'Sabonete 90g', 4.20);
INSERT INTO public.produtos VALUES (195, 8, 'Shampoo 300ml', 17.50);
INSERT INTO public.produtos VALUES (196, 8, 'Detergente 500ml', 3.90);
INSERT INTO public.produtos VALUES (197, 8, 'Desinfetante 1L', 12.00);
INSERT INTO public.produtos VALUES (198, 8, 'Cerveja Lata 350ml', 7.50);
INSERT INTO public.produtos VALUES (199, 8, 'Refrigerante 2L', 9.80);
INSERT INTO public.produtos VALUES (200, 8, 'Água Mineral 1.5L', 3.00);


--
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sudoers
--

SELECT pg_catalog.setval('public.categorias_id_seq', 9, true);


--
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sudoers
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 1, false);


--
-- Name: produtos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sudoers
--

SELECT pg_catalog.setval('public.produtos_id_seq', 200, true);


--
-- Name: auditoria_pedidos auditoria_pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.auditoria_pedidos
    ADD CONSTRAINT auditoria_pedidos_pkey PRIMARY KEY (id_pedido);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- Name: pessoas pessoas_pkey; Type: CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.pessoas
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (id);


--
-- Name: itens_pedidos pkey_itens_pedidos; Type: CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.itens_pedidos
    ADD CONSTRAINT pkey_itens_pedidos PRIMARY KEY (id_pedido, id_produto);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id);


--
-- Name: auditoria_pedidos fk_auditoria_pedidos; Type: FK CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.auditoria_pedidos
    ADD CONSTRAINT fk_auditoria_pedidos FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id);


--
-- Name: produtos fk_categoria; Type: FK CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT fk_categoria FOREIGN KEY (id_categoria) REFERENCES public.categorias(id);


--
-- Name: itens_pedidos fk_itens_pedidos; Type: FK CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.itens_pedidos
    ADD CONSTRAINT fk_itens_pedidos FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- Name: pedidos fk_pedidos; Type: FK CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos FOREIGN KEY (id_pessoa) REFERENCES public.pessoas(id);


--
-- Name: itens_pedidos fk_pedidos; Type: FK CONSTRAINT; Schema: public; Owner: sudoers
--

ALTER TABLE ONLY public.itens_pedidos
    ADD CONSTRAINT fk_pedidos FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id);


--
-- PostgreSQL database dump complete
--

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_pessoas
BEFORE UPDATE ON pessoas
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();


CREATE TRIGGER set_updated_at_produtos
BEFORE UPDATE ON produtos
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();











CREATE SCHEMA dw;

CREATE TABLE dw.dim_produtos (
    sk_produto SERIAL PRIMARY KEY,
    id INTEGER NOT NULL,
    cat_desc character varying(255),
    descricao character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

CREATE TABLE dw.stg_pedidos (    
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


CREATE TABLE dw.dim_pessoas (
    sk_pessoa SERIAL PRIMARY KEY,
    id BIGINT NOT NULL,
    nome character varying(255),
    sexo character varying(1),
    dt_nasc DATE,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

CREATE TABLE dw.fato_pedidos (
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
    CONSTRAINT fk_pessoa FOREIGN KEY (sk_pessoa) REFERENCES dw.dim_pessoas (sk_pessoa),
    CONSTRAINT fk_produto FOREIGN KEY (sk_produto) REFERENCES dw.dim_produtos (sk_produto)
);