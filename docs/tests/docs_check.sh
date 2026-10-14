#!/usr/bin/env bash
# Comprobaciones de documentación / Documentation checks
#
# ES: Este script vive en `docs/` a propósito: comprueba que **los documentos** no se
# separan de las fuentes que describen, y esa es responsabilidad de la documentación, no
# del tooling. `scripts/tests/glot_test.sh` no lee nada fuera de `scripts/`, así que las
# aserciones que miraban `docs/` viven aquí desde el 2026-10-13.
#
# EN: This script lives under `docs/` on purpose: it checks that **the documents** do not
# drift from the sources they describe, and that is the documentation's job, not the
# tooling's. `scripts/tests/glot_test.sh` reads nothing outside `scripts/`, so the
# assertions that looked at `docs/` live here since 2026-10-13.
#
# Uso / Usage: bash docs/tests/docs_check.sh
set -euo pipefail

TESTS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO="$(cd -- "$TESTS_DIR/../.." && pwd -P)"
GUIDE="$REPO/docs/core/00_Project_Initialization_Guide.md"
GUIDE_MASTER='/^## .*Master table/,/^## .*Multi-step sequences/'
DATA="$REPO/scripts/data"

# La sección se lee **una vez**: con `pipefail`, un `awk | grep -q` muere por SIGPIPE cuando
# `grep` acierta y sale antes, y la aserción se vuelve intermitente (medido el 2026-10-13).
guide_master="$(awk "$GUIDE_MASTER" "$GUIDE")"

passed=0
failed=0

_ok() { passed=$((passed + 1)); }
_ko() {
    failed=$((failed + 1))
    printf 'FAIL  %s\n      esperado / expected: %s\n      obtenido / actual:   %s\n' "$1" "$2" "$3"
}

assert_eq() { [[ "$2" == "$3" ]] && _ok || _ko "$1" "$2" "$3"; }
assert_contains() { [[ "$3" == *"$2"* ]] && _ok || _ko "$1" "$2" "$3"; }

# --- guía de inicialización ↔ catálogo / guide ↔ catalogue -------------------
# La guía es la **lectura humana** del catálogo: si las dos se separan, manda el catálogo
# y la guía se corrige. Esto es lo que antes comprobaba el harness del tooling.
guide_langs="$(awk -F'|' '/^\| \*\*[a-z]/ {gsub(/\*/,"",$2); gsub(/[ \t]/,"",$2); print $2}' <<<"$guide_master")"
assert_eq 'catálogo y guía: mismos lenguajes' "$guide_langs" "$(cut -f1 "$DATA/languages.tsv")"

guide_tests="$(awk -F'|' '/^\| \*\*[a-z]/ {print $5}' <<<"$guide_master" |
    LC_ALL=C sed 's/`//g; s/  */ /g; s/^ //; s/ $//; s/\xef\xb8\x8f//g; s/\xe2\x9c\x85//g; s/\xf0\x9f\x94\xa7//g; s/\xe2\x9c\x8d//g; s/  */ /g; s/^ //; s/ $//')"
assert_eq 'catálogo y guía: mismos comandos de pruebas' "$guide_tests" "$(cut -f3 "$DATA/languages.tsv")"

data_seq="$(awk -F'\t' 'FNR > 1 {print $1}' "$DATA/init_sequences.tsv" | LC_ALL=C sort -u)"
guide_seq="$(awk '/^## .*Multi-step sequences/,/^## .*Manual generation/' "$GUIDE" |
    awk -F'|' '/^\| \*\*[a-z]/ {gsub(/\*/,"",$2); gsub(/[ \t]/,"",$2); print $2}' | LC_ALL=C sort -u)"
CHAIN_MARK="$(printf '\xe2\x9b\x93')"
guide_chain="$(grep -F -- "$CHAIN_MARK" <<<"$guide_master" |
    awk -F'|' '/^\| \*\*[a-z]/ {gsub(/\*/,"",$2); gsub(/[ \t]/,"",$2); print $2}' | LC_ALL=C sort -u)"

assert_eq 'secuencias: el dato trae los 50 lenguajes' '50' "$(printf '%s\n' "$data_seq" | wc -l | tr -d ' ')"
assert_eq 'secuencias y guía: la sección no inventa lenguajes' '' \
    "$(comm -23 <(printf '%s\n' "$guide_seq") <(printf '%s\n' "$data_seq") | tr -d '\t' | tr -d ' ' | tr '\n' ' ')"
assert_eq 'secuencias y guía: lo marcado con la cadena está en el dato' '' \
    "$(comm -23 <(printf '%s\n' "$guide_chain") <(printf '%s\n' "$data_seq") | tr -d '\t' | tr -d ' ' | tr '\n' ' ')"

# la tabla maestra tiene que **renderizar** como tabla: es el defecto que obligó a
# convertirla de bloque alineado a tabla markdown (2026-10-13)
assert_eq 'guía: la tabla maestra es una tabla markdown' '50' \
    "$(grep -c '^| \*\*[a-z]' <<<"$guide_master" | tr -d ' ')"
