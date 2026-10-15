# 🧪 Ciclo de auditoría y `align` / Audit and `align` cycle

**ES:** Este documento es la **norma** del segundo ciclo del monorepo: el que lleva un módulo **ya cerrado a `50/50`** a un estado homogéneo en los 50 lenguajes antes de arrancar el **módulo siguiente**. El primer ciclo —el sprint— vive en [`WORKFLOW.md`](WORKFLOW.md) y no se toca: lo de aquí es una **capa nueva** —la de la idiomaticidad—, con su propio registro, su propio estado y su propio cierre. La convención de los registros, los estados y los criterios vive en [`audits/README.md`](audits/README.md); la escala con la que se clasifica cada implementación, en [`ruleset/IDIOMATICITY_LEVELS.md`](ruleset/IDIOMATICITY_LEVELS.md).

**EN:** This document is the **policy** for the monorepo's second cycle: the one that takes a module **already closed at `50/50`** to a homogeneous state across the 50 languages before the **next module** starts. The first cycle —the sprint— lives in [`WORKFLOW.md`](WORKFLOW.md) and is not touched: what is here is a **new layer** —idiomaticity— with its own record, its own state and its own closure. The record, state and criteria conventions live in [`audits/README.md`](audits/README.md); the scale used to classify each implementation, in [`ruleset/IDIOMATICITY_LEVELS.md`](ruleset/IDIOMATICITY_LEVELS.md).

---

## 🧭 Principios / Principles

**ES:** Cinco reglas gobiernan este ciclo.

1. **El cierre del sprint no se reabre.** El módulo cumple lo establecido, su contador `X/50` no baja y su cierre sigue siendo válido. La auditoría **no** deshace ese cierre: añade una capa que el tooling todavía no verifica.
2. **Una auditoría no corrige nada.** Verifica contra la especificación, el contrato y la escala de niveles, deja la evidencia y planifica el arreglo.
3. **El arreglo es un `align`, un lenguaje cada vez.** Se hace **a mano**: `glot` ejecuta pruebas y captura evidencia, pero no abre ni cierra este ciclo, porque no tiene verbos de auditoría ni de alignment.
4. **El alcance es el módulo, no el lenguaje.** El `align` adecúa el módulo auditado; nunca cambia la convención global del lenguaje ni su andamiaje.
5. **El pase no cierra por lenguajes sueltos.** Cierra cuando **todos** los `align` de ese módulo están integrados y el módulo queda homogéneo —todos en 🟢, o con desviación aceptada por escrito—. Solo entonces se abre el módulo siguiente.

**EN:** Five rules govern this cycle.

1. **The sprint closure is not reopened.** The module meets what was established, its `X/50` counter does not drop and its closure stays valid. The audit does **not** undo that closure: it adds a layer the tooling does not verify yet.
2. **An audit fixes nothing.** It verifies against the specification, the contract and the level scale, records the evidence and plans the fix.
3. **The fix is an `align`, one language at a time.** It is done **by hand**: `glot` runs tests and captures evidence, but it neither opens nor closes this cycle, because it has no audit or alignment verbs.
4. **The scope is the module, not the language.** The `align` brings the audited module into line; it never changes the language's global convention or its scaffolding.
5. **The pass does not close language by language.** It closes once **every** `align` of that module is integrated and the module is homogeneous —all 🟢, or with a written accepted deviation—. Only then does the next module start.

---

## 🌿 Ramas y ámbito / Branches and scope

| Ámbito / Scope | Rama / Branch | Contenido / Content |
|----------------|---------------|---------------------|
| Monorepo | `audit/{fase}/{modulo}` | El registro de auditoría, el estado, la evidencia regenerada y el cierre |
| Submódulo del lenguaje / Language submodule | `align/{fase}/{modulo}` | La adecuación de ese lenguaje, solo si el pase encontró algo |

**ES:** En el submódulo el lenguaje es **implícito**: la misma rama se repite en cada repositorio, sin sufijo de lenguaje, y eso permite alinear solo los que hagan falta. Cada `align` nace del `main` del submódulo —que guarda el estado cerrado del lenguaje— y se integra en ese `main` **antes** de mover el puntero, como manda [`CONTRIBUTING.md`](CONTRIBUTING.md).

**EN:** Inside a submodule the language is **implicit**: the same branch repeats in every repository, with no language suffix, which is what allows aligning only those that need it. Each `align` starts from the submodule's `main` —which holds the language's closed state— and is integrated into that `main` **before** the pointer moves, as [`CONTRIBUTING.md`](CONTRIBUTING.md) requires.

