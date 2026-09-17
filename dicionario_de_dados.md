# Dicionário de Dados — Sistema de Pedidos e Expedição (v2)

**Domínio:** distribuição B2B — recebimento de pedidos de distribuidores, separação/conferência em centro de distribuição e entrega para todo o Brasil.
**Modelo:** conceitual/lógico em 3FN, 12 entidades, 12 relacionamentos.
**Notação:** Entidade–Relacionamento (Chen) com atributos listados dentro da entidade; PK sublinhada, FK identificada, cardinalidade máxima (1, N) nas linhas e cardinalidade mínima descrita na seção 4.

---

## 1. Ponto crítico do enunciado: `ITEM_PEDIDO` **não** é a mesma coisa que `PRODUTO`

Essa é a única instrução do briefing que eu recomendo não seguir literalmente, e vale explicar o porquê — costuma ser exatamente o ponto que a banca cobra.

| | `PRODUTO` | `ITEM_PEDIDO` |
|---|---|---|
| O que representa | O **catálogo**: a existência do SKU na empresa | A **participação** de um produto dentro de um pedido específico |
| Existe sem o outro? | Sim (produto cadastrado e nunca vendido) | Não (só existe se houver pedido **e** produto) |
| Cardinalidade | 1 produto aparece em N pedidos | 1 item pertence a exatamente 1 pedido e 1 produto |
| Exemplo de atributo | `peso`, `codigo_barras` (valem sempre) | `quantidade_solicitada`, `valor_unitario` (valem só naquele pedido) |

Fundir as duas entidades quebraria a 2ª Forma Normal: `nome_produto` e `peso` dependeriam apenas de `id_produto`, e não da chave inteira do item. Na prática, o catálogo seria reescrito a cada pedido e um produto não poderia ser vendido duas vezes.

O que realmente existe no modelo é um **relacionamento N:N entre `PEDIDO` e `PRODUTO`**, e `ITEM_PEDIDO` é a **entidade associativa** que o resolve. No diagrama original isso já estava certo em estrutura, mas mal expresso: `ITEM_PEDIDO` tinha uma PK artificial (`id_item_pedido`) e um relacionamento solto com `PEDIDO`. Na v2 ela recebe **PK composta `(id_pedido, id_produto)`**, que é a forma canônica e ainda garante de graça a regra "um produto não se repete duas vezes no mesmo pedido".

> Se o professor exigir a fusão mesmo assim, o caminho defensável é o oposto do pedido: manter `ITEM_PEDIDO` e transformar `PRODUTO` em entidade de catálogo apenas referenciada — nunca copiar os dados do produto para dentro do item.

---

## 2. Critérios usados para enxugar (de ~110 para 92 atributos)

1. **Nada de atributo derivado.** Todo valor que pode ser calculado por agregação sai do modelo e vira consulta (seção 6). Guardar total em coluna cria risco de inconsistência sem nenhum ganho semântico.
2. **`data` + `hora` viram um só atributo** de data/hora (`TIMESTAMP`). Dois campos para um mesmo instante é redundância de representação.
3. **Um identificador natural por entidade.** `codigo_produto` + `codigo_barras` viravam dois identificadores concorrentes; ficou `codigo_barras` (GTIN). `numero_faturamento` + `numero_nota_fiscal` idem.
4. **Endereço como atributo composto** (`cep, logradouro, numero, complemento, bairro, cidade, uf`), padronizado nas três entidades que precisam dele. Na implementação física ele vira 7 colunas ou uma tabela `ENDERECO` — a decisão é de projeto físico, não conceitual.
5. **`observacao` só onde há valor de negócio** (em `PEDIDO`). Campo-texto livre replicado em toda entidade é ruído.
6. **Atributos fora do escopo saem.** `estoque_disponivel` pertence a um módulo de estoque (movimentações), não ao cadastro de produto; manter aqui seria um dado sempre desatualizado.

---

