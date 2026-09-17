ENTREGA 1 — MODELO CONCEITUAL (DER)

METADADOS

Nomes dos alunos e RGM:
- Eduarda Carneiro dos Santos - 47084979
- Henrique Cordeiro Gonçalves - 47014351
- Julia Caroline Hütter de Lemos - 46995986


1. CARACTERIZAÇÃO DA ORGANIZAÇÃO

Nome e natureza da organização: Catálogos Hiroshima

Contexto e porte: Médio porte

Problemas e necessidades identificados: Os principais pontos negativos identificados são as grandes quantidades de etapas no processo, a possibilidade de erros e retrabalho nas conferências e a dificuldade de acompanhar o pedido durante todo o seu percurso. A implementação de um banco de dados integrado pode solucionar esses problemas ao centralizar as informações, facilitar validações e permitir o acompanhamento do status de cada pedido

Justificativa da escolha: O banco de dados foi desenvolvido com o objetivo de centralizar e facilitar o fluxo de pedidos da empresa, integrando suas diferentes etapas e permitindo maior controle das informações. Dessa forma, busca-se reduzir erros, retrabalho e perda de dados, além de melhorar a eficiência e o acompanhamento dos pedidos.

Evidências da organização:

Endereço: R. Ulisses Cruz, 761 - Tatuapé, São Paulo - SP, 03077-000

Telefone:(11) 2942-4000

E-mail:Kasilva@hiroshima.com.br

Responsável: Kamilly Anselmo da Silva

Site/Google Maps/Instagram: https://hiroshima.com.br/  
https://maps.app.goo.gl/ZfxGT7DhEfKfqYXX6 
https://www.instagram.com/catalogoshiroshima?stkn=ajBucmUwOXNqc2Zr

Fotos da organização/visita: Imagem em anexo. 


2. PROCESSOS DE NEGÓCIO

Principais processos mapeados:

1. Cadastro e gerenciamento de distribuidores, representantes e produtos.
2. Registro e atendimento de pedidos.
3. Geração e processamento de prévias e faturamentos.
4. Separação e expedição dos pedidos.
5. Transporte, entrega e fechamento das caixas.

Fluxogramas:

Processo 1:
Início → Cadastro/identificação do distribuidor → Registro do pedido → Associação do representante → Inclusão dos produtos → Conferência dos itens → Pedido registrado.

Processo 2:
Pedido registrado → Geração da prévia → Conferência da prévia → Faturamento → Geração da expedição → Separação dos itens → Bipagem → Agrupamento em caixa.

Processo 3:
Expedição concluída → Associação da transportadora → Criação da entrega → Registro do código de rastreio → Saída para entrega → Registro da entrega → Atualização do status da entrega.


3. REQUISITOS DO SISTEMA

3.1 REQUISITOS FUNCIONAIS

RF01 — O sistema deve permitir cadastrar e manter os dados dos distribuidores.

RF02 — O sistema deve permitir cadastrar e manter os dados dos representantes.

RF03 — O sistema deve permitir cadastrar e manter os dados dos produtos.

RF04 — O sistema deve permitir registrar pedidos vinculados a um distribuidor e, quando necessário, a um representante.

RF05 — O sistema deve permitir incluir produtos e suas respectivas quantidades nos pedidos.

RF06 — O sistema deve permitir gerar a prévia e o faturamento de um pedido.

RF07 — O sistema deve permitir registrar a expedição, a bipagem dos produtos e a organização dos itens em caixas.

RF08 — O sistema deve permitir registrar transportadoras, entregas, códigos de rastreio e status da entrega.


3.2 REQUISITOS NÃO FUNCIONAIS

RNF01 — O sistema deve possuir controle de acesso para proteger as informações cadastradas.

RNF02 — O sistema deve apresentar interface simples e fácil de utilizar pelos funcionários.

RNF03 — O sistema deve manter os dados armazenados de forma organizada e consistente.

RNF04 — O sistema deve apresentar bom desempenho durante o cadastro, consulta e atualização dos pedidos.

RNF05 — O sistema deve permitir a expansão da quantidade de pedidos, produtos e demais registros sem comprometer seu funcionamento.


4. REGRAS DE NEGÓCIO

Regras operacionais:

