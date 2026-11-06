-- ============================================================
-- Catalogos Hiroshima - SCRIPT DEFINITIVO
-- Ordem: reset, DDL, massa, SELECT/UPDATE/DELETE, consultas G (G01 a G09), consultas A (A01 a A04).
-- Para rodar do zero: execute o arquivo inteiro. O DROP apaga o banco hiroshima.
-- ============================================================

USE mysql;

DROP DATABASE IF EXISTS hiroshima;

-- ============================================================
-- Catálogos Hiroshima — DDL corrigido (MySQL 8.0)
-- Base: DER conceitual v14 e modelo lógico (brModelo)
--
-- Ordem de criação: tabelas referenciadas antes das que as referenciam.
-- As chaves estrangeiras estão declaradas dentro de cada CREATE TABLE.
--
-- Não representado aqui (verificado pelas consultas A01 a A04 em script.sql):
--   RB08  todo pedido tem ao menos um produto (CONTEM)
--   RB09  todo produto tem ao menos uma compra (ORIGINA)
--   RB10  toda conta a pagar tem ao menos um produto (ORIGINA)
--   RB11  todo faturamento tem ao menos uma nota fiscal (GERA)
-- ============================================================

CREATE DATABASE IF NOT EXISTS hiroshima
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hiroshima;

-- ------------------------------------------------------------
-- CLIENTE (distribuidores)
-- ------------------------------------------------------------
CREATE TABLE CLIENTE (
  id_cliente     INT AUTO_INCREMENT PRIMARY KEY,
  razao_social   VARCHAR(100) NOT NULL,
  CNPJ           CHAR(14)     NOT NULL UNIQUE,
  nome_fantasia  VARCHAR(60),
  email          VARCHAR(100) NOT NULL,
  telefone       VARCHAR(15),
  logradouro     VARCHAR(100) NOT NULL,
  numero         VARCHAR(10)  NOT NULL,
  complemento    VARCHAR(50),
  bairro         VARCHAR(50)  NOT NULL,
  cidade         VARCHAR(50)  NOT NULL,
  UF             CHAR(2)      NOT NULL,
  CEP            CHAR(8)      NOT NULL,
  status         VARCHAR(20)  NOT NULL
);

-- ------------------------------------------------------------
-- REPRESENTANTE_COMERCIAL
-- ------------------------------------------------------------
CREATE TABLE REPRESENTANTE_COMERCIAL (
  id_representante     INT AUTO_INCREMENT PRIMARY KEY,
  nome                 VARCHAR(100) NOT NULL,
  email                VARCHAR(100) NOT NULL,
  telefone             VARCHAR(15),
  status_representante VARCHAR(20)  NOT NULL,
  data_cadastro        DATE         NOT NULL DEFAULT (CURRENT_DATE)
);

-- ------------------------------------------------------------
-- FATURAMENTO
-- ------------------------------------------------------------
CREATE TABLE FATURAMENTO (
  id_faturamento        INT AUTO_INCREMENT PRIMARY KEY,
  data_hora_faturamento DATETIME    NOT NULL,
  status_faturamento    VARCHAR(20) NOT NULL
);

-- ------------------------------------------------------------
-- PRODUTO
-- ------------------------------------------------------------
CREATE TABLE PRODUTO (
  id_produto               INT AUTO_INCREMENT PRIMARY KEY,
  nome_produto             VARCHAR(100)   NOT NULL,
  codigo_barras            VARCHAR(14),
  sku                      VARCHAR(30)    NOT NULL UNIQUE,
  ncm                      CHAR(8)        NOT NULL,
  categoria                VARCHAR(50)    NOT NULL,
  unidade_medida           VARCHAR(5)     NOT NULL,
  preco_unitario           DECIMAL(10,2)  NOT NULL CHECK (preco_unitario >= 0),
  status_produto           VARCHAR(20)    NOT NULL,
  data_hora_ultima_entrada DATETIME,
  data_hora_ultima_saida   DATETIME
);

-- ------------------------------------------------------------
-- FORNECEDOR
-- ------------------------------------------------------------
CREATE TABLE FORNECEDOR (
  id_fornecedor      INT AUTO_INCREMENT PRIMARY KEY,
  razao_social       VARCHAR(100) NOT NULL,
  nome_fantasia      VARCHAR(60),
  CNPJ               CHAR(14)     NOT NULL UNIQUE,
  inscricao_estadual VARCHAR(20),
  telefone           VARCHAR(15),
  email              VARCHAR(100),
  logradouro         VARCHAR(100) NOT NULL,
  numero             VARCHAR(10)  NOT NULL,
  complemento        VARCHAR(50),
  bairro             VARCHAR(50)  NOT NULL,
  cidade             VARCHAR(50)  NOT NULL,
  UF                 CHAR(2)      NOT NULL,
  CEP                CHAR(8)      NOT NULL,
  status             VARCHAR(20)  NOT NULL
);

-- ------------------------------------------------------------
-- TRANSPORTADORA
-- ------------------------------------------------------------
CREATE TABLE TRANSPORTADORA (
  id_transportadora INT AUTO_INCREMENT PRIMARY KEY,
  telefone          VARCHAR(15),
  CNPJ              CHAR(14)     NOT NULL UNIQUE,
  razao_social      VARCHAR(100) NOT NULL,
  email             VARCHAR(100),
  rntrc             VARCHAR(8)   NOT NULL,
  modal             VARCHAR(20)  NOT NULL,
  nome_fantasia     VARCHAR(60)
);