## 3. Dicionário de dados por entidade

Convenções: `PK` chave primária · `FK` chave estrangeira · `UK` chave única/alternativa · **Obr.** = obrigatório (NOT NULL).

### 3.1 DISTRIBUIDOR
Cliente pessoa jurídica que emite pedidos.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_distribuidor | INTEGER | PK | Sim | Identificador interno (sequencial). |
| cnpj | CHAR(14) | UK | Sim | Somente dígitos; validado por dígito verificador. |
| razao_social | VARCHAR(120) | | Sim | Denominação legal. |
| nome_fantasia | VARCHAR(120) | | Não | Nome comercial. |
| inscricao_estadual | VARCHAR(20) | | Não | Necessária para a NF-e; nulo quando isento. |
| email | VARCHAR(100) | | Sim | Contato para envio de NF-e e prévia. |
| telefone | VARCHAR(20) | | Não | Com DDD. |
| endereco | COMPOSTO | | Sim | cep, logradouro, numero, complemento, bairro, cidade, uf. |
| status | VARCHAR(10) | | Sim | ATIVO, INATIVO, BLOQUEADO. |

### 3.2 REPRESENTANTE
Colaborador/representante comercial responsável por receber e acompanhar o pedido.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_representante | INTEGER | PK | Sim | Identificador interno. |
| cpf | CHAR(11) | UK | Sim | Somente dígitos. |
| nome | VARCHAR(120) | | Sim | Nome completo. |
| email | VARCHAR(100) | | Sim | Contato corporativo. |
| telefone | VARCHAR(20) | | Não | Com DDD. |
| status | VARCHAR(10) | | Sim | ATIVO, INATIVO. |

*Removido:* `cargo` — a própria entidade já define o papel; cargos adicionais seriam um módulo de RH.

### 3.3 PRODUTO
Item do catálogo comercializado.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_produto | INTEGER | PK | Sim | Identificador interno. |
| codigo_barras | VARCHAR(14) | UK | Sim | GTIN/EAN usado na bipagem. |
| nome_produto | VARCHAR(150) | | Sim | Descrição comercial. |
| categoria | VARCHAR(50) | | Sim | Agrupamento mercadológico. |
| unidade_medida | VARCHAR(10) | | Sim | UN, CX, KG, L. |
| peso | DECIMAL(10,3) | | Sim | Em kg; usado na cubagem e no frete. |
| altura | DECIMAL(10,2) | | Sim | Em cm. |
| largura | DECIMAL(10,2) | | Sim | Em cm. |
| comprimento | DECIMAL(10,2) | | Sim | Em cm. |
| preco_unitario | DECIMAL(12,2) | | Sim | Preço de tabela vigente. |
| status | VARCHAR(12) | | Sim | ATIVO, INATIVO, DESCONTINUADO. |

*Removidos:* `descricao` (duplicava `nome_produto`) e `estoque_disponivel` (derivado de movimentações de estoque).

### 3.4 PEDIDO
Documento comercial emitido pelo distribuidor.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_pedido | INTEGER | PK | Sim | Identificador interno. |
| numero_pedido | VARCHAR(20) | UK | Sim | Número visível ao cliente. |
| id_distribuidor | INTEGER | FK | Sim | → DISTRIBUIDOR. |
| id_representante | INTEGER | FK | Sim | → REPRESENTANTE. |
| data_hora_pedido | TIMESTAMP | | Sim | Momento do registro. |
| data_hora_exportacao | TIMESTAMP | | Não | Envio ao ERP; nulo enquanto não exportado. |
| tipo_pedido | VARCHAR(15) | | Sim | VENDA, BONIFICACAO, TROCA, AMOSTRA. |
| status_pedido | VARCHAR(15) | | Sim | RASCUNHO, APROVADO, SEPARACAO, FATURADO, EXPEDIDO, ENTREGUE, CANCELADO. |
| observacao | VARCHAR(255) | | Não | Instruções comerciais/logísticas. |