RN01 — Cada pedido deve estar vinculado a um distribuidor.

RN02 — Um distribuidor pode realizar vários pedidos, mas cada pedido pertence a apenas um distribuidor.

RN03 — Um pedido pode possuir vários itens, sendo que cada item está relacionado a um produto.

RN04 — Um produto pode aparecer em vários itens de pedidos diferentes.

RN05 — Cada pedido pode gerar uma prévia e um faturamento, mantendo a relação com o pedido de origem.

RN06 — Uma expedição deve estar relacionada a um pedido e pode resultar em uma entrega realizada por uma transportadora.

Restrições organizacionais:

RO01 — O código de barras do produto deve ser único para permitir sua identificação durante a separação e bipagem.

RO02 — O número do pedido deve ser único para evitar duplicidade de pedidos.

RO03 — O código da caixa deve ser único para permitir sua identificação durante o processo de expedição.

RO04 — Os registros de pedidos, expedições, entregas e faturamentos devem permanecer relacionados para possibilitar o acompanhamento e a rastreabilidade da operação.


5. DICIONÁRIO DE DADOS CONCEITUAL (PRELIMINAR)

Entidade 1: DISTRIBUIDOR

Atributo: id_distribuidor
Descrição: Identificador único do distribuidor.
Regra de negócio: Deve ser único.

Atributo: cnpj
Descrição: Cadastro Nacional da Pessoa Jurídica do distribuidor.
Regra de negócio: Deve ser único.

Atributo: razao_social
Descrição: Nome empresarial oficial do distribuidor.
Regra de negócio: Deve ser informado.

Atributo: nome_fantasia
Descrição: Nome comercial utilizado pelo distribuidor.
Regra de negócio: Pode ser utilizado para identificação comercial.

Atributo: inscricao_estadual
Descrição: Inscrição estadual do distribuidor.
Regra de negócio: Deve ser registrada quando aplicável.

Atributo: email
Descrição: E-mail de contato do distribuidor.
Regra de negócio: Deve seguir um formato válido.

Atributo: telefone
Descrição: Telefone de contato do distribuidor.
Regra de negócio: Deve ser informado para contato.

Atributo: endereco
Descrição: Endereço do distribuidor.
Regra de negócio: Deve representar o local cadastrado.

Atributo: status
Descrição: Situação atual do distribuidor no sistema.
Regra de negócio: Deve possuir um valor válido definido pela organização.


Entidade 2: REPRESENTANTE

Atributo: id_representante
Descrição: Identificador único do representante.
Regra de negócio: Deve ser único.

Atributo: cpf
Descrição: CPF utilizado para identificação do representante.
Regra de negócio: Deve ser único.

Atributo: nome
Descrição: Nome completo do representante.
Regra de negócio: Deve ser informado.

Atributo: email
Descrição: E-mail de contato do representante.
Regra de negócio: Deve seguir um formato válido.

Atributo: telefone
Descrição: Telefone de contato do representante.
Regra de negócio: Deve ser informado.

Atributo: status
Descrição: Situação atual do representante.
Regra de negócio: Deve possuir um valor válido.


Entidade 3: PRODUTO

Atributo: id_produto
Descrição: Identificador único do produto.
Regra de negócio: Deve ser único.

Atributo: codigo_barras
Descrição: Código utilizado para identificação do produto.
Regra de negócio: Deve ser único.

Atributo: nome_produto
Descrição: Nome do produto comercializado.
Regra de negócio: Deve ser informado.

Atributo: categoria
Descrição: Categoria à qual o produto pertence.
Regra de negócio: Deve ser informada.

Atributo: unidade_medida
Descrição: Unidade utilizada para medir o produto.
Regra de negócio: Deve possuir uma unidade válida.

Atributo: peso
Descrição: Peso do produto.
Regra de negócio: Deve possuir valor compatível com o produto.

Atributo: altura
Descrição: Altura do produto.
Regra de negócio: Deve ser informada quando utilizada no processo logístico.

Atributo: largura
Descrição: Largura do produto.
Regra de negócio: Deve ser informada quando utilizada no processo logístico.

Atributo: comprimento
Descrição: Comprimento do produto.
Regra de negócio: Deve ser informado quando utilizado no processo logístico.

