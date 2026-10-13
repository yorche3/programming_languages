# 📋 Plan de Documentación / Documentation Plan

> **ES:** Registro maestro para el seguimiento de la documentación en todo el monorepo. Este archivo es la fuente única de verdad sobre **qué documentación existe, en qué estado se encuentra y qué pasos siguen**. Este documento realiza seguimiento **únicamente de la documentación, no del código ni de las pruebas** —estos últimos se gestionan en el roadmap y en el ciclo de sprint de cada rama—.
>
> **EN:** Master tracking for documentation work across the monorepo. This file is the single source of truth for **what docs exist, what state they are in, and what is next**. It tracks **documentation only, not code or tests** —those live in the roadmap and the sprint cycle of each branch—.

---

## 🧭 Leyenda / Legend

| Símbolo / Symbol | Significado / Meaning |
|:---:|---|
| ✅ | Completo / Complete |
| 🔄 | En progreso / In progress |
| 📋 | Planificado / Planned |
| ⏳ | Futuro (no iniciado) / Future (not started) |
| ❌ | No aplica a este lenguaje / Does not apply to this language |

---

## 1. Documentos transversales / Cross-cutting documents (all 50 languages)

| Documento / Document | Propósito / Purpose | Estado / State | Responsable / Owner |
|----------------------|---------------------|:--------------:|:-------------------:|
| `docs/ruleset/PSEUDOCODE_CONVENTION.md` | Pseudocódigo canónico, nombres conceptuales y casos medidos / Canonical pseudocode, conceptual names, measured cases | ✅ | Software Architect (apoyo: Language-Specific SME) |
| `docs/ruleset/LANGUAGE_CHARACTERISTICS.md` | 11 ejes por lenguaje / 11 axes per language | ✅ | Language-Specific SME |
| `docs/ruleset/IDIOMATICITY_LEVELS.md` | Escala de 4 niveles con 9 ejes de evaluación / 4-level scale with 9 evaluation axes | ✅ | Software Architect (apoyo: SDET) |
| `docs/ruleset/DEVIATION_POLICY.md` | Política de registro de desviaciones / When/how to document deviations | ✅ | Software Architect |
| `docs/ruleset/PARADIGM_FAMILIES.md` | 9 familias prácticas y pseudocódigo ajustado por familia / 9 practical families and per-family adjusted pseudocode | ✅ | Software Architect (apoyo: Language-Specific SME) |
| `docs/ruleset/data/canonical_names.tsv` | Mapeo concepto → nombre canónico por lenguaje / concept → name per language | ✅ | Language-Specific SME |
| `docs/ruleset/data/language_characteristics.tsv` | Ejes estructurados legibles por máquina / Machine-readable axes | ✅ | Language-Specific SME |
| `docs/ruleset/data/idiomaticity_state.tsv` | Estado por (lenguaje, módulo): 2 ejes principales (objetivo idiomático y fidelidad al módulo) / State per (lang, module): 2 principal axes | 🔄 | SDET |

---

## 2. Documentos por lenguaje / Per-language documents

> **ES:** Alcance **técnico**: `idioms` (el *cómo* idiomático) y `adaptations` (cada desviación y su motivo) son el soporte por lenguaje de la convención de pseudocódigo. El `Responsable` de las 50 filas es el **Language-Specific SME** (apoyo: *Technical Writer* en la redacción del README). La columna `Changelog` y el estado editorial quedan **fuera del alcance técnico**; el registro técnico medido vive en *Casos medidos en la homologación*, en `PSEUDOCODE_CONVENTION.md`.
>
> **EN:** **Technical** scope: `idioms` (the idiomatic *how*) and `adaptations` (each deviation and its reason) are the per-language support of the pseudocode convention. The 50 rows' `Owner` is the **Language-Specific SME** (support: *Technical Writer* for README wording). The `Changelog` column and editorial state are **out of technical scope**; the measured technical record lives in *Cases measured during homologation*, in `PSEUDOCODE_CONVENTION.md`.

