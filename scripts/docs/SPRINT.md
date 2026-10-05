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
| 2 | **Situar** | `glot use php algorithms/naive_sort` (0.5.0) | Directorio del módulo **creado**; la capa cargable deja al autor en la **carpeta de la fase** —el andamiaje del `4a` arranca ahí— y desde ahí funcionan `git`, `glot test`, `save` y `pointer`; estado `lang/phase/module/branch/spec/repo` | script |
| 3 | Rama publicada | incluido en `use`: `git push -u origin feat/algorithms/naive-sort` | Rama `feat/{fase}/{módulo}` con upstream | script |
| 4a | Esqueleto | `glot new` (0.9.0; secuencia desde la 1.1.0) · `glot prompt scaffold` (0.9.0) · `glot save 4a` (0.9.0) | Estructura de compilación y de pruebas según la **secuencia** del dato [`data/init_sequences.tsv`](../data/init_sequences.tsv) (pasos, directorio de trabajo y completado) y con el **runner arrancando sin casos** —el runner es de este paso—, sin ejecutables de ejemplo; `.gitignore` verificado. **`new` baja al autor al directorio del módulo** (con la capa cargable) | script + **agente** |
| 4b | **Contrato y esqueletos** (artefacto propio, antes de la suite) | `glot prompt contract_stub` (1.5.0) · `glot save 4b` (1.1.0) | Tipo nuevo, firmas del contrato (en Ada, `src/*.ads`) y **esqueleto de cada operación** (en Ada, `src/*.adb`), con el **indicador natural** del lenguaje: sin el cuerpo, la suite no compila **ni enlaza** | **agente** |
| 4c | Suite de pruebas | `glot prompt suite` (0.9.0) · `glot save 4c` (1.1.0) | Suite unitaria derivada de la especificación, **sobre el contrato y sus esqueletos del paso 4b** (no los declara: los usa) y **sin crear el runner**, que es del 4a: si falta o no arranca, se detiene. Con salida real. Desde la v1.5.0 el `4b` deja el cuerpo vacío, así que compila **y enlaza**; si el contrato llegara **sin esqueletos**, se admite la **compilación sin enlace** y la ejecución se traslada al acta del paso 6, pero eso es un **defecto del `4b`**, no del contrato | **agente** |
| 4d | **Corrección previa a la implementación** (un artefacto `4a`/`4b`/`4c` confirmado resultó defectuoso) | `glot prompt correct` (1.6.0) · `glot save 4d` (1.6.0) | El artefacto corregido y la **causa en el cuerpo del commit** (obligatoria): el registro del retrabajo. Solo artefactos **anteriores** a la implementación | **agente** |
| 5 | Implementación | `glot prompt implement` (0.8.0) + `glot test` (0.7.0) · `glot save 5` (0.9.0) | `feat(algorithms): add naive sort implementation`; suite en verde | autor / **agente** |
| 5b | **Defecto de la implementación** (un test en rojo, un criterio incumplido) | `glot prompt fix` (1.6.0) · `glot save 5b` (1.6.0) | El defecto corregido y la **causa** en el commit (obligatoria); el paso 6 se repite | **agente** |
| 5c | **Reelaboración** sin cambio de comportamiento | `glot prompt refactor` (1.6.0) · `glot save 5c` (1.6.0) | La forma reelaborada y el **motivo** en el commit (obligatorio); suite verde antes y después, sin tocarla | **agente** |
| 6 | Verificación | `glot test`, `glot verify` (0.7.0) · `glot evidence` (0.10.0) · `glot validate` (0.10.0) — **sin commit propio**: el acta entra en el monorepo con `save 10` | Acta en `docs/evidence/{fase}/{módulo}/{lenguaje}.md` con la salida real de la suite y del analizador, sin warnings **nuevos**; y el informe del validador, si se usa | script + **agente** |
| 7 | Cierre documental del módulo | `glot prompt docs-module` (0.8.0; alcance **solo N3** desde la 1.6.0) · `glot save 7` (0.9.0) → README de Nivel 3 desde [`README_Template.md`](../../docs/README_Template.md) | `docs(naive-sort): add README for naive sort module` | **agente** |
| 8 | Índices del lenguaje | `glot prompt docs-language` (0.8.0; alcance **solo N1/N2** desde la 1.6.0) · `glot save 8` (0.9.0) → `{lang}/README.md` y los `README.md` de fase | `docs: add README for {phase} and update indexes` | **agente** |

