#!/usr/bin/env bash
# glot 0.2.0 — Hello User del CLI del monorepo programming_languages.
#
# Snapshot archivado: versión cerrada el 2026-09-20. No se edita; el código es
# el mismo que tenía la versión viva en su cierre.
# Uso / Usage:
#   ./versions/glot_0.2.0.sh Ada

set -euo pipefail

name="${1:-}"

if [[ -z "$name" ]]; then
    printf 'Enter your name: '
    read -r name || name=''
fi

# Descarta el terminador CRLF si la entrada viene con salto de línea de Windows.
name="${name%$'\r'}"

printf 'Hello, %s!\n' "$name"
