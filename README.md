# Modelagem de Banco de Dados — Catálogos Hiroshima
### Entrega 2 — Relatório Técnico Final: modelo lógico, implementação SQL e apresentação

---

## Integrantes

| Nome completo do aluno | RGM | Usuário do GitHub |
| :---- | :---- | :---- |
| Eduarda Carneiro dos Santos | 47084979 | Eduardacsantos |
| Henrique Cordeiro Gonçalves | 47014351 | henriquegoncalves29 |
| Julia Caroline Hütter de Lemos | 46995986 | JuliaHutter |

**Software do DER e do modelo lógico:** brModelo (versão web).

---

## Artefatos do repositório

| Artefato | Arquivo |
| :---- | :---- |
| DER conceitual revisado (v14) | [diagramas/der_conceitual_v14.jpg](diagramas/der_conceitual_v14.jpg) |
| Fluxograma do processo | [diagramas/fluxograma_processo.jpg](diagramas/fluxograma_processo.jpg) |
| Modelo lógico (brModelo) | [diagramas/modelo_logico.jpg](diagramas/modelo_logico.jpg) |
| Dicionário de dados físico (HTML, E2) | [docs/dicionario_dados_fisico.html](docs/dicionario_dados_fisico.html) |
| Script SQL completo | [docs/script_definitivo.sql](docs/script_definitivo.sql) |
| Massa de dados fictícia | [docs/massa_de_dados.sql](docs/massa_de_dados.sql) |
| Levantamento da entrevista | [levantamento/levantamento.md](levantamento/levantamento.md) |
| Evidência da organização (depósito) | [evidencias/deposito_hiroshima.jpg](evidencias/deposito_hiroshima.jpg) |

&nbsp;

---

## 1. Relatório Técnico Final

### 1.1 Revisão do Modelo Conceitual

#### Caracterização da organização

- **Nome e natureza:** Catálogos Hiroshima, loja de moda feminina em São Paulo. A moda feminina é o carro-chefe. A empresa também vende utensílios e objetos para casa.
- **Contexto e porte** (informado pela Kamilly Anselmo da Silva, Analista Comercial, na entrevista de 28/10/2026):
  - Aproximadamente 250 funcionários.
  - Aproximadamente 3.000 clientes, que são distribuidores.
  - Mais de 500 produtos cadastrados.
  - Média de 900 vendas por mês.
  - Aproximadamente 30 representantes comerciais.
  - Aproximadamente 15 fornecedores.
- **Problemas declarados** (confirmados na entrevista):
  - **P1:** as informações ficam divididas entre os setores. Para acompanhar um pedido, é preciso solicitar dados a cada área.
  - **P2:** há perda de dados entre as etapas do ciclo do pedido.
  - **P3:** não existe uma visão integrada do ciclo, do registro do pedido até a expedição.
- **Justificativa da escolha:** escolhemos a Catálogos Hiroshima porque é uma empresa real, com endereço, telefone e uma responsável que aceitou colaborar com o trabalho. O tamanho também importou: a empresa tem cerca de 250 funcionários, 3.000 clientes e 900 vendas por mês, o que gera dados suficientes para a modelagem sem tornar o projeto inviável para a disciplina. Além disso, o caminho de um pedido passa por vários setores (vendas, faturamento, fiscal, expedição e entrega), e cada um depende das informações do outro. Esse é o tipo de situação que um banco de dados bem modelado consegue organizar.
- **Escopo do sistema:** o banco reúne os dados de pedidos, faturamento, notas fiscais de saída, expedição, transportadoras, entregas, fornecedores e contas a pagar. O que fica fora está descrito abaixo.

**Escopo: o que fica fora e por quê**

1. **Recebimento dos clientes (boleto, PIX e cartão 1x).** A cobrança é feita fora do sistema. O modelo registra o pedido, a condição de pagamento e o faturamento, mas não o recebimento nem os pagamentos parciais dos clientes. Os pagamentos parciais ficam representados pelas notas: um pedido pode gerar mais de uma nota.
2. **Quantidade em estoque.** O controle de quantidade é feito em sistema externo. O modelo registra a origem de cada produto (compras, pela conta a pagar) e as datas da última entrada e da última saída.
3. **Prévia, bipagem e caixa.** Essas etapas da expedição são feitas em sistema externo. O modelo começa na expedição.
4. **Funcionários e folha de pagamento.** A organização tem cerca de 250 funcionários, informados como contexto. O RH não faz parte do sistema modelado.
5. **Pedido de compra a fornecedor.** A compra é registrada pela conta a pagar e pela origem dos produtos.
6. **Acompanhamento da entrega ligado ao pedido.** A entrega é registrada com o código de rastreio da transportadora. O modelo liga a entrega à transportadora, mas não ao pedido nem à expedição, porque o acompanhamento não está entre os problemas declarados.
7. **Devolução, troca e comissão de representantes.** Não foram tratadas na entrevista e não estão entre os problemas declarados. Ficam fora desta versão. O cancelamento de pedido e de nota está no modelo (RB07).
8. **Pedido mínimo e controle de crédito.** Não foram informados como regra da organização. Ficam fora desta versão.

#### Evidências da organização

- **Perfil no Google:** https://share.google/NCDADNDkuTG5OACzG
- **Endereço:** R. Ulisses Cruz, 761 – Tatuapé, São Paulo – SP, CEP 03077-000.
- **Telefone da organização:** (11) 2942-4000.
- **Site:** https://hiroshima.com.br/
- **Foto do depósito:** [evidencias/deposito_hiroshima.jpg](evidencias/deposito_hiroshima.jpg).

#### Responsável pela organização

- **Colaboradora:** Kamilly Anselmo da Silva, Analista Comercial.
- **E-mail corporativo:** kasilva@hiroshima.com.br
- **Telefone:** (11) 2942-4000 (institucional). Os contatos pessoais não são publicados no repositório.

#### Relato da entrevista