-- ------------------------------------------------------------
-- PEDIDO (ATENDE: id_representante e período ficam aqui)
-- ------------------------------------------------------------
CREATE TABLE PEDIDO (
  id_pedido              INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente             INT          NOT NULL,
  id_representante       INT,
  data_hora_pedido       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data_hora_liberacao    DATETIME,
  tipo_pedido            VARCHAR(20)  NOT NULL,
  status_pedido          VARCHAR(20)  NOT NULL,
  observacao             VARCHAR(255),
  condicao_pagamento     VARCHAR(30)  NOT NULL,
  data_hora_cancelamento DATETIME,
  motivo_cancelamento    VARCHAR(255),
  data_hora_inicio       DATETIME,
  data_hora_fim          DATETIME,
  CONSTRAINT ck_pedido_liberacao CHECK (data_hora_liberacao IS NULL OR data_hora_liberacao >= data_hora_pedido),
  CONSTRAINT ck_pedido_periodo   CHECK (data_hora_fim IS NULL OR data_hora_inicio IS NULL OR data_hora_fim >= data_hora_inicio),
  CONSTRAINT fk_pedido_cliente        FOREIGN KEY (id_cliente)       REFERENCES CLIENTE (id_cliente),
  CONSTRAINT fk_pedido_representante  FOREIGN KEY (id_representante) REFERENCES REPRESENTANTE_COMERCIAL (id_representante)
);

-- ------------------------------------------------------------
-- NOTA_FISCAL (notas de saída)
-- ------------------------------------------------------------
CREATE TABLE NOTA_FISCAL (
  id_nota_fiscal             INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido                  INT           NOT NULL,
  id_faturamento             INT,
  serie_nfe_saida            VARCHAR(3)    NOT NULL,
  numero_nfe_saida           INT           NOT NULL CHECK (numero_nfe_saida > 0),
  chave_nfe_saida            CHAR(44)      NOT NULL UNIQUE,
  motivo_cancelamento_nfe    VARCHAR(255),
  data_hora_cancelamento_nfe DATETIME,
  status_nfe_saida           VARCHAR(20)   NOT NULL,
  data_hora_emissao          DATETIME      NOT NULL,
  protocolo_autorizacao      VARCHAR(20)   NOT NULL,
  valor_total_nfe_saida      DECIMAL(10,2) NOT NULL CHECK (valor_total_nfe_saida >= 0),
  CONSTRAINT fk_nota_pedido      FOREIGN KEY (id_pedido)      REFERENCES PEDIDO (id_pedido),
  CONSTRAINT fk_nota_faturamento FOREIGN KEY (id_faturamento) REFERENCES FATURAMENTO (id_faturamento)
);

-- ------------------------------------------------------------
-- EXPEDICAO (DESPACHA: id_nota_fiscal NOT NULL e UNIQUE)
-- ------------------------------------------------------------
CREATE TABLE EXPEDICAO (
  id_expedicao      INT AUTO_INCREMENT PRIMARY KEY,
  id_nota_fiscal    INT          NOT NULL UNIQUE,
  id_transportadora INT          NOT NULL,
  data_hora_liberacao DATETIME   NOT NULL,
  data_hora_inicio  DATETIME,
  data_hora_fim     DATETIME,
  status_expedicao  VARCHAR(20)  NOT NULL,
  observacao        VARCHAR(255),
  CONSTRAINT ck_expedicao_periodo CHECK (data_hora_fim IS NULL OR data_hora_inicio IS NULL OR data_hora_fim >= data_hora_inicio),
  CONSTRAINT fk_expedicao_nota         FOREIGN KEY (id_nota_fiscal)    REFERENCES NOTA_FISCAL (id_nota_fiscal),
  CONSTRAINT fk_expedicao_transportadora FOREIGN KEY (id_transportadora) REFERENCES TRANSPORTADORA (id_transportadora)
);

-- ------------------------------------------------------------
-- ENTREGA (REALIZA: id_transportadora NOT NULL)
-- ------------------------------------------------------------
CREATE TABLE ENTREGA (
  id_entrega                  INT AUTO_INCREMENT PRIMARY KEY,
  id_transportadora           INT          NOT NULL,
  codigo_rastreio             VARCHAR(40)  NOT NULL UNIQUE,
  motivo_ocorrencia           VARCHAR(255),
  data_hora_saida             DATETIME     NOT NULL,
  data_prevista_entrega       DATE         NOT NULL,
  comprovante_entrega         VARCHAR(255),
  status_entrega              VARCHAR(20)  NOT NULL,
  data_hora_ultima_ocorrencia DATETIME,
  logradouro                  VARCHAR(100) NOT NULL,
  numero                      VARCHAR(10)  NOT NULL,
  complemento                 VARCHAR(50),
  bairro                      VARCHAR(50)  NOT NULL,
  cidade                      VARCHAR(50)  NOT NULL,
  UF                          CHAR(2)      NOT NULL,
  CEP                         CHAR(8)      NOT NULL,
  data_hora_entrega           DATETIME,
  CONSTRAINT ck_entrega_datas CHECK (data_hora_entrega IS NULL OR data_hora_entrega >= data_hora_saida),
  CONSTRAINT fk_entrega_transportadora FOREIGN KEY (id_transportadora) REFERENCES TRANSPORTADORA (id_transportadora)
);