**ES:** El paso 8 es del **submódulo**, igual que el 7: sube los índices N1/N2 que enumeran el módulo nuevo. Va aquí, **antes** de la integración, para que el merge y el puntero se hagan una sola vez. Confirmarlo **después** del `pointer` deja el gitlink apuntando a un commit anterior: `glot status` lo enseña como `differs` y `glot close` **frena** hasta que el puntero se vuelva a preparar.

**EN:** Step 8 belongs to the **submodule**, like step 7: it updates the N1/N2 indexes that list the new module. It goes here, **before** the integration, so that the merge and the pointer happen once. Confirming it **after** the `pointer` leaves the gitlink pointing at an earlier commit: `glot status` shows it as `differs` and `glot close` **stops** until the pointer is prepared again.

**ES:** **Reparto del paso 6** (decidido en la v1.4.0, y en [`CONTRACT.md`](CONTRACT.md)): `test` comprueba que la suite **entera** pase; `verify` es **lint idiomático** (sintaxis y formato) y nada más —no comprueba la suite, no busca valores codificados para aprobar y **no** hace análisis estático de seguridad—; `evidence` deja el **acta** con las dos salidas reales; `validate` revisa contrato, README, enlaces, cobertura y el ***hardcode***; y la **revisión humana** se queda con lo cualitativo (pseudocódigo y divergencias idiomáticas).

**EN:** **Step 6 split** (decided in v1.4.0, and in [`CONTRACT.md`](CONTRACT.md)): `test` checks that the **whole** suite passes; `verify` is **idiomatic lint** (syntax and formatting) and nothing else —it does not check the suite, does not look for hardcoded values and does **not** run static security analysis—; `evidence` leaves the **record** with both real outputs; `validate` reviews contract, README, links, coverage and ***hardcode***; and the **human review** keeps the qualitative part.

**ES:** Al terminar la Fase A, el cambio del submódulo se integra en **su** `main` y se anota el commit resultante (la sección **Integración** de abajo); después el monorepo lo registra con los pasos 9 y 10 (Fase B).

**EN:** When Phase A ends, the submodule change is merged into **its** `main` and the resulting commit is noted (the **Integration** section below); then the monorepo records it with steps 9 and 10 (Phase B).

**ES:** **Numeración de pasos:** cuando un paso nuevo entra **en medio**, se le asigna el ordinal libre y **los siguientes se recorren**: el paso 4 se partió en `4a` (esqueleto) y `4b` (suite) en la v0.9.0; en la v1.1.0 el contrato entró como `4b` con la suite desplazada a `4c`; y en la **v1.6.0** llegaron los tres pasos del **retrabajo** —`4d correct` (un artefacto `4a`/`4b`/`4c` anterior a la implementación), `5b fix` (un defecto de comportamiento del paso 5) y `5c refactor` (una forma nueva sin cambio observable)—, que toman el ordinal libre **junto a su paso de origen**. La numeración es **contrato del tooling**: el mismo ordinal vale para esta tabla, para [`data/commits.tsv`](../data/commits.tsv) y para el `step:` del frontmatter de cada plantilla, y se cambia en los tres sitios a la vez.

**EN:** **Step numbering:** when a new step goes **in the middle**, it takes the free ordinal and **the following ones shift**: step 4 was split into `4a` (scaffold) and `4b` (suite) in v0.9.0; in v1.1.0 the contract came in as `4b` with the suite shifted to `4c`; and in **v1.6.0** the three **rework** steps arrived —`4d correct` (an artefact `4a`/`4b`/`4c` from before the implementation), `5b fix` (a behaviour defect of step 5) and `5c refactor` (a new shape with no observable change)—, taking the free ordinal **next to their source step**. The numbering is a **tooling contract**: the same ordinal holds for this table, for [`data/commits.tsv`](../data/commits.tsv) and for the `step:` frontmatter of each template, and the three change at once.

---

## 🧷 Integración — solo el autor / Integration — the author only

**ES:** Aquí `glot` **no puede trabajar por ti**: el trabajo del submódulo vive en `feat/{fase}/{módulo}` hasta que se integra en el `main` del submódulo, y `glot` no fusiona ni publica por su cuenta (el reparto de [`AGENTS.md`](../../AGENTS.md) y la regla de [`CONTRIBUTING.md`](../../docs/CONTRIBUTING.md)). Los comandos, con `{lang}` y `{rama}` ya resueltos:

```bash
git -C {lang} switch main                  # 1. la rama que guarda lo integrado
git -C {lang} merge --no-ff {rama}         # 2. el trabajo del sprint entra en main
git -C {lang} push origin main             # 3. el remoto guarda ese commit
git -C {lang} push origin {rama}           # 4. la rama de trabajo, si quieres conservarla
```