| Lenguaje / Language | `docs/ruleset/idioms/{lang}.md` | `docs/ruleset/adaptations/{lang}.md` | Changelog | Estado / State | Responsable / Owner |
|---------------------|:-----------------------:|:----------------------------:|:---------:|:--------------:|:-------------------:|
| Ada (`ada`) | 📋 | 📋 | 📋 | 📋 | — |
| Assembly (`assembly`) | 📋 | 📋 | 📋 | 📋 | — |
| Ballerina (`ballerina`) | 📋 | 📋 | 📋 | 📋 | — |
| C (`c`) | 📋 | 📋 | 📋 | 📋 | — |
| C# (`csharp`) | 📋 | 📋 | 📋 | 📋 | — |
| Clojure (`clojure`) | 📋 | 📋 | 📋 | 📋 | — |
| COBOL (`cobol`) | 📋 | 📋 | 📋 | 📋 | — |
| Common Lisp (`common-lisp`) | 📋 | 📋 | 📋 | 📋 | — |
| C++ (`cpp`) | 📋 | 📋 | 📋 | 📋 | — |
| Crystal (`crystal`) | 📋 | 📋 | 📋 | 📋 | — |
| D (`d`) | 📋 | 📋 | 📋 | 📋 | — |
| Dart (`dart`) | 📋 | 📋 | 📋 | 📋 | — |
| Elixir (`elixir`) | 📋 | 📋 | 📋 | 📋 | — |
| Elm (`elm`) | 📋 | 📋 | 📋 | 📋 | — |
| Erlang (`erlang`) | 📋 | 📋 | 📋 | 📋 | — |
| Forth (`forth`) | 📋 | 📋 | 📋 | 📋 | — |
| F# (`fsharp`) | 📋 | 📋 | 📋 | 📋 | — |
| Gleam (`gleam`) | 📋 | 📋 | 📋 | 📋 | — |
| Go (`go`) | 📋 | 📋 | 📋 | 📋 | — |
| Grain (`grain`) | 📋 | 📋 | 📋 | 📋 | — |
| Groovy (`groovy`) | 📋 | 📋 | 📋 | 📋 | — |
| Haskell (`haskell`) | 📋 | 📋 | 📋 | 📋 | — |
| Haxe (`haxe`) | 📋 | 📋 | 📋 | 📋 | — |
| Java (`java`) | 📋 | 📋 | 📋 | 📋 | — |
| JavaScript (`javascript`) | 📋 | 📋 | 📋 | 📋 | — |
| Julia (`julia`) | 📋 | 📋 | 📋 | 📋 | — |
| Kotlin (`kotlin`) | 📋 | 📋 | 📋 | 📋 | — |
| Lua (`lua`) | 📋 | 📋 | 📋 | 📋 | — |
| Nim (`nim`) | 📋 | 📋 | 📋 | 📋 | — |
| OCaml (`ocaml`) | 📋 | 📋 | 📋 | 📋 | — |
| Perl (`perl`) | 📋 | 📋 | 📋 | 📋 | — |
| PHP (`php`) | 📋 | 📋 | 📋 | 📋 | — |
| Prolog (`prolog`) | 📋 | 📋 | 📋 | 📋 | — |
| PureScript (`purescript`) | 📋 | 📋 | 📋 | 📋 | — |
| Python (`python`) | 📋 | 📋 | 📋 | 📋 | — |
| R (`r`) | 📋 | 📋 | 📋 | 📋 | — |
| Racket (`racket`) | 📋 | 📋 | 📋 | 📋 | — |
| Raku (`raku`) | 📋 | 📋 | 📋 | 📋 | — |
| ReScript (`rescript`) | 📋 | 📋 | 📋 | 📋 | — |
| REXX (`rexx`) | 📋 | 📋 | 📋 | 📋 | — |
| Ruby (`ruby`) | 📋 | 📋 | 📋 | 📋 | — |
| Rust (`rust`) | 📋 | 📋 | 📋 | 📋 | — |
| Scala (`scala`) | 📋 | 📋 | 📋 | 📋 | — |
| Scheme (`scheme`) | 📋 | 📋 | 📋 | 📋 | — |
| Swift (`swift`) | 📋 | 📋 | 📋 | 📋 | — |
| Tcl/Tk (`tcl-tk`) | 📋 | 📋 | 📋 | 📋 | — |
| TypeScript (`typescript`) | 📋 | 📋 | 📋 | 📋 | — |
| V (`v`) | 📋 | 📋 | 📋 | 📋 | — |
| Vala (`vala`) | 📋 | 📋 | 📋 | 📋 | — |
| Zig (`zig`) | 📋 | 📋 | 📋 | 📋 | — |

