# 🗺️ Roadmap

> **Cierre / Closure:** registra la evidencia en [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) antes de cambiar el estado de un módulo o fase.

> **Leyenda / Legend:**
> - ✅ **Completado** / Completed
> - 🔄 **En progreso** / In progress
> - 📋 **Planificado** / Planned
> - ⏳ **Futuro** / Future

---

## 🚀 Inicio del flujo / Starting the Flow

**ES:** Para comenzar a implementar, abre el primer documento de especificación:

**EN:** To start implementing, open the first specification document:

👉 **[`core/foundations/01_Hello_World.md`](core/foundations/01_Hello_World.md)** ← **INICIO / START**

Luego sigue la numeración secuencial para avanzar en el flujo de implementación:

```text
01_Hello_World.md  →  02_Hello_User.md  →  03_Unit_Test_Calculator.md  →  04_Numbers.md  →  ...
```

---

## 🧠 Curva de aprendizaje / Learning Curve

**ES:** A medida que avanzas en los módulos, se introducen nuevas formas de manejar errores y casos especiales. Esta tabla muestra la progresión de conceptos:

**EN:** As you advance through the modules, new ways of handling errors and edge cases are introduced. This table shows the concept progression:

| Concepto introducido / Concept introduced | Fase / Phase | Dónde se practica / Where practiced |
|-------------------------------------------|-------------|-------------------------------------|
| Bucles, condicionales, funciones / Loops, conditionals, functions | 0 — **Foundations** | `hello_world`, `hello_user`, `unit_test`, `numbers` |
| **Indicadores de fallo compatibles con el lenguaje/API** (sin excepciones): la función devuelve una representación controlada (`-1`, `None`, `null`, `Option/Maybe`, `Result`, etc.) sin interrumpir el flujo / **Language/API-compatible failure indicators** (no exceptions): function returns a controlled representation (`-1`, `None`, `null`, `Option/Maybe`, `Result`, etc.) without interrupting flow | 1 — **Algorithms Pure** | `naive_sort`, `data_structures`, `searching`, `efficient_sort`, `distributed_sort` |
| **Excepciones**: los algoritmos lanzan/atrapan excepciones para entradas inválidas / **Exceptions**: algorithms throw/catch exceptions for invalid inputs | 2 — **Contiguous Processing** | `transformations`, `patterns`, `substr`, `input_output`, `etl_basico` |
| **Aplicación de estructuras y paradigmas de optimización** (grafos, backtracking, DP, greedy) — sigue usando indicadores de fallo compatibles / **Application of structures and optimization paradigms** (graphs, backtracking, DP, greedy) — still uses compatible failure indicators | 3 — **Algorithms on Structures** | `graph_algorithms`, `backtracking`, `dynamic_programming`, `greedy` |
| **Tipos de retorno** (Option/Result, Maybe/Either) si el lenguaje lo soporta / **Return types** (Option/Result, Maybe/Either) if the language supports it | 4 — **Abstraction & Persistence** | `modeling`, `regex`, `parsing`, `data_base`, `integracion_etl` |

> **ES:** Esto explica por qué en `algorithms` el código "no muere" sino que devuelve un valor especial, y en `text` ya se usan excepciones. Las pruebas unitarias verifican estos comportamientos según corresponda.  
> **EN:** This explains why in `algorithms` the code "doesn't crash" but returns a special value, and in `text` exceptions are already used. Unit tests verify these behaviors accordingly.

---

## Fase 0 — Fundamentos / Foundations (✅ Completada / Completed)

| Módulo | Estado | Lenguajes | Especificación | Notas |
|--------|--------|-----------|----------------|-------|
| `core.foundations.hello_world` | ✅ | 49/49 | [`📄 01_Hello_World.md`](core/foundations/01_Hello_World.md) | Base mínima del lenguaje |
| `core.foundations.hello_user` | ✅ | 49/49 | [`📄 02_Hello_User.md`](core/foundations/02_Hello_User.md) | Entrada/salida interactiva |
| `core.foundations.unit_test` | ✅ | 49/49 | [`📄 03_Unit_Test_Calculator.md`](core/foundations/03_Unit_Test_Calculator.md) | Operaciones aritméticas básicas con unit tests |
| `core.foundations.numbers` | ✅ | 49/49 | [`📄 04_Numbers.md`](core/foundations/04_Numbers.md) | Algoritmos numéricos recursivos e iterativos |

