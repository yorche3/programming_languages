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
| 0.9.0 | 2026-09-22 | [`versions/glot_0.9.0.sh`](../versions/glot_0.9.0.sh) | **Creación y registro** (L5): `new` (inicializador del lenguaje, esqueleto y normalización) y `save` (commit guiado desde el catálogo `data/commits.tsv`), con la tabla de inicialización ampliada | ✅ cerrada |
| 0.10.0 | 2026-09-22 | [`versions/glot_0.10.0.sh`](../versions/glot_0.10.0.sh) | **Evidencia y cierre** (L6): `evidence`, `close` y `validate` con validador enchufable, más la retirada de `hello` y el objetivo resuelto por directorio | ✅ cerrada |
| 0.11.0 | 2026-09-22 | [`versions/glot_0.11.0.sh`](../versions/glot_0.11.0.sh) | **Perfiles de modelo por encargo** (L6.5): `model:` en el frontmatter de las seis plantillas y `data/models.tsv` fijando esfuerzo y tope de créditos por encargo, con los modelos que ofrece Copilot | ✅ cerrada |
| 0.12.0 | 2026-09-23 | [`versions/glot_0.12.0.sh`](../versions/glot_0.12.0.sh) | **Higiene y punteros** (L7): `status` (submódulos, ramas y punteros), `pointer` (deja el puntero del submódulo listo y publicado en el monorepo) y `clean` (artefactos del módulo y `submodule sync`), con el commit del monorepo en manos de `save` | ✅ cerrada |
| 1.0.0 | 2026-09-23 | [`versions/glot_1.0.0.sh`](../versions/glot_1.0.0.sh) | **Instalación y capa cargable** (L8): `install`/`uninstall` con copia estable, bloque del rc y completado; `glot` como función de bash que hace el `cd` real de `use`; estado **por raíz** de monorepo, `doctor` completo (instalación, shells, estado y toolchains) y encargos con sus fuentes declaradas | ✅ cerrada |

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

## 0.6.0 — 2026-09-22 (cerrada)

