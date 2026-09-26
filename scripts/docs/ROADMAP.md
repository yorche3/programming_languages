# 🧭 Roadmap de `glot` / `glot` roadmap

**ES:** Capas, versiones y el criterio que decide en qué orden llegan. La versión viva y su log están en [`VERSIONS.md`](VERSIONS.md); el ciclo que estas capas sirven está en [`SPRINT.md`](SPRINT.md) y, como norma del monorepo, en [`../../docs/WORKFLOW.md`](../../docs/WORKFLOW.md).

**EN:** Layers, versions and the rule that decides their order. The live version and its log are in [`VERSIONS.md`](VERSIONS.md); the cycle these layers serve is in [`SPRINT.md`](SPRINT.md) and, as monorepo policy, in [`../../docs/WORKFLOW.md`](../../docs/WORKFLOW.md).

---

## 🎯 Objetivo / Goal

**ES:** `glot` convierte el ciclo de trabajo de un módulo —**situar, crear, ejecutar, delegar, cerrar y publicar**— en comandos reproducibles, y deja la evidencia en el repositorio.

**EN:** `glot` turns the per-module work cycle —**locate, create, run, delegate, close and publish**— into reproducible commands, and leaves the evidence in the repository.

| Responsabilidad / Responsibility | Detalle / Detail |
|---|---|
| Resolver catálogo y estado | Lenguaje, fase, módulo, rama y especificación del trabajo en curso |
| Preparar el entorno | Directorio del módulo, rama de trabajo y, desde L9, la toolchain esperada |
| Ejecutar y verificar | Comandos nativos del lenguaje desde cualquier directorio, leyendo el estado |
| Preparar los encargos de IA | Arma el encargo para el agente con las plantillas versionadas de `scripts/prompts/`; no lo ejecuta por su cuenta |
| Registrar la evidencia | Salidas reales, checklist de cierre, roadmap y puntero del submódulo |

**No-objetivos / Non-goals:** no es un módulo del roadmap ni toca `.gitmodules` o los contadores `X/50`; no escribe documentación (la encarga y la valida); no sustituye al agente de VS Code; no publica nada que no se le pida explícitamente; no instala toolchains antes de L9; no es un gestor de proyectos.

---

## 📐 Criterios de orden / Ordering rules

1. **Primero leer, después mutar.** Los verbos que solo consultan llegan antes que los que escriben.
2. **El autocompletado acompaña al catálogo**, no llega al final: los datos (`.gitmodules`, el bloque de contadores de `docs/ROADMAP.md`, la guía de inicialización y `data/languages.tsv`) son lo que el autocompletado necesita. El catálogo de datos no sustituye a la guía: la guía manda y el harness comprueba que los dos no se separan.
3. **Todo verbo que muta trae `-n/--dry-run` desde el día uno** y nunca pregunta: el dato llega por argumento o por stdin.
4. **La capa de shell entra con la instalación.** `glot` se **ejecuta** hasta la v1.0.0; la función cargable con `source` (la única forma de que `use` pueda hacer `cd`) llega con `install`, que es quien toca `.bashrc`.
5. **Ninguna versión existe sin un paso del sprint detrás.** Cada capa cubre pasos concretos de [`SPRINT.md`](SPRINT.md).
6. **Puerta de entrada al archivo.** Ninguna versión se empieza a implementar sin el snapshot de la anterior en `versions/`; si falta, se copia `glot.sh` con el sufijo de su versión y solo después se reanuda la implementación.

---

## 🗂️ Capas / Layers

| Capa | Qué es / What it is | Versión / Version |
|:----:|---------------------|:-----------------:|
| L0 | Contrato de verbos y dispatcher | 0.3.0 ✅ |
| L1 | Almacén de estado clave/valor | 0.4.0 ✅ |
| L2 | Asignación: situar el trabajo (`use`) | 0.5.0 ✅ |
| L2.5 | Catálogo (`langs`, `modules`, `progress`), comandos nativos y autocompletado | 0.6.0 ✅ |
| L3 | Ejecución: `test` y `verify` | 0.7.0 ✅ |
| L4 | Delegación: `prompt` (encargos de IA) y `ask` (envío al delegado) | 0.8.0 ✅ |
| L5 | Creación y registro: `new`, `save` | 0.9.0 ✅ |
| L6 | Evidencia y cierre: `evidence`, `close`, `validate` | 0.10.0 ✅ |
| L6.5 | Perfiles de modelo por encargo: `model:` en cada plantilla y catálogo de perfiles con los modelos de Copilot | 0.11.0 ✅ |
| L7 | Higiene y punteros: `status`, `pointer`, `clean` | 0.12.0 ✅ |
| L8 | Instalación: `install`, función cargable, `doctor` completo | 1.0.0 ✅ |
| L9 | Instalación de toolchains por lenguaje (`mise`, `nvm`, `pyenv`): **instalar**, no comprobar (la comprobación entra en el `doctor` completo de la v1.0.0) | después |

---

## 🗓️ Versiones / Versions