**ES:** Desde la **v1.6.2**, confirmar el `7` o el `8` con la capa cargable **ya te deja en la raíz del lenguaje**, que es donde se integra: los comandos de abajo se pueden pegar sin el `-C {lang}` (y tal cual también funcionan desde cualquier directorio).

**EN:** Since **v1.6.2**, committing step `7` or `8` with the loadable layer **already leaves you at the language root**, which is where the integration happens: the commands below can be pasted without `-C {lang}` (and as they are they also work from any directory).

**ES:** El paso 3 no es cosmético: `pointer` exige que el `HEAD` del submódulo sea **el de `origin/main`** (un `fetch` explícito y una comparación), porque el puntero del monorepo no puede apuntar a una rama de trabajo. Y el **push del monorepo** tampoco lo hace `glot`: las ramas del monorepo las publica `use` y el resto del trabajo lo sube el autor.

**EN:** Step 3 is not cosmetic: `pointer` requires the submodule `HEAD` to be **the `origin/main` one** (an explicit `fetch` and a comparison), because the monorepo pointer must not point at a working branch. And the **monorepo push** is not done by `glot` either: monorepo branches are published by `use`, and the rest of the work is pushed by the author.

**ES:** Lo que `glot` sí hace es **decirte cuándo toca**: al confirmar el paso 7 o el 8 con la rama del sprint sin integrar, `save` imprime el bloque de los cuatro comandos; y `pointer` **frena** con ese mismo bloque si le llega el trabajo sin fusionar (también si vuelves a `main` sin fusionar: comprueba que la rama del sprint no tenga commits que `main` no tenga).

**EN:** What `glot` does do is **tell you when it is time**: when step 7 or 8 is committed with the sprint branch unmerged, `save` prints the four-command block; and `pointer` **stops** with that same block if it finds unmerged work (also if you switch back to `main` without merging: it checks that the sprint branch has no commits `main` does not have).

## Fase B — en el monorepo / Phase B — in the monorepo

| # | Paso | Comando | Evidencia / artefacto | Quién |
|:-:|------|---------|-----------------------|-------|
| 9 | Puntero | `glot pointer` (0.12.0; **sin rama propia** desde la 1.3.0) + `glot save 9` (0.12.0), **en la rama activa** | `chore(submodule): update {lang} pointer` con el gitlink del commit integrado | script |
| 10 | Registro del cierre | `glot close` (0.10.0) + `glot save 10` (0.12.0) | Entrada en [`ROADMAP_UPDATE_CHECKLIST.md`](../../docs/ROADMAP_UPDATE_CHECKLIST.md) y contador de [`ROADMAP.md`](../../docs/ROADMAP.md) al día, a partir del acta de evidencia | script + **agente** |
| **9+10** | **Cierre completo**, en un paso | `glot finish` (1.6.0) → `pointer` + `save 9` + `close` + `save 10` | Los **dos commits** —el puntero y el registro— y el **estado del sprint limpio** (salvo las dos claves de modelo); el **push** es del autor |

**ES:** Los pasos 9 y 10 se hacen de una vez con `glot finish` (1.6.0): prepara y confirma el **puntero** (`save 9`) y registra el **cierre** (`close` + `save 10`), en la **rama activa** y sin abrir rama propia. Son **dos commits** —el puntero y el registro— y el **push** lo hace el autor. `finish` deja el estado en `target=monorepo` y, desde la **v1.6.2**, al terminar **limpia el estado del sprint** (salvo `antigravity-model` y `shell-gpt-model`, las dos claves de modelo del delegado; v1.7.0): el sprint siguiente empieza por `glot use`.

**EN:** Steps 9 and 10 are done at once with `glot finish` (1.6.0): it prepares and commits the **pointer** (`save 9`) and records the **closure** (`close` + `save 10`), on the **active branch** and opening no branch. That is **two commits** —the pointer and the record— and the **push** is the author's. `finish` leaves the state in `target=monorepo` and, since **v1.6.2**, when it is done it **clears the sprint state** (except `antigravity-model` and `shell-gpt-model`, the two delegate model keys; v1.7.0): the next sprint starts with `glot use`.

---

## 📋 Plantilla de commit por paso / Commit template per step

**ES:** Convención real del repositorio (Conventional Commits, alcance de fase o módulo):