- **Añade:** el **catálogo** (L2.5) con `langs`, `modules`, `progress` y `completion`, más el **conversor de nombres**: de un id canónico (`data_structures`) salen el nombre legible, el del documento, la rama, el nombre del commit y la carpeta.
- **Fuentes:** `.gitmodules` (lenguajes, el denominador), el bloque de contadores de `docs/ROADMAP.md` (módulos y estado, la fuente de verdad), `docs/core/{fase}/` (especificaciones, con el prefijo `NN` leído del disco) y [`data/languages.tsv`](../data/languages.tsv) (comandos nativos por lenguaje, con test de deriva contra la guía de inicialización).
- **Nombres legacy:** `hello_world` → carpeta `helloworld` (en 49 lenguajes; Ada usa el id tal cual) y `hello_user` → `hellouser`; `unit_test` → carpeta `unit_test/calculator` y documento `03_Unit_Test_Calculator.md`. Se resuelven sondeando el disco, no con una tabla completa, y la comparación del documento no distingue mayúsculas (`etl_basico` encuentra `14_ETL_Basico.md`).
- **Corrige:** `use` ya no falla con los módulos cuyo nombre de carpeta o de documento no sigue el id del roadmap (`foundations/helloworld` y `foundations/unit_test` devolvían `1` con 158 comprobaciones en verde). El fixture del harness incluye ahora una fase con nombres divergentes, que es justo por lo que el fallo no se veía.
- **Robustez:** `doctor` comprueba `flock`, `mktemp`, `sort`, `awk` y `cat`, la cobertura del catálogo de datos, los dos guiones de autocompletado y la lectura del roadmap; el estado ya no se inventa una ruta si no hay `HOME` ni `XDG_STATE_HOME` (mensaje propio en vez de abortar por `set -u`).
- **Autocompletado:** `completions/glot.bash` y `completions/glot.zsh`, con completado **dinámico** de lenguajes, fases y módulos preguntando al catálogo. Se imprimen con `glot completion <shell>`; **no** se instalan (eso es `install`, v1.0.0).
- **Contrato:** `langs` devuelve `lenguaje<TAB>prueba nativa`; `modules` devuelve `id<TAB>fase<TAB>módulo<TAB>especificación`; `progress` devuelve `clave=valor` sin fase y TSV con fase. Los estados del roadmap se traducen a `done`/`in_progress`/`planned`/`pending`: ASCII, sin emoji en la salida.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 227 passed, 0 failed` (rc `0`); incluye la deriva guía ↔ `data/languages.tsv`, la resolución de los nombres divergentes en el sandbox, el autocompletado de bash de punta a punta y, cuando `zsh` está instalado, su sintaxis y su `compdef` (verificado con `zsh 5.9.2`).
- **Snapshot:** [`versions/glot_0.6.0.sh`](../versions/glot_0.6.0.sh), archivado al abrir la v0.7.0; su contenido es el que tenía `main` en el cierre de la versión.

## 0.7.0 — 2026-09-22 (cerrada)

- **Añade:** la **ejecución** (L3) con `test` (suite del módulo asignado, con el comando nativo del lenguaje) y `verify` (sintaxis/formato), los dos desde cualquier directorio: el objetivo se resuelve con los argumentos y, lo que falte, con el estado del sprint (`lang`, `phase`, `module`).
- **Contrato:** se estrena el código `4` (**verificación fallida**), para que un CI distinga «no pude ejecutar» (`1`) de «ejecuté y está en rojo» (`4`). `-n/--dry-run` imprime el plan (`cd <módulo> && <comando>`) sin ejecutar nada, también aquí.
- **Marcadores de la tabla de comandos:** `{modulo}` → id (`naive_sort`), `{Modulo}` → PascalCase (`NaiveSort`) y `{suite}` → archivo de suite, que se deduce del propio patrón (prefijo y sufijo del token, buscados en el directorio efectivo del comando) y exige una única coincidencia: cero o varias son un error, nunca una elección silenciosa.
- **Corrige la tabla de comandos:** nueve filas no eran ejecutables como estaban. `ada` apuntaba a `tests` (el directorio real es `test`), `kotlin` usaba un envoltorio que no existe, `scala` necesita `-batch -no-colors` para no quedarse esperando, `prolog` y `tcl-tk` requieren `cd test` (tcl-tk además `TCLLIBPATH`), `vala` necesita `--pkg glib-2.0` y ejecutar el binario, `scheme` usa `--no-auto-compile` con la suite de Guile, `common-lisp` necesita el `--eval '(uiop:quit)'` y `nim` va con `nimble test`. Se corrigen en la guía de inicialización y en el catálogo, con lo que documentan y ejecutan los módulos.
- **Columna nueva `verify`:** 14 de los 50 lenguajes tienen verificador **verificado** (crystal, dart, elixir, go, julia, nim, perl, php, python, r, ruby, rust, v, zig). El resto imprime `skipped` y `doctor` informa de la cobertura: `verify_commands: 14 de / of 50`.
- **Hallazgo declarado:** el verificador encuentra hallazgos de formato **preexistentes** en tres módulos ya homologados (V, Rust y Crystal). No se tocan en esta versión: quedan visibles como deuda.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 258 passed, 0 failed` (rc `0`). Ejecuciones reales sobre el monorepo: `test` en `php` (`OK (3 tests, 21 assertions)`), `prolog` (3 subtests passed), `vala` (`ok 1..3`) y `tcl-tk` (`Total 21 Passed 21 Failed 0`) → rc `0`; `verify php` → `No syntax errors detected` rc `0`; `verify v` y `verify rust` → rc `4` con los hallazgos preexistentes; `verify ada` → `skipped` rc `0`.
- **Snapshot:** [`versions/glot_0.7.0.sh`](../versions/glot_0.7.0.sh), archivado **antes** de fusionar la rama en `main` y antes de abrir la v0.8.0, para que la puerta de entrada no bloquee el arranque de la siguiente versión.

## 0.8.0 — 2026-09-22 (cerrada)