> **ES:** Los **49 submódulos registrados en `.gitmodules`** tienen los cuatro módulos de Foundations homologados y documentados. Foundations queda cerrada; la siguiente fase visible es Algorithms Pure.
> **EN:** All **49 submodules registered in `.gitmodules`** have the four Foundations modules standardized and documented. Foundations is complete; Algorithms Pure is the next visible phase.

---

## Fase 1 — Algoritmos Puros / Algorithms Pure (🔄 En progreso / In progress)

**ES:** Algoritmos sobre números y secuencias numéricas. Se introduce cada tema según tres ejes: (1) coste computacional, (2) ADT o representación requerida y (3) andamiaje conceptual.

**EN:** Algorithms on numbers and numeric sequences. Each topic is introduced according to three axes: (1) computational cost, (2) required ADT or representation, and (3) conceptual scaffolding.

| Módulo | Estado | Lenguajes | Algoritmos | Especificación |
|--------|--------|-----------|------------|----------------|
| `core.algorithms.naive_sort` | 🔄 | 48/49 | selection, bubble, insertion | [`📄 05_Naive_Sort.md`](core/algorithms/05_Naive_Sort.md) |
| `core.algorithms.data_structures` | 📋 | 0/49 | construcción y contrato de stack, queue, linked_list, tree y graph sobre arrays | [`📄 06_Data_Structures.md`](core/algorithms/06_Data_Structures.md) |
| `core.algorithms.efficient_sort` | 📋 | 0/49 | quick, merge, heap; puede usar ADTs optimizados del lenguaje salvo `sort()` | [`📄 07_Efficient_Sort.md`](core/algorithms/07_Efficient_Sort.md) |
| `core.algorithms.distributed_sort` | 📋 | 0/49 | radix, bucket, shell, counting | [`📄 08_Distributed_Sort.md`](core/algorithms/08_Distributed_Sort.md) |
| `core.algorithms.searching` | 📋 | 0/49 | linear sobre arrays numéricos; binary, jump e interpolation con precondición de array ordenado | [`📄 09_Searching.md`](core/algorithms/09_Searching.md) |

### Ejes de progresión / Progression axes

| Módulo | Eje computacional / Computational | Eje estructural / Structural | Andamiaje / Scaffolding |
|--------|-----------------------------------|------------------------------|--------------------------|
| 05 — naive sort | $O(n^2)$ | array numérico mutable | comparación, intercambio e invariante de prefijo ordenado |
| 06 — data structures | operaciones locales; depende del ADT | arrays e índices implementan ADTs | representación, capacidad, invariantes y contrato |
| 07 — efficient sort | $O(n \log n)$ esperado/típico | arrays; heap/colección optimizada permitida | divide & conquer, recursión y partición |
| 08 — distributed sort | $O(n+k)$ o dependiente de dígitos | arrays de conteo/cubetas | rango, distribución y estabilidad como límites de aplicabilidad |
| 09 — searching | $O(n)$ a $O(\log n)$, más preparación cuando aplica | array numérico; acceso indexado | consumo de una secuencia ordenada; contrato y composición con sort |

---

## Fase 2 — Procesamiento Contiguo / Contiguous Processing (📋)

**ES:** Procesamiento de texto y archivos sobre representaciones contiguas. Parte de que una cadena es una secuencia indexable de unidades de texto (caracteres, bytes o code units, según el lenguaje), avanza desde recorridos y transformaciones manuales hasta patrones y archivos, y finalmente integra los algoritmos ya implementados en un ETL reproducible. Se introducen excepciones para errores de frontera de I/O y datos malformados.

**EN:** Text and file processing over contiguous representations. It starts from the fact that a string is an indexable sequence of text units (characters, bytes, or code units, depending on the language), progresses from manual traversals and transformations to patterns and files, and finally integrates previously implemented algorithms in a reproducible ETL. Exceptions are introduced for I/O-boundary and malformed-data errors.

