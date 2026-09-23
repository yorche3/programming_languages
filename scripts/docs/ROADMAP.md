# 🧭 Roadmap de `glot` / `glot` roadmap

**ES:** Capas, versiones y el criterio que decide en qué orden llegan. La versión viva y su log están en [`VERSIONS.md`](VERSIONS.md); el ciclo que estas capas sirven está en [`SPRINT.md`](SPRINT.md) y, como norma del monorepo, en [`../../docs/WORKFLOW.md`](../../docs/WORKFLOW.md).

**EN:** Layers, versions and the rule that decides their order. The live version and its log are in [`VERSIONS.md`](VERSIONS.md); the cycle these layers serve is in [`SPRINT.md`](SPRINT.md) and, as monorepo policy, in [`../../docs/WORKFLOW.md`](../../docs/WORKFLOW.md).

---

## 🎯 Objetivo / Goal

**ES:** `glot` convierte el ciclo de trabajo de un módulo —**situar, crear, ejecutar, delegar, cerrar y publicar**— en comandos reproducibles, y deja la evidencia en el repositorio.

**EN:** `glot` turns the per-module work cycle —**locate, create, run, delegate, close and publish**— into reproducible commands, and leaves the evidence in the repository.

| Responsabilidad / Responsibility | Detalle / Detail |
|---|---|
| Resolver catálogo y estado | Lenguaje, fase, módulo, rama y especificación del trabajo en curso |
| Preparar el entorno | Directorio del módulo, rama de trabajo y, desde L9, la toolchain esperada |
| Ejecutar y verificar | Comandos nativos del lenguaje desde cualquier directorio, leyendo el estado |
| Preparar los encargos de IA | Arma el encargo para el agente con las plantillas versionadas de `scripts/prompts/`; no lo ejecuta por su cuenta |
| Registrar la evidencia | Salidas reales, checklist de cierre, roadmap y puntero del submódulo |

**No-objetivos / Non-goals:** no es un módulo del roadmap ni toca `.gitmodules` o los contadores `X/50`; no escribe documentación (la encarga y la valida); no sustituye al agente de VS Code; no publica nada que no se le pida explícitamente; no instala toolchains antes de L9; no es un gestor de proyectos.

---

## 📐 Criterios de orden / Ordering rules

1. **Primero leer, después mutar.** Los verbos que solo consultan llegan antes que los que escriben.
2. **El autocompletado acompaña al catálogo**, no llega al final: los datos (`.gitmodules`, el bloque de contadores de `docs/ROADMAP.md`, la guía de inicialización y `data/languages.tsv`) son lo que el autocompletado necesita. El catálogo de datos no sustituye a la guía: la guía manda y el harness comprueba que los dos no se separan.
3. **Todo verbo que muta trae `-n/--dry-run` desde el día uno** y nunca pregunta: el dato llega por argumento o por stdin.
4. **La capa de shell entra con la instalación.** `glot` se **ejecuta** hasta la v1.0.0; la función cargable con `source` (la única forma de que `use` pueda hacer `cd`) llega con `install`, que es quien toca `.bashrc`.
5. **Ninguna versión existe sin un paso del sprint detrás.** Cada capa cubre pasos concretos de [`SPRINT.md`](SPRINT.md).
6. **Puerta de entrada al archivo.** Ninguna versión se empieza a implementar sin el snapshot de la anterior en `versions/`; si falta, se copia `glot.sh` con el sufijo de su versión y solo después se reanuda la implementación.

---

## 🗂️ Capas / Layers

| Capa | Qué es / What it is | Versión / Version |
|:----:|---------------------|:-----------------:|
| L0 | Contrato de verbos y dispatcher | 0.3.0 ✅ |
| L1 | Almacén de estado clave/valor | 0.4.0 ✅ |
| L2 | Asignación: situar el trabajo (`use`) | 0.5.0 ✅ |
| L2.5 | Catálogo (`langs`, `modules`, `progress`), comandos nativos y autocompletado | 0.6.0 ✅ |
| L3 | Ejecución: `test` y `verify` | 0.7.0 ✅ |
| L4 | Delegación: `prompt` (encargos de IA) y `ask` (envío al delegado) | 0.8.0 ✅ |
| L5 | Creación y registro: `new`, `save` | 0.9.0 ✅ |
| L6 | Evidencia y cierre: `evidence`, `close`, `validate` | 0.10.0 ✅ |
| L6.5 | Perfiles de modelo por encargo: `model:` en cada plantilla y catálogo de perfiles con los modelos de Copilot | 0.11.0 |
| L7 | Higiene y punteros: `status`, `pointer`, `clean` | 0.12.0 |
| L8 | Instalación: `install`, función cargable, `doctor` completo | 1.0.0 |
| L9 | Toolchains por lenguaje (`mise`, `nvm`, `pyenv`) | después |

