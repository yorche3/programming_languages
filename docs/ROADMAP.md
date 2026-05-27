# 🗺️ Roadmap

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
| **Valores centinela** (sin excepciones): la función devuelve un valor especial (`-1`, `None`) para indicar error sin interrumpir el flujo / **Sentinel values** (no exceptions): function returns a special value (`-1`, `None`) to indicate error without interrupting flow | 1 — **Algorithms Pure** | `naive_sort`, `efficient_sort`, `distributed_sort`, `data_structures`, `searching` |
| **Excepciones**: los algoritmos lanzan/atrapan excepciones para entradas inválidas / **Exceptions**: algorithms throw/catch exceptions for invalid inputs | 2 — **Contiguous Processing** | `patterns`, `substr`, `input_output`, `etl_basico` |
| **Tipos de retorno** (Option/Result, Maybe/Either) si el lenguaje lo soporta / **Return types** (Option/Result, Maybe/Either) if the language supports it | 3 — **Abstraction & Persistence** | `modeling`, `regex`, `parsing`, `data_base`, `integracion_etl` |

> **ES:** Esto explica por qué en `algorithms` el código "no muere" sino que devuelve un valor especial, y en `text` ya se usan excepciones. Las pruebas unitarias verifican estos comportamientos según corresponda.  
> **EN:** This explains why in `algorithms` the code "doesn't crash" but returns a special value, and in `text` exceptions are already used. Unit tests verify these behaviors accordingly.

---

## Fase 0 — Fundamentos / Foundations (✅ Completada)

| Módulo | Estado | Lenguajes | Especificación | Notas |
|--------|--------|-----------|----------------|-------|
| `core.foundations.hello_world` | ✅ | Todos | [`📄 01_Hello_World.md`](core/foundations/01_Hello_World.md) | Base mínima del lenguaje |
| `core.foundations.hello_user` | ✅ | Todos | [`📄 02_Hello_User.md`](core/foundations/02_Hello_User.md) | Entrada/salida interactiva |
| `core.foundations.unit_test` | ✅ | Todos | [`📄 03_Unit_Test_Calculator.md`](core/foundations/03_Unit_Test_Calculator.md) | Operaciones aritméticas básicas con unit tests |
| `core.foundations.numbers` | ✅ | Todos | [`📄 04_Numbers.md`](core/foundations/04_Numbers.md) | Algoritmos numéricos recursivos e iterativos |

---

## Fase 1 — Algoritmos Puros / Algorithms Pure (📋)

**ES:** Algoritmos estructurados solo con arrays y valores centinela. Sin excepciones, sin estructuras avanzadas. Se progresa desde los algoritmos más simples hasta los optimizados.

**EN:** Algorithms structured with only arrays and sentinel values. No exceptions, no advanced structures. Progress from the simplest to the optimized algorithms.

| Módulo | Estado | Algoritmos |
|--------|--------|------------|
| `core.algorithms.naive_sort` | ✅ | bubble, insertion, selection |
| `core.algorithms.data_structures` | 📋 | stack, queue, linked_list, tree, graph (con arrays) |
| `core.algorithms.efficient_sort` | 📋 | quick, merge, heap |
| `core.algorithms.distributed_sort` | 📋 | radix, bucket, shell, counting |
| `core.algorithms.searching` | 📋 | linear, binary, jump, interpolation |

> **ES:** `naive_sort` (O(n²)) ya está implementado en `05_Sorting.md`. Los módulos `efficient_sort` y `distributed_sort` se separarán en documentos propios para mantener el foco didáctico.
> **EN:** `naive_sort` (O(n²)) is already implemented in `05_Sorting.md`. The `efficient_sort` and `distributed_sort` modules will have their own documents to maintain didactic focus.

---

## Fase 2 — Procesamiento Contiguo / Contiguous Processing (📋)

**ES:** Procesamiento de datos usando solo estructuras contiguas (arrays, archivos). Se introducen excepciones para manejar errores. Incluye transformaciones de texto, búsqueda de patrones básicos, I/O de archivos y ETL básico.

**EN:** Data processing using only contiguous structures (arrays, files). Exceptions are introduced for error handling. Includes string transformations, basic pattern matching, file I/O, and basic ETL.

| Módulo | Estado | Notas |
|--------|--------|-------|
| `core.text.transformations` | ✅ | reverse, trim, capitalize, to_uppercase, to_lowercase, pad_left/right, remove_blank_chars |
| `core.text.patterns` | 📋 | palindrome, anagram (con arrays ASCII, sin HashMaps) |
| `core.text.substr` | 📋 | Naive Search, LPP, KMP, Boyer-Moore, LCS, LCP, Z-Algorithm |
| `core.text.input_output` | 📋 | Archivos (read, write, append) con excepciones y validaciones |
| `core.text.etl_basico` | 📋 | CSV parse, JSON parse básico, transformaciones de datos |

