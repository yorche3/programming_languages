# 🛠️ glot — CLI del monorepo / monorepo CLI

`glot` es el script de práctica del propio repositorio: igual que los lenguajes del roadmap empiezan por un `helloworld`, `glot` empieza por su «hello world» en Bash (v0.1.0) y crece versión a versión. Es **tooling del monorepo**: no es un módulo del roadmap, no altera `.gitmodules` ni los contadores `X/49` de [`docs/ROADMAP.md`](../docs/ROADMAP.md).

Versión viva / Live version: **v0.3.0** en [`glot.sh`](glot.sh).

---

## 📁 Estructura / Structure

```text
scripts/
├── README.md                 # Este archivo / This file
├── glot.sh                   # Versión viva / live version (v0.3.0)
├── tests/
│   └── glot_test.sh          # Harness de pruebas, sin dependencias
└── versions/                 # Snapshots de versiones cerradas
    ├── glot_0.1.0.sh
    └── glot_0.2.0.sh
```

| Archivo | Propósito |
|---------|-----------|
| [`glot.sh`](glot.sh) | Versión en desarrollo del CLI. Hoy: dispatcher de verbos (L0) con `version`, `help`, `doctor`, `greet` y `hello`. |
| [`tests/glot_test.sh`](tests/glot_test.sh) | Harness propio: ejecuta `glot.sh` real y comprueba contrato, verbos y códigos de salida. |
| [`versions/glot_0.1.0.sh`](versions/glot_0.1.0.sh) | Foto inmutable de la v0.1.0: `echo "Hello World! from Bash!"`. |
| [`versions/glot_0.2.0.sh`](versions/glot_0.2.0.sh) | Foto inmutable de la v0.2.0: nombre por argumento, stdin o prompt. |

---

## 🚀 Funcionamiento actual / Current behaviour (v0.3.0)

**ES:** El script es un **dispatcher de verbos** con el contrato L0: `stdout` solo lleva datos, `stderr` solo diagnóstico, y los códigos de salida son estables. No asume ninguna ruta del usuario: se localiza con `BASH_SOURCE` y resuelve la raíz del monorepo por `GLOT_ROOT`, el superproyecto o la raíz de git. Se ejecuta; no hace falta cargarlo.

**EN:** The script is a **verb dispatcher** implementing the L0 contract: `stdout` carries data only, `stderr` diagnostics only, and exit codes are stable. It assumes no user path: it locates itself through `BASH_SOURCE` and resolves the monorepo root from `GLOT_ROOT`, the superproject or the git root. It is executed; sourcing is not needed.

```bash
cd "$REPO"                              # ruta de tu clon / path to your clone
./scripts/glot.sh version
./scripts/glot.sh help
./scripts/glot.sh doctor
./scripts/glot.sh greet Ada
printf 'Ada\n' | ./scripts/glot.sh greet
```

| Verbo | Comportamiento | Código |
|-------|----------------|:------:|
| `version`, `--version` | Versión instalada | 0 |
| `help [verbo]` | Ayuda general o de un verbo | 0 |
| `doctor` | Diagnóstico: bash, git, raíz del monorepo y ruta prevista del estado | 0 / 1 |
| `greet [nombre]` | `Hello, <nombre>!` con el nombre por argumento o por stdin | 0 / 2 |
| `hello [nombre]` | Igual que `greet` (compatibilidad v0.2.0, se retira en v1.0.0) | 0 / 2 |

**Salidas reales / Actual output:**

```text
$ ./scripts/glot.sh version
glot 0.3.0
```

```text
$ ./scripts/glot.sh greet Ada
Hello, Ada!
$ printf 'Ada\n' | ./scripts/glot.sh greet
Hello, Ada!
```

```text
$ ./scripts/glot.sh doctor
glot doctor — diagnóstico / diagnostics
version: 0.3.0
script_dir: /home/yorche3/programming_languages/scripts
bash: 5.2.21(1)-release
bash_ok: yes
git: git version 2.43.0
root: /home/yorche3/programming_languages
state_dir: /home/yorche3/.local/state/glot (se creará en v0.4.0 / will be created in v0.4.0)
```

