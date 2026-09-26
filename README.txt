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
3. Faturamento dos pedidos.
4. Preparação e expedição dos pedidos.
5. Entrega dos pedidos ao destino.

Fluxogramas:

Processo 1:
Início → Identificação do distribuidor → Atendimento pelo representante → Registro do pedido → Inclusão dos produtos → Finalização do pedido.

Processo 2:
Pedido registrado → Geração do faturamento → Conferência do faturamento → Início da expedição → Identificação dos produtos → Finalização da expedição.

Processo 3:
Expedição concluída → Geração da entrega → Registro da transportadora → Saída para entrega → Acompanhamento do código de rastreio → Registro da entrega → Finalização.


3. REQUISITOS DO SISTEMA

3.1 REQUISITOS FUNCIONAIS

RF01 — O sistema deve permitir cadastrar e manter os dados dos distribuidores.

RF02 — O sistema deve permitir cadastrar e manter os dados dos representantes.

RF03 — O sistema deve permitir cadastrar e manter os dados dos produtos.

RF04 — O sistema deve permitir registrar pedidos vinculados a distribuidores e representantes.

RF05 — O sistema deve permitir associar produtos aos pedidos.

RF06 — O sistema deve permitir registrar o faturamento relacionado aos pedidos.

RF07 — O sistema deve permitir registrar e acompanhar as etapas de expedição dos pedidos.

RF08 — O sistema deve permitir registrar e acompanhar as entregas, incluindo dados da transportadora, código de rastreio e status da entrega.


3.2 REQUISITOS NÃO FUNCIONAIS

RNF01 — O sistema deve possuir controle de acesso para proteger as informações cadastradas.

RNF02 — O sistema deve possuir uma interface simples e fácil de utilizar pelos funcionários.

RNF03 — O sistema deve manter os dados armazenados de forma organizada e consistente.

RNF04 — O sistema deve apresentar bom desempenho durante o cadastro, consulta e atualização das informações.

RNF05 — O sistema deve permitir o crescimento da quantidade de pedidos, produtos e demais registros sem comprometer seu funcionamento.


4. REGRAS DE NEGÓCIO

Regras operacionais:

RN01 — Cada pedido deve estar relacionado a um único distribuidor.

RN02 — Um distribuidor pode realizar vários pedidos.

RN03 — Um representante pode atender vários pedidos, porém cada pedido deve estar associado a um único representante.

RN04 — Um pedido pode conter vários produtos e um produto pode estar relacionado a vários pedidos.

RN05 — Um pedido pode possuir no máximo um faturamento, enquanto cada faturamento deve estar relacionado a um único pedido.

RN06 — Uma expedição deve estar relacionada a um único pedido e uma entrega deve estar relacionada a uma única expedição.

Restrições organizacionais:

RO01 — Os identificadores das entidades devem ser únicos para evitar duplicidade de registros.

RO02 — O número do pedido deve identificar cada pedido de forma única.

RO03 — Os produtos devem estar cadastrados antes de serem associados aos pedidos.

RO04 — As informações de faturamento, expedição e entrega devem permanecer relacionadas ao pedido para permitir o acompanhamento e a rastreabilidade da operação.


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
Descrição: Número de inscrição estadual do distribuidor.
Regra de negócio: Deve ser informado quando aplicável.

Atributo: email
Descrição: E-mail de contato do distribuidor.
Regra de negócio: Deve possuir formato válido.

Atributo: telefone
Descrição: Telefone de contato do distribuidor.
Regra de negócio: Deve ser informado.

Atributo: endereco
Descrição: Endereço do distribuidor.
Regra de negócio: Deve representar o endereço cadastrado.

Atributo: status
Descrição: Situação atual do distribuidor.
Regra de negócio: Deve possuir um valor válido.


Entidade 2: REPRESENTANTE

Atributo: id_representante
Descrição: Identificador único do representante.
Regra de negócio: Deve ser único.

Atributo: nome
Descrição: Nome completo do representante.
Regra de negócio: Deve ser informado.

Atributo: email
Descrição: E-mail de contato do representante.
Regra de negócio: Deve possuir formato válido.

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
Descrição: Código utilizado para identificar o produto.
Regra de negócio: Deve ser único.

Atributo: nome_produto
Descrição: Nome do produto.
Regra de negócio: Deve ser informado.

