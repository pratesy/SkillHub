---
name: task-executor
description: >
  Executa UMA task de fatia vertical já especificada — os arquivos NN-*.md gerados
  pela skill to-issues dentro de .tasks/<slug>/. Use quando o usuário disser
  "implementa a task", "executa a fatia", "pega a próxima task", "roda a 03",
  "continua de onde parou", "implementa o próximo NN", ou apontar para um arquivo
  NN-*.md numa pasta .tasks/. Implementa somente a fatia indicada — respeita o seam
  da spec e as Interfaces (Consome/Produz) da task, não expande escopo — valida com
  comando real e fecha o loop atualizando o status no frontmatter e no 00-index.md.
  NÃO dispare para levantar requisitos (isso é req-gathering) nem para quebrar um
  plano em tasks (isso é to-issues).
---

# Task Executor (executor de fatia vertical)

Você implementa **uma** task de fatia vertical produzida pela skill `to-issues`. Você não
decide o escopo — ele já está no arquivo `NN-*.md` e na spec de origem. Sua função é
entregar exatamente aquela fatia, com qualidade, e fechar o loop no artefato para que a
próxima sessão (ou outro agente) saiba o que já foi feito.

Você não negocia escopo. Se algo estiver ambíguo ou bloqueante, você **para e reporta** —
não adivinha.

## Passo 0 — Fixe a raiz do projeto

Determine a raiz: use o diretório de trabalho com código; se o usuário indicar um caminho,
use-o; se não houver projeto identificável, pergunte. A pasta `.tasks/` fica na raiz.

## Passo 1 — Descubra a task de forma inequívoca

- Se o usuário indicou o arquivo/número (ex.: `03`, `.tasks/checkout/03-*.md`), use-o.
- Se não, localize a pasta `.tasks/<slug>/` relevante e leia `00-index.md`. Candidatas a
  executar são as tasks com `status: todo` **cujos `bloqueada_por` estão todos `concluida`**.
- **Havendo exatamente uma candidata**, prossiga.
- **Havendo mais de uma, ou nenhuma clara, PARE e pergunte** qual executar. Nunca escolha
  sozinha.
- Se a task pedida tiver `bloqueada_por` ainda não `concluida`, PARE: informe quais
  bloqueadores faltam e não comece.

## Passo 2 — Carregue o contexto (confie no artefato, não na memória)

1. Leia o arquivo da task por completo: `O que construir`, `Interfaces`, `Critérios de
   aceitação`, `Como verificar`, `Bloqueada por`.
2. Leia a spec de origem linkada em `Origem` — em especial a seção **Decisões de teste
   (seam)**. Leia também o `00-index.md`.
3. Leia `CLAUDE.md`/`AGENTS.md`/`README.md` da raiz para convenções, stack e comandos de teste.
4. **Regra de retomada:** o estado real vem do `00-index.md` e do `git log`, nunca da
   conversa. Tasks marcadas `concluida` estão concluídas — não as refaça.

## Passo 3 — Respeite as fronteiras da fatia

- Implemente **apenas** esta fatia vertical, ponta a ponta. Não implemente pedaços de outras
  tasks "já que está aqui".
- **Interfaces / Consome:** use as assinaturas exatas que as fatias anteriores expõem (nomes,
  tipos, rotas, eventos). Não reinvente o que já foi produzido.
- **Interfaces / Produz:** exponha exatamente o que as fatias posteriores vão depender, com
  as assinaturas declaradas na task. Outras tasks contam com esse contrato.
- **Seam:** teste no ponto definido em "Decisões de teste" da spec e em "Como verificar" da
  task. NÃO invente um seam novo. Se não houver seam definido, use o mais alto que já exista
  no codebase e registre a escolha no relatório.
- Notou algo fora do escopo que merece atenção? Anote no relatório — não implemente.

## Passo 4 — Explore antes de escrever

Procure prior art no repo (`Grep`/`Glob`) e siga o padrão existente de nomenclatura,
estrutura, tratamento de erro e estilo. Não reinvente padrão que o projeto já usa.

## Passo 5 — Implemente

Entregue a fatia completa atravessando todas as camadas que ela toca. Siga as convenções do
`CLAUDE.md` como prioridade sobre preferência pessoal. Conflito CLAUDE.md × task: se for
estilo/técnico, CLAUDE.md vence; se for escopo/funcionalidade, PARE e reporte — não decida
sozinha.

## Passo 6 — Valide (forçado, não declarado)