```text
$ ./scripts/glot.sh nope
glot: error: verbo desconocido / unknown verb: nope
si querías el saludo / if you meant the greeting: glot greet nope
glot: prueba / try: glot help
$ echo $?
2
```

> **ES:** El encabezado de `doctor` y los avisos van a `stderr`, así que con `-q` la salida de `stdout` queda lista para parsear (`clave: valor`). Las rutas que aparecen en esa salida son las detectadas en tu entorno, no constantes del script.
> **EN:** `doctor`'s header and warnings go to `stderr`, so with `-q` the `stdout` output is ready to parse (`key: value`). The paths shown in that output are detected in your environment, not constants baked into the script.

---

## 🔍 Cómo funciona por dentro / How it works internally

**ES:** Recorrido del script v0.3.0, del argumento al código de salida. No es documentación línea a línea: solo lo necesario para leerlo, entender las decisiones raras y extenderlo.

**EN:** A walkthrough of the v0.3.0 script, from argument to exit code. It is not line-by-line documentation: just what is needed to read it, understand the odd decisions and extend it.

### 1. Arranque y localización / Startup and self-location

1. `set -euo pipefail` al principio: como el archivo se **ejecuta**, cualquier orden que falle detiene el script y el `return` de un verbo se convierte en su código de salida. Esta línea desaparecerá cuando el archivo se cargue con `source` (v0.5.0), porque ahí no puede tocar las opciones del shell.
2. `GLOT_VERSION="0.3.0"` es la única constante propia; el resto de funciones y variables internas llevan el prefijo `_glot_` para poder cargarse más adelante sin contaminar el entorno.
3. `GLOT_SCRIPT_DIR` se obtiene de `BASH_SOURCE[0]`, resolviendo enlaces simbólicos con `readlink` y normalizando con `cd … && pwd -P`. Es lo que permite invocar el script desde cualquier directorio (o desde un enlace) sin rutas fijas.

### 2. Lectura de argumentos / Argument parsing

1. **Primero los flags globales**: un bucle consume `-q`/`--quiet` mientras aparezcan *antes* del verbo y activa `_glot_quiet`; al primer argumento que no es flag, el bucle corta.
2. **El primer argumento libre es el verbo**; el resto se conserva intacto y se pasa al verbo (`greet Ada` → verbo `greet`, argumento `Ada`).
3. Sin argumentos, `cmd` queda vacío y comparte rama con `help`: un CLI que no recibe nada y pide ayuda es preferible a uno que falla.

### 3. Despacho / Dispatch

Un `case` sobre `cmd` elige el camino; cada rama llama a un `_glot_cmd_*`:

| Entrada | Rama | Efecto |
|---------|------|--------|
| `""`, `help`, `-h`, `--help` | `_glot_cmd_help "$@"` | Ayuda general, o la del verbo si se pasa uno |
| `version`, `-V`, `--version` | `_glot_cmd_version` | Imprime la versión |
| `doctor` | `_glot_cmd_doctor` | Recoge el entorno y devuelve `0`/`1` |
| `greet`, `hello` | `_glot_cmd_greet "$@"` | Saludo; `hello` es el alias de compatibilidad v0.2.0 |
| otra opción (`-*`) | error de uso | `2` y mensaje en `stderr` |
| cualquier otra cosa | error de verbo | `2`, sugiere `glot greet <algo>` y `glot help` |

> **ES:** La última rama es deliberada: **no** intenta adivinar si era un nombre (eso hacía v0.2.0) porque un error de tecleo debe fallar rápido, no saludar.
> **EN:** The last branch is deliberate: it does **not** guess whether the argument was a name (v0.2.0 did), because a typo must fail fast instead of greeting.

### 4. Qué hace cada verbo / What each verb does

| Verbo | Lee | Decide | Escribe | Devuelve |
|-------|-----|--------|---------|:--------:|
| `version` | — | — | `glot 0.3.0` en stdout | `0` |
| `help [verbo]` | El verbo opcional | Si hay verbo, ayuda corta; si no, tabla general | stdout | `0`, o `2` si el verbo no existe |
| `doctor` | bash, git, raíz del monorepo, ruta del estado | Marca `1` si falta bash 4+, git o la raíz | `clave: valor` en stdout; encabezado y avisos en stderr | `0` o `1` |
| `greet [nombre]` | El argumento; si no hay, una línea de stdin | Si stdin es terminal falla sin bloquearse; descarta el CRLF final | `Hello, <nombre>!` en stdout | `0`, o `2` sin nombre |

