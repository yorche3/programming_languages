# 🔁 Ciclo de trabajo de un módulo / Module work cycle (sprint)

**ES:** Este documento es la **norma** del ciclo con el que se lleva un módulo desde su especificación hasta su cierre con evidencia. Aplica a **todos** los lenguajes homologados, no solo al tooling. Lo que dice [`docs/CONTRIBUTING.md`](CONTRIBUTING.md) sobre Git y submódulos manda sobre este documento; lo que dice [`docs/ROADMAP.md`](ROADMAP.md) sobre contadores y cierre de fase, también.

**EN:** This document is the **policy** for the cycle that takes a module from its specification to its closure with evidence. It applies to **all** standardised languages, not just the tooling. What [`docs/CONTRIBUTING.md`](CONTRIBUTING.md) states about Git and submodules prevails over this document; so does what [`docs/ROADMAP.md`](ROADMAP.md) states about counters and phase closure.

> **ES:** «Sprint» es el nombre coloquial del ciclo: **un** `{lenguaje} + {fase}/{módulo}`, con su documentación, su implementación y su verificación. No es un sprint de calendario: empieza cuando se asigna el trabajo y termina cuando queda registrado el cierre.
> **EN:** "Sprint" is the colloquial name for the cycle: **one** `{language} + {phase}/{module}`, with its documentation, implementation and verification. It is not a calendar sprint: it starts when the work is assigned and ends when the closure is recorded.

---

## 🧭 Principio de partida / Starting principle

**ES:** Un sprint empieza **siempre** desde el `main` del submódulo, que guarda el estado concluido del lenguaje, y siempre desde una **especificación existente** en `docs/core/{fase}/`. Si falta la especificación, el sprint no empieza: se escribe antes.

**EN:** A sprint **always** starts from the submodule's `main`, which holds the language's closed state, and always from an **existing specification** in `docs/core/{phase}/`. If the specification is missing, the sprint does not start: it is written first.

---

## 🅰️ Fase A — en el submódulo del lenguaje / Phase A — inside the language submodule

| # | Paso | Objetivo | Artefacto obligatorio |
|:-:|------|----------|-----------------------|
| 1 | Reconocimiento | Saber en qué estado está el repo y el submódulo antes de tocar nada | `git status --short` y `git submodule status` leídos, sin cambios pendientes ajenos al sprint |
| 2 | Asignación | Fijar `{lenguaje}`, `{fase}`, `{módulo}`, la rama y la especificación del sprint | Estado del sprint registrado fuera del shell (ver «Estado del sprint») |
| 3 | Rama de trabajo | Trabajar aislado, con la rama publicada y su upstream | Rama `{tipo}/{fase}/{módulo}` en minúsculas y `kebab-case`, publicada |
| 4 | Esqueleto y pruebas | Dejar el andamiaje y la suite, **sin implementar** | Estructura del lenguaje + suite que falla por falta de implementación (o pasa si el módulo es solo documental) |
| 5 | Implementación | Cumplir el contrato de la especificación | Código verificado por la suite, sin warnings |
| 6 | Verificación | Tener evidencia real de que cumple | Salida real de la suite y del analizador, copiada sin editar |
| 7 | Cierre documental del módulo | Documentar lo implementado | `README.md` de Nivel 3 generado desde [`README_Template.md`](README_Template.md) |
| — | Integración | Que el lenguaje quede en estado concluido | Rama integrada en el `main` del submódulo; commit anotado |

## 🅱️ Fase B — en el monorepo / Phase B — in the monorepo

| # | Paso | Objetivo | Artefacto obligatorio |
|:-:|------|----------|-----------------------|
| 8 | Puntero y cierre del lenguaje | Que el monorepo apunte al commit integrado y que el lenguaje quede cerrado | Puntero actualizado en rama `chore/{fase}/{módulo}-pointer`; readmes faltantes e índices de Nivel 1–3 al día |
| 9 | Registro del cierre | Dejar constancia verificable | Entrada en [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) y contador de [`ROADMAP.md`](ROADMAP.md) al día, en el mismo cambio |

**ES:** El puntero se actualiza **después** de integrar en el `main` del submódulo y **antes** de integrar la rama del monorepo. Nunca se apunta a una rama de trabajo no integrada.

**EN:** The pointer is updated **after** integrating into the submodule's `main` and **before** integrating the monorepo branch. It never points to a non-integrated working branch.

---

## 👥 Quién hace cada paso / Who does each step

| Paso | Autor | Tooling (`glot`) | Agente de IA |
|------|:-----:|:----------------:|:------------:|
| 1 Reconocimiento | decide | informa | — |
| 2–3 Asignación y rama | decide | ejecuta | — |
| 4 Esqueleto y pruebas | revisa | ejecuta | **escribe** |
| 5 Implementación | decide | ejecuta pruebas | **puede escribir** |
| 6 Verificación | valida | ejecuta y captura | **comprueba** |
| 7 README del módulo | valida | encarga | **escribe** |
| 8 Puntero e índices | decide | ejecuta | **escribe la documentación** |
| 9 Registro del cierre | autoriza | encarga | **escribe el registro** |