| Paso | Mensaje |
|------|---------|
| Esqueleto | `chore({phase}): add scaffold for {module}` |
| Contrato del módulo | `chore({phase}): add contract for {module}` |
| Suite de pruebas | `chore({phase}): add suite for {module}` |
| Corrección previa a la implementación | `chore({phase}): correct {module}` |
| Implementación | `feat({phase}): add {module} implementation` |
| Defecto de la implementación | `fix({phase}): correct {module}` |
| Reelaboración sin cambio de comportamiento | `refactor({phase}): rework {module}` |
| README del módulo | `docs({module}): add README for {module} module` |
| Índices y lenguaje | `docs: add README for {phase} and update indexes` |
| Puntero en el monorepo | `chore(submodule): update {lang} pointer` |
| Cierre del roadmap | `docs(roadmap): close {phase}/{module} for {lang}` |

**ES:** Esta tabla es la fuente de los mensajes y vive **también en datos** ([`scripts/data/commits.tsv`](../../scripts/data/commits.tsv)), que es lo que lee `glot save <paso>`; el harness comprueba la deriva entre las dos. Los marcadores son los mismos del resto del tooling (`{phase}`, `{module}`, `{lang}`), no sus traducciones.

**EN:** This table is the source of the messages and it lives **in data too** ([`scripts/data/commits.tsv`](../../scripts/data/commits.tsv)), which is what `glot save <step>` reads; the harness checks for drift between the two. The placeholders are the same ones used by the rest of the tooling (`{phase}`, `{module}`, `{lang}`), not their translations.

**EN:** Actual repository convention (Conventional Commits, phase or module scope). The scope is the phase for scaffolding and implementation, and the module for its own README.

---

## 🔧 Qué hace cada verbo, paso a paso / What each verb does, step by step

**ES:** Lo que hay **dentro** de cada verbo del ciclo. Los ordinales son pasos internos, no pasos del sprint: sirven para saber dónde frena un verbo y qué queda en tu mano. Medido el 2026-09-28 recorriendo el ciclo entero en el laboratorio (`~/glot-lab/cycle`).

**EN:** What is **inside** each verb of the cycle. The ordinals are internal steps, not sprint steps: they tell you where a verb stops and what is left in your hands.

### `glot use <lenguaje> <fase>/<módulo> [tipo]` — situar el trabajo

| # | Qué hace / What it does |
|:-:|---|
| 1 | **Argumentos**: rechaza opciones; resuelve lenguaje y `fase/módulo`; el tipo de rama por defecto es `feat` (también `fix`, `docs`, `chore`, `refactor`, `test`) |
| 2 | **Valida antes de tocar nada**: raíz del monorepo, lenguaje registrado en `.gitmodules`, submódulo inicializado, fase existente y **especificación presente** |
| 3 | **Lee el estado real**: ¿existe la rama `{tipo}/{fase}/{módulo}`? ¿existe la carpeta del módulo? ¿hay trabajo sin confirmar en el submódulo? |
| 4 | **`-n`**: imprime el plan —los mismos `git` y `mkdir` que ejecutaría— y **no toca ni git ni el estado** |
| 5 | **Módulo nuevo**: `switch -c {rama} main` → `push -u origin {rama}` → `mkdir -p {carpeta}`, vacía (el esqueleto del lenguaje es de `new`) |
| 6 | **Módulo existente**: avisa de que no hay esqueleto que crear. Si ya estás en la rama, la **republica** (un `push` no toca el árbol: reanudar con trabajo a medias es seguro); con el árbol limpio **activa** la rama; si el módulo está cerrado, abre una de mantenimiento **solo** si le diste `tipo` |
| 7 | **Con trabajo sin confirmar**, `use` **no crea ni cambia ramas**: informa de dónde estás y de la rama que falta, y para |
| 8 | **Guarda el estado** `lang/phase/module/branch/spec/repo` e imprime **la carpeta de la fase** (`{lenguaje}/core/{fase}`) en stdout, que es donde la capa cargable deja al autor |
| 9 | Recuerda que el `cd` real solo llega con la **capa cargable** (`glot install`) y **nunca dentro de una tubería**: ahí corre en un subshell |

### `glot new [lenguaje] [fase/módulo]` — el esqueleto del lenguaje

