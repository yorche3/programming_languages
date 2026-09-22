# 🧾 Log de versiones / Version log

**ES:** Historial de versiones cerradas y de la versión viva. Las versiones **futuras** y la capa que cubre cada una están en [`ROADMAP.md`](ROADMAP.md).

**EN:** History of closed versions and of the live version. **Future** versions and the layer each one covers are in [`ROADMAP.md`](ROADMAP.md).

| Versión | Fecha | Archivo | Añade | Estado |
|---------|-------|---------|-------|:------:|
| 0.1.0 | 2026-09-20 | [`versions/glot_0.1.0.sh`](../versions/glot_0.1.0.sh) | Hello World en Bash (`echo "Hello World! from Bash!"`) | ✅ cerrada |
| 0.2.0 | 2026-09-20 | [`versions/glot_0.2.0.sh`](../versions/glot_0.2.0.sh) | Nombre por argumento o por entrada estándar y saludo `Hello, <nombre>!` (equivalente a `hellouser`) | ✅ cerrada |
| 0.3.0 | 2026-09-20 | [`versions/glot_0.3.0.sh`](../versions/glot_0.3.0.sh) | **Contrato y dispatcher** (L0): `version`, `help`, `doctor`, `greet`, `hello`, sin rutas del usuario, más harness de pruebas propio | ✅ cerrada |
| 0.4.0 | 2026-09-21 | [`versions/glot_0.4.0.sh`](../versions/glot_0.4.0.sh) | **Almacén clave/valor** (L1): `set`, `get`, `unset`, `list`, `path`, en XDG, atómico bajo `flock` y con `-n/--dry-run` | ✅ cerrada |
| 0.5.0 | 2026-09-22 | [`versions/glot_0.5.0.sh`](../versions/glot_0.5.0.sh) | **Asignación** (L2): `use <lenguaje> <fase>/<módulo> [tipo]`, que sitúa el trabajo según los cuatro estados del sprint (nuevo, en curso, reanudar y cerrado) | ✅ cerrada |
| 0.6.0 | 2026-09-22 | [`versions/glot_0.6.0.sh`](../versions/glot_0.6.0.sh) | **Catálogo** (L2.5): `langs`, `modules`, `progress` y `completion`, con el conversor de nombres y los comandos nativos por lenguaje | ✅ cerrada |
| 0.7.0 | 2026-09-22 | [`versions/glot_0.7.0.sh`](../versions/glot_0.7.0.sh) | **Ejecución** (L3): `test` y `verify`, con el código `4` de verificación fallida, los marcadores de la tabla de comandos y la cobertura de verificadores | ✅ cerrada |
| 0.8.0 | 2026-09-22 | [`versions/glot_0.8.0.sh`](../versions/glot_0.8.0.sh) | **Delegación** (L4): `prompt` y `ask`, con las cuatro plantillas versionadas de `scripts/prompts/` y un solo vocabulario de marcadores | ✅ cerrada |

---

## 0.1.0 — 2026-09-20 (cerrada)

- **Añade:** `echo "Hello World! from Bash!"`, el equivalente del `helloworld` de los lenguajes aplicado al tooling del repositorio.
- **Cómo se usaba:** `./scripts/glot.sh`.
- **Snapshot:** [`versions/glot_0.1.0.sh`](../versions/glot_0.1.0.sh), archivado al abrir la v0.2.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real → `Hello World! from Bash!`, código de salida `0`.

## 0.2.0 — 2026-09-20 (cerrada)

- **Añade:** el nombre llega como argumento (`./scripts/glot.sh Ada`) o por la entrada estándar; si no llega por ninguna de las dos vías, el script pregunta `Enter your name: ` y lee con `read -r`.
- **Equivalencia:** es el `hellouser` del tooling (especificación `02_Hello_User`): pide el nombre, lo guarda en una variable y saluda.
- **Snapshot:** [`versions/glot_0.2.0.sh`](../versions/glot_0.2.0.sh), archivado al abrir la v0.3.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real de las tres vías → `Hello, Ada!` (`rc=0`), `Enter your name: Hello, Ada!` (`rc=0`) y `Hello, Grace Hopper!` con entrada `printf 'Grace Hopper\r\n'`.
- **Notas:** `read -r` evita que se interpreten las barras invertidas; `${name%$'\r'}` descarta el terminador CRLF, igual que los módulos `hellouser` de los lenguajes; con entrada vacía (EOF) imprime `Enter your name: Hello, !` y devuelve `0`, sin abortar pese a `set -e`.