-- ------------------------------------------------------------
-- CONTAS_PAGAR (PAGA: id_fornecedor NOT NULL)
-- ------------------------------------------------------------
CREATE TABLE CONTAS_PAGAR (
  id_conta_pagar      INT AUTO_INCREMENT PRIMARY KEY,
  id_fornecedor       INT           NOT NULL,
  descricao           VARCHAR(255)  NOT NULL,
  chave_nfe_entrada   CHAR(44),
  numero_nfe_entrada  INT,
  serie_nfe_entrada   VARCHAR(3),
  data_emissao        DATE          NOT NULL,
  data_vencimento     DATE          NOT NULL,
  valor_titulo        DECIMAL(10,2) NOT NULL CHECK (valor_titulo >= 0),
  valor_pago          DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (valor_pago >= 0),
  data_hora_pagamento DATETIME,
  forma_pagamento     VARCHAR(30),
  status_conta_pagar  VARCHAR(20)   NOT NULL,
  observacao          VARCHAR(255),
  CONSTRAINT ck_conta_vencimento CHECK (data_vencimento >= data_emissao),
  CONSTRAINT fk_conta_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR (id_fornecedor)
);

-- ------------------------------------------------------------
-- CONTEM (PEDIDO–PRODUTO, chave composta)
-- ------------------------------------------------------------
CREATE TABLE CONTEM (
  id_pedido       INT           NOT NULL,
  id_produto      INT           NOT NULL,
  quantidade      INT           NOT NULL CHECK (quantidade > 0),
  preco_praticado DECIMAL(10,2) NOT NULL CHECK (preco_praticado >= 0),
  desconto        DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (desconto >= 0),
  PRIMARY KEY (id_pedido, id_produto),
  CONSTRAINT fk_contem_pedido  FOREIGN KEY (id_pedido)  REFERENCES PEDIDO (id_pedido),
  CONSTRAINT fk_contem_produto FOREIGN KEY (id_produto) REFERENCES PRODUTO (id_produto)
);

-- ------------------------------------------------------------
-- ORIGINA (CONTAS_PAGAR–PRODUTO, chave composta)
-- ------------------------------------------------------------
CREATE TABLE ORIGINA (
  id_produto            INT           NOT NULL,
  id_conta_pagar        INT           NOT NULL,
  quantidade_comprada   INT           NOT NULL CHECK (quantidade_comprada > 0),
  valor_unitario_compra DECIMAL(10,2) NOT NULL CHECK (valor_unitario_compra >= 0),
  PRIMARY KEY (id_produto, id_conta_pagar),
  CONSTRAINT fk_origina_produto FOREIGN KEY (id_produto)     REFERENCES PRODUTO (id_produto),
  CONSTRAINT fk_origina_conta   FOREIGN KEY (id_conta_pagar) REFERENCES CONTAS_PAGAR (id_conta_pagar)
);

-- ============================================================
-- Catálogos Hiroshima — massa de dados FICTÍCIA
-- Executar DEPOIS de script_ddl_corrigido.sql, em banco vazio
-- (sem dados de teste). Se já houver dados, rodar antes:
--   DROP DATABASE hiroshima,  e depois o DDL.
--
-- Todos os nomes, CNPJs, e-mails, telefones, endereços e chaves
-- de NF-e são FICTÍCIOS. Os CNPJs não têm dígitos verificadores
-- válidos, e os e-mails usam o domínio .invalid.
--
-- PREMISSAS DO GRUPO (não informadas pela organização):
--   P1. 5 transportadoras.
--   P2. 15 fornecedores e 50 contas a pagar, cada produto tem uma compra (ORIGINA).
--   P3. Cada conta a pagar reúne 10 produtos.
--   P4. 900 pedidos no período (aprox. 1 mês), com 1 a 4 itens cada.
--   P5. Cada pedido gera 1 nota fiscal e 1 faturamento.
--   P6. 1 em cada 25 pedidos é cancelado (com nota cancelada e faturamento cancelado).
--   P7. Cada nota não cancelada gera 1 expedição e 1 entrega.
--   P8. Pedidos sem representante: 1 em cada 5.
--
-- Volumes esperados ao final:
--   CLIENTE 3000 · REPRESENTANTE_COMERCIAL 30 · PRODUTO 500
--   FORNECEDOR 15 · TRANSPORTADORA 5 · CONTAS_PAGAR 50 · ORIGINA 500
--   PEDIDO 900 · CONTEM 2250 · FATURAMENTO 900 · NOTA_FISCAL 900
--   EXPEDICAO 864 · ENTREGA 864
-- ============================================================

USE hiroshima;

SET SESSION cte_max_recursion_depth = 5000;

-- ------------------------------------------------------------
-- CLIENTE (3000)
-- ------------------------------------------------------------
INSERT INTO CLIENTE (razao_social, CNPJ, nome_fantasia, email, telefone, logradouro, numero, complemento, bairro, cidade, UF, CEP, status)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 3000
)
SELECT
  CONCAT('Cliente Ficticio ', n, ' Ltda'),
  LPAD(n, 14, '0'),
  CONCAT('Loja Ficticia ', n),
  CONCAT('cliente', n, '@exemplo.invalid'),
  CONCAT('11', LPAD(n, 9, '0')),
  CONCAT('Rua Ficticia ', n % 200 + 1),
  CAST(n % 999 + 1 AS CHAR),
  CASE WHEN n % 3 = 0 THEN CONCAT('Sala ', n % 10 + 1) ELSE NULL END,
  CONCAT('Bairro ', n % 40 + 1),
  'Cidade Ficticia',
  'SP',
  LPAD(n, 8, '0'),
  CASE WHEN n % 10 = 0 THEN 'INATIVO' ELSE 'ATIVO' END