| # | Qué hace / What it does |
|:-:|---|
| 1 | Resuelve el destino (argumentos → estado del sprint → directorio) y **comprueba que el módulo ya existe** (`use` lo creó): si hay contenido del sprint, no lo pisa |
| 2 | Busca la **secuencia** del lenguaje en [`data/init_sequences.tsv`](../data/init_sequences.tsv); si no la hay, el **comando único** de `languages.tsv`; si el lenguaje es `manual`, crea las carpetas |
| 3 | **`-n`**: imprime el plan —pasos, directorio de trabajo de cada uno y completado— sin ejecutar nada |
| 4 | **Ejecuta cada paso en orden** dentro del directorio del módulo (subshell: **no mueve al autor**), con `expect` cuando el dato lo pide |
| 5 | Aplica la **normalización** declarada (aplanar el nido del inicializador, quitar el `.git` anidado, descartar el vendoring que el repositorio rechaza) |
| 6 | Imprime **en un solo bloque final** el **completado**: lo que el dato declara como nota y el autor aplica a mano |
| 7 | **No** escribe la suite ni el contrato: son los pasos `4b` y `4c` |
| 8 | Deja al autor **en el directorio del módulo**: con la capa cargable es `new` quien baja a él, y en modo programa lo recuerda su salida |

### `glot test` · `glot verify` — ejecutar

| # | Qué hace / What it does |
|:-:|---|
| 1 | Resuelve el destino (argumentos → estado → directorio) |
| 2 | Lee el comando nativo de `languages.tsv` (`test` la columna 4, `verify` la columna 5) y lo ejecuta **en el directorio del módulo**, vengas de donde vengas |
| 3 | `test`: `0` en verde y `4` en rojo. `verify`: si la celda es `-`, imprime `skipped` y sale `0`; con hallazgos, `4` |
| 4 | Imprime **la salida real** del comando y su código. `verify` es *lint* idiomático: no comprueba la suite ni busca *hardcode* (ver el reparto del paso 6) |

### `glot evidence` — el acta

| # | Qué hace / What it does |
|:-:|---|
| 1 | Ejecuta la suite y el verificador y **captura** sus salidas y sus códigos |
| 2 | Lee la rama y el commit del submódulo, y si el árbol está limpio |
| 3 | Escribe `docs/evidence/{fase}/{módulo}/{lenguaje}.md` con el veredicto `green` o `red`, **también cuando está en rojo** |
| 4 | Devuelve `4` si algo falló. Sin test en verde no hay `close` |

### `glot save <paso|alias> [--cause "…"]` — confirmar

| # | Qué hace / What it does |
|:-:|---|
| 1 | Resuelve el paso (ordinal o alias) en [`data/commits.tsv`](../data/commits.tsv) y su **ámbito**: `submodule` o `monorepo` |
| 2 | Resuelve el destino del sprint y comprueba que la rama activa del submódulo sea la del estado (avisa si no) |
| 3 | **Ámbito `submodule`**: `git add -A` del submódulo entero, avisando de lo que entra de fuera del módulo. **Ámbito `monorepo`**: añade **solo las rutas del paso** (el gitlink, o roadmap + checklist + evidencia) |
| 4 | **`-n`**: imprime el plan (`git add` y `git commit` con su mensaje) sin tocar el índice |
| 5 | Confirma con el mensaje del catálogo e imprime el **SHA corto**. El **retrabajo** (`4d`, `5b`, `5c`) **exige causa**: sale de `--cause` —`--causa` vale como alias— o de la **clave de estado `cause`**, que el propio encargo deja con `glot set cause "…"`, y viaja como **segundo `-m`**; al confirmar, `save` **retira la clave** para que no se cuele en el commit siguiente |
| 6 | **Nunca hace push**. Y en los pasos `7` y `8`, si la rama del sprint no está integrada, imprime el bloque de **integración** |
| 7 | Con la capa cargable, confirmar el **`7` o el `8` deja al autor en la raíz del lenguaje**, que es donde se integra: la carpeta del módulo no existe en el `main` del submódulo, así que un `switch` desde ahí dejaría un directorio sin contenido |

### `glot pointer` — el gitlink del monorepo

| # | Qué hace / What it does |
|:-:|---|
| 1 | Resuelve el destino y comprueba que el submódulo esté clonado |
| 2 | **Frena si la rama del sprint tiene commits que `main` no tiene**: sin esto, volver a `main` sin fusionar dejaba el puntero en el commit base y respondía `nothing`, con el módulo entero fuera. Imprime el bloque de integración |
| 3 | **Idempotente y sin red**: si el monorepo ya apunta a ese commit, imprime `nothing` |
| 4 | **`-n`**: imprime el plan y no toca nada |
| 5 | `fetch origin main` **explícito** del submódulo y exige dos cosas: que esté en `main` y que su `HEAD` **sea** el de `origin/main` (la regla de [`CONTRIBUTING.md`](../../docs/CONTRIBUTING.md) convertida en comprobación) |
| 6 | Añade el gitlink **en la rama activa** del monorepo —**sin** abrir ni publicar rama propia desde la v1.3.0— e imprime el SHA y `glot save 9` |

