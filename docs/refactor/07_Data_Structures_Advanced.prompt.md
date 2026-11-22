---
layout: default
title: Encargo de corrección 07 / Correction request 07
nav_exclude: true
---

# Encargo de corrección: Data Structures Advanced
# Correction request: Data Structures Advanced

**ES:** Encargo manual para el autor y los agentes; no ejecuta `glot prompt`
ni `glot ask`. Un lenguaje por encargo. Sustituye `{lang}` por el lenguaje y
declara la rama autorizada antes de actuar. Este documento no modifica por sí
solo la especificación.

**EN:** Manual request for the author and agents; do not run `glot prompt` or
`glot ask`. One language per request. Supply `{lang}` and the authorised branch
before acting. This document does not itself change the specification.

## Roles y precedencia / Roles and precedence

**ES:** Cada entrega tiene un dueño: Software Architect con Computer Scientist
para el contrato; SDET para la suite; Senior Software Developer con apoyo del
Language-Specific SME para el fix; Technical Writer para el README; Validator
para la verificación. El autor como Tech Lead decide conflictos y cierre.
Una persona o agente puede asumir varios roles, pero no sustituir sus entregas.

**EN:** Each delivery has one owner: Software Architect with Computer Scientist
for the contract; SDET for the suite; Senior Software Developer with the
Language-Specific SME for the fix; Technical Writer for the README; Validator
for verification. The author as Tech Lead decides conflicts and closure.

Lee `AGENTS.md`, `docs/AGENT_ROLES.md`, `docs/AGENT_Template.md`,
`docs/WORKFLOW.md`, `docs/AUDIT_WORKFLOW.md`,
`docs/audits/07_Audited_Data_Structures_Advanced.md`,
`docs/core/algorithms/07_Data_Structures_Advanced.md`,
`docs/implementations/07_Data_Structures_Advanced.md` y
`docs/README_Template.md`. Para la forma, inspecciona en `{lang}` primero
`core/algorithms/data_structures_basics` y después
`core/foundations/numbers`, incluidos fuentes, suite, runner, manifiesto y README
pertinentes. Son referencias, no sustituyen contrato ni fase.

## Portón de contrato / Contract gate

**ES:** **Resuelto el 2026-11-22.** El autor confirma el contrato **vigente**:
la adyacencia conserva el **orden creciente** porque la especificación y la guía
ya lo fijan, y la propuesta de vecinos como nodos en orden de inserción queda
descartada para este pase. Por tanto **no se toca la especificación ni la
suite**: el trabajo es un `align` por lenguaje.

Criterios acordados con el autor:

- **Sin `sort` de biblioteca.** El orden creciente se obtiene con **inserción
  ordenada escrita a mano**; solo se dejaría el orden de agregado si la
  documentación del lenguaje no fijara el orden, y aquí sí lo fija.
- **Estructura de vecinos libre**: array, lista o cola, la que mejor se ajuste
  al lenguaje, siempre que recorrido, detección de duplicado e inserción
  ordenada sean manuales. Se pueden reutilizar funciones, métodos o helpers de
  estructuras de módulos anteriores; el **recorrido de búsqueda es manual**.
- **Listas inmutables o enlazadas** pueden anteponer internamente; la salida
  observable sigue siendo ascendente y la adaptación se documenta.
- **Prolog**: predicado recursivo propio; `member/2` es hallazgo.
- **Documentación dentro de la rama `align`**: comentarios y README N3 cuando
  cambien estructura o complejidad.
- **Un commit por paso y sin push.**

**EN:** **Resolved on 2026-11-22.** The author confirms the **current contract**:
the adjacency keeps **ascending order** because the specification and the guide
already fix it, and the node-neighbour insertion-order proposal is discarded for
this pass. Therefore **neither the specification nor the suite is touched**: the
work is one `align` per language, with the criteria above (no library `sort`;
free neighbour storage with manual traversal, duplicate detection and ordered
insertion; helper reuse from earlier modules allowed; internal prepending
allowed when the output stays ascending and the adaptation is documented;
Prolog with its own predicate; documentation inside the `align` branch; one
commit per step, no push).

## Trabajo por lenguaje / Per-language work

