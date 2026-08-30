# 🤖 Guía para Agentes de IA / AI Agent Guide

**ES:** Este documento es la guía operativa para cualquier agente de IA (Claude, Copilot, Continue, etc.) que asista en la generación o corrección de documentación de este monorepo. No reemplaza a [`Plantilla_Readme.md`](Plantilla_Readme.md) — lo complementa, indicando **cuándo** y **cómo** aplicarla según el nivel del documento y la fase actual del roadmap.

**EN:** This document is the operational guide for any AI agent (Claude, Copilot, Continue, etc.) assisting in generating or fixing this monorepo's documentation. It does not replace [`Plantilla_Readme.md`](Plantilla_Readme.md) — it complements it, indicating **when** and **how** to apply it depending on the document level and the current roadmap phase.

---

## 🎯 Alcance de los agentes en este repo / Scope of agents in this repo

**ES:** El propósito principal del repositorio es que el autor **practique cada lenguaje personalmente**. Los agentes de IA se usan sobre todo para:

1. Generar y corregir **documentación** (README de sub-proyecto, de `core/foundations`, y raíz del lenguaje).
2. Corregir o mejorar **implementaciones** ya escritas por el autor (revisiones, fixes, refactors puntuales).
3. En casos de lenguajes más complejos o con poca información disponible para el autor, ayudar también a **generar implementación** — esto es la excepción, no la regla.

**EN:** The repo's main purpose is for the author to **personally practice each language**. AI agents are mainly used to:

1. Generate and fix **documentation** (sub-project README, `core/foundations` README, and language root README).
2. Fix or improve **implementations** already written by the author (reviews, fixes, targeted refactors).
3. For more complex languages or ones with little information available to the author, also help **generate implementation** — this is the exception, not the rule.

> **ES:** Un agente **nunca** debe implementar código de un lenguaje simplemente porque "es más rápido" — eso rompería el propósito de aprendizaje del repo.
> **EN:** An agent should **never** implement a language's code simply because "it's faster" — that would defeat the repo's learning purpose.

---

## 🧭 Antes de escribir nada / Before writing anything

**ES:** Todo agente debe verificar, en este orden, antes de tocar documentación o código:

1. `git status` y `git submodule status` en la raíz — para saber qué está en progreso o sin commitear.
2. La rama activa de cada submódulo afectado (`git -C <lenguaje> branch`) — el flujo es `dev → feature/<módulo> → dev → main` (ver [`CONTRIBUTING.md`](CONTRIBUTING.md)).
3. El estado real de `docs/ROADMAP.md` — un ✅ ahí **debe** corresponder a código y documentación existentes; si no, es un hueco a señalar, no a asumir como resuelto.
4. **No tocar** lenguajes que el autor tenga marcados como "en progreso activo" (rama `feature/*` sin mergear a `dev`), salvo que el autor lo pida explícitamente.

**EN:** Every agent must verify, in this order, before touching documentation or code:

1. `git status` and `git submodule status` at the root — to know what's in progress or uncommitted.
2. The active branch of each affected submodule (`git -C <language> branch`) — the flow is `dev → feature/<module> → dev → main` (see [`CONTRIBUTING.md`](CONTRIBUTING.md)).
3. The real state of `docs/ROADMAP.md` — a ✅ there **must** correspond to existing code and docs; if not, flag it as a gap, don't assume it's resolved.
4. **Do not touch** languages the author has marked as "actively in progress" (unmerged `feature/*` branch), unless explicitly requested.

---

## 🪜 Niveles de documentación / Documentation levels

**ES:** Cada lenguaje homologado (submódulo) tiene documentación en 3 niveles. Un agente debe identificar en qué nivel está trabajando antes de generar contenido:

| Nivel | Archivo | Plantilla base | Propósito |
|-------|---------|-----------------|-----------|
| **1 — Lenguaje (raíz)** | `{lenguaje}/README.md` | Ver ejemplo en `groovy/README.md` o `cpp/README.md` | Requisitos, tipos de proyecto (script simple vs. proyecto con tests), lista de módulos por fase |
| **2 — Fase (`core/`, `core/foundations/`, etc.)** | `{lenguaje}/core/README.md`, `{lenguaje}/core/{fase}/README.md` | Ver ejemplo en `ada/core/README.md`, `ada/core/foundations/README.md` | Tabla de módulos de la fase, estructura de directorios, estado (✅/📋/⛔) |
| **3 — Sub-proyecto (módulo individual)** | `{lenguaje}/core/{fase}/{modulo}/README.md` | [`Plantilla_Readme.md`](Plantilla_Readme.md) | Detalle de archivos, enfoque de construcción, algoritmos, notas de implementación |