> **ES:** Esta fase sustituye el concepto anterior de "Text" puro. Ahora incluye I/O de archivos y ETL básico usando solo arrays. Los algoritmos de patrón más complejos (KMP, Boyer-Moore) usan tablas de salto basadas en arrays.
> **EN:** This phase replaces the previous pure "Text" concept. It now includes file I/O and basic ETL using only arrays. Complex pattern algorithms (KMP, Boyer-Moore) use array-based jump tables.

---

## Fase 3 — Abstracción y Persistencia / Abstraction & Persistence (📋)

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

> **ES:** La Fase 3 unifica lo que antes eran Fase 2 (regex, parsing) y Fase 3 (modeling, data_base) en una sola capa de abstracción. El ETL básico de la Fase 2 se integra aquí con BD para formar pipelines completos.
> **EN:** Phase 3 unifies what were previously Phase 2 (regex, parsing) and Phase 3 (modeling, data_base) into a single abstraction layer. The basic ETL from Phase 2 is integrated here with databases to form complete pipelines.

---

## Fase 4 — Matemáticas / Math (📋)

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
| `util.db` | Abstracción de conexiones a bases de datos | ⏳ Se poblará en fase 3 (Data) |
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

## Fase 5 — Interfaz de Usuario / UI (⏳ — Proyectos complejos)

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

## Fase 6 — Web (⏳)

**ES:** Misma replicación de `hello_world` y `hello_user` con nomenclatura específica del tipo de API/framework:

**EN:** Same replication of `hello_world` and `hello_user` with API/framework-specific naming:

| Módulo | Estado | Submódulos | Notas |
|--------|--------|------------|-------|
| `web.mvcapp` | ⏳ | `hello_mvc`, `hello_user_mvc`, … | Framework MVC. **Pipeline, contenedores y análisis de seguridad** |
| `web.api` | ⏳ | `hello_rest_api`, `hello_user_rest_api`, `hello_soap_api`, `hello_user_soap_api`, … | APIs REST, SOAP, GraphQL, gRPC, WebSocket. **OWASP API Security** |

---

## Fase 7 — Concurrencia y Asincronía / Async (⏳)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `async.futures_and_promises` | ⏳ | |
| `async.async_await` | ⏳ | |
| `async.actor_model` | ⏳ | |
| `async.channels` | ⏳ | |
| `async.parallel` | ⏳ | |

---

## Fase 8 — Interoperabilidad / Interop (⏳)

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
| `doc/Jenkinsfile` | Pipeline global del monorepo | Fase 5 — cliapp |
| `doc/Dockerfile` | Entorno de construcción y pruebas global | Fase 5 — cliapp |
| `doc/docker-compose.yml` | Orquestación de servicios (BD, etc.) | Fase 5 — cliapp |
| `tools/static_analysis/` | Reglas SAST, configuraciones OWASP | Fase 5 — cliapp |

---

## Resumen de progreso / Progress Summary

```text
## Fase 0 — Foundations ✅
core.foundations.hello_world          ✅
core.foundations.hello_user           ✅
core.foundations.unit_test            ✅
core.foundations.numbers              ✅

## Fase 1 — Algorithms Pure 📋
core.algorithms.naive_sort            ✅
core.algorithms.data_structures       📋
core.algorithms.efficient_sort        📋
core.algorithms.distributed_sort      📋
core.algorithms.searching             📋

## Fase 2 — Contiguous Processing 📋
core.text.transformations             ✅
core.text.patterns                    📋
core.text.substr                       📋
core.text.input_output                📋
core.text.etl_basico                  📋

## Fase 3 — Abstraction & Persistence 📋
core.data.modeling                    📋
core.data.strsearch                   📋
core.data.regex                       📋
core.data.parsing                     📋
core.data.data_base                   📋
core.data.integracion_etl             📋

## Fase 4 — Math 📋
core.math.statistics                  📋
core.math.linear_algebra              📋

## Utilidades y Herramientas ⏳
util.{logging,db,data_transform,...}  ⏳
tools.{sast_ada,coverage_reporter}    ⏳

## Proyectos complejos ⏳
ui.cliapp   (Docker + Jenkins SAST/OWASP) ⏳
ui.tuiapp   (Docker + Jenkins SAST/OWASP) ⏳
ui.guiapp   (Docker + Jenkins SAST/OWASP) ⏳
web.mvcapp  (Docker + Jenkins SAST/OWASP) ⏳
web.api     (Docker + Jenkins SAST/OWASP) ⏳
async.futures_and_promises                 ⏳
async.async_await                          ⏳
async.actor_model                          ⏳
async.channels                             ⏳
async.parallel                             ⏳
interop.c_binding                          ⏳
interop.system_calls                       ⏳
interop.other_lang_bridge                  ⏳
```

---

> **ES:** Esta estructura puede cambiar a medida que el proyecto evoluciona y se identifican mejores formas de organizar las implementaciones.  
> **EN:** This structure may change as the project evolves and better ways to organize implementations are identified.

---

*Última actualización: 2025*