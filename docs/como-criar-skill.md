# Como criar uma skill do zero

---

## Antes de começar: perguntas que definem a skill

Responda estas antes de escrever uma linha:

1. **O que o Claude deve conseguir fazer com esta skill que não consegue sem ela?**
2. **Quando exatamente ela deve ativar? Que frases o usuário vai digitar?**
3. **Qual é o formato esperado de saída?**
4. **Existe alguma skill parecida já no hub?** (evite duplicatas ou conflitos)

---

## Passo 1 — Crie a pasta

```bash
mkdir skills/nome-da-skill
```

Use `kebab-case`. O nome deve ser descritivo e único no hub.

---

## Passo 2 — Crie o SKILL.md

```bash
touch skills/nome-da-skill/SKILL.md
```

Estrutura mínima:

```markdown
---
name: nome-da-skill
description: >
  O que a skill faz e QUANDO deve ser usada. Inclua verbos de ação,
  palavras-chave específicas e contextos. Esta descrição é o que o Claude
  lê para decidir se ativa a skill — seja específico e um pouco insistente.
---

# Nome da Skill

Instruções para o Claude seguir quando a skill estiver ativa.

## Quando usar
- Situação A
- Situação B

## Como funciona
Passo a passo do que fazer.

## Exemplos
Entrada e saída esperada.
```

---

## Passo 3 — Adicione recursos opcionais (se precisar)

```
skills/nome-da-skill/
├── SKILL.md
├── scripts/       ← scripts que a skill pode executar
├── references/    ← docs de referência (carregados sob demanda)
└── assets/        ← templates, arquivos de saída
```

Quando usar cada um:
- **scripts/**: lógica determinística que não vale explicar em markdown (ex: parsers, formatters)
- **references/**: documentação técnica grande demais para ficar no SKILL.md
- **assets/**: arquivos que a skill produz ou usa como base (templates Word, etc.)

---

## Passo 4 — Valide a estrutura

```bash
./scripts/validate.sh skills/nome-da-skill
```

Corrija qualquer erro antes de prosseguir.

---

## Passo 5 — Teste manualmente

1. Abra o Claude em uma conversa nova
2. Escreva mensagens que deveriam (e não deveriam) ativar a skill
3. Ajuste a `description` conforme o comportamento observado
4. Repita até estar satisfeito

Veja [boas-praticas.md](boas-praticas.md) para dicas de triggering.

---

## Passo 6 — Atualize o README

Adicione sua skill na tabela do README.md:

```markdown
| `nome-da-skill` | Descrição curta do que ela faz | @seu-usuario |
```

---

## Passo 7 — Abra o PR

```bash
git checkout -b feat/nome-da-skill
git add skills/nome-da-skill README.md
git commit -m "feat: adiciona skill nome-da-skill"
git push origin feat/nome-da-skill
```

Na descrição do PR, responda:
- O que a skill faz?
- Quando ela dispara?
- Algum edge case relevante?

Aguarde pelo menos 1 aprovação antes de mergear.

---

## Dica: use o Claude para criar a skill

Você pode pedir ao Claude para ajudar a escrever o SKILL.md descrevendo o que quer:

> "Me ajuda a criar uma skill para [o que você quer]. Ela deve disparar quando [contexto]. A saída esperada é [formato]."

O Claude vai fazer perguntas de clarificação e gerar um rascunho inicial.