Atributo: categoria
Descrição: Categoria à qual o produto pertence.
Regra de negócio: Deve ser informada.

Atributo: unidade_medida
Descrição: Unidade utilizada para representar o produto.
Regra de negócio: Deve possuir uma unidade válida.

Atributo: preco_unitario
Descrição: Preço de uma unidade do produto.
Regra de negócio: Deve ser maior ou igual a zero.

Atributo: status
Descrição: Situação atual do produto.
Regra de negócio: Deve possuir um valor válido.


Entidade 4: PEDIDO

Atributo: id_pedido
Descrição: Identificador único do pedido.
Regra de negócio: Deve ser único.

Atributo: numero_pedido
Descrição: Número utilizado para identificar o pedido.
Regra de negócio: Deve ser único.

Atributo: data_hora_pedido
Descrição: Data e horário em que o pedido foi registrado.
Regra de negócio: Deve ser registrado no momento da criação do pedido.

Atributo: data_hora_exportacao
Descrição: Data e horário em que o pedido foi exportado.
Regra de negócio: Deve ser registrado quando ocorrer a exportação.

Atributo: tipo_pedido
Descrição: Tipo ou classificação do pedido.
Regra de negócio: Deve possuir um tipo válido.

Atributo: status_pedido
Descrição: Situação atual do pedido.
Regra de negócio: Deve possuir um status válido.

Atributo: observacao
Descrição: Informações adicionais relacionadas ao pedido.
Regra de negócio: Deve ser utilizada quando houver necessidade de registrar informações complementares.


Entidade 5: FATURAMENTO

Atributo: id_faturamento
Descrição: Identificador único do faturamento.
Regra de negócio: Deve ser único.

Atributo: numero_nota_fiscal
Descrição: Número da nota fiscal relacionada ao faturamento.
Regra de negócio: Deve ser informado quando houver emissão da nota fiscal.

Atributo: serie_nota_fiscal
Descrição: Série da nota fiscal.
Regra de negócio: Deve ser registrada conforme a emissão fiscal.

Atributo: chave_nfe
Descrição: Chave de identificação da nota fiscal eletrônica.
Regra de negócio: Deve identificar a nota fiscal correspondente.

Atributo: data_hora_faturamento
Descrição: Data e horário em que o faturamento foi realizado.
Regra de negócio: Deve ser registrado no momento do faturamento.

Atributo: status_faturamento
Descrição: Situação atual do faturamento.
Regra de negócio: Deve possuir um status válido.


Entidade 6: EXPEDICAO

Atributo: id_expedicao
Descrição: Identificador único da expedição.
Regra de negócio: Deve ser único.

Atributo: numero_expedicao
Descrição: Número utilizado para identificar a expedição.
Regra de negócio: Deve ser único.

Atributo: data_hora_inicio
Descrição: Data e horário de início da expedição.
Regra de negócio: Deve ser registrado no início do processo.

Atributo: data_hora_fim
Descrição: Data e horário de finalização da expedição.
Regra de negócio: Deve ser registrado após a conclusão do processo.

Atributo: status_expedicao
Descrição: Situação atual da expedição.
Regra de negócio: Deve possuir um status válido.


Entidade 7: ENTREGA

Atributo: id_entrega
Descrição: Identificador único da entrega.
Regra de negócio: Deve ser único.

Atributo: codigo_rastreio
Descrição: Código utilizado para acompanhar a entrega.
Regra de negócio: Deve ser informado quando houver rastreamento.

Atributo: endereco_entrega
Descrição: Endereço para onde o pedido será entregue.
Regra de negócio: Deve ser informado antes da realização da entrega.

Atributo: data_hora_saida
Descrição: Data e horário em que a entrega saiu para transporte.
Regra de negócio: Deve ser registrada no momento da saída.

Atributo: data_prevista_entrega
Descrição: Data prevista para a realização da entrega.
Regra de negócio: Deve ser registrada quando houver previsão.

Atributo: data_hora_entrega
Descrição: Data e horário em que a entrega foi realizada.
Regra de negócio: Deve ser preenchida após a conclusão da entrega.

Atributo: status_entrega
Descrição: Situação atual da entrega.
Regra de negócio: Deve possuir um status válido.