---

## 🗓️ Versiones / Versions

| Versión | Capa | Pasos del sprint | Añade | Por qué ahí / Why there |
|---------|:----:|:----------------:|-------|-------------------------|
| 0.4.0 | L1 | — | `set`, `get`, `unset`, `list`, `path` en XDG | Cimiento que consumen `use`, `test` y el progreso |
| 0.5.0 | L2 | 2–3 | `use <lenguaje> <fase>/<módulo> [tipo]`: valida contra `.gitmodules` y sitúa el trabajo según cuatro estados (nuevo, en curso, reanudar, cerrado): activa o crea la rama desde `main`, la publica con upstream, crea la carpeta si falta y no toca nada cuando hay trabajo sin confirmar. Guarda el estado e imprime la ruta | Es el paso que sitúa el trabajo; el `cd` real que lo completa llega con la capa cargable |
| 0.6.0 | L2.5 | apoyo a todos | `langs`, `modules`, `progress` y `completion`: el **conversor de nombres** (id canónico → documento, rama, commit y carpeta), los comandos nativos por lenguaje en `data/languages.tsv` y el autocompletado de bash y zsh con completado dinámico | Los datos ya existen; el autocompletado los necesita, y `use` deja de depender de un heurístico de nombres |
| 0.7.0 | L3 | 5–7 | `test` (suite del módulo asignado, con el comando nativo del lenguaje) y `verify` (sintaxis/formato), desde cualquier directorio, con el código `4` de verificación fallida y los marcadores `{modulo}`/`{Modulo}`/`{suite}` resueltos contra el módulo real | Primer consumo real del catálogo y del estado; la tabla de comandos se corrige contra los módulos ya homologados
| 0.8.0 | L4 | 4–8 | `prompt`/`ask`: arma el encargo para el agente con las plantillas **versionadas** de `scripts/prompts/`, con el estado del sprint expandido y `GLOT_DELEGATE` como estrategia enchufable | **Solo imprime texto** (o lo envía): no muta nada, así que va antes que la capa que sí muta |
| 0.9.0 | L5 | 4 | `new` (un verbo, dos modos: ejecuta el inicializador o construye el esqueleto manual, y normaliza lo que el inicializador deja) y `save` (commit guiado desde el catálogo de commits); tabla de inicialización ampliada con tipo/comando/normalización y el encargo `suite` separado de `scaffold` | Reutiliza catálogo y estado; elimina el andamiaje y el commit manual repetidos. Lo que exige leer la especificación (runners de ejemplo, nombres predefinidos) sigue siendo del agente |
| 0.10.0 | L6 | 7–8 | `evidence` (salidas reales), `close` (checklist + roadmap) y `validate` (validador automático con Copilot CLI) | El cierre documental requiere validación: la ejecuta el agente, el script la encarga y la comprueba |
| 0.11.0 | L6.5 | 4–6 | **Perfiles de modelo por encargo**: `model:` en el frontmatter de cada plantilla y un catálogo de perfiles **con los modelos que ofrece Copilot** —uno económico con esfuerzo bajo para validar y documentar, y el más capaz para implementar—, con tope de créditos por corrida | La delegación y la validación ya existen; el modelo es la palanca de calidad y de coste, y va después de tenerlas |
| 0.12.0 | L7 | 1, 9 | `status` (submódulos, ramas, punteros), `pointer` (actualiza el puntero del submódulo en el monorepo), `clean` de artefactos y `submodule sync` | Ops diaria; primero solo lectura, las mutaciones con `-n` |
| 1.0.0 | L8 | todos | `install`/`uninstall` (`.bashrc` + completions), **capa cargable** (`use` hace el `cd` real) y `doctor` completo | 1.0 = objetivo original cumplido |
| ⏳ | L9 | — | Versión esperada por lenguaje y comprobación/instalación | Segunda acepción de «manejador de versiones»; llega después del ciclo del roadmap |