Detalles no evidentes / Non-obvious details:

- **`[[ -t 0 ]]`** evita quedarse esperando entrada cuando se ejecuta `glot greet` a mano en una terminal: prefiere fallar con un mensaje útil antes que colgarse.
- **`IFS= read -r name || true`** lee una línea sin interpretar barras invertidas y sin abortar por `set -e` si llega EOF.
- **`${name%$'\r'}`** descarta el terminador CRLF, igual que los módulos `hellouser` de los lenguajes.
- **`_glot_repo_root`** busca la raíz en este orden: `GLOT_ROOT` → `git rev-parse --show-superproject-working-tree` (así detecta el monorepo cuando estás dentro de un submódulo) → `git rev-parse --show-toplevel`. Si no encuentra ninguna, no inventa una ruta: `doctor` lo informa y devuelve `1`.
- **`_glot_state_dir`** solo calcula la ruta del estado (`$XDG_STATE_HOME/glot` o `~/.local/state/glot`); el almacén que la usará llega en v0.4.0, por eso `doctor` dice «se creará en v0.4.0».

### 5. Salida y códigos / Output and exit codes

1. Los verbos escriben **solo datos** en stdout; los errores salen por `_glot_error` y los avisos por `_glot_warn`, ambos a stderr.
2. `_glot_info` escribe en stderr salvo que se haya pasado `-q/--quiet`; de ahí que `doctor -q` deje stdout parseable.
3. El código final del script es el del verbo: la última orden del archivo es `glot "$@"`, y con `set -e` un `return 2` dentro de un verbo termina el script con `2`.

### 6. Lo que todavía no hace / What it does not do yet

No hay estado persistente ni rutas por lenguaje: eso es L1 (v0.4.0) y L2 (v0.5.0). Las claves `lang`, `module` y `branch` ya están reservadas en la especificación, pero ningún verbo las escribe todavía.

---

## ⚙️ Seteo en `.bashrc` / Shell setup

**Hasta v0.4.0:** no hace falta cargarlo, se ejecuta directamente (por eso el script sí usa `set -euo pipefail`: no se carga con `source`).

**Desde v0.5.0:** `glot` pasará a ser una función y se cargará al arrancar el shell. Usa una variable en lugar de una ruta fija:

```bash
# ~/.bashrc — ajusta REPO a la ruta de tu clon / point REPO at your clone
REPO="${REPO:-$HOME/programming_languages}"
source "$REPO/scripts/glot.sh"
```

Comprobar que quedó cargado:

```bash
type glot
```

> **ES:** Lo que esté en `glot.sh` es lo que cargará cada shell nuevo, así que la rama `main` debe quedar siempre en un estado cargable (ver «Rama y flujo»).
> **EN:** Whatever `glot.sh` contains is what every new shell will load, so the `main` branch must always stay in a loadable state (see "Branch & flow").

---

## 🧾 Log de versiones / Version log

| Versión | Fecha | Archivo | Añade | Estado |
|---------|-------|---------|-------|:------:|
| 0.1.0 | 2026-09-20 | `versions/glot_0.1.0.sh` | Hello World en Bash (`echo "Hello World! from Bash!"`) | ✅ cerrada |
| 0.2.0 | 2026-09-20 | `versions/glot_0.2.0.sh` | Nombre por argumento o por entrada estándar y saludo `Hello, <nombre>!` (equivalente a `hellouser`) | ✅ cerrada |
| 0.3.0 | 2026-09-20 | `glot.sh` | **Contrato y dispatcher** (L0): `version`, `help`, `doctor`, `greet`, `hello`, sin rutas del usuario, más harness de pruebas propio | 🔄 viva |
| 0.4.0 | — | `glot.sh` | **Almacén clave/valor** (L1): `set`, `get`, `unset`, `list`, `path`, con el estado en XDG | ⏳ propuesta |
| 0.5.0 | — | `glot.sh` | **`use <lenguaje> <módulo>` (L2)** validado contra `.gitmodules`, y función cargable con `source` para el `cd` | ⏳ propuesta |
| 0.6.0 | — | `glot.sh` | **`test` (L3)**: ejecuta el comando nativo del lenguaje y módulo asignados; `status` y `doctor` ampliados | ⏳ propuesta |
| 0.7.0 | — | `glot.sh` | Autocompletado (`complete -F _glot_complete glot`) | ⏳ propuesta |