FROM s;

-- ------------------------------------------------------------
-- REPRESENTANTE_COMERCIAL (30)
-- ------------------------------------------------------------
INSERT INTO REPRESENTANTE_COMERCIAL (nome, email, telefone, status_representante)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 30
)
SELECT
  CONCAT('Representante Ficticio ', n),
  CONCAT('rep', n, '@exemplo.invalid'),
  CONCAT('11', LPAD(n, 9, '8')),
  CASE WHEN n % 8 = 0 THEN 'INATIVO' ELSE 'ATIVO' END
FROM s;

-- ------------------------------------------------------------
-- PRODUTO (500)
-- ------------------------------------------------------------
INSERT INTO PRODUTO (nome_produto, codigo_barras, sku, ncm, categoria, unidade_medida, preco_unitario, status_produto)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 500
)
SELECT
  CONCAT('Produto Ficticio ', n),
  LPAD(n, 13, '0'),
  CONCAT('SKU-', LPAD(n, 4, '0')),
  '62044200',
  CASE WHEN n % 10 < 7 THEN 'MODA_FEMININA'
       WHEN n % 10 < 9 THEN 'UTENSILIOS'
       ELSE 'CASA' END,
  'UN',
  ROUND(19.90 + (n % 50) * 3.50, 2),
  CASE WHEN n % 25 = 0 THEN 'INATIVO' ELSE 'ATIVO' END
FROM s;

-- ------------------------------------------------------------
-- FORNECEDOR (15)
-- ------------------------------------------------------------
INSERT INTO FORNECEDOR (razao_social, nome_fantasia, CNPJ, inscricao_estadual, telefone, email, logradouro, numero, complemento, bairro, cidade, UF, CEP, status)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 15
)
SELECT
  CONCAT('Fornecedor Ficticio ', n, ' SA'),
  NULL,
  LPAD(n, 14, '9'),
  'ISENTO',
  CONCAT('11', LPAD(n, 9, '7')),
  CONCAT('fornecedor', n, '@exemplo.invalid'),
  CONCAT('Avenida Ficticia ', n),
  CAST(n * 10 AS CHAR),
  NULL,
  'Centro',
  'Cidade Ficticia',
  'SP',
  LPAD(n, 8, '1'),
  'ATIVO'
FROM s;

-- ------------------------------------------------------------
-- TRANSPORTADORA (5) — premissa P1
-- ------------------------------------------------------------
INSERT INTO TRANSPORTADORA (telefone, CNPJ, razao_social, email, rntrc, modal, nome_fantasia)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 5
)
SELECT
  CONCAT('11', LPAD(n, 9, '6')),
  LPAD(n, 14, '8'),
  CONCAT('Transportadora Ficticia ', n, ' Ltda'),
  CONCAT('transp', n, '@exemplo.invalid'),
  LPAD(n, 8, '0'),
  'RODOVIARIO',
  CONCAT('Transp Ficticia ', n)
FROM s;

-- ------------------------------------------------------------
-- FATURAMENTO (900) — uma por pedido (P5)
-- ------------------------------------------------------------
INSERT INTO FATURAMENTO (data_hora_faturamento, status_faturamento)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 900
)
SELECT
  TIMESTAMPADD(HOUR, 2, TIMESTAMPADD(MINUTE, n * 45, '2026-10-01 08:00:00')),
  CASE WHEN n % 25 = 0 THEN 'CANCELADO' ELSE 'EMITIDO' END
FROM s;

-- ------------------------------------------------------------
-- CONTAS_PAGAR (50) — premissa P2
-- ------------------------------------------------------------
INSERT INTO CONTAS_PAGAR (id_fornecedor, descricao, data_emissao, data_vencimento, valor_titulo, valor_pago, data_hora_pagamento, forma_pagamento, status_conta_pagar, observacao, chave_nfe_entrada, numero_nfe_entrada, serie_nfe_entrada)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 50
)
SELECT
  ((n - 1) % 15) + 1,
  CONCAT('Compra ficticia do lote ', n),
  DATE_ADD('2026-09-01', INTERVAL n DAY),
  DATE_ADD(DATE_ADD('2026-09-01', INTERVAL n DAY), INTERVAL 30 DAY),
  ROUND(3000 + n * 150, 2),
  CASE WHEN n % 2 = 0 THEN ROUND(3000 + n * 150, 2) ELSE 0 END,
  CASE WHEN n % 2 = 0 THEN TIMESTAMPADD(DAY, 28, DATE_ADD('2026-09-01', INTERVAL n DAY)) ELSE NULL END,
  CASE WHEN n % 2 = 0 THEN 'PIX' ELSE 'BOLETO' END,
  CASE WHEN n % 2 = 0 THEN 'PAGA' ELSE 'ABERTA' END,
  NULL,
  NULL,
  NULL,
  NULL
FROM s;

-- ------------------------------------------------------------
-- ORIGINA (500) — cada produto tem uma compra (RB09),
-- cada conta reúne 10 produtos (RB10)
-- ------------------------------------------------------------
INSERT INTO ORIGINA (id_produto, id_conta_pagar, quantidade_comprada, valor_unitario_compra)
SELECT
  id_produto,
  ((id_produto - 1) % 50) + 1,
  10 + (id_produto % 20),
  ROUND(preco_unitario * 0.5, 2)
FROM PRODUTO;