### Deuda técnica declarada / Declared technical debt

| Deuda | Cuándo se paga |
|-------|----------------|
| Hasta la v1.0.0 el `cd` no es real: se usa `cd "$(glot use …)"` | v1.0.0 (`install` + capa cargable) |
| Hasta la v0.11.0 el puntero del submódulo en el monorepo se actualiza a mano | v0.11.0 (`pointer`) |

**ES:** Pagadas: los commits a mano se acabaron en la v0.9.0 (`save`).

**EN:** Paid: hand-made commits ended in v0.9.0 (`save`).

---

## 🤝 Reparto de responsabilidades: script y agente / Script and agent split

**ES:** `glot` es el **orquestador**: resuelve catálogo y estado, ejecuta los comandos de terminal (git, ramas, inicialización, tests, lint), captura las **salidas reales** y prepara el encargo. La parte documental (generar o modificar READMEs, checklist y roadmap) la ejecuta el **agente de VS Code**, porque requiere validación y criterio. La delegación se diseña como estrategia enchufable: por defecto el encargo se imprime en `stdout` (listo para pegar en el chat) y, si el entorno lo permite, se envía a un comando definido en `GLOT_DELEGATE`. Comprobado en este entorno: `code chat` **no está disponible** (el CLI remoto pasa `chat` a Electron) y `code agent` responde `The 'agent' command is not supported by the remote CLI`, así que el valor por defecto es imprimir.

**EN:** `glot` is the **orchestrator**: it resolves catalog and state, runs terminal commands (git, branches, initialization, tests, lint), captures **real outputs** and prepares the request. The documentation part (creating or modifying READMEs, checklist and roadmap) is executed by the **VS Code agent**, because it needs validation and judgement. Delegation is a pluggable strategy: by default the request is printed to `stdout` (ready to paste into the chat) and, when the environment allows it, it is piped to a command set in `GLOT_DELEGATE`. Verified in this environment: `code chat` is **not available** and `code agent` answers `The 'agent' command is not supported by the remote CLI`, so the default is printing.

La política del validador automático (invocación, modelo y coste, advertencias) está en [`VALIDATION.md`](VALIDATION.md).

---

### Decisiones cerradas de la v0.9.0 / Closed decisions for v0.9.0

**ES:** Las decisiones que la L5 tenía abiertas se resolvieron el 2026-09-22, antes de escribir código.

**EN:** The decisions L5 had pending were resolved on 2026-09-22, before writing any code.

| Tema | Decisión |
|------|----------|
| `new` y `scaffold` | **No hay verbo nuevo**: `new` es el verbo del script, con dos modos (`tool` ejecuta la herramienta, `manual` construye el esqueleto). `scaffold` sigue siendo el **encargo de IA** que ajusta lo que exige leer la especificación |
| Datos del inicializador | La leyenda de la guía (✅ verificado · 🔧 ecosistema · ✍️ manual) se **recupera como dato**: tipo, comando y normalización son columnas del catálogo, verificadas ejecutando cada inicializador en un directorio temporal y con la entrada cerrada. **Un caso que no se pudo verificar no se añade** |
| Alcance de `new` | Esqueleto y normalización, **sin la suite**: las pruebas son del encargo `suite` (paso 4b). El directorio del módulo lo prepara `use`; `new` no lo inventa y no pisa contenido existente |
| Paso 4 en dos commits | `4a` esqueleto (`chore({phase}): add scaffold for {module}`) y `4b` suite (`chore({phase}): add suite for {module}`) |
| `save` | El mensaje sale del **catálogo de commits** (paso o alias del encargo), nunca escrito a mano; añade el submódulo completo; confirma **solo** en el submódulo; **nunca** hace push. Los pasos del monorepo esperan a `close` y `pointer` |

---

### Decisiones cerradas de la v0.10.0 / Closed decisions for v0.10.0

**ES:** Las decisiones de la L6 se resolvieron el 2026-09-22, antes de escribir código.

**EN:** The L6 decisions were resolved on 2026-09-22, before writing any code.