Atributo: preco_unitario
Descrição: Preço de uma unidade do produto.
Regra de negócio: Deve ser maior ou igual a zero.

Atributo: status
Descrição: Situação atual do produto no sistema.
Regra de negócio: Deve possuir um valor válido.


Entidade 4: PEDIDO

Atributo: id_pedido
Descrição: Identificador único do pedido.
Regra de negócio: Deve ser único.

Atributo: numero_pedido
Descrição: Número utilizado para identificação do pedido.
Regra de negócio: Deve ser único.

Atributo: id_distribuidor
Descrição: Identifica o distribuidor responsável pelo pedido.
Regra de negócio: Todo pedido deve estar associado a um distribuidor.

Atributo: id_representante
Descrição: Identifica o representante relacionado ao pedido.
Regra de negócio: Deve ser preenchido quando houver representante associado.

Atributo: data_hora_pedido
Descrição: Data e horário em que o pedido foi registrado.
Regra de negócio: Deve ser registrada no momento do pedido.

Atributo: data_hora_exportacao
Descrição: Data e horário da exportação do pedido.
Regra de negócio: Deve ser registrada quando ocorrer a exportação.

Atributo: tipo_pedido
Descrição: Tipo ou classificação do pedido.
Regra de negócio: Deve possuir um tipo válido.

Atributo: status_pedido
Descrição: Situação atual do pedido.
Regra de negócio: Deve acompanhar as etapas do processo.

Atributo: observacao
Descrição: Informações adicionais relacionadas ao pedido.
Regra de negócio: Campo utilizado quando houver necessidade de observações.


Entidade 5: ITEM_PEDIDO

Atributo: id_pedido
Descrição: Identifica o pedido ao qual o item pertence.
Regra de negócio: Deve estar relacionado a um pedido existente.

Atributo: id_produto
Descrição: Identifica o produto presente no pedido.
Regra de negócio: Deve estar relacionado a um produto existente.

Atributo: quantidade_solicitada
Descrição: Quantidade do produto solicitada no pedido.
Regra de negócio: Deve ser maior que zero.

Atributo: quantidade_aprovada
Descrição: Quantidade do produto aprovada para o pedido.
Regra de negócio: Não deve ser superior à quantidade solicitada.

Atributo: quantidade_separada
Descrição: Quantidade do produto efetivamente separada para expedição.
Regra de negócio: Deve respeitar a quantidade aprovada.

Atributo: valor_unitario
Descrição: Valor de cada unidade do produto no pedido.
Regra de negócio: Deve ser registrado para cálculo do pedido.

Atributo: percentual_desconto
Descrição: Percentual de desconto aplicado ao item.
Regra de negócio: Deve estar dentro dos limites definidos pela organização.


Entidade 6: PREVIA

Atributo: id_previa
Descrição: Identificador único da prévia.
Regra de negócio: Deve ser único.

Atributo: id_pedido
Descrição: Identifica o pedido relacionado à prévia.
Regra de negócio: Cada prévia deve estar vinculada a um pedido.

Atributo: numero_previa
Descrição: Número utilizado para identificar a prévia.
Regra de negócio: Deve ser único.

Atributo: data_hora_geracao
Descrição: Data e horário em que a prévia foi gerada.
Regra de negócio: Deve ser registrada no momento da geração.

Atributo: status_previa
Descrição: Situação atual da prévia.
Regra de negócio: Deve possuir um status válido.


Entidade 7: FATURAMENTO

Atributo: id_faturamento
Descrição: Identificador único do faturamento.
Regra de negócio: Deve ser único.

Atributo: id_pedido
Descrição: Identifica o pedido relacionado ao faturamento.
Regra de negócio: Deve estar relacionado a um pedido existente.

Atributo: numero_nota_fiscal
Descrição: Número da nota fiscal emitida para o pedido.
Regra de negócio: Deve identificar a nota fiscal correspondente.

Atributo: serie_nota_fiscal
Descrição: Série da nota fiscal.
Regra de negócio: Deve ser registrada conforme a emissão fiscal.

Atributo: chave_nfe
Descrição: Chave de identificação da nota fiscal eletrônica.
Regra de negócio: Deve identificar a NF-e correspondente.