-- ------------------------------------------------------------
-- PEDIDO (900) — pedido n tem id n (base vazia)
-- ------------------------------------------------------------
INSERT INTO PEDIDO (id_cliente, id_representante, data_hora_pedido, data_hora_liberacao, tipo_pedido, status_pedido, observacao, condicao_pagamento, data_hora_cancelamento, motivo_cancelamento, data_hora_inicio, data_hora_fim)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 900
)
SELECT
  ((n * 37) % 3000) + 1,
  CASE WHEN n % 5 = 0 THEN NULL ELSE ((n - 1) % 30) + 1 END,
  TIMESTAMPADD(MINUTE, n * 45, '2026-10-01 08:00:00'),
  TIMESTAMPADD(MINUTE, n * 45 + 30, '2026-10-01 08:00:00'),
  CASE WHEN n % 20 = 0 THEN 'TROCA'
       WHEN n % 50 = 0 THEN 'BONIFICACAO'
       ELSE 'VENDA' END,
  CASE WHEN n % 25 = 0 THEN 'CANCELADO'
       WHEN n % 10 <> 0 AND n % 7 <> 0 THEN 'ENTREGUE'
       ELSE 'EXPEDIDO' END,
  NULL,
  CASE WHEN n % 3 = 0 THEN 'A_VISTA' ELSE 'A_PRAZO' END,
  CASE WHEN n % 25 = 0 THEN TIMESTAMPADD(DAY, 1, TIMESTAMPADD(MINUTE, n * 45, '2026-10-01 08:00:00')) ELSE NULL END,
  CASE WHEN n % 25 = 0 THEN 'Cancelamento solicitado pelo distribuidor (ficticio)' ELSE NULL END,
  CASE WHEN n % 5 <> 0 THEN TIMESTAMPADD(DAY, -1, TIMESTAMPADD(MINUTE, n * 45, '2026-10-01 08:00:00')) ELSE NULL END,
  NULL
FROM s;

-- ------------------------------------------------------------
-- CONTEM (2250) — de 1 a 4 itens por pedido (P4).
-- Produtos distintos dentro do mesmo pedido.
-- ------------------------------------------------------------
INSERT INTO CONTEM (id_pedido, id_produto, quantidade, preco_praticado, desconto)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 900
),
ks AS (
  SELECT 0 AS k UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
),
it AS (
  SELECT s.n, ks.k
  FROM s CROSS JOIN ks
  WHERE ks.k < (s.n % 4) + 1
)
SELECT
  it.n,
  ((it.n * 7 + it.k * 13) % 500) + 1,
  1 + ((it.n + it.k) % 3),
  p.preco_unitario,
  CASE WHEN (it.n + it.k) % 7 = 0 THEN ROUND(p.preco_unitario * 0.05, 2) ELSE 0 END
FROM it
JOIN PRODUTO p ON p.id_produto = ((it.n * 7 + it.k * 13) % 500) + 1;

-- ------------------------------------------------------------
-- NOTA_FISCAL (900) — uma por pedido (P5), id_faturamento = n
-- ------------------------------------------------------------
INSERT INTO NOTA_FISCAL (id_pedido, id_faturamento, serie_nfe_saida, numero_nfe_saida, chave_nfe_saida, motivo_cancelamento_nfe, data_hora_cancelamento_nfe, status_nfe_saida, data_hora_emissao, protocolo_autorizacao, valor_total_nfe_saida)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 900
)
SELECT
  n,
  n,
  '1',
  n,
  LPAD(n, 44, '0'),
  CASE WHEN n % 25 = 0 THEN 'Cancelamento do pedido (ficticio)' ELSE NULL END,
  CASE WHEN n % 25 = 0 THEN TIMESTAMPADD(DAY, 1, TIMESTAMPADD(MINUTE, n * 45 + 60, '2026-10-01 08:00:00')) ELSE NULL END,
  CASE WHEN n % 25 = 0 THEN 'CANCELADA' ELSE 'AUTORIZADA' END,
  TIMESTAMPADD(MINUTE, n * 45 + 60, '2026-10-01 08:00:00'),
  CONCAT('PROT', LPAD(n, 10, '0')),
  (SELECT ROUND(SUM(c.quantidade * c.preco_praticado - c.desconto), 2)
     FROM CONTEM c
    WHERE c.id_pedido = s.n)
FROM s;

-- ------------------------------------------------------------
-- EXPEDICAO (864) — uma por nota não cancelada (P7)
-- ------------------------------------------------------------
INSERT INTO EXPEDICAO (id_nota_fiscal, id_transportadora, data_hora_liberacao, data_hora_inicio, data_hora_fim, status_expedicao, observacao)
WITH RECURSIVE s AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM s WHERE n < 900
)
SELECT
  n,
  ((n - 1) % 5) + 1,
  TIMESTAMPADD(HOUR, 3, TIMESTAMPADD(MINUTE, n * 45, '2026-10-01 08:00:00')),
  TIMESTAMPADD(HOUR, 4, TIMESTAMPADD(MINUTE, n * 45, '2026-10-01 08:00:00')),
  TIMESTAMPADD(HOUR, 5, TIMESTAMPADD(MINUTE, n * 45, '2026-10-01 08:00:00')),
  'DESPACHADA',
  NULL
FROM s
WHERE n % 25 <> 0;