| Tema | Decisión |
|------|----------|
| Casa de la evidencia | `docs/evidence/{fase}/{modulo}/{lenguaje}.md`, en el monorepo y junto al checklist y al roadmap que `close` toca. Antes de esto `VALIDATION.md` citaba un `$EVIDENCE_DIR` que ningún documento definía |
| Código de `validate` | `4` con hallazgos y `1` sin validador: el contrato mantiene separado «no pude ejecutarlo» de «lo ejecuté y está mal». `VALIDATION.md` preveía `1` para las dos cosas y se corrige |
| `close` y el roadmap | Edita el contador y la lista entre paréntesis (nombre de presentación y orden derivados de las líneas ya cerradas a `50/50`); `-n` enseña el diff exacto. **No confirma**: el commit es del autor, o de `save` cuando el ámbito `monorepo` se habilite |
| Contador de fase | «Lenguajes con **todos** los módulos de la fase cerrados», sobre los 50 de `.gitmodules`: Fase 0 `50/50`, Fase 1 hoy `0/50`. Se dice en la propia cabecera de la fase |
| Lenguaje por directorio | El objetivo se resuelve **argumentos → estado → directorio**. El estado manda sobre el directorio a propósito; el directorio es el último recurso, para que `cd php && glot test …` no exija `use` |
| `hello` | Se retira en la **v0.10.0**, antes de lo previsto (el contrato decía v1.0.0), y el aviso de verbo desconocido deja de ofrecer el saludo |
| Perfiles de modelo | Versión propia: **L6.5 → 0.11.0**, con L7 desplazada a la 0.12.0. Se configurarán **solo los modelos que ofrece Copilot**, con esfuerzo y tope de créditos ajustados por encargo. El proveedor propio (BYOK) **queda fuera**: exige variables de entorno y `glot` no gestiona claves ni proveedores; el mecanismo queda documentado en [`VALIDATION.md`](VALIDATION.md) por si algún día se quiere enchufar |
| Veredicto de `validate` | Se **lee**, no se interpreta: la plantilla `validate` exige una última línea `glot:validate verdict=clean\|findings findings=N` y `glot` solo acepta esos dos valores. Sin línea, o con otro, devuelve `3` en vez de suponer un resultado |
| Evidencia de la validación | El registro lo escribe `glot` (`docs/evidence/{fase}/{módulo}/{lenguaje}.validate.md`) y **no** se usa `--share`: así funciona también con un validador propio, que no tiene por qué saber escribir sesiones |

---

## ✅ Decisiones cerradas / Closed decisions

**ES:** Las tres decisiones que quedaban abiertas para la v0.6.0 se resolvieron el 2026-09-22.

**EN:** The three decisions pending for v0.6.0 were resolved on 2026-09-22.

| Tema | Decisión |
|------|----------|
| Contador de `progress` | El denominador son los **50** submódulos de `.gitmodules`. `progress` informa de los dos números: `registrados 50` (pertenencia a `.gitmodules`) y `homologados X` (módulos terminados). Cualquier contador `X/49` que quedara en la documentación se corrige a `X/50` |
| Vocabulario | Se mantiene **homologado** para el estado «finalizado\|concluido» y para marcar que el estado actual se actualizó; **registrado** queda reservado a la pertenencia técnica a `.gitmodules` |
| División de prompts | `module-readme.prompt.md` cubría README del módulo **más** índices y roadmap: **hecho** en la v0.8.0, con `docs-module` (paso 7) y `docs-language` (paso 8) separados y versionados en `scripts/prompts/` |

### Prompts: alcance actual / Prompts: current scope

**ES:** Las plantillas **normalizadas viven versionadas** en `scripts/prompts/`, junto al tooling: `glot prompt` las lista y las arma con el estado del sprint. `.github/prompts/` sigue siendo el banco local del autor (`.gitignore` lo excluye con «local only, never tracked»): `glot` lo acepta como respaldo cuando falta la versionada, **avisando** de que no viaja en el repositorio.

**EN:** The **normalised templates are versioned** in `scripts/prompts/`, next to the tooling: `glot prompt` lists them and builds them from the sprint state. `.github/prompts/` remains the author's local bank (`.gitignore` excludes it with "local only, never tracked"): `glot` accepts it as a fallback when the versioned one is missing, **warning** that it does not travel with the repository.
