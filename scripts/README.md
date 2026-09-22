# 🛠️ glot — CLI del monorepo / monorepo CLI

**ES:** `glot` convierte el ciclo de trabajo de un módulo —**situar, crear, ejecutar, delegar, cerrar y publicar**— en comandos reproducibles, y deja la evidencia en el repositorio. Es **tooling del monorepo**: no es un módulo del roadmap, no altera `.gitmodules` ni los contadores `X/50` de [`docs/ROADMAP.md`](../docs/ROADMAP.md).

**EN:** `glot` turns the per-module work cycle —**locate, create, run, delegate, close and publish**— into reproducible commands, and leaves the evidence in the repository. It is **monorepo tooling**: it is not a roadmap module, it touches neither `.gitmodules` nor the `X/50` counters in [`docs/ROADMAP.md`](../docs/ROADMAP.md).

Versión viva / Live version: **v0.9.0** en [`glot.sh`](glot.sh).

---

## 🎯 Objetivo y límites / Goal and boundaries

| Responsabilidad / Responsibility | Detalle / Detail |
|---|---|
| Resolver catálogo y estado | Lenguaje, fase, módulo, rama y especificación del trabajo en curso |
| Preparar el entorno | Directorio del módulo, rama de trabajo y, desde L9, la toolchain esperada |
| Ejecutar y verificar | Comandos nativos del lenguaje desde cualquier directorio, leyendo el estado |
| Crear el esqueleto | Inicializador del lenguaje y normalización de lo que deja (aplanar el nido, quitar el `.git` anidado), por dato y no por heurístico |
| Preparar los encargos de IA | Arma el encargo para el agente con las plantillas versionadas de [`prompts/`](prompts/); no lo ejecuta por su cuenta |
| Registrar la evidencia | Salidas reales, checklist de cierre, roadmap y puntero del submódulo |

**No-objetivos / Non-goals:** no es un módulo del roadmap ni toca `.gitmodules` o los contadores; no escribe documentación (la encarga y la valida); no sustituye al agente de VS Code; no publica nada que no se le pida explícitamente; no instala toolchains antes de L9; no es un gestor de proyectos.

El detalle de cada capa y el orden de las versiones están en [`docs/ROADMAP.md`](docs/ROADMAP.md).

---

## 🚀 Empezar / Quick start

```bash
cd "$REPO"                              # ruta de tu clon / path to your clone
./scripts/glot.sh version
./scripts/glot.sh doctor
./scripts/glot.sh langs
./scripts/glot.sh modules
./scripts/glot.sh progress
./scripts/glot.sh test php algorithms/naive_sort    # suite del módulo / module suite
./scripts/glot.sh verify php algorithms/naive_sort  # sintaxis/lint del lenguaje
./scripts/glot.sh evidence php algorithms/naive_sort  # acta con la salida real
./scripts/glot.sh -n close php algorithms/naive_sort   # cierre: diff exacto del roadmap
./scripts/glot.sh -n new php algorithms/naive_sort   # esqueleto: plan sin tocar nada
./scripts/glot.sh new php algorithms/naive_sort      # inicializador + normalización
./scripts/glot.sh prompt suite                        # encargo de la suite (paso 4b)
./scripts/glot.sh set lang php && ./scripts/glot.sh get lang
source <(./scripts/glot.sh completion bash)   # autocompletado / completion
```

---

## 📚 Documentación / Documentation

| Documento | Contenido |
|-----------|-----------|
| [`docs/ROADMAP.md`](docs/ROADMAP.md) | Capas L0–L9, versiones, criterios de orden y decisiones cerradas |
| [`docs/SPRINT.md`](docs/SPRINT.md) | El ciclo de módulo: 9 pasos, comandos, evidencias y encargos de IA |
| [`docs/CONTRACT.md`](docs/CONTRACT.md) | Contrato de todos los verbos, códigos de salida, almacén de estado y especificación de `use` |
| [`docs/INTERNALS.md`](docs/INTERNALS.md) | Cómo funciona el script por dentro |
| [`docs/VERSIONS.md`](docs/VERSIONS.md) | Log de versiones, archivado, requisitos y cómo verificar |
| [`docs/VALIDATION.md`](docs/VALIDATION.md) | Validador automático con GitHub Copilot CLI |
| [`../docs/WORKFLOW.md`](../docs/WORKFLOW.md) | Ciclo de trabajo del módulo: **norma del monorepo** (todos los lenguajes) |

---

## 📁 Estructura / Structure

