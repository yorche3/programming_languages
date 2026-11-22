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

**ES:** La especificación vigente exige orden creciente e identificadores en la
adyacencia. La intención propuesta es vecinos como nodos `GraphNode` o
representación equivalente acordada, orden de inserción y salida de
identificadores enteros en una secuencia tipo array/lista idiomática. No
ejecutes correcciones incompatibles con la especificación vigente.

Antes del fix, el Software Architect y el Computer Scientist deben revisar la
especificación y la guía de implementación: representación de nodos y ciclos,
adaptaciones inmutables, algoritmo manual, orden, resultados, pseudocódigo,
casos y complejidad. Aclara con el autor cualquier imposibilidad o compromiso
no resuelto; no aceptes etiquetas enteras como sustituto silencioso de nodos.
No añadas API para listar vértices ni un árbol rojo-negro o heap. El autor
aprueba el contrato revisado antes de que SDET o el desarrollador continúen.

**EN:** The current specification requires ascending adjacency of identifiers.
The proposed intent is node neighbours or an agreed equivalent, insertion order,
and an idiomatic array/list-like sequence of integer identifiers. Do not perform
changes incompatible with the current specification. The architect and computer
scientist first revise the contract and guide, including cycles, immutable
adaptations, algorithms, outputs, cases and complexity; consult the author on
unresolved trade-offs. Do not silently substitute integer labels for nodes or
add a vertex-listing API, red-black tree or heap. Author approval gates the work.

## Trabajo por lenguaje / Per-language work

1. **Reconocimiento / Reconnaissance.** En la raíz, `git status --short` y
   `git submodule status`; en `{lang}`, comprueba rama y estado. No invadas
   cambios ajenos ni una rama activa sin autorización. Lee contrato revisado,
   fuentes, suite, README y referencias del mismo lenguaje. Registra commit,
   causa y resultados reales de la suite inicial; no interpretes una suite
   antigua verde como cumplimiento del contrato nuevo.
2. **Suite / Suite — SDET.** Cambia los casos afectados en el paso de suite o
   `correct`, no desde `fix`. En vértice `10`, inserta vecinos `70`, `30`, `50`
   y repite `30`: espera `[70, 30, 50]` y tres aristas. Comprueba retorno de
   enteros, aislamiento de la salida anterior y mutable, ausencia frente a
   vacío, dirección, vértices aislados, bucles, duplicados, extremos inexistentes
   y contadores. Conserva los casos del árbol y otros casos requeridos; adapta
   solo lo que cambió en el contrato. Ejecuta y documenta el rojo esperado o el
   bloqueo real; una prueba conductual no demuestra representación interna.
3. **Fix / Fix — Senior Software Developer.** Con contrato y suite aprobados,
   implementa lo mínimo necesario: vecinos de nodos según el contrato,
   búsqueda manual e inserción al final en orden de entrada, sin ordenación;
   convierte a identificadores en la salida. Mantén duplicados idempotentes,
   aristas dirigidas, bucles, errores, contadores y aislamiento. Revisa
   identidad de vértices y ciclos; en inmutables usa solo la adaptación
   aprobada. Evita recorridos o copias cuadráticas que excedan la cota revisada.
   No cambies la suite desde `fix`.
4. **Verificación y README / Verification and README.** Ejecuta la suite nativa
   y el verificador correspondientes; conserva las salidas reales y reporta
   bloqueos o warnings. Revisa código y complejidad, porque una suite verde no
   prueba el enlace a nodos. Actualiza el README N3 en el paso documental con
   representación, resultados, adaptación y costes reales.
5. **Entrega / Delivery.** Reporta contrato y commit inspeccionados, causa,
   archivos, adaptación, evidencia anterior/posterior, casos y límites
   pendientes. Registra solo lo comprobado. No hagas `git add`, commit, push,
   cambios de puntero ni cierre; son decisiones del autor.

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