**ES:** `audit` y `align` son **prefijos de ciclo**, declarados en [`CONTRIBUTING.md`](CONTRIBUTING.md); los commits que llevan dentro siguen siendo Conventional Commits (`docs` en el pase, `fix` o `refactor` en el `align`). Como este ciclo no pasa por `glot use`, las ramas se crean a mano:

```bash
git switch -c audit/algorithms/naive-sort              # monorepo
git -C racket switch -c align/algorithms/naive-sort main   # cada submódulo que lo necesite
```

**EN:** `audit` and `align` are **cycle prefixes**, declared in [`CONTRIBUTING.md`](CONTRIBUTING.md); the commits inside them stay Conventional Commits (`docs` in the pass, `fix` or `refactor` in the `align`). Because this cycle does not go through `glot use`, the branches are created by hand.

---

## 🅰️ Fase A — el pase de auditoría / Phase A — the audit pass

**ES:** Se lleva **entero** en la rama `audit/{fase}/{modulo}` del monorepo y **no toca código**. El método reproducible y los criterios están en [`audits/README.md`](audits/README.md); estos son los cinco pasos y lo que deja cada uno. El **encargo** que ejecuta el agente —genérico, y por eso no un encargo de `glot`— está versionado en [`audits/audit.prompt.md`](audits/audit.prompt.md).

**EN:** It runs **entirely** on the monorepo's `audit/{fase}/{module}` branch and **touches no code**. The reproducible method and criteria are in [`audits/README.md`](audits/README.md); these are the five steps and what each leaves. The **request** the agent runs —generic, and therefore not a `glot` request— is versioned in [`audits/audit.prompt.md`](audits/audit.prompt.md).

| # | Paso / Step | Comando / Command | Artefacto / Artefact |
|:-:|-------------|-------------------|----------------------|
| 1 | Barrido léxico | `git -C {lang} ls-files` + `grep` de los patrones prohibidos | Hallazgos por lenguaje (0 invocaciones = limpio) |
| 2 | Lectura de código | Lo que señale el barrido, más constructor, indicador de fallo y aislamiento de tests | Hallazgos clasificados por eje |
| 3 | Ejecución | `glot test {lang} {fase}/{modulo}` | Salida real de la suite por lenguaje |
| 4 | Documentación | README del módulo y comentarios del código | Cumplimiento del criterio de documentación |
| 5 | Estado del árbol | `git -C {lang} status --short` | Lenguajes con cambios locales sin confirmar |

**ES:** El pase deja **tres** artefactos, todos versionados en la misma rama:

- el **registro** `docs/audits/{NN}_Audited_{Modulo}.md`, con los estados 🔴 fallo, 🟡 advertencia, 🔵 aceptado y 🟢 homologado, y el «Plan de cierre»;
- las **filas del estado** en [`ruleset/data/idiomaticity_state.tsv`](ruleset/data/idiomaticity_state.tsv), una por `(lenguaje, módulo)`: nivel, eje bloqueante, desviaciones documentadas y commit verificado;
- el **índice** de [`audits/README.md`](audits/README.md), con el recuento 🟢/🟡/🔴 del módulo.

**EN:** The pass leaves **three** artefacts, all versioned on the same branch: the record, the state rows (one per `(language, module)`) and the record index with the module's 🟢/🟡/🔴 count.

> **ES:** El estado tiene **una sola copia versionada**: [`ruleset/data/idiomaticity_state.tsv`](ruleset/data/idiomaticity_state.tsv). El ciclo lo escribe ahí y en ningún otro sitio; si apareciera otra, la copia buena es esta y la otra se retira.
> **EN:** The state has a **single versioned copy**: [`ruleset/data/idiomaticity_state.tsv`](ruleset/data/idiomaticity_state.tsv). The cycle writes it there and nowhere else; if another one shows up, this is the good one and the other is retired.

> **ES:** Un hallazgo no es una opinión: se clasifica con la lista de verificación binaria por eje de [`ruleset/IDIOMATICITY_LEVELS.md`](ruleset/IDIOMATICITY_LEVELS.md), y el nivel final es el mínimo de los ejes evaluados. Un eje `N/A` no cuenta.
> **EN:** A finding is not an opinion: it is classified with the binary per-axis checklist of [`ruleset/IDIOMATICITY_LEVELS.md`](ruleset/IDIOMATICITY_LEVELS.md), and the final level is the minimum across evaluated axes. An `N/A` axis does not count.

