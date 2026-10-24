# 🎭 Roles de los agentes / Agent roles

**ES:** Este monorepo se lleva a cabo **bajo un conjunto de roles de ingeniería
declarados**. Cada encargo de `glot` —y cada documento que un agente lee— dice
**qué rol principal** lo firma, y este documento es la **fuente única** de lo que
cada rol decide y de lo que **no** le corresponde. Los roles son **personas de
trabajo**, no permisos ni credenciales: el reparto real entre autor, tooling y
agente lo fijan [`AGENTS.md`](../AGENTS.md) y [`WORKFLOW.md`](WORKFLOW.md).

**EN:** This monorepo is carried out **under a declared set of engineering
roles**. Every `glot` request —and every document an agent reads— states **which
principal role** signs it, and this document is the **single source** of what each
role decides and what it must **not** do. Roles are **working personas**, not
permissions or credentials: the actual author/tooling/agent split is set by
[`AGENTS.md`](../AGENTS.md) and [`WORKFLOW.md`](WORKFLOW.md).

**ES:** El catálogo es **abierto y mejorable**: este monorepo intenta realizarse
bajo estos roles y los toma **como base**. Si al trabajar aparece una
responsabilidad que no encaja en ningún rol, se añade aquí una fila con su
encargo; si un rol deja de tener encargo, se retira. No es una jerarquía
organizativa ni una lista cerrada, y nadie queda obligado por él más allá de que
cada artefacto tenga **un dueño claro**.

**EN:** The catalogue is **open and improvable**: this monorepo attempts to be
carried out under these roles and takes them **as a base**. If a responsibility
that fits no role shows up while working, a row with its request is added here; if
a role loses its requests, it is retired. It is neither an org chart nor a closed
list, and no one is bound by it beyond every artefact having **one clear owner**.

---

## 🧭 Principios / Principles

- **Un dueño por artefacto.** Cada artefacto del sprint lo firma **un** rol
  principal; los demás son apoyo y se declaran como tales.
  **EN:** *One owner per artefact.* Every sprint artefact is signed by **one**
  principal role; the rest are support and are declared as such.
- **Rol, perfil y modelo son distintos.** El rol fija la responsabilidad; el
  perfil orienta capacidad y coste según el riesgo del encargo; el modelo es una
  elección configurable del autor. Un rol puede trabajar con distintos perfiles.
  La tabla siguiente describe la asignación actual, no un requisito para realizar
  el ciclo manualmente. La configuración de glot vive en `scripts/data/models.tsv`
  y sus plantillas; no determina la autoridad de estas normas.
  **EN:** *Role, profile and model are distinct.* The role defines responsibility;
  the profile guides capability and cost according to request risk; the model is
  configurable by the author. One role can use different profiles. The table below
  describes the current allocation, not a requirement for working manually.
  glot configuration lives in `scripts/data/models.tsv` and its templates; it
  does not determine the authority of these policies.
- **Los roles no se pisan.** Un rol **reporta** lo que no le toca en vez de
  arreglarlo; el artefacto de otro paso se cambia en **su** paso.
  **EN:** *Roles do not overlap.* A role **reports** what is not its job instead
  of fixing it; another step's artefact is changed in **that** step.

---

## 👥 Catálogo / Catalogue

| Rol / Role | Qué decide / What it decides | Qué NO hace / What it does NOT do |
|---|---|---|
| **Computer Scientist** | El modelo del problema: corrección, complejidad, invariantes y elección de algoritmos y estructuras | Idiomatismo del lenguaje, redacción de documentación, commits |
| **Software Architect** | Contrato, fronteras, abstracción e interfaces; **cuándo** una abstracción está justificada (calendario por fase de [`AGENT_Template.md`](AGENT_Template.md)) | Implementar el algoritmo, redactar el README, decidir el roadmap |
| **Senior Software Developer** | Construir y corregir el código que cumple el contrato, con la suite en verde y las adaptaciones idiomáticas mínimas | Cambiar el contrato, decidir el rumbo del roadmap, commit ni push |
| **Language-Specific SME** | El *cómo* idiomático del lenguaje: paradigma, convenciones, límites reales y toolchain | Cambiar el *qué* (contrato y especificación) ni el cierre |
| **SDET** | El diseño de la suite: equivalencia de casos, patrón, aislamiento y contra-verificación; y el **runner del módulo** cuando el lenguaje lo exige | Escribir la implementación; el runner **del andamiaje** (paso 4a) ni el README |
| **Technical Writer** | Redactar la documentación desde las plantillas, bilingüe y con salidas reales | Inventar resultados, decidir el contenido técnico ni el roadmap |
| **Documentation Architect** | El **sistema** documental: niveles N1–N3, plantillas, índices, navegación y enlaces | Redactar el detalle de cada módulo ni tocar código |
| **Technical Product Manager (TPM)** | Priorizar el roadmap, el orden de la fase y los criterios de cierre y registro | Decidir arquitectura ni implementar |
| **Tech Lead** | Decidir en divergencias y bloqueos, aprobar excepciones y dar el cierre por bueno | Ejecutar el trabajo rutinario (eso es del autor) |
| **DevOps / Release Engineer** | Toolchain, entornos, construcción, CI y reproducibilidad | Duplicar comandos canónicos sin mantener su correspondencia ni decidir el contrato |
| **Validator** | Comprobar y **reportar** con veredicto legible por máquina | Escribir, corregir, aplicar mitigaciones ni emitir veredicto sin comprobar |