| Módulo | Estado | Notas |
|--------|--------|-------|
| `core.text.transformations` | 🔄 | representación de strings, recorrido, reverse, trim, case, padding y normalización de blancos | [`📄 10_Transformations.md`](core/text/10_Transformations.md) |
| `core.text.patterns` | 📋 | palindrome, anagram, búsqueda ingenua y patrones literales | [`📄 11_Patterns.md`](core/text/11_Patterns.md) |
| `core.text.substr` | 📋 | LPP, KMP, Boyer–Moore y Z; tablas auxiliares basadas en arrays | [`📄 12_Substr.md`](core/text/12_Substr.md) |
| `core.text.input_output` | 📋 | fixtures compartidos, read/write/append, codificación y excepciones de frontera | [`📄 13_Input_Output.md`](core/text/13_Input_Output.md) |
| `core.text.etl_basico` | 📋 | CSV delimitado, validación, transformación, búsqueda/ordenamiento y salida reproducible | [`📄 14_ETL_Basico.md`](core/text/14_ETL_Basico.md) |

---

## Fase 3 — Algoritmos sobre Estructuras / Algorithms on Structures (📋)

**ES:** Algoritmos que aplican las bibliotecas propias construidas en la Fase 1 (árboles, grafos, colas y pilas) y presentan paradigmas de optimización. La dificultad crece por el modelo de estado y las invariantes —frontera de un grafo, estado parcial de backtracking o tabla DP—, no solo por la notación asintótica. Se implementan desde cero y siguen usando indicadores de fallo compatibles.

**EN:** Algorithms that apply the own libraries built in Phase 1 (trees, graphs, queues, and stacks) and introduce optimization paradigms. Difficulty grows through the state model and invariants —a graph frontier, a backtracking partial state, or a DP table— rather than asymptotic notation alone. They are implemented from scratch and still use compatible failure indicators.

| Módulo | Estado | Algoritmos | Especificación |
|--------|--------|------------|----------------|
| `core.structures.graph_algorithms` | 📋 | BFS, DFS, Dijkstra, Prim, Kruskal, orden topológico, componentes conexas | [`📄 15_Graph_Algorithms.md`](core/structures/15_Graph_Algorithms.md) |
| `core.structures.backtracking` | 📋 | N-Queens, permutaciones, subconjuntos, laberinto | [`📄 16_Backtracking.md`](core/structures/16_Backtracking.md) |
| `core.structures.dynamic_programming` | 📋 | LCS, knapsack 0/1, coin change, LIS, caminos en grid | [`📄 17_Dynamic_Programming.md`](core/structures/17_Dynamic_Programming.md) |
| `core.structures.greedy` | 📋 | activity selection, fractional knapsack, coin change greedy | [`📄 18_Greedy.md`](core/structures/18_Greedy.md) |

> **ES:** El heap de `efficient_sort` se reutiliza aquí como cola de prioridad en Dijkstra. `backtracking` sienta las bases de la recursión con retroceso que se usará en el `parsing` de la Fase 4. DP y greedy son insumos directos de la capa de abstracción (optimización de pipelines ETL, menús de UI).
> **EN:** The heap from `efficient_sort` is reused here as a priority queue in Dijkstra. `backtracking` lays the foundation for the backtracking recursion used in Phase 4's `parsing`. DP and greedy are direct inputs for the abstraction layer (ETL pipeline optimization, UI menus).

---

## Fase 4 — Abstracción y Persistencia / Abstraction & Persistence (📋)

**ES:** Se introducen tipos de retorno (Option/Result), modelado de datos, expresiones regulares, parsing formal, bases de datos y ETL integrado. Es la capa de abstracción sobre el procesamiento contiguo.

**EN:** Return types (Option/Result), data modeling, regular expressions, formal parsing, databases, and integrated ETL are introduced. This is the abstraction layer over contiguous processing.

| Módulo | Estado | Notas |
|--------|--------|-------|
| `core.data.modeling` | 📋 | user, product, order... |
| `core.data.strsearch` | 📋 | String search con abstracciones y tipos de retorno |
| `core.data.regex` | 📋 | Patrones de email, teléfono, etc. |
| `core.data.parsing` | 📋 | csv_parser, json_parser, arithmetic_parser |
| `core.data.data_base` | 📋 | raw_queries, ORM, connection_pool |
| `core.data.integracion_etl` | 📋 | Pipelines ETL que integran I/O, regex y BD |

> **ES:** La Fase 4 unifica lo que antes eran Fase 2 (regex, parsing) y Fase 3 (modeling, data_base) en una sola capa de abstracción. El ETL básico de la Fase 2 se integra aquí con BD para formar pipelines completos.
> **EN:** Phase 4 unifies what were previously Phase 2 (regex, parsing) and Phase 3 (modeling, data_base) into a single abstraction layer. The basic ETL from Phase 2 is integrated here with databases to form complete pipelines.