---

## 🅱️ Fase B — el `align` de un lenguaje / Phase B — a language's `align`

**ES:** Se lleva en la rama `align/{fase}/{modulo}` de **ese** submódulo. Es el paso intermedio que deja el módulo en el mismo estado que los demás, no un sprint nuevo.

**EN:** It runs on **that** submodule's `align/{fase}/{module}` branch. It is the intermediate step that leaves the module in the same state as the others, not a new sprint.

| # | Paso / Step | Comando / Command | Artefacto / Artefact |
|:-:|-------------|-------------------|----------------------|
| 1 | Rama | `git -C {lang} switch -c align/{fase}/{modulo} main` | Rama del submódulo |
| 2 | Adecuación | La corrección mínima que pide el hallazgo | Código, comentarios o README del módulo |
| 3 | Verificación | `glot test {lang}` y `glot verify {lang}` | Suite en verde, sin warnings nuevos |
| 4 | Acta | `glot evidence {lang} {fase}/{modulo}` | `docs/evidence/{fase}/{modulo}/{lang}.md` regenerada |
| 5 | README del módulo | [`README_Template.md`](README_Template.md), si el `align` cambió estructura o complejidad | README de Nivel 3 al día |
| 6 | Commit | `fix({fase}): align {modulo} with the audit` + la causa en el cuerpo | Commit del submódulo |
| 7 | Integración y puntero | Merge en el `main` del submódulo; en el monorepo `glot pointer` + `glot save 9` | Gitlink actualizado en la rama `audit/...` |

**ES:** Lo que un `align` **nunca** toca: la especificación del módulo, el pseudocódigo, el contrato de errores de la fase, la suite de pruebas y el andamiaje del lenguaje. Si un hallazgo exige cambiar algo de eso, **no es un `align`**: es rehacer el módulo, y eso se lleva con el ciclo de [`WORKFLOW.md`](WORKFLOW.md) desde una rama del submódulo —ahí sí aplican `4e correct`, `5b fix` y `5c refactor`, con su causa obligatoria—.

**EN:** What an `align` **never** touches: the module specification, the pseudocode, the phase's error contract, the test suite and the language's scaffolding. If a finding requires changing any of that, it is **not an `align`**: it is redoing the module, and that runs with the [`WORKFLOW.md`](WORKFLOW.md) cycle from a submodule branch —where `4e correct`, `5b fix` and `5c refactor` do apply, with their mandatory cause—.

**ES:** El cuerpo del commit cita el registro y el hallazgo, y el acta regenerada es obligatoria: la del cierre del sprint puede estar en rojo o describir un árbol que el `align` ya cambió. El mensaje del `align` **no** está en [`../scripts/data/commits.tsv`](../scripts/data/commits.tsv): este ciclo no tiene pasos de `glot`, así que no hay `save` que lo confirme; el commit lo decide y lo hace el autor.

**EN:** The commit body cites the record and the finding, and a regenerated record is mandatory: the sprint closure's record may be red or describe a tree the `align` has already changed. The `align` message is **not** in [`../scripts/data/commits.tsv`](../scripts/data/commits.tsv): this cycle has no `glot` steps, so there is no `save` to confirm it; the author decides the commit and makes it.

---

## 🅲️ Fase C — sincronización y cierre del pase / Phase C — sync and closing the pass

**ES:** Cuando el **último** `align` del módulo está integrado, en la rama `audit/{fase}/{modulo}`:

1. el **registro** cierra: «Plan de cierre» y «Registro de verificaciones» al día, con fecha, comando y resultado por lenguaje;
2. el **estado** queda con la fecha y el commit de la verificación de cada lenguaje;
3. el **índice** de [`audits/README.md`](audits/README.md) refleja el módulo (por ejemplo `🟢 50 · 🟡 0 · 🔵 0 · 🔴 0`);
4. [`ROADMAP.md`](ROADMAP.md): el módulo **sigue** en su estado y su contador `X/50` —la auditoría no toca el contador del sprint— y la **nota** del módulo nombra la auditoría cerrada con su fecha;
5. [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md): una entrada del pase, con alcance, lenguajes alineados, lenguajes sin cambios y la evidencia.

