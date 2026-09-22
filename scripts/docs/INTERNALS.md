# 🔍 Cómo funciona por dentro / How it works internally

**ES:** Recorrido de [`glot.sh`](../glot.sh) en su versión viva (v0.5.0), del argumento al código de salida. No es documentación línea a línea: solo lo necesario para leerlo, entender las decisiones raras y extenderlo. El contrato está en [`CONTRACT.md`](CONTRACT.md).

**EN:** A walkthrough of [`glot.sh`](../glot.sh) at its live version (v0.5.0), from argument to exit code. It is not line-by-line documentation: just what is needed to read it, understand the odd decisions and extend it. The contract is in [`CONTRACT.md`](CONTRACT.md).

---

## 1. Arranque y localización / Startup and self-location

1. `set -euo pipefail` al principio: como el archivo se **ejecuta**, cualquier orden que falle detiene el script y el `return` de un verbo se convierte en su código de salida. Esta línea desaparecerá cuando el archivo se cargue con `source` (v1.0.0), porque ahí no puede tocar las opciones del shell.
2. `GLOT_VERSION="0.5.0"` es la única constante propia; el resto de funciones y variables internas llevan el prefijo `_glot_` para poder cargarse más adelante sin contaminar el entorno.
3. `GLOT_SCRIPT_DIR` se obtiene de `BASH_SOURCE[0]`, resolviendo enlaces simbólicos con `readlink` y normalizando con `cd … && pwd -P`. Es lo que permite invocar el script desde cualquier directorio (o desde un enlace) sin rutas fijas.

## 2. Lectura de argumentos / Argument parsing

1. **Primero los flags globales**: un bucle consume `-q`/`--quiet` y `-n`/`--dry-run` mientras aparezcan *antes* del verbo y activa `_glot_quiet` o `_glot_dry_run`; al primer argumento que no es flag, el bucle corta.
2. **El primer argumento libre es el verbo**; el resto se conserva intacto y se pasa al verbo (`set lang php` → verbo `set`, argumentos `lang` y `php`).
3. Sin argumentos, `cmd` queda vacío y comparte rama con `help`: un CLI que no recibe nada y pide ayuda es preferible a uno que falla.

## 3. Despacho / Dispatch

Un `case` sobre `cmd` elige el camino; cada rama llama a un `_glot_cmd_*`:

| Entrada | Rama | Efecto |
|---------|------|--------|
| `""`, `help`, `-h`, `--help` | `_glot_cmd_help "$@"` | Ayuda general, o la del verbo si se pasa uno |
| `version`, `-V`, `--version` | `_glot_cmd_version` | Imprime la versión |
| `doctor` | `_glot_cmd_doctor` | Recoge el entorno y devuelve `0`/`1` |
| `greet`, `hello` | `_glot_cmd_greet "$@"` | Saludo; `hello` es el alias de compatibilidad v0.2.0 |
| `set`, `get`, `unset`, `list` | `_glot_cmd_<verbo> "$@"` | Operan sobre el almacén de estado (L1) |
| `path` | `_glot_cmd_path` | Ruta del fichero de estado, sin leerlo |
| otra opción (`-*`) | error de uso | `2` y mensaje en `stderr` |
| cualquier otra cosa | error de verbo | `2`, sugiere `glot greet <algo>` y `glot help` |

> **ES:** La última rama es deliberada: **no** intenta adivinar si era un nombre (eso hacía v0.2.0) porque un error de tecleo debe fallar rápido, no saludar.
> **EN:** The last branch is deliberate: it does **not** guess whether the argument was a name (v0.2.0 did), because a typo must fail fast instead of greeting.

## 4. El almacén de estado / The state store (L1)

1. **Dónde vive**: `GLOT_STATE_DIR` → `$XDG_STATE_HOME/glot` → `~/.local/state/glot`. El fichero es `<dir>/state`, salvo que se fije `GLOT_STATE_FILE`, que gana a todo (es lo que usa el harness para aislarse).
2. **Formato**: una línea `clave=valor` por entrada. Las claves solo admiten `[A-Za-z0-9_.-]` y los valores no pueden llevar salto de línea ni CR; lo que no cumple se rechaza con `2` antes de tocar el disco.
3. **Escritura atómica**: `_glot_state_rewrite` escribe un temporal con `mktemp` en el mismo directorio, le pone `chmod 600`, lo mueve con `mv -f` (atómico dentro del mismo sistema de ficheros) y borra el temporal si algo falla; el directorio se crea con `chmod 700`. Un corte a mitad no deja el fichero a medias.
4. **Concurrencia**: el ciclo leer-modificar-escribir va dentro de `flock 9` sobre `<fichero>.lock`, en un subshell, para que dos `set` simultáneos no se pisen. El `.lock` permanece en el directorio: es inocuo.
5. **Lectura**: `list` ordena con `LC_ALL=C sort -t= -k1,1`, así el orden no depende del idioma del entorno. `get` distingue «no encontrada» (`1` y error en stderr) de «valor vacío» (`0` y línea vacía): dato ausente no es lo mismo que dato vacío.
6. **Errores de estado**: si no se puede crear o escribir, el verbo devuelve `3` y no `1`, para que quien llama distinga «me falta un dato» de «no puedo guardar».
7. **`-n/--dry-run`**: los verbos que mutan imprimen el efecto en stdout (`clave=valor`) y no escriben; `set` valida igual la clave y el valor, así el ensayo detecta los mismos errores de uso que la ejecución.

## 5. Qué hace cada verbo / What each verb does

