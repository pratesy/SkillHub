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

| Skill | Descrição | Autor |
|-------|-----------|-------|
| `example-skill` | Skill de exemplo — veja como estruturar | @voce |

> Atualize esta tabela ao adicionar uma nova skill.

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