**EN:** Once the module's **last** `align` is integrated, on the `audit/{phase}/{module}` branch: the record closes (closure plan and verification log up to date, with date, command and result per language); the state keeps each language's verification date and commit; the record index reflects the module (e.g. `🟢 50 · 🟡 0 · 🔴 0`); in [`ROADMAP.md`](ROADMAP.md) the module **keeps** its state and its `X/50` counter —the audit does not touch the sprint counter— and the module's **note** names the closed audit with its date; and [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) gets one entry for the pass, with scope, aligned languages, untouched languages and the evidence.

**ES:** Un módulo no está listo para el siguiente hasta que este cierre existe. El **roadmap no se toca durante el pase**: la nota se escribe al cerrar, que es cuando el estado del módulo deja de estar en discusión.

**EN:** A module is not ready for the next one until this closure exists. **The roadmap is not touched during the pass**: the note is written at closure, which is when the module's state stops being in question.

---

## 🎯 Qué dispara un `align` / What triggers an `align`

**ES:** El `align` **no** se abre por cualquier diferencia: se abre por un hallazgo **🔴 `blocking`** y, si el autor decide pagarlo, por uno **🟠 `structural`**. La severidad no es una opinión —sale del árbol de decisión de [`ruleset/DEVIATION_POLICY.md`](ruleset/DEVIATION_POLICY.md)— y el nivel que produce sale del mínimo de los ejes aplicables de [`ruleset/IDIOMATICITY_LEVELS.md`](ruleset/IDIOMATICITY_LEVELS.md).

**EN:** The `align` is **not** opened for any difference: it is opened for a **🔴 `blocking`** finding and, if the author chooses to pay it, for a **🟠 `structural`** one. Severity is not an opinion —it comes from the decision tree in [`ruleset/DEVIATION_POLICY.md`](ruleset/DEVIATION_POLICY.md)— and the level it produces comes from the minimum over the applicable axes of [`ruleset/IDIOMATICITY_LEVELS.md`](ruleset/IDIOMATICITY_LEVELS.md).

**ES:** Se abre `align` cuando el hallazgo es alguno de estos cuatro:

1. **Complejidad real peor que el techo del módulo.** El costo medido supera el que el módulo permite alcanzar con sus restricciones: $O(n^3)$ donde basta $O(n^2)$ (pasar por `list-ref`/`list-set` en un bucle, el caso medido en Racket), o $O(n \log n)$ declarado sobre un recorrido cuadrático.
2. **Uso de una facilidad que el módulo prohíbe**: la rutina de ordenamiento o de **selección** de la biblioteca estándar en los módulos de ordenamiento, por ejemplo.
3. **Uso sin justificación real**: algo que el lenguaje **no** obliga y que tiene mecanismo nativo equivalente (`unsafe`, `unwrap`, `fatalError`, `init()` como método donde el lenguaje tiene constructor).
4. **Cambio de la semántica observable del contrato**: eso no es una desviación, es un defecto, y se corrige igual.

**EN:** An `align` is opened when the finding is one of these four: measured cost above the module's ceiling; use of a facility the module forbids; use with no real justification when the language offers a native mechanism; or a change in the contract's observable semantics.

| Hallazgo / Finding | Severidad / Severity | Qué se hace / What happens | Quién lo decide / Who decides |
|---|:--:|---|---|
| Complejidad por encima del techo del módulo | 🔴 | `align` | Computer Scientist (veredicto) · Tech Lead (lo abre) |
| Rutina de biblioteca prohibida por el módulo | 🔴 | `align` | Language-Specific SME |
| Mecanismo evitable donde hay nativo | 🔴 | `align` | Language-Specific SME |
| Semántica del contrato alterada | 🔴 | `align` —o sprint, si hay que tocar la especificación— | Tech Lead |
| Mecanismo peligroso aislado, justificado y con plan de retirada | 🟠 | Documentar; `align` solo si el autor lo prioriza | Tech Lead |
| Nombre no idiomático, propiedad frente a método, construcción mejorable | 🟡 | Documentar y bajar el nivel; **sin** `align` | Language-Specific SME |
| Import o mecanismo **obligado** por el lenguaje | 🟢 | Documentar; **sin** `align` | Language-Specific SME |

