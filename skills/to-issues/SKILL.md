---
name: to-issues
description: Quebra um plano, spec, PRD ou ideia grande em tarefas independentes usando fatias verticais (tracer bullets), gerando uma pasta de arquivos markdown numerados no projeto. Use SEMPRE que o usuário quiser "quebrar em tarefas", "dividir o plano", "criar as tasks", "gerar os issues", "fatiar a spec", ou tiver um documento de planejamento pronto e quiser transformá-lo em unidades de trabalho executáveis — mesmo que não mencione a palavra "issue".
---
 
# To Issues (versão local em markdown)
 
> Baseada na skill `to-issues` de **Matt Pocock** (matt-pocock-skills). Adaptada para gerar arquivos markdown locais em vez de publicar em um issue tracker. Créditos da metodologia de tracer bullets / fatias verticais ao trabalho original do Matt.
 
Quebra um plano em tarefas independentemente "pegáveis" usando fatias verticais (tracer bullets), salvas como arquivos `.md` numerados dentro de uma pasta no projeto.
 
## Processo
 
### 1. Reunir contexto

Primeiro, fixe a raiz do projeto: use o diretório de trabalho com código; se o usuário indicar um caminho ou repositório, use-o; se não houver projeto identificável, pergunte onde fica. A pasta `.tasks/` mora na raiz.

Trabalhe com o que já está no contexto da conversa. Se o usuário passar um caminho de arquivo (plano, spec, PRD) como argumento, leia o arquivo inteiro antes de começar.
 
Se o usuário indicar uma pasta de destino, use-a. Caso contrário:
 
- **Se a spec veio da skill `req-gathering`**, ela já mora em `.tasks/<slug>/spec.md` — gere as tasks nessa mesma pasta, ao lado da spec.
- **Caso contrário**, o padrão é `.tasks/<slug-da-spec>/` na raiz do projeto, onde `<slug-da-spec>` deriva do nome da spec/plano de origem (ex.: spec "Checkout em duas etapas" → `.tasks/checkout-em-duas-etapas/`). Se a spec de origem for um arquivo solto, considere copiá-la para dentro da pasta como `spec.md` (pergunte ao usuário), para que a pasta fique autocontida.
Cada spec ganha sua própria pasta dentro de `.tasks/`, que acumula todas as specs do projeto. Confirme o destino com o usuário no passo 4.
 
### 2. Explorar o código (opcional, mas recomendado)
 
Se ainda não explorou o codebase, explore para entender o estado atual do código. Títulos e descrições das tarefas devem usar o vocabulário de domínio do projeto e respeitar ADRs/decisões de arquitetura existentes na área que você vai tocar.
 
Procure oportunidades de **prefactoring** — preparar o código para tornar a implementação mais fácil. "Torne a mudança fácil, depois faça a mudança fácil."
 
### 3. Rascunhar as fatias verticais
 
Quebre o plano em tarefas do tipo **tracer bullet**. Cada tarefa é uma fatia vertical fina que atravessa TODAS as camadas de integração de ponta a ponta — NUNCA uma fatia horizontal de uma camada só.
 
<regras-de-fatia-vertical>
- Cada fatia entrega um caminho estreito mas COMPLETO por todas as camadas (schema, API, UI, testes)
- Uma fatia concluída é demonstrável ou verificável sozinha
- Qualquer prefactoring vira a(s) primeira(s) fatia(s), antes das demais
- Uma fatia deve caber confortavelmente em uma sessão de trabalho de um agente ou dev — se parecer grande demais, divida
</regras-de-fatia-vertical>
### 4. Validar com o usuário
 
Apresente a quebra proposta como lista numerada. Para cada fatia, mostre:
 
- **Título**: nome curto e descritivo
- **Bloqueada por**: quais outras fatias (se houver) precisam terminar antes
- **User stories cobertas**: quais user stories essa fatia atende (se o material de origem tiver)
Pergunte ao usuário:
 