### 0.1.0 — 2026-09-20 (cerrada)

- **Añade:** `echo "Hello World! from Bash!"`, el equivalente del `helloworld` de los lenguajes aplicado al tooling del repositorio.
- **Cómo se usaba:** `./scripts/glot.sh`.
- **Snapshot:** [`versions/glot_0.1.0.sh`](versions/glot_0.1.0.sh), archivado al abrir la v0.2.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real → `Hello World! from Bash!`, código de salida `0`.

### 0.2.0 — 2026-09-20 (cerrada)

- **Añade:** el nombre llega como argumento (`./scripts/glot.sh Ada`) o por la entrada estándar; si no llega por ninguna de las dos vías, el script pregunta `Enter your name: ` y lee con `read -r`.
- **Equivalencia:** es el `hellouser` del tooling (especificación 02_Hello_User): pide el nombre, lo guarda en una variable y saluda.
- **Snapshot:** [`versions/glot_0.2.0.sh`](versions/glot_0.2.0.sh), archivado al abrir la v0.3.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real de las tres vías → `Hello, Ada!` (`rc=0`), `Enter your name: Hello, Ada!` (`rc=0`) y `Hello, Grace Hopper!` con entrada `printf 'Grace Hopper\r\n'`.
- **Notas:** `read -r` evita que se interpreten las barras invertidas; `${name%$'\r'}` descarta el terminador CRLF, igual que los módulos `hellouser` de los lenguajes; con entrada vacía (EOF) imprime `Enter your name: Hello, !` y devuelve `0`, sin abortar pese a `set -e`.

### 0.3.0 — 2026-09-20 (viva)

- **Añade:** el contrato L0 y el dispatcher de verbos: `version`, `help [verbo]`, `doctor` y `greet [nombre]`, con `stdout` = datos, `stderr` = diagnóstico y códigos `0/1/2`; y el harness `scripts/tests/glot_test.sh` (39 comprobaciones, sin dependencias).
- **Sin rutas del usuario:** el script se localiza con `BASH_SOURCE` y resuelve la raíz con `GLOT_ROOT` → superproyecto → raíz git; la documentación usa variables en lugar de rutas fijas.
- **Cambios respecto a v0.2.0:** se retira el prompt interactivo (los verbos nunca preguntan: el dato llega por argumento o stdin) y un primer argumento que no es verbo ya no se interpreta como nombre: devuelve `2` con la sugerencia `glot greet <nombre>`. El saludo de v0.2.0 se conserva como verbo `hello`, que se retira en v1.0.0.
- **Verificación:** `bash -n` limpio en `glot.sh`, el harness y el snapshot; `./scripts/tests/glot_test.sh` → `glot tests: 39 passed, 0 failed` (rc `0`); `doctor` dentro del monorepo rc `0` y fuera rc `1` con `root: (no detectado / not detected)`.
- **Documentación:** sección «Cómo funciona por dentro», con el recorrido de los argumentos, la tabla de despacho, qué lee y decide cada verbo y los detalles no evidentes (`-t 0`, `read -r`, CRLF, resolución de la raíz).
- **Snapshot:** se archivará en `versions/glot_0.3.0.sh` al cerrar la versión.

---

## 📐 Especificación v0.3.0 (en desarrollo) / v0.3.0 specification

**ES:** Versión dedicada a la **capa de contrato (L0)**: el dispatcher de verbos y las reglas que reutilizarán todas las versiones siguientes. No incluye almacenamiento; el estado (L1) llega en la v0.4.0.

**EN:** This version covers the **contract layer (L0)**: the verb dispatcher and the rules every following version will reuse. It does not include storage; the state (L1) arrives in v0.4.0.

### Decisiones confirmadas / Confirmed decisions