| Versión | Capa | Pasos del sprint | Añade | Por qué ahí / Why there |
|---------|:----:|:----------------:|-------|-------------------------|
| 0.4.0 | L1 | — | `set`, `get`, `unset`, `list`, `path` en XDG | Cimiento que consumen `use`, `test` y el progreso |
| 0.5.0 | L2 | 2–3 | `use <lenguaje> <fase>/<módulo> [tipo]`: valida contra `.gitmodules` y sitúa el trabajo según cuatro estados (nuevo, en curso, reanudar, cerrado): activa o crea la rama desde `main`, la publica con upstream, crea la carpeta si falta y no toca nada cuando hay trabajo sin confirmar. Guarda el estado e imprime la ruta | Es el paso que sitúa el trabajo; el `cd` real que lo completa llega con la capa cargable |
| 0.6.0 | L2.5 | apoyo a todos | `langs`, `modules`, `progress` y `completion`: el **conversor de nombres** (id canónico → documento, rama, commit y carpeta), los comandos nativos por lenguaje en `data/languages.tsv` y el autocompletado de bash y zsh con completado dinámico | Los datos ya existen; el autocompletado los necesita, y `use` deja de depender de un heurístico de nombres |
| 0.7.0 | L3 | 5–7 | `test` (suite del módulo asignado, con el comando nativo del lenguaje) y `verify` (sintaxis/formato), desde cualquier directorio, con el código `4` de verificación fallida y los marcadores `{modulo}`/`{Modulo}`/`{suite}` resueltos contra el módulo real | Primer consumo real del catálogo y del estado; la tabla de comandos se corrige contra los módulos ya homologados
| 0.8.0 | L4 | 4–8 | `prompt`/`ask`: arma el encargo para el agente con las plantillas **versionadas** de `scripts/prompts/`, con el estado del sprint expandido y `GLOT_DELEGATE` como estrategia enchufable | **Solo imprime texto** (o lo envía): no muta nada, así que va antes que la capa que sí muta |
| 0.9.0 | L5 | 4 | `new` (un verbo, dos modos: ejecuta el inicializador o construye el esqueleto manual, y normaliza lo que el inicializador deja) y `save` (commit guiado desde el catálogo de commits); tabla de inicialización ampliada con tipo/comando/normalización y el encargo `suite` separado de `scaffold` | Reutiliza catálogo y estado; elimina el andamiaje y el commit manual repetidos. Lo que exige leer la especificación (runners de ejemplo, nombres predefinidos) sigue siendo del agente |
| 0.10.0 | L6 | 7–8 | `evidence` (salidas reales), `close` (checklist + roadmap) y `validate` (validador automático con Copilot CLI) | El cierre documental requiere validación: la ejecuta el agente, el script la encarga y la comprueba |
| 0.11.0 | L6.5 | 4–8 | **Perfiles de modelo por encargo**: `model:` en el frontmatter de cada plantilla y un catálogo de perfiles **con los modelos que ofrece Copilot** —uno económico con esfuerzo bajo para validar y documentar, y el más capaz para implementar—, con tope de créditos por corrida | La delegación y la validación ya existen; el modelo es la palanca de calidad y de coste, y va después de tenerlas |
| 0.12.0 | L7 | 1, 8 | `status` (submódulos, ramas, punteros), `pointer` (actualiza el puntero del submódulo en el monorepo) y `clean` de artefactos con `submodule sync`, que es **apoyo a los pasos 5–6** y no un paso por sí mismo | Ops diaria; primero solo lectura, las mutaciones con `-n` |
| 1.0.0 | L8 | todos | `install`/`uninstall` (copia estable, `.bashrc` + completions), **capa cargable** (`use` hace el `cd` real), estado **por raíz**, `doctor` completo (instalación, shells, toolchains) y encargos con `sources:` | 1.0 = objetivo original cumplido |
| ⏳ | L9 | — | Versión esperada por lenguaje y comprobación/instalación | Segunda acepción de «manejador de versiones»; llega después del ciclo del roadmap |

### Deuda técnica declarada / Declared technical debt