**ES:** **No** se abre `align` cuando el uso está **obligado por el lenguaje**: importar para poder comparar en los lenguajes funcionales, un `N/A` en un eje que no aplica, o un nombre que **es** el idiomático aunque no lo parezca. Eso es una **desviación aceptada**, no un arreglo: se documenta con su plantilla y severidad 🟢 `informational` o 🟡 `warning`, y el lenguaje no se toca. Un lenguaje sin hallazgo 🔴 **no tiene rama `align`**: su fila queda con el nivel calculado, su commit y su fecha, y el pase sigue. Así el coste se concentra en la deuda real en vez de reescribir 50 módulos para bajar 🟡.

**EN:** **No** `align` is opened when the use is **mandated by the language**: importing to compare in functional languages, an `N/A` axis, or a name that **is** the idiomatic one. That is an **accepted deviation**, not a fix: it is documented with its template and 🟢 `informational` or 🟡 `warning` severity, and the language is left untouched. A language with no 🔴 finding **gets no `align` branch**: its row keeps the computed level, its commit and its date, and the pass moves on.

> **ES:** Un hogar que la política de desviaciones exige **todavía no existe**: `docs/ruleset/idioms/{lang}.md`, la fuente de verdad de una desviación aceptada. Sin él, tu excepción —el uso **obligado por el lenguaje**— no tiene dónde constar y se vuelve a discutir en el pase siguiente. El «cuándo se corrigió» **no** necesita carpeta propia: vive en el registro de verificaciones de este pase y en la fecha y el commit de la fila del estado.
> **EN:** One home required by the deviation policy **does not exist yet**: `docs/ruleset/idioms/{lang}.md`, the source of truth of an accepted deviation. Without it, your exception —the use **mandated by the language**— has nowhere to live and is discussed again in the next pass. The "when it was fixed" **needs no folder of its own**: it lives in this pass's verification log and in the state row's date and commit.

---

## 👥 Quién firma cada paso / Who signs each step

**ES:** El pase y el `align` **no inventan roles**: usan el catálogo de [`AGENT_ROLES.md`](AGENT_ROLES.md), con **un dueño por artefacto**. El perfil es la política de coste del rol en ese paso, no una etiqueta del módulo; los perfiles viven en [`../scripts/data/models.tsv`](../scripts/data/models.tsv).

**EN:** The pass and the `align` **invent no roles**: they use the catalogue in [`AGENT_ROLES.md`](AGENT_ROLES.md), with **one owner per artefact**. The profile is the role's cost policy for that step, not a label of the module; profiles live in [`../scripts/data/models.tsv`](../scripts/data/models.tsv).

| Paso / Step | Rol principal / Principal role | Apoyo / Support | Perfil / Profile | Artefacto / Artefact |
|---|:--|:--|:--:|---|
| A1 Barrido léxico | Language-Specific SME | DevOps / Release Engineer | `economy` | Hallazgos por lenguaje |
| A2 Lectura de código | Language-Specific SME | Senior Software Developer, Computer Scientist | `balanced` | Hallazgos clasificados por eje |
| A2b Complejidad real vs declarada | Computer Scientist | Language-Specific SME | `deep` | Veredicto de complejidad por lenguaje |
| A3 Ejecución de suites | DevOps / Release Engineer | SDET | `economy` | Salida real de la suite |
| A4 Desviaciones y documentación | Technical Writer | Language-Specific SME, Documentation Architect | `economy` | Filas del estado del lenguaje |
| A5 Registro del pase | Technical Writer | Software Architect | `economy` | `docs/audits/{NN}_Audited_{Modulo}.md` |
| A5 Nivel y eje bloqueante | Software Architect | SDET | `balanced` | Filas de `idiomaticity_state.tsv` |
| B Adecuación (`align`) | Senior Software Developer | Language-Specific SME, SDET | `balanced` · `deep` si es estructural | Commit del submódulo |
| B Aceptación de una desviación | Tech Lead (el autor) | Software Architect | — | Fila en `docs/ruleset/idioms/{lang}.md` |
| B Verificación y acta | Validator | SDET, DevOps / Release Engineer | `economy` | `docs/evidence/{fase}/{modulo}/{lang}.md` |
| C Cierre del pase | Technical Product Manager | Documentation Architect | `economy` | Registro, checklist y nota del roadmap |

**ES:** Dos reglas del catálogo que aquí mandan: **un rol reporta lo que no le toca** en vez de arreglarlo —el hallazgo se arregla en el `align`, no en el pase— y **el rol decide el modelo**, no el número del paso. Por eso el pase corre casi entero en `economy`, paga `balanced` en el juicio idiomático y en el cálculo del nivel, y solo paga `deep` cuando el veredicto de complejidad o la representación de la estructura cambian: es el mismo criterio con el que el sprint usa `correct` en `balanced` y `fix`/`refactor` en `deep`.

