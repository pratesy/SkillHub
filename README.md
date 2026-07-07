# 🧠 Skill Hub

Repositório compartilhado de skills para o Claude — criado e mantido colaborativamente pelo grupo.

Skills são instruções em markdown que o Claude carrega dinamicamente para melhorar em tarefas específicas. Este repo funciona como um **marketplace privado**: cada membro instala o hub localmente e todas as skills ficam disponíveis automaticamente.

---

## ⚡ Instalação rápida

### Claude Code
```bash
/plugin marketplace add SEU_USUARIO/skill-hub
```

### Claude.ai
As skills ficam em `skills/` — copie o conteúdo de qualquer `SKILL.md` direto nas configurações de skills customizadas.

---

## 📁 Estrutura do repositório

```
skill-hub/
├── README.md               ← você está aqui
├── CONTRIBUTING.md         ← como contribuir
├── skills/                 ← uma pasta por skill
│   └── example-skill/
│       └── SKILL.md
├── docs/
│   ├── como-criar-skill.md ← guia passo a passo
│   └── boas-praticas.md    ← dicas para skills que disparam certo
└── scripts/
    └── validate.sh         ← valida estrutura das skills antes do PR
```

---

## 🗂️ Skills disponíveis

| Skill | Problema que resolve | Autor |
|-------|----------------------|-------|
| [`req-gathering`](#req-gathering) | Transforma uma ideia bruta em spec técnica aprovada, antes de qualquer código | @gyga |
| [`to-issues`](#to-issues) | Quebra uma spec ou plano em tasks independentes (fatias verticais) prontas para execução | @gyga |

> Atualize esta tabela ao adicionar uma nova skill.

---

### `req-gathering`

**O problema:** o Claude começa a codar antes de entender direito o que precisa ser feito — e aí você percebe na metade que o escopo tava errado.

**O que faz:** funciona como um analista de requisitos embutido. Quando você descreve uma tarefa, feature ou bug, a skill:

1. Lê automaticamente o contexto do projeto (`README`, `CLAUDE.md`, stack detectada pela estrutura de arquivos)
2. Faz até 5 perguntas objetivas de clarificação, só quando necessário
3. Valida a viabilidade técnica contra a stack do projeto
4. Gera um arquivo `spec.md` em `.tasks/<slug-da-tarefa>/` com escopo, user stories, abordagem técnica, decisões de teste e critérios de aceite
5. Aguarda sua aprovação antes de qualquer implementação

**Quando dispara:** automaticamente ao descrever qualquer mudança de código — "quero adicionar X", "tem um bug em Y", "ideia: Z". Não precisa pedir explicitamente.

**Saída:** `.tasks/<slug>/spec.md` — arquivo de spec estruturado, pronto para revisar e aprovar.

---

### `to-issues`

**O problema:** você tem um plano ou spec aprovada, mas ele é grande demais para executar de uma vez. Fica difícil paralelizar, retomar de onde parou ou passar para um agente.

**O que faz:** quebra qualquer plano, spec ou PRD em **fatias verticais** (tracer bullets) — tasks independentes que atravessam todas as camadas de ponta a ponta. Cada task é pequena o suficiente para caber em uma sessão de trabalho.

A skill gera uma pasta de arquivos numerados:

- `00-index.md` — índice com tabela de status, ordem de execução e regra de retomada (para o agente não refazer o que já foi feito)
- `01-slug.md`, `02-slug.md`, ... — uma task por arquivo, com critérios de aceite, dependências e como verificar que está pronta

**Quando dispara:** ao dizer "quebra em tasks", "gera os issues", "fatia a spec" ou apontar para um documento de plano.

**Fluxo natural com `req-gathering`:** `req-gathering` gera a spec → você aprova → `to-issues` quebra em tasks dentro da mesma pasta `.tasks/<slug>/` → um agente (ou você) executa task por task.

**Saída:** `.tasks/<slug>/00-index.md` + `NN-slug.md` para cada fatia.

---

## 🤝 Contribuindo

Veja [CONTRIBUTING.md](CONTRIBUTING.md) para o passo a passo completo.

Fluxo resumido:
1. Crie uma branch: `feat/nome-da-skill`
2. Adicione sua pasta em `skills/nome-da-skill/` com o `SKILL.md`
3. Rode `scripts/validate.sh` para checar a estrutura
4. Abra um PR descrevendo o que a skill faz e quando dispara
5. Pelo menos 1 aprovação antes de mergear

---

## 📖 Recursos úteis

- [Documentação oficial de skills](https://docs.claude.com)
- [Repositório oficial da Anthropic](https://github.com/anthropics/skills)
- [awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills) — curadoria da comunidade
- [SkillsMP](https://skillsmp.com) — buscador de skills públicas