Atributo: data_hora_faturamento
Descrição: Data e horário do faturamento.
Regra de negócio: Deve ser registrada na realização do faturamento.

Atributo: valor_frete
Descrição: Valor cobrado referente ao frete.
Regra de negócio: Deve ser registrado quando houver cobrança.

Atributo: valor_desconto
Descrição: Valor total de desconto aplicado ao pedido.
Regra de negócio: Deve corresponder aos descontos aplicados.

Atributo: status_faturamento
Descrição: Situação atual do faturamento.
Regra de negócio: Deve possuir um status válido.


Entidade 8: EXPEDICAO

Atributo: id_expedicao
Descrição: Identificador único da expedição.
Regra de negócio: Deve ser único.

Atributo: id_pedido
Descrição: Identifica o pedido relacionado à expedição.
Regra de negócio: A expedição deve estar relacionada a um pedido.

Atributo: numero_expedicao
Descrição: Número utilizado para identificação da expedição.
Regra de negócio: Deve ser único.

Atributo: data_hora_inicio
Descrição: Data e horário de início da expedição.
Regra de negócio: Deve ser registrado quando o processo começar.

Atributo: data_hora_fim
Descrição: Data e horário de finalização da expedição.
Regra de negócio: Deve ser registrado após a conclusão.

Atributo: status_expedicao
Descrição: Situação atual da expedição.
Regra de negócio: Deve possuir um status válido.


Entidade 9: BIPAGEM

Atributo: id_bipagem
Descrição: Identificador único do registro de bipagem.
Regra de negócio: Deve ser único.

Atributo: id_caixa
Descrição: Identifica a caixa utilizada na bipagem.
Regra de negócio: Deve estar relacionada a uma caixa existente.

Atributo: id_pedido
Descrição: Identifica o pedido relacionado à bipagem.
Regra de negócio: Deve estar relacionado a um pedido existente.

Atributo: id_produto
Descrição: Identifica o produto bipado.
Regra de negócio: Deve estar relacionado a um produto existente.

Atributo: codigo_barras_lido
Descrição: Código de barras registrado durante a leitura.
Regra de negócio: Deve corresponder a um produto cadastrado.

Atributo: data_hora_bipagem
Descrição: Data e horário em que a bipagem foi realizada.
Regra de negócio: Deve ser registrada durante a operação.

Atributo: quantidade_bipada
Descrição: Quantidade de produtos registrada na bipagem.
Regra de negócio: Deve ser compatível com a quantidade a ser separada.

Atributo: status_bipagem
Descrição: Situação da bipagem realizada.
Regra de negócio: Deve possuir um status válido.


Entidade 10: CAIXA

Atributo: id_caixa
Descrição: Identificador único da caixa.
Regra de negócio: Deve ser único.

Atributo: id_expedicao
Descrição: Identifica a expedição à qual a caixa pertence.
Regra de negócio: Deve estar relacionada a uma expedição existente.

Atributo: codigo_caixa
Descrição: Código utilizado para identificar a caixa.
Regra de negócio: Deve ser único.

Atributo: tipo_caixa
Descrição: Tipo ou modelo da caixa utilizada.
Regra de negócio: Deve possuir um tipo válido.

Atributo: data_hora_fechamento
Descrição: Data e horário em que a caixa foi fechada.
Regra de negócio: Deve ser registrado após a finalização da montagem.

Atributo: peso
Descrição: Peso total da caixa.
Regra de negócio: Deve ser compatível com os itens armazenados.

Atributo: altura
Descrição: Altura da caixa.
Regra de negócio: Deve ser registrada para controle logístico.

Atributo: largura
Descrição: Largura da caixa.
Regra de negócio: Deve ser registrada para controle logístico.

Atributo: comprimento
Descrição: Comprimento da caixa.
Regra de negócio: Deve ser registrado para controle logístico.


Entidade 11: TRANSPORTADORA

Atributo: id_transportadora
Descrição: Identificador único da transportadora.
Regra de negócio: Deve ser único.

Atributo: cnpj
Descrição: CNPJ da transportadora.
Regra de negócio: Deve ser único.

Atributo: razao_social
Descrição: Nome empresarial da transportadora.
Regra de negócio: Deve ser informado.