-- ------------------------------------------------------------
-- ENTREGA (864) — uma por expedição, endereço = endereço do cliente
-- ------------------------------------------------------------
INSERT INTO ENTREGA (id_transportadora, codigo_rastreio, motivo_ocorrencia, data_hora_saida, data_prevista_entrega, comprovante_entrega, status_entrega, data_hora_ultima_ocorrencia, logradouro, numero, complemento, bairro, cidade, UF, CEP, data_hora_entrega)
SELECT
  e.id_transportadora,
  CONCAT('BR', LPAD(e.id_expedicao, 11, '0')),
  CASE WHEN nf.id_pedido % 10 = 0 THEN 'Destinatario ausente (ficticio)' ELSE NULL END,
  e.data_hora_fim,
  DATE_ADD(DATE(e.data_hora_fim), INTERVAL 3 DAY),
  CASE WHEN nf.id_pedido % 10 <> 0 AND nf.id_pedido % 7 <> 0
       THEN CONCAT('comprovantes/ENT', LPAD(e.id_expedicao, 11, '0'), '.pdf')
       ELSE NULL END,
  CASE WHEN nf.id_pedido % 10 = 0 THEN 'OCORRENCIA'
       WHEN nf.id_pedido % 7 = 0 THEN 'EM_TRANSITO'
       ELSE 'ENTREGUE' END,
  CASE WHEN nf.id_pedido % 10 = 0 THEN TIMESTAMPADD(DAY, 2, e.data_hora_fim) ELSE NULL END,
  c.logradouro,
  c.numero,
  c.complemento,
  c.bairro,
  c.cidade,
  c.UF,
  c.CEP,
  CASE WHEN nf.id_pedido % 10 <> 0 AND nf.id_pedido % 7 <> 0
       THEN TIMESTAMPADD(DAY, 2, e.data_hora_fim)
       ELSE NULL END
FROM EXPEDICAO e
JOIN NOTA_FISCAL nf ON nf.id_nota_fiscal = e.id_nota_fiscal
JOIN PEDIDO p       ON p.id_pedido = nf.id_pedido
JOIN CLIENTE c      ON c.id_cliente = p.id_cliente;

-- ============================================================
-- Catálogos Hiroshima — SELECTs com JOIN, UPDATE e DELETE
-- Executar DEPOIS de script_ddl_corrigido.sql e massa_de_dados.sql
-- ============================================================

USE hiroshima;

-- ------------------------------------------------------------
-- SELECTs com JOIN
-- ------------------------------------------------------------

-- S1: pedidos com o nome do cliente e do representante.
-- LEFT JOIN no representante, porque o pedido pode não ter representante.
SELECT p.id_pedido,
       p.data_hora_pedido,
       c.razao_social AS cliente,
       COALESCE(r.nome, 'Sem representante') AS representante,
       p.status_pedido
FROM PEDIDO p
JOIN CLIENTE c ON c.id_cliente = p.id_cliente
LEFT JOIN REPRESENTANTE_COMERCIAL r ON r.id_representante = p.id_representante
ORDER BY p.id_pedido
LIMIT 10;

-- S2: itens do pedido 1, com o nome do produto e o subtotal de cada item.
SELECT ct.id_pedido,
       pr.nome_produto,
       ct.quantidade,
       ct.preco_praticado,
       ct.desconto,
       ROUND(ct.quantidade * ct.preco_praticado - ct.desconto, 2) AS subtotal
FROM CONTEM ct
JOIN PRODUTO pr ON pr.id_produto = ct.id_produto
WHERE ct.id_pedido = 1
ORDER BY pr.nome_produto;

-- S3: ciclo do pedido, do pedido à expedição.
-- A entrega não aparece aqui: ENTREGA se liga só à transportadora (limitação do modelo).
SELECT p.id_pedido,
       nf.numero_nfe_saida,
       nf.status_nfe_saida,
       f.status_faturamento,
       e.status_expedicao
FROM PEDIDO p
JOIN NOTA_FISCAL nf ON nf.id_pedido = p.id_pedido
JOIN FATURAMENTO f ON f.id_faturamento = nf.id_faturamento
LEFT JOIN EXPEDICAO e ON e.id_nota_fiscal = nf.id_nota_fiscal
WHERE p.id_pedido BETWEEN 1 AND 10
ORDER BY p.id_pedido;

-- S4: entregas por transportadora, com total e número de ocorrências.
SELECT t.nome_fantasia,
       COUNT(*) AS entregas,
       SUM(en.status_entrega = 'OCORRENCIA') AS ocorrencias
FROM ENTREGA en
JOIN TRANSPORTADORA t ON t.id_transportadora = en.id_transportadora
GROUP BY t.nome_fantasia
ORDER BY entregas DESC;

-- ------------------------------------------------------------
-- UPDATEs
-- ------------------------------------------------------------

-- U1: a entrega do pedido 7 foi concluída. O código de rastreio é BR + id da expedição (11 dígitos).
-- O WHERE inclui o status atual, para que o comando só altere a linha se ela estiver em trânsito.
UPDATE ENTREGA
   SET status_entrega = 'ENTREGUE',
       data_hora_entrega = '2026-11-05 10:00:00',
       comprovante_entrega = 'comprovantes/ENT00000000007.pdf'
 WHERE codigo_rastreio = 'BR00000000007'
   AND status_entrega = 'EM_TRANSITO';

-- U2: o pedido 7 também passa para ENTREGUE.
UPDATE PEDIDO
   SET status_pedido = 'ENTREGUE'
 WHERE id_pedido = 7
   AND status_pedido = 'EXPEDIDO';

-- ------------------------------------------------------------
-- DELETEs
-- ------------------------------------------------------------