| Verbo | Lee | Decide | Escribe | Devuelve |
|-------|-----|--------|---------|:--------:|
| `version` | — | — | `glot 0.5.0` en stdout | `0` |
| `help [verbo]` | El verbo opcional | Si hay verbo, ayuda corta; si no, tabla general | stdout | `0`, o `2` si el verbo no existe |
| `doctor` | bash, git, raíz del monorepo, estado | Marca `1` si falta bash 4+, git o la raíz | `clave: valor` en stdout; encabezado y avisos en stderr | `0` o `1` |
| `greet [nombre]` | El argumento; si no hay, una línea de stdin | Si stdin es terminal falla sin bloquearse; descarta el CRLF final | `Hello, <nombre>!` en stdout | `0`, o `2` sin nombre |
| `set <clave> <valor>` | Los dos argumentos | Valida clave y valor; `-n` corta antes de escribir | Confirmación por stderr; con `-n`, `clave=valor` en stdout | `0`, `2` o `3` |
| `get <clave>` | El fichero de estado | Distingue ausente de vacío | El valor en stdout | `0`, `1` o `2` |
| `unset <clave>` | El fichero de estado | Es idempotente: borrar lo que no está no es error | Confirmación por stderr | `0`, `2` o `3` |
| `list` | El fichero de estado | Ordena por clave en `LC_ALL=C` | `clave=valor` en stdout | `0` o `3` |
| `path` | Las variables de entorno | — | La ruta del estado en stdout | `0` |

### Detalles no evidentes / Non-obvious details

- **`[[ -t 0 ]]`** evita quedarse esperando entrada cuando se ejecuta `glot greet` a mano en una terminal: prefiere fallar con un mensaje útil antes que colgarse.
- **`IFS= read -r name || true`** lee una línea sin interpretar barras invertidas y sin abortar por `set -e` si llega EOF.
- **`${name%$'\r'}`** descarta el terminador CRLF, igual que los módulos `hellouser` de los lenguajes.
- **`_glot_repo_root`** busca la raíz en este orden: `GLOT_ROOT` → `git rev-parse --show-superproject-working-tree` (así detecta el monorepo cuando estás dentro de un submódulo) → `git rev-parse --show-toplevel`. Si no encuentra ninguna, no inventa una ruta: `doctor` lo informa y devuelve `1`.
- **`_glot_state_dir`/`_glot_state_file`** resuelven las rutas en el orden descrito en la sección 4; `doctor` informa de cuáles se han usado, de si el directorio existe y de cuántas claves hay.
- **`cmd || rc=$?`** aparece donde una orden puede fallar (`flock`, `mv`) porque el archivo se ejecuta con `set -e`: hay que capturar el código antes de que el shell aborte y decidir después si eso es `1`, `2` o `3`.

## 6. El verbo `use` / The `use` verb (L2)

**ES:** `_glot_cmd_use` hace ocho pasos y **todas las validaciones ocurren antes de tocar nada**: lee los argumentos (el lenguaje se puede omitir si estás dentro del submódulo y el `tipo` por defecto es `feat`), comprueba el lenguaje contra `.gitmodules`, que el submódulo esté inicializado, que la fase exista, que la especificación exista (`_glot_spec_for` compara el nombre del módulo con `docs/core/{fase}/{NN}_{Nombre}.md`) y que el árbol no tenga cambios ajenos al directorio del módulo. Después crea el directorio vacío, prepara la rama (`checkout` o `checkout -b`, según exista ya), la publica con `push -u origin`, escribe las seis claves del estado e imprime la ruta absoluta. Con `-n` imprime el mismo plan sin ejecutarlo.

**EN:** `_glot_cmd_use` runs eight steps and **every validation happens before touching anything**: it reads the arguments (the language may be omitted inside a submodule and the default `tipo` is `feat`), checks the language against `.gitmodules`, that the submodule is initialised, that the phase exists, that the specification exists (`_glot_spec_for` matches the module name against `docs/core/{phase}/{NN}_{Name}.md`) and that the tree has no changes outside the module directory. Then it creates the empty directory, prepares the branch (`checkout` or `checkout -b`, depending on whether it exists), publishes it with `push -u origin`, writes the six state keys and prints the absolute path. With `-n` it prints the same plan without running it.

**ES:** Detalles no evidentes: el directorio del módulo **no** cuenta como suciedad (por eso `use` se puede repetir sin fallar), y si el estado no se puede escribir devuelve `3` avisando de que la rama ya quedó preparada.

## 7. Salida y códigos / Output and exit codes

1. Los verbos escriben **solo datos** en stdout; los errores salen por `_glot_error` y los avisos por `_glot_warn`, ambos a stderr. `set`/`unset` confirman por stderr: su stdout solo lleva datos si `-n` está activo.
2. `_glot_info` escribe en stderr salvo que se haya pasado `-q/--quiet`; de ahí que `doctor -q` deje stdout parseable.
3. El código final del script es el del verbo: la última orden del archivo es `glot "$@"`, y con `set -e` un `return 2` dentro de un verbo termina el script con `2`.
4. `3` está reservado al estado: no se pudo leer, crear o escribir. Los errores de uso siguen siendo `2` y los de entorno `1`.

## 8. Lo que todavía no hace / What it does not do yet

No hay catálogo ni comando nativo por lenguaje: eso es L2.5 (v0.6.0). La asignación ya existe (L2, v0.5.0): `use` escribe las seis claves reservadas, crea el directorio del módulo y prepara y publica la rama.