Atributo: nome_fantasia
Descrição: Nome comercial da transportadora.
Regra de negócio: Pode ser utilizado para identificação comercial.

Atributo: telefone
Descrição: Telefone de contato da transportadora.
Regra de negócio: Deve ser informado.

Atributo: email
Descrição: E-mail de contato da transportadora.
Regra de negócio: Deve seguir um formato válido.

Atributo: endereco
Descrição: Endereço da transportadora.
Regra de negócio: Deve representar o endereço cadastrado.

Atributo: status
Descrição: Situação atual da transportadora.
Regra de negócio: Deve possuir um valor válido.


Entidade 12: ENTREGA

Atributo: id_entrega
Descrição: Identificador único da entrega.
Regra de negócio: Deve ser único.

Atributo: id_expedicao
Descrição: Identifica a expedição relacionada à entrega.
Regra de negócio: A entrega deve estar relacionada a uma expedição.

Atributo: id_transportadora
Descrição: Identifica a transportadora responsável pela entrega.
Regra de negócio: Deve estar relacionada a uma transportadora existente.

Atributo: codigo_rastreio
Descrição: Código utilizado para acompanhar a entrega.
Regra de negócio: Deve identificar a entrega quando utilizado.

Atributo: endereco_entrega
Descrição: Local para onde o pedido será entregue.
Regra de negócio: Deve ser informado antes do envio.

Atributo: data_hora_saida
Descrição: Data e horário em que a entrega saiu para transporte.
Regra de negócio: Deve ser registrada no momento da saída.

Atributo: data_prevista_entrega
Descrição: Data prevista para realização da entrega.
Regra de negócio: Deve ser definida quando houver previsão de entrega.

Atributo: data_hora_entrega
Descrição: Data e horário em que a entrega foi realizada.
Regra de negócio: Deve ser preenchida após a conclusão da entrega.

Atributo: status_entrega
Descrição: Situação atual da entrega.
Regra de negócio: Deve possuir um status válido.

Atributo: comprovante_entrega
Descrição: Registro utilizado para comprovar a realização da entrega.
Regra de negócio: Deve ser registrado quando exigido pela organização.


6. MODELAGEM CONCEITUAL (ENTIDADES, ATRIBUTOS, RELACIONAMENTOS)

Entidades reconhecidas:

1. DISTRIBUIDOR — representa os distribuidores que realizam pedidos.
2. REPRESENTANTE — representa os responsáveis comerciais relacionados aos pedidos.
3. PRODUTO — representa os produtos comercializados e movimentados.
4. PEDIDO — representa a solicitação de produtos realizada pelo distribuidor.
5. ITEM_PEDIDO — representa cada produto e quantidade pertencente a um pedido.
6. PREVIA — representa a prévia gerada a partir do pedido.
7. FATURAMENTO — representa o processo de faturamento do pedido.
8. EXPEDICAO — representa o processo de preparação e envio do pedido.
9. BIPAGEM — registra a leitura e conferência dos produtos durante a expedição.
10. CAIXA — representa as caixas utilizadas para acondicionar os produtos.
11. TRANSPORTADORA — representa a empresa responsável pelo transporte.
12. ENTREGA — representa o processo de entrega do pedido ao destino.

Atributos e classificações:

Entidade 1: DISTRIBUIDOR
- Identificação: id_distribuidor
- Dados cadastrais: cnpj, razao_social, nome_fantasia, inscricao_estadual
- Contato e localização: email, telefone, endereco
- Controle: status

Entidade 2: REPRESENTANTE
- Identificação: id_representante, cpf
- Dados pessoais: nome
- Contato: email, telefone
- Controle: status

Entidade 3: PRODUTO
- Identificação: id_produto, codigo_barras
- Dados do produto: nome_produto, categoria, unidade_medida
- Características físicas: peso, altura, largura, comprimento
- Comercial: preco_unitario
- Controle: status

Entidade 4: PEDIDO
- Identificação: id_pedido, numero_pedido
- Relacionamentos: id_distribuidor, id_representante
- Datas: data_hora_pedido, data_hora_exportacao
- Classificação: tipo_pedido, status_pedido
- Complementar: observacao