- **Quem:** entrevistada Kamilly Anselmo da Silva, Analista Comercial. Entrevistador: Henrique Cordeiro Gonçalves.
- **Quando e onde:** 28/10/2026, por videochamada (Google Meet).
- **Entrevista presencial: não foi possível realizá-la.** A entrevista não foi feita no ambiente da organização, não houve visita presencial ao local e, por isso, não há foto da entrevista no local.
- **Autorização:** a entrevistada autorizou por escrito o uso do seu nome e das informações no trabalho ([evidencias/autorizacao_kamilly.jpg](evidencias/autorizacao_kamilly.jpg)).
- **Ordem em relação à E1:** a entrevista formal foi realizada **depois da entrega da Entrega 1 (24/10/2026)**. O grupo dispõe de comprovação escrita e de print da reunião, guardados fora do repositório.
- **Observação:** não houve observação presencial da rotina. A observação de material está registrada no [levantamento](levantamento/levantamento.md), separada do que foi dito pela entrevistada.
- **O que foi levantado:** processos comerciais, financeiros e logísticos; porte; setores envolvidos; problemas P1 a P3; compras e contas a pagar. O levantamento completo está em [levantamento/levantamento.md](levantamento/levantamento.md).

#### Processos de negócio

1. **Cadastros:** clientes (distribuidores), representantes comerciais, produtos, fornecedores e transportadoras.
2. **Registro do pedido:** cliente, representante (quando houver), produtos e quantidades, preço praticado, desconto, tipo e condição de pagamento.
3. **Liberação do pedido:** o pedido é liberado para as etapas seguintes. A data da liberação é registrada.
4. **Emissão de nota fiscal de saída:** cada pedido pode gerar uma ou mais notas. A nota registra série, número, chave de acesso, protocolo, valor e status.
5. **Faturamento:** agrupa uma ou mais notas fiscais de saída.
6. **Expedição:** cada nota fiscal tem, no máximo, uma expedição. A expedição tem uma transportadora, datas de início, fim e liberação, e status.
7. **Transporte e entrega:** a transportadora realiza a entrega e registra o código de rastreio, a data de saída, a previsão, a data de entrega, as ocorrências e o comprovante.
8. **Compras e contas a pagar:** o fornecedor vende produtos à empresa. A compra gera contas a pagar, com vencimento, pagamento e forma (boleto ou PIX).
9. **Cancelamentos:** pedidos e notas podem ser cancelados, com motivo e data registrados.

O fluxo completo, com os setores, as decisões e os caminhos de erro, está em [diagramas/fluxograma_processo.jpg](diagramas/fluxograma_processo.jpg). As etapas em sistema externo (prévia, bipagem e caixa) aparecem tracejadas, como atividades a confirmar.

#### Requisitos

**Requisitos funcionais**

- **RF01:** registrar o pedido com cliente, representante (quando houver), data e hora do pedido, tipo, condição de pagamento e observação.
- **RF02:** registrar os itens do pedido, com produto, quantidade, preço praticado e desconto.
- **RF03:** cadastrar clientes, com razão social, nome fantasia, CNPJ, endereço, e-mail, telefone e status.
- **RF04:** cadastrar representantes comerciais, com nome, e-mail, telefone, status e data de cadastro, e registrar o período de atendimento de cada pedido (data de início e fim).
- **RF05:** cadastrar produtos, com nome, SKU, código de barras, NCM, categoria, unidade de medida, preço unitário, status e datas da última entrada e da última saída.
- **RF06:** registrar o faturamento, com data, hora e status, agrupando uma ou mais notas fiscais.
- **RF07:** registrar as notas fiscais de saída, vinculadas a um pedido, com série, número, chave de acesso, protocolo, valor total, data de emissão, status e dados de cancelamento.
- **RF08:** registrar a expedição de cada nota fiscal, com a transportadora, datas de liberação, início e fim, status e observação.
- **RF09:** cadastrar transportadoras, com razão social, nome fantasia, CNPJ, RNTRC, modal e contato.
- **RF10:** registrar a entrega vinculada à transportadora, com código de rastreio, endereço de entrega, datas de saída, previsão e entrega, status, ocorrências e comprovante.
- **RF11:** cadastrar fornecedores, com razão social, nome fantasia, CNPJ, inscrição estadual, endereço, contato e status.
- **RF12:** registrar as contas a pagar de cada fornecedor, com descrição, data de emissão, vencimento, valor, pagamento, forma e status, e registrar a origem de compra dos produtos, com a quantidade comprada e o valor unitário da compra.
- **RF13:** permitir consultas que cruzem pedido, nota, faturamento, expedição e entrega, para responder aos problemas P1 a P3.

**Requisitos não funcionais**

- **RNF01 — Integridade:** o banco deve impedir dados inconsistentes, com chaves primárias e estrangeiras, campos obrigatórios e valores únicos onde a regra exige.
- **RNF02 — Centralização:** os dados dos setores ficam em um único banco, para evitar que a informação fique dividida (P1).
- **RNF03 — Proteção de dados pessoais:** os dados de pessoas (representantes e contatos) são usados apenas para cadastro e atendimento, conforme a LGPD.
- **RNF04 — Rastreabilidade:** cada etapa do pedido registra data e hora, para que o ciclo possa ser acompanhado de ponta a ponta (P2 e P3).

**Controle de acesso por setor:** a permissão de cada setor é uma restrição da aplicação (RB01 a RB04). O modelo conceitual não tem entidades de usuário ou de setor, por isso essa regra não é representada no DER.

#### Regras de negócio

**Operacionais e de responsabilidade**