---

## Fase 5 — Matemáticas / Math (📋)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `core.math.statistics` | 📋 | mean, median, mode, variance, std_dev, percentiles |
| `core.math.linear_algebra` | 📋 | matrix, vector, linear_equation, linear_system, complex_numbers |

---

## 🧰 Utilidades compartidas / Shared Utilities

**ES:** Biblioteca de fragmentos reutilizables que **crece con cada proyecto**. No es una fase secuencial, sino un conjunto de módulos que se van poblando conforme se necesiten.

**EN:** Library of reusable snippets that **grows with each project**. It's not a sequential phase, but a set of modules that get populated as needed.

| Módulo | Descripción | Estado |
|--------|-------------|--------|
| `util.logging` | Configuración y wrappers de logging | ⏳ Crece con cada proyecto |
| `util.db` | Abstracción de conexiones a bases de datos | ⏳ Se poblará en fase 4 (Data) |
| `util.data_transform` | Formateo, validación, sanitización | ⏳ |
| `util.serialization` | JSON, XML, CSV helpers | ⏳ |
| `util.config` | Carga de configuración desde archivos/variables de entorno | ⏳ |

---

## 🔧 Herramientas de desarrollo propias / Custom Dev Tools

**ES:** Implementaciones propias de herramientas de calidad cuando **no existan en el ecosistema del lenguaje**. Por ejemplo, un SAST para Ada/Alire o un unificador de reportes de cobertura multiplataforma. Tampoco es una fase secuencial.

**EN:** Custom implementations of quality tools when they **don't exist in the language's ecosystem**. For example, an SAST for Ada/Alire or a cross-platform coverage report unifier. Not a sequential phase either.

| Herramienta / Tool | Lenguajes objetivo / Target languages | Descripción | Estado |
|-------------------|-------------------|-------------|--------|
| `sast_ada` | Ada (Alire) | Análisis estático básico inspirado en bandit | ⏳ Planeado tras UI/Web |
| `coverage_reporter` | Varios | Unificador de reportes de cobertura | ⏳ |
| `linter_aggregator` | Varios | Ejecuta linters de cada lenguaje y unifica resultados | ⏳ |

---

## 🖥️ Tracks de Aplicación Paralelos (UI y Web) / Parallel Application Tracks

**ES:** Las fases de **UI (Fase 6)** y **Web (Fase 7)** son **fases de aplicación** que pueden iniciarse de manera paralela o como un paso posterior a Core:

1. **Reinicio de la curva de aprendizaje en cada interfaz:** Para explorar un entorno gráfico o un servidor web se vuelve a partir desde lo elemental:
   - *Paso 1 — Arranque elemental:* Levantar la ventana, terminal interactiva o servidor HTTP mínimo (`hello_world`, `hello_user` adaptados a CLI, TUI, GUI, MVC y API REST).
   - *Paso 2 — Menús y orquestación:* Construir menús interactivos o enrutadores de endpoints para despachar y ejecutar las funcionalidades y algoritmos previamente construidos y probados en Core (`algorithms_menu`).
   - *Paso 3 — Servicios de datos reales:* Conectar con bases de datos, almacenamiento persistente, transformaciones de datos y consultas completas (CRUD, pipelines ETL expuestos).
2. **Manejo de errores por capas:**
   - En **Core** se valida la lógica pura del dominio y de los algoritmos (mediante indicadores de fallo compatibles en Fases 1 y 3, excepciones en Fase 2, o tipos Result/Option en Fase 4).
   - En **UI y Web**, la capa de interfaz atrapa esos resultados y los traduce a los códigos de error (*code errors*) propios de cada medio: códigos de salida de proceso (*exit codes* como `exit 1` / `exit 2`) en CLI, mensajes de estado visuales en GUI/TUI, y códigos de estado HTTP (400 Bad Request, 404 Not Found, 422 Unprocessable Entity, 500 Internal Error) en Web.

**EN:** The **UI (Phase 6)** and **Web (Phase 7)** phases are **application tracks** that can be started in parallel or as a subsequent step to Core:

1. **Restarting the learning curve per interface:** Exploring a GUI or web server starts again from the basics:
   - *Step 1 — Basic bootstrap:* Launching the minimal window, interactive terminal, or HTTP server (`hello_world`, `hello_user` adapted to CLI, TUI, GUI, MVC, and REST API).
   - *Step 2 — Menus and orchestration:* Building interactive menus or endpoint routers to dispatch and execute functionalities and algorithms already built and tested in Core (`algorithms_menu`).
   - *Step 3 — Real data services:* Connecting to databases, persistent storage, data transformations, and full queries (CRUD, exposed ETL pipelines).
2. **Layered error handling:**
   - In **Core**, pure domain and algorithm logic is validated (using compatible failure indicators in Phases 1 and 3, exceptions in Phase 2, or Result/Option types in Phase 4).
   - In **UI and Web**, the interface layer catches these results and translates them into medium-specific *code errors*: process exit codes (`exit 1` / `exit 2`) in CLI, visual status messages in GUI/TUI, and HTTP status codes (400, 404, 422, 500) in Web.

---

## Fase 6 — Interfaz de Usuario / UI (⏳ — Proyectos complejos)

> **ES:** A partir de esta fase, cada proyecto incluirá:  
> - ✅ **Jenkinsfile** — Pipeline CI/CD 
> - ✅ **Dockerfile** — Contenedor de construcción y ejecución  
> - ✅ **docker-compose.yml** — Orquestación local (si aplica)  
> - 🔒 **Análisis de seguridad estático (SAST)** — Aplicación de análisis de código  
> - 🔒 **OWASP Top 10** — Revisión y mitigación de vulnerabilidades
> 
> **EN:** From this phase onward, each project will include:  
> - ✅ **Jenkinsfile** — CI/CD Pipeline  
> - ✅ **Dockerfile** — Build and execution container  
> - ✅ **docker-compose.yml** — Local orchestration (if applicable)  
> - 🔒 **Static Application Security Testing (SAST)** — Code analysis tool  
> - 🔒 **OWASP Top 10** — Vulnerability review and mitigation

**ES:** Los proyectos `hello_world` y `hello_user` de fundamentos se replican aquí con la nomenclatura específica de cada interfaz, manteniendo ambas implementaciones:

**EN:** The `hello_world` and `hello_user` foundation projects are replicated here with the interface-specific naming convention, keeping both implementations:

| Módulo | Estado | Submódulos | Notas |
|--------|--------|------------|-------|
| `ui.cliapp` | ⏳ | `hello_cli`, `hello_user_cli`, `algorithms_menu`, `crud` | CLI interactivo. Primer proyecto con **Docker + CI/CD + SAST** |
| `ui.tuiapp` | ⏳ | `hello_tui`, `hello_user_tui`, … | Interfaz de terminal (TUI). Refuerzo de seguridad |
| `ui.guiapp` | ⏳ | `hello_gui`, `hello_user_gui`, … | Interfaz gráfica. OWASP en dependencias gráficas |

---

## Fase 7 — Web (⏳)

**ES:** Misma replicación de `hello_world` y `hello_user` con nomenclatura específica del tipo de API/framework:

**EN:** Same replication of `hello_world` and `hello_user` with API/framework-specific naming:

| Módulo | Estado | Submódulos | Notas |
|--------|--------|------------|-------|
| `web.mvcapp` | ⏳ | `hello_mvc`, `hello_user_mvc`, … | Framework MVC. **Pipeline, contenedores y análisis de seguridad** |
| `web.api` | ⏳ | `hello_rest_api`, `hello_user_rest_api`, `hello_soap_api`, `hello_user_soap_api`, … | APIs REST, SOAP, GraphQL, gRPC, WebSocket. **OWASP API Security** |

---

## Fase 8 — Concurrencia y Asincronía / Async (⏳)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `async.futures_and_promises` | ⏳ | |
| `async.async_await` | ⏳ | |
| `async.actor_model` | ⏳ | |
| `async.channels` | ⏳ | |
| `async.parallel` | ⏳ | |

---

## Fase 9 — Interoperabilidad / Interop (⏳)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `interop.c_binding` | ⏳ | FFI con C |
| `interop.system_calls` | ⏳ | Llamadas al sistema operativo |
| `interop.other_lang_bridge` | ⏳ | Puente con otros lenguajes |

---

## Infraestructura compartida / Shared Infrastructure