```text
scripts/
├── README.md                 # Este archivo: qué es glot y mapa de la documentación
├── glot.sh                   # Versión viva / live version (v0.9.0)
├── completions/              # Autocompletado por shell (se imprime en stdout)
│   ├── glot.bash
│   └── glot.zsh
├── prompts/                  # Plantillas de encargo, versionadas
│   ├── scaffold.prompt.md        # Paso 4a · esqueleto
│   ├── suite.prompt.md           # Paso 4b · suite de pruebas
│   ├── implement.prompt.md       # Paso 5
│   ├── docs-module.prompt.md     # Paso 7
│   └── docs-language.prompt.md   # Paso 8
├── data/                     # Catálogo de datos del tooling
│   ├── README.md
│   ├── languages.tsv         # Un lenguaje por fila: init, manifiestos, pruebas, verificador e inicialización
│   ├── commits.tsv           # Un paso de sprint por fila: alias, ámbito y mensaje de commit
│   └── display.tsv           # Nombre de presentación por lenguaje, en el orden de las listas del roadmap
├── docs/                     # Documentación del tooling
│   ├── ROADMAP.md
│   ├── SPRINT.md
│   ├── CONTRACT.md
│   ├── INTERNALS.md
│   ├── VALIDATION.md
│   └── VERSIONS.md
├── tests/
│   └── glot_test.sh          # Harness de pruebas, sin dependencias
└── versions/                 # Snapshots de versiones cerradas
    ├── glot_0.1.0.sh
    ├── glot_0.2.0.sh
    ├── glot_0.3.0.sh
    ├── glot_0.4.0.sh
    ├── glot_0.5.0.sh
    ├── glot_0.6.0.sh
    ├── glot_0.7.0.sh
    └── glot_0.8.0.sh
```

---

## ⚙️ Seteo en `.bashrc` / Shell setup

**Hasta v1.0.0:** no hace falta cargarlo, se ejecuta directamente. Por eso el script sí usa `set -euo pipefail`: no se carga con `source`.

**Desde v1.0.0:** `glot` será además una función cargable —es la única forma de que `use` haga el `cd` real— y `install` escribirá la línea por ti. Mientras tanto, si quieres adelantarlo, usa una variable en lugar de una ruta fija:

```bash
# ~/.bashrc — ajusta REPO a la ruta de tu clon / point REPO at your clone
REPO="${REPO:-$HOME/programming_languages}"
source "$REPO/scripts/glot.sh"
```

> **ES:** Lo que esté en `glot.sh` es lo que cargará cada shell nuevo, así que la rama `main` debe quedar siempre en un estado cargable.
> **EN:** Whatever `glot.sh` contains is what every new shell will load, so the `main` branch must always stay in a loadable state.

---

## 🌿 Rama y flujo / Branch & flow

**ES:** Al ser un cambio solo-monorepo, sigue la regla de [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md): una rama corta por versión, `chore/repo/glot-v0.X`, fusionada en `main` cuando el snapshot ya está en `versions/`. Así `main` nunca queda con un `glot.sh` a medias que rompa los shells nuevos. Esa es también la **puerta de entrada**: ninguna versión se empieza a implementar sin el snapshot de la anterior en `versions/`; si falta, se copia primero y después se reanuda la implementación.

**EN:** As a monorepo-only change, follow [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md): one short branch per version, `chore/repo/glot-v0.X`, merged into `main` once the snapshot is in `versions/`. That way `main` never keeps a half-finished `glot.sh`.

---

## 🧭 Gobernanza / Governance

- **ES:** `scripts/` vive en el repositorio raíz (no en ningún submódulo) y no entra en los contadores del roadmap. Está documentado en la raíz: sección «Herramientas del monorepo» de [`README.md`](../README.md), scope `glot` y cierre de versión en [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md), límite del tooling en [`AGENTS.md`](../AGENTS.md), mención en [`docs/index.md`](../docs/index.md) (sitio GitHub Pages) y entrada en [`CHANGELOG.md`](../CHANGELOG.md).
- **EN:** `scripts/` lives in the root repository (not in any submodule) and is not part of the roadmap counters. It is documented at the root: the "Monorepo tooling" section in [`README.md`](../README.md), the `glot` scope and version closing in [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md), the tooling boundary in [`AGENTS.md`](../AGENTS.md), a mention in [`docs/index.md`](../docs/index.md) (GitHub Pages site) and an entry in [`CHANGELOG.md`](../CHANGELOG.md).