### `glot close` — el cierre

| # | Qué hace / What it does |
|:-:|---|
| 1 | Resuelve el destino y el nombre de presentación del lenguaje |
| 2 | Exige la **línea del módulo** en el roadmap y el checklist |
| 3 | **Exige que el puntero del monorepo apunte al `HEAD` del submódulo**: si el paso 8 se confirmó después del `pointer`, el gitlink se quedó atrás y aquí frena con el remedio |
| 4 | Exige el **acta** y que su veredicto sea `green` (si no, remite a `glot evidence`) |
| 5 | Exige el **README del módulo** (paso 7) y el de la **fase** (paso 8), y nombra el encargo que los escribe |
| 6 | Reescribe la línea del roadmap —contador y lista de lenguajes— y **añade** la entrada del checklist. **No confirma**: el commit es `save 10` |

### `glot finish` — el cierre del monorepo en un paso (v1.6.0)

| # | Qué hace / What it does |
|:-:|---|
| 1 | Prepara y confirma el **puntero** (`pointer` + `save 9`) |
| 2 | Registra el **cierre** (`close` + `save 10` y su commit), reutilizando lo que ya hacen los dos verbos, así que sus requisitos siguen valiendo: el gitlink al `HEAD` del submódulo y el acta en `green` |
| 3 | Todo en la **rama activa** del monorepo y **sin abrir rama propia**: son **dos commits** —el puntero y el registro— y el **push** es del autor |
| 4 | Deja el estado en `target=monorepo` (que es lo que fija `use` en `target=submodule`); códigos: `0` correcto · `1` entorno o dato · `3` no se pudo escribir · `4` requisitos sin cumplir |
| 5 | Al terminar, **limpia el estado del sprint** (v1.6.2): se van `lang`, `phase`, `module`, `branch`, `spec`, `repo`, `target` y `cause`, y se quedan `antigravity-model` y `shell-gpt-model` (v1.7.0). Es lo que evita seguir trabajando sobre una rama y un directorio finalizados: para el siguiente, `glot use`. En ensayo (`-n`) solo lo anuncia |

## 🙋 Lo que solo puede hacer el autor / What only the author can do

**ES:** `glot` no hace estas cuatro cosas, y no son un defecto: son el reparto. Cuando toca, las **dice** (el bloque de integración y el remedio del puntero); aquí quedan juntas:

| Qué / What | Cómo / How |
|---|---|
| **Aplicar el completado** de `new` cuando el dato lo declara como nota y no como comando | A mano, en el módulo; `new` lo imprime en un bloque al final |
| **Integrar el submódulo**: fusionar la rama del sprint en su `main` y publicarlo | `git -C {lang} switch main && git -C {lang} merge --no-ff {rama} && git -C {lang} push origin main` |
| **Publicar el monorepo** | `glot` **nunca** hace push del monorepo (`use` publica la rama de trabajo del submódulo; el resto es del autor) |
| **La revisión cualitativa**: pseudocódigo, divergencias idiomáticas y si el README dice la verdad | Leer; `validate` revisa contrato, README, enlaces, cobertura y *hardcode*, pero no juzga |

**EN:** `glot` does not do these four things, and that is not a defect: it is the split. When the time comes it **says so** (the integration block and the pointer remedy); here they are together: apply `new`'s completion notes by hand; **integrate the submodule** (merge the sprint branch into its `main` and push it); **push the monorepo** (`glot` never pushes it); and the **qualitative review** (pseudocode, idiomatic divergences and whether the README tells the truth).

---

## 🤖 Los pasos con IA, y por qué / The AI-assisted steps, and why

**ES:** Los pasos 4a, 4b, 4c, 4d, 5, 5b, 5c, 7 y 8 se hacen con ayuda del agente porque requieren **leer y comparar** (la especificación contra el código, la plantilla contra el README, el roadmap contra el estado real). `glot` no los ejecuta: los **encarga**. Desde la v0.8.0 el encargo lo arma `glot prompt <encargo>` con el estado del sprint, y las plantillas están **versionadas** en [`scripts/prompts/`](../../scripts/prompts/).