**EN:** Two rules of the catalogue govern here: **a role reports what is not its job** instead of fixing it —the finding is fixed in the `align`, not in the pass— and **the role picks the model**, not the step number. That is why the pass runs almost entirely on `economy`, pays `balanced` for the idiomatic judgement and the level computation, and pays `deep` only when the complexity verdict or the structure's representation change: the same criterion the sprint uses when it runs `correct` on `balanced` and `fix`/`refactor` on `deep`.

---

## ⛔ Qué no cubre el tooling / What the tooling does not cover

| Pieza / Piece | Hoy / Today |
|---------------|-------------|
| Pasos de auditoría y de `align` | **No existen**: el pase y el `align` son manuales |
| Deshacer un cierre | **No hay verbo**: `close` y `finish` solo suman, así que retirar o rehacer un módulo es `git rm` + editar el contador a mano |
| Portón del puntero | El atajo documentado en [`../scripts/docs/SPRINT.md`](../scripts/docs/SPRINT.md) **lo salta**, y `status`/`doctor` no marcan el gitlink cuya rama no está integrada en el `main` del submódulo |
| Lo que sí se usa | `glot test`, `glot verify`, `glot evidence`, `glot pointer` y `glot save 9`: el mismo sitio de siempre |

**ES:** Mientras estas piezas no existan, este ciclo **no se delega** a `glot`: se lleva con `git` y con evidencia real. Lo que no cambia es la regla de fondo: **nada pasa a 🟢 sin la suite en verde y el acta escrita**.

**EN:** While these pieces do not exist, this cycle is **not delegated** to `glot`: it runs with `git` and real evidence. What does not change is the underlying rule: **nothing goes 🟢 without the suite green and the record written**.

---

## 🔢 Alcance hoy / Scope today

| Módulo / Module | `50/50` | Registro / Record | Estado / State |
|-----------------|:-------:|-------------------|----------------|
| `core.foundations.hello_world` | Sí / Yes | Falta / Missing (`01_Audited_Hello_World.md`) | Por abrir / To open |
| `core.foundations.hello_user` | Sí / Yes | Falta / Missing (`02_Audited_Hello_User.md`) | Por abrir / To open |
| `core.foundations.unit_test_calculator` | Sí / Yes | Falta / Missing (`03_Audited_Unit_Test_Calculator.md`) | Por abrir / To open |
| `core.foundations.numbers` | Sí / Yes | Falta / Missing (`04_Audited_Numbers.md`) | Por abrir / To open |
| `core.algorithms.naive_sort` | Sí / Yes | Escrito / Written (`05_Audited_Naive_Sort.md`, 🟢 50) | Re-verificar y cerrar / Re-verify and close |
| `core.algorithms.data_structures_basics` | Sí / Yes | Falta / Missing (`06_Audited_Data_Structures_Basics.md`) | Pase en curso / Pass in progress (49 filas de estado) |

**ES:** Orden acordado: se termina `06`, se re-verifica y cierra `05` y se abren `01`–`04`; con los seis homogéneos arranca el sprint de `07 data_structures_advanced`.

**EN:** Agreed order: finish `06`, re-verify and close `05`, then open `01`–`04`; with all six homogeneous, the `07 data_structures_advanced` sprint starts.

---

## 🔗 Relación con otras normas / Relation to other policies

| Documento / Document | Qué manda / What it governs |
|----------------------|------------------------------|
| [`audits/README.md`](audits/README.md) | Convención de los registros, estados (fallo, advertencia, aceptado, homologado), criterios y método reproducible |
| [`ruleset/IDIOMATICITY_LEVELS.md`](ruleset/IDIOMATICITY_LEVELS.md) | La escala de 4 niveles y su lista de verificación binaria por eje |
| [`ruleset/DEVIATION_POLICY.md`](ruleset/DEVIATION_POLICY.md) | Cuándo una desviación es aceptable y cómo se documenta |
| [`WORKFLOW.md`](WORKFLOW.md) | El ciclo del sprint: código, pruebas, README y cierre con evidencia |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Ramas —incluidos los prefijos `audit` y `align`—, Conventional Commits y el orden del puntero |
| [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) | Plantilla y registro del cierre |
| [`../AGENTS.md`](../AGENTS.md) | Límites de actuación del agente: qué puede y qué no |
