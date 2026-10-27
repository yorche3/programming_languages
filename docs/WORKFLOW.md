# 🔁 Ciclo de trabajo de un módulo / Module work cycle (sprint)

**ES:** Este documento es la **norma** del ciclo con el que se lleva un módulo desde su especificación hasta su cierre con evidencia. Aplica a **todos** los lenguajes homologados, no solo al tooling. Lo que dice [`docs/CONTRIBUTING.md`](CONTRIBUTING.md) sobre Git y submódulos manda sobre este documento; lo que dice [`docs/ROADMAP.md`](ROADMAP.md) sobre contadores y cierre de fase, también.

**EN:** This document is the **policy** for the cycle that takes a module from its specification to its closure with evidence. It applies to **all** standardised languages, not just the tooling. What [`docs/CONTRIBUTING.md`](CONTRIBUTING.md) states about Git and submodules prevails over this document; so does what [`docs/ROADMAP.md`](ROADMAP.md) states about counters and phase closure.

> **ES:** «Sprint» es el nombre coloquial del ciclo: **un** `{lenguaje} + {fase}/{módulo}`, con su documentación, su implementación y su verificación. No es un sprint de calendario: empieza cuando se asigna el trabajo y termina cuando queda registrado el cierre.
> **EN:** "Sprint" is the colloquial name for the cycle: **one** `{language} + {phase}/{module}`, with its documentation, implementation and verification. It is not a calendar sprint: it starts when the work is assigned and ends when the closure is recorded.

---

## 🧭 Principio de partida / Starting principle

**ES:** El ciclo es independiente de herramientas y puede realizarlo el autor
manualmente con Git y el toolchain nativo. glot es una herramienta auxiliar
personal del autor, no un módulo académico ni un requisito del monorepo.
Sus comandos, cuando se mencionan, son atajos equivalentes: no sustituyen estas
normas ni su evidencia. Su documentación permanece separada.

**EN:** The cycle is tool-independent: the author can perform it manually with
Git and the native toolchain. glot is the author's personal helper, not an
academic module or a monorepo requirement. Any commands mentioned are equivalent
shortcuts, not replacements for these policies or their evidence. Its
documentation remains separate.

**ES:** Un sprint empieza **siempre** desde el `main` del submódulo, que guarda el estado concluido del lenguaje, y siempre desde una **especificación existente** en `docs/core/{fase}/`. Si falta la especificación, el sprint no empieza: se escribe antes.

**EN:** A sprint **always** starts from the submodule's `main`, which holds the language's closed state, and always from an **existing specification** in `docs/core/{phase}/`. If the specification is missing, the sprint does not start: it is written first.

---

## 🅰️ Fase A — en el submódulo del lenguaje / Phase A — inside the language submodule

| # | Paso | Objetivo | Artefacto obligatorio |
|:-:|------|----------|-----------------------|
| 1 | Reconocimiento | Saber en qué estado está el repo y el submódulo antes de tocar nada | `git status --short` y `git submodule status` leídos, sin cambios pendientes ajenos al sprint |
| 2 | Asignación | Fijar `{lenguaje}`, `{fase}`, `{módulo}`, la rama y la especificación del sprint | Contexto del trabajo registrado y comprobable (ver «Estado del sprint») |
| 3 | Rama de trabajo | Trabajar aislado, con la rama publicada y su upstream | Rama `{tipo}/{fase}/{módulo}` en minúsculas y `kebab-case`, publicada |
| **4** | Esqueleto: la carpeta | Crear el módulo con las herramientas nativas desde la fase, respetando su directorio de trabajo (atajo: `glot new`) | Carpeta del módulo creada y **confirmada con su commit** (paso `4`) |
| **4a** | Esqueleto: la estructura idiomática | Preparar los artefactos repetibles, copiar plantillas solo si faltan y garantizar `.gitignore` sin truncarlo; completar el runner mínimo cuando haga falta | Estructura idiomática ejecutable sin casos del módulo, con `.gitignore`; **confirmada con su commit** |
| **4b** | Contrato | El tipo nuevo y sus firmas, **antes** de la suite | Contrato |
| **4c** | Suite | Escribir los casos y conectarlos al runner que dejó 4a; si falla por construcción, conservar la suite y reportar el bloqueo | Suite ejecutada: fase roja por aserciones o resultado documentado |
| **4d** | Construcción y enlace *(excepcional)* | Corregir un fallo de construcción no previsto en 4a/4c; no reescribir ni regenerar la suite | Construcción corregida y `glot test` reejecutado sobre los mismos archivos |
| 5 | Implementación | Cumplir el contrato de la especificación | Código verificado por la suite, sin warnings |
| **4e · 5b · 5c** | Corrección y ajuste | Corregir el artefacto previo a implementación (`correct`), reparar la implementación (`fix`) o refactorizar sin cambiar contrato ni cobertura (`refactor`); registrar siempre la causa | Corrección aplicada y verificada en el artefacto correspondiente |
| 6 | Verificación | Tener evidencia real de que cumple | Salida real de la suite y del analizador, copiada sin editar |
| 7 | Cierre documental del módulo | Documentar lo implementado | `README.md` de Nivel 3 generado desde [`README_Template.md`](README_Template.md) |
| 8 | Documentación del lenguaje | Dejar el lenguaje y sus índices al día | `README.md` del lenguaje y los índices de Nivel 1–3 actualizados |
| — | Integración | Que el lenguaje quede en estado concluido | Rama integrada en el `main` del submódulo; commit anotado |