**EN:** Steps 4a, 4b, 4c, 4d, 5, 5b, 5c, 7 and 8 are done with the agent's help because they require **reading and comparing** (spec against code, template against README, roadmap against the real state). `glot` does not run them: it **requests** them. Since v0.8.0 the request is built by `glot prompt <request>` from the sprint state, and the templates are **versioned** in [`scripts/prompts/`](../../scripts/prompts/).

| Encargo previsto | Plantilla versionada | Paso | Modelo (v1.6.0) |
|------------------|----------------------|:----:|-----------------|
| `scaffold` | [`scaffold.prompt.md`](../../scripts/prompts/scaffold.prompt.md) | 4a | `gpt-5.6-terra` |
| `contract_stub` | [`contract_stub.prompt.md`](../../scripts/prompts/contract_stub.prompt.md) | 4b | `gpt-5.6-terra` |
| `suite` | [`suite.prompt.md`](../../scripts/prompts/suite.prompt.md) | 4c | `gpt-5.6-terra` |
| `correct` | [`correct.prompt.md`](../../scripts/prompts/correct.prompt.md) | 4d | `gpt-5.6-terra` |
| `implement` | [`implement.prompt.md`](../../scripts/prompts/implement.prompt.md) | 5 | `claude-sonnet-5` |
| `fix` | [`fix.prompt.md`](../../scripts/prompts/fix.prompt.md) | 5b | `claude-sonnet-5` |
| `refactor` | [`refactor.prompt.md`](../../scripts/prompts/refactor.prompt.md) | 5c | `claude-sonnet-5` |
| `validate` | [`validate.prompt.md`](../../scripts/prompts/validate.prompt.md) | 6 | `gemini-3.8-flash` |
| `docs-module` | [`docs-module.prompt.md`](../../scripts/prompts/docs-module.prompt.md) | 7 | `gemini-3.8-flash` |
| `docs-language` | [`docs-language.prompt.md`](../../scripts/prompts/docs-language.prompt.md) | 8 | `gemini-3.8-flash` |

**ES:** Desde la v0.11.0 cada plantilla **declara su modelo** en el frontmatter (`model:`, con el id real que ofrece Copilot) y el catálogo [`data/models.tsv`](../../scripts/data/models.tsv) fija el esfuerzo, el tope de créditos y el tier de auto de ese modelo. El **modelo es la clave del perfil**: no hay una clave `profile:` que pueda derivar. Las plantillas siguen siendo **genéricas**: el modelo es política de coste, no dato de un módulo. Desde la **v1.6.0** el catálogo añade la **séptima columna** con el modelo del **delegado de AGY** —sus ids no son los de Copilot—, así que el modelo se elige **por rol** y viaja también con `--delegate antigravity`; `--model`/`GLOT_MODEL` (`_COP`/`_AGY`) y `--effort`/`GLOT_EFFORT` lo cambian **para una corrida** sin tocar el dato (los perfiles: `economy` → `gemini-3.8-flash-low`, `balanced` → `gemini-3.8-flash-low`, `deep` → `claude-sonnet-5-5-low`). Desde la v1.0.0 declaran además sus **fuentes** (`sources:`, rutas relativas a la raíz del monorepo, que la cabecera del encargo trae como `root`) y `glot prompt` **avisa** por stderr de las que falten: el encargo dice qué documentos necesita como dato comprobable, en vez de nombrar el monorepo en prosa.

**EN:** Since v0.11.0 every template **declares its model** in the frontmatter (`model:`, with the real id Copilot offers) and the [`data/models.tsv`](../../scripts/data/models.tsv) catalogue states the effort, the credit cap and the auto tier for that model. The **model is the profile key**: there is no `profile:` key that could drift. Templates stay **generic**: the model is cost policy, not module data. Since **v1.6.0** the catalogue adds the **seventh column** with the **AGY delegate's** model —its ids are not Copilot's—, so the model is chosen **by role** and travels with `--delegate antigravity` too; `--model`/`GLOT_MODEL` (`_COP`/`_AGY`) and `--effort`/`GLOT_EFFORT` change it **for one run** without touching the datum (the profiles: `economy` → `gemini-3.8-flash-low`, `balanced` → `gemini-3.8-flash-low`, `deep` → `claude-sonnet-5-5-low`). Since **v1.7.0** the **AGY** one can be **pinned per sprint** with `glot set antigravity-model <alias>` (the `antigravity-model` state key, an alias from `data/delegates.tsv`: `gemini`, `sonnet`) and **shellgpt**'s with `glot set shell-gpt-model <alias>` (`default`, `qwen`, `gemini`, `kimi`): they beat the profile and lose to `--model`/`GLOT_MODEL_<DELEGATE>`; it is what lets them be changed mid-module when the hourly or quota limits run out, which the CLI does not expose. Since v1.0.0 they also declare their **sources** (`sources:`, paths relative to the monorepo root, which the request header carries as `root`) and `glot prompt` **warns** on stderr about the missing ones: the request states which documents it needs as checkable data, instead of naming the monorepo in prose.