- **Añade:** la **delegación** (L4) con `prompt` (sin argumentos lista el registro; con encargo imprime la cabecera del estado del sprint y la plantilla expandida) y `ask` (el mismo encargo, enviado a `GLOT_DELEGATE` por stdin). Ninguno de los dos ejecuta el trabajo ni escribe en el repositorio.
- **Plantillas versionadas:** cuatro encargos en `scripts/prompts/` — `scaffold` (paso 4), `implement` (5), `docs-module` (7) y `docs-language` (8) — normalizados desde el banco local de `.github/prompts/`. El registro no está codificado: `glot prompt` recorre `*.prompt.md` y lee `name`, `step` y `description` del frontmatter, así que añadir un encargo es añadir un archivo.
- **Un solo vocabulario de marcadores**, anclado a las claves del estado: `{lang}`, `{phase}`, `{module}`, `{Module}`, `{repo}`, `{branch}`, `{spec}`, `{suite}` y `{module_dir}`. Se renombran en la guía de inicialización y en el catálogo de datos (`{modulo}`/`{Modulo}` → `{module}`/`{Module}`, 110 ocurrencias).
- **Contrato:** un marcador sin resolver es un error `1` que lo nombra, nunca texto literal; `prompt` no necesita `-n` (imprimir es su función) y `ask -n` imprime el plan; sin `GLOT_DELEGATE`, `ask` devuelve `1`; un delegado que falla devuelve `1`, no `4`.
- **`doctor`:** informa de la carpeta de plantillas, del número de encargos y de si hay delegado configurado.
- **Corrige:** la clave reservada `repo` se documentaba como «ruta del submódulo dentro del monorepo» cuando `use` guarda el **nombre** del submódulo; la tabla del contrato ya dice lo que hace el código.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 286 passed, 0 failed` (rc `0`). Reproducción real: `glot prompt` → 4 encargos con su paso; `glot prompt scaffold php algorithms/naive_sort` → cabecera con `spec` y `module_dir` y plantilla sin frontmatter y sin marcadores; `GLOT_DELEGATE='wc -l' glot ask implement php algorithms/naive_sort` → el encargo completo (115 líneas) por stdin, rc `0`; sin delegado → rc `1`; delegado que falla → rc `1`.
- **Snapshot:** [`versions/glot_0.8.0.sh`](../versions/glot_0.8.0.sh), archivado **antes** de fusionar la rama en `main` y antes de abrir la v0.9.0, para que la puerta de entrada no bloquee el arranque de la siguiente versión.

## 0.9.0 — 2026-09-22 (cerrada)

- **Añade:** la **creación y el registro** (L5) con `new` (inicializador del lenguaje y esqueleto mecánico del módulo) y `save` (commit guiado con la convención del repositorio), los dos verbos que hasta la v0.8.0 se hacían a mano.
- **`new` tiene dos modos, decididos por dato:** con `tool` ejecuta el inicializador del lenguaje en el directorio del módulo; con `manual` crea las carpetas del esqueleto; con `deferred` no ejecuta nada, informa, remite al encargo `scaffold` e imprime `skipped` (como `verify` sin verificador). No escribe la suite: eso es el encargo `suite` (paso 4b).
- **Tabla de inicialización ampliada** en [`data/languages.tsv`](../data/languages.tsv): de 5 a 8 columnas, con el **tipo** (columna 6, la leyenda ✅/🔧/✍️ de la guía recuperada como dato), el **comando** (7) y la **normalización** (8). Resultado: **22 lenguajes con herramienta**, **21 de estructura manual** y **7 aplazados** al agente.
- **Normalización declarada, no adivinada:** `flat:<sub>` sube el contenido del proyecto hijo (los inicializadores que anidan, como `crystal init lib` o `dart create`) y `rm:<ruta>` limpia. `crystal` y `gleam` crean además un `.git` propio: se borra **antes** de aplanar, porque un repositorio dentro de un submódulo no es válido. Un lenguaje sin operación declarada no se toca.
- **Tabla paso → mensaje, en datos:** [`data/commits.tsv`](../data/commits.tsv) (`paso`, `alias`, `ámbito`, `mensaje`). `save` acepta el paso (`4a`, `4b`, `5`, `7`, `8`) o el nombre del encargo (`scaffold`, `suite`, `implement`, `docs-module`, `docs-language`). Los pasos del monorepo (puntero y roadmap) se rechazan con `1` y remiten a `close` (v0.10.0) y `pointer` (v0.12.0).
- **Encargo nuevo:** `suite` (paso 4b) con el contrato de pruebas unitarias, que estaba dentro de `scaffold`. El paso 4 del sprint se parte en **4a** (esqueleto, `glot new` + `glot prompt scaffold`) y **4b** (suite, `glot prompt suite`), con dos commits: `chore({phase}): add scaffold for {module}` y `chore({phase}): add suite for {module}`.
- **Contrato:** `new` devuelve `4` si el inicializador falla y `0` con `skipped` si el esqueleto está aplazado; `save` devuelve el **SHA corto** por stdout o `nothing` si no hay nada que confirmar, **nunca hace push** y solo confirma en el submódulo. Los dos respetan `-n/--dry-run`, obligatorio por mutar.
- **Hallazgos que no bloquean, nombrados antes de confirmar:** cambios fuera del módulo (que entran igual, porque `add -A` es del submódulo) y una rama activa que no es la del estado del sprint.
- **`doctor`:** informa de la cobertura de inicializadores (`new_commands: 43 de / of 50 (deferred: 7)`) y del catálogo de commits (`commit_steps: 7 de / of which 5 son del submódulo`).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 361 passed, 0 failed` (rc `0`), con la **deriva** entre `data/commits.tsv` y la tabla del sprint, la coherencia del catálogo de inicialización (tipos válidos, comando obligatorio salvo en `deferred`, operaciones conocidas), el ciclo completo `use` → `new` → `save` en el sandbox sobre `ruby` (manual) y `python` (deferred), y la **genericidad de las plantillas** (ninguna lleva casos ni nombres de un módulo concreto).
- **Snapshot:** [`versions/glot_0.9.0.sh`](../versions/glot_0.9.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.

## 0.10.0 — 2026-09-22 (cerrada)

- **Añade:** la **evidencia y el cierre** (L6) completos: `evidence`, `close` y `validate`.
- **En detalle:**
  - **`validate`:** pasa el encargo `validate` (paso 6, **versionado** en `prompts/validate.prompt.md`) al validador automático y guarda su informe en `docs/evidence/{fase}/{módulo}/{lenguaje}.validate.md`. La orden sale de `GLOT_VALIDATOR` y, sin ella, de la invocación verificada de Copilot CLI en solo lectura; el **veredicto se lee** de la línea que la plantilla exige (`glot:validate verdict=clean|findings findings=N`) y no se adivina. Es **opcional**: sin validador avisa y devuelve `1`.
  - **`close`:** registra el cierre de un módulo en un lenguaje. Exige el acta de `evidence` **en verde** y los README del módulo y de la fase; escribe la entrada del checklist con los comandos y sus códigos leídos del acta, y sube el contador y la lista del roadmap con el nombre de presentación (`data/display.tsv` fija el nombre y el orden). Es idempotente, enseña el diff exacto con `-n` y **no confirma**.
  - **`evidence`:** ejecuta la suite y el verificador del módulo y deja el **acta** con la salida real en `docs/evidence/{fase}/{módulo}/{lenguaje}.md` —fecha, rama, commit del submódulo, árbol sucio o limpio, los comandos, su salida tal cual y sus códigos—, más un bloque de máquina que `close` leerá sin interpretar markdown. La escribe **también cuando algo está en rojo**, y entonces devuelve `4`.
  - **Retira** el verbo `hello` (alias de compatibilidad de la v0.2.0), que el contrato situaba en la v1.0.0: devuelve `2` como cualquier verbo desconocido. El aviso de verbo desconocido ya solo sugiere `glot help`.
  - **El objetivo se resuelve por directorio:** `test`, `verify`, `new` y `save` deducen el lenguaje del directorio cuando no lo traen ni los argumentos ni el estado del sprint, así que `cd php && glot test algorithms/naive_sort` funciona sin `use` previo. El estado manda sobre el directorio a propósito.
  - **El harness cierra el círculo del archivado:** toda versión marcada como cerrada en este log tiene que tener su snapshot, y ningún snapshot puede sobrar.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 477 passed, 0 failed` (rc `0`), incluida la **puerta de entrada del archivado** en las dos direcciones: 10 versiones cerradas en el log y 10 snapshots en `versions/`.
- **Snapshot:** [`versions/glot_0.10.0.sh`](../versions/glot_0.10.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.
- **Lo que deja abierto:** `pointer` y `status` llegan con L7 (0.12.0) y el reparto de modelos por encargo con L6.5 (0.11.0), **solo con los modelos que ofrece Copilot**; la cabecera de fase del roadmap y su contador siguen esperando un formato único entre fases.

---

## 0.11.0 — 2026-09-22 (cerrada)

- **Añade:** los **perfiles de modelo por encargo** (L6.5): `model:` en el frontmatter de las seis plantillas —con el **id real** del modelo, que es clave nativa de los `.prompt.md` de VS Code— y el catálogo [`data/models.tsv`](../data/models.tsv), que fija el esfuerzo y el tope de créditos de cada perfil.
- **Decisiones cerradas antes de codificar:** en [`ROADMAP.md`](ROADMAP.md). El modelo es la **clave del perfil** (no hay `profile:` que pueda derivar), el delegado recibe el modelo por entorno (`COPILOT_MODEL` y `COPILOT_AUTO_TIER`, que el CLI sí reconoce) y el tope de créditos del perfil económico es el **mínimo que acepta el CLI** (30).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 503 passed, 0 failed` (rc `0`), con 26 comprobaciones nuevas del catálogo, las plantillas y los códigos. Los límites del CLI (1.0.88) se midieron de verdad: `--reasoning-effort bogus` → `error: invalid value 'bogus' for '--reasoning-effort <level>' [possible values: none, minimal, low, medium, high, xhigh, max]` y `--max-ai-credits 20` → `error: Invalid value for --max-ai-credits: "20". Use at least 30 AI credits.`, que es de dónde sale el suelo de 30 del perfil económico. Los **tres perfiles se probaron contra la API real** —`copilot -C <dir temporal> -p 'Responde solo con la palabra OK.' -s --model <modelo> --reasoning-effort <esfuerzo> --max-ai-credits <créditos> --allow-all-tools --deny-tool write`— y los tres respondieron `OK` con código `0`: `gemini-3.8-flash`/`low`/30, `gpt-5.6-terra`/`medium`/90 y `claude-sonnet-5`/`high`/120.
- **Snapshot:** [`versions/glot_0.11.0.sh`](../versions/glot_0.11.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.

## 0.12.0 — 2026-09-23 (cerrada)

- **Añade:** la **higiene y los punteros** (L7): `status`, `pointer` y `clean`, con el commit del monorepo en manos de `save`.
- **El puntero deja de ser manual:** `pointer` comprueba con `fetch` explícito de `origin/main` que el commit del submódulo está **integrado** —la regla de [`CONTRIBUTING.md`](../../docs/CONTRIBUTING.md) pasa de prosa a comprobación—, prepara y publica la rama `chore/{fase}/{módulo}-pointer` y deja el gitlink añadido; el commit lo hace `save 9`. Es idempotente: si el monorepo ya apunta a ese commit, imprime `nothing` y no toca ramas.
- **`status`, solo lectura:** `lang<TAB>branch<TAB>pointer<TAB>worktree`, con `pointer` en `ok`, `differs`, `uninitialised` o `unknown`. Sin resumen a propósito (los contadores son de `progress`) y filtrable por lenguaje.
- **`clean` declara su alcance:** `git clean -Xfd` en el directorio del módulo —lo que el propio `.gitignore` del lenguaje declara como artefacto, aunque parezca útil: `php` ignora `composer.lock`— más `submodule sync` del lenguaje. Nunca `-x`, nunca el monorepo y nunca `docs/`. Se declara **apoyo a los pasos 5–6**, porque no es un paso por sí mismo.
- **`save` confirma el monorepo:** los pasos `9` y `10` añaden solo sus rutas (el submódulo del puntero; roadmap, checklist y evidencia del cierre), y siguen sin hacer push.
- **Decisiones cerradas antes de codificar:** en [`ROADMAP.md`](ROADMAP.md).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 551 passed, 0 failed` (rc `0`), con 48 comprobaciones nuevas sobre una fixture con **submódulos reales** (gitlink, remoto y rama `main`), porque el sandbox anterior no tenía punteros que mover. Las últimas siete guardan la **ayuda por verbo** de los tres verbos nuevos, que se había quedado sin escribir.
- **Snapshot:** [`versions/glot_0.12.0.sh`](../versions/glot_0.12.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.

---

## 1.0.0 — 2026-09-23 (cerrada)

- **Añade:** la **instalación y la capa cargable** (L8): `install`/`uninstall`, `glot` como función de bash y el `doctor` completo. Es la versión que cierra el objetivo original: `use` deja de necesitar `cd "$(glot use …)"`.
- **Añade además:** el **catálogo de toolchains** ([`data/toolchains.tsv`](../data/toolchains.tsv), con la serie verificada de 45 de los 50 lenguajes) que `doctor` comprueba, y los **encargos con fuentes**: cada plantilla declara sus `sources:` en el frontmatter, la cabecera del encargo lleva `root` y `glot prompt` avisa de las fuentes que falten.
- **Paga dos deudas declaradas:** el **estado por raíz** de monorepo (dos repos ya no comparten sprint) y los **encargos sin el nombre del monorepo**, con sus fuentes declaradas en el frontmatter y aviso si falta alguna.
- **Decisiones cerradas antes de codificar:** en [`ROADMAP.md`](ROADMAP.md) (copia estable, bloque del rc, bash para la capa cargable, `-n` sin `cd`, nombre y ruta del fichero de estado, `doctor`, toolchains y el ajuste de L9).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 666 passed, 0 failed` (rc `0`), 91 comprobaciones más que la v0.12.0: el estado por raíz, la instalación con `HOME` desechable, el catálogo de toolchains (con catálogo inyectado para probar `ok`, `differs`, `missing` y `unknown`), las fuentes de los encargos y las dos direcciones de `pointer`. En el **laboratorio**, con repos y remotos reales: ciclo completo del sprint en `ruby2` (4a→10, con puntero y cierre), hasta evidencia verde en `python2` (`pytest`, 24 pasados) y `php2` (`composer test`, 27 aserciones, con `new` en modo `tool`), y el **camino de fallo** en `ada2` (sin `gnat`: `test` en `4`, acta roja y `close` en `4` sin cerrar). Esa prueba encontró tres cosas, corregidas en la misma versión: `pointer` se detenía por la evidencia del propio sprint (que confirma `save 10`, después), el harness no era hermético (heredaba `GLOT_ROOT` del autor) y las plantillas nombraban el monorepo en prosa.
- **Snapshot:** [`versions/glot_1.0.0.sh`](../versions/glot_1.0.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.

---

## 🔖 Convención de archivado / Archiving convention
- **SemVer** `MAJOR.MINOR.PATCH`; el número vive en el encabezado de [`glot.sh`](../glot.sh) y en la tabla de este documento (desde v0.3.0 también en `glot version`).
- **Puerta de entrada:** ninguna versión se empieza a implementar sin el snapshot de la anterior en `versions/`. Si falta, se copia `glot.sh` con el sufijo de su versión y solo después se reanuda la implementación de la nueva.
- **Cierre de versión:** copiar `glot.sh` a `versions/glot_<versión>.sh`, marcar la fila del log como `✅` y empezar la versión siguiente en `glot.sh`.
- Los snapshots de `versions/` **no se editan**: son la foto de cómo estaba el script en esa versión y permiten ver la progresión.
- `versions/` contiene [`glot_0.1.0.sh`](../versions/glot_0.1.0.sh), [`glot_0.2.0.sh`](../versions/glot_0.2.0.sh), [`glot_0.3.0.sh`](../versions/glot_0.3.0.sh), [`glot_0.4.0.sh`](../versions/glot_0.4.0.sh), [`glot_0.5.0.sh`](../versions/glot_0.5.0.sh), [`glot_0.6.0.sh`](../versions/glot_0.6.0.sh), [`glot_0.7.0.sh`](../versions/glot_0.7.0.sh), [`glot_0.8.0.sh`](../versions/glot_0.8.0.sh), [`glot_0.9.0.sh`](../versions/glot_0.9.0.sh), [`glot_0.10.0.sh`](../versions/glot_0.10.0.sh), [`glot_0.11.0.sh`](../versions/glot_0.11.0.sh), [`glot_0.12.0.sh`](../versions/glot_0.12.0.sh) y [`glot_1.0.0.sh`](../versions/glot_1.0.0.sh).
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
| GitHub Copilot CLI 1.0.88 (opcional) | Validador automático de `validate` (v0.10.0) | `copilot --version` |

---

## 🧪 Cómo verificar / How to verify

```bash
bash -n scripts/glot.sh              # sintaxis
./scripts/tests/glot_test.sh        # contrato, verbos, estado, catálogo, ejecución, delegación, creación, evidencia, cierre, validación, perfiles de modelo, higiene y punteros, plantillas, archivado y códigos (551 comprobaciones)
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
./scripts/glot.sh -n new php algorithms/naive_sort          # esqueleto: comando y normalización
./scripts/glot.sh new python algorithms/naive_sort          # aplazado al agente: skipped
./scripts/glot.sh -n save 4a php algorithms/naive_sort      # commit guiado: git add + mensaje
./scripts/glot.sh -n use php algorithms/naive_sort   # ensayo de `use`: plan sin tocar nada

# Estado en un directorio propio, sin tocar el del usuario / state in its own dir
export GLOT_STATE_DIR=$(mktemp -d)
./scripts/glot.sh set lang php      # set: lang (stderr)
./scripts/glot.sh get lang          # php
./scripts/glot.sh list              # lang=php
```

`shellcheck` no está instalado en este entorno; conviene añadirlo a la verificación cuando exista CI.