## 🅱️ Fase B — en el monorepo / Phase B — in the monorepo

| # | Paso | Objetivo | Artefacto obligatorio |
|:-:|------|----------|-----------------------|
| **9** | Puntero | Que el monorepo apunte al commit **integrado** | Gitlink revisado y confirmado por el autor (atajos: `glot pointer` y `glot save 9`) |
| **10** | Cierre | Dejar constancia verificable | Entrada en [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) y contador de [`ROADMAP.md`](ROADMAP.md) al día, en el mismo cambio |

**ES:** El puntero se actualiza **después** de integrar en el `main` del submódulo y **antes** de integrar la rama del monorepo. Nunca se apunta a una rama de trabajo no integrada.

**EN:** The pointer is updated **after** integrating into the submodule's `main` and **before** integrating the monorepo branch. It never points to a non-integrated working branch.

---

## 👥 Quién hace cada paso / Who does each step

| Paso | Autor | Tooling opcional / Optional tooling | Agente de IA |
|------|:-----:|:----------------:|:------------:|
| 1 Reconocimiento | decide | informa | — |
| 2–3 Asignación y rama | decide | ejecuta | — |
| 4–4a Esqueleto | ejecuta o revisa | **ejecuta comandos repetibles** | completa si el comando indica análisis pendiente |
| 4b–4c Contrato y suite | revisa | ejecuta | **escribe** |
| 4d Construcción y enlace | revisa | encarga solo si 4c reporta un bloqueo no previsto | **corrige; después se reejecuta la suite existente** |
| 5 Implementación | decide | ejecuta pruebas | **puede escribir** |
| 6 Verificación | valida | ejecuta y captura | **comprueba** |
| 7 README del módulo | valida | encarga | **escribe** |
| 8 Documentación del lenguaje | valida | ejecuta | **escribe la documentación** |
| 9–10 Puntero y cierre | decide | ejecuta | ayuda a redactar el registro |

**ES:** El autor puede realizar cualquier paso o encargarlo expresamente a un
agente. Leer y comparar exige criterio, no obliga a usar IA ni a ejecutar un
agente distinto por rol. El tooling ejecuta comandos y prepara encargos, pero no
toma decisiones técnicas. En 4a, el tooling prepara lo repetible; si falta análisis
idiomático, indica el encargo correspondiente. Commits y publicación corresponden al
autor; el agente no los realiza salvo autorización explícita.

**EN:** The author can perform any step or explicitly assign it to an agent.
Reading and comparing requires judgement, not mandatory AI or a separate agent
per role. Tooling runs commands and prepares requests, not technical decisions.
At 4a, tooling prepares repeatable files and tells the author when
`glot prompt scaffold` is needed for idiomatic analysis. That delegate completes
the minimal runner and language-specific `.gitignore`; it does not introduce
contracts or cases. Commits and publication belong to the author; agents do not
perform them without explicit authorisation.

### Traspasos y bloqueos / Handoffs and blockers

**ES:** Las responsabilidades las fija [`AGENT_ROLES.md`](AGENT_ROLES.md).
Cada entrega cita sus entradas y lo comprobado; el siguiente responsable verifica
lo necesario antes de apoyarse en ella:

**EN:** Responsibilities are defined by the role catalogue. Each delivery cites
its inputs and checks; the next owner verifies what is needed before relying on it:

| Entrega / Delivery | Condición de aceptación / Acceptance condition |
|---|---|
| Contrato / Contract | Operaciones, semántica y representación compatibles con especificación y fase / Operations, semantics and representation match specification and phase |
| Suite y runner / Suite and runner | Mapa unidad/variante → casos → grupo → archivo/suite → runner; aislamiento, todos los grupos ejecutados y fallos propagados / Traceable mapping, isolation, all groups executed and failures propagated |
| Construcción / Build | Compila y enlaza; distingue fallos de infraestructura del rojo esperado / Compiles and links; distinguishes infrastructure failure from expected red tests |
| Implementación / Implementation | Contrato satisfecho sin acomodar suite ni omitir casos / Contract satisfied without tailoring the suite or omitting cases |
| README | Describe código, agrupamiento y evidencia reales / Describes actual code, grouping and evidence |
| Validación / Validation | Separa comprobado, no comprobado y hallazgos que bloquean el cierre / Separates checked, unchecked and closure-blocking findings |

**ES:** Una suite agregada y varias suites son equivalentes si preservan casos,
variantes aplicables y aislamiento; separación lógica no exige archivos separados.
El agrupamiento se decide en la suite y el README lo describe, no lo rediseña.
Ante un conflicto, se reporta `regla/fuente → evidencia → artefacto afectado →
alternativas → decisión pendiente`. Un error de construcción no revierte la suite:
se conserva, se corrige en 4d y se vuelve a ejecutar; no se repite la delegación 4c.
Se detiene solo el artefacto bloqueado;
el autor como Tech Lead decide la excepción o el cambio normativo antes de continuar.
Ni documentar un defecto ni un test verde lo convierten en una desviación aceptada.

**EN:** Aggregate and separate suites are equivalent if they preserve cases,
applicable variants and isolation; logical separation does not require separate
files. Suite authoring decides grouping and the README describes, not redesigns it.
Report conflicts as `rule/source → evidence → affected artefact → alternatives →
pending decision`. Stop only the blocked artefact; the author as Tech Lead decides
the exception or policy change before work resumes. Neither documenting a defect
nor a green test makes it an accepted deviation.

**ES:** El agente que hace el paso **no ejecuta los verbos de delegación** (`glot prompt`, `glot ask`): recibe el encargo ya armado, o lee las fuentes que este declara, y **realiza** el trabajo. Delegar es opcional y tiene dos vías que conviven: el autor puede enviar el encargo a su propio delegado (configurado en su entorno, fuera del repositorio y sin versionar) o el mismo agente del editor lo ejecuta. El reparto no cambia: `glot` orquesta y ejecuta comandos, el agente escribe el artefacto y el autor decide y publica. Los detalles están en [`AGENT_Template.md`](AGENT_Template.md).

**EN:** The agent performing the step **does not run the delegation verbs** (`glot prompt`, `glot ask`): it receives the request already built, or reads the sources the request declares, and **does** the work. Delegating is optional and has two coexisting routes: the author may send the request to their own delegate (configured in their environment, outside the repository and unversioned) or the editor's own agent performs it. The split does not change: `glot` orchestrates and runs commands, the agent writes the artefact and the author decides and publishes. Details are in [`AGENT_Template.md`](AGENT_Template.md).

---

## 🗂️ Estado del sprint / Sprint state

**ES:** El sprint tiene un contexto explícito —lenguaje, fase, módulo, rama,
especificación y ruta del submódulo— que se comprueba antes de cada acción; no
se deduce solo del directorio actual. En trabajo manual se declara en el encargo
y el registro de evidencia. glot puede conservarlo fuera del shell como atajo.

**EN:** A sprint has explicit context —language, phase, module, branch,
specification and submodule path— checked before every action, not inferred
solely from the current directory. Manual work declares it in the request and
evidence record. glot can retain it outside the shell as a shortcut.

---

## 📋 Evidencia y cierre / Evidence and closure

**ES:** Un paso no está hecho hasta que deja su evidencia. La evidencia es la **salida real** del comando, copiada sin editar ni resumir; si un comando no se ha ejecutado, no hay evidencia y el paso sigue abierto.