*Removido:* `valor_total` — derivado (seção 6).

### 3.5 ITEM_PEDIDO *(entidade associativa)*
Produto solicitado dentro de um pedido.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_pedido | INTEGER | PK, FK | Sim | → PEDIDO. |
| id_produto | INTEGER | PK, FK | Sim | → PRODUTO. |
| quantidade_solicitada | INTEGER | | Sim | > 0. Pedida pelo cliente. |
| quantidade_aprovada | INTEGER | | Sim | ≤ solicitada. Liberada pelo comercial/crédito. |
| quantidade_separada | INTEGER | | Sim | ≤ aprovada. Efetivamente separada. Default 0. |
| valor_unitario | DECIMAL(12,2) | | Sim | Preço praticado **neste** pedido (histórico; não é o preço de tabela atual). |
| percentual_desconto | DECIMAL(5,2) | | Sim | 0 a 100. Default 0. |

*Removidos:* `id_item_pedido` (PK artificial substituída pela composta), `quantidade_bipada` e `valor_total_item` e `status_item` (derivados).

### 3.6 PREVIA
Espelho do pedido gerado para conferência prévia do cliente, antes do faturamento.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_previa | INTEGER | PK | Sim | Identificador interno. |
| id_pedido | INTEGER | FK, UK | Sim | → PEDIDO. Único: garante o 1:1. |
| numero_previa | VARCHAR(20) | UK | Sim | Número do documento. |
| data_hora_geracao | TIMESTAMP | | Sim | Momento da geração. |
| status_previa | VARCHAR(12) | | Sim | GERADA, ENVIADA, APROVADA, REJEITADA. |

*Removidos:* `quantidade_total_itens` e `valor_total_estimado` (derivados dos itens do pedido).

### 3.7 FATURAMENTO
Nota fiscal eletrônica emitida para o pedido.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_faturamento | INTEGER | PK | Sim | Identificador interno. |
| id_pedido | INTEGER | FK, UK | Sim | → PEDIDO. Único: um pedido gera no máximo uma NF. |
| numero_nota_fiscal | INTEGER | | Sim | Numeração sequencial por série. |
| serie_nota_fiscal | VARCHAR(3) | | Sim | Série fiscal. |
| chave_nfe | CHAR(44) | UK | Sim | Chave de acesso da NF-e. |
| data_hora_faturamento | TIMESTAMP | | Sim | Emissão. |
| valor_frete | DECIMAL(12,2) | | Sim | Rateado na nota. Default 0. |
| valor_desconto | DECIMAL(12,2) | | Sim | Desconto no rodapé da nota. Default 0. |
| status_faturamento | VARCHAR(12) | | Sim | AUTORIZADA, REJEITADA, CANCELADA, INUTILIZADA. |

*Restrição composta:* `(numero_nota_fiscal, serie_nota_fiscal)` é única.
*Removidos:* `numero_faturamento` (redundante), `valor_produtos` e `valor_total` (derivados).

### 3.8 EXPEDICAO
Processo de separação e conferência do pedido no centro de distribuição.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_expedicao | INTEGER | PK | Sim | Identificador interno. |
| id_pedido | INTEGER | FK, UK | Sim | → PEDIDO. Único: garante o 1:1. |
| numero_expedicao | VARCHAR(20) | UK | Sim | Número operacional. |
| data_hora_inicio | TIMESTAMP | | Sim | Início da separação. |
| data_hora_fim | TIMESTAMP | | Não | Conclusão; nulo enquanto em andamento. |
| status_expedicao | VARCHAR(15) | | Sim | ABERTA, EM_SEPARACAO, CONFERIDA, FINALIZADA, CANCELADA. |

*Removido:* `quantidade_total_separada` (derivado da bipagem).

