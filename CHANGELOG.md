# Changelog

Todos los cambios relevantes del monorepo se registran en este archivo.
El formato sigue [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
y el versionado sigue [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- Nueva carpeta `scripts/` para las herramientas del monorepo, con `glot`: un CLI
  que crece por versiones siguiendo las especificaciones de los lenguajes
  (v0.1.0 `Hello World`, v0.2.0 equivalente a `hellouser`, v0.3.0 contrato y
  dispatcher de verbos y v0.4.0 almacén de estado clave/valor en XDG), con
  harness de pruebas propio y snapshots en `scripts/versions/`.
- `glot` v0.5.0: verbo `use`, que sitúa el trabajo del sprint y reconoce cuatro
  estados (nuevo, en curso, reanudar y cerrado): activa o crea la rama
  `{tipo}/{fase}/{módulo}` desde `main`, la publica con upstream y crea la
  carpeta si falta, y no crea ni cambia nada cuando hay trabajo sin confirmar;
  guarda el estado del sprint e imprime la ruta, con ensayo `-n/--dry-run` y
  158 comprobaciones en el harness.
- Se documentó el camino de versiones de `glot` (capas L0 a L9), el reparto de
  responsabilidades entre script y agente y la política del validador automático
  con GitHub Copilot CLI (modelo económico, salida JSONL y solo lectura).
- Se documentó el ciclo de trabajo de un módulo (el «sprint») como norma del
  monorepo en `docs/WORKFLOW.md`, y la documentación de `glot` se dividió en
  `scripts/README.md` (índice) más `scripts/docs/`: roadmap por capas L0–L9,
  sprint, contrato de verbos, tripas del script, log de versiones y validación.
- Se cerraron las decisiones abiertas de `glot` para la v0.6.0 y se unificó el
  vocabulario: **registrado** es la pertenencia técnica a `.gitmodules` (el
  denominador, 50) y **homologado** el estado «finalizado|concluido» de un
  módulo en un lenguaje (el numerador).
- `glot` v0.6.0: **catálogo** (L2.5) con `langs`, `modules`, `progress` y
  `completion`, más el conversor que proyecta el id canónico de un módulo
  (`data_structures`) a su nombre legible, su documento, su rama, su commit y su
  carpeta; los comandos nativos por lenguaje viven en
  `scripts/data/languages.tsv`, con test de deriva contra la guía de
  inicialización, y el autocompletado de bash y zsh (dinámico) se imprime con
  `glot completion`, con 227 comprobaciones en el harness.
- `glot` v0.7.0: **ejecución** (L3) con `test` (suite del módulo asignado, con el
  comando nativo del lenguaje) y `verify` (sintaxis/formato), desde cualquier
  directorio, con el código `4` de verificación fallida y los marcadores
  `{modulo}`, `{Modulo}` y `{suite}` resueltos contra el módulo real; el
  catálogo de datos suma la columna del verificador (14 de 50 lenguajes) y
  `doctor` informa de la cobertura, con 258 comprobaciones en el harness.
- `glot` v0.8.0: **delegación** (L4) con `prompt` (registro de encargos y
  encargo armado con el estado del sprint) y `ask` (envío a `GLOT_DELEGATE` por
  stdin); las cuatro plantillas del ciclo quedan **versionadas** en
  `scripts/prompts/` (`scaffold`, `implement`, `docs-module`, `docs-language`) y
  el vocabulario de marcadores se unifica con el del catálogo, con 286
  comprobaciones en el harness.
- `glot` v0.9.0: **creación y registro** (L5) con `new` (un verbo y dos modos,
  decididos por dato: ejecuta el inicializador del lenguaje, construye el
  esqueleto manual o lo aplaza al agente, y normaliza lo que deja el
  inicializador) y `save` (commit guiado cuyo mensaje sale del catálogo y que
  nunca hace push), con 361 comprobaciones en el harness.
- La tabla de inicialización de `scripts/data/languages.tsv` pasa de 5 a 8
  columnas: la leyenda de la guía (✅ verificado · 🔧 ecosistema · ✍️ manual) se
  recupera como dato y se añaden el comando y la normalización, verificados
  ejecutando cada inicializador en un directorio temporal con la entrada
  cerrada: 22 lenguajes con herramienta, 21 de estructura manual y 7 aplazados.
- El catálogo `scripts/data/commits.tsv` pone la tabla de mensajes del sprint en
  datos, y el harness comprueba la deriva entre las dos y que cada alias sea un
  encargo registrado.
- La plantilla `scaffold` se divide: `scaffold` (paso 4a) ajusta el esqueleto a
  lo que exige el módulo y `suite` (paso 4b) escribe la suite desde la
  especificación, con dos commits por paso.
- `glot` v0.10.0: **evidencia y cierre** (L6) con `evidence`, que
  ejecuta la suite y el verificador del módulo y deja el acta con la salida real
  en `docs/evidence/{fase}/{modulo}/{lenguaje}.md` —fecha, rama, commit del
  submódulo, árbol sucio o limpio, comandos, salida tal cual y códigos—, escrita
  también cuando algo está en rojo.
- El harness cierra el círculo del archivado: comprueba que **toda versión
  marcada como cerrada en el log tiene su snapshot** en `scripts/versions/`, y
  que no sobra ninguno. El olvido se ve al confirmar el cierre y no al arrancar
  la versión siguiente, que es como se detectó en las v0.5.0 y v0.6.0.
- `glot` v0.10.0: `close`, que registra el cierre de un módulo en un
  lenguaje —exige la evidencia en verde y los README del módulo y de la fase,
  escribe la entrada del checklist y sube el contador y la lista del roadmap con
  el nombre de presentación—, con `data/display.tsv` como tabla de nombres y
  orden, idempotente, con el diff exacto en `-n` y sin confirmar nada.
- `glot` v0.10.0: `validate`, que pasa el encargo `validate` (paso 6,
  ya versionado) al validador automático y guarda su informe en
  `docs/evidence/…/{lenguaje}.validate.md`. La orden sale de `GLOT_VALIDATOR` y,
  sin ella, de la invocación de Copilot CLI en solo lectura; el veredicto se lee
  de la línea que la plantilla exige y no se adivina. Es opcional: sin validador
  avisa y devuelve `1`, y con hallazgos devuelve `4`.
- `glot` v0.11.0 (en curso): **perfiles de modelo por encargo** (L6.5). Cada
  plantilla de `scripts/prompts/` declara su modelo en el frontmatter (`model:`,
  con el id real que ofrece Copilot, que es clave nativa de los `.prompt.md` de
  VS Code) y [`scripts/data/models.tsv`](scripts/data/models.tsv) fija el
  esfuerzo, el tope de créditos y el tier de auto de cada perfil: `economy`,
  `balanced` y `deep`. El modelo es la clave del perfil, así que el catálogo se
  audita solo y no puede derivar del frontmatter.
- Se auditó el módulo `05_Naive_Sort` en los 50 lenguajes y se abrió
  `docs/audits/` para registrar la deuda técnica por módulo, con criterios,
  estados, método reproducible y plan de cierre.
- Se documentó el alcance real de `.github/prompts/` (plantillas locales que
  `.gitignore` no versiona y que se normalizarán en la L4) en
  `scripts/docs/ROADMAP.md`, `scripts/docs/SPRINT.md` y `docs/WORKFLOW.md`.
- Se abrió la fase `Algorithms Pure` como siguiente fase del roadmap.
- Se estableció el flujo de cierre documental y actualización del roadmap.

### Changed

- `test`, `verify`, `new` y `save` resuelven el lenguaje **desde el directorio**
  cuando no lo traen ni los argumentos ni el estado del sprint: `cd php && glot
  test algorithms/naive_sort` ya funciona sin `use` previo. La precedencia es
  argumentos → estado → directorio, y el estado manda sobre el directorio a
  propósito.
- El aviso de verbo desconocido ya solo sugiere `glot help`: la sugerencia del
  saludo era legado de la v0.2.0.
- Los marcadores de las plantillas y del catálogo de datos pasan a un solo
  vocabulario anclado al estado del sprint: `{modulo}`/`{Modulo}` se renombran a
  `{module}`/`{Module}` en la guía de inicialización (87 ocurrencias) y en
  `scripts/data/languages.tsv` (23), y las plantillas dejan `{lenguaje}`,
  `{fase}` y `{especificacion}` por `{lang}`, `{phase}` y `{spec}`.
- El roadmap reconoce los **50** submódulos registrados en `.gitmodules`: `php`
  entra en el contador y Foundations y `core.algorithms.naive_sort` pasan a
  `50/50`.
- Las plantillas de documentación usan nombres en inglés terminados en
  `_Template`.

### Removed

- El verbo `hello`, alias de compatibilidad de la v0.2.0 que el contrato situaba
  en la v1.0.0: se retira en la v0.10.0 y devuelve `2` como cualquier verbo
  desconocido.

### Fixed

- La clave reservada `repo` se documentaba como «ruta del submódulo dentro del
  monorepo» cuando `use` guarda el **nombre** del submódulo; el contrato ya dice
  lo que hace el código.
- Nueve filas de la tabla de comandos nativos no eran ejecutables como estaban
  (`ada` apuntaba a un directorio inexistente, `kotlin` a un envoltorio ausente,
  `scala` se quedaba esperando sin `-batch`, `prolog`, `tcl-tk` y `scheme`
  necesitaban su propio directorio o banderas, `vala` requería `--pkg glib-2.0`
  y ejecutar el binario, `common-lisp` el `--eval` de salida y `nim` el runner
  de `nimble`). Se corrigen en la guía de inicialización y en el catálogo de
  datos.
- `glot use` no resolvía los módulos cuyo nombre de carpeta o de documento no
  sigue el id del roadmap: `foundations/helloworld` y `foundations/unit_test`
  devolvían `1` (especificación ausente) por un heurístico sobre el nombre del
  archivo. Ahora el catálogo resuelve el id canónico y sondea la carpeta.
- Los contadores `X/49` que quedaban en la documentación pasan a `X/50`
  (Foundations, fase de texto y guía de inicialización, que además incorpora la
  fila y la estructura de `php`).

## [0.1.0] - 2026-09-11

### Added

- Foundations completada y homologada en los 49 submódulos registrados.
- Especificaciones `01_Hello_World.md` a `04_Numbers.md`.
- READMEs de Foundations y documentación de implementación por lenguaje.

[Unreleased]: https://github.com/yorche3/programming_languages/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/yorche3/programming_languages/releases/tag/v0.1.0