- **RB01 — Consulta entre setores:** os funcionários podem consultar informações de outros setores.
- **RB02 — Registro de pedidos:** somente o setor Comercial/Vendas registra pedidos. (Restrição de aplicação.)
- **RB03 — Acesso da transportadora:** a transportadora registra e atualiza somente as informações de transporte e entrega dos pedidos sob sua responsabilidade. (Restrição de aplicação.)
- **RB04 — Isolamento entre transportadoras:** cada transportadora consulta e atualiza somente as entregas vinculadas a ela. (Restrição de aplicação.)
- **RB05 — Registro fiscal:** o setor Fiscal registra e emite as notas fiscais.
- **RB06 — Registro financeiro:** o setor Faturamento/Financeiro registra os valores faturados, os valores dos pedidos e as condições de pagamento.
- **RB07 — Cancelamento:** somente o setor Fiscal cancela notas fiscais. Pedidos cancelados são mantidos no histórico, com motivo e data.

**Cardinalidades** (verificadas pelas consultas A01 a A04)

- **RB08:** todo pedido tem pelo menos um produto. (CONTEM)
- **RB09:** todo produto tem pelo menos uma compra registrada. (ORIGINA)
- **RB10:** toda conta a pagar tem pelo menos um produto. (ORIGINA)
- **RB11:** todo faturamento tem pelo menos uma nota fiscal. (GERA)
- **RB12:** cada expedição tem exatamente uma nota fiscal, e cada nota tem no máximo uma expedição. (DESPACHA)
- **RB13:** toda conta a pagar tem um fornecedor. (PAGA)
- **RB14:** toda entrega tem uma transportadora, e cada transportadora pode ter várias entregas. (REALIZA)

**Restrições legais e organizacionais**

- **RB15 — Dados pessoais:** os dados pessoais de representantes são usados para cadastro e atendimento, com acesso restrito (LGPD).
- **RB16 — Valores:** quantidades, preços e valores não podem ser negativos.

#### Diagrama conceitual revisado (Caso A)

O DER conceitual foi revisado a partir da correção da Entrega 1. O software usado foi o **brModelo**. A imagem está em [diagramas/der_conceitual_v14.jpg](diagramas/der_conceitual_v14.jpg). As chaves estrangeiras não aparecem no DER, porque são decisão do modelo lógico.

| Apontamento da correção da E1 | O que mudou no trabalho | Por quê |
| :---- | :---- | :---- |
| CONTEM sem quantidade nem preço | CONTEM tem `quantidade`, `preco_praticado` e `desconto`. | Sem eles, não é possível saber quanto de cada produto foi vendido e por qual preço. |
| IDENTIFICA obrigava uma expedição por produto | Removida. A expedição se liga à nota fiscal (DESPACHA). | O processo separa todos os itens do pedido, e não um produto por vez. |
| COBRE criava um segundo caminho entre pedido e entrega | Removida. A entrega se liga só à transportadora. | Havia dois caminhos paralelos para a mesma informação. |
| Dados da transportadora repetidos em ENTREGA | TRANSPORTADORA é entidade própria, ligada a ENTREGA por REALIZA. | Evita repetir CNPJ e razão social em cada entrega. |
| Caixa e volume ausentes | Feitos em sistema externo. | Justificado no escopo (item 3). |
| Cardinalidades mínimas e máximas | Presentes nos dois lados de todos os relacionamentos. | Exigência da notação. |
| Sem chaves estrangeiras no conceitual | Mantido. As FKs aparecem só no lógico. | FK é decisão do modelo lógico. |
| Processos sem compras nem apoio | FORNECEDOR, CONTAS_PAGAR e ORIGINA. | Compras precisam de origem registrada. |
| Atributos derivados (valor do pedido, valor faturado) | Removidos. O valor da nota fiscal permanece. | O valor do pedido é soma dos itens. O valor da nota é registro fiscal. |
| Produto com entrada e saída como atributos multivalorados | Substituídos por `data_hora_ultima_entrada` e `data_hora_ultima_saida`. | Atende à 1FN. |
| Regras de negócio que eram apenas cardinalidades | Viraram RB08 a RB14. Unicidade ficou no dicionário. | Regras de negócio são restrições da organização. |
| Dicionário sem os itens obrigatórios | Dicionário de dados em um único arquivo HTML, com atributo, tipo, obrigatoriedade, unicidade, padrão, regra e significado. | Formato exigido pela disciplina. |

**Itens justificados e não corrigidos:** bipagem, prévia e caixa (fora do sistema); recebimento de clientes e estoque em quantidade (fora do sistema); devolução, troca e comissão (fora do escopo, item 7 do escopo).

### 1.2 Conversão do Modelo Conceitual para o Modelo Lógico

- **Entidades → tabelas:** cada entidade do DER virou uma tabela com o mesmo nome em maiúsculas, com colunas em `snake_case`. São 11 tabelas: CLIENTE, REPRESENTANTE_COMERCIAL, PEDIDO, PRODUTO, FATURAMENTO, NOTA_FISCAL, EXPEDICAO, TRANSPORTADORA, ENTREGA, FORNECEDOR e CONTAS_PAGAR.
- **Atributos → colunas:** cada atributo virou uma coluna com tipo físico definido. Valores monetários usam `DECIMAL(10,2)`, para evitar erros de arredondamento de `FLOAT`. Códigos como CNPJ, CEP e chave de acesso são texto (`CHAR`), para não perder zeros à esquerda. Os detalhes estão no dicionário de dados ([docs/dicionario_dados_fisico.html](docs/dicionario_dados_fisico.html)).
- **Relacionamentos → chaves:**
  - **ATENDE** (PEDIDO–REPRESENTANTE, 0,1 : 0,n): chave estrangeira `id_representante` em PEDIDO, opcional.
  - **REALIZA** (CLIENTE–PEDIDO, 1,1 : 0,n): chave estrangeira `id_cliente` em PEDIDO, obrigatória.
  - **EMITE** (PEDIDO–NOTA_FISCAL, 1,1 : 0,n): chave estrangeira `id_pedido` em NOTA_FISCAL, obrigatória.
  - **GERA** (FATURAMENTO–NOTA_FISCAL, 0,1 : 1,n): chave estrangeira `id_faturamento` em NOTA_FISCAL, opcional. A nota pertence a no máximo um faturamento, e o faturamento tem pelo menos uma nota (RB11).
  - **DESPACHA** (NOTA_FISCAL–EXPEDICAO, 1,1 : 0,1): chave estrangeira `id_nota_fiscal` em EXPEDICAO, obrigatória e única. Assim, cada expedição tem uma nota, e cada nota tem no máximo uma expedição (RB12).
  - **TRANSPORTA** (EXPEDICAO–TRANSPORTADORA): chave estrangeira `id_transportadora` em EXPEDICAO, obrigatória.
  - **REALIZA** (TRANSPORTADORA–ENTREGA): chave estrangeira `id_transportadora` em ENTREGA, obrigatória (RB14).
  - **PAGA** (FORNECEDOR–CONTAS_PAGAR): chave estrangeira `id_fornecedor` em CONTAS_PAGAR, obrigatória (RB13).
  - **CONTEM** (PEDIDO–PRODUTO, N:N): tabela associativa CONTEM, com chave primária composta (`id_pedido`, `id_produto`) e os atributos `quantidade`, `preco_praticado` e `desconto`.
  - **ORIGINA** (CONTAS_PAGAR–PRODUTO, N:N): tabela associativa ORIGINA, com chave primária composta (`id_produto`, `id_conta_pagar`) e os atributos `quantidade_comprada` e `valor_unitario_compra`.
