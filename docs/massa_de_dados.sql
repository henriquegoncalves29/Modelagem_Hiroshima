-- ============================================================
-- Catálogos Hiroshima — massa de dados FICTÍCIA
-- Executar DEPOIS de script_ddl_corrigido.sql, em banco vazio
-- (sem dados de teste). Se já houver dados, rodar antes:
--   DROP DATABASE hiroshima;  e depois o DDL.
--
-- Todos os nomes, CNPJs, e-mails, telefones, endereços e chaves
-- de NF-e são FICTÍCIOS. Os CNPJs não têm dígitos verificadores
-- válidos, e os e-mails usam o domínio .invalid.
--
-- PREMISSAS DO GRUPO (não informadas pela organização):
--   P1. 5 transportadoras.
--   P2. 15 fornecedores e 50 contas a pagar; cada produto tem uma compra (ORIGINA).
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
-- ORIGINA (500) — cada produto tem uma compra (RB09);
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
-- NOTA_FISCAL (900) — uma por pedido (P5); id_faturamento = n
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
-- ENTREGA (864) — uma por expedição; endereço = endereço do cliente
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
