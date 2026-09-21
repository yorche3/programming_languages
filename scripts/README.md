# 🛠️ glot — CLI del monorepo / monorepo CLI

`glot` es el script de práctica del propio repositorio: igual que los lenguajes del roadmap empiezan por un `helloworld`, `glot` empieza por su «hello world» en Bash (v0.1.0) y crece versión a versión. Es **tooling del monorepo**: no es un módulo del roadmap, no altera `.gitmodules` ni los contadores `X/49` de [`docs/ROADMAP.md`](../docs/ROADMAP.md).

Versión viva / Live version: **v0.2.0** en [`glot.sh`](glot.sh).

---

## 📁 Estructura / Structure

```text
scripts/
├── README.md                 # Este archivo / This file
├── glot.sh                   # Versión viva / live version (v0.2.0)
└── versions/                 # Snapshots de versiones cerradas
    └── glot_0.1.0.sh
```

| Archivo | Propósito |
|---------|-----------|
| [`glot.sh`](glot.sh) | Versión en desarrollo del CLI. Hoy: pide un nombre y saluda (`Hello, <nombre>!`). |
| [`versions/glot_0.1.0.sh`](versions/glot_0.1.0.sh) | Foto inmutable de la v0.1.0: `echo "Hello World! from Bash!"`. |

---

## 🚀 Funcionamiento actual / Current behaviour (v0.2.0)

**ES:** El script pide un nombre y muestra `Hello, <nombre>!`. El nombre puede llegar de tres formas: como argumento, por la entrada estándar o de forma interactiva. No se carga con `source` ni necesita `.bashrc`: se ejecuta.

**EN:** The script asks for a name and prints `Hello, <name>!`. The name can arrive in three ways: as an argument, through standard input, or interactively. It is not sourced and does not need `.bashrc`: it is executed.

```bash
cd /home/yorche3/programming_languages
./scripts/glot.sh Ada                    # 1) argumento / argument
printf 'Ada\n' | ./scripts/glot.sh       # 2) entrada estándar / standard input
./scripts/glot.sh                        # 3) interactivo: pregunta el nombre
```

**Salidas reales / Actual output:**

```text
$ ./scripts/glot.sh Ada
Hello, Ada!
```

```text
$ printf 'Ada\n' | ./scripts/glot.sh
Enter your name: Hello, Ada!
```

El prompt queda en la misma línea que la entrada porque no se imprime un salto de línea después de `Enter your name: `.
The prompt stays on the same line as the input because no newline is printed after `Enter your name: `.

---

## ⚙️ Seteo en `.bashrc` / Shell setup

**Hasta v0.2.0:** no hace falta cargarlo, se ejecuta directamente (por eso el script sí usa `set -euo pipefail`: no se carga con `source`).

**Desde v0.3.0:** `glot` pasará a ser una función y se cargará al arrancar el shell:

```bash
# ~/.bashrc
source /home/yorche3/programming_languages/scripts/glot.sh
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
| 0.2.0 | 2026-09-20 | `glot.sh` | Nombre por argumento o por entrada estándar y saludo `Hello, <nombre>!` (equivalente a `hellouser`) | 🔄 viva |
| 0.3.0 | — | `glot.sh` | **Contrato y dispatcher** de verbos (L0) y harness de pruebas propio, con las claves del manager reservadas | 📐 especificada |
| 0.4.0 | — | `glot.sh` | **Almacén clave/valor** (L1): `set`, `get`, `unset`, `list`, `path`, con el estado en XDG | ⏳ propuesta |
| 0.5.0 | — | `glot.sh` | **`use <lenguaje> <módulo>` (L2)** validado contra `.gitmodules`, y función cargable con `source` para el `cd` | ⏳ propuesta |
| 0.6.0 | — | `glot.sh` | **`test` (L3)**: ejecuta el comando nativo del lenguaje y módulo asignados; `status` y `doctor` ampliados | ⏳ propuesta |
| 0.7.0 | — | `glot.sh` | Autocompletado (`complete -F _glot_complete glot`) | ⏳ propuesta |

### 0.1.0 — 2026-09-20 (cerrada)

- **Añade:** `echo "Hello World! from Bash!"`, el equivalente del `helloworld` de los lenguajes aplicado al tooling del repositorio.
- **Cómo se usaba:** `./scripts/glot.sh`.
- **Snapshot:** [`versions/glot_0.1.0.sh`](versions/glot_0.1.0.sh), archivado al abrir la v0.2.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real → `Hello World! from Bash!`, código de salida `0`.

### 0.2.0 — 2026-09-20 (viva)

- **Añade:** el nombre llega como argumento (`./scripts/glot.sh Ada`) o por la entrada estándar; si no llega por ninguna de las dos vías, el script pregunta `Enter your name: ` y lee con `read -r`.
- **Equivalencia:** es el `hellouser` del tooling (especificación 02_Hello_User): pide el nombre, lo guarda en una variable y saluda.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real de las tres vías → `Hello, Ada!` (`rc=0`), `Enter your name: Hello, Ada!` (`rc=0`) y `Hello, Grace Hopper!` con entrada `printf 'Grace Hopper\r\n'`.
- **Notas:** `read -r` evita que se interpreten las barras invertidas; `${name%$'\r'}` descarta el terminador CRLF, igual que los módulos `hellouser` de los lenguajes; con entrada vacía (EOF) imprime `Enter your name: Hello, !` y devuelve `0`, sin abortar pese a `set -e`.

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

### Contrato de todos los verbos / Verb contract

| Regla | Detalle |
|-------|---------|
| stdout | Solo el dato (así `$(glot get lang)` será utilizable en v0.4.0) |
| stderr | Diagnóstico, avisos y errores |
| Códigos de salida | `0` correcto · `1` error de entorno o dato ausente · `2` uso incorrecto · `3` estado ilegible o no escribible |
| Flags | `-h/--help` (general y por verbo), `--version`, `-q/--quiet`; los verbos que mutan aceptarán `-n/--dry-run` |
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
| Verbo desconocido | Error en stderr y sugerencia de `help` | 2 |

> **ES:** Compatibilidad heredada: `glot <algo-que-no-es-verbo>` sigue tratándose como `greet <nombre>` para no romper el uso de v0.2.0; se retira en v1.0.0.
> **EN:** Legacy compatibility: `glot <something-that-is-not-a-verb>` is still treated as `greet <name>` so v0.2.0 usage keeps working; it is removed in v1.0.0.

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
bash -n scripts/glot.sh     # sintaxis
./scripts/glot.sh           # comportamiento
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