**EN:** A step is not done until it leaves its evidence. Evidence is the command's **real output**, copied without editing or summarising; if a command has not been run, there is no evidence and the step stays open.

**ES:** Desde la v0.10.0 esa evidencia tiene casa y forma: `glot evidence` ejecuta la suite y el verificador y deja el **acta** en `docs/evidence/{fase}/{módulo}/{lenguaje}.md`, con la fecha, el commit del submódulo que la respalda y la salida real tal cual. El acta se escribe **también cuando algo está en rojo**, porque la evidencia es lo que pasó y no lo que se desea.

**EN:** Since v0.10.0 that evidence has a home and a shape: `glot evidence` runs the suite and the verifier and writes the **record** to `docs/evidence/{phase}/{module}/{language}.md`, with the date, the submodule commit backing it and the real output as is. The record is written **even when something is red**, because evidence is what happened and not what is wished for.

**ES:** Sin glot se registra la misma evidencia en esa ruta: contexto, fecha,
commit verificado, comandos nativos, códigos de salida y salidas reales, incluso
si fallan. Se distingue evidencia de un árbol con cambios pendientes de la de un
commit integrado. La validación revisa contrato y cobertura además de la ejecución;
la evidencia no es una aprobación y el cierre lo decide el autor.

**EN:** Without glot, record equivalent evidence at that path: context, date,
verified commit, native commands, exit codes and actual output, including failures.
Distinguish a dirty worktree run from evidence of an integrated commit.
Validation reviews contract and coverage as well as execution; evidence is not
approval and the author decides closure.

1. **Cierre del módulo:** código + pruebas ejecutadas + README de Nivel 3 + entrada en [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) + actualización de [`ROADMAP.md`](ROADMAP.md), **en el mismo cambio**.
2. **Cierre de fase:** solo cuando **todos** los módulos requeridos cumplen el ciclo completo. Un README no cierra un módulo, y un módulo no cierra una fase.
3. **Nada se marca `✅` sin evidencia verificable.**

---

## 🤖 CI por submódulo / CI per submodule

**ES:** La CI debe usar el mismo comando nativo verificado que el autor y declarar
su directorio de trabajo, toolchain y versiones. Si se elige glot, **el comando de la CI no se copia del catálogo, se le pide al catálogo**:
`glot test` ejecuta la suite y `glot verify` el lint idiomático. Sin glot, el
workflow llama al comando nativo mantenido con la configuración del módulo y
documentado en su README. Ninguna vía permite divergencias silenciosas.

**EN:** CI must use the same verified native command as the author and declare
its working directory, toolchain and versions. When using glot, ask the catalogue
for the command rather than copying it: `glot test` runs the suite and `glot verify`
runs idiomatic lint. Without glot, call the native command maintained with module
configuration and documented in its README. Neither route allows silent drift.

**ES:** Dónde vive cada CI:

- **La CI del ciclo vive en el monorepo** (`.github/workflows/`), donde puede contrastar especificaciones, roadmap y evidencia con los submódulos.
- **El disparador del monorepo es el puntero del submódulo**: un push dentro del submódulo no se ve desde el monorepo. Para comprobar cada commit puede haber CI nativa en el submódulo, sin dependencia obligatoria de glot. Si el autor elige usarlo allí, debe proporcionar la herramienta y sus datos versionados.
- **La CI del tooling** (`scripts/`) también vive en el monorepo, y es la que ya existe: el análisis estático de `scripts/**`. Es **CI del repositorio**, no el verbo `verify`: desde la v1.4.0 `verify` está declarado *lint* y el **análisis estático de seguridad es un no-objetivo suyo**, lo que no impide que el repositorio tenga su propio SAST.

**EN:** Where each CI lives:

- **The cycle's CI lives in the monorepo** (`.github/workflows/`), where it can cross-check specifications, roadmap and evidence against submodules.
- **The monorepo's trigger is the submodule pointer**: a submodule push is not seen by the monorepo. Native submodule CI can check every commit without requiring glot. If the author chooses to use it there, provide the tool and its versioned data.
- **The tooling CI** (`scripts/`) also lives in the monorepo, and it is the one that exists today: static analysis of `scripts/**`. It is **repository CI**, not the `verify` verb: since v1.4.0 `verify` is declared *lint* and **static security analysis is an explicit non-goal of it**, which does not stop the repository from having its own SAST.