Entidade 5: ITEM_PEDIDO
- Chaves: id_pedido, id_produto
- Quantidades: quantidade_solicitada, quantidade_aprovada, quantidade_separada
- Valores: valor_unitario, percentual_desconto

Entidade 6: PREVIA
- Identificação: id_previa, numero_previa
- Relacionamento: id_pedido
- Data: data_hora_geracao
- Controle: status_previa

Entidade 7: FATURAMENTO
- Identificação: id_faturamento
- Relacionamento: id_pedido
- Dados fiscais: numero_nota_fiscal, serie_nota_fiscal, chave_nfe
- Data: data_hora_faturamento
- Valores: valor_frete, valor_desconto
- Controle: status_faturamento

Entidade 8: EXPEDICAO
- Identificação: id_expedicao, numero_expedicao
- Relacionamento: id_pedido
- Datas: data_hora_inicio, data_hora_fim
- Controle: status_expedicao

Entidade 9: BIPAGEM
- Identificação: id_bipagem
- Relacionamentos: id_caixa, id_pedido, id_produto
- Leitura: codigo_barras_lido
- Data: data_hora_bipagem
- Quantidade: quantidade_bipada
- Controle: status_bipagem

Entidade 10: CAIXA
- Identificação: id_caixa, codigo_caixa
- Relacionamento: id_expedicao
- Classificação: tipo_caixa
- Data: data_hora_fechamento
- Dimensões: peso, altura, largura, comprimento

Entidade 11: TRANSPORTADORA
- Identificação: id_transportadora
- Dados cadastrais: cnpj, razao_social, nome_fantasia
- Contato: telefone, email
- Localização: endereco
- Controle: status

Entidade 12: ENTREGA
- Identificação: id_entrega
- Relacionamentos: id_expedicao, id_transportadora
- Rastreamento: codigo_rastreio
- Localização: endereco_entrega
- Datas: data_hora_saida, data_prevista_entrega, data_hora_entrega
- Controle: status_entrega
- Comprovante: comprovante entrega


Relacionamentos pertinentes:

1. DISTRIBUIDOR realiza PEDIDO — um distribuidor pode realizar vários pedidos e cada pedido pertence a um distribuidor.

2. REPRESENTANTE atende PEDIDO — um representante pode atender vários pedidos.

3. PEDIDO contém ITEM_PEDIDO — um pedido pode possuir vários itens.

4. PRODUTO refere-se a ITEM_PEDIDO — um produto pode aparecer em vários itens de pedidos.

5. PEDIDO gera PREVIA — cada pedido pode gerar uma prévia.

6. PEDIDO fatura FATURAMENTO — cada pedido pode possuir um faturamento.

7. PEDIDO origina EXPEDICAO — cada expedição está relacionada a um pedido.

8. EXPEDICAO resulta em ENTREGA — a expedição está relacionada à entrega.

9. TRANSPORTADORA realiza ENTREGA — uma transportadora pode realizar várias entregas.

10. EXPEDICAO compõe CAIXA — uma expedição pode possuir várias caixas.

11. CAIXA agrupa BIPAGEM — uma caixa pode possuir vários registros de bipagem.

12. ITEM_PEDIDO confere BIPAGEM — os registros de bipagem permitem conferir os itens do pedido.


Restrições e políticas organizacionais aplicadas ao modelo:

1. Os identificadores das entidades devem ser únicos para evitar duplicidade de registros.

2. Todo pedido deve estar relacionado a um distribuidor.

3. Os produtos devem estar cadastrados antes de serem associados aos itens de um pedido.

4. As etapas de faturamento, expedição, transporte e entrega devem permanecer relacionadas ao pedido para garantir a rastreabilidade da operação.


7. DIAGRAMA ENTIDADE-RELACIONAMENTO (DER)

Imagem em anexo.


8. JUSTIFICATIVA TÉCNICA

Escolha das Entidades:

PEDIDO e ITEM_PEDIDO: Separa o cabeçalho das mercadorias, permitindo múltiplos produtos por pedido e congelando o preço da venda (valor_unitario).

PREVIA e FATURAMENTO: Isolam a intenção de compra da emissão fiscal (NF-e), evitando campos nulos no pedido antes da conclusão.

