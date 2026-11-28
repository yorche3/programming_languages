# Política compartida de delegación / Shared delegation policy

## Autoridad y bases / Authority and references

**ES:** Lee `AGENTS.md`, `docs/AGENT_ROLES.md`, `docs/AGENT_Template.md` y las
fuentes declaradas del encargo. Respeta sus límites: esta política no amplía el
alcance del rol. Rige la **jerarquía normativa única** de `docs/AGENT_Template.md`:
1) `AGENTS.md`, `docs/CONTRIBUTING.md`, `docs/WORKFLOW.md` y `docs/ROADMAP.md`
(límites y flujo); 2) **`{spec}`** (manda siempre en el **qué**: operaciones,
dominio de valores, ausencia/fallo, invariantes, casos y complejidad); 3) reglas
de fase (sin excepciones ni `Option`/`Maybe` por estilo en Fase 1, salvo por
restricción del lenguaje para comparar `absent`); 4) capacidades verificadas del
lenguaje + `docs/ruleset/DEVIATION_POLICY.md`, `docs/ruleset/IDIOMATICITY_LEVELS.md`,
`docs/ruleset/data/canonical_names.tsv` y `docs/ruleset/data/language_characteristics.tsv`;
5) guías de implementación (`docs/implementations/`) y `docs/ruleset/PARADIGM_FAMILIES.md`
como orientación operativa; 6) las bases homologadas del mismo lenguaje solo
como **referencias de forma** (layout, naming, framework, runner). El contrato y
la suite existentes se comprueban contra `{spec}`, no se cambian para que pase
una implementación.

**EN:** Read `AGENTS.md`, `docs/AGENT_ROLES.md`, `docs/AGENT_Template.md` and
the request's declared sources. Respect their boundaries: this policy does not
extend role scope. The **single normative precedence hierarchy** in
`docs/AGENT_Template.md` governs: 1) `AGENTS.md`, `docs/CONTRIBUTING.md`,
`docs/WORKFLOW.md`, and `docs/ROADMAP.md` (boundaries and flow); 2) **`{spec}`**
(always governs the **what**: operations, value domain, absence/failure,
invariants, cases, and complexity); 3) phase rules (no exceptions or stylistic
`Option`/`Maybe` in Phase 1, except by language restriction to compare `absent`);
4) verified language capabilities + deviation/translation rules; 5) implementation
guides (`docs/implementations/`) and `docs/ruleset/PARADIGM_FAMILIES.md` as
operational guidance; 6) same-language homologated bases only as **form
references** (layout, naming, framework, runner). Check existing contract and
suite against `{spec}`, never change them to make an implementation pass.

**ES:** Para la forma, consulta estas bases **del mismo lenguaje, en este orden**:

1. `{lang}/core/algorithms/data_structures_basics/`
2. `{lang}/core/foundations/numbers/`

**EN:** For form, consult the two **same-language references in the order above**.

**ES:** Esta prioridad es persistente para todos los módulos y fases hasta que
se cambie explícitamente esta política versionada. No elijas «el primero de la
carpeta» ni reemplaces la base por estar en otra fase. Son **referencias**, no
moldes: no copies contenido, imports, tipos, dominios ni indicadores obsoletos
por inercia (por ejemplo, si una base usó `-1` o `Natural` y `{spec}` exige
enteros negativos y `absent`, manda `{spec}` y las capacidades reales del
lenguaje). `numbers` puede aportar un patrón que la primera base no ejercita,
sin invertir la prioridad global. Justifica por aspecto qué tomas de cada una.

**EN:** This priority persists across modules and phases until this versioned
policy is explicitly changed. Do not select “the first directory” or replace a
base because it belongs to another phase. They are **references**, not templates:
do not copy content, imports, types, value domains, or obsolete failure
indicators by inertia (e.g. if a base used `-1` or `Natural` while `{spec}`
requires negative integers and `absent`, `{spec}` and verified language
capabilities govern). `numbers` may supply a pattern absent from the first base
without reversing global priority. Explain which aspect comes from each reference.

**ES:** Inspecciona sus fuentes, pruebas, runner, manifiesto y README pertinentes.
Contrasta el idioma real con `docs/ruleset/PARADIGM_FAMILIES.md`,
`docs/ruleset/data/language_characteristics.tsv`,
`docs/ruleset/PSEUDOCODE_CONVENTION.md` y `docs/ruleset/DEVIATION_POLICY.md`.
Lee también la guía de implementación que enlace la especificación, si existe.
No impongas mutabilidad, ausencia, nombres, archivos ni runner de otro lenguaje.
Una incompatibilidad entre reglas y capacidades reales se cita y se reporta
como bloqueo del artefacto afectado; no se resuelve silenciosamente.

