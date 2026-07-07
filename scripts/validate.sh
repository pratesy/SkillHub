#!/bin/bash
# validate.sh — valida a estrutura de todas as skills antes de um PR
# Uso: ./scripts/validate.sh
#      ./scripts/validate.sh skills/minha-skill   (valida só uma)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

check_skill() {
  local skill_path="$1"
  local skill_name=$(basename "$skill_path")
  local skill_file="$skill_path/SKILL.md"

  echo ""
  echo "Verificando: $skill_name"

  # 1. SKILL.md existe?
  if [ ! -f "$skill_file" ]; then
    echo -e "  ${RED}✗ SKILL.md não encontrado${NC}"
    ((ERRORS++))
    return
  fi

  # 2. Frontmatter existe?
  if ! grep -q "^---" "$skill_file"; then
    echo -e "  ${RED}✗ Frontmatter YAML ausente (precisa começar com ---)${NC}"
    ((ERRORS++))
    return
  fi

  # 3. Campo 'name' preenchido?
  if ! grep -qE "^name: .+" "$skill_file"; then
    echo -e "  ${RED}✗ Campo 'name' ausente ou vazio no frontmatter${NC}"
    ((ERRORS++))
  fi

  # 4. Campo 'description' preenchido?
  if ! grep -qE "^description" "$skill_file"; then
    echo -e "  ${RED}✗ Campo 'description' ausente no frontmatter${NC}"
    ((ERRORS++))
  fi

  # 5. Nome da pasta bate com o 'name' no frontmatter?
  local frontmatter_name=$(grep "^name:" "$skill_file" | sed 's/name: //' | tr -d '"' | tr -d "'")
  if [ "$frontmatter_name" != "$skill_name" ]; then
    echo -e "  ${YELLOW}⚠ Nome da pasta ('$skill_name') diferente do 'name' no frontmatter ('$frontmatter_name')${NC}"
    ((WARNINGS++))
  fi

  # 6. SKILL.md muito grande?
  local lines=$(wc -l < "$skill_file")
  if [ "$lines" -gt 500 ]; then
    echo -e "  ${YELLOW}⚠ SKILL.md tem $lines linhas (recomendado: < 500). Considere mover parte para references/${NC}"
    ((WARNINGS++))
  fi

  # 7. Nome da pasta em kebab-case?
  if [[ ! "$skill_name" =~ ^[a-z0-9-]+$ ]]; then
    echo -e "  ${YELLOW}⚠ Nome da pasta '$skill_name' não está em kebab-case${NC}"
    ((WARNINGS++))
  fi

  echo -e "  ${GREEN}✓ OK${NC}"
}

# Determina quais skills validar
if [ -n "$1" ]; then
  check_skill "$1"
else
  for skill_dir in skills/*/; do
    check_skill "$skill_dir"
  done
fi

# Resultado final
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo -e "${GREEN}✓ Tudo certo! $ERRORS erros, $WARNINGS avisos.${NC}"
elif [ "$ERRORS" -eq 0 ]; then
  echo -e "${YELLOW}⚠ $WARNINGS aviso(s) encontrado(s). Revise antes de mergear.${NC}"
else
  echo -e "${RED}✗ $ERRORS erro(s) e $WARNINGS aviso(s). Corrija antes de abrir o PR.${NC}"
  exit 1
fi