## 0.3.0 — 2026-09-20 (cerrada)

- **Añade:** el contrato L0 y el dispatcher de verbos: `version`, `help [verbo]`, `doctor` y `greet [nombre]`, con `stdout` = datos, `stderr` = diagnóstico y códigos `0/1/2`; y el harness [`tests/glot_test.sh`](../tests/glot_test.sh) (39 comprobaciones, sin dependencias).
- **Sin rutas del usuario:** el script se localiza con `BASH_SOURCE` y resuelve la raíz con `GLOT_ROOT` → superproyecto → raíz git; la documentación usa variables en lugar de rutas fijas.
- **Cambios respecto a v0.2.0:** se retira el prompt interactivo (los verbos nunca preguntan: el dato llega por argumento o stdin) y un primer argumento que no es verbo ya no se interpreta como nombre: devuelve `2` con la sugerencia `glot greet <nombre>`. El saludo de v0.2.0 se conserva como verbo `hello`, que se retira en v1.0.0.
- **Verificación:** `bash -n` limpio en `glot.sh`, el harness y el snapshot; `./scripts/tests/glot_test.sh` → `glot tests: 39 passed, 0 failed` (rc `0`); `doctor` dentro del monorepo rc `0` y fuera rc `1` con `root: (no detectado / not detected)`.
- **Documentación:** recorrido interno del script, con la lectura de argumentos, la tabla de despacho, qué lee y decide cada verbo y los detalles no evidentes (`-t 0`, `read -r`, CRLF, resolución de la raíz).
- **Snapshot:** [`versions/glot_0.3.0.sh`](../versions/glot_0.3.0.sh), archivado al abrir la v0.4.0.
- **Notas:** al pasar a v0.4.0 se ajustó un detalle del contrato: las confirmaciones de `set`/`unset` van a `stderr` (antes se mezclaban con el dato en stdout de los verbos de estado) y se estrenó el código `3` para el estado ilegible.

## 0.4.0 — 2026-09-21 (cerrada)

