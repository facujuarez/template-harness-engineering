#!/bin/bash
# ============================================================
# pre-commit-check.sh
# Pre-commit hook: verifica build y lint antes de cada commit.
# 
# INSTALACIÓN:
#   cp scripts/pre-commit-check.sh .git/hooks/pre-commit
#   chmod +x .git/hooks/pre-commit
#
# El skill /start-issue lo instala automáticamente.
# ============================================================

set -e

# Colores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo ""
echo "🔍 Pre-commit check..."

# ─────────────────────────────────────────
# CONFIGURA AQUÍ TUS COMANDOS
# (o lee los comandos canónicos desde docs/architecture.md)
# ─────────────────────────────────────────

# Detecta el tipo de proyecto automáticamente
detect_project_type() {
  if [ -f "*.sln" ] || [ -f "*.csproj" ] 2>/dev/null || find . -maxdepth 2 -name "*.csproj" -o -name "*.sln" 2>/dev/null | grep -q .; then
    echo "dotnet"
  elif [ -f "package.json" ]; then
    if grep -q "\"spfx\"" package.json 2>/dev/null || [ -d "src/webparts" ]; then
      echo "spfx"
    elif grep -q "\"vitest\"" package.json 2>/dev/null; then
      echo "vite"
    else
      echo "node"
    fi
  else
    echo "unknown"
  fi
}

PROJECT_TYPE=$(detect_project_type)

# ─────────────────────────────────────────
# BUILD CHECK
# ─────────────────────────────────────────

echo "  📦 Build check ($PROJECT_TYPE)..."

BUILD_FAILED=0

case $PROJECT_TYPE in
  dotnet)
    if ! dotnet build --configuration Debug --no-restore -v quiet 2>&1; then
      BUILD_FAILED=1
    fi
    ;;
  spfx)
    # SPFx: type check sin build completo (más rápido)
    if ! npx tsc --noEmit 2>&1; then
      BUILD_FAILED=1
    fi
    ;;
  vite|node)
    if ! npx tsc --noEmit 2>&1; then
      BUILD_FAILED=1
    fi
    ;;
  *)
    echo -e "  ${YELLOW}⚠️  Tipo de proyecto no detectado. Saltando build check.${NC}"
    echo "     Configura el tipo en scripts/pre-commit-check.sh"
    ;;
esac

if [ $BUILD_FAILED -eq 1 ]; then
  echo ""
  echo -e "${RED}❌ Build fallido.${NC}"
  echo "   Corrige los errores de compilación antes de commitear."
  echo ""
  exit 1
fi

echo -e "  ${GREEN}✅ Build OK${NC}"

# ─────────────────────────────────────────
# LINT CHECK
# ─────────────────────────────────────────

echo "  🧹 Lint check..."

LINT_FAILED=0

case $PROJECT_TYPE in
  dotnet)
    # Solo verifica archivos staged en .NET
    if ! dotnet format --verify-no-changes --severity warn 2>&1; then
      LINT_FAILED=1
    fi
    ;;
  spfx|vite|node)
    # Solo lint de archivos staged
    STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(ts|tsx|js|jsx)$' || true)
    if [ -n "$STAGED_FILES" ]; then
      if ! npx eslint $STAGED_FILES --max-warnings=0 2>&1; then
        LINT_FAILED=1
      fi
    fi
    ;;
esac

if [ $LINT_FAILED -eq 1 ]; then
  echo ""
  echo -e "${YELLOW}⚠️  Lint con errores.${NC}"
  echo "   Corrige los errores de lint o usa --no-verify si es intencional."
  echo ""
  exit 1
fi

echo -e "  ${GREEN}✅ Lint OK${NC}"

# ─────────────────────────────────────────
# RESULTADO FINAL
# ─────────────────────────────────────────

echo ""
echo -e "${GREEN}✅ Pre-commit check pasado. Procediendo con el commit.${NC}"
echo ""

exit 0