---

## 3. Documentos por módulo / Per-module documents

> **ES:** Pendiente registrado (revisión posterior): alinear los README de módulo (`{lenguaje}/core/{fase}/{módulo}/README.md`) con `PARADIGM_FAMILIES.md` — manteniendo su pseudocódigo canónico y su didáctica y añadiendo el enlace a la familia — y revisar el impacto en `docs/ROADMAP.md` y `docs/ROADMAP_UPDATE_CHECKLIST.md`. **Nada de eso se ha modificado en este cambio.**
>
> **EN:** Registered pending item (later review): align module READMEs (`{lang}/core/{phase}/{module}/README.md`) with `PARADIGM_FAMILIES.md` — keeping their canonical pseudocode and teaching material and adding the family link — and review the impact on `docs/ROADMAP.md` and `docs/ROADMAP_UPDATE_CHECKLIST.md`. **None of that has been modified in this change.**

| Fase / Phase | Módulo / Module | Especificación / Spec | README (N3) | Evidencia / Evidence | Estado / State | Responsable / Owner |
|--------------|-----------------|:---------------------:|:-----------:|:--------------------:|:--------------:|:-------------------:|
| **Fase 0 — Foundations** | `core.foundations.hello_world` | ✅ | ✅ | 📋 | ✅ | — |
| **Fase 0 — Foundations** | `core.foundations.hello_user` | ✅ | ✅ | 📋 | ✅ | — |
| **Fase 0 — Foundations** | `core.foundations.unit_test` | ✅ | ✅ | 📋 | ✅ | — |
| **Fase 0 — Foundations** | `core.foundations.numbers` | ✅ | ✅ | 📋 | ✅ | — |
| **Fase 1 — Algorithms Pure** | `core.algorithms.naive_sort` | ✅ | ✅ | ✅ | ✅ | — |
| **Fase 1 — Algorithms Pure** | `core.algorithms.data_structures_basics` | ✅ | ✅ | ✅ | ✅ | Software Architect (apoyo: Language-Specific SME, SDET) |
| **Fase 1 — Algorithms Pure** | `core.algorithms.data_structures_advanced` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 1 — Algorithms Pure** | `core.algorithms.efficient_sort` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 1 — Algorithms Pure** | `core.algorithms.distributed_sort` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 1 — Algorithms Pure** | `core.algorithms.searching` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 2 — Contiguous Processing** | `core.text.transformations` | ✅ | 📋 | 📋 | 🔄 | — |
| **Fase 2 — Contiguous Processing** | `core.text.patterns` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 2 — Contiguous Processing** | `core.text.substr` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 2 — Contiguous Processing** | `core.text.input_output` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 2 — Contiguous Processing** | `core.text.etl_basico` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 3 — Algorithms on Structures** | `core.structures.graph_algorithms` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 3 — Algorithms on Structures** | `core.structures.backtracking` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 3 — Algorithms on Structures** | `core.structures.dynamic_programming` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 3 — Algorithms on Structures** | `core.structures.greedy` | ✅ | 📋 | 📋 | 📋 | — |
| **Fase 4 — Abstraction & Persistence** | `core.data.modeling` | 📋 | 📋 | 📋 | 📋 | — |
| **Fase 4 — Abstraction & Persistence** | `core.data.strsearch` | 📋 | 📋 | 📋 | 📋 | — |
| **Fase 4 — Abstraction & Persistence** | `core.data.regex` | 📋 | 📋 | 📋 | 📋 | — |
| **Fase 4 — Abstraction & Persistence** | `core.data.parsing` | 📋 | 📋 | 📋 | 📋 | — |
| **Fase 4 — Abstraction & Persistence** | `core.data.data_base` | 📋 | 📋 | 📋 | 📋 | — |
| **Fase 4 — Abstraction & Persistence** | `core.data.integracion_etl` | 📋 | 📋 | 📋 | 📋 | — |
| **Fase 5 — Math** | `core.math.statistics` | 📋 | 📋 | 📋 | 📋 | — |
| **Fase 5 — Math** | `core.math.linear_algebra` | 📋 | 📋 | 📋 | 📋 | — |
| **Utilidades / Utilities** | `util.logging` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Utilidades / Utilities** | `util.db` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Utilidades / Utilities** | `util.data_transform` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Utilidades / Utilities** | `util.serialization` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Utilidades / Utilities** | `util.config` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Herramientas / Dev Tools** | `tools.sast_ada` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Herramientas / Dev Tools** | `tools.coverage_reporter` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Herramientas / Dev Tools** | `tools.linter_aggregator` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 6 — UI** | `ui.cliapp` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 6 — UI** | `ui.tuiapp` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 6 — UI** | `ui.guiapp` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 7 — Web** | `web.mvcapp` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 7 — Web** | `web.api` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 8 — Async** | `async.futures_and_promises` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 8 — Async** | `async.async_await` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 8 — Async** | `async.actor_model` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 8 — Async** | `async.channels` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 8 — Async** | `async.parallel` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 9 — Interop** | `interop.c_binding` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 9 — Interop** | `interop.system_calls` | ⏳ | ⏳ | ⏳ | ⏳ | — |
| **Fase 9 — Interop** | `interop.other_lang_bridge` | ⏳ | ⏳ | ⏳ | ⏳ | — |