Atributo: comprovante_entrega
Descrição: Registro utilizado para comprovar a realização da entrega.
Regra de negócio: Deve ser registrado quando exigido.

Atributo: cnpj_transportadora
Descrição: CNPJ da transportadora responsável pela entrega.
Regra de negócio: Deve identificar a transportadora responsável.

Atributo: razao_social_transportadora
Descrição: Razão social da transportadora responsável pela entrega.
Regra de negócio: Deve corresponder à transportadora responsável.

Atributo: telefone_transportadora
Descrição: Telefone de contato da transportadora.
Regra de negócio: Deve ser informado para contato quando necessário.


6. MODELAGEM CONCEITUAL (ENTIDADES, ATRIBUTOS, RELACIONAMENTOS)

Entidades reconhecidas:

1. DISTRIBUIDOR — representa os distribuidores responsáveis pela realização dos pedidos.

2. REPRESENTANTE — representa os representantes responsáveis pelo atendimento dos pedidos.

3. PRODUTO — representa os produtos que podem ser incluídos nos pedidos.

4. PEDIDO — representa a solicitação realizada pelo distribuidor.

5. FATURAMENTO — representa o registro fiscal relacionado ao pedido.

6. EXPEDICAO — representa o processo de preparação e envio do pedido.

7. ENTREGA — representa o processo de entrega do pedido ao destino.


Atributos e classificações:

Entidade 1: DISTRIBUIDOR
- Identificação: id_distribuidor
- Dados cadastrais: cnpj, razao_social, nome_fantasia, inscricao_estadual
- Contato e localização: email, telefone, endereco
- Controle: status

Entidade 2: REPRESENTANTE
- Identificação: id_representante
- Dados pessoais: nome
- Contato: email, telefone
- Controle: status

Entidade 3: PRODUTO
- Identificação: id_produto, codigo_barras
- Dados do produto: nome_produto, categoria, unidade_medida
- Comercial: preco_unitario
- Controle: status

Entidade 4: PEDIDO
- Identificação: id_pedido, numero_pedido
- Datas: data_hora_pedido, data_hora_exportacao
- Classificação: tipo_pedido, status_pedido
- Complementar: observacao

Entidade 5: FATURAMENTO
- Identificação: id_faturamento
- Dados fiscais: numero_nota_fiscal, serie_nota_fiscal, chave_nfe
- Data: data_hora_faturamento
- Controle: status_faturamento

Entidade 6: EXPEDICAO
- Identificação: id_expedicao, numero_expedicao
- Datas: data_hora_inicio, data_hora_fim
- Controle: status_expedicao

Entidade 7: ENTREGA
- Identificação: id_entrega, codigo_rastreio
- Localização: endereco_entrega
- Datas: data_hora_saida, data_prevista_entrega, data_hora_entrega
- Controle: status_entrega
- Comprovante: comprovante_entrega
- Dados da transportadora: cnpj_transportadora, razao_social_transportadora, telefone_transportadora


Relacionamentos pertinentes:

1. DISTRIBUIDOR realiza PEDIDO — um distribuidor pode realizar vários pedidos, enquanto cada pedido deve estar relacionado a um único distribuidor.

2. REPRESENTANTE atende PEDIDO — um representante pode atender vários pedidos, enquanto cada pedido está relacionado a um único representante.

3. PEDIDO contém PRODUTO — um pedido pode conter vários produtos e um produto pode estar presente em vários pedidos.

4. PEDIDO tem FATURAMENTO — um pedido pode possuir nenhum ou um faturamento, enquanto cada faturamento pertence a um único pedido.

5. PEDIDO origina EXPEDICAO — um pedido pode originar várias expedições, enquanto cada expedição está relacionada a um único pedido.

6. PRODUTO identifica EXPEDICAO — um produto pode estar relacionado a várias expedições, enquanto cada expedição está relacionada a um único produto.

7. EXPEDICAO resulta em ENTREGA — uma expedição pode resultar em nenhuma ou uma entrega, enquanto cada entrega está relacionada a uma única expedição.

8. FATURAMENTO cobre ENTREGA — um faturamento pode estar relacionado a várias entregas, enquanto cada entrega está relacionada a um único faturamento.


Restrições e políticas organizacionais aplicadas ao modelo:

1. Os identificadores das entidades devem ser únicos para evitar duplicidade de registros.