- **Cardinalidades:** 1:N são resolvidas com chave estrangeira no lado N. N:N são resolvidas com tabela associativa. A relação 1:1 (DESPACHA) é resolvida com chave estrangeira no lado da expedição, com restrição `UNIQUE`.
- **Mínimos não representados no brModelo:** o brModelo lógico só aceita os rótulos `(0,n)` e `(1,1)`. Por isso, os mínimos `(1,n)` e `(0,1)` do conceitual são garantidos por regra de negócio (RB08 a RB11) e verificados pelas consultas A01 a A04 do script. Os códigos RB08 a RB11 estão listados na tabela de regras do dicionário de dados.
- **Generalização/especialização:** o modelo não tem. Não se aplica.

### 1.3 Definição de Chaves Primárias e Estrangeiras

| Tabela | Chave primária | Chaves estrangeiras |
| :---- | :---- | :---- |
| CLIENTE | `id_cliente` | — |
| REPRESENTANTE_COMERCIAL | `id_representante` | — |
| PEDIDO | `id_pedido` | `id_cliente` (obrigatória); `id_representante` (opcional) |
| PRODUTO | `id_produto` | — |
| FATURAMENTO | `id_faturamento` | — |
| NOTA_FISCAL | `id_nota_fiscal` | `id_pedido` (obrigatória); `id_faturamento` (opcional) |
| EXPEDICAO | `id_expedicao` | `id_nota_fiscal` (obrigatória e única); `id_transportadora` (obrigatória) |
| TRANSPORTADORA | `id_transportadora` | — |
| ENTREGA | `id_entrega` | `id_transportadora` (obrigatória) |
| FORNECEDOR | `id_fornecedor` | — |
| CONTAS_PAGAR | `id_conta_pagar` | `id_fornecedor` (obrigatória) |
| CONTEM | (`id_pedido`, `id_produto`) | `id_pedido`; `id_produto` |
| ORIGINA | (`id_produto`, `id_conta_pagar`) | `id_produto`; `id_conta_pagar` |

Chaves candidatas com `UNIQUE`: `CNPJ` em CLIENTE, TRANSPORTADORA e FORNECEDOR; `sku` em PRODUTO; `chave_nfe_saida` em NOTA_FISCAL; `codigo_rastreio` em ENTREGA; `id_nota_fiscal` em EXPEDICAO.

### 1.4 Processo de Normalização (1FN, 2FN e 3FN)

**1FN — eliminação de grupos repetitivos.** Os atributos multivalorados do primeiro desenho (produtos de entrada e de saída, guardados como lista em PRODUTO) foram substituídos por dois campos de data: `data_hora_ultima_entrada` e `data_hora_ultima_saida`. Todas as colunas guardam um único valor atômico. Os endereços estão em colunas separadas (logradouro, número, bairro, cidade, UF e CEP).

**2FN — eliminação de dependências parciais.** Nas tabelas associativas, cada atributo depende da chave composta inteira:

- `quantidade`, `preco_praticado` e `desconto` dependem de (`id_pedido`, `id_produto`). Preço e desconto mudam de um pedido para outro, por isso não podem ficar em PRODUTO.
- `quantidade_comprada` e `valor_unitario_compra` dependem de (`id_produto`, `id_conta_pagar`), porque o preço de compra depende da compra, e não só do produto.

**3FN — eliminação de dependências transitivas.** Foram analisadas quatro dependências transitivas. Três delas foram mantidas de forma deliberada, com justificativa:

1. **CEP → cidade, UF, bairro e logradouro** (em CLIENTE, FORNECEDOR e ENTREGA). A dependência existe. A decisão foi **manter** esses campos em cada tabela, porque o endereço é registrado como informado pelo cliente, pelo fornecedor ou para a entrega, e pode ser diferente em cada caso (por exemplo, o endereço de entrega pode não ser o do cliente). Criar uma tabela de CEP exigiria uma base oficial dos Correios, que não faz parte do escopo.
2. **`chave_nfe_saida` → `serie_nfe_saida` e `numero_nfe_saida`.** A chave da NF-e contém série e número, e a dependência existe. A decisão foi **manter as duas colunas**, para permitir consulta direta por número e série, que é como o setor Fiscal localiza a nota. A consistência entre a chave e essas colunas é uma verificação de aplicação, e não está implementada no banco.
3. **`id_pedido` → `id_representante` → `data_hora_inicio` / `data_hora_fim`.** Como cada pedido tem no máximo um representante, o período de atendimento depende do pedido. A decisão foi **manter os dois atributos em PEDIDO**. Criar uma tabela separada para um único representante por pedido geraria uma tabela 1:1, sem ganho.