**ES:** Convivencia con el acta: **la CI comprueba y no firma; el acta la firma el autor**.
`docs/evidence/` conserva la salida real y el commit verificado; la CI deja su
propio registro, **no escribe** el acta ni autoriza el cierre. Si divergen, se
comparan commit, árbol de trabajo, comandos, versiones, entorno y resultados.
La procedencia no decide cuál es correcto: se registra la causa, se corrige y
se repite la comprobación afectada antes del cierre. Un acta verde no demuestra
por sí sola cobertura completa.

**ES:** Lo que la CI **no** hace: no instala toolchains del roadmap (eso es L9 y es del autor), no crea ni publica ramas, no fusiona, no sustituye a `close` y no es la puerta del cierre: la puerta es la evidencia del autor.

**EN:** **CI checks and does not sign; the author signs the record**.
`docs/evidence/` retains actual output and the verified commit; CI keeps its own
log, does not write the record and does not authorise closure. If they diverge,
compare commit, worktree, commands, versions, environment and results. Provenance
does not decide which is correct: record the cause, fix it and repeat the affected
check before closure. A green record alone does not prove complete coverage.

**EN:** What CI does **not** do: it does not install roadmap toolchains (that is L9 and the author's job), it does not create or publish branches, it does not merge, it does not replace `close` and it is not the closing gate: the gate is the author's evidence.

**ES:** La antigua **excepción declarada**, `ada/.github/workflows/tests.yml`,
usa comandos nativos (`alr build` y `alr -C tests run`). No exige migrar a glot:
al revisar el módulo se contrasta su equivalencia con el README y la evidencia.
Los workflows nuevos siguen el mismo criterio de reproducibilidad.

**EN:** The former **declared exception**, `ada/.github/workflows/tests.yml`,
uses native commands (`alr build` and `alr -C tests run`). No migration to glot
is required: review equivalence against the README and evidence when reviewing
the module. New workflows follow the same reproducibility criterion.

---

## ✅ Validación de la documentación / Documentation validation

**ES:** Antes de cerrar un paso se comprueba el artefacto que ese paso produce. Cada punto se marca `Sí`, `No` (con motivo) o `No aplica` (con motivo); un `No` sin motivo es un incumplimiento. Esta sección comprueba lo que otras normas mandan, no lo repite.

**EN:** Before closing a step, the artefact that step produces is checked. Each point is marked `Sí`, `No` (with a reason) or `No aplica` (with a reason); an unexplained `No` is a breach. This section checks what other policies mandate, it does not repeat them.

### Especificación / Specification — `docs/core/{fase}/{NN}_{Modulo}.md`

- [ ] **Objetivo y enunciado** bilingües, con lo que el módulo **no** es.
- [ ] **Una fila por operación** con representación interna, operaciones clave y valor de fallo.
- [ ] **Pseudocódigo completo**: cubre **todas** las operaciones de la tabla, sin `…` ni «etc.».
- [ ] **Política donde hay ambigüedad**: orden de inserción, hueco vacío, qué devuelve una búsqueda, dirección de un grafo. Si falta, la especificación lo marca «pendiente de definir».
- [ ] **Casos de prueba** con salida esperada, incluidos los de límite (vacío, lleno) y fallo.
- [ ] **Criterios de aceptación** verificables y alineados con la fase, que incluyan el README y el acta de evidencia.
- [ ] **Cláusula de adaptación**: qué hacer cuando el lenguaje no puede cumplir el pseudocódigo (ver [`AGENT_Template.md`](AGENT_Template.md)).
- [ ] **Ubicación esperada** contrastada con [`core/00_Project_Initialization_Guide.md`](core/00_Project_Initialization_Guide.md).

### README de módulo-lenguaje / Per-language module README

- [ ] Sigue [`README_Template.md`](README_Template.md): **todas** sus secciones obligatorias están, o llevan `No aplica` con motivo.
- [ ] Salidas de compilación y pruebas **reales**, coincidentes con el acta de evidencia.
- [ ] Una fila por operación en _Algoritmos y operaciones_ y en _Indicadores de fallo_.
- [ ] Una fila por caso de la especificación en _Cobertura de pruebas_, con `Omitido` y razón cuando no sea representable.
- [ ] Cada desviación del pseudocódigo o de la ubicación esperada tiene su fila en _Adaptaciones idiomáticas_.
- [ ] Bilingüe, con enlaces relativos que resuelven y sin rutas absolutas del autor ni credenciales.

### Submódulo del lenguaje / Language submodule

- [ ] Código y tests en la ubicación que declara la especificación, o con la desviación documentada.
- [ ] Suite nativa ejecutada con el comando documentado del módulo y evidencia escrita en `docs/evidence/`; si se usa catálogo, comprobar su equivalencia.
- [ ] Artefactos generados ignorados en `.gitignore`; el árbol queda limpio entre pasos.
- [ ] READMEs de Nivel 1 y 2 con el módulo listado.
- [ ] Puntero del monorepo apuntando a un commit **integrado** en el `main` del submódulo.

### Cuándo se aplica / When it applies

| Momento / Moment | Qué se comprueba / What is checked |
|---|---|
| Antes de implementar un módulo / Before implementing | La especificación, y con ella su cláusula de adaptación |
| Al cerrar un módulo en un lenguaje / Closing a module | README del módulo y submódulo, más el acta de evidencia |
| Al revisar un README ya escrito / Reviewing an existing README | El README, alineándolo con la plantilla vigente |
| Al auditar un módulo homologado / Auditing a homologated module | Los criterios de [`audits/README.md`](audits/README.md) |

**ES:** Este checklist **no** invalida los READMEs escritos antes de la plantilla vigente: se alinean al revisarlos, y esa deuda se anota en la auditoría del módulo.

**EN:** This checklist does **not** invalidate READMEs written before the current template: they are brought in line when reviewed and that debt is noted in the module's audit.

---

## ✅ Definition of Done del sprint / Sprint Definition of Done

- [ ] Reconocimiento hecho: `git status --short` y `git submodule status` leídos.
- [ ] Sprint asignado: lenguaje, fase, módulo, rama y especificación registrados.
- [ ] Rama `{tipo}/{fase}/{módulo}` publicada con su upstream.
- [ ] Esqueleto y `.gitignore` del módulo puestos, sin `main` de ejemplo si el módulo es una biblioteca.
- [ ] Suite ejecutada con salida real; sin warnings ni errores.
- [ ] Acta de evidencia con la suite en verde, escrita manualmente o con `glot evidence`, con contexto, commit, comandos y resultados verificables.
- [ ] Divergencias respecto al pseudocódigo clasificadas como idiomáticas (documentadas) o como defecto (reportadas).
- [ ] README de Nivel 3 generado desde la plantilla, bilingüe y con salidas reales.
- [ ] Índices de Nivel 1–3 actualizados (o creados si faltaban).
- [ ] Integrado en el `main` del submódulo.
- [ ] Puntero del submódulo actualizado en el monorepo.
- [ ] Entrada en el checklist y contador del roadmap al día.
- [ ] `git diff --check` sin errores.
- [ ] Sin `push` ni `commit` hechos por el agente sin autorización explícita.

---

## 🧪 Después del sprint: la auditoría / After the sprint: the audit

**ES:** Un módulo que cierra a `50/50` no se da por homogéneo: entra en el **segundo ciclo**, el de la auditoría, que verifica la capa de idiomaticidad y devuelve al mismo estado a los lenguajes que se hayan desviado antes de arrancar el **módulo siguiente**. Ese ciclo tiene su propia norma —[`AUDIT_WORKFLOW.md`](AUDIT_WORKFLOW.md), con las ramas `audit/{fase}/{módulo}` y `align/{fase}/{módulo}`— y **no reabre** el cierre del sprint: son dos capas, con registros y estados distintos.

**EN:** A module that closes at `50/50` is not taken as homogeneous yet: it enters the **second cycle**, the audit, which verifies the idiomaticity layer and brings any deviating languages back to the same state before the **next module** starts. That cycle has its own policy —[`AUDIT_WORKFLOW.md`](AUDIT_WORKFLOW.md), with the `audit/{phase}/{module}` and `align/{phase}/{module}` branches— and it does **not reopen** the sprint closure: they are two layers, with different records and states.

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
| [`AUDIT_WORKFLOW.md`](AUDIT_WORKFLOW.md) | El segundo ciclo: la auditoría del módulo cerrado y el `align` por lenguaje |
