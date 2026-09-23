# 🔁 Sprint de módulo / Module sprint

**ES:** Resumen operativo del ciclo de trabajo. La **norma** vive en [`docs/WORKFLOW.md`](../../docs/WORKFLOW.md) y la **regla de Git** en [`docs/CONTRIBUTING.md`](../../docs/CONTRIBUTING.md); este documento dice **qué comando hace cada paso y qué evidencia deja**, y qué versión de `glot` lo cubre ([`ROADMAP.md`](ROADMAP.md)).

**EN:** Operational summary of the work cycle. The **policy** lives in [`docs/WORKFLOW.md`](../../docs/WORKFLOW.md) and the **Git rule** in [`docs/CONTRIBUTING.md`](../../docs/CONTRIBUTING.md); this document states **which command performs each step and what evidence it leaves**, and which `glot` version covers it ([`ROADMAP.md`](ROADMAP.md)).

**ES:** Un *sprint* es el ciclo completo de un módulo: documentación, implementación y verificación de **un** `{lenguaje} + {fase}/{módulo}`, cerrado con evidencia. Dos repositorios, dos ramas, un cierre.

**EN:** A *sprint* is the full cycle of one module: documentation, implementation and verification of **one** `{language} + {phase}/{module}`, closed with evidence. Two repositories, two branches, one closure.

---

## Fase A — en el submódulo del lenguaje / Phase A — inside the language submodule

| # | Paso | Comando | Evidencia / artefacto | Quién |
|:-:|------|---------|-----------------------|-------|
| 1 | Reconocimiento | `git status --short`, `git submodule status`, `glot progress` (0.6.0), `glot status` (0.12.0) | — | autor / script |
| 2 | **Situar** | `glot use php algorithms/naive_sort` (0.5.0) | Directorio del módulo, estado `lang/phase/module/branch/spec/repo`, ruta en `stdout` | script |
| 3 | Rama publicada | incluido en `use`: `git push -u origin feat/algorithms/naive-sort` | Rama `feat/{fase}/{módulo}` con upstream | script |
| 4a | Esqueleto | `glot new` (0.9.0) · `glot prompt scaffold` (0.9.0) · `glot save 4a` (0.9.0) | Estructura de compilación y de pruebas, sin runners de ejemplo; `.gitignore` verificado | script + **agente** |
| 4b | Suite de pruebas | `glot prompt suite` (0.9.0) · `glot save 4b` (0.9.0) | Suite unitaria derivada de la especificación, con salida real | **agente** |
| 5 | Implementación | `glot prompt implement` (0.8.0) + `glot test` (0.7.0) | `feat(algorithms): add naive sort implementation`; suite en verde | autor / **agente** |
| 6 | Verificación | `glot test`, `glot verify` (0.7.0) · `glot evidence` (0.10.0) · `glot validate` (0.10.0) | Acta en `docs/evidence/{fase}/{módulo}/{lenguaje}.md` con la salida real de la suite y del analizador, sin warnings **nuevos**; y el informe del validador, si se usa | script + **agente** |
| 7 | Cierre documental del módulo | `glot prompt docs-module` (0.8.0) → README de Nivel 3 desde [`README_Template.md`](../../docs/README_Template.md) | `docs(naive-sort): add README for naive sort module` | **agente** |

**ES:** Al terminar la Fase A, el cambio del submódulo se integra en **su** `main` y se anota el commit resultante.

**EN:** When Phase A ends, the submodule change is integrated into **its** `main` and the resulting commit is noted.

## Fase B — en el monorepo / Phase B — in the monorepo

| # | Paso | Comando | Evidencia / artefacto | Quién |
|:-:|------|---------|-----------------------|-------|
| 8 | Puntero y cierre del lenguaje | `glot pointer` (0.12.0) + `glot save 9` (0.12.0) en rama `chore/{fase}/{módulo}-pointer` · `glot prompt docs-language` (0.8.0) | `chore(submodule): update php pointer`; readmes faltantes e índices N1/N2/N3 | script + **agente** |
| 9 | Registro del cierre | `glot close` (0.10.0) + `glot save 10` (0.12.0) | Entrada en [`ROADMAP_UPDATE_CHECKLIST.md`](../../docs/ROADMAP_UPDATE_CHECKLIST.md) y contador de [`ROADMAP.md`](../../docs/ROADMAP.md) al día, a partir del acta de evidencia | script + **agente** |

---

## 📋 Plantilla de commit por paso / Commit template per step

**ES:** Convención real del repositorio (Conventional Commits, alcance de fase o módulo):

| Paso | Mensaje |
|------|---------|
| Esqueleto | `chore({phase}): add scaffold for {module}` |
| Suite de pruebas | `chore({phase}): add suite for {module}` |
| Implementación | `feat({phase}): add {module} implementation` |
| README del módulo | `docs({module}): add README for {module} module` |
| Índices y lenguaje | `docs: add README for {phase} and update indexes` |
| Puntero en el monorepo | `chore(submodule): update {lang} pointer` |
| Cierre del roadmap | `docs(roadmap): close {phase}/{module} for {lang}` |

**ES:** Esta tabla es la fuente de los mensajes y vive **también en datos** ([`scripts/data/commits.tsv`](../../scripts/data/commits.tsv)), que es lo que lee `glot save <paso>`; el harness comprueba la deriva entre las dos. Los marcadores son los mismos del resto del tooling (`{phase}`, `{module}`, `{lang}`), no sus traducciones.