assert_eq 'guía: la tabla maestra tiene cabecera y separador' 'si' \
    "$(grep -qE '^\| Lenguaje.*\|$' <<<"$guide_master" && echo si || echo no)"
assert_eq 'guía: la tabla de secuencias es una tabla markdown' "$(printf '%s\n' "$guide_seq" | wc -l | tr -d ' ')" \
    "$(awk '/^## .*Multi-step sequences/,/^## .*Manual generation/' "$GUIDE" | grep -c '^| \*\*[a-z]' | tr -d ' ')"
assert_eq 'guía: sin etiquetas de código sueltas' '0' \
    "$(grep -c '^\(bash\|text\|markdown\)$' "$GUIDE" | tr -d ' ')"
assert_eq 'guía: sin bloques indentados' '0' \
    "$(grep -c '^    [A-Za-zÁÉÍÓÚ]' "$GUIDE" | tr -d ' ' || true)"
assert_eq 'guía: marcas bilingües en negrita' '0' \
    "$(grep -c '^\(ES\|EN\):' "$GUIDE" | tr -d ' ' || true)"

# --- encargo del README ↔ plantilla / README request ↔ template --------------
docs_module_prompt="$(cat -- "$REPO/scripts/prompts/docs-module.prompt.md")"
assert_contains 'docs-module: remite a la plantilla' \
    'todas las secciones obligatorias de `docs/README_Template.md`' "$docs_module_prompt"
sections_named=0
while IFS= read -r title; do
    [[ -n "$title" ]] || continue
    grep -qF -- "$title" <<<"$docs_module_prompt" && sections_named=$((sections_named + 1))
done < <(sed -n 's/^## [^ ]* \(.*\) \/ .*$/\1/p' "$REPO/docs/README_Template.md")
assert_eq 'docs-module: no vuelve a enumerar las secciones' 'si' \
    "$([[ "$sections_named" -le 2 ]] && echo si || echo no)"

# --- política de CI ↔ documento del ciclo / CI policy ↔ cycle document -------
CI_POLICY="$REPO/docs/WORKFLOW.md"
assert_contains 'CI: la política vive donde vive el ciclo' 'CI por submódulo' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: el comando no se copia del catálogo' 'no se copia del catálogo, se le pide al catálogo' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: llama a los verbos del catálogo' '`glot test`' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: la CI comprueba y no firma' 'la CI comprueba y no firma' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: la CI no escribe el acta' 'no escribe' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: el SAST del repositorio no es verify' 'no el verbo `verify`' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: el workflow que copia queda como excepción' 'excepción declarada' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: la excepción se nombra' 'ada/.github/workflows/tests.yml' "$(cat -- "$CI_POLICY")"

# --- creadores de carpeta ↔ guía / folder creators ↔ guide -------------------
# La regla del directorio de trabajo: quien crea la carpeta se lanza desde la fase, y la
# guía tiene que nombrarlos. La mitad del catálogo la comprueba el harness; esta es la de
# la guía. Con `pipefail`, la sección se lee una vez y se busca sobre el texto ya leído.
CREATORS='ballerina crystal d dart elixir erlang gleam'
guide_seq_body="$(awk '/^## .*Multi-step sequences/,/^## .*Manual generation/' "$GUIDE")"
missing_creator=""
for lang in $CREATORS; do
    grep -q -- "$lang" <<<"$guide_seq_body" || missing_creator+="$lang "
done
assert_eq 'guía: nombra los creadores de carpeta' '' "$missing_creator"

# --- registros de auditoría ↔ índice / audit records ↔ index -----------------
# Un módulo auditado tiene registro y el índice lo enseña: los dos conjuntos coinciden.
AUDITS="$REPO/docs/audits"
index_rows="$(grep -oE '\]\(([0-9]{2}_Audited_[^)]+\.md)\)' "$AUDITS/README.md" | sed 's/^](//; s/)$//' | LC_ALL=C sort)"
files="$(cd "$AUDITS" && ls [0-9][0-9]_Audited_*.md 2>/dev/null | LC_ALL=C sort)"
assert_eq 'auditorías: el índice y los registros coinciden' "$index_rows" "$files"
balanced_50="$(grep -cE '^core\.[a-z_]+\.[a-z_0-9]+[[:space:]]+✅ 50/50' "$REPO/docs/ROADMAP.md" | tr -d ' ')"
assert_eq 'auditorías: hay registro para cada módulo a 50/50' "$balanced_50" \
    "$(printf '%s\n' "$files" | grep -c '_Audited_' | tr -d ' ')"

# --- registros de auditoría ↔ estados / audit records ↔ states ----------------
# Los cuatro estados del marco tienen que existir como secciones en cada registro:
# fallo, advertencia, aceptado por el autor y homologado (2026-10-13).
missing_states=""
for rec in $files; do
    for sec in 'Requieren Refactorización' 'Advertencias' 'Aceptados por el autor' 'Homologados'; do
        grep -qF -- "$sec" "$AUDITS/$rec" || missing_states+="$rec:$sec "
    done
done
assert_eq 'auditorías: los registros traen los cuatro estados' '' "$missing_states"

printf '\ndocs checks: %s passed, %s failed\n' "$passed" "$failed"
[[ "$failed" -eq 0 ]]