**EN:** Inspect relevant sources, tests, runner, manifest and README. Cross-check
actual idiom against the ruleset sources above and any implementation guide
linked by the specification. Never impose another language's mutability,
absence, naming, files or runner. Cite and report incompatible rules and actual
capabilities as a blocker for the affected artefact; never resolve them silently.

**ES:** Si una base falta, no está homologada o es el propio módulo en trabajo,
decláralo y no la uses como antecedente homologado. Usa la otra si basta para el
aspecto requerido; si no basta, reporta el bloqueo. No inventes otra base.

**EN:** If a base is missing, not homologated or is the module being worked on,
declare it and do not use it as homologated precedent. Use the other if sufficient
for the required aspect; otherwise report the blocker. Do not invent a replacement.

## Agrupación por tema e idioma / Topic- and idiom-aware grouping

**ES:** Distingue unidad conceptual, variante de implementación, grupo lógico de
pruebas, archivo físico y runner. Una estructura con varias operaciones no son
varias implementaciones; casos válidos e inválidos no exigen suites separadas.
Identifica las unidades y variantes que realmente pide la especificación; si
`{spec}` define nodos internos propios o exige verificar invariantes internas
cuando `test/` no accede a privados, declara y usa en `4b`–`5` los helpers
mínimos de inspección o paso que `{spec}` autorice como superficie de prueba
(sin contarlos como desviación C6 ni convertirlos en una API pública ajena).

**EN:** Distinguish conceptual unit, implementation variant, logical test group,
physical file and runner. Multiple operations on one structure are not multiple
implementations; valid and invalid cases do not require separate suites.
Identify the units and variants actually required by the specification; if
`{spec}` defines own internal nodes or requires verifying internal invariants
where `test/` cannot access privates, declare and use in `4b`–`5` the minimal
inspection or step helpers authorized by `{spec}` as test surface (without
counting them as a C6 deviation or turning them into an unrequested public API).

**ES:** Agrupa por operación, invariante o escenario. Asigna cada caso a su
contrato y a las variantes aplicables: solo variantes del **mismo contrato**
comparten todos sus casos. No multipliques todos los casos por todas las
funciones de contratos distintos. Mantén los pasos de los escenarios, sus
valores y la trazabilidad de cada caso; agrupar no autoriza añadir ni omitir casos.

**EN:** Group by operation, invariant or scenario. Map every case to its contract
and applicable variants: only variants of the **same contract** share all its
cases. Do not multiply all cases by functions with different contracts.
Preserve scenario steps, values and case traceability; grouping does not authorise
adding or dropping cases.

**ES:** Una suite agregada, varias suites o grupos dentro del mismo archivo son
válidos según el framework y las bases: separación lógica no exige separación
física. Separa variantes iterativa/recursiva cuando el tema lo pida, no en todos
los módulos. No generalices `src/ispec/`, `src/impl/` ni `Test_Runner` de Ada.
Cada caso necesita estado aislado; el runner debe descubrir o agregar **todos**
los grupos y propagar al proceso cualquier fallo.

**EN:** An aggregate suite, separate suites or groups in one file are valid
according to the framework and references: logical separation does not require
physical separation. Separate iterative/recursive variants when required by the
topic, not in every module. Do not generalise Ada's directories or runner.
Each case needs isolated state; the runner must discover or aggregate **all**
groups and propagate any failure to the process.

**ES:** Antes de escribir, declara brevemente en el reporte, sin crear archivos
de planificación: `unidad/variante → casos aplicables → grupo lógico →
archivo/suite → runner`, con referencia y motivo. Usa el agrupamiento existente
si ya está decidido; declara lo aún pendiente, no inventes casos en `scaffold`.
`suite` concreta el mapa; `build` lo enlaza; `correct` corrige solo el artefacto
indicado; `implement`, `fix` y `refactor` lo respetan; `docs-module` lo documenta;
`validate` lo comprueba sin escribir. `docs-language` solo mantiene índices.
No rediseñes artefactos fuera de tu rol y reporta cualquier cambio necesario.

**EN:** Before writing, state briefly in the report, without planning files:
`unit/variant → applicable cases → logical group → file/suite → runner`, with
reference and rationale. Reuse existing grouping; declare pending decisions
without inventing cases during scaffolding. Suite authoring completes the map;
build links it; correction stays within the selected artefact; implementation,
fixing and refactoring preserve it; module documentation describes it; validation
checks without writing. Language documentation only maintains indexes.
Never redesign artefacts outside your role; report required changes.