**ES:** Las plantillas son **genéricas**: no llevan datos de ningún módulo concreto (ni casos de prueba ni nombres de archivo). Cada encargo **lee** lo que necesita de la especificación del módulo y de los módulos ya homologados del lenguaje; el harness comprueba que ninguna plantilla vuelva a llevar datos de un módulo.

**ES:** El encargo viaja con **rutas absolutas** (v1.6.3, [`CONTRACT.md`](CONTRACT.md) regla 21): `root`, `spec`, `module_dir` y las citas de la plantilla que son relativas a la raíz del monorepo. El `cd` del ciclo deja al autor dentro del módulo, y el delegado resuelve las rutas relativas contra *su* repositorio —el submódulo—, así que buscaba `{lenguaje}/docs/…` y gastaba turnos y créditos en documentos que no existen ahí. Los **alias** de modelo se completan con el TAB en `glot set antigravity-model|shell-gpt-model`, desde el catálogo `glot delegates` (v1.7.0).

**EN:** The request travels with **absolute paths** (v1.6.3, [`CONTRACT.md`](CONTRACT.md) rule 21): `root`, `spec`, `module_dir` and the template's citations that are relative to the monorepo root. The cycle's `cd` leaves the author inside the module, and the delegate resolves relative paths against *its* repository —the submodule—, so it looked for `{lang}/docs/…` and burned turns and credits on documents that are not there. The model **aliases** complete with TAB in `glot set antigravity-model|shell-gpt-model`, from the `glot delegates` catalogue (v1.7.0).

**EN:** The templates are **generic**: they carry no data from any particular module (no test cases, no file names). Each request **reads** what it needs from the module's specification and from the language's already homologated modules; the harness checks that no template carries module data again.

---

## 🧭 Estado del sprint y dónde vive / Sprint state and where it lives

**ES:** El estado del sprint es el del almacén de `glot` ([`CONTRACT.md`](CONTRACT.md)): `lang`, `phase`, `module`, `branch`, `spec` y `repo`. Cualquier verb que necesite saber «dónde estoy trabajando» lo lee de ahí, no del directorio actual: por eso `glot test` funciona **desde cualquier directorio**. Desde la **v1.6.0** hay además `target` —`submodule` mientras el trabajo vive en el submódulo y `monorepo` después de `finish`— y, mientras hay retrabajo pendiente, la clave `cause`, que el encargo deja puesta y `save` **retira** al confirmar el commit.

**EN:** The sprint state is `glot`'s state store ([`CONTRACT.md`](CONTRACT.md)): `lang`, `phase`, `module`, `branch`, `spec` and `repo`. Any verb that needs to know "where am I working" reads it from there, not from the current directory: that is why `glot test` works **from any directory**. Since **v1.6.0** there is also `target` —`submodule` while the work lives in the submodule and `monorepo` after `finish`— and, while rework is pending, the `cause` key, which the request leaves set and `save` **removes** when the commit is confirmed.

**ES:** El estado **se limpia al cerrar** (v1.6.2): `glot finish` retira las claves del sprint y deja solo `antigravity-model` y `shell-gpt-model` (v1.7.0), así que un sprint cerrado no se continúa por inercia —y ningún verbo trabaja sobre una rama o un directorio que ya no existen en `main`—: para el siguiente hay que volver a asignar los valores con `glot use`. Al cerrar sin `finish` (`close` + `save 10` por separado) el estado se queda como está.

**EN:** The state **is cleared on closure** (v1.6.2): `glot finish` removes the sprint keys and leaves only `antigravity-model` and `shell-gpt-model` (v1.7.0), so a closed sprint is not carried on by inertia —and no verb works against a branch or a directory that no longer exists on `main`—: the next one needs the values assigned again with `glot use`. Closing without `finish` (`close` + `save 10` separately) leaves the state as it is.

**ES:** Un sprint empieza **siempre** desde el `main` del submódulo, que guarda el estado concluido. La rama `dev` existe en algunos repositorios como legado del flujo anterior y no se usa.

**EN:** A sprint **always** starts from the submodule's `main`, which holds the closed state. The `dev` branch exists in some repositories as a leftover from the previous flow and is not used.