| Tema | Decisión |
|------|----------|
| Alcance de v0.3.0 | Solo L0: contrato y dispatcher |
| Claves reservadas | `lang`, `module` y `branch` documentadas ya, aunque sus verbos lleguen después |
| Verificación | Harness propio en `scripts/tests/`, sin dependencias externas (`bats` y `jq` no están instalados) |
| Estado (desde v0.4.0) | XDG: `$XDG_STATE_HOME/glot/…` con fallback `~/.local/state/glot/` y override `GLOT_STATE_FILE` |
| Ejecución | Script ejecutado; la función cargable con `source` llega en v0.5.0, cuando `use` necesite cambiar el shell |
| Rutas | Sin rutas del usuario: el script se localiza con `BASH_SOURCE` y la raíz se resuelve con `GLOT_ROOT` → superproyecto → raíz git; la documentación usa variables |

### Contrato de todos los verbos / Verb contract

| Regla | Detalle |
|-------|---------|
| stdout | Solo el dato (así `$(glot get lang)` será utilizable en v0.4.0) |
| stderr | Diagnóstico, avisos y errores |
| Códigos de salida | `0` correcto · `1` error de entorno o dato ausente · `2` uso incorrecto · `3` estado ilegible o no escribible |
| Flags | `-h/--help` (general y por verbo), `--version`, `-q/--quiet`; `-n/--dry-run` se añadirá con el primer verbo que muta (v0.4.0) |
| Interacción | Un verbo nunca pregunta: el dato llega por argumento o por stdin |
| Idempotencia | Repetir el mismo efecto no cambia el resultado ni el código de salida |
| Testabilidad | La raíz del repo y (desde v0.4.0) la ruta del estado son inyectables por variable |

### Verbos de v0.3.0 / v0.3.0 verbs

| Verbo | Comportamiento | Código |
|-------|----------------|:------:|
| `version`, `--version` | `glot 0.3.0` | 0 |
| `help`, `-h`, `--help`, `help <verbo>` | Ayuda general o de un verbo | 0 |
| `doctor` | Diagnóstico: versión de bash, git, raíz del monorepo y ruta prevista del estado | 0 / 1 |
| `greet [nombre]` | `Hello, <nombre>!` con el nombre por argumento o por stdin | 0 / 2 |
| `hello [nombre]` | Igual que `greet`; compatibilidad con v0.2.0, se retira en v1.0.0 | 0 / 2 |
| Verbo desconocido | Error en stderr, sugerencia de `greet`/`help`; un nombre suelto ya no vale | 2 |

> **ES:** La compatibilidad con v0.2.0 se hace con el verbo explícito `hello`, no interpretando un nombre suelto: `glot Ada` devuelve `2` y sugiere `glot greet Ada`.
> **EN:** v0.2.0 compatibility is provided by the explicit `hello` verb, not by treating a bare name as input: `glot Ada` returns `2` and suggests `glot greet Ada`.

### Fuera de alcance / Out of scope

Almacén `set/get/unset/list/path` (v0.4.0), `use <lenguaje> <módulo>` (v0.5.0), `test` y `status` (v0.6.0) y autocompletado (v0.7.0).

### Verificación / Verification

`scripts/tests/` con runner propio y sin dependencias; cada caso trabaja en un directorio temporal (`mktemp -d`) para no tocar nada del usuario. Casos previstos: formato de `version`; `help` general y `help <verbo>`; verbo desconocido → `2`; `greet Ada` y `printf 'Ada\n' | glot greet`; silencio con `-q`; `doctor` dentro del monorepo (detecta la raíz) y fuera de él; y que `glot version | wc -l` devuelva exactamente `1` (stdout limpio, sin diagnóstico).

**DoD de la versión:** `bash -n` limpio, harness en verde, README y log al día, snapshot en `versions/` y rama `chore/repo/glot-v0.3` fusionada en `main`.

---

## 🔖 Convención de versiones y archivado / Versioning & archiving

- **SemVer** `MAJOR.MINOR.PATCH`; el número vive en el encabezado de `glot.sh` y en la tabla de este README (desde v0.3.0 también en `glot version`).
- **Cierre de versión:** copiar `glot.sh` a `versions/glot_<versión>.sh`, marcar la fila del log como `✅` y empezar la versión siguiente en `glot.sh`.
- Los snapshots de `versions/` **no se editan**: son la foto de cómo estaba el script en esa versión y permiten ver la progresión.
- `versions/` ya contiene [`glot_0.1.0.sh`](versions/glot_0.1.0.sh), el snapshot de la primera versión cerrada.

