# 🔁 Sprint de módulo / Module sprint

**ES:** Resumen operativo del ciclo de trabajo. La **norma** vive en [`docs/WORKFLOW.md`](../../docs/WORKFLOW.md) y la **regla de Git** en [`docs/CONTRIBUTING.md`](../../docs/CONTRIBUTING.md); este documento dice **qué comando hace cada paso y qué evidencia deja**, y qué versión de `glot` lo cubre ([`ROADMAP.md`](ROADMAP.md)).

**EN:** Operational summary of the work cycle. The **policy** lives in [`docs/WORKFLOW.md`](../../docs/WORKFLOW.md) and the **Git rule** in [`docs/CONTRIBUTING.md`](../../docs/CONTRIBUTING.md); this document states **which command performs each step and what evidence it leaves**, and which `glot` version covers it ([`ROADMAP.md`](ROADMAP.md)).

**ES:** Un *sprint* es el ciclo completo de un módulo: documentación, implementación y verificación de **un** `{lenguaje} + {fase}/{módulo}`, cerrado con evidencia. Dos repositorios, dos ramas, un cierre.

**EN:** A *sprint* is the full cycle of one module: documentation, implementation and verification of **one** `{language} + {phase}/{module}`, closed with evidence. Two repositories, two branches, one closure.

---

## Fase A — en el submódulo del lenguaje / Phase A — inside the language submodule

| # | Paso | Comando | Evidencia / artefacto | Quién |
|:-:|------|---------|-----------------------|-------|
| 1 | Reconocimiento | `git status --short`, `git submodule status`, `glot status` (0.11.0) | — | autor / script |
| 2 | **Situar** | `glot use php algorithms/naive_sort` (0.5.0) | Directorio del módulo, estado `lang/phase/module/branch/spec/repo`, ruta en `stdout` | script |
| 3 | Rama publicada | incluido en `use`: `git push -u origin feat/algorithms/naive-sort` | Rama `feat/{fase}/{módulo}` con upstream | script |
| 4 | Esqueleto y tests | `glot prompt scaffold` (0.8.0) → plantilla local `scaffold-and-unit-tests.prompt.md` · `glot new` (0.9.0) · `glot save` (0.9.0) | `chore(algorithms): add scaffold and tests for naive sort` | **agente** + script |
| 5 | Implementación | `glot prompt implement` (0.8.0) + `glot test` (0.7.0) | `feat(algorithms): add naive sort implementation`; suite en verde | autor / **agente** |
| 6 | Verificación | `glot test`, `glot verify` (0.7.0) · `glot prompt validate` (0.8.0) | Salida real de la suite y del analizador, sin warnings | script + **agente** |
| 7 | Cierre documental del módulo | `glot prompt docs-module` (0.8.0) → README de Nivel 3 desde [`README_Template.md`](../../docs/README_Template.md) | `docs(naive-sort): add README for naive sort module` | **agente** |

**ES:** Al terminar la Fase A, el cambio del submódulo se integra en **su** `main` y se anota el commit resultante.

**EN:** When Phase A ends, the submodule change is integrated into **its** `main` and the resulting commit is noted.

## Fase B — en el monorepo / Phase B — in the monorepo

| # | Paso | Comando | Evidencia / artefacto | Quién |
|:-:|------|---------|-----------------------|-------|
| 8 | Puntero y cierre del lenguaje | `glot pointer` (0.11.0) en rama `chore/{fase}/{módulo}-pointer` · `glot prompt docs-language` (0.8.0) | `chore(submodule): update php pointer`; readmes faltantes e índices N1/N2/N3 | script + **agente** |
| 9 | Registro del cierre | `glot close` (0.10.0) | Entrada en [`ROADMAP_UPDATE_CHECKLIST.md`](../../docs/ROADMAP_UPDATE_CHECKLIST.md) y contador de [`ROADMAP.md`](../../docs/ROADMAP.md) al día | **agente** |

---

## 📋 Plantilla de commit por paso / Commit template per step

**ES:** Convención real del repositorio (Conventional Commits, alcance de fase o módulo):

| Paso | Mensaje |
|------|---------|
| Esqueleto y tests | `chore({fase}): add scaffold and tests for {módulo}` |
| Implementación | `feat({fase}): add {módulo} implementation` |
| README del módulo | `docs({módulo}): add README for {módulo} module` |
| Índices y lenguaje | `docs: add README for {fase} and update indexes` |
| Puntero en el monorepo | `chore(submodule): update {lenguaje} pointer` |
| Cierre del roadmap | `docs(roadmap): close {fase}/{módulo} for {lenguaje}` |

**EN:** Actual repository convention (Conventional Commits, phase or module scope). The scope is the phase for scaffolding and implementation, and the module for its own README.

---

## 🤖 Los pasos con IA, y por qué / The AI-assisted steps, and why

**ES:** Los pasos 4, 5, 7 y 8 se hacen con ayuda del agente porque requieren **leer y comparar** (la especificación contra el código, la plantilla contra el README, el roadmap contra el estado real). `glot` no los ejecuta: los **encarga**. Cada encargo se arma con la plantilla de `.github/prompts` correspondiente y el estado del sprint, y el veredicto se guarda como evidencia. Esas plantillas **no se versionan** (`.gitignore` excluye `.github/prompts/`): son locales del autor y se normalizarán para `glot` en la L4 (v0.8.0).

**EN:** Steps 4, 5, 7 and 8 are done with the agent's help because they require **reading and comparing** (spec against code, template against README, roadmap against the real state). `glot` does not run them: it **requests** them. Each request is built from the matching `.github/prompts` template plus the sprint state, and the verdict is stored as evidence. Those templates are **not versioned** (`.gitignore` excludes `.github/prompts/`): they are local to the author and will be normalised for `glot` in L4 (v0.8.0).

| Encargo previsto | Plantilla (local, no versionada) | Estado |
|------------------|----------------------------------|:------:|
| `scaffold` | `scaffold-and-unit-tests.prompt.md` | ✅ existe |
| `implement` | — | ⏳ por escribir |
| `docs-module` | `module-readme.prompt.md` (a dividir) | ⏳ dividir |
| `docs-language` | idem | ⏳ dividir |
| `validate` | — | ⏳ por escribir |

---

## 🧭 Estado del sprint y dónde vive / Sprint state and where it lives

**ES:** El estado del sprint es el del almacén de `glot` ([`CONTRACT.md`](CONTRACT.md)): `lang`, `phase`, `module`, `branch`, `spec` y `repo`. Cualquier verb que necesite saber «dónde estoy trabajando» lo lee de ahí, no del directorio actual: por eso `glot test` funciona **desde cualquier directorio**.

**EN:** The sprint state is `glot`'s state store ([`CONTRACT.md`](CONTRACT.md)): `lang`, `phase`, `module`, `branch`, `spec` and `repo`. Any verb that needs to know "where am I working" reads it from there, not from the current directory: that is why `glot test` works **from any directory**.

**ES:** Un sprint empieza **siempre** desde el `main` del submódulo, que guarda el estado concluido. La rama `dev` existe en algunos repositorios como legado del flujo anterior y no se usa.

**EN:** A sprint **always** starts from the submodule's `main`, which holds the closed state. The `dev` branch exists in some repositories as a leftover from the previous flow and is not used.