| Deuda | Cuándo se paga |
|-------|----------------|
| Hasta la v1.0.0 el `cd` no es real: se usa `cd "$(glot use …)"` | v1.0.0 (`install` + capa cargable) |
| El **estado del sprint es global** (XDG), sin clave de repositorio: dos monorepos comparten `lang/phase/module`, así que un sprint en un banco de pruebas pisa el del trabajo real. Medido el 2026-09-23 ejecutando un sprint completo en un laboratorio aparte, que hubo que aislar con `GLOT_STATE_DIR` | v1.0.0 (`install` + capa cargable): clave por raíz del monorepo |
| Los **encargos citan rutas y nombres del monorepo real** (`docs/core/00_Project_Initialization_Guide.md`, `AGENTS.md`, los módulos homologados del lenguaje y el nombre `yorche3/programming_languages` en prosa) y no comprueban que existan. Medido el 2026-09-23: en el laboratorio faltaban y hubo que añadirlas a mano | v1.0.0: raíz del monorepo como marcador del encargo y comprobación de fuentes |
| **La instalación congela los datos**: `install.meta` solo registra el `sha` de `glot.sh`, así que `doctor` no ve que la copia lleve `data/` o `prompts/` viejos (medido el 2026-09-25: la copia seguía diciendo `install_stale: no` con el comando de pruebas de Ada anterior) | v1.1.0 — que el `sha` cubra `data/` y `prompts/`, o que `doctor` informe la deriva de datos |
| El harness limpia `GLOT_ROOT` y `GLOT_TOOLCHAINS_FILE`, pero **no** `GLOT_STATE_DIR`: con esa variable exportada (laboratorio) falla la comprobación de desinstalado (medido el 2026-09-25) | v1.1.0 — añadir el `unset`. **Resuelto el 2026-09-26** (P5): el harness limpia `GLOT_STATE_DIR` y `GLOT_DATA_DIR`. Nota: al reproducirlo con `GLOT_STATE_DIR` exportada la suite ya salía en verde, porque desde la v1.0.0 el harness fija antes `GLOT_STATE_FILE`, que manda sobre el directorio; el `unset` se añade igualmente para que el aislamiento no dependa de ese orden |
| `docs-module` enumera las secciones del README de forma **cerrada** y quedó atrás respecto a la plantilla ampliada el 2026-09-25 (13 secciones) | v1.1.0 — remitir a «todas las secciones obligatorias de la plantilla» |
| La sección «Secuencias de varios pasos» de la guía de inicialización no la valida nadie: la incoherencia `test`/`tests` de Ada vivió ahí sin aviso (la tabla sí se compara con el catálogo). Medido el 2026-09-26 en el laboratorio: la secuencia de ReScript es **imposible** tal como está escrita (`npm install` sin `package.json`) y los layouts que genera la guía para F# y OCaml **no coinciden** con los módulos homologados | v1.1.0 — corregir la guía con la medición y ampliar la deriva del harness a esa sección. **Resuelto el 2026-09-26** (P5): el harness compara la sección, el marcador de secuencia de la tabla maestra y `init_sequences.tsv` en los dos sentidos, y la comprobación **encontró deriva el mismo día**: la guía decía que son **tres** los generadores que crean la carpeta y el dato declara **cuatro** (faltaba `common-lisp`; medido: `quickproject:make-project` crea el directorio del proyecto). La guía queda corregida |
| El catálogo de pasos del sprint no tiene paso de **corrección**: un artefacto de pytest versionado en un módulo se arregló a mano, fuera del flujo | ⏳ **Bloque B** (v1.2.0) — hay camino alternativo (commit manual) y falta decidir si es paso propio o parte de `suite` |
| Con la capa cargable, `use` hace el `cd` real en un **subproceso**: `glot use … \| tail -1` pierde el `cd` (limitación de bash, no del verbo) | ⏳ **Bloque B** (v1.2.0) — es una nota en la ayuda, no un bloqueo del ciclo |
| Cinco lenguajes no tienen fila en `data/toolchains.tsv` (ada, common-lisp, rescript, rexx, scala): `doctor` no comprueba su toolchain, así que un sprint en ellos no avisa de una herramienta ausente | ⏳ **Bloque B** (v1.2.0) — la fila exige un comando de versión **verificado**: el 2026-09-26 `gnat` no está instalado y `uv` tampoco, así que no se puede medir aquí |
| La política de **CI por submódulo** no está definida: el workflow debe usar el comando del catálogo (no copiarlo) y hay que decidir si convive con el acta de `docs/evidence/`, que vive en el monorepo | ⏳ **Bloque B** (v1.2.0) — es una decisión de diseño, no un bloqueo; se documenta antes de añadir workflows |
| La **inicialización multi-paso** no está en el catálogo: los lenguajes que necesitan dos o más comandos (Ada, C#, F#, Haxe, ReScript, Ruby…) aparecen como `deferred`/`manual` y `glot new` no ejecuta ni imprime esos comandos. Medido el 2026-09-25: `glot -n new ada algorithms/data_structures` responde `sin inicializador validado… skipped` y remite a `glot prompt scaffold`, sin listar `alr init --lib` + `alr init --bin tests`, que solo están en la guía de inicialización. **Medición del 2026-09-26** (tabla abajo): Ada, C#, F#, Groovy y Kotlin se automatizan **sin interacción**; V, Java, OCaml, ReScript, Python, Clojure, Nim y C++ se quedan manuales | v1.1.0 — que el catálogo exprese la secuencia, que `new` la imprima y, si se acuerda, la ejecute **solo** en los casos no interactivos |
| **Los encargos no se descubren**: no hay verbo ni alias para ellos y no aparecen en el autocompletado, así que `glot suite` devuelve `2` por verbo desconocido cuando lo que se quiere es `glot prompt suite`. Medido el 2026-09-25 | v1.1.0 — completar `glot prompt <TAB>` con los seis encargos y que el verbo desconocido sugiera el encargo homónimo. **Resuelto el 2026-09-26** (P7): el autocompletado ya listaba los encargos en vivo desde el registro (ahora siete), y `glot suite` responde `2` con `quizá buscabas / maybe you meant: glot prompt suite`; el harness lo comprueba con el encargo real y con un nombre con ruta |
| El encargo `suite` **no define los contratos idiomáticos**: la especificación da los nombres y la semántica, pero no el **tipo nuevo** del lenguaje ni las firmas, así que quien escribe la suite tiene que inventar la API antes de que exista la implementación. Medido el 2026-09-25 escribiendo `data_structures_basics` en Ada | v1.1.0 — que el encargo exija declarar el tipo nuevo, el `init` homologado y el dominio de valores antes de escribir la suite |
| El **contrato no tiene paso propio** y acaba escrito dentro de `4b`: el encargo `suite` prohíbe tocar `src/`, pero sin contrato previo la suite no compila, así que el sprint declaró el contrato de `data_structures_basics` fuera de su paso. El orden natural —contrato primero, suite después— no está ni en el catálogo de commits ni en la decisión «Paso 4 en dos commits» de la v0.9.0. Medido el 2026-09-25 con `data_structures_basics` en Ada | v1.1.0 — dar al contrato su propio paso antes de la suite (o incluirlo en `4a`), con fila propia en `data/commits.tsv`, y **un commit por artefacto** (nunca varios mensajes en un solo commit): el historial del sprint se lee como se trabaja. **Resuelto el 2026-09-26** (P6): el contrato es el paso `4b` con el encargo `contract` y la suite se desplaza a `4c` |

**ES:** La deuda se reparte en **dos bloques** para que la v1.1.0 no nazca cargada. Abre la versión cuando `core.algorithms.data_structures_basics` y `core.algorithms.data_structures_advanced` cierren `50/50`.

**EN:** The debt is split into **two blocks** so that v1.1.0 does not start overloaded. The version opens when `core.algorithms.data_structures_basics` and `core.algorithms.data_structures_advanced` reach `50/50`.

- **✅ Bloque A — entra en la v1.1.0 (8 entradas).** Es lo que **desbloquea el uso diario**: la secuencia de inicialización en el catálogo; el paso propio del contrato antes de la suite y el contrato idiomático en el encargo `suite`; los encargos descubribles desde `glot prompt`; la deriva de datos en `install.meta`/`doctor`; el `unset GLOT_STATE_DIR` del harness; la validación de «Secuencias de varios pasos» con la corrección medida; y `docs-module` remitiendo a la plantilla vigente.
- **⏳ Bloque B — se aplaza a la v1.2.0 (4 entradas).** No bloquea el ciclo: el paso de corrección, el `cd` en tubería, las cinco filas de `toolchains.tsv` y la política de CI por submódulo.

**ES:** El orden de aplicación del bloque A y la verificación de cada paso están en [`PLAN_v1.1.0.md`](PLAN_v1.1.0.md).

**EN:** The work order for block A and each step's verification are in [`PLAN_v1.1.0.md`](PLAN_v1.1.0.md).

**ES:** Criterio del reparto: entra en la v1.1.0 lo que **impide cerrar un sprint** o lo que hace que `doctor`/`new` informen mal; se aplaza lo que tiene camino alternativo, exige una medición que hoy no se puede hacer (toolchain ausente) o es una decisión de diseño pendiente.

**EN:** Split rule: v1.1.0 takes what **blocks closing a sprint** or makes `doctor`/`new` report wrongly; the rest is postponed when a workaround exists, when it needs a measurement that cannot be taken today (missing toolchain) or when it is a pending design decision.

**ES:** Pagadas: los commits a mano se acabaron en la v0.9.0 (`save`), el puntero del submódulo dejó de actualizarse a mano en la v0.12.0 (`pointer` prepara y `save 9` confirma), y desde el 2026-09-25 el harness aísla el `PATH` del `HOME` desechable para no depender de una instalación real de `glot`.

**EN:** Paid: hand-made commits ended in v0.9.0 (`save`).

#### 🧪 Inicialización multi-paso: medición del 2026-09-26 / Multi-step initialisation measurement

**ES:** Cada secuencia se ejecutó **de verdad** en `~/glot-lab/init-lab/`, fuera del monorepo y de los submódulos, y el resultado se comparó —sin tocarlos— con el módulo homologado `naive_sort` del repo de cada lenguaje. `✅` no interactivo y layout coincidente · `⚠️` funciona con matices · `❌` no se puede automatizar así.

**EN:** Every sequence was **actually run** in `~/glot-lab/init-lab/`, outside the monorepo and the submodules, and the result was compared —without touching them— against the `naive_sort` homologated module in each language repo. `✅` non-interactive and matching layout · `⚠️` works with caveats · `❌` cannot be automated this way.

| Lenguaje | Secuencia medida | Interactivo | Layout homologado | Normalización que falta |
|---|---|:--:|:--:|---|
| Ada | `alr -n init --lib --in-place {module}` + `alr -n init --bin tests` (**desde la carpeta del módulo**, que `use` ya creó) | ✅ | ✅ | Licencia (`GPL-3.0-or-later`; el default es `MIT OR Apache-2.0 WITH LLVM-exception`) y `tests/alire.toml`: `description`, `[[depends-on]]`, `[[pins]] path='..'`, `aunit`. **Sin `--in-place` el crate sale anidado** (`{module}/{module}/`), que es el choque con la carpeta que crea `use` |
| C# | `dotnet new sln/classlib/xunit` + `dotnet sln add` (4 comandos) | ✅ | ✅ (`.slnx`) | `<ProjectReference>` al proyecto de `src` (el generador no lo añade), borrar `Class1.cs`/`UnitTest1.cs`, añadir `.gitignore` |
| F# | igual que C# con `-lang F#` | ✅ | ❌ | La guía propone `-o src/{Module}` (anidado) y el repo es **plano** (`src/{Module}.fsproj`); ídem C# (referencia, plantillas por defecto, `.gitignore`) |
| Haxe | `mkdir -p src test` + `haxelib install utest` | ✅ | n/a | `build.hxml` y `RunTests.hx` son contenido del sprint, no inicialización |
| ReScript | la guía dice `mkdir -p src test` + `npm install` | ❌ | ❌ | `npm install` **falla** (`ENOENT package.json`): el manifiesto va primero; la secuencia de la guía es inviable |
| Ruby | `mkdir -p src test` + `bundle init` + `bundle install` | ✅ | ✅ | El `Gemfile` nace sin `rspec`: añadirlo y crear `.rspec` |
| V | `v init --lib` (descripción, versión, licencia) | ✅ con `expect` | ❌ | Con `expect` concluye y genera **biblioteca**; crea `{m}.v` en raíz, `tests/`, `.editorconfig`, `.gitattributes` y un **`git init` anidado** (que hay que quitar). **R1/R3: se usa y se completa**; el módulo homologado (`src/{m}.v` + `test/`) se actualiza al retomar V (R6) |
| Groovy | `gradle init --type groovy-library --dsl groovy --project-name {m} --package {m} --use-defaults` | ✅ | ✅ (`lib/`) | Borrar `Library.groovy`/`LibraryTest.groovy` |
| Kotlin | ídem con `--type kotlin-library --dsl kotlin … --no-split-project` | ✅ | ✅ (plano) | Borrar `Library.kt`/`LibraryTest.kt` |
| Java | `mvn archetype:generate … -DinteractiveMode=false` | ✅ | ❌ | Genera carpeta anidada, paquete `com.example`, `App`/`AppTest` y otro JUnit; el repo es plano, `com.programminglanguages`, JUnit 5.11.3 |
| OCaml | `dune init proj {module}` | ✅ | ❌ | Genera `lib/`+`bin/`+`.opam`; el repo es `src/` plano sin `.opam` |
| Python | `uv init --lib` (`uv` 0.12.19 instalado) | ✅ | ❌ | Genera **biblioteca** (`.gitignore`, `.python-version`, `README.md`, `pyproject.toml`, `src/{paquete}/__init__.py`, `py.typed`, backend `uv_build`). **R1: se usa y se completa** (`conftest.py`, `tests/`, configuración de pytest; el runner pasa a `uv run pytest`). Módulo homologado a actualizar (R6) |
| Clojure | `clojure -Sdeps '{:deps {io.github.seancorfield/deps-new {:git/tag "v0.9.0" :git/sha "da2f764f…"}}}' -Tnew create :template lib :name {m} :target-dir {m}` | ✅ | ✅ | El comando del catálogo (`clojure -T:build new`) es **inválido**: el `build.clj` del repo no tiene tarea `new`. Con `deps-new` el layout coincide (`src/{m}/{m}.clj`, `test/`, `build.clj`, `deps.edn`) y `clojure -T:build test` corre (falla solo por el test de plantilla, que el sprint sustituye) |
| Nim | `nimble init` (tipo de paquete, versión, descripción, licencia y versión mínima de Nim) | ✅ con `expect` | ❌ | **R1: se usa** (`library` + Enter) y se completa: mover `src/{m}/{m}.nim`→`src/{m}.nim`, `tests/`→`test/` y añadir la `task test` del `.nimble`. Módulo homologado a actualizar (R6) |
| C++ | — (Bazel escrito a mano) | n/a | ✅ por construcción | No hay generador: `MODULE.bazel`, `WORKSPACE`, `BUILD` y `.bazelversion` son del esqueleto manual |

**ES:** Política de inicialización cerrada el 2026-09-26 (sustituye al criterio anterior de «solo si el layout coincide»):

- **R1** — Se usa la herramienta del ecosistema **instalada** (las versiones de WSL son el estándar nuevo) **aunque su salida difiera** de la convención anterior; lo que falte (carpetas, manifiesto, configuración del runner) se completa a mano, como haría un desarrollador. `glot` solo **automatiza ejecutar comandos**.
- **R2** — Se descarta la herramienta cuyo esqueleto es para una **aplicación** y no para una biblioteca.
- **R3** — Se acepta la herramienta que añada documentos o carpetas extra que no alejen del proyecto de biblioteca.
- **R4** — La **herramienta de construcción** puede cambiar a la más usada del lenguaje (Make, CMake, meson…).
- **R5** — Decide el **uso y la aceptación de la comunidad** del lenguaje.
- **R6** — Si la herramienta impone otra estructura, **el módulo homologado se actualiza** al retomar ese lenguaje; es deuda declarada, no trabajo de esta versión.

**ES:** Reparto resultante: **33 `tool` · 17 `manual` · 0 `deferred`**. Pasan a `tool` doce lenguajes: los seis que estaban `deferred` (`ada`, `groovy`, `kotlin`, `clojure`, `nim`, `python`) y seis que estaban `manual` (`julia`, `vala`, `perl`, `common-lisp`, `racket`, `v`). `cpp` queda `manual` (sin generador) y `java` **baja a `manual`** por **R2** (el arquetipo `quickstart` trae `main`: es aplicación, no biblioteca). Con R6, hay que **actualizar el módulo homologado** de `fsharp`, `nim`, `python`, `julia`, `vala`, `perl`, `common-lisp`, `racket` y `v` cuando se retomen.

**EN:** Policy closed on 2026-09-26 (it replaces the earlier “only if the layout matches” rule): **R1** use the **installed** ecosystem tool even when its output differs, completing what is missing by hand; **R2** reject tools whose skeleton is an **application**; **R3** accept extra docs or folders that keep the library project intact; **R4** the build tool may move to the language's most used one; **R5** community acceptance decides; **R6** when the tool imposes another structure, **the homologated module is updated** when that language is retaken. Result: **33 `tool` · 17 `manual` · 0 `deferred`**.

**ES:** Herramientas instaladas el 2026-09-26 para poder medir: `uv 0.12.19` (`~/.local/bin`), `Module::Starter 1.82` (`~/perl5`; su `bin` y `PERL5LIB` son parte de la normalización de Perl) y `quickproject` mediante el quicklisp ya configurado de `ros`. `expect 5.45.4` conduce los interactivos (`nim`, `v`). La tabla de decisión completa —lenguaje a lenguaje, con la normalización y si el módulo homologado hay que actualizarlo— está en [`PLAN_v1.1.0.md`](PLAN_v1.1.0.md).

**EN:** Tools installed on 2026-09-26 so the measurement could be taken: `uv 0.12.19`, `Module::Starter 1.82` and `quickproject` through the already-configured `ros` quicklisp; `expect 5.45.4` drives the interactive ones. The full decision table lives in [`PLAN_v1.1.0.md`](PLAN_v1.1.0.md).

#### 📍 Dónde queda el autor: `use`, `new` y la carpeta del módulo / Where the author ends up

**ES:** `use` **crea y devuelve la carpeta del módulo** (`{lang}/core/{fase}/{módulo}`) y la capa cargable hace el `cd` real hasta ahí; `new` ejecuta su comando **dentro de esa carpeta** y en un subproceso, así que **no mueve al autor**: sigue donde lo dejó `use`, que es donde vive el proyecto y donde `git` funciona (el submódulo es el repositorio).

**EN:** `use` **creates and prints the module folder** (`{lang}/core/{phase}/{module}`) and the loadable layer performs the real `cd` there; `new` runs its command **inside that folder** in a subshell, so it **does not move the author**: they stay where `use` left them, which is where the project lives and where `git` works (the submodule is the repository).

**ES:** Consecuencia para el catálogo multi-paso: **no hace falta cambiar `use`**. Lo que la secuencia necesita es declarar **el directorio de trabajo de cada paso**, que en todos los casos medidos es la carpeta del módulo:

1. los comandos que crean carpeta por su cuenta van con **`--in-place`** (Ada) o admiten destino explícito (`-o` en C#/F#, `:target-dir` en Clojure);
2. los que deben correr dentro del proyecto (Ada `--bin tests`, `dotnet sln add`, `bundle install`) ya están en esa carpeta.

Y la alternativa de «volver a `{fase}`» no aporta nada: desde `{módulo}` funcionan igual `git add`, `glot save`, `glot test` y la suite, porque el estado del sprint y el repo del submódulo **no dependen del `cwd`**. Se deja el comportamiento actual —el autor termina dentro del proyecto— y se documenta en la ayuda del verbo.

**EN:** Multi-step catalogue consequence: **`use` does not need to change**. The sequence must declare **each step's working directory**, which in every measured case is the module folder: (1) commands that create the folder themselves run with **`--in-place`** (Ada) or accept an explicit target (`-o` in C#/F#, `:target-dir` in Clojure); (2) commands that must run inside the project (Ada `--bin tests`, `dotnet sln add`, `bundle install`) are already there. The “return to `{phase}`” alternative adds nothing: from `{module}`, `git add`, `glot save`, `glot test` and the suite all work, because sprint state and the submodule repo **do not depend on the `cwd`**. Current behaviour stays —the author ends inside the project— and it is documented in the verb's help.

---

## 🤝 Reparto de responsabilidades: script y agente / Script and agent split

**ES:** `glot` es el **orquestador**: resuelve catálogo y estado, ejecuta los comandos de terminal (git, ramas, inicialización, tests, lint), captura las **salidas reales** y prepara el encargo. La parte documental (generar o modificar READMEs, checklist y roadmap) la ejecuta el **agente de VS Code**, porque requiere validación y criterio. La delegación se diseña como estrategia enchufable: por defecto el encargo se imprime en `stdout` (listo para pegar en el chat) y, si el entorno lo permite, se envía a un comando definido en `GLOT_DELEGATE`. Comprobado en este entorno: `code chat` **no está disponible** (el CLI remoto pasa `chat` a Electron) y `code agent` responde `The 'agent' command is not supported by the remote CLI`, así que el valor por defecto es imprimir.

**EN:** `glot` is the **orchestrator**: it resolves catalog and state, runs terminal commands (git, branches, initialization, tests, lint), captures **real outputs** and prepares the request. The documentation part (creating or modifying READMEs, checklist and roadmap) is executed by the **VS Code agent**, because it needs validation and judgement. Delegation is a pluggable strategy: by default the request is printed to `stdout` (ready to paste into the chat) and, when the environment allows it, it is piped to a command set in `GLOT_DELEGATE`. Verified in this environment: `code chat` is **not available** and `code agent` answers `The 'agent' command is not supported by the remote CLI`, so the default is printing.

La política del validador automático (invocación, modelo y coste, advertencias) está en [`VALIDATION.md`](VALIDATION.md).

---

### Decisiones cerradas de la v0.9.0 / Closed decisions for v0.9.0

**ES:** Las decisiones que la L5 tenía abiertas se resolvieron el 2026-09-22, antes de escribir código.

**EN:** The decisions L5 had pending were resolved on 2026-09-22, before writing any code.

| Tema | Decisión |
|------|----------|
| `new` y `scaffold` | **No hay verbo nuevo**: `new` es el verbo del script, con dos modos (`tool` ejecuta la herramienta, `manual` construye el esqueleto). `scaffold` sigue siendo el **encargo de IA** que ajusta lo que exige leer la especificación |
| Datos del inicializador | La leyenda de la guía (✅ verificado · 🔧 ecosistema · ✍️ manual) se **recupera como dato**: tipo, comando y normalización son columnas del catálogo, verificadas ejecutando cada inicializador en un directorio temporal y con la entrada cerrada. **Un caso que no se pudo verificar no se añade** |
| Alcance de `new` | Esqueleto y normalización, **sin la suite**: las pruebas son del encargo `suite` (paso 4c). El directorio del módulo lo prepara `use`; `new` no lo inventa y no pisa contenido existente |
| Paso 4 en tres commits | `4a` esqueleto (`chore({phase}): add scaffold for {module}`), `4b` contrato (`chore({phase}): add contract for {module}`) y `4c` suite (`chore({phase}): add suite for {module}`). Al insertar un paso **en medio**, los siguientes se recorren (v1.1.0) |
| `save` | El mensaje sale del **catálogo de commits** (paso o alias del encargo), nunca escrito a mano; añade el submódulo completo; confirma **solo** en el submódulo; **nunca** hace push. Los pasos del monorepo esperan a `close` y `pointer` |

---

### Decisiones cerradas de la v0.10.0 / Closed decisions for v0.10.0

**ES:** Las decisiones de la L6 se resolvieron el 2026-09-22, antes de escribir código.

**EN:** The L6 decisions were resolved on 2026-09-22, before writing any code.

| Tema | Decisión |
|------|----------|
| Casa de la evidencia | `docs/evidence/{fase}/{modulo}/{lenguaje}.md`, en el monorepo y junto al checklist y al roadmap que `close` toca. Antes de esto `VALIDATION.md` citaba un `$EVIDENCE_DIR` que ningún documento definía |
| Código de `validate` | `4` con hallazgos y `1` sin validador: el contrato mantiene separado «no pude ejecutarlo» de «lo ejecuté y está mal». `VALIDATION.md` preveía `1` para las dos cosas y se corrige |
| `close` y el roadmap | Edita el contador y la lista entre paréntesis (nombre de presentación y orden derivados de las líneas ya cerradas a `50/50`); `-n` enseña el diff exacto. **No confirma**: el commit es del autor, o de `save` cuando el ámbito `monorepo` se habilite |
| Contador de fase | «Lenguajes con **todos** los módulos de la fase cerrados», sobre los 50 de `.gitmodules`: Fase 0 `50/50`, Fase 1 hoy `0/50`. Se dice en la propia cabecera de la fase |
| Lenguaje por directorio | El objetivo se resuelve **argumentos → estado → directorio**. El estado manda sobre el directorio a propósito; el directorio es el último recurso, para que `cd php && glot test …` no exija `use` |
| `hello` | Se retira en la **v0.10.0**, antes de lo previsto (el contrato decía v1.0.0), y el aviso de verbo desconocido deja de ofrecer el saludo |
| Perfiles de modelo | Versión propia: **L6.5 → 0.11.0**, con L7 desplazada a la 0.12.0. Se configurarán **solo los modelos que ofrece Copilot**, con esfuerzo y tope de créditos ajustados por encargo. El proveedor propio (BYOK) **queda fuera**: exige variables de entorno y `glot` no gestiona claves ni proveedores; el mecanismo queda documentado en [`VALIDATION.md`](VALIDATION.md) por si algún día se quiere enchufar |
| Veredicto de `validate` | Se **lee**, no se interpreta: la plantilla `validate` exige una última línea `glot:validate verdict=clean\|findings findings=N` y `glot` solo acepta esos dos valores. Sin línea, o con otro, devuelve `3` en vez de suponer un resultado |
| Evidencia de la validación | El registro lo escribe `glot` (`docs/evidence/{fase}/{módulo}/{lenguaje}.validate.md`) y **no** se usa `--share`: así funciona también con un validador propio, que no tiene por qué saber escribir sesiones |

---

### Decisiones cerradas de la v0.11.0 / Closed decisions for v0.11.0

**ES:** Las decisiones de la L6.5 se resolvieron el 2026-09-22, antes de escribir código.

**EN:** The L6.5 decisions were resolved on 2026-09-22, before writing any code.

| Tema | Decisión |
|------|----------|
| Qué lleva `model:` | El **id real** del modelo que ofrece Copilot (`gemini-3.8-flash`, `gpt-5.6-terra`, `claude-sonnet-5`…), **no** un alias de perfil: `model:` es clave nativa de los `.prompt.md` de VS Code, así que la plantilla sigue valiendo en el chat del IDE y se lee sin traductor. El alias se descartó por eso |
| El modelo es la clave | La plantilla declara **solo** `model:`; [`data/models.tsv`](../data/models.tsv) fija el esfuerzo, el tope de créditos y el tier de auto. No hay `profile:` en el frontmatter: repetir el mismo dato en dos sitios es una deriva esperando, y el catálogo se audita solo |
| Perfiles | Tres, con nombre de política: `economy` (`gemini-3.8-flash`, esfuerzo `low`, 30 créditos), `balanced` (`gpt-5.6-terra`, `medium`, 90) y `deep` (`claude-sonnet-5`, `high`, 120). El tope del económico es el **mínimo que acepta el CLI** (30): no se puede bajar |
| Reparto por encargo | `economy` para `validate`, `docs-module` y `docs-language`; `balanced` para `scaffold` y `suite`, porque los dos siguen estructuras ya homologadas del lenguaje; `deep` solo para `implement` |
| Cómo llega al delegado | `glot` exporta `COPILOT_MODEL` y `COPILOT_AUTO_TIER` —variables que el CLI sí reconoce— antes del `eval` del delegado, y pasa `--model`, `--reasoning-effort` y `--max-ai-credits` **explícitos** solo en la invocación por defecto de `validate`. A un `GLOT_DELEGATE` propio se le da entorno, no flags: inyectárselos rompería `GLOT_DELEGATE='wc -l'` |
| Precedencia | Manda la **plantilla**, que es el dato versionado del encargo. El override por corrida no se añade en esta versión: si hiciera falta, será una variable propia (`GLOT_MODEL`) y una fila de decisión, no un flag escondido |
| Modelo fuera del catálogo | Un `model:` que no está en `data/models.tsv` es un **dato que falta**: código `1`, como un marcador sin resolver. Un perfil pedido por argumento que no existe sería **uso**: código `2` |
| Anti-envejecimiento | La lista de modelos la manda el CLI instalado (`copilot help config`). `doctor` informa de la cobertura del catálogo y de si cada modelo de los perfiles sigue en la lista del CLI, para que una fila vieja se vea antes de usarla |
| Sin BYOK | Confirmado: solo modelos de Copilot. El proveedor propio exige variables de entorno y `glot` no gestiona claves ni proveedores; el mecanismo queda documentado en [`VALIDATION.md`](VALIDATION.md) por si algún día se quiere enchufar |

---

### Decisiones cerradas de la v1.0.0 / Closed decisions for v1.0.0

**ES:** Las decisiones de la L8 se resolvieron el 2026-09-23, antes de escribir código.

**EN:** The L8 decisions were resolved on 2026-09-23, before writing any code.

| Tema | Decisión |
|------|----------|
| Qué deja `install` | **Copia estable**, no un puntero al clon: `glot.sh` + `data/` + `prompts/` a `~/.local/share/glot/`, enlace `~/.local/bin/glot` y los guiones de completado donde cada shell los busca. El bloque del `.bashrc` carga la **copia**, así que mover o borrar el clon no rompe la instalación; `doctor` detecta si la copia quedó vieja respecto al clon |
| Bloque del rc | Delimitado y quirúrgico: `# >>> glot (install) >>>` … `# <<< glot (install) <<<`. `install` y `uninstall` son idempotentes, admiten `-n` y **solo** tocan lo que está entre las dos marcas |
| Capa cargable en bash, no en zsh | La regla 15 del contrato usa `BASH_SOURCE`, que zsh no tiene: la función `glot` (la que hace el `cd` real en `use`) es de bash. zsh conserva el **completado** y sigue usando `cd "$(glot use …)"`. Se dice en la documentación en vez de fingir paridad |
| `use` con `-n` no hace `cd` | La función solo cambia de directorio cuando el verbo es `use` y no hay `-n`: en ensayo la salida es un plan, no una ruta |
| Estado **por raíz** | `<state_dir>/state.<hash8>-<basename>` calculado desde la raíz real del monorepo; `GLOT_STATE_FILE` sigue siendo el override absoluto y `glot path` imprime el fichero **resuelto**. El `state` global viejo no se migra: se avisa una vez y se deja quieto, para que dos monorepos no compartan sprint |
| `doctor` completo | Añade `install:` (bloque presente, ruta que apunta y si existe → instalación rota o vieja), `shell:` (bash/zsh disponibles y si la capa cargable está activa en esta shell), `state_root:` (raíz y fichero resuelto) y `toolchains:` |
| Toolchains: comprobar aquí, instalar en L9 | El **dato** vive en [`data/toolchains.tsv`](../data/toolchains.tsv) (`lang`, `comando`, `serie verificada`), que crece **solo con versiones verificadas** en este entorno (45 de los 50 lenguajes hoy); `doctor` informa de la cobertura y de la presencia y comprueba la **serie del lenguaje del sprint**, porque arrancar las 45 cuesta 5 s medidos y `doctor` se ejecuta a menudo. Un `differs` se informa y no cambia el código; un `missing` sí. L9 queda para **instalar** versiones (el roadmap se ajusta por esto) |
| Encargos sin el nombre del monorepo | Las plantillas dejan de decir `yorche3/programming_languages` en prosa, declaran sus fuentes en el frontmatter (`sources:`) y `glot prompt` **avisa** por stderr si alguna falta; la cabecera del encargo gana la fila `root` |
| Verificación de la 1.0.0 | En el laboratorio, con `HOME` desechable: `install`/`uninstall` sobre un `~` de prueba, `source` en bash real, y el ciclo del sprint en `ruby2`/`php2`/`python2`/`ada2`. Nada se toca en `programming_languages` ni en los 50 submódulos hasta verificarlo |

---

### Decisiones cerradas de la v0.12.0 / Closed decisions for v0.12.0

**ES:** Las decisiones de la L7 se resolvieron el 2026-09-23, antes de escribir código.

**EN:** The L7 decisions were resolved on 2026-09-23, before writing any code.

| Tema | Decisión |
|------|----------|
| `pointer` y el commit | `pointer` **prepara** (verifica la integración, lleva el submódulo al commit integrado, crea y publica la rama `chore/{fase}/{módulo}-pointer` y hace `git add`) y **no confirma**: confirma `save 9`, que es el mismo verbo que confirma el resto del sprint |
| `save` en el monorepo | Se habilita para los pasos de ámbito `monorepo`: `9` añade **solo el submódulo** y `10` añade las rutas del cierre (roadmap, checklist y la evidencia de ese módulo). Sigue **sin hacer push**: eso es del autor |
| Qué apunta `pointer` | Solo a un commit **integrado** en el `main` del submódulo: `fetch` explícito de `origin/main` y `merge-base --is-ancestor`, porque el ref local puede estar viejo y dar un falso OK. La regla de [`CONTRIBUTING.md`](../../docs/CONTRIBUTING.md) —nunca apuntar a una rama de trabajo— pasa de prosa a comprobación. El gitlink se lee con `git ls-tree HEAD -- <lenguaje>` o `git rev-parse HEAD:<lenguaje>`: `git rev-parse <ruta>` devuelve la **ruta**, no el SHA |
| Contrato de `status` | Una línea por lenguaje registrado y **solo lectura**: `lang<TAB>branch<TAB>pointer<TAB>worktree`, con `pointer` ∈ `ok` (el gitlink coincide con el HEAD del submódulo), `differs`, `uninitialised` o `unknown`, y `worktree` ∈ `clean` o `dirty`. Filtrable por lenguaje y **sin resumen**: para contadores ya está `progress` |
| Alcance de `clean` | `git clean -Xfd` —solo lo que el propio `.gitignore` del lenguaje declara como artefacto— en el **directorio del módulo**, más `git submodule sync` del lenguaje. Nunca el monorepo y nunca `docs/`. Borra también lo que el lenguaje ignore aunque parezca útil (`php` ignora `composer.lock`): el dato lo pone su `.gitignore`, no `glot` |
| `clean` y la regla 5 | `clean` no cubre ningún paso del sprint, así que se declara **apoyo a los pasos 5–6** (artefactos viejos fuera antes de verificar) y se dice en la fila de la versión, en vez de relajar la regla |

---

## ✅ Decisiones cerradas / Closed decisions

**ES:** Las tres decisiones que quedaban abiertas para la v0.6.0 se resolvieron el 2026-09-22.

**EN:** The three decisions pending for v0.6.0 were resolved on 2026-09-22.

| Tema | Decisión |
|------|----------|
| Contador de `progress` | El denominador son los **50** submódulos de `.gitmodules`. `progress` informa de los dos números: `registrados 50` (pertenencia a `.gitmodules`) y `homologados X` (módulos terminados). Cualquier contador `X/49` que quedara en la documentación se corrige a `X/50` |
| Vocabulario | Se mantiene **homologado** para el estado «finalizado\|concluido» y para marcar que el estado actual se actualizó; **registrado** queda reservado a la pertenencia técnica a `.gitmodules` |
| División de prompts | `module-readme.prompt.md` cubría README del módulo **más** índices y roadmap: **hecho** en la v0.8.0, con `docs-module` (paso 7) y `docs-language` (paso 8) separados y versionados en `scripts/prompts/` |

### Prompts: alcance actual / Prompts: current scope

**ES:** Las plantillas **normalizadas viven versionadas** en `scripts/prompts/`, junto al tooling: `glot prompt` las lista y las arma con el estado del sprint. `.github/prompts/` sigue siendo el banco local del autor (`.gitignore` lo excluye con «local only, never tracked»): `glot` lo acepta como respaldo cuando falta la versionada, **avisando** de que no viaja en el repositorio.

**EN:** The **normalised templates are versioned** in `scripts/prompts/`, next to the tooling: `glot prompt` lists them and builds them from the sprint state. `.github/prompts/` remains the author's local bank (`.gitignore` excludes it with "local only, never tracked"): `glot` accepts it as a fallback when the versioned one is missing, **warning** that it does not travel with the repository.