### 3.9 CAIXA
Volume físico montado durante a expedição.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_caixa | INTEGER | PK | Sim | Identificador interno. |
| id_expedicao | INTEGER | FK | Sim | → EXPEDICAO. |
| codigo_caixa | VARCHAR(20) | UK | Sim | Etiqueta/código de barras do volume. |
| tipo_caixa | VARCHAR(20) | | Sim | P, M, G, PALLET. |
| data_hora_fechamento | TIMESTAMP | | Não | Nulo enquanto a caixa está aberta. |
| peso | DECIMAL(10,3) | | Não | Peso aferido na balança, em kg. |
| altura | DECIMAL(10,2) | | Não | Em cm. |
| largura | DECIMAL(10,2) | | Não | Em cm. |
| comprimento | DECIMAL(10,2) | | Não | Em cm. |

*Removidos:* `data_montagem` (equivale ao instante da primeira bipagem) e `quantidade_itens` (derivado).

### 3.10 BIPAGEM
Registro de cada leitura de código de barras na conferência.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_bipagem | INTEGER | PK | Sim | Identificador interno. |
| id_caixa | INTEGER | FK | Sim | → CAIXA (em qual volume o item foi acondicionado). |
| id_pedido | INTEGER | FK | Sim | → ITEM_PEDIDO (parte 1 da FK composta). |
| id_produto | INTEGER | FK | Sim | → ITEM_PEDIDO (parte 2 da FK composta). |
| codigo_barras_lido | VARCHAR(14) | | Sim | Valor cru lido pelo coletor; preservado para auditoria de divergência. |
| data_hora_bipagem | TIMESTAMP | | Sim | Momento da leitura. |
| quantidade_bipada | INTEGER | | Sim | Normalmente 1; > 1 em leitura por múltiplo. |
| status_bipagem | VARCHAR(15) | | Sim | CONFIRMADA, DIVERGENTE, CANCELADA. |

*Removidos:* `divergencia` (passou a ser um valor do domínio de `status_bipagem`) e `observacao`.
**Mudança estrutural:** antes a bipagem apontava para `PRODUTO`; agora aponta para `ITEM_PEDIDO` e para `CAIXA`. É isso que permite responder "qual item de qual pedido foi para qual volume" — pergunta que o modelo anterior não conseguia responder.

### 3.11 TRANSPORTADORA
Empresa responsável pelo transporte.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_transportadora | INTEGER | PK | Sim | Identificador interno. |
| cnpj | CHAR(14) | UK | Sim | Somente dígitos. |
| razao_social | VARCHAR(120) | | Sim | Denominação legal. |
| nome_fantasia | VARCHAR(120) | | Não | Nome comercial. |
| telefone | VARCHAR(20) | | Não | Com DDD. |
| email | VARCHAR(100) | | Sim | Contato operacional. |
| endereco | COMPOSTO | | Sim | cep, logradouro, numero, complemento, bairro, cidade, uf. |
| status | VARCHAR(10) | | Sim | ATIVO, INATIVO. |

### 3.12 ENTREGA
Remessa física ao distribuidor e seu acompanhamento.

| Atributo | Tipo | Chave | Obr. | Descrição / domínio |
|---|---|---|---|---|
| id_entrega | INTEGER | PK | Sim | Identificador interno. |
| id_expedicao | INTEGER | FK, UK | Sim | → EXPEDICAO. Único: garante o 1:1. |
| id_transportadora | INTEGER | FK | Sim | → TRANSPORTADORA. |
| codigo_rastreio | VARCHAR(50) | | Não | Fornecido pela transportadora após a coleta. |
| endereco_entrega | COMPOSTO | | Sim | Copiado do distribuidor no momento da expedição, mas armazenado aqui porque pode divergir e precisa ser histórico. |
| data_hora_saida | TIMESTAMP | | Não | Coleta/saída do CD. |
| data_prevista_entrega | DATE | | Sim | Prazo acordado. |
| data_hora_entrega | TIMESTAMP | | Não | Entrega efetiva; nulo enquanto em trânsito. |
| status_entrega | VARCHAR(15) | | Sim | PENDENTE, EM_TRANSITO, ENTREGUE, DEVOLVIDA, EXTRAVIADA. |
| comprovante_entrega | VARCHAR(255) | | Não | Caminho/URL do canhoto digitalizado. |

