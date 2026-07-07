# Boas práticas para skills que disparam certo

O maior problema em skills mal feitas não é o conteúdo — é o triggering. O Claude lê
`name` + `description` e decide se ativa a skill. Se a description for vaga, a skill
fica parada mesmo quando seria útil.

---

## O que o Claude usa para decidir

1. **`name`** — identificador interno, raramente visto pelo usuário
2. **`description`** — lida a cada mensagem para decidir se ativa a skill
3. **Corpo do SKILL.md** — só carregado *depois* que a skill é ativada

Portanto: **tudo que define quando usar vai na `description`. Tudo que define como
fazer vai no corpo.**

---

## Padrões que funcionam

### Inclua verbos de ação que o usuário vai usar
```yaml
description: >
  Use quando o usuário disser "criar PR", "abrir pull request", "subir branch",
  "revisar antes de mergear" ou qualquer variação de enviar código para revisão.
```

### Mencione contextos específicos, não genéricos
```yaml
# Ruim — muito vago
description: Ajuda com tarefas de desenvolvimento.

# Bom — contexto claro
description: >
  Guia para criar pull requests com título e descrição no padrão Conventional
  Commits. Use quando o usuário for abrir um PR, precisar de template de PR
  ou quiser revisar o formato antes de submeter.
```

### Seja "insistente" — prefira over-trigger a under-trigger
```yaml
description: >
  Revisora de segurança. Use SEMPRE que o usuário mencionar segurança,
  vulnerabilidade, SQL, autenticação, tokens, JWT, ou compartilhar qualquer
  código que lide com dados sensíveis ou autenticação — mesmo que não peça
  explicitamente uma revisão de segurança.
```

### Liste palavras-chave que o usuário provavelmente vai digitar
```yaml
description: >
  Gerador de changelogs. Ativado por: "gerar changelog", "o que mudou",
  "release notes", "diff desde a última versão", "resumo de commits".
```

---

## Erros comuns

| Erro | Problema | Correção |
|------|----------|----------|
| Description genérica | Never triggers | Seja específico com contextos |
| Tudo no corpo do SKILL.md | Under-triggers | Mova gatilhos para a description |
| Nome sem contexto | Conflita com outras skills | Adicione domínio: "para projetos Python" |
| Skill muito grande | Consome contexto desnecessariamente | Use `references/` para detalhes |

---

## Tamanho ideal

| Parte | Recomendado |
|-------|-------------|
| `description` | 50–150 palavras |
| Corpo do `SKILL.md` | < 500 linhas |
| Arquivos em `references/` | Sem limite (carregados sob demanda) |

---

## Testando sua skill

Antes de abrir o PR, teste manualmente:

1. Inicie uma conversa nova no Claude (sem contexto anterior)
2. Escreva uma mensagem que deveria ativar a skill
3. Veja se o Claude consultou a skill ou resolveu sozinho
4. Tente também mensagens que **não** deveriam ativar — verifique falsos positivos

Se a skill não disparar em casos óbvios, revise a `description` para ser mais
específica e "insistente".