A quarta dependência, `chave_nfe_entrada` → fornecedor, é atendida pela chave estrangeira `id_fornecedor` em CONTAS_PAGAR, que já referencia o fornecedor diretamente.

**Justificativa do processo:** a 1FN era necessária porque o desenho inicial tinha um atributo com vários valores. A 2FN era necessária porque as tabelas associativas têm chave composta e atributos que não dependem da chave inteira. A 3FN foi aplicada com exceções documentadas, porque as dependências transitivas restantes são de dados informados por terceiros (endereços e chaves de nota), e a separação em tabelas adicionais não traria ganho para as consultas do projeto.

### 1.5 Justificativas Técnicas das Decisões

**Chaves primárias.** As chaves das entidades são identificadores inteiros com `AUTO_INCREMENT`, porque CNPJ, SKU e chave de NF-e podem mudar ou ser reutilizados. Esses campos ficam como chave candidata, com `UNIQUE` (RB05 e RNF01). As tabelas associativas CONTEM e ORIGINA usam chave composta, porque a combinação dos dois lados identifica cada relação.

**Chaves estrangeiras.** Cada chave estrangeira implementa um relacionamento do DER:

- `id_cliente` em PEDIDO é obrigatória, porque todo pedido pertence a um cliente (cardinalidade (1,1) do lado do pedido).
- `id_representante` em PEDIDO é opcional, porque nem todo pedido tem representante. Quando o campo está nulo, o pedido não tem representante.
- `id_nota_fiscal` em EXPEDICAO é obrigatória e única, porque implementa DESPACHA (RB12): cada expedição tem uma nota, e cada nota tem no máximo uma expedição.
- `id_fornecedor` em CONTAS_PAGAR é obrigatória (RB13).
- `id_transportadora` em ENTREGA é obrigatória (RB14).

**Restrições aplicadas.** As restrições estão no script SQL e no dicionário de dados:

- **Obrigatoriedade (`NOT NULL`):** campos que a regra de negócio exige, como data e hora do pedido, status, CNPJ e chave da NF-e.
- **Unicidade (`UNIQUE`):** CNPJ de clientes, transportadoras e fornecedores; SKU de produto; chave de acesso da NF-e; código de rastreio da entrega (RB05).
- **Valores permitidos (`CHECK`):** valores e quantidades não negativos (RB16); quantidade positiva; data de término não anterior à data de início; data de vencimento não anterior à emissão.
- **Valor padrão (`DEFAULT`):** data de cadastro do representante, data e hora do pedido, desconto zero e valor pago zero.

**Decisões arquiteturais.**

- **MySQL 8.0** como SGBD, por ser o disponível no laboratório e por suportar `CHECK`, chaves estrangeiras e `WITH RECURSIVE` para gerar a massa de dados.
- **Valores monetários em `DECIMAL(10,2)`**, e não em `FLOAT`, para evitar erro de arredondamento.
- **Ações de exclusão em `RESTRICT`** (padrão do MySQL). Um cliente com pedidos, por exemplo, não pode ser excluído. O cancelamento é registrado por status (RB07), e não por exclusão, para manter o histórico.
- **Valor do pedido calculado, não armazenado.** O valor do pedido é a soma dos itens. O valor da nota fiscal é armazenado, porque é o valor fiscal emitido e não pode mudar se o preço mudar depois.
- **Alternativas consideradas:** transportadora como entidade (escolhida, para não repetir dados); item do pedido como relacionamento N:N (escolhido) ou como entidade ITEM_PEDIDO (equivalente no lógico, mas com uma entidade sem informação nova); expedição por nota (escolhida) em vez de por pedido ou por produto; compra como origem do produto (escolhida) em vez de entidade COMPRA, que ficaria sem informação além da conta a pagar.

### 1.6 Proposta de Arquitetura Analítica para BI e IA

#### Indicadores (KPIs)

Regra adotada: um KPI só entra na lista se as tabelas do modelo tiverem os dados para calculá-lo e houver uma consulta no script que o calcule.

**Metas:** a organização não informou metas. Os campos estão marcados como "a definir com a organização", e nenhum valor foi inventado.

| Código | KPI | Fórmula | Período | Meta | Tabelas | Consulta |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| K01 | Ticket médio por nota | Soma de `valor_total_nfe_saida` ÷ quantidade de notas autorizadas | Mensal, por `data_hora_emissao` | A definir com a organização | NOTA_FISCAL | G04 |
| K02 | Taxa de cancelamento de pedidos | Pedidos cancelados ÷ total de pedidos | Mensal, por `data_hora_pedido` | A definir com a organização | PEDIDO | G05 |
| K03 | Tempo até a expedição | Média de horas entre a liberação do pedido e o início da expedição | Mensal | A definir com a organização | PEDIDO, NOTA_FISCAL, EXPEDICAO | G06 |
| K04 | Prazo médio de entrega | Média de dias entre a saída e a entrega, somente entregas concluídas | Mensal, por transportadora | A definir com a organização | ENTREGA, TRANSPORTADORA | G07 |
| K05 | Percentual de entregas com ocorrência | Entregas com ocorrência ÷ total de entregas | Mensal, por transportadora | A definir com a organização | ENTREGA, TRANSPORTADORA | G08 |
| K06 | Produtos mais vendidos | Soma de `quantidade` por produto, em pedidos não cancelados | Mensal | Não se aplica (ranking) | CONTEM, PRODUTO, PEDIDO | G09 |

**O que cada KPI mede:**

- **K01:** valor médio de cada nota emitida, usando o valor fiscal. Notas canceladas ficam fora.
- **K02:** proporção de pedidos cancelados, que serve para acompanhar a qualidade do registro do pedido.
- **K03:** intervalo entre a liberação e o início da expedição. Mostra gargalos entre o comercial e a expedição.
- **K04:** dias que a transportadora leva da saída até a entrega. Permite comparar transportadoras.
- **K05:** proporção de entregas com problema, por transportadora.
- **K06:** produtos com maior saída, para apoiar a compra (ORIGINA) e a exposição do catálogo.