Logística (EXPEDICAO, CAIXA, BIPAGEM, ENTREGA): Permitem fracionar o pedido em vários volumes físicos (CAIXA), auditando a leitura exata de cada item na esteira (BIPAGEM) e desacoplando a entrega do armazém interno.

Relacionamentos e Cardinalidades:

DISTRIBUIDOR (1) : (N) PEDIDO / REPRESENTANTE (1) : (N) PEDIDO: Garante vínculo obrigatório do cliente e comissionamento flexível.

PEDIDO (1) : (1) PREVIA / FATURAMENTO / EXPEDICAO: Mantém fluxo único de aprovação, faturamento e preparação.

EXPEDICAO (1) : (N) CAIXA (1) : (N) BIPAGEM: Suporta o empacotamento fracionado em múltiplas caixas e conferência unitária.

Atributos-Chave:

Controle de Quantidades (solicitada, aprovada, separada): Registra divergências e cortes de estoque sem perder o histórico do pedido.

Dimensões do Produto vs. Caixa: O produto calcula a cubagem teórica; a caixa registra o peso/tamanho real para cálculo de frete.

Datas/Horas (data_hora_*): Permitem medir o lead time e mapear gargalos operacionais.


9. USO DE INTELIGÊNCIA ARTIFICIAL

Ferramenta e etapa: ChatGPT e Claude 

Motivação: Agilidade no processo: Acelerar a montagem gráfica do Diagrama Entidade-Relacionamento (DER), otimizando o tempo de construção e permitindo focar na validação das regras de negócio.

Apoio na estrutura técnica: Garantir o correto mapeamento visual das entidades, atributos (como chaves primárias e estrangeiras) e cardinalidades, evitando erros manuais de notação.

Organização e clareza: Obter um layout limpo, padronizado e de fácil leitura para representar o fluxo logístico e fiscal completo (do pedido à entrega).

Prompt(s) utilizados: 
Primeiro Prompt:

Crie um Diagrama Entidade-Relacionamento (DER)  baseado na minha rotina de trabalho>
O distribuidor realiza um pedido pelo sistema próprio da empresa. O pedido é exportado e recebido pelos representantes no sistema da empresa. Após o recebimento, é gerada uma prévia para verificar a quantidade de itens que serão enviados. Em seguida, o pedido é faturado e encaminhado para a expedição. Na expedição, os produtos são separados conforme o cálculo de cada pedido, os itens são bipados para conferência e colocados nas caixas. As caixas são fechadas e encaminhadas ao setor de transporte, onde são coletadas pela transportadora e enviadas para entrega em todo o Brasil.

Resultado:
Imagem em anexo

Segundo Prompt:

#Papel
Você é um cientista e doutor de dados.
#Tarefa
Melhorar o diagrama, e torna-lo mais enxuto colocando apenas os dados realmente necessários em cada entidade. As entidades Item_pedido e Produto são a mesma coisa, revise.
#Contexto
Estou fazendo um projeto acadêmico para a faculdade e preciso da sua ajuda.
#Regras
Faça baseado nos conceitos mais atualizados de modelagem de dados.
Revise seu trabalho e entregue o que foi pedido sem pontas soltas.
#Formato de saída
Entregue o diagrama DER em imagem e também crie um dicionário em texto sobre o projeto.

Resultado:
Imagem em anexo.

Resposta recebida: Como resposta ao prompt enviado, a Inteligência Artificial gerou e retornou a imagem completa do Diagrama Entidade-Relacionamento (DER).

Fontes consultadas e verificadas: Comparação com o que foi observado na visita de campo

Trechos rejeitados ou corrigidos: Nenhum trecho do diagrama gerado pela Inteligência Artificial foi rejeitado ou descarregado.

Justificativa da escolha final: A estrutura gerada pela IA atendeu de forma precisa a todas as regras de negócio e requisitos funcionais estipulados.

Reflexão crítica: O uso da IA como ferramenta de apoio à modelagem acelerou a construção gráfica do diagrama, permitindo focar na análise lógica do fluxo de dados. A IA interpretou corretamente os relacionamentos complexos (como o fracionamento em caixas e a bipagem), fornecendo um modelo sólido e sem necessidade de correções estruturais.