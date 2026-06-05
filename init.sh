#!/usr/bin/env bash
# init.sh — Verificación e inicialización del entorno.
# Idempotente: corre cuantas veces quieras desde la raíz del repo:
#   ./init.sh
#
# Comprueba prerrequisitos, valida estructura, valida feature_list.json,
# y deja los scripts con permisos de ejecución. No instala nada por su cuenta
# (no quiere decisiones implícitas) — reporta qué falta y cómo arreglarlo.

set -euo pipefail

# ---------- Colores ----------
if [[ -t 1 ]]; then
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  YELLOW=$'\033[0;33m'
  BLUE=$'\033[0;34m'
  BOLD=$'\033[1m'
  RESET=$'\033[0m'
else
  RED=""; GREEN=""; YELLOW=""; BLUE=""; BOLD=""; RESET=""
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

ERRORS=0
WARNINGS=0

# Parse mode: --phase1 adds docs/ completeness check
MODE="phase0"
for arg in "$@"; do
  [[ "$arg" == "--phase1" ]] && MODE="phase1"
done

log_ok()    { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
log_warn()  { printf "  ${YELLOW}!${RESET} %s\n" "$1"; WARNINGS=$((WARNINGS + 1)); }
log_err()   { printf "  ${RED}✗${RESET} %s\n" "$1"; ERRORS=$((ERRORS + 1)); }
section()   { printf "\n${BOLD}${BLUE}== %s ==${RESET}\n" "$1"; }

# ---------- 1. Prerrequisitos ----------
section "Prerrequisitos"

check_cmd() {
  local cmd="$1"
  local required="${2:-required}"  # required | optional
  if command -v "$cmd" >/dev/null 2>&1; then
    log_ok "$cmd disponible ($(command -v "$cmd"))"
  else
    if [[ "$required" == "required" ]]; then
      log_err "$cmd no encontrado en PATH"
    else
      log_warn "$cmd no encontrado (opcional)"
    fi
  fi
}

check_cmd git      required
check_cmd gh       required
check_cmd bash     required
check_cmd jq       required
check_cmd node     optional
check_cmd npm      optional
check_cmd dotnet   optional
check_cmd python3  optional

# ---------- 2. Estado git ----------
section "Estado git"

if [[ -d .git ]]; then
  log_ok "repositorio git inicializado"
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(detached)")
  log_ok "branch actual: ${current_branch}"
else
  log_err "este directorio no es un repositorio git. Ejecuta: git init"
fi

# ---------- 3. Archivos canónicos del harness ----------
section "Archivos canónicos del harness"

REQUIRED_FILES=(
  "AGENTS.md"
  "init.sh"
  "feature_list.json"
  "workflow/agents/orchestrator.md"
  "workflow/agents/explorer.md"
  "workflow/agents/designer.md"
  "workflow/agents/implementer.md"
  "workflow/agents/reviewer.md"
  "workflow/docs/checkpoint.md"
  "workflow/docs/workflow-conventions.md"
  "workflow/docs/definition-of-ready.md"
  "workflow/docs/issue-template.md"
  "workflow/docs/dev-review-checklist.md"
  "workflow/docs/workflow-levels.md"
  "workflow/specs/project-memory.md"
  "workflow/scripts/pre-commit-check.sh"
)

for f in "${REQUIRED_FILES[@]}"; do
  if [[ -f "$f" ]]; then
    log_ok "$f"
  else
    log_err "falta: $f"
  fi
done

# ---------- 4. Permisos de scripts ----------
section "Permisos de scripts"

SCRIPTS=(
  "init.sh"
  "workflow/scripts/pre-commit-check.sh"
)

for s in "${SCRIPTS[@]}"; do
  if [[ -f "$s" ]]; then
    if [[ -x "$s" ]]; then
      log_ok "$s ejecutable"
    else
      chmod +x "$s"
      log_ok "$s — chmod +x aplicado"
    fi
  fi
done

# ---------- 5. Validación de feature_list.json ----------
section "Validación de feature_list.json"

if [[ -f feature_list.json ]] && command -v jq >/dev/null 2>&1; then
  if jq empty feature_list.json >/dev/null 2>&1; then
    log_ok "JSON válido"

    project=$(jq -r '.project // "(falta)"' feature_list.json)
    [[ "$project" == "(falta)" ]] && log_err "feature_list.json: campo 'project' faltante" || log_ok "project: $project"

    if jq -e '.rules.valid_status | type == "array"' feature_list.json >/dev/null 2>&1; then
      log_ok "rules.valid_status definido"
    else
      log_err "feature_list.json: rules.valid_status debe ser un array"
    fi

    if jq -e '.features | type == "array"' feature_list.json >/dev/null 2>&1; then
      total=$(jq '.features | length' feature_list.json)
      log_ok "features: $total"

      invalid_status=$(jq -r '
        .rules.valid_status as $valid
        | .features
        | map(select(.status as $s | ($valid | index($s)) == null))
        | map("#\(.id) \(.name) → status=\(.status)")
        | .[]
      ' feature_list.json)

      if [[ -n "$invalid_status" ]]; then
        log_err "features con status inválido:"
        printf "    %s\n" "$invalid_status"
      else
        log_ok "todos los statuses son válidos"
      fi

      if jq -e '.rules.one_feature_at_a_time == true' feature_list.json >/dev/null 2>&1; then
        in_progress=$(jq '[.features[] | select(.status == "in_progress")] | length' feature_list.json)
        if (( in_progress > 1 )); then
          log_err "regla 'one_feature_at_a_time' violada: $in_progress features en in_progress"
        else
          log_ok "regla 'one_feature_at_a_time' respetada (in_progress: $in_progress)"
        fi
      fi
    else
      log_err "feature_list.json: 'features' debe ser un array"
    fi
  else
    log_err "feature_list.json: JSON inválido"
  fi
fi

# ---------- 6. checkpoint.md en estado template ----------
section "checkpoint.md"

CHECKPOINT="workflow/docs/checkpoint.md"
if [[ -f "$CHECKPOINT" ]]; then
  unchecked=$(grep -c '^- \[ \]' "$CHECKPOINT" || true)
  checked=$(grep -c '^- \[x\]' "$CHECKPOINT" || true)
  if (( checked == 0 )); then
    log_ok "checkpoint.md en estado template ($unchecked items pendientes — lo esperado)"
  else
    log_warn "checkpoint.md tiene $checked items marcados. ¿Sesión anterior sin cerrar? Revisa con el reviewer."
  fi
fi

# ---------- 7. Documentos de proyecto ----------
if [[ "$MODE" == "phase1" ]]; then
  section "Documentos de proyecto"

  REQUIRED_DOCS=(
    "docs/functional.md"
    "docs/architecture.md"
  )

  for doc in "${REQUIRED_DOCS[@]}"; do
    if [[ ! -f "$doc" ]]; then
      log_err "$doc — no existe. Ejecuta /setup-project antes de start-issue."
    elif [[ ! -s "$doc" ]]; then
      log_err "$doc — está vacío. Ejecuta /setup-project antes de start-issue."
    elif grep -q '\[COMPLETAR\]' "$doc"; then
      log_err "$doc — contiene secciones sin completar. Ejecuta /setup-project."
    else
      log_ok "$doc"
    fi
  done
fi

# ---------- 8. Resumen ----------
section "Resumen"

if (( ERRORS == 0 && WARNINGS == 0 )); then
  printf "${GREEN}${BOLD}Entorno OK.${RESET} Puedes empezar.\n"
  exit 0
elif (( ERRORS == 0 )); then
  printf "${YELLOW}${BOLD}Entorno listo con %d warning(s).${RESET}\n" "$WARNINGS"
  exit 0
else
  printf "${RED}${BOLD}Entorno NO listo: %d error(es), %d warning(s).${RESET}\n" "$ERRORS" "$WARNINGS"
  printf "Resuelve los errores marcados con ${RED}✗${RESET} y vuelve a correr ${BOLD}./init.sh${RESET}.\n"
  exit 1
fi