#### Rastreabilidade: problemas e KPIs

| Problema ou KPI | Tabelas envolvidas | Consulta no script | O que a consulta mostra |
| :---- | :---- | :---- | :---- |
| P1 — informações divididas entre setores | PEDIDO, CLIENTE, NOTA_FISCAL, FATURAMENTO, EXPEDICAO | G01 | Visão única do pedido, com cliente, nota, faturamento e expedição em uma linha. |
| P2 — perda de dados entre etapas | PEDIDO, NOTA_FISCAL, EXPEDICAO | G02 | Pedidos expedidos ou entregues sem nota fiscal ou sem expedição. Na massa de dados, retorna zero linhas. |
| P3 — falta de visão integrada do ciclo | PEDIDO, NOTA_FISCAL, FATURAMENTO, EXPEDICAO | G03 | Quantidade de pedidos em cada status, por mês. |
| K01 — ticket médio | NOTA_FISCAL | G04 | Valor médio das notas autorizadas, por mês. |
| K02 — taxa de cancelamento | PEDIDO | G05 | Pedidos cancelados sobre o total, por mês. |
| K03 — tempo até a expedição | PEDIDO, NOTA_FISCAL, EXPEDICAO | G06 | Horas entre a liberação e o início da expedição, por mês. |
| K04 — prazo de entrega | ENTREGA, TRANSPORTADORA | G07 | Dias médios de entrega, por transportadora. |
| K05 — ocorrências | ENTREGA, TRANSPORTADORA | G08 | Percentual de entregas com ocorrência, por transportadora. |
| K06 — produtos mais vendidos | CONTEM, PRODUTO, PEDIDO | G09 | Quantidade vendida por produto, em ordem decrescente. |

**Consultas de auditoria:** A01 a A04 verificam as regras de cardinalidade (RB08 a RB11). Elas não medem indicadores, mas garantem que os dados usados nos KPIs são consistentes. Na massa de dados, todas retornam zero linhas.

#### Potencial para BI e IA

- **BI:** os KPIs K01 a K06 podem ser apresentados em um painel mensal, com filtro por transportadora (K04 e K05) e por produto (K06). O modelo já tem as chaves e as datas necessárias para esses filtros.
- **IA (aplicações futuras):**
  - Previsão de demanda por produto, a partir do histórico de K06.
  - Alerta de atraso, a partir de K04 e da data prevista de entrega.
  - Análise dos motivos de cancelamento (K02), para identificar padrões.

**Limite:** o modelo não registra recebimento de clientes nem estoque em quantidade. Por isso, indicadores de caixa e de giro de estoque não entram nesta proposta.

---

## 2. Modelo Lógico Relacional

O modelo lógico foi criado no **brModelo**, na notação visual do brModelo. A imagem está em [diagramas/modelo_logico.jpg](diagramas/modelo_logico.jpg).

O modelo apresenta as 13 tabelas (11 entidades e 2 tabelas associativas), com as colunas e os tipos de dados, as chaves primárias e estrangeiras e as cardinalidades já convertidas. As demais restrições (`NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`) estão no [dicionário de dados físico](docs/dicionario_dados_fisico.html) e no [script SQL](docs/script_definitivo.sql).

---

## 3. Script SQL Completo

Arquivo: [docs/script_definitivo.sql](docs/script_definitivo.sql).

**SGBD:** MySQL 8.0. O script foi executado do zero (banco vazio) no MySQL Workbench, sem erros, com 55 instruções.

Ordem do script:

