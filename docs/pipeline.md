# Pipeline canônico — fonte da verdade compartilhada

Este documento é a **definição única** da espinha de desenvolvimento usada por dois
projetos que compartilham o mesmo modelo mental:

- **Time de agentes** (repo `claude-code/`) — subagentes do Claude Code.
- **SkillHub** (este repo) — skills do Claude Code.

Os dois implementam a **mesma espinha** com **mecanismos diferentes**. Este arquivo define o
que eles têm em comum e **ambos devem se conformar a ele**. Quando algo essencial mudar, muda
aqui primeiro; as duas implementações seguem. Isso existe para impedir que as duas divirjam no
essencial com o tempo.

> Regra de ouro: **unifique o modelo, não a implementação.** Ver a seção seguinte.

---

## 1. Por que dois mecanismos e não um

Subagentes e skills são mecanismos distintos, com garantias distintas. Fundir num só jogaria
fora a vantagem de cada um.

| | Subagente (time de agentes) | Skill (SkillHub) |
|---|---|---|
| Artefato | `.md` com `name/description/**tools**/model` | `SKILL.md` com `name/description` |
| Ativação | Despachado deliberadamente | Disparado por frase do usuário (`description`) |
| Contexto | **Isolado** — fresh, sem contaminar/ser contaminado | Injetado no contexto atual |
| Fronteira de permissão | **Real** — o reviewer não tem `Write`, fisicamente não escreve | **Inexistente** — roda com as tools de quem invocou |

A garantia mais valiosa do time de agentes — o revisor que *fisicamente não consegue* editar o
código — **não é reproduzível como skill**. Por isso os mecanismos ficam separados. O que se
unifica é a camada conceitual abaixo.

---

## 2. A espinha (mínima e obrigatória)

Todo trabalho passa por quatro papéis, nesta ordem. A espinha é curta de propósito; a
profundidade vem de especialistas condicionais, não de mais estágios obrigatórios.

```
   ESPECIFICAR  →  IMPLEMENTAR  →  REVISAR  →  INTEGRAR
        │              ↑ ____________ │
        │              loop de retrabalho (com escape anti-loop)
```

| Papel na espinha | Time de agentes | SkillHub | Estado no SkillHub |
|---|---|---|---|
| Especificar | `po-task-generator` (+ `arquiteto` condicional) | `req-gathering` (+ `to-issues` para decompor) | **existe** |
| Implementar | `developer` | `task-executor` | **existe** |
| Revisar | `code-reviewer` (+ `security-auditor` condicional) | *reviewer* | **pendente** (FOLLOW-UP-2) |
| Integrar | `integrator` | *integrator* | **pendente** |

O SkillHub tem hoje a espinha até "Implementar". "Revisar" e "Integrar" são ciclos futuros —
não construir contra uma peça anterior não testada é decisão explícita, não esquecimento.

---

## 3. Critério dos 3 testes — quando um papel merece unidade própria

Um papel merece ser um agente/skill separado quando tem **pelo menos um** destes, **e**
produz output com valor independente:

1. **Modo cognitivo distinto e conflitante** — construir e auditar no mesmo contexto se
   contaminam (o construtor racionaliza o próprio código).
2. **Fronteira de permissão distinta** — read-only vs. write. (No time de agentes é *real*,
   aplicada pelas tools; no SkillHub é apenas convenção no texto da skill.)
3. **Gatilho detectável e distinto** — ativa num ponto reconhecível.

E paga o **custo de handoff**: todo canal entre unidades tem perda; cada unidade re-lê
contexto. Por isso a espinha é mínima. O erro a evitar não é ter poucas ou muitas unidades —
é ter unidades *always-on com escopo sobreposto*.

---

## 4. Máquina de estados da tarefa

O artefato da tarefa é o **estado vivo** do pipeline. Cada unidade atualiza o `status` e anexa
seu relatório ao próprio artefato — o próximo agente não vê a conversa anterior.

### 4.1 Estados canônicos (alvo — completos)

```
pronta-para-dev → em-dev → em-revisao → aprovada → concluida
                     ↑           |
                     └── bloqueada ┘
```