- **Añade:** el **almacén de estado** (L1) con `set`, `get`, `unset`, `list` y `path`; escritura atómica (`mktemp` + `mv -f`) bajo `flock`, permisos `600` del fichero y `700` del directorio, `-n/--dry-run` en los verbos que mutan, y `doctor` ampliado con `state_dir`, `state_file` y `state_file_ok`.
- **Contrato:** se estrena el código `3` (estado ilegible o no escribible) y se documenta el formato `clave=valor` con clave `[A-Za-z0-9_.-]` y valor sin saltos de línea.
- **Sin rutas del usuario:** el estado se resuelve con `GLOT_STATE_DIR` → `XDG_STATE_HOME` → `~/.local/state/glot`, y `GLOT_STATE_FILE` gana a todo; el harness se aísla con esa variable.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 71 passed, 0 failed` (rc `0`); `get` de clave ausente → `1`; clave inválida y valor con salto de línea → `2`; `unset` repetido → `0`; `-n set lang lua` imprime `lang=lua` y no escribe; `stat -c '%a'` → `600` el fichero y `700` el directorio.
- **Snapshot:** [`versions/glot_0.4.0.sh`](../versions/glot_0.4.0.sh), archivado al abrir la v0.5.0.

## 0.5.0 — 2026-09-22 (cerrada)

- **Añade:** la **asignación** (L2) con `use <lenguaje> <fase>/<módulo> [tipo]`, que **sitúa el trabajo**: valida lenguaje, fase, módulo, tipo y árbol **sin tocar nada**, resuelve la especificación `docs/core/{fase}/{NN}_{Nombre}.md` y después **lee el estado y nunca lo fuerza**. Reconoce cuatro estados: **nuevo** (no existe la carpeta) → crea la rama desde `main`, la publica con `push -u origin` y crea la carpeta vacía; **en curso y limpio** (la rama ya existe) → la activa y la publica; **reanudar** (trabajo sin confirmar dentro del módulo) → no crea ni cambia nada y solo informa, republicando si ya estás en la rama; **cerrado** (limpio sobre `main` y sin rama) → con `tipo` explícito abre la rama de mantenimiento desde `main`; sin él avisa y sugiere. En todos los casos escribe las seis claves del sprint (`lang`, `phase`, `module`, `branch`, `spec`, `repo`) e imprime la ruta absoluta del módulo en stdout.
- **Contrato:** `2` para uso incorrecto (argumentos, tipo no permitido, opción desconocida), `1` para entorno o dato ausente (lenguaje fuera de `.gitmodules`, especificación ausente, submódulo sin inicializar, cambios sin confirmar **fuera** del directorio del módulo, rama no creable o no publicable) y `3` si el estado no se puede escribir (avisando de que el módulo y la rama ya quedaron preparados). No hace commits, ni `git add`, ni esqueleto, ni toca el monorepo.
- **Estados del sprint:** el directorio del módulo **no** cuenta como suciedad ajena; dentro de él, un árbol sucio es el estado normal de un sprint a medias (fin de jornada, corte de luz, implementación incompleta). Por eso **con trabajo sin confirmar `use` nunca crea ni cambia de rama**: reanudar es su caso principal, no un error. Reanudar sobre la rama del módulo republica con `-u` lo que quedó local (el `push` no toca el árbol de trabajo).
- **`tipo`:** por defecto `feat`, que es el de la rama propia del módulo. Por eso, con el módulo **ya cerrado**, hay que indicarlo: así no se resucita una rama `feat` fantasma. Con el módulo **nuevo** el valor por defecto se aplica sin preguntar.
- **`-n/--dry-run`:** imprime el plan completo sin tocar el repositorio ni el estado: la rama desde `main`, el `push -u` y la creación de la carpeta para un módulo nuevo; la activación y el `push -u` para un módulo en curso; nada para un reanudar; y la rama de mantenimiento para un módulo cerrado con `tipo`.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 158 passed, 0 failed` (rc `0`), con un sandbox de git propio (monorepo falso con `.gitmodules`, especificación y un submódulo `php` con remoto desnudo) para que `use` cree la rama desde `main`, la publique con upstream y genere la carpeta en un módulo nuevo, active una rama existente, abra una de mantenimiento en un módulo cerrado y respete el trabajo sin confirmar, sin salir del directorio temporal ni tocar la red. Ensayo real sobre el monorepo: `./scripts/glot.sh -n use php algorithms/naive_sort` → aviso de módulo existente, activación de `feat/algorithms/naive-sort` y estado intacto; `./scripts/glot.sh -n use php algorithms/naive_sort test` → plan de la rama de mantenimiento `test/algorithms/naive-sort` desde `main`.
- **Snapshot:** [`versions/glot_0.5.0.sh`](../versions/glot_0.5.0.sh), archivado al abrir la v0.6.0; su contenido es el que tenía `main` en el cierre de la versión.

## 0.6.0 — 2026-09-22 (viva)