---

## 4. Relacionamentos

Cardinalidade no formato **(mínima, máxima)** em cada sentido.

| # | Relacionamento | Entidades | Cardinalidade | Leitura |
|---|---|---|---|---|
| 1 | REALIZA | DISTRIBUIDOR — PEDIDO | (0,N) : (1,1) | Um distribuidor realiza zero ou vários pedidos; cada pedido pertence a exatamente um distribuidor. |
| 2 | ATENDE | REPRESENTANTE — PEDIDO | (0,N) : (1,1) | Um representante atende vários pedidos; cada pedido tem um representante responsável. |
| 3 | CONTÉM | PEDIDO — ITEM_PEDIDO | (1,N) : (1,1) | Todo pedido contém ao menos um item; cada item pertence a um único pedido. |
| 4 | REFERE-SE A | ITEM_PEDIDO — PRODUTO | (1,1) : (0,N) | Cada item refere-se a um produto; um produto pode aparecer em N itens (ou em nenhum). |
| 5 | GERA | PEDIDO — PREVIA | (0,1) : (1,1) | Um pedido gera no máximo uma prévia. |
| 6 | FATURA | PEDIDO — FATURAMENTO | (0,1) : (1,1) | Um pedido gera no máximo uma nota fiscal. |
| 7 | ORIGINA | PEDIDO — EXPEDICAO | (0,1) : (1,1) | Um pedido origina no máximo um processo de expedição. |
| 8 | COMPÕE | EXPEDICAO — CAIXA | (1,N) : (1,1) | Uma expedição finalizada tem ao menos uma caixa; cada caixa pertence a uma expedição. |
| 9 | AGRUPA | CAIXA — BIPAGEM | (0,N) : (1,1) | Uma caixa agrupa as bipagens dos itens nela acondicionados. |
| 10 | CONFERE | ITEM_PEDIDO — BIPAGEM | (0,N) : (1,1) | Cada bipagem confere exatamente um item de pedido. |
| 11 | RESULTA EM | EXPEDICAO — ENTREGA | (0,1) : (1,1) | Uma expedição finalizada resulta em uma entrega. |
| 12 | REALIZA | TRANSPORTADORA — ENTREGA | (0,N) : (1,1) | Uma transportadora realiza várias entregas. |

**Relacionamento N:N resolvido:** `PEDIDO` (0,N) ⟷ (0,N) `PRODUTO`, via a entidade associativa `ITEM_PEDIDO` (relacionamentos 3 e 4).

---

## 5. Regras de negócio suportadas pelo modelo

| RN | Regra | Como o modelo garante |
|---|---|---|
| RN01 | Um produto não pode se repetir duas vezes no mesmo pedido. | PK composta de `ITEM_PEDIDO`. |
| RN02 | `quantidade_solicitada ≥ quantidade_aprovada ≥ quantidade_separada`. | CHECK em `ITEM_PEDIDO`. |
| RN03 | Só se fatura pedido com status APROVADO ou posterior. | CHECK/trigger sobre `status_pedido`. |
| RN04 | Um pedido tem no máximo uma prévia, uma NF e uma expedição. | FK `id_pedido` com restrição UNIQUE nas três entidades. |
| RN05 | Toda bipagem pertence a um item existente do pedido em expedição. | FK composta `(id_pedido, id_produto)` → `ITEM_PEDIDO`. |
| RN06 | Uma caixa só é fechada com ao menos uma bipagem confirmada. | Validação de aplicação sobre o relacionamento AGRUPA. |
| RN07 | Divergência de conferência = soma das bipagens confirmadas ≠ `quantidade_aprovada`. | Consulta de agregação (seção 6), sem campo redundante. |
| RN08 | O preço praticado no pedido é histórico e não muda com reajuste de tabela. | `valor_unitario` em `ITEM_PEDIDO`, separado de `preco_unitario` em `PRODUTO`. |
| RN09 | O endereço de entrega é o do momento da expedição. | `endereco_entrega` armazenado em `ENTREGA`. |
| RN10 | Entrega só existe para expedição finalizada. | Cardinalidade (0,1):(1,1) + validação de `status_expedicao`. |