---

## 4. Documentos de tooling / Tooling documents (glot, sprint, roadmap, agent template)

| Documento / Document | Propósito / Purpose | Estado / State | Responsable / Owner |
|----------------------|---------------------|:--------------:|:-------------------:|
| `docs/ROADMAP.md` | Progreso por fases, especificaciones y contadores `X/50` / Phase progress, specs, and `X/50` counters | 🔄 | — |
| `docs/WORKFLOW.md` / `scripts/docs/SPRINT.md` (`Sprint de módulo.md`) | Norma del ciclo de sprint y comandos operativos por paso / Sprint cycle policy and step-by-step commands | ✅ | — |
| `scripts/README.md` (`glot` CLI docs) | Orquestador de desarrollo, tooling del monorepo y catálogo de datos / Development tool orchestrator and data catalog | ✅ | — |
| `docs/AGENT_Template.md` / `AGENTS.md` | Contrato de agentes de IA, roles y calendario de adopción / AI agent contract, roles, and adoption schedule | ✅ | — |
| `docs/ROADMAP_UPDATE_CHECKLIST.md` | Lista de verificación obligatoria para cierre de fase y módulo / Verification checklist for phase and module closure | ✅ | — |
| `docs/README_Template.md` | Plantilla canónica de README de Nivel 3 para módulos / Canonical Level 3 module README template | ✅ | — |

---

## 5. Orden de trabajo / Order of work

### Cadena bloqueante / Blocking chain (must exist before auditing begins)

1. `docs/ruleset/PSEUDOCODE_CONVENTION.md` → **hecho / done** ✅
2. `docs/ruleset/IDIOMATICITY_LEVELS.md` → **hecho / done** ✅
3. `docs/ruleset/data/canonical_names.tsv` → **hecho / done** ✅
4. `docs/ruleset/LANGUAGE_CHARACTERISTICS.md` → **hecho / done** ✅
5. `docs/ruleset/data/language_characteristics.tsv` → **hecho / done** ✅

### Cadena de soporte / Support chain (can be done in parallel)

6. `docs/ruleset/DEVIATION_POLICY.md` → **hecho / done** ✅
7. `docs/ruleset/PARADIGM_FAMILIES.md` → **hecho / done** ✅
8. `docs/ruleset/data/idiomaticity_state.tsv` → **en curso / in progress** 🔄
9. Archivos por lenguaje en `docs/ruleset/idioms/{lang}.md` / Per-language `idioms/` files
10. Archivos por lenguaje en `docs/ruleset/adaptations/{lang}.md` / Per-language `adaptations/` files
11. Changelogs por lenguaje / Per-language changelogs