- **Añade:** el **catálogo** (L2.5) con `langs`, `modules`, `progress` y `completion`, más el **conversor de nombres**: de un id canónico (`data_structures`) salen el nombre legible, el del documento, la rama, el nombre del commit y la carpeta.
- **Fuentes:** `.gitmodules` (lenguajes, el denominador), el bloque de contadores de `docs/ROADMAP.md` (módulos y estado, la fuente de verdad), `docs/core/{fase}/` (especificaciones, con el prefijo `NN` leído del disco) y [`data/languages.tsv`](../data/languages.tsv) (comandos nativos por lenguaje, con test de deriva contra la guía de inicialización).
- **Nombres legacy:** `hello_world` → carpeta `helloworld` (en 49 lenguajes; Ada usa el id tal cual) y `hello_user` → `hellouser`; `unit_test` → carpeta `unit_test/calculator` y documento `03_Unit_Test_Calculator.md`. Se resuelven sondeando el disco, no con una tabla completa, y la comparación del documento no distingue mayúsculas (`etl_basico` encuentra `14_ETL_Basico.md`).
- **Corrige:** `use` ya no falla con los módulos cuyo nombre de carpeta o de documento no sigue el id del roadmap (`foundations/helloworld` y `foundations/unit_test` devolvían `1` con 158 comprobaciones en verde). El fixture del harness incluye ahora una fase con nombres divergentes, que es justo por lo que el fallo no se veía.
- **Robustez:** `doctor` comprueba `flock`, `mktemp`, `sort`, `awk` y `cat`, la cobertura del catálogo de datos, los dos guiones de autocompletado y la lectura del roadmap; el estado ya no se inventa una ruta si no hay `HOME` ni `XDG_STATE_HOME` (mensaje propio en vez de abortar por `set -u`).
- **Autocompletado:** `completions/glot.bash` y `completions/glot.zsh`, con completado **dinámico** de lenguajes, fases y módulos preguntando al catálogo. Se imprimen con `glot completion <shell>`; **no** se instalan (eso es `install`, v1.0.0).
- **Contrato:** `langs` devuelve `lenguaje<TAB>prueba nativa`; `modules` devuelve `id<TAB>fase<TAB>módulo<TAB>especificación`; `progress` devuelve `clave=valor` sin fase y TSV con fase. Los estados del roadmap se traducen a `done`/`in_progress`/`planned`/`pending`: ASCII, sin emoji en la salida.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 227 passed, 0 failed` (rc `0`); incluye la deriva guía ↔ `data/languages.tsv`, la resolución de los nombres divergentes en el sandbox, el autocompletado de bash de punta a punta y, cuando `zsh` está instalado, su sintaxis y su `compdef` (verificado con `zsh 5.9.2`).
- **Snapshot:** [`versions/glot_0.6.0.sh`](../versions/glot_0.6.0.sh), archivado al abrir la v0.7.0; su contenido es el que tenía `main` en el cierre de la versión.

## 0.7.0 — 2026-09-22 (viva)

- **Añade:** la **ejecución** (L3) con `test` (suite del módulo asignado, con el comando nativo del lenguaje) y `verify` (sintaxis/formato), los dos desde cualquier directorio: el objetivo se resuelve con los argumentos y, lo que falte, con el estado del sprint (`lang`, `phase`, `module`).
- **Contrato:** se estrena el código `4` (**verificación fallida**), para que un CI distinga «no pude ejecutar» (`1`) de «ejecuté y está en rojo» (`4`). `-n/--dry-run` imprime el plan (`cd <módulo> && <comando>`) sin ejecutar nada, también aquí.
- **Marcadores de la tabla de comandos:** `{modulo}` → id (`naive_sort`), `{Modulo}` → PascalCase (`NaiveSort`) y `{suite}` → archivo de suite, que se deduce del propio patrón (prefijo y sufijo del token, buscados en el directorio efectivo del comando) y exige una única coincidencia: cero o varias son un error, nunca una elección silenciosa.
- **Corrige la tabla de comandos:** nueve filas no eran ejecutables como estaban. `ada` apuntaba a `tests` (el directorio real es `test`), `kotlin` usaba un envoltorio que no existe, `scala` necesita `-batch -no-colors` para no quedarse esperando, `prolog` y `tcl-tk` requieren `cd test` (tcl-tk además `TCLLIBPATH`), `vala` necesita `--pkg glib-2.0` y ejecutar el binario, `scheme` usa `--no-auto-compile` con la suite de Guile, `common-lisp` necesita el `--eval '(uiop:quit)'` y `nim` va con `nimble test`. Se corrigen en la guía de inicialización y en el catálogo, con lo que documentan y ejecutan los módulos.
- **Columna nueva `verify`:** 14 de los 50 lenguajes tienen verificador **verificado** (crystal, dart, elixir, go, julia, nim, perl, php, python, r, ruby, rust, v, zig). El resto imprime `skipped` y `doctor` informa de la cobertura: `verify_commands: 14 de / of 50`.
- **Hallazgo declarado:** el verificador encuentra hallazgos de formato **preexistentes** en tres módulos ya homologados (V, Rust y Crystal). No se tocan en esta versión: quedan visibles como deuda.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 258 passed, 0 failed` (rc `0`). Ejecuciones reales sobre el monorepo: `test` en `php` (`OK (3 tests, 21 assertions)`), `prolog` (3 subtests passed), `vala` (`ok 1..3`) y `tcl-tk` (`Total 21 Passed 21 Failed 0`) → rc `0`; `verify php` → `No syntax errors detected` rc `0`; `verify v` y `verify rust` → rc `4` con los hallazgos preexistentes; `verify ada` → `skipped` rc `0`.
- **Snapshot:** [`versions/glot_0.7.0.sh`](../versions/glot_0.7.0.sh), archivado **antes** de fusionar la rama en `main` y antes de abrir la v0.8.0, para que la puerta de entrada no bloquee el arranque de la siguiente versión.