A medida que se avanza a proyectos más complejos (a partir de `ui.cliapp`), los siguientes archivos se mantendrán y actualizarán:

| Archivo | Propósito | Desde fase |
|---------|-----------|------------|
| `doc/Jenkinsfile` | Pipeline global del monorepo | Fase 6 — cliapp |
| `doc/Dockerfile` | Entorno de construcción y pruebas global | Fase 6 — cliapp |
| `doc/docker-compose.yml` | Orquestación de servicios (BD, etc.) | Fase 6 — cliapp |
| `tools/static_analysis/` | Reglas SAST, configuraciones OWASP | Fase 6 — cliapp |

---

## Resumen de progreso / Progress Summary

> **ES:** Los contadores `X/49` indican cuántos de los **49 submódulos registrados en `.gitmodules`** tienen el módulo implementado y homologado bajo `core/`. Los lenguajes legacy, copias de respaldo, `_experimental/` y lenguajes eliminados como `seed7` no forman parte del denominador.
> **EN:** The `X/49` counters indicate how many of the **49 submodules registered in `.gitmodules`** have the module implemented and standardized under `core/`. Legacy languages, backups, `_experimental/`, and removed languages such as `seed7` are excluded from the denominator.

```text
## Fase 0 — Foundations ✅ (completos: 49/49 submódulos)
core.foundations.hello_world          ✅ 49/49
core.foundations.hello_user           ✅ 49/49
core.foundations.unit_test            ✅ 49/49
core.foundations.numbers              ✅ 49/49

## Fase 1 — Algorithms Pure 🔄 (fase abierta; implementados: 1/49)
core.algorithms.naive_sort            🔄 48/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm, Erlang, Forth, F#, Gleam, Go, Grain, Groovy, Haskell, Haxe, Java, JavaScript, Julia, Kotlin, Lua, Nim, OCaml, Perl, Prolog, PureScript, Python, R, Racket, Raku, ReScript, REXX, Ruby, Rust, Scala, Scheme, Swift, Tcl/Tk, TypeScript, V, Vala)
core.algorithms.data_structures       📋
core.algorithms.efficient_sort        📋
core.algorithms.distributed_sort      📋
core.algorithms.searching             📋

## Fase 2 — Contiguous Processing 📋 (refactorizados: 0/49)
core.text.transformations             🔄 (refactor pendiente)
core.text.patterns                    📋
core.text.substr                      📋
core.text.input_output                📋
core.text.etl_basico                  📋

## Fase 3 — Algorithms on Structures 📋 (implementados: 0/49)
core.structures.graph_algorithms      📋
core.structures.backtracking          📋
core.structures.dynamic_programming   📋
core.structures.greedy                📋

## Fase 4 — Abstraction & Persistence 📋
core.data.modeling                    📋
core.data.strsearch                   📋
core.data.regex                       📋
core.data.parsing                     📋
core.data.data_base                   📋
core.data.integracion_etl             📋

## Fase 5 — Math 📋
core.math.statistics                  📋
core.math.linear_algebra              📋

## Utilidades y Herramientas ⏳
util.{logging,db,data_transform,...}  ⏳
tools.{sast_ada,coverage_reporter}    ⏳

## Proyectos complejos ⏳
ui.cliapp   (Fase 6 — Docker + Jenkins SAST/OWASP) ⏳
ui.tuiapp   (Fase 6 — Docker + Jenkins SAST/OWASP) ⏳
ui.guiapp   (Fase 6 — Docker + Jenkins SAST/OWASP) ⏳
web.mvcapp  (Fase 7 — Docker + Jenkins SAST/OWASP) ⏳
web.api     (Fase 7 — Docker + Jenkins SAST/OWASP) ⏳
async.futures_and_promises            (Fase 8) ⏳
async.async_await                     (Fase 8) ⏳
async.actor_model                     (Fase 8) ⏳
async.channels                        (Fase 8) ⏳
async.parallel                        (Fase 8) ⏳
interop.c_binding                     (Fase 9) ⏳
interop.system_calls                  (Fase 9) ⏳
interop.other_lang_bridge             (Fase 9) ⏳
```

---

> **ES:** Esta estructura puede cambiar a medida que el proyecto evoluciona y se identifican mejores formas de organizar las implementaciones.  
> **EN:** This structure may change as the project evolves and better ways to organize implementations are identified.

---

*Última actualización: 2026-09-05*