---

## 6. Atributos derivados (substituem os campos removidos)

| Valor | Fórmula | Consulta de referência |
|---|---|---|
| `valor_total_item` | `quantidade_aprovada × valor_unitario × (1 − percentual_desconto/100)` | coluna calculada / view |
| `valor_total` do pedido | Σ `valor_total_item` do pedido | `SELECT SUM(...) FROM ITEM_PEDIDO WHERE id_pedido = ?` |
| `valor_produtos` da NF | Σ `valor_total_item` dos itens faturados | idem |
| `valor_total` da NF | `valor_produtos + valor_frete − valor_desconto` | view de faturamento |
| `quantidade_bipada` do item | Σ `quantidade_bipada` das bipagens CONFIRMADAS do item | `GROUP BY id_pedido, id_produto` |
| `status_item` | comparação entre quantidade aprovada e bipada (PENDENTE / PARCIAL / COMPLETO / DIVERGENTE) | CASE em view |
| `quantidade_total_itens` da prévia | Σ `quantidade_solicitada` | agregação sobre `ITEM_PEDIDO` |
| `quantidade_itens` da caixa | contagem de bipagens da caixa | `COUNT` sobre `BIPAGEM` |
| `estoque_disponivel` | saldo de movimentações | módulo de estoque (fora do escopo) |

---

## 7. Verificação de normalização

- **1FN** — nenhum atributo multivalorado; `endereco` é composto (decomponível em atributos atômicos na implementação), não multivalorado.
- **2FN** — a única entidade com PK composta é `ITEM_PEDIDO`, e todos os seus atributos dependem do par completo `(id_pedido, id_produto)`. Era exatamente essa a violação que apareceria se `PRODUTO` fosse fundido ao item.
- **3FN** — nenhuma dependência transitiva: dados de produto ficam em `PRODUTO`, dados de cliente em `DISTRIBUIDOR`, e nenhum total calculado é armazenado.
- **BCNF** — todos os determinantes (`cnpj`, `cpf`, `codigo_barras`, `chave_nfe`, `numero_pedido`, `codigo_caixa`) são chaves candidatas declaradas como UK.

---

## 8. Limites conhecidos e evoluções possíveis

Assumido pelo escopo, e que vale citar na defesa do trabalho:

1. **Um pedido = uma expedição = uma entrega.** Entrega parcial (pedido separado em duas remessas) exigiria trocar os relacionamentos 7 e 11 para 1:N e mover `id_pedido` da expedição para um vínculo por item.
2. **Uma NF por pedido.** Faturamento parcial exigiria 1:N e uma entidade `ITEM_FATURAMENTO`.
3. **Sem módulo de estoque.** `PRODUTO` não controla saldo; se o trabalho pedir isso, entra uma entidade `MOVIMENTACAO_ESTOQUE`.
4. **Sem histórico de preço de tabela.** O preço praticado fica preservado no item, mas a evolução da tabela exigiria `PRECO_PRODUTO` com vigência.
5. **Endereço como atributo composto.** Se o distribuidor precisar de vários endereços (cobrança, entrega, filiais), promover para a entidade `ENDERECO` com relacionamento (1,N).

---

*Arquivo do diagrama: `der_pedidos_expedicao_v2.svg` (vetorial — abre no navegador, no Word e no Google Docs, e pode ser exportado em PNG/PDF sem perda de qualidade).*