2. Todo pedido deve estar relacionado a um único distribuidor e a um único representante.

3. Os produtos devem estar cadastrados antes de serem associados aos pedidos e às expedições.

4. As informações de faturamento, expedição e entrega devem permanecer relacionadas ao pedido para permitir o acompanhamento e a rastreabilidade da operação.


7. DIAGRAMA ENTIDADE-RELACIONAMENTO (DER)

Imagem em anexo.


8. JUSTIFICATIVA TÉCNICA

Escolha das Entidades:

PEDIDO: Representa a solicitação realizada pelo distribuidor e concentra as principais informações do processo, como número, datas, tipo, status e observações. A entidade permite acompanhar o pedido desde seu registro até as etapas de faturamento e expedição.

DISTRIBUIDOR e REPRESENTANTE: Foram definidos para identificar quem realiza o pedido e quem realiza o atendimento. A separação dessas entidades evita a repetição de informações e permite que um distribuidor possua vários pedidos e um representante atenda vários pedidos.

PRODUTO: Representa os produtos que podem ser relacionados aos pedidos e às expedições. Possui informações de identificação, categoria, unidade de medida, preço e status, permitindo manter um cadastro centralizado dos produtos.

FATURAMENTO: Foi separado do pedido para representar as informações fiscais e o momento em que o pedido é faturado. Dessa forma, os dados relacionados à nota fiscal e ao status do faturamento ficam organizados em uma entidade específica.

EXPEDICAO: Representa a etapa de preparação e envio do pedido. A separação dessa entidade permite registrar número, datas de início e fim e o status da expedição, facilitando o acompanhamento da operação.

ENTREGA: Representa a etapa final do processo, contendo informações sobre o endereço, rastreamento, datas, status, comprovante e dados da transportadora responsável.


Relacionamentos e Cardinalidades:

DISTRIBUIDOR (0,N) : (1,1) PEDIDO: Permite que um distribuidor realize nenhum ou vários pedidos, enquanto cada pedido deve estar relacionado a um único distribuidor.

REPRESENTANTE (0,N) : (1,1) PEDIDO: Permite que um representante atenda nenhum ou vários pedidos, enquanto cada pedido deve estar relacionado a um único representante.

PEDIDO (0,N) : (0,N) PRODUTO: Permite que um pedido contenha vários produtos e que um produto possa estar presente em vários pedidos.

PEDIDO (0,1) : (1,1) FATURAMENTO: Permite que um pedido ainda não possua faturamento ou possua um faturamento, enquanto cada faturamento está relacionado a um único pedido.

PEDIDO (0,N) : (1,1) EXPEDICAO: Permite que um pedido origine nenhuma ou várias expedições, enquanto cada expedição deve estar relacionada a um único pedido.

PRODUTO (0,N) : (1,1) EXPEDICAO: Relaciona os produtos às expedições, permitindo identificar o produto associado a cada processo de expedição.

EXPEDICAO (0,1) : (1,1) ENTREGA: Permite que uma expedição ainda não tenha resultado em uma entrega ou resulte em uma entrega, enquanto cada entrega está relacionada a uma única expedição.

FATURAMENTO (0,N) : (1,1) ENTREGA: Relaciona o faturamento às entregas, permitindo manter o vínculo entre as informações fiscais e o processo de entrega.


Atributos-Chave:

Identificadores: Os atributos id_ foram utilizados como identificadores das entidades, permitindo diferenciar cada registro e manter os relacionamentos entre as informações.

Dados de Cadastro: Informações como CNPJ, razão social, nome, e-mail, telefone e endereço permitem manter os dados necessários para identificação e contato dos participantes do processo.

Status: Os atributos de status permitem acompanhar a situação atual de pedidos, produtos, faturamentos, expedições e entregas.

Datas e Horários: Os atributos data_hora_pedido, data_hora_exportacao, data_hora_faturamento, data_hora_inicio, data_hora_fim, data_hora_saida e data_hora_entrega permitem registrar as principais etapas do processo e acompanhar sua evolução.

Informações Fiscais e de Entrega: Os atributos relacionados à nota fiscal, código de rastreio, endereço e comprovante de entrega permitem manter as informações necessárias para acompanhar o pedido desde o faturamento até a entrega.


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