1. **Reconocimiento / Reconnaissance.** En la raíz, `git status --short` y
   `git submodule status`; en `{lang}`, comprueba rama y estado. No invadas
   cambios ajenos ni una rama activa sin autorización. Lee el contrato vigente,
   las fuentes, la suite, el README y las referencias del mismo lenguaje.
   Registra commit, causa y resultados reales de la suite inicial antes de
   tocar nada / in the root, `git status --short` and `git submodule status`; in
   `{lang}`, branch and state; do not invade others' changes or an active
   branch. Read the current contract, sources, suite, README and the language's
   references. Record commit, cause and the real result of the initial suite
   before touching anything.
2. **Suite / Suite — SDET.** No cambia: el contrato conserva el orden creciente
   y los casos ya lo verifican. Comprueba que el caso de vecinos sigue esperando
   `[30, 50, 70]` con `70, 30, 50` insertados y `30` repetido, y que cubre
   retorno de enteros, aislamiento de la salida, ausencia frente a vacío,
   dirección, vértices aislados, bucles, duplicados, extremos inexistentes y
   contadores. Si un caso tuviera que cambiar, el paso deja de ser `align` /
   it does not change: the contract keeps ascending order and the cases already
   verify it; confirm the neighbour case still expects `[30, 50, 70]` and that
   the rest of the scenario coverage holds. If a case had to change, the step
   would stop being an `align`.
3. **Fix / Fix — Senior Software Developer.** Sustituye la pertenencia de
   biblioteca por **recorrido manual** e **inserción ordenada a mano**, sin
   `sort`; elige la estructura de vecinos que mejor encaje (array, lista o
   cola) y reutiliza helpers de módulos previos solo para almacenar o leer, no
   para buscar. En listas inmutables o enlazadas puedes anteponer si la salida
   sigue ascendente y lo documentas. En Prolog, predicado recursivo propio.
   Mantén duplicados idempotentes, aristas dirigidas, bucles, errores,
   contadores, aislamiento y las cotas del contrato. No cambies la suite desde
   `fix` / replace library membership with a **manual traversal** and **ordered
   insertion**, no `sort`; pick the neighbour storage that best fits and reuse
   earlier modules' helpers only for storage or reading, not for searching;
   prepending is allowed in immutable or linked lists when the output stays
   ascending and it is documented; Prolog uses its own recursive predicate; keep
   duplicates idempotent, directed edges, loops, errors, counters, isolation and
   the contract's bounds. Do not change the suite from `fix`.
4. **Verificación y README / Verification and README.** Ejecuta la suite nativa
   y el verificador correspondientes; conserva las salidas reales y reporta
   bloqueos o warnings. Revisa código y complejidad, porque una suite verde no
   prueba que la búsqueda sea manual. Actualiza el README N3 **si cambió la
   estructura o la complejidad**, y regenera el acta con
   `glot evidence {lang} algorithms/data_structures_advanced` /
   run the native suite and verifier, keep the real output and report blocks or
   warnings; review code and complexity, because a green suite does not prove
   the lookup is manual. Update the N3 README **if structure or complexity
   changed** and regenerate the evidence record.
5. **Entrega / Delivery.** Reporta contrato y commit inspeccionados, causa,
   archivos, adaptación, evidencia anterior/posterior, casos y límites
   pendientes. Registra solo lo comprobado. **Un commit por paso y sin push**:
   código, README y acta en la rama `align/...`, y el puntero del submódulo en la
   rama `audit/...` del monorepo; el merge en el `main` del submódulo y el push
   los decide el autor / report the inspected contract and commit, cause, files,
   adaptation, before/after evidence, cases and pending limits; record only what
   was verified. **One commit per step and no push**: code, README and evidence
   on the `align/...` branch, and the submodule pointer on the monorepo's
   `audit/...` branch; the merge into the submodule's `main` and the push are
   the author's decision.

## Separación de ciclos / Cycle separation

**ES:** Cambiar el orden observable o la suite no es `refactor` 5c ni `align`.
Un refactor 5c posterior conserva comportamiento y suite; un `align` de
auditoría tampoco modifica especificación ni suite. El pase se hace sin
corregir código y clasifica los nueve ejes; registra fecha, comando, resultado
y commit verificado. No declares homologación sin suite real e integración,
ni actualices el roadmap durante trabajo parcial.

**EN:** Changing observable order or tests is neither 5c refactor nor `align`.
A later 5c preserves behaviour and tests; an audit `align` changes neither
specification nor suite. The audit pass fixes no code and classifies all nine
axes, recording date, command, result and verified commit. Do not claim a pass
without a real suite and integration, or update the roadmap during partial work.