-- D1: apagar um representante de teste, sem pedidos vinculados.
-- Criado aqui só para o DELETE ter um alvo seguro.
INSERT INTO REPRESENTANTE_COMERCIAL (nome, email, status_representante)
VALUES ('Representante Descartavel', 'descartavel@exemplo.invalid', 'INATIVO');

DELETE FROM REPRESENTANTE_COMERCIAL
 WHERE email = 'descartavel@exemplo.invalid';

-- ------------------------------------------------------------
-- TESTE DE INTEGRIDADE (NÃO incluir na execução normal)
-- Este comando deve FALHAR com erro 1451 (foreign key constraint fails),
-- porque o cliente 38 tem o pedido 1. Serve para demonstrar a proteção do banco.
-- Rodar isoladamente, na apresentação.
-- DELETE FROM CLIENTE WHERE id_cliente = 38,
-- ============================================================

-- ============================================================
-- Catálogos Hiroshima — consultas gerenciais G01 e G09
-- Executar depois de script_ddl_corrigido.sql e massa_de_dados.sql
-- ============================================================

USE hiroshima;

-- ------------------------------------------------------------
-- G01 — Visão única do pedido
-- Pergunta: quais são os dados de cada pedido em um só lugar,
-- do cliente até a expedição?
-- Atende: P1 (informações divididas entre setores)
-- ------------------------------------------------------------
SELECT p.id_pedido,
       p.data_hora_pedido,
       c.razao_social                         AS cliente,
       COALESCE(r.nome, 'Sem representante')  AS representante,
       p.status_pedido,
       nf.numero_nfe_saida,
       nf.status_nfe_saida,
       f.id_faturamento,
       f.status_faturamento,
       e.id_expedicao,
       e.status_expedicao,
       t.nome_fantasia                        AS transportadora
FROM PEDIDO p
JOIN CLIENTE c                  ON c.id_cliente = p.id_cliente
LEFT JOIN REPRESENTANTE_COMERCIAL r ON r.id_representante = p.id_representante
LEFT JOIN NOTA_FISCAL nf        ON nf.id_pedido = p.id_pedido
LEFT JOIN FATURAMENTO f         ON f.id_faturamento = nf.id_faturamento
LEFT JOIN EXPEDICAO e           ON e.id_nota_fiscal = nf.id_nota_fiscal
LEFT JOIN TRANSPORTADORA t      ON t.id_transportadora = e.id_transportadora
ORDER BY p.id_pedido
LIMIT 20;


-- ============================================================
-- Catálogos Hiroshima — consultas gerenciais G02 a G08
-- ============================================================

-- ------------------------------------------------------------
-- G02 — Pedidos com etapa avançada sem o registro da etapa anterior
-- Pergunta: existe pedido expedido ou entregue sem nota fiscal ou sem expedição?
-- Resultado esperado na massa: nenhuma linha.
-- Atende: P2 (perda de dados entre etapas)
-- ------------------------------------------------------------
SELECT p.id_pedido,
       p.status_pedido,
       COUNT(nf.id_nota_fiscal) AS notas,
       COUNT(e.id_expedicao)    AS expedicoes
FROM PEDIDO p
LEFT JOIN NOTA_FISCAL nf ON nf.id_pedido = p.id_pedido
LEFT JOIN EXPEDICAO e    ON e.id_nota_fiscal = nf.id_nota_fiscal
WHERE p.status_pedido IN ('EXPEDIDO', 'ENTREGUE')
GROUP BY p.id_pedido, p.status_pedido
HAVING COUNT(nf.id_nota_fiscal) = 0 OR COUNT(e.id_expedicao) = 0;

-- ------------------------------------------------------------
-- G03 — Pedidos por status, por mês
-- Pergunta: quantos pedidos estão em cada etapa do ciclo, em cada mês?
-- Atende: P3 (falta de visão integrada do ciclo)
-- ------------------------------------------------------------
SELECT DATE_FORMAT(p.data_hora_pedido, '%Y-%m') AS mes,
       p.status_pedido,
       COUNT(*) AS pedidos
FROM PEDIDO p
GROUP BY mes, p.status_pedido
ORDER BY mes, p.status_pedido;

-- ------------------------------------------------------------
-- G04 — Ticket médio por nota fiscal autorizada, por mês
-- Pergunta: qual o valor médio das notas autorizadas em cada mês?
-- Atende: K01 (ticket médio por nota)
-- ------------------------------------------------------------
SELECT DATE_FORMAT(nf.data_hora_emissao, '%Y-%m') AS mes,
       COUNT(*)                                   AS notas_autorizadas,
       ROUND(AVG(nf.valor_total_nfe_saida), 2)    AS ticket_medio
FROM NOTA_FISCAL nf
WHERE nf.status_nfe_saida = 'AUTORIZADA'
GROUP BY mes
ORDER BY mes;

-- ------------------------------------------------------------
-- G05 — Taxa de cancelamento de pedidos, por mês
-- Pergunta: qual percentual dos pedidos foi cancelado em cada mês?
-- Atende: K02 (taxa de cancelamento de pedidos)
-- ------------------------------------------------------------
SELECT DATE_FORMAT(p.data_hora_pedido, '%Y-%m')                 AS mes,
       COUNT(*)                                                 AS total_pedidos,
       SUM(p.status_pedido = 'CANCELADO')                       AS cancelados,
       ROUND(100 * SUM(p.status_pedido = 'CANCELADO') / COUNT(*), 2) AS taxa_cancelamento_pct
FROM PEDIDO p
GROUP BY mes
ORDER BY mes;