| Estado | Significa |
|---|---|
| `pronta-para-dev` | spec fechada, sem pergunta bloqueante |
| `em-dev` | implementando |
| `em-revisao` | terminou; aguarda revisão |
| `aprovada` | revisão aprovou; aguarda integração |
| `bloqueada` | rejeitado; volta a implementar (com bloqueadores anexados) |
| `concluida` | integração fechou (regressão ok + finalização) |

Campo `rejeicoes` (inteiro, começa em 0): conta rejeições sobre **o mesmo ponto**, para a
regra de escape (seção 5).

### 4.2 Subconjunto atual do SkillHub

O `to-issues` emite e o `task-executor` consome, **por enquanto**, um subconjunto:

```
todo → em-andamento → concluida
```

Além de `bloqueada_por: []`, que **não é um estado de ciclo de vida** — é um eixo diferente
(dependência entre fatias), e continua valendo em paralelo ao `status`.

### 4.3 Mapeamento e reconciliação pendente

| Canônico | SkillHub hoje |
|---|---|
| `pronta-para-dev` | `todo` |
| `em-dev` | `em-andamento` |
| `em-revisao` | *(não existe — sem skill revisora)* |
| `aprovada` | *(não existe — sem skill revisora)* |
| `bloqueada` | *(não existe — sem skill revisora)* |
| `concluida` | `concluida` |

> **FOLLOW-UP-1 — Reconciliação de vocabulário de estado.** O SkillHub usa hoje o subconjunto
> `todo|em-andamento|concluida` porque é o que o `to-issues` já produz e o `task-executor`
> consome. Quando a skill revisora entrar (FOLLOW-UP-2), o SkillHub **provavelmente adota os
> estados canônicos ricos** desta seção (`em-revisao`, `aprovada`, `bloqueada`, `rejeicoes`).
> Decisão adiada de propósito, registrada aqui — não resolver agora, mas não deixar solta.

---

## 5. Regra de escape anti-loop (implementar ⇄ revisar)

O ciclo implementar⇄revisar pode travar se os dois discordarem no mesmo ponto.

- O campo `rejeicoes` conta rejeições sobre **o mesmo ponto**. Quem implementa incrementa ao
  reimplementar pela mesma objeção; quem revisa confere o contador.
- **Ao atingir 3**, o ciclo PARA e escala:
  - desacordo **estrutural / de design** → aciona o `arquiteto` (time de agentes) ou a decisão
    de arquitetura equivalente;
  - caso contrário → escala ao **humano** com o resumo do desacordo (posição de cada lado, por
    que não convergem).
- Ninguém reimplementa ou re-rejeita após o limite. Escalar é a resposta certa.

No SkillHub esta regra entra junto com a skill revisora (FOLLOW-UP-2); o `task-executor` já
deixa o gancho pronto no seu contrato de handoff.

---

## 6. Decisões pendentes (nomeadas)

| ID | Decisão | Estado |
|---|---|---|
| FOLLOW-UP-1 | Reconciliar vocabulário de estado do SkillHub com os estados canônicos ricos | adiada; ver §4.3 |
| FOLLOW-UP-2 | Construir a skill revisora do SkillHub + loop de re-execução + escape anti-loop | próximo ciclo, após o `task-executor` rodar de verdade |
| FOLLOW-UP-3 | Apontar o repo `claude-code/` (time de agentes) para este arquivo — SkillHub é o dono canônico, o outro repo apenas referencia (sem cópia, symlink ou duplicata) | pendente; ao abrir o repo `claude-code/` |

---

## 7. Prioridade de instruções (vale para as duas implementações)

1. Instruções explícitas do usuário.
2. `CLAUDE.md` do projeto-alvo + a spec/tarefa + **este documento**.
3. Julgamento da unidade.

Conflito entre este documento e a implementação de um lado: se for **estilo/mecanismo**, a
implementação se adapta; se for **modelo essencial** (espinha, estados, escape), este
documento vence e a implementação é corrigida para segui-lo.