**EN:** Each homologated language (submodule) has documentation at 3 levels. An agent must identify which level it's working on before generating content — see the table above (same content applies in English).

---

## 🧩 Evolución de `Plantilla_Readme.md` por fase / `Plantilla_Readme.md` evolution by phase

**ES:** `Plantilla_Readme.md` se mantiene como plantilla única de **Nivel 3**, pero su contenido de referencia (secciones opcionales, ejemplos de notas de implementación) cambiará a medida que el roadmap avanza de fase, porque cada fase introduce nuevos conceptos (ver `docs/ROADMAP.md` → "Curva de aprendizaje"):

| Fase | Concepto nuevo a documentar en Nivel 3 |
|------|------------------------------------------|
| 0 — Foundations | Enfoques recursivo/acumulador/iterativo, TCO |
| 1 — Algorithms Pure | Valores centinela (sin excepciones) |
| 2 — Contiguous Processing | Manejo de excepciones |
| 3 — Abstraction & Persistence | Tipos de retorno (Option/Result, Maybe/Either) |

**ES:** Cuando el autor entra a una fase nueva, el agente debe **proponer una adecuación** de `Plantilla_Readme.md` (nueva sección de notas de implementación específica de la fase) en lugar de crear una plantilla totalmente nueva. Esto deja evidencia explícita, en el historial de commits de `docs/Plantilla_Readme.md`, de cómo se fue poblando el repo fase por fase.

**EN:** When the author starts a new phase, the agent should **propose an adjustment** to `Plantilla_Readme.md` (a new phase-specific implementation notes section) instead of creating a brand-new template. This leaves explicit evidence, in `docs/Plantilla_Readme.md`'s commit history, of how the repo was populated phase by phase.

---

## ✅ Reglas al generar documentación / Rules when generating documentation

1. **ES:** Nunca marcar ✅ o "Estado: completado" si no verificaste que el código y sus tests existen y compilan/pasan.
   **EN:** Never mark ✅ or "Status: complete" without verifying the code and its tests exist and build/pass.
2. **ES:** Si un módulo no se implementa por una limitación real del lenguaje (ej. `hellouser` en Grain, sin `stdin`), documentarlo explícitamente con ⛔ y la razón — no omitirlo en silencio.
   **EN:** If a module isn't implemented due to a real language limitation (e.g. `hellouser` in Grain, no `stdin`), explicitly document it with ⛔ and the reason — don't silently omit it.
3. **ES:** Mantener el formato bilingüe ES/EN en bloques `**ES:** ... **EN:** ...` como en el resto del repo.
   **EN:** Keep the bilingual ES/EN format in `**ES:** ... **EN:** ...` blocks as in the rest of the repo.
4. **ES:** Los enlaces a especificaciones apuntan a GitHub Pages (`https://yorche3.github.io/programming_languages/...`), no a rutas relativas de archivo, en READMEs de Nivel 2 y 3.
   **EN:** Links to specifications point to GitHub Pages (`https://yorche3.github.io/programming_languages/...`), not relative file paths, in Level 2 and 3 READMEs.
5. **ES:** No generar documentación para lenguajes en `feature/*` sin mergear, ni adelantarse al lenguaje que sigue en la secuencia de migración del autor (A→Z hasta Haskell, luego Z→A).
   **EN:** Do not generate documentation for languages on an unmerged `feature/*` branch, nor get ahead of the next language in the author's migration order (A→Z through Haskell, then Z→A).
6. **ES:** No ejecutar `git push` en ningún submódulo ni en el monorepo raíz salvo instrucción explícita del autor.
   **EN:** Never run `git push` on any submodule or the root monorepo unless explicitly instructed by the author.

---

*[← Volver al inicio / Back to home](index.md)*