-- ------------------------------------------------------------
-- G06 — Tempo médio entre a liberação do pedido e o início da expedição, por mês
-- Pergunta: quantas horas, em média, levam entre a liberação e o início da expedição?
-- Atende: K03 (tempo até a expedição)
-- ------------------------------------------------------------
SELECT DATE_FORMAT(p.data_hora_pedido, '%Y-%m') AS mes,
       COUNT(*)                                 AS expedicoes,
       ROUND(AVG(TIMESTAMPDIFF(HOUR, p.data_hora_liberacao, e.data_hora_inicio)), 2) AS horas_ate_expedicao
FROM EXPEDICAO e
JOIN NOTA_FISCAL nf ON nf.id_nota_fiscal = e.id_nota_fiscal
JOIN PEDIDO p       ON p.id_pedido = nf.id_pedido
WHERE p.data_hora_liberacao IS NOT NULL
  AND e.data_hora_inicio IS NOT NULL
GROUP BY mes
ORDER BY mes;

-- ------------------------------------------------------------
-- G07 — Prazo médio de entrega por transportadora (somente entregas realizadas)
-- Pergunta: quantos dias cada transportadora leva, em média, da saída até a entrega?
-- Atende: K04 (prazo médio de entrega)
-- ------------------------------------------------------------
SELECT t.nome_fantasia                                              AS transportadora,
       COUNT(*)                                                     AS entregas_realizadas,
       ROUND(AVG(DATEDIFF(en.data_hora_entrega, en.data_hora_saida)), 2) AS prazo_medio_dias
FROM ENTREGA en
JOIN TRANSPORTADORA t ON t.id_transportadora = en.id_transportadora
WHERE en.status_entrega = 'ENTREGUE'
GROUP BY t.nome_fantasia
ORDER BY prazo_medio_dias;

-- ------------------------------------------------------------
-- G08 — Percentual de entregas com ocorrência, por transportadora
-- Pergunta: qual percentual das entregas de cada transportadora teve ocorrência?
-- Atende: K05 (percentual de entregas com ocorrência)
-- ------------------------------------------------------------
SELECT t.nome_fantasia                                                AS transportadora,
       COUNT(*)                                                       AS total_entregas,
       SUM(en.status_entrega = 'OCORRENCIA')                          AS ocorrencias,
       ROUND(100 * SUM(en.status_entrega = 'OCORRENCIA') / COUNT(*), 2) AS percentual_ocorrencia
FROM ENTREGA en
JOIN TRANSPORTADORA t ON t.id_transportadora = en.id_transportadora
GROUP BY t.nome_fantasia
ORDER BY percentual_ocorrencia DESC;

-- ------------------------------------------------------------
-- G09 — Produtos mais vendidos por mês (top 10 por mês)
-- Pergunta: quais produtos tiveram maior quantidade vendida em cada mês?
-- Regra: pedidos cancelados ficam fora do cálculo.
-- Atende: K06 (produtos mais vendidos)
-- ------------------------------------------------------------
WITH vendas AS (
  SELECT DATE_FORMAT(p.data_hora_pedido, '%Y-%m') AS mes,
         pr.id_produto,
         pr.nome_produto,
         pr.categoria,
         SUM(ct.quantidade) AS quantidade_vendida
  FROM CONTEM ct
  JOIN PRODUTO pr ON pr.id_produto = ct.id_produto
  JOIN PEDIDO p   ON p.id_pedido = ct.id_pedido
  WHERE p.status_pedido <> 'CANCELADO'
  GROUP BY mes, pr.id_produto, pr.nome_produto, pr.categoria
),
ranking AS (
  SELECT v.*,
         ROW_NUMBER() OVER (PARTITION BY v.mes ORDER BY v.quantidade_vendida DESC) AS posicao
  FROM vendas v
)
SELECT mes,
       posicao,
       nome_produto,
       categoria,
       quantidade_vendida
FROM ranking
WHERE posicao <= 10
ORDER BY mes, posicao;

-- ============================================================
-- Catálogos Hiroshima — consultas de auditoria A01 a A04
-- Cada consulta deve retornar ZERO linhas na massa de dados.
-- ============================================================

-- A01 — Existe pedido sem nenhum produto?
-- Verifica: RB08 (todo pedido tem ao menos um produto)
SELECT p.id_pedido
FROM PEDIDO p
LEFT JOIN CONTEM c ON c.id_pedido = p.id_pedido
WHERE c.id_pedido IS NULL;

-- A02 — Existe conta a pagar sem nenhum produto?
-- Verifica: RB10 (toda conta a pagar tem ao menos um produto)
SELECT cp.id_conta_pagar
FROM CONTAS_PAGAR cp
LEFT JOIN ORIGINA o ON o.id_conta_pagar = cp.id_conta_pagar
WHERE o.id_conta_pagar IS NULL;

-- A03 — Existe produto sem nenhuma compra registrada?
-- Verifica: RB09 (todo produto tem ao menos uma origem de compra)
SELECT pr.id_produto
FROM PRODUTO pr
LEFT JOIN ORIGINA o ON o.id_produto = pr.id_produto
WHERE o.id_produto IS NULL;

-- A04 — Existe faturamento sem nenhuma nota fiscal?
-- Verifica: RB11 (todo faturamento tem ao menos uma nota)
SELECT f.id_faturamento
FROM FATURAMENTO f
LEFT JOIN NOTA_FISCAL nf ON nf.id_faturamento = f.id_faturamento
WHERE nf.id_nota_fiscal IS NULL;