**ES:** Los pasos 4a, 4b, 5, 7 y 8 usan IA porque exigen **leer y comparar** (especificación contra código, plantilla contra README, roadmap contra el estado real). El encargo lo arma `glot prompt <encargo>` con las plantillas **versionadas** de [`scripts/prompts/`](../scripts/prompts/); el banco local de `.github/prompts/` (que `.gitignore` excluye) se acepta como respaldo, con aviso. El agente **nunca** ejecuta `git add`, `git commit` ni `git push`: eso lo decide y lo hace el autor.

**EN:** Steps 4a, 4b, 5, 7 and 8 use AI because they require **reading and comparing** (spec against code, template against README, roadmap against the real state). The request is built by `glot prompt <request>` from the **versioned** templates in [`scripts/prompts/`](../scripts/prompts/); the local bank in `.github/prompts/` (excluded by `.gitignore`) is accepted as a fallback, with a warning. The agent **never** runs `git add`, `git commit` or `git push`: the author decides and does that.

---

## 🗂️ Estado del sprint / Sprint state

**ES:** El sprint tiene un estado explícito —lenguaje, fase, módulo, rama, especificación y ruta del submódulo— que **no** se deduce del directorio actual. Se guarda fuera del shell (almacén de estado de `glot`, ver [`scripts/docs/CONTRACT.md`](../scripts/docs/CONTRACT.md)) para que cualquier comando posterior —ejecutar pruebas, encargar documentación, capturar evidencia— funcione **desde cualquier directorio** y para el mismo módulo.

**EN:** A sprint has explicit state —language, phase, module, branch, specification and submodule path— which is **not** inferred from the current directory. It is stored outside the shell (`glot`'s state store, see [`scripts/docs/CONTRACT.md`](../scripts/docs/CONTRACT.md)) so that any later command —running tests, requesting documentation, capturing evidence— works **from any directory** and for the same module.

---

## 📋 Evidencia y cierre / Evidence and closure

**ES:** Un paso no está hecho hasta que deja su evidencia. La evidencia es la **salida real** del comando, copiada sin editar ni resumir; si un comando no se ha ejecutado, no hay evidencia y el paso sigue abierto.

**EN:** A step is not done until it leaves its evidence. Evidence is the command's **real output**, copied without editing or summarising; if a command has not been run, there is no evidence and the step stays open.

1. **Cierre del módulo:** código + pruebas ejecutadas + README de Nivel 3 + entrada en [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) + actualización de [`ROADMAP.md`](ROADMAP.md), **en el mismo cambio**.
2. **Cierre de fase:** solo cuando **todos** los módulos requeridos cumplen el ciclo completo. Un README no cierra un módulo, y un módulo no cierra una fase.
3. **Nada se marca `✅` sin evidencia verificable.**

---

## ✅ Definition of Done del sprint / Sprint Definition of Done

- [ ] Reconocimiento hecho: `git status --short` y `git submodule status` leídos.
- [ ] Sprint asignado: lenguaje, fase, módulo, rama y especificación registrados.
- [ ] Rama `{tipo}/{fase}/{módulo}` publicada con su upstream.
- [ ] Esqueleto y `.gitignore` del módulo puestos, sin `main` de ejemplo si el módulo es una biblioteca.
- [ ] Suite ejecutada con salida real; sin warnings ni errores.
- [ ] Divergencias respecto al pseudocódigo clasificadas como idiomáticas (documentadas) o como defecto (reportadas).
- [ ] README de Nivel 3 generado desde la plantilla, bilingüe y con salidas reales.
- [ ] Índices de Nivel 1–3 actualizados (o creados si faltaban).
- [ ] Integrado en el `main` del submódulo.
- [ ] Puntero del submódulo actualizado en el monorepo.
- [ ] Entrada en el checklist y contador del roadmap al día.
- [ ] `git diff --check` sin errores.
- [ ] Sin `push` ni `commit` hechos por el agente.

---

## 🔗 Relación con otras normas / Relation to other policies

| Documento | Qué manda |
|-----------|-----------|
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Ramas, Conventional Commits, alcances y el orden del puntero del submódulo |
| [`ROADMAP.md`](ROADMAP.md) | Estados, contadores `X/50` y cierre de fases |
| [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) | Plantilla y registro del cierre |
| [`README_Template.md`](README_Template.md) | Estructura obligatoria del README de Nivel 3 |
| [`AGENT_Template.md`](AGENT_Template.md) | Cómo genera documentación el agente |
| [`../AGENTS.md`](../AGENTS.md) | Límites de actuación del agente: qué puede y qué no |
| [`../scripts/docs/SPRINT.md`](../scripts/docs/SPRINT.md) | Los mismos pasos, con el comando de `glot` que los cubre |