---

## ✅ Requisitos / Requirements

| Herramienta | Uso | Verificación |
|-------------|-----|--------------|
| Bash 5.2 | Ejecutar `glot.sh` y, desde v0.5.0, cargarlo con `source` | `bash --version` |
| Git 2.43 | Desde v0.3.0: `doctor` resuelve la raíz con `git rev-parse --show-superproject-working-tree` | `git --version` |

---

## 🧪 Cómo verificar / How to verify

```bash
bash -n scripts/glot.sh              # sintaxis
./scripts/tests/glot_test.sh        # contrato, verbos y códigos (39 comprobaciones)
./scripts/glot.sh doctor            # diagnóstico del entorno
```

`shellcheck` no está instalado en este entorno; conviene añadirlo a la verificación cuando exista CI.

---

## 🧱 Reglas de diseño / Design rules

### Contrato de todos los verbos (desde v0.3.0)

1. **stdout solo dato, stderr solo diagnóstico**, para que la salida se pueda canalizar y capturar.
2. **Códigos de salida estables**: `0` correcto, `1` error de entorno o dato ausente, `2` uso incorrecto, `3` estado ilegible o no escribible.
3. **Nunca preguntar** en un verbo: el dato llega por argumento o stdin.
4. **Idempotencia** cuando se repite el mismo efecto.
5. **Inyectable para test**: raíz del repo y ruta del estado sobreescribibles por variable (`GLOT_ROOT`, `GLOT_STATE_FILE`).
6. **Mensajes bilingües ES/EN** en `help`, `doctor` y errores; los datos de salida (como `Hello, Ada!`) no se traducen.
7. **Namespace**: funciones y variables internas con prefijo `_glot_`; públicas solo `GLOT_VERSION`, `GLOT_ROOT` y `GLOT_STATE_FILE`.

### Reglas cuando sea cargable con `source` (desde v0.5.0)

8. **Sin `exit`, sin tocar opciones globales del shell** (`set -e`, `IFS`) ni el directorio actual fuera de un verbo que lo pida explícitamente; todo sale con `return`.
9. **Raíz del monorepo**: `GLOT_ROOT` → superproyecto → raíz git, para que funcione también desde dentro de un submódulo.

---

## 🧭 Gobernanza / Governance

- **ES:** `scripts/` vive en el repositorio raíz (no en ningún submódulo) y no entra en los contadores del roadmap. Está documentado en la raíz: sección «Herramientas del monorepo» de [`README.md`](../README.md), scope `glot` y cierre de versión en [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md), límite del tooling en [`AGENTS.md`](../AGENTS.md), mención en [`docs/index.md`](../docs/index.md) (sitio GitHub Pages) y entrada en [`CHANGELOG.md`](../CHANGELOG.md).
- **EN:** `scripts/` lives in the root repository (not in any submodule) and is not part of the roadmap counters. It is documented at the root: the "Monorepo tooling" section in [`README.md`](../README.md), the `glot` scope and version closing in [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md), the tooling boundary in [`AGENTS.md`](../AGENTS.md), a mention in [`docs/index.md`](../docs/index.md) (GitHub Pages site) and an entry in [`CHANGELOG.md`](../CHANGELOG.md).

---

## 🌿 Rama y flujo / Branch & flow

**ES:** Al ser un cambio solo-monorepo, sigue la regla de [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md): rama corta desde `main` con formato `chore/repo/<módulo>`, por ejemplo `chore/repo/glot`. Recomendado: una rama por versión y fusionar en `main` al cerrarla (cuando el snapshot ya está en `versions/`), para que `main` nunca quede con un `glot.sh` a medias que rompa los shells nuevos.

**EN:** As a monorepo-only change, follow [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md): a short branch from `main` named `chore/repo/<module>`, for example `chore/repo/glot`. Recommended: one branch per version, merged into `main` when the version closes (once the snapshot is in `versions/`), so `main` never keeps a half-finished `glot.sh` that breaks new shells.

