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
| 2 | Asignación | Fijar `{lenguaje}`, `{fase}`, `{módulo}`, la rama y la especificación del sprint; `use` **crea la carpeta del módulo y deja al autor dentro de ella** | Estado del sprint registrado fuera del shell (ver «Estado del sprint») |
| 3 | Rama de trabajo | Trabajar aislado, con la rama publicada y su upstream | Rama `{tipo}/{fase}/{módulo}` en minúsculas y `kebab-case`, publicada |
| 4 | Esqueleto, contrato y pruebas | Dejar el andamiaje (**4a**), el **contrato** (**4b**) y la suite (**4c**), **sin implementar**. El andamiaje sale de la **secuencia** del lenguaje ([`scripts/data/init_sequences.tsv`](../scripts/data/init_sequences.tsv): pasos, directorio de trabajo y completado); el contrato (tipo nuevo y firmas) es un artefacto propio y va **antes** de la suite | Estructura del lenguaje + contrato + suite que falla por falta de implementación (o pasa si el módulo es solo documental) |
| 5 | Implementación | Cumplir el contrato de la especificación | Código verificado por la suite, sin warnings |
| 6 | Verificación | Tener evidencia real de que cumple | Salida real de la suite y del analizador, copiada sin editar |
| 7 | Cierre documental del módulo | Documentar lo implementado | `README.md` de Nivel 3 generado desde [`README_Template.md`](README_Template.md) |
| — | Integración | Que el lenguaje quede en estado concluido | Rama integrada en el `main` del submódulo; commit anotado |

## 🅱️ Fase B — en el monorepo / Phase B — in the monorepo

| # | Paso | Objetivo | Artefacto obligatorio |
|:-:|------|----------|-----------------------|
| 8 | Puntero y cierre del lenguaje | Que el monorepo apunte al commit integrado y que el lenguaje quede cerrado | `glot pointer` deja la rama `chore/{fase}/{módulo}-pointer` preparada y publicada, con el gitlink añadido, y `glot save 9` la confirma; readmes faltantes e índices de Nivel 1–3 al día |
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

**ES:** Los pasos 4a (esqueleto), 4b (contrato), 4c (suite), 5, 7 y 8 usan IA porque exigen **leer y comparar** (especificación contra código, plantilla contra README, roadmap contra el estado real). El encargo lo arma `glot prompt <encargo>` con las plantillas **versionadas** de [`scripts/prompts/`](../scripts/prompts/); el banco local de `.github/prompts/` (que `.gitignore` excluye) se acepta como respaldo, con aviso. El agente **nunca** ejecuta `git add`, `git commit` ni `git push`: eso lo decide y lo hace el autor.

**EN:** Steps 4a (scaffold), 4b (contract), 4c (suite), 5, 7 and 8 use AI because they require **reading and comparing** (spec against code, template against README, roadmap against the real state). The request is built by `glot prompt <request>` from the **versioned** templates in [`scripts/prompts/`](../scripts/prompts/); the local bank in `.github/prompts/` (excluded by `.gitignore`) is accepted as a fallback, with a warning. The agent **never** runs `git add`, `git commit` or `git push`: the author decides and does that.

**ES:** El agente que hace el paso **no ejecuta los verbos de delegación** (`glot prompt`, `glot ask`): recibe el encargo ya armado, o lee las fuentes que este declara, y **realiza** el trabajo. Delegar es opcional y tiene dos vías que conviven: el autor puede enviar el encargo a su propio delegado (configurado en su entorno, fuera del repositorio y sin versionar) o el mismo agente del editor lo ejecuta. El reparto no cambia: `glot` orquesta y ejecuta comandos, el agente escribe el artefacto y el autor decide y publica. Los detalles están en [`AGENT_Template.md`](AGENT_Template.md).

**EN:** The agent performing the step **does not run the delegation verbs** (`glot prompt`, `glot ask`): it receives the request already built, or reads the sources the request declares, and **does** the work. Delegating is optional and has two coexisting routes: the author may send the request to their own delegate (configured in their environment, outside the repository and unversioned) or the editor's own agent performs it. The split does not change: `glot` orchestrates and runs commands, the agent writes the artefact and the author decides and publishes. Details are in [`AGENT_Template.md`](AGENT_Template.md).

