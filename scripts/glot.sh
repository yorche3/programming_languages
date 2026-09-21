#!/usr/bin/env bash
# glot 0.2.0 — Hello User del CLI del monorepo programming_languages.
#
# Equivalente a la especificación 02_Hello_User aplicada al tooling: pide un
# nombre y muestra el saludo. El nombre puede llegar como argumento o por stdin.
#
# Versión viva del script: las versiones cerradas se archivan en versions/.
# Uso / Usage:
#   ./scripts/glot.sh Ada                  # nombre como argumento
#   printf 'Ada\n' | ./scripts/glot.sh     # nombre por entrada estándar
#   ./scripts/glot.sh                      # interactivo: pregunta el nombre

set -euo pipefail

name="${1:-}"

if [[ -z "$name" ]]; then
    printf 'Enter your name: '
    read -r name || name=''
fi

# Descarta el terminador CRLF si la entrada viene con salto de línea de Windows.
name="${name%$'\r'}"

printf 'Hello, %s!\n' "$name"