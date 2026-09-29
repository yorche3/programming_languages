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
- **El rol decide el modelo.** El perfil de modelo de un encargo se elige por el
  **rol** y el riesgo del trabajo, no por el número del paso: razonar sobre
  comportamiento observable exige el modelo profundo; redactar o comprobar, el
  económico. Los perfiles viven en
  [`scripts/data/models.tsv`](../scripts/data/models.tsv); este documento nombra
  el perfil, no el id del modelo.
  **EN:** *The role picks the model.* A request's model profile is chosen by the
  **role** and the work's risk, not by the step number: reasoning about observable
  behaviour needs the deep model; writing or checking, the cheap one. Profiles
  live in [`scripts/data/models.tsv`](../scripts/data/models.tsv); this document
  names the profile, not the model id.
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
| **SDET** | El diseño de la suite: equivalencia de casos, patrón, aislamiento y contra-verificación | Escribir la implementación, el runner del andamiaje ni el README |
| **Technical Writer** | Redactar la documentación desde las plantillas, bilingüe y con salidas reales | Inventar resultados, decidir el contenido técnico ni el roadmap |
| **Documentation Architect** | El **sistema** documental: niveles N1–N3, plantillas, índices, navegación y enlaces | Redactar el detalle de cada módulo ni tocar código |
| **Technical Product Manager (TPM)** | Priorizar el roadmap, el orden de la fase y los criterios de cierre y registro | Decidir arquitectura ni implementar |
| **Tech Lead** | Decidir en divergencias y bloqueos, aprobar excepciones y dar el cierre por bueno | Ejecutar el trabajo rutinario (eso es del autor) |
| **DevOps / Release Engineer** | Toolchain, entornos, construcción, CI y reproducibilidad | Reescribir los comandos del catálogo (se **piden** a `scripts/data/languages.tsv`) ni decidir el contrato |
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
| `scaffold` | 4a | Language-Specific SME | DevOps / Release Engineer, SDET | `balanced` |
| `contract_stub` | 4b | Software Architect | Computer Scientist, Language-Specific SME | `balanced` |
| `suite` | 4c | SDET | Language-Specific SME | `balanced` |
| `correct` | 4d | Senior Software Developer | Language-Specific SME, SDET | `balanced` |
| `implement` | 5 | Senior Software Developer | Language-Specific SME, Computer Scientist | `deep` |
| `fix` | 5b | Senior Software Developer | SDET, Language-Specific SME | `deep` |
| `refactor` | 5c | Software Architect | Senior Software Developer, Language-Specific SME | `deep` |
| `validate` | 6 | Validator | SDET, Technical Writer | `economy` |
| `docs-module` | 7 | Technical Writer | Language-Specific SME, Documentation Architect | `economy` |
| `docs-language` | 8 | Documentation Architect | Technical Writer | `economy` |
| `finish` (puntero + cierre) | 9–10 | Technical Product Manager | Documentation Architect | `economy` |

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
[`scripts/docs/SPRINT.md`](../scripts/docs/SPRINT.md)— apuntan aquí en vez de
repetir el reparto, para que ampliar un rol sea cambiar **una** fila.

**EN:** The frontmatter and body of every template under `scripts/prompts/` name
their principal role, and the header of the request built by `glot prompt` carries
the sprint state. The documents an agent reads —[`AGENTS.md`](../AGENTS.md),
[`AGENT_Template.md`](AGENT_Template.md) and
[`scripts/docs/SPRINT.md`](../scripts/docs/SPRINT.md)— point here instead of
repeating the split, so extending a role is changing **one** row.