---

## 🗂️ Estado del sprint / Sprint state

**ES:** El sprint tiene un estado explícito —lenguaje, fase, módulo, rama, especificación y ruta del submódulo— que **no** se deduce del directorio actual. Se guarda fuera del shell (almacén de estado de `glot`, ver [`scripts/docs/CONTRACT.md`](../scripts/docs/CONTRACT.md)) para que cualquier comando posterior —ejecutar pruebas, encargar documentación, capturar evidencia— funcione **desde cualquier directorio** y para el mismo módulo.

**EN:** A sprint has explicit state —language, phase, module, branch, specification and submodule path— which is **not** inferred from the current directory. It is stored outside the shell (`glot`'s state store, see [`scripts/docs/CONTRACT.md`](../scripts/docs/CONTRACT.md)) so that any later command —running tests, requesting documentation, capturing evidence— works **from any directory** and for the same module.

---

## 📋 Evidencia y cierre / Evidence and closure

**ES:** Un paso no está hecho hasta que deja su evidencia. La evidencia es la **salida real** del comando, copiada sin editar ni resumir; si un comando no se ha ejecutado, no hay evidencia y el paso sigue abierto.

**EN:** A step is not done until it leaves its evidence. Evidence is the command's **real output**, copied without editing or summarising; if a command has not been run, there is no evidence and the step stays open.

**ES:** Desde la v0.10.0 esa evidencia tiene casa y forma: `glot evidence` ejecuta la suite y el verificador y deja el **acta** en `docs/evidence/{fase}/{módulo}/{lenguaje}.md`, con la fecha, el commit del submódulo que la respalda y la salida real tal cual. El acta se escribe **también cuando algo está en rojo**, porque la evidencia es lo que pasó y no lo que se desea.

**EN:** Since v0.10.0 that evidence has a home and a shape: `glot evidence` runs the suite and the verifier and writes the **record** to `docs/evidence/{phase}/{module}/{language}.md`, with the date, the submodule commit backing it and the real output as is. The record is written **even when something is red**, because evidence is what happened and not what is wished for.

1. **Cierre del módulo:** código + pruebas ejecutadas + README de Nivel 3 + entrada en [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) + actualización de [`ROADMAP.md`](ROADMAP.md), **en el mismo cambio**.
2. **Cierre de fase:** solo cuando **todos** los módulos requeridos cumplen el ciclo completo. Un README no cierra un módulo, y un módulo no cierra una fase.
3. **Nada se marca `✅` sin evidencia verificable.**

---

## 🤖 CI por submódulo / CI per submodule

**ES:** La decisión está tomada **antes de escribir ningún workflow**: **el comando de la CI no se copia del catálogo, se le pide al catálogo**. Un workflow que repite `alr build` o `pytest -q` crea una **segunda verdad** que envejece en silencio —cambia el catálogo y el workflow no—, así que la CI llama a los mismos verbos que usan el autor y el harness: `glot test` (la suite, con el comando nativo del lenguaje) y `glot verify` (el lint idiomático). El workflow declara la **versión** de la herramienta, no la implementación del comando.

**EN:** The decision is taken **before any workflow is written**: **the CI command is not copied from the catalogue, it is asked of the catalogue**. A workflow repeating `alr build` or `pytest -q` creates a **second truth** that ages in silence —the catalogue changes and the workflow does not—, so CI calls the same verbs the author and the harness use: `glot test` (the suite, with the language's native command) and `glot verify` (the idiomatic lint). The workflow declares the tool **version**, not the command's implementation.

**ES:** Dónde vive cada CI:

- **La CI del ciclo vive en el monorepo** (`.github/workflows/`), porque es el único sitio que tiene a la vez `glot`, su catálogo, las especificaciones, el roadmap y `docs/evidence/`. Un submódulo es un repositorio aparte: no tiene `scripts/`, así que una CI allí solo podría comprobar su lenguaje **copiando** el comando.
- **El disparador del monorepo es el puntero del submódulo**: un push dentro del submódulo no se ve desde el monorepo, así que esa CI comprueba **cuando el módulo entra** (paso 9, `pointer`) y a mano (`workflow_dispatch`). Quien quiera la comprobación en **cada** commit del submódulo tiene que llevar allí la CI, y entonces el paso previo obligatorio es **traer `glot`** (clon superficial del monorepo, o el script con su catálogo) y llamarlo; **nunca** reescribir el comando.
- **La CI del tooling** (`scripts/`) también vive en el monorepo, y es la que ya existe: el análisis estático de `scripts/**`. Es **CI del repositorio**, no el verbo `verify`: desde la v1.4.0 `verify` está declarado *lint* y el **análisis estático de seguridad es un no-objetivo suyo**, lo que no impide que el repositorio tenga su propio SAST.

**EN:** Where each CI lives:

- **The cycle's CI lives in the monorepo** (`.github/workflows/`), because it is the only place holding `glot`, its catalogue, the specifications, the roadmap and `docs/evidence/` at once. A submodule is a repository of its own: it has no `scripts/`, so a CI there could only check its language by **copying** the command.
- **The monorepo's trigger is the submodule pointer**: a push inside the submodule is not seen from the monorepo, so that CI checks **when the module comes in** (step 9, `pointer`) and by hand (`workflow_dispatch`). Whoever wants the check on **every** submodule commit has to move CI there, and then the mandatory previous step is **fetching `glot`** (a shallow clone of the monorepo, or the script with its catalogue) and calling it; **never** rewriting the command.
- **The tooling CI** (`scripts/`) also lives in the monorepo, and it is the one that exists today: static analysis of `scripts/**`. It is **repository CI**, not the `verify` verb: since v1.4.0 `verify` is declared *lint* and **static security analysis is an explicit non-goal of it**, which does not stop the repository from having its own SAST.

**ES:** Convivencia con el acta, en una frase: **la CI comprueba y no firma; el acta la firma el autor**. `docs/evidence/` es un artefacto versionado con la salida real de la máquina del autor y el commit del submódulo que la respalda —es lo que cierra un módulo—, mientras que la CI deja su salida en su propio registro. Por eso la CI **no escribe** en `docs/evidence/` ni confirma nada: un acta escrita desde la CI sería un acta sin autor, y `close` exige el acta con su commit. Las dos dicen lo mismo por caminos distintos; si divergen, manda el acta y lo que está mal configurado es la CI.

**ES:** Lo que la CI **no** hace: no instala toolchains del roadmap (eso es L9 y es del autor), no crea ni publica ramas, no fusiona, no sustituye a `close` y no es la puerta del cierre: la puerta es la evidencia del autor.

**EN:** Living with the record, in one sentence: **CI checks and does not sign; the author signs the record**. `docs/evidence/` is a versioned artefact with the author's machine's real output and the submodule commit backing it —it is what closes a module—, while CI leaves its output in its own log. That is why CI **does not write** to `docs/evidence/` nor commit anything: a record written from CI would be a record without an author, and `close` demands the record with its commit. Both say the same thing along different paths; if they diverge, the record wins and the misconfigured part is the CI.

**EN:** What CI does **not** do: it does not install roadmap toolchains (that is L9 and the author's job), it does not create or publish branches, it does not merge, it does not replace `close` and it is not the closing gate: the gate is the author's evidence.

**ES:** Lo que ya existe se alinea con esta política: `ada/.github/workflows/tests.yml` **copia** hoy sus dos comandos (`alr build` y `alr -C tests run`), así que queda como **excepción declarada** —se conserva porque funciona y se alinea al catálogo (`glot test`) cuando ese submódulo cierre su siguiente módulo—, y los workflows nuevos se escriben ya con la regla.

**EN:** What already exists is aligned with this policy: `ada/.github/workflows/tests.yml` **copies** its two commands today (`alr build` and `alr -C tests run`), so it stands as a **declared exception** —kept because it works and aligned with the catalogue (`glot test`) when that submodule closes its next module—, and new workflows are written with the rule already in place.

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
- [ ] Suite nativa ejecutada con el comando del catálogo y evidencia escrita en `docs/evidence/`.
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
- [ ] Acta de evidencia escrita con `glot evidence`, con la suite en verde (desde la v0.10.0).
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
