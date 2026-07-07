# Como contribuir com o Skill Hub

---

## 1. Anatomia de uma skill

Toda skill é uma pasta dentro de `skills/` com um arquivo obrigatório:

```
skills/
└── minha-skill/
    ├── SKILL.md          ← obrigatório
    ├── scripts/          ← opcional: scripts que a skill pode executar
    ├── references/       ← opcional: docs de referência carregados sob demanda
    └── assets/           ← opcional: templates, ícones, arquivos de saída
```

O `SKILL.md` tem duas partes:

```markdown
---
name: nome-da-skill
description: >
  Descrição clara de O QUE a skill faz e QUANDO deve ser usada.
  Esta é a chave do triggering — o Claude lê isso para decidir se
  ativa a skill. Seja específico com verbos de ação e contextos.
  Inclua palavras-chave que o usuário provavelmente vai digitar.
---

# Nome da Skill

Instruções detalhadas para o Claude seguir quando esta skill estiver ativa.

## Quando usar
- Situação A
- Situação B

## Como funciona
Passo a passo do que o Claude deve fazer.

## Exemplos
Exemplos de entrada e saída esperada.
```

---

## 2. A description é o coração da skill

O Claude usa **somente** o `name` + `description` do frontmatter para decidir se ativa a skill. O corpo do SKILL.md só é lido depois.

**Boas práticas para a description:**
- Inclua verbos que o usuário vai usar ("crie", "gere", "analise", "revise")
- Mencione contextos específicos ("quando o usuário mencionar X", "ao trabalhar com Y")
- Seja um pouco "insistente" — prefira over-trigger a under-trigger
- Máximo ~150 palavras; seja denso, não vago

**Exemplo ruim:**
```
description: Ajuda com tarefas de código.
```

**Exemplo bom:**
```
description: >
  Revisora de segurança para código e APIs. Use SEMPRE que o usuário
  mencionar: segurança, vulnerabilidade, SQL injection, XSS, autenticação,
  secrets no código, "está seguro?", "revisar segurança", ou compartilhar
  código com queries SQL, JWT, senhas ou tokens.
```

---

## 3. Tamanho e organização

- `SKILL.md` idealmente abaixo de 500 linhas
- Para skills grandes, use `references/` com arquivos separados e aponte para eles no SKILL.md
- Para múltiplos domínios (ex: AWS vs GCP), crie um arquivo por variante em `references/`

---

## 4. Processo de PR

```
main
 └── feat/nome-da-skill   ← sua branch
```

**Checklist antes de abrir o PR:**
- [ ] Pasta nomeada em `kebab-case`
- [ ] `SKILL.md` com frontmatter válido (`name` e `description` preenchidos)
- [ ] `scripts/validate.sh` passou sem erros
- [ ] README.md atualizado com a nova skill na tabela
- [ ] PR descreve: o que faz, quando dispara, exemplo de uso

**Regra de review:** pelo menos **1 aprovação** de outro membro antes de mergear.

---

## 5. Convenções de nome

| Tipo | Formato | Exemplo |
|------|---------|---------|
| Pasta da skill | `kebab-case` | `code-review` |
| `name` no frontmatter | `kebab-case` | `code-review` |
| Branch | `feat/nome-da-skill` | `feat/code-review` |
| Arquivos de referência | `kebab-case.md` | `aws-deploy.md` |

---

## 6. Atualizando uma skill existente

- Mantenha o `name` original no frontmatter
- Abra PR com `fix/` ou `improve/` no nome da branch
- Documente o que mudou na descrição do PR

---

## 7. Removendo uma skill

Abra uma issue antes de deletar. Skills com uso ativo precisam de discussão antes da remoção.