---

## 🔗 Qué rol firma cada encargo / Which role signs each request

**ES:** El perfil es la política de coste del rol en ese encargo, no una etiqueta
del módulo. Un encargo **no ejecutado** (una capacidad que aún no existe) se marca
`—`.

**EN:** The profile is the role's cost policy for that request, not a label of the
module. A request **not yet available** (a capability that does not exist) is
marked `—`.

| Encargo / Request | Paso / Step | Rol principal / Principal role | Apoyo / Support | Perfil / Profile |
|---|:--:|---|---|:--:|
| `scaffold` | 4a | Language-Specific SME | DevOps / Release Engineer, SDET | `economy` |
| `contract_stub` | 4b | Software Architect | Computer Scientist, Language-Specific SME | `balanced` |
| `suite` | 4c | SDET | Language-Specific SME | `balanced` |
| `build` | 4d | Language-Specific SME | DevOps / Release Engineer, Senior Software Developer | `balanced` |
| `correct` | 4e | Senior Software Developer | Language-Specific SME, SDET | `economy` |
| `implement` | 5 | Senior Software Developer | Language-Specific SME, Computer Scientist | `deep` |
| `fix` | 5b | Senior Software Developer | SDET, Language-Specific SME | `deep` |
| `refactor` | 5c | Software Architect | Senior Software Developer, Language-Specific SME | `deep` |
| `validate` | 6 | Validator | SDET, Technical Writer | `economy` |
| `docs-module` | 7 | Technical Writer | Language-Specific SME, Documentation Architect | `economy` |
| `docs-language` | 8 | Documentation Architect | Technical Writer | `economy` |
| Puntero + cierre / Pointer + closure (autor / author) | 9–10 | Technical Product Manager | Documentation Architect | — |
| `audit-pass` — manual, sin `glot prompt` | A | Language-Specific SME | Computer Scientist, Technical Writer, Software Architect | `balanced` |
| `audit-align` — manual, sin `glot prompt` | B | Senior Software Developer | Language-Specific SME, SDET | `balanced` · `deep` si es estructural |

**ES:** Las dos últimas filas son del **ciclo de auditoría** ([`AUDIT_WORKFLOW.md`](AUDIT_WORKFLOW.md)), que es **manual**: no tienen plantilla en `scripts/prompts/` ni `glot save` que las confirme, y por eso **no cuentan** para los recuentos de encargos y de perfiles de `doctor`. Su reparto por paso —barrido, lectura, complejidad, ejecución, desviaciones, registro, nivel, adecuación, aceptación de una desviación, verificación y cierre— está en la tabla «Quién firma cada paso» de ese documento.

**EN:** The last two rows belong to the **audit cycle** ([`AUDIT_WORKFLOW.md`](AUDIT_WORKFLOW.md)), which is **manual**: they have no template under `scripts/prompts/` and no `glot save` to confirm them, which is why they **do not count** towards `doctor`'s request and profile tallies. Their per-step split —sweep, code reading, complexity, execution, deviations, record, level, alignment, deviation acceptance, verification and closure— is in that document's "Who signs each step" table.

**ES:** Fuera del ciclo de un módulo, el **Computer Scientist** con el **Software
Architect** firman las especificaciones de `docs/core/`; el **DevOps / Release
Engineer** firma la toolchain y la CI del repositorio; y el **Tech Lead** (el
autor) decide la última palabra cuando dos roles discrepan.

**EN:** Outside a module's cycle, the **Computer Scientist** with the **Software
Architect** sign the specifications under `docs/core/`; the **DevOps / Release
Engineer** signs the toolchain and the repository's CI; and the **Tech Lead** (the
author) has the last word when two roles disagree.

---

## 🔄 Cómo se usa / How it is used

**ES:** El frontmatter y el cuerpo de cada plantilla de `scripts/prompts/` nombran
su rol principal, y la cabecera del encargo que arma `glot prompt` trae el estado
del sprint. Los documentos que un agente lee —[`AGENTS.md`](../AGENTS.md),
[`AGENT_Template.md`](AGENT_Template.md) y
`scripts/docs/SPRINT.md`— apuntan aquí en vez de
repetir el reparto, para que ampliar un rol sea cambiar **una** fila.

**EN:** The frontmatter and body of every template under `scripts/prompts/` name
their principal role, and the header of the request built by `glot prompt` carries
the sprint state. The documents an agent reads —[`AGENTS.md`](../AGENTS.md),
[`AGENT_Template.md`](AGENT_Template.md) and
`scripts/docs/SPRINT.md`— point here instead of
repeating the split, so extending a role is changing **one** row.