- A granularidade está boa? (grossa demais / fina demais)
- As relações de dependência estão corretas?
- Alguma fatia deveria ser mesclada ou dividida?
- O destino `.tasks/<slug-da-spec>/` está ok, ou prefere outro slug/pasta?
Itere até o usuário aprovar a quebra. Não escreva arquivos antes da aprovação.
 
### 5. Gerar os arquivos

Guarda de colisão: se `.tasks/<slug>/` já contém arquivos `NN-*.md`, **pare antes de escrever**. Liste o que existe e pergunte se é para (a) numerar a partir do próximo livre, (b) usar outro slug, ou (c) regenerar do zero. **Nunca sobrescreva** uma task com status `em-andamento` ou `concluida` sem confirmação — o índice pode refletir trabalho já feito.

Crie a pasta de destino e, dentro dela:
 
**a) Um arquivo por fatia**, nomeado `NN-slug-curto.md` (numeração em ordem de dependência: bloqueadores primeiro, começando em `01`). Use o template abaixo.
 
**b) Um índice `00-index.md`** contendo:
- Título do plano e link relativo para a spec de origem — `[Spec completa](./spec.md)` se ela estiver na mesma pasta, ou o caminho relativo correto caso esteja em outro lugar
- Tabela de tarefas: número, título, status, bloqueada por
- Ordem de execução sugerida (ordem topológica das dependências)
- Instrução curta: "Ao concluir uma tarefa, atualize `status` no frontmatter dela e nesta tabela, registrando os hashes dos commits."
- Regra de retomada: "Ao retomar o trabalho (nova sessão ou após compactação de contexto), confie neste índice e no `git log` — nunca na memória da conversa. Tarefas marcadas `concluida` aqui estão concluídas: não as refaça."
<template-de-tarefa>
---
id: NN
titulo: Título curto da fatia
status: todo          # todo | em-andamento | concluida
bloqueada_por: []     # ex.: [01, 03] — ou lista vazia se pode começar já
---
# NN — Título da fatia
 
## Origem
Link relativo para a spec de origem (ex.: `[Spec](./spec.md)`, citando a seção relevante se aplicável) e para o índice (`[Índice](./00-index.md)`). Se não houver spec, omita o link e resuma a origem em uma linha.
 
## O que construir
Descrição concisa desta fatia vertical. Descreva o comportamento de ponta a ponta, não a implementação camada por camada.
 
Evite caminhos de arquivo específicos ou trechos de código — eles ficam desatualizados rápido. Exceção: se um protótipo produziu um snippet que codifica uma decisão com mais precisão do que prosa (máquina de estados, reducer, schema, formato de tipo), inclua-o aqui e anote brevemente que veio de um protótipo. Corte para as partes ricas em decisão — não uma demo funcional, só o essencial.
 
## Interfaces
- **Consome:** o que esta fatia usa de fatias anteriores — assinaturas exatas (nomes de funções, tipos de parâmetro e retorno, rotas, eventos). Omita se não consome nada.
- **Produz:** o que fatias posteriores vão depender — assinaturas exatas. Este bloco é como o implementador de outra fatia (que só vê a task dele) descobre os nomes e tipos que o seu trabalho expõe. Omita se nada depende desta fatia.
## User stories cobertas
Números das user stories da spec que esta fatia atende (ex.: `3, 7, 8`). Omita se a spec não tiver stories.
 
## Critérios de aceitação
- [ ] Critério 1
- [ ] Critério 2
- [ ] Critério 3
## Como verificar
Um comando, rota ou passo manual que demonstra a fatia funcionando de ponta a ponta. Use o seam definido na seção "Decisões de teste" da spec, se houver — não invente um ponto de teste novo.
 
## Bloqueada por
- `NN-slug.md` (se houver)
Ou "Nenhuma — pode começar imediatamente".
</template-de-tarefa>
 
### 6. Encerrar
 
Mostre ao usuário a árvore de arquivos criada e um resumo de quais tarefas podem começar imediatamente. NÃO modifique nem apague o documento de plano/spec original.