1. `CREATE DATABASE` (com `utf8mb4`).
2. `CREATE TABLE` das 13 tabelas, com tipos de dados.
3. Constraints: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE` e `CHECK`.
4. `INSERT INTO` (carga da massa de dados, [docs/massa_de_dados.sql](docs/massa_de_dados.sql)).
5. `SELECT` com `JOIN`.
6. `UPDATE`.
7. `DELETE`.
8. Consultas gerenciais G01 a G09.
9. Consultas de auditoria A01 a A04.

**Teste de integridade:** o [script SQL](docs/script_definitivo.sql) traz, em comentário, a tentativa de excluir um cliente que tem pedidos (`DELETE FROM CLIENTE WHERE id_cliente = 38`). O erro esperado é o 1451 (`foreign key constraint fails`), que confirma a regra `RESTRICT`.

**Consultas gerenciais:** G01 a G09, descritas na [seção 1.6](#16-proposta-de-arquitetura-analítica-para-bi-e-ia).

**Consultas de auditoria:** A01 (pedido sem produto, RB08), A02 (conta a pagar sem produto, RB10), A03 (produto sem compra, RB09) e A04 (faturamento sem nota, RB11).

---

## 4. Massa de Dados

Arquivo: [docs/massa_de_dados.sql](docs/massa_de_dados.sql). Também incluída no script completo.

**Dados reais não foram usados.** Toda a massa é fictícia, gerada por um script com `WITH RECURSIVE`.

**Volume e justificativa.** Os números informados na entrevista justificam a quantidade de registros:

- Cerca de 3.000 clientes (distribuidores) e 30 representantes.
- Cerca de 500 produtos.
- Cerca de 900 vendas por mês.
- Cerca de 15 fornecedores.

Volumes da massa, no mesmo porte informado pela organização: 3.000 clientes, 30 representantes, 500 produtos, 15 fornecedores, 5 transportadoras, 50 contas a pagar, 900 pedidos (aproximadamente um mês de vendas), 2.250 itens de pedido, 900 notas fiscais, 900 faturamentos, 864 expedições e 864 entregas. As premissas P1 a P8 estão no cabeçalho do arquivo, incluindo a de que 1 em cada 5 pedidos não tem representante.

**Variedade para os testes:**

- Pedidos em três status: entregue, expedido e cancelado. Cerca de 1 pedido em 25 é cancelado.
- Clientes com e sem pedidos: 900 pedidos distribuídos entre 3.000 clientes.
- Pedidos com e sem representante: 1 em cada 5 pedidos não tem representante.
- Entregas com e sem ocorrência (status OCORRENCIA e EM_TRANSITO, além de ENTREGUE).
- Contas a pagar com formas de pagamento diferentes (boleto e PIX).
- Os pedidos estão em um único período de aproximadamente um mês. Por isso, as consultas mensais mostram um único mês.

**Valores de domínio** (status, categorias e formas de pagamento) são premissas do grupo, e não dados informados pela organização.

---

## 5. Repositório GitHub

Estrutura:

- `README.md`: este relatório.
- `docs/`: script SQL, massa de dados e dicionários em HTML.
- `diagramas/`: DER conceitual, modelo lógico e fluxograma.
- `levantamento/`: levantamento da entrevista.
- `evidencias/`: foto da organização.

**Histórico de commits:** o desenvolvimento está registrado em commits de cada integrante, feitos com a própria conta do GitHub. O nome de cada conta corresponde ao nome da tabela de integrantes.

---

## 6. Uso de Inteligência Artificial

A IA foi usada principalmente para análise e revisão do projeto. A produção dos textos, do modelo e dos artefatos foi conduzida pelo grupo, com a conferência de cada sugestão.

### 6.1 Henrique Cordeiro Gonçalves: análise e revisão do projeto (Claude)

- **Ferramenta:** Claude (Claude Code), da Anthropic.
- **Etapas:** análise dos documentos da disciplina, revisão do DER conceitual e do modelo lógico, conferência das cardinalidades, comparação com a correção da Entrega 1, análise do escopo, revisão da memória do projeto.
- **Motivação:** obter uma revisão detalhada e identificar inconsistências antes da entrega.
- **Prompts principais (resumidos; o texto exato está no histórico da conversa):**
  1. Pedido para atuar como revisor do projeto, sem inventar informações e apontando dúvidas quando os documentos não bastarem.
  2. Pedido para ler todos os arquivos da pasta de documentos da disciplina antes de qualquer análise.
  3. Pedido para revisar o DER e o modelo lógico, verificando cardinalidades, chaves e tipos.
  4. Pedido para comparar o trabalho com a correção do professor da Entrega 1, classificando cada apontamento.
- **Respostas recebidas:** análises técnicas organizadas por gravidade, com o local do problema, o impacto e a sugestão de correção.
- **Aproveitado:** apontamentos sobre cardinalidades que não batiam com a convenção da disciplina; atributos derivados armazenados, retirados ou justificados; lista de pendências, que organizou a divisão de tarefas.
- **Rejeitado ou corrigido:** sugestões que contrariavam decisões do grupo (por exemplo, uma entidade de contas a receber, recusada pelo grupo); interpretações de cardinalidade fora da convenção, corrigidas relação por relação; classificações do professor que não batiam com o texto da correção.
- **Reflexão crítica:** a ferramenta errou com frequência na leitura das cardinalidades, e algumas sugestões iam além do que os documentos sustentavam. A análise só foi útil porque cada ponto foi conferido manualmente.

### 6.2 Integrantes do grupo: acompanhamento técnico (ChatGPT e Claude)

Uso relatado pelos próprios integrantes, em conversas separadas das deste projeto.

- **Ferramentas:** ChatGPT, com a skill `tutor-mbd` e o arquivo de instruções `tutor-mbd-instrucoes.md`; e Claude.
- **Etapas:** acompanhamento técnico da Entrega 2, com análise de algumas seções (validação da conversão para o modelo lógico e da identificação de chaves) e apoio na revisão da documentação.
- **Exemplo de resposta recebida com o Claude (trecho do item 1.4, em análise da 3FN):** "A dependência existe. A decisão foi manter esses campos em cada tabela, porque o endereço é registrado como informado pelo cliente, pelo fornecedor ou para a entrega, e pode ser diferente em cada caso."
**Uso 1 (ChatGPT, integrante do grupo)**

- **Prompt utilizado (texto exato):**

  > Você é um Cientista de Dados e Cientista da Computação, revisando um projeto de Modelagem de Banco de Dados para a empresa Catálogos Hiroshima (loja de moda feminina em São Paulo, com utensílios e objetos para casa).
  >
  > Regra principal: não invente informações. Baseie a análise somente nos documentos do projeto e nos dados informados. Se algo não estiver claro, aponte a dúvida em vez de supor.
  >
  > Analise:
  >
  > 1. Os documentos da pasta "Documentos CID": esqueletos das entregas 1 e 2, critérios de avaliação, regras de entrega e materiais de referência. Identifique o que é exigido e o que já foi atendido.
  >
  > 2. O DER conceitual mais recente. Para cada relacionamento, confira a cardinalidade (mínimo e máximo) nas duas pontas, usando a convenção: o rótulo junto de uma entidade indica quantas dessas entidades existem para cada instância da outra. Aponte entidades, atributos e relacionamentos que estejam incoerentes com o processo descrito, com atributos derivados armazenados e com a regra de negócio.
  >
  > 3. O modelo lógico gerado a partir do conceitual. Compare nomes de tabelas e colunas, tipos de dado, chaves primárias e estrangeiras, e cardinalidades. Verifique se as divergências vêm da conversão e se os máximos foram preservados. Registre o que a ferramenta não consegue representar.
  >
  > 4. O escopo do sistema. Verifique o que está dentro e o que está fora, e se cada exclusão tem justificativa. Compare com os problemas declarados pela organização e confirme que cada um tem tratamento no modelo.
  >
  > 5. Os apontamentos de uma correção anterior. Para cada apontamento, verifique se foi atendido, justificado ou ficou pendente, e se a justificativa é consistente com o modelo atual.
  >
  > 6. O que falta para cumprir as exigências da entrega, com a fonte de cada exigência.
  >
  > Formato da resposta:
  > - Comece pelos problemas mais graves, em ordem de gravidade.
  > - Para cada problema, indique o local (tabela, coluna, relacionamento ou seção do documento), o que está errado, por que importa e a correção sugerida.
  > - Separe o que é certeza do que é suposição.
  > - Ao final liste o que depende de informação externa ao projeto.

- **Resposta recebida (resumo):** a IA foi direcionada a produzir uma revisão mais completa e específica, considerando a versão final do DER e o modelo lógico correspondente. A análise contemplou a verificação das cardinalidades, a identificação de diferenças entre os modelos, a avaliação das limitações da conversão, a conferência dos requisitos das entregas e a revisão dos apontamentos feitos pelo professor. Também foi solicitada uma avaliação da relação entre os problemas da organização e o escopo do sistema, além da identificação de lacunas no arquivo de memória do projeto.
- **O que foi aproveitado e o que foi rejeitado:** foram aproveitados a organização da análise por gravidade, com local, consequência e sugestão de correção para cada problema; a comparação entre o modelo conceitual e o lógico; a conferência dos requisitos de cada entrega e a revisão dos apontamentos do professor; e a relação entre os problemas da organização e o escopo. As sugestões de cardinalidade e de correção só entraram no projeto depois de conferidas uma a uma contra a convenção da disciplina e contra os documentos. Afirmações sobre o que o professor pediu foram checadas no esqueleto e na correção da E1. Sugestões que mudariam decisões já tomadas pelo grupo, como a inclusão de entidades fora do escopo, não foram aceitas sem discussão.
- **Reflexão crítica:** a resposta ajudou a organizar a revisão e a apontar pontos para olhar com mais cuidado. Mas uma análise gerada a partir de um prompt não substitui a leitura dos documentos. O prompt pedia para não inventar e para separar certeza de suposição, o que ajuda, mas a ferramenta ainda pode interpretar mal uma cardinalidade ou um apontamento. O que deu segurança foi a conferência manual de cada ponto, e essa conferência é o que o grupo deve manter.

**Uso 2 (ChatGPT, integrante do grupo)**

- **Prompt utilizado (texto exato):**

  > Revise todos os arquivos da pasta "Documentos CID" para entender o projeto por completo. Depois, revise o que já foi produzido para a Catálogos Hiroshima, com uma análise bem profunda.
  >
  > Use como base o DER v14 (versão final) e o modelo lógico gerado a partir dele. Para o DER, confira cada relacionamento, com a cardinalidade mínima e máxima nas duas pontas, usando a convenção da disciplina: o rótulo junto de uma entidade indica quantas dessas entidades existem para cada instância da outra. Para o lógico, compare tabelas, colunas, tipos, chaves primárias e estrangeiras e cardinalidades com o conceitual. Registre o que a ferramenta não consegue representar, como os mínimos (1,n) e (0,1), e verifique se os máximos foram preservados.
  >
  > Verifique se o que foi feito está de acordo com o que o professor pede na Entrega 1 e na Entrega 2, e a correção que ele fez da E1. Para cada apontamento da correção, diga se foi atendido, justificado ou ficou pendente, e se a justificativa é consistente com o modelo atual.
  >
  > Compare o escopo com os problemas declarados pela organização e confirme que cada problema tem tratamento no modelo. Confira se as exclusões do escopo têm justificativa.
  >
  > Revise também o arquivo de memória do projeto e diga o que está faltando nele.
  >
  > Não invente informações. Se algo não estiver claro nos documentos, aponte a dúvida em vez de supor.
  >
  > Formato da resposta:
  > - Comece pelos problemas mais graves, em ordem de gravidade.
  > - Para cada problema, indique o local (tabela, coluna, relacionamento ou seção do documento), o que está errado, por que importa e a correção sugerida.
  > - Separe o que é certeza do que é suposição.
  > - Ao final, liste o que depende de informação que não está nos documentos.

- **Resposta recebida (resumo):**
- **O que foi aproveitado e o que foi rejeitado:**
- **Reflexão crítica:**

**Resposta sem prompt registrado (resumo enviado por outra integrante)**

- **Resposta recebida (resumo):** a IA apresentou uma análise técnica do projeto, organizada por problemas identificados e classificados por gravidade. Para cada problema, indicou o local da possível inconsistência, suas consequências e uma sugestão de correção. Também abordou as diferenças entre o modelo conceitual e o lógico, as possíveis falhas de cardinalidade, a coerência com as regras de negócio, o atendimento aos requisitos das entregas e os pontos que ainda precisavam de atenção.
- **O que foi aproveitado e o que foi rejeitado:** foram aproveitados a organização da análise por gravidade, a comparação entre o modelo conceitual e o lógico, a conferência dos requisitos e dos apontamentos do professor, e a relação entre os problemas da organização e o escopo. As sugestões de cardinalidade e de correção só entraram no projeto depois de conferidas contra a convenção da disciplina e contra os documentos. Afirmações sobre o que o professor pediu foram checadas no esqueleto e na correção da E1. Sugestões que mudariam decisões já tomadas pelo grupo não foram aceitas sem discussão.
- **Reflexão crítica:** a resposta ajudou a organizar a revisão e a apontar pontos para olhar com mais cuidado, mas não substitui a leitura dos documentos. A ferramenta ainda pode interpretar mal uma cardinalidade ou um apontamento. O que deu segurança foi a conferência manual de cada ponto, e essa conferência é o que o grupo deve manter.

### 6.3 Uso de IA na produção do material

Parte do script SQL, a massa de dados fictícia e alguns textos de documentação foram produzidos com apoio do Claude (Claude Code). Os prompts estão no histórico da conversa. A massa de dados foi gerada por script, e os valores de domínio são premissas do grupo. O script SQL foi testado no MySQL antes da entrega, e os textos foram revisados pelo grupo.

