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
01_Hello_World.md  →  02_Hello_User.md  →  03_Unit_Test.md  →  04_Numbers.md  →  ...
```

---

## Fase 0 — Fundamentos / Foundations (✅ Completada)

| Módulo | Estado | Lenguajes | Especificación | Notas |
|--------|--------|-----------|----------------|-------|
| `core.foundations.helloworld` | ✅ | Todos | [`📄 01_Hello_World.md`](core/foundations/01_Hello_World.md) | Base mínima del lenguaje |
| `core.foundations.hellouser` | ✅ | Todos | [`📄 02_Hello_User.md`](core/foundations/02_Hello_User.md) | Entrada/salida interactiva |
| `core.foundations.unit_test` | ✅ | Todos | `03_Unit_Test.md` | Pruebas unitarias (TDD básico) |
| `core.foundations.numbers` | ✅ | Todos | `04_Numbers.md` | Algoritmos numéricos iterativos |

---

## Fase 1 — Texto / Text (✅ Completada hasta patterns)

| Módulo | Estado | Lenguajes | Notas |
|--------|--------|-----------|-------|
| `core.text.transformations` | ✅ | Todos | reverse, remove_blank_chars |
| `core.text.patterns` | ✅ | Todos | palindrome, anagram, substring, LPP, KMP, LCS, LCP, Boyer-Moore, Z-Algorithm |
| `core.text.regex` | 📋 | — | Patrones de email, teléfono, etc. |
| `core.text.parsing` | 📋 | — | csv_parser, json_parser, arithmetic_parser |

---

## Fase 2 — Algoritmos y Estructuras de Datos / Algorithms & Data Structures (📋)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `core.algorithms.sorting` | 📋 | bubble, insertion, selection, quick, merge, heap, radix, bucket, shell, counting |
| `core.algorithms.data_structures` | 📋 | stack, queue, linked_list, tree, graph, hash_table, heap, set |
| `core.algorithms.searching` | 📋 | linear, binary, jump, interpolation |

---

## Fase 3 — Datos / Data (📋)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `core.data.input_output` | 📋 | Archivos (read, write, append) con excepciones y validaciones |
| `core.data.modeling` | 📋 | user, product, order… |
| `core.data.data_base` | 📋 | raw_queries, ORM, connection_pool |

---

## Fase 4 — Matemáticas / Math (📋)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `core.math.statistics` | 📋 | mean, median, mode, variance, std_dev, percentiles |
| `core.math.linear_algebra` | 📋 | matrix, vector, linear_equation, linear_system, complex_numbers |

---

## Fase 5 — Utilidades / Util (⏳)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `util` | ⏳ | Biblioteca reusable (especificación de interfaz común) |

---

## Fase 6 — Interfaz de Usuario / UI (⏳ — Inicio de proyectos complejos)

> A partir de esta fase, cada proyecto incluirá:
> - ✅ **Jenkinsfile** — Pipeline CI/CD
> - ✅ **Dockerfile** — Contenedor de construcción y ejecución
> - ✅ **docker-compose.yml** — Orquestación local (si aplica)
> - 🔒 **Análisis de seguridad estático (SAST)** — Aplicación de análisis de código (bandit, semgrep, etc.)
> - 🔒 **OWASP Top 10** — Revisión y mitigación de vulnerabilidades

| Módulo | Estado | Submódulos | Notas |
|--------|--------|------------|-------|
| `ui.cliapp` | ⏳ | hello_world, hello_user, algorithms_menu, crud | CLI interactivo. Primer proyecto con **Docker + CI/CD + SAST** |
| `ui.tuiapp` | ⏳ | *misma subestructura* | Interfaz de terminal (TUI). Refuerzo de seguridad |
| `ui.guiapp` | ⏳ | *misma subestructura* | Interfaz gráfica. OWASP en dependencias gráficas |

---

## Fase 7 — Web (⏳)

| Módulo | Estado | Submódulos | Notas |
|--------|--------|------------|-------|
| `web.mvcapp` | ⏳ | hello_world, hello_user, … | Framework MVC. **Pipeline, contenedores y análisis de seguridad** |
| `web.api` | ⏳ | restapi, soapapi, graphqlapi, grpcapi, websocketapi | APIs. **Pruebas de penetración básicas + OWASP API Security** |

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

## Fase 10 — Herramientas / Tools (⏳)

| Módulo | Estado | Notas |
|--------|--------|-------|
| `tools.linter` | ⏳ | Integración continua |
| `tools.formatter` | ⏳ | Integración continua |
| `tools.static_analysis` | ⏳ | SAST, OWASP Dependency Check |
| `tools.coverage` | ⏳ | Cobertura de código |
| `tools.build` | ⏳ | Sistema de compilación |

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

```text
core.foundations.helloworld       ✅
core.foundations.hellouser        ✅
core.foundations.unit_test        ✅
core.foundations.numbers          ✅
core.text.transformations         ✅
core.text.patterns                ✅
core.text.regex                   📋
core.text.parsing                 📋
core.algorithms.sorting           📋
core.algorithms.data_structures   📋
core.algorithms.searching         📋
core.data.input_output            📋
core.data.modeling                📋
core.data.data_base               📋
core.math.statistics              📋
core.math.linear_algebra          📋
util                              ⏳
ui.cliapp    (Docker + Jenkins SAST/OWASP)  ⏳
ui.tuiapp    (Docker + Jenkins SAST/OWASP)  ⏳
ui.guiapp    (Docker + Jenkins SAST/OWASP)  ⏳
web.mvcapp   (Docker + Jenkins SAST/OWASP)  ⏳
web.api      (Docker + Jenkins SAST/OWASP)  ⏳
async.futures_and_promises                   ⏳
async.async_await                            ⏳
async.actor_model                            ⏳
async.channels                               ⏳
async.parallel                               ⏳
interop.c_binding                            ⏳
interop.system_calls                         ⏳
interop.other_lang_bridge                    ⏳
tools                                        ⏳
```

---

*Última actualización: 2025*