**EN:** This table is the source of the messages and it lives **in data too** ([`scripts/data/commits.tsv`](../../scripts/data/commits.tsv)), which is what `glot save <step>` reads; the harness checks for drift between the two. The placeholders are the same ones used by the rest of the tooling (`{phase}`, `{module}`, `{lang}`), not their translations.

**EN:** Actual repository convention (Conventional Commits, phase or module scope). The scope is the phase for scaffolding and implementation, and the module for its own README.

---

## 🤖 Los pasos con IA, y por qué / The AI-assisted steps, and why

**ES:** Los pasos 4a, 4b, 5, 7 y 8 se hacen con ayuda del agente porque requieren **leer y comparar** (la especificación contra el código, la plantilla contra el README, el roadmap contra el estado real). `glot` no los ejecuta: los **encarga**. Desde la v0.8.0 el encargo lo arma `glot prompt <encargo>` con el estado del sprint, y las plantillas están **versionadas** en [`scripts/prompts/`](../../scripts/prompts/). El banco local de `.github/prompts/` sigue ahí como taller del autor y `glot` lo acepta como respaldo, avisando de que no viaja en el repositorio.

**EN:** Steps 4a, 4b, 5, 7 and 8 are done with the agent's help because they require **reading and comparing** (spec against code, template against README, roadmap against the real state). `glot` does not run them: it **requests** them. Since v0.8.0 the request is built by `glot prompt <request>` from the sprint state, and the templates are **versioned** in [`scripts/prompts/`](../../scripts/prompts/). The local bank in `.github/prompts/` remains the author's workshop and `glot` accepts it as a fallback, warning that it does not travel with the repository.

| Encargo previsto | Plantilla versionada | Paso | Modelo (v0.11.0) |
|------------------|----------------------|:----:|-----------------|
| `scaffold` | [`scaffold.prompt.md`](../../scripts/prompts/scaffold.prompt.md) | 4a | `gpt-5.6-terra` |
| `suite` | [`suite.prompt.md`](../../scripts/prompts/suite.prompt.md) | 4b | `gpt-5.6-terra` |
| `implement` | [`implement.prompt.md`](../../scripts/prompts/implement.prompt.md) | 5 | `claude-sonnet-5` |
| `docs-module` | [`docs-module.prompt.md`](../../scripts/prompts/docs-module.prompt.md) | 7 | `gemini-3.8-flash` |
| `docs-language` | [`docs-language.prompt.md`](../../scripts/prompts/docs-language.prompt.md) | 8 | `gemini-3.8-flash` |
| `validate` | [`validate.prompt.md`](../../scripts/prompts/validate.prompt.md) | 6 | `gemini-3.8-flash` |

**ES:** Desde la v0.11.0 cada plantilla **declara su modelo** en el frontmatter (`model:`, con el id real que ofrece Copilot) y el catálogo [`data/models.tsv`](../../scripts/data/models.tsv) fija el esfuerzo, el tope de créditos y el tier de auto de ese modelo. El **modelo es la clave del perfil**: no hay una clave `profile:` que pueda derivar. Las plantillas siguen siendo **genéricas**: el modelo es política de coste, no dato de un módulo.

**EN:** Since v0.11.0 every template **declares its model** in the frontmatter (`model:`, with the real id Copilot offers) and the [`data/models.tsv`](../../scripts/data/models.tsv) catalogue states the effort, the credit cap and the auto tier for that model. The **model is the profile key**: there is no `profile:` key that could drift. Templates stay **generic**: the model is cost policy, not module data.

**ES:** Las plantillas son **genéricas**: no llevan datos de ningún módulo concreto (ni casos de prueba ni nombres de archivo). Cada encargo **lee** lo que necesita de la especificación del módulo y de los módulos ya homologados del lenguaje; el harness comprueba que ninguna plantilla vuelva a llevar datos de un módulo.

**EN:** The templates are **generic**: they carry no data from any particular module (no test cases, no file names). Each request **reads** what it needs from the module's specification and from the language's already homologated modules; the harness checks that no template carries module data again.

---

## 🧭 Estado del sprint y dónde vive / Sprint state and where it lives

**ES:** El estado del sprint es el del almacén de `glot` ([`CONTRACT.md`](CONTRACT.md)): `lang`, `phase`, `module`, `branch`, `spec` y `repo`. Cualquier verb que necesite saber «dónde estoy trabajando» lo lee de ahí, no del directorio actual: por eso `glot test` funciona **desde cualquier directorio**.

**EN:** The sprint state is `glot`'s state store ([`CONTRACT.md`](CONTRACT.md)): `lang`, `phase`, `module`, `branch`, `spec` and `repo`. Any verb that needs to know "where am I working" reads it from there, not from the current directory: that is why `glot test` works **from any directory**.

**ES:** Un sprint empieza **siempre** desde el `main` del submódulo, que guarda el estado concluido. La rama `dev` existe en algunos repositorios como legado del flujo anterior y no se usa.

**EN:** A sprint **always** starts from the submodule's `main`, which holds the closed state. The `dev` branch exists in some repositories as a leftover from the previous flow and is not used.