## 0.8.0 — 2026-09-22 (viva)

- **Añade:** la **delegación** (L4) con `prompt` (sin argumentos lista el registro; con encargo imprime la cabecera del estado del sprint y la plantilla expandida) y `ask` (el mismo encargo, enviado a `GLOT_DELEGATE` por stdin). Ninguno de los dos ejecuta el trabajo ni escribe en el repositorio.
- **Plantillas versionadas:** cuatro encargos en `scripts/prompts/` — `scaffold` (paso 4), `implement` (5), `docs-module` (7) y `docs-language` (8) — normalizados desde el banco local de `.github/prompts/`. El registro no está codificado: `glot prompt` recorre `*.prompt.md` y lee `name`, `step` y `description` del frontmatter, así que añadir un encargo es añadir un archivo.
- **Un solo vocabulario de marcadores**, anclado a las claves del estado: `{lang}`, `{phase}`, `{module}`, `{Module}`, `{repo}`, `{branch}`, `{spec}`, `{suite}` y `{module_dir}`. Se renombran en la guía de inicialización y en el catálogo de datos (`{modulo}`/`{Modulo}` → `{module}`/`{Module}`, 110 ocurrencias).
- **Contrato:** un marcador sin resolver es un error `1` que lo nombra, nunca texto literal; `prompt` no necesita `-n` (imprimir es su función) y `ask -n` imprime el plan; sin `GLOT_DELEGATE`, `ask` devuelve `1`; un delegado que falla devuelve `1`, no `4`.
- **`doctor`:** informa de la carpeta de plantillas, del número de encargos y de si hay delegado configurado.
- **Corrige:** la clave reservada `repo` se documentaba como «ruta del submódulo dentro del monorepo» cuando `use` guarda el **nombre** del submódulo; la tabla del contrato ya dice lo que hace el código.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 286 passed, 0 failed` (rc `0`). Reproducción real: `glot prompt` → 4 encargos con su paso; `glot prompt scaffold php algorithms/naive_sort` → cabecera con `spec` y `module_dir` y plantilla sin frontmatter y sin marcadores; `GLOT_DELEGATE='wc -l' glot ask implement php algorithms/naive_sort` → el encargo completo (115 líneas) por stdin, rc `0`; sin delegado → rc `1`; delegado que falla → rc `1`.
- **Snapshot:** [`versions/glot_0.8.0.sh`](../versions/glot_0.8.0.sh), archivado **antes** de fusionar la rama en `main` y antes de abrir la v0.9.0, para que la puerta de entrada no bloquee el arranque de la siguiente versión.

---

## 🔖 Convención de archivado / Archiving convention

- **SemVer** `MAJOR.MINOR.PATCH`; el número vive en el encabezado de [`glot.sh`](../glot.sh) y en la tabla de este documento (desde v0.3.0 también en `glot version`).
- **Puerta de entrada:** ninguna versión se empieza a implementar sin el snapshot de la anterior en `versions/`. Si falta, se copia `glot.sh` con el sufijo de su versión y solo después se reanuda la implementación de la nueva.
- **Cierre de versión:** copiar `glot.sh` a `versions/glot_<versión>.sh`, marcar la fila del log como `✅` y empezar la versión siguiente en `glot.sh`.
- Los snapshots de `versions/` **no se editan**: son la foto de cómo estaba el script en esa versión y permiten ver la progresión.
- `versions/` contiene [`glot_0.1.0.sh`](../versions/glot_0.1.0.sh), [`glot_0.2.0.sh`](../versions/glot_0.2.0.sh), [`glot_0.3.0.sh`](../versions/glot_0.3.0.sh), [`glot_0.4.0.sh`](../versions/glot_0.4.0.sh), [`glot_0.5.0.sh`](../versions/glot_0.5.0.sh), [`glot_0.6.0.sh`](../versions/glot_0.6.0.sh), [`glot_0.7.0.sh`](../versions/glot_0.7.0.sh) y [`glot_0.8.0.sh`](../versions/glot_0.8.0.sh).
- El harness **comprueba la puerta de entrada**: exige el snapshot de la versión anterior a la viva, así que no se puede empezar una versión nueva sin haber archivado la anterior.
- Cada versión se cierra en su propia rama `chore/repo/glot-v0.X` antes de fusionarla en `main` (ver [`README.md`](../README.md)).

---

## ✅ Definition of Done de una versión / Per-version Definition of Done

- [ ] `bash -n scripts/glot.sh scripts/tests/glot_test.sh` sin salida.
- [ ] Harness en verde (`glot tests: N passed, 0 failed`, rc `0`).
- [ ] Salidas reales capturadas y documentadas (sin editar).
- [ ] `scripts/README.md` y los documentos de `scripts/docs/` al día.
- [ ] Snapshot copiado a `versions/glot_<versión>.sh` y fila del log marcada `✅`.
- [ ] El harness pasa, incluida la comprobación de la **puerta de entrada**: el snapshot de la versión anterior a la viva existe.
- [ ] Rama `chore/repo/glot-v0.X` fusionada en `main`.
- [ ] `git diff --check` sin errores y sin `push` ni `commit` hechos por el agente.

---

## ✅ Requisitos / Requirements

| Herramienta | Uso | Verificación |
|-------------|-----|--------------|
| Bash 5.2 | Ejecutar `glot.sh` y, desde v1.0.0, cargarlo con `source`. Desde v0.6.0 el conversor de nombres usa `${var,,}`, `${var^}` y `${1//_/-}` (bash 4+) | `bash --version` |
| Git 2.43 | Desde v0.3.0: `doctor` resuelve la raíz con `git rev-parse --show-superproject-working-tree`; desde v0.5.0, `use` prepara y publica ramas; desde v0.6.0, `langs` lee `.gitmodules` y el catálogo resuelve el lenguaje desde la raíz de git | `git --version` |
| coreutils y util-linux | Desde v0.4.0: el almacén usa `mktemp`, `mv`, `chmod` y `flock`; `doctor` lo comprueba desde v0.6.0 | `mktemp --version`, `flock --version` |
| GNU coreutils (`stat -c`) | Solo para el harness: comprueba los permisos `600`/`700` | `stat --version` |
| zsh 5.9 (opcional) | Solo para verificar el autocompletado de `completions/glot.zsh`; el harness se salta sus dos comprobaciones si no está | `zsh --version` |
| Toolchains de cada lenguaje | Desde v0.7.0, `test` y `verify` ejecutan el comando nativo del lenguaje: la toolchain que falte se detecta al ejecutar (código `1`), y `doctor` informa de la cobertura del catálogo de verificadores | p. ej. `composer --version`, `swipl --version` |
| GitHub Copilot CLI 1.0.86 (opcional) | Validador automático de `validate` (v0.10.0) | `copilot --version` |

---

## 🧪 Cómo verificar / How to verify

```bash
bash -n scripts/glot.sh              # sintaxis
./scripts/tests/glot_test.sh        # contrato, verbos, estado, catálogo, ejecución, delegación y códigos (286 comprobaciones)
./scripts/glot.sh doctor            # diagnóstico del entorno, del catálogo y del roadmap
./scripts/glot.sh langs             # catálogo de lenguajes y su comando de pruebas
./scripts/glot.sh modules           # catálogo de módulos con su especificación
./scripts/glot.sh progress          # contadores del roadmap
./scripts/glot.sh completion bash   # autocompletado en stdout
./scripts/glot.sh -n test php algorithms/naive_sort   # plan: cd al módulo y comando nativo
./scripts/glot.sh test php algorithms/naive_sort     # ejecuta la suite (salida real)
./scripts/glot.sh verify php algorithms/naive_sort   # verificador del lenguaje
./scripts/glot.sh prompt                             # registro de encargos
./scripts/glot.sh prompt scaffold php algorithms/naive_sort   # encargo armado
GLOT_DELEGATE='cat' ./scripts/glot.sh ask implement php algorithms/naive_sort
./scripts/glot.sh -n use php algorithms/naive_sort   # ensayo de `use`: plan sin tocar nada

# Estado en un directorio propio, sin tocar el del usuario / state in its own dir
export GLOT_STATE_DIR=$(mktemp -d)
./scripts/glot.sh set lang php      # set: lang (stderr)
./scripts/glot.sh get lang          # php
./scripts/glot.sh list              # lang=php
```

`shellcheck` no está instalado en este entorno; conviene añadirlo a la verificación cuando exista CI.