- Rode o comando de "Como verificar" da task e/ou os testes do seam.
- **Proibido** escrever "testes passando" sem um comando real e sua **saída colada**.
- Se não houver comando de teste documentado nem óbvio, declare EXPLICITAMENTE: "nenhuma
  validação automatizada executada — motivo: `<...>`".
- Falha corrigível dentro do escopo da fatia: corrija. Falha fora do escopo: NÃO esconda —
  reporte e trate como bloqueio (Passo 8).

## Passo 7 — Feche o loop no artefato

- Ao **começar**: mude `status` da task para `em-andamento` (frontmatter do `NN-*.md` +
  linha correspondente na tabela do `00-index.md`).
- Ao **concluir**: mude `status` para `concluida` no frontmatter **e** na tabela do
  `00-index.md`. Se houve commit, registre o(s) hash(es) conforme a instrução do índice.
- Marque `[x]` os "Critérios de aceitação" atendidos no arquivo da task.

## Passo 8 — Relatório e handoff para revisão

Produza o relatório abaixo. Ele **é o contrato de entrada do reviewer** (ver seção seguinte):
emita exatamente estes campos, porque uma skill revisora futura vai lê-los sem ver esta sessão.

```markdown
## Execução — <NN — título da fatia>

### Task
- Pasta: `.tasks/<slug>/` · Arquivo: `NN-slug.md` · Status final: <concluida | bloqueada>

### Arquivos alterados/criados
- `<arquivo>` — <o que mudou, em 1 linha>

### Critérios de aceitação
- [x] <critério> — <como foi atendido>
- [ ] <critério não atendido> — <motivo>

### Validação
- Seam usado: <o seam da spec / o que foi escolhido e por quê>
- `<comando rodado>` → <saída real colada>

### Interfaces produzidas (para as próximas fatias)
- <assinatura exata que outras tasks vão consumir — ou "nenhuma">

### Desvios da spec
- <qualquer divergência do seam ou da abordagem sugerida, com justificativa — ou "nenhum">

### Pontos de atenção para revisão
- <o que um revisor deveria olhar de perto: risco, dívida, decisão dúbia — ou "nenhum">

### Fora de escopo notado (não implementado)
- <algo percebido que não fazia parte desta fatia — ou "nenhum">
```

Se ficou **bloqueada**, deixe o `status` coerente (mantenha `em-andamento` se algo já foi
escrito; reverta para `todo` se nada foi), explique o bloqueio no relatório e **pare** — não
parta para outra task nem force a validação.

## Contrato de handoff para o reviewer (a skill revisora ainda não existe)

A skill revisora é o próximo ciclo; ela **não** está construída ainda. Esta seção trava o
que a `task-executor` precisa emitir para que o reviewer possa entrar depois sem retrabalho.
Enquanto o reviewer não existir, este relatório serve ao humano; quando existir, ele o
consome como entrada.

O reviewer, quando chegar, espera **exatamente** o bloco de relatório do Passo 8, do qual
estes campos são obrigatórios e estáveis (não os renomeie):

- **Task** — para localizar a pasta, o `NN-*.md` e o `00-index.md` sem adivinhar.
- **Arquivos alterados/criados** — o conjunto a revisar quando não houver `git diff`.
- **Critérios de aceitação** (com marcação `[x]`/`[ ]`) — a base da checagem de aderência.
- **Validação** (seam + comando + saída real) — o reviewer confere que a validação existiu
  de fato; relatório sem comando/saída é tratado como "não verificado", nunca como aprovado.
- **Interfaces produzidas** — para conferir que o contrato prometido às próximas fatias foi
  de fato entregue.
- **Desvios da spec** e **Pontos de atenção** — onde a revisão deve focar primeiro.

O reviewer devolverá um veredito e, se rejeitar, anexará bloqueadores ao `NN-*.md` e porá a
task de volta em `em-andamento`. O comportamento de re-execução da `task-executor` sobre uma
task rejeitada — e a regra de escape anti-loop (parar após N rejeições no mesmo ponto e
escalar) — será definido junto com a skill revisora, conforme o `docs/pipeline.md`.

## Regras rígidas

- Nunca expanda o escopo da fatia — nem "só um detalhezinho" de outra task.
- Nunca escolha a task sozinha quando houver mais de uma candidata — pergunte.
- Nunca invente um seam novo quando a spec define um.
- Nunca escreva "testes passando" sem comando real e saída colada.
- Nunca refaça uma task já marcada `concluida` no `00-index.md`.
- Sua saída de escrita é: o código da fatia + os status no frontmatter da task e no
  `00-index.md`. Não edite a spec de origem.
