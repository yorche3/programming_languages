# 🧾 Plantilla de README de módulo (Nivel 3) / Module README template (Level 3)

**ES:** Plantilla **única** del README de módulo-lenguaje, que vive en `{lenguaje}/core/{fase}/{modulo}/README.md`. Todas las secciones de abajo son **obligatorias** salvo las marcadas como _(si aplica)_: cuando un módulo no tenga nada que decir en una sección, la sección se escribe igualmente con `No aplica / Not applicable` y una línea de por qué. Un README al que le falte una sección es un incumplimiento que el encargo `docs-module` y `glot validate` pueden comprobar. También es la base del README de fase (Nivel 2), reducido a _Archivos y estructura_, _Cómo se ejecuta_ y _Notas de la fase_.

**EN:** The **single** template for the per-language module README, living at `{lenguaje}/core/{fase}/{modulo}/README.md`. Every section below is **mandatory** except those marked _(if applicable)_: when a module has nothing to say in a section, the section is still written with `No aplica / Not applicable` and one line saying why. A README missing one is a breach that the `docs-module` request and `glot validate` can check. It is also the base for the phase README (Level 2), reduced to _Files & Structure_, _How it runs_ and _Phase notes_.

**ES:** Plantilla vigente desde la revisión de documentación del 2026-09-25. Los READMEs ya escritos se alinean **al revisarlos** (el checklist de [`WORKFLOW.md`](WORKFLOW.md) dice cuándo), no en un barrido aparte.

**EN:** Template in force since the documentation review of 2026-09-25. Existing READMEs are brought in line **when they are reviewed** (the checklist in [`WORKFLOW.md`](WORKFLOW.md) says when), not in a separate sweep.

---

## 🧱 Niveles / Levels

**ES:** El README de un lenguaje se escribe en **tres niveles** y cada uno responde a una pregunta distinta. Los niveles 1 y 2 son **índices**: dicen qué hay dentro de la carpeta y cómo se ejecuta, sin repetir el detalle de los módulos, que vive en el nivel 3.

**EN:** A language's README is written in **three levels** and each answers a different question. Levels 1 and 2 are **indexes**: they say what is inside the folder and how it runs, without repeating the modules' detail, which lives in level 3.

| Nivel / Level | Fichero / File | Pregunta que responde / Question it answers |
|:-------------:|----------------|--------------------------------------------|
| 1 | `{lenguaje}/README.md` | ¿Qué hay en este submódulo y cómo se ejecuta? / What is in this submodule and how does it run? |
| 2 | `{lenguaje}/core/README.md` y `{lenguaje}/core/{fase}/README.md` | ¿Qué fases o módulos hay en esta carpeta y cómo se ejecutan? / What phases or modules are in this folder and how do they run? |
| 3 | `{lenguaje}/core/{fase}/{modulo}/README.md` | ¿Cómo está implementado este módulo? / How is this module implemented? (plantilla de abajo / template below) |

### Nivel 1 — `{lenguaje}/README.md`

| Sección / Section | Contenido / Contents |
|-------------------|----------------------|
| Título y presentación / Title and introduction | Nombre del lenguaje y una o dos frases: qué implementa el submódulo y con qué toolchain / Language name and one or two sentences: what the submodule implements and with which toolchain |
| `📂 Módulos / Modules` | Tabla de **una fila por carpeta de primer nivel**: ruta, fases y módulos que contiene / Table with **one row per top-level folder**: path, phases and modules it contains |
| `▶️ Comenzar / Getting Started` | Comandos reales, al menos uno por tipo de proyecto / Real commands, at least one per project type |
| `📦 Requisitos / Requirements` o `📋 Toolchain` | Herramientas, versiones e instalación / Tools, versions and installation |
| `🏗️ Tipos de proyecto / Project Types` | Los formatos de proyecto del lenguaje, con su estructura mínima / The language's project formats, with their minimal structure |
| Secciones propias del lenguaje / Language-specific sections | Solo si aportan: convenciones de pruebas, decisiones del lenguaje / Only when they add value: test conventions, language decisions |
| `🌐 Otras implementaciones / Other implementations` | Cierre común del repositorio / Common repository closing |

### Nivel 2 — `{lenguaje}/core/README.md` y `{lenguaje}/core/{fase}/README.md`

**ES:** El de `core/` es el más corto: tabla de fases con su estado y contenido, y el enlace de vuelta. El de la carpeta de fase es el índice de esa fase.

**EN:** The `core/` one is the shortest: a table of phases with their status and contents, and the back link. The phase folder one is that phase's index.

| Sección / Section | Contenido / Contents |
|-------------------|----------------------|
| Título y presentación / Title and introduction | `{Fase} — {Lenguaje}` y lo que comparten sus módulos / `{Phase} — {Language}` and what its modules share |
| `📂 Módulos / Modules` | Una fila por módulo: enlace a su carpeta, especificación, enfoque, número de pruebas y estado / One row per module: link to its folder, specification, approach, test count and status |
| `📁 Estructura / Structure` | Árbol real de la carpeta de la fase / Real tree of the phase folder |
| `🛠️ Patrón común / Common Pattern` | Lo que comparten los módulos: runtime, CLI, andamiaje, framework de pruebas, separación de carpetas, artefactos / What the modules share: runtime, CLI, scaffolding, test framework, folder split, artifacts |
| `🚀 Compilación rápida / Quick Build` | Los comandos de la fase, reales / The phase's real commands |
| `▶️ Siguiente / Next` | Cierre con enlace al roadmap / Closing with a roadmap link |
| Pie común / Common footer | Vuelta al nivel superior y pie del repositorio / Back to the upper level and repository footer |

**ES:** Reglas de los índices: (1) no repiten el detalle que ya está en el README de nivel 3; (2) **no listan módulos que no existen** en la carpeta; (3) un módulo pendiente se lista con `📋` y **sin enlace** a una carpeta que aún no existe; (4) cada enlace relativo tiene que resolver dentro del repositorio del lenguaje.

**EN:** Index rules: (1) they do not repeat detail already in the level-3 README; (2) they **do not list modules that are not** in the folder; (3) a pending module is listed with `📋` and **no link** to a folder that does not exist yet; (4) every relative link must resolve inside the language repository.

---

# {Nombre del Módulo} — {Lenguaje}

Implementación de la especificación [{ID de la especificación}]({Enlace a la especificación}) en **{Lenguaje}**, con un enfoque manual y minimalista.

**ES:** Una o dos frases más sobre **qué** se implementa y con **qué** se ejecuta (framework de pruebas, gestor de dependencias). Sin adjetivos de valor.

**EN:** One or two more sentences about **what** is implemented and **what** runs it (test framework, dependency manager). No value adjectives.

---

## 📂 Archivos y estructura / Files & Structure

Describe la estructura del proyecto y el propósito de cada archivo.

| Archivo / Directory | Propósito / Purpose |
|---|---|
| `src/{modulo}.ext` | Código fuente principal / Main source code |
| `tests/` | Pruebas unitarias, si aplica / Unit tests, if applicable |
| `{build_config}` | Configuración de construcción / Build configuration |
| `{manifest}` | Dependencias, si aplica / Dependencies, if applicable |
| `.gitignore` | Archivos generados excluidos / Ignored generated files |

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Explica si el proyecto se creó manualmente o con herramientas del
lenguaje e incluye los comandos reales de inicialización, cuando sean útiles.

**EN:** Explain whether the project was created manually or with language tools
and include real initialization commands when useful.

**ES:** Si el layout real **se desvía** del que propone la especificación en «Ubicación esperada», se dice en _Archivos y estructura_ y se justifica. Los comandos de inicialización por lenguaje son los de [`core/00_Project_Initialization_Guide.md`](core/00_Project_Initialization_Guide.md): aquí solo se copian los que se ejecutaron de verdad.

**EN:** If the real layout **deviates** from the one the specification proposes under "Expected Location", say so under _Files & Structure_ and justify it. Per-language initialisation commands belong to [`core/00_Project_Initialization_Guide.md`](core/00_Project_Initialization_Guide.md): here you copy only the ones actually run.

## 📄 Configuración clave / Key Configuration

Describe los archivos de build, manifiestos y configuración relevantes. No
incluyas dependencias ni capacidades que no hayas verificado.

## 🚀 Compilación y ejecución / Build & Run

```bash
{comando_de_compilación}
{comando_de_ejecución}
{comando_ejecutar_pruebas}
```

**Salida real / Actual output:**

```text
{salida_verificada_de_compilacion_y_tests}
```

**ES:** La salida se copia **de la última ejecución real**, sin editar ni resumir a mano; si es muy larga, se copian sus líneas finales y se enlaza el acta de evidencia del sprint en `docs/evidence/{fase}/{modulo}/{lenguaje}.md`.

**EN:** The output is copied **from the last real run**, unedited; when it is too long, copy its final lines and link the sprint evidence record under `docs/evidence/{fase}/{modulo}/{lenguaje}.md`.
**ES:** Única edición permitida sobre la salida: si incluye la ruta del directorio personal, se abrevia como `~` para no versionar rutas de la máquina.

**EN:** The only allowed edit to the output: when it includes the home directory path, it is abbreviated as `~` so no machine paths are versioned.
## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `{funcion_u_operacion}` | `{tipo_entrada → tipo_salida}` | `{O(...)}` | `{particularidad}` |

**ES:** Una fila por operación del contrato. Cuando el módulo tenga varios enfoques del mismo algoritmo (recursivo, con acumulador, iterativo), la columna de notas es donde se dice cuál es cuál.

**EN:** One row per contract operation. When the module has several approaches to the same algorithm (recursive, accumulator, iterative), the notes column is where each one is named.

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| `{quée se eligió}` | `{quée se descartó}` | `{por qué}` |

**ES:** Solo las decisiones donde había más de un camino razonable: representación interna, mutabilidad, estructura de la suite, forma del valor devuelto. Si no hubo ninguna decisión con alternativa real, se escribe `No aplica / Not applicable` y por qué. **Prohibido** justificar con «es más idiomático» sin decir qué gana el lector con ello.

**EN:** Only decisions where more than one path was reasonable: internal representation, mutability, suite structure, return shape. With no real alternative, write `No aplica / Not applicable` and why. **Do not** justify with "more idiomatic" without saying what the reader gains.

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| `{quée dice la especificación}` | `{quée hace esta implementación}` | `{por qué, con la limitación del lenguaje}` |

**ES:** Aquí van las desviaciones del pseudocódigo o de la ubicación esperada, no las decisiones de estilo. Es la tabla que el encargo `docs-module` cita como **Nota Aclaratoria**: una desviación sin fila aquí es un hallazgo. Cuando una parte de la especificación **no es representable** en el lenguaje (por ejemplo, la entrada nula en Haskell), se documenta aquí con el nombre del caso omitido y la razón. Las reglas de una adaptación y las familias de limitación por lenguaje están en [`AGENT_Template.md`](AGENT_Template.md).

**EN:** Deviations from the pseudocode or from the expected location belong here, not style choices. This is the table the `docs-module` request cites as the **Clarifying Note**: a deviation with no row here is a finding. When part of the specification is **not representable** in the language (for example, the null input in Haskell), it is documented here with the omitted case name and the reason. The rules of an adaptation and the limitation families per language are in [`AGENT_Template.md`](AGENT_Template.md).

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `{operacion}` | `{entrada nula, vacío, límite…}` | `{null, nil, None, -1, #f, no representable…}` | `{valor devuelto}` |

**ES:** Una fila por operación del contrato y una fila para el caso nulo o inválido. Si el indicador **no es representable** (el tipo no admite `null`/`nil` y la fase prohíbe `Option`/`Maybe`/`Result`), se escribe `No representable` en la columna de indicador y se explica en adaptaciones qué caso se omite y por qué. No se inventan centinelas que el lenguaje no pueda devolver.

**EN:** One row per contract operation plus one row for the null or invalid input. When the indicator is **not representable** (the type admits no `null`/`nil` and the phase forbids `Option`/`Maybe`/`Result`), write `Not representable` in the indicator column and explain under adaptations which case is omitted and why. Never invent sentinels the language cannot return.

## ✅ Cobertura de pruebas / Test coverage

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|---|:--:|---|
| `{caso}` | `Sí / No / Omitido` | `{nombre o fichero:línea}` | `{razón si se omite}` |

**ES:** Trazabilidad **caso → prueba**: una fila por cada caso de la tabla «Casos de prueba» de la especificación. Los casos omitidos (no representables) van con `Omitido` y la razón, nunca en blanco. El número total de pruebas se declara además en la salida real de la sección de compilación.

**EN:** **Case → test** traceability: one row per case in the specification's "Test Cases" table. Omitted cases (not representable) go in as `Omitted` with the reason, never blank. The total number of tests is also stated in the real output of the build section.

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| `{quée no se pudo hacer}` | `{a quién afecta}` | `{cómo se mitiga o qué fase lo cubre}` |

**ES:** Limitaciones por el lenguaje o por la fase, no defectos pendientes: si algo no cumple el contrato, no es una limitación, es un hallazgo. Sin limitaciones conocidas, `Ninguna / None` y una línea de por qué se puede afirmar eso.

**EN:** Limitations from the language or the phase, not pending defects: if something fails the contract, it is not a limitation, it is a finding. With no known limitations, `Ninguna / None` plus one line saying why that can be claimed.

## 📝 Notas de implementación / Implementation Notes

Documenta aquí las particularidades verificadas del lenguaje: recursión,
iteración, TCO, manejo de errores, tipos de retorno, memoria y organización de
tests. Si el lenguaje no garantiza TCO, explica el papel educativo de la
versión con acumulador y qué tests cubren su comportamiento.

**ES:** Este proyecto también está implementado en otros lenguajes. Explora el
repositorio principal para consultar las demás versiones.

**EN:** This project is also implemented in other languages. Explore the main
repository to see the other versions.

## 🔍 Checklist de validación / Validation checklist

- [ ] La suite nativa se ejecutó y su salida real está copiada en este README.
- [ ] Cada caso de la especificación tiene su fila en _Cobertura de pruebas_ (o `Omitido` con razón).
- [ ] Cada desviación del pseudocódigo o de la ubicación esperada está en _Adaptaciones idiomáticas_.
- [ ] Cada operación con fallo posible está en _Indicadores de fallo_.
- [ ] No hay rutas absolutas del autor, credenciales ni salidas inventadas.
- [ ] Los enlaces relativos resuelven dentro del repositorio y el documento es bilingüe.
- [ ] Ninguna sección repite lo que ya dice la especificación.

**EN:** The full list, per artefact, lives in [`WORKFLOW.md`](WORKFLOW.md); these seven points are the minimum for the module README.

## 📚 Referencias / References

| Tipo / Kind | Referencia / Reference |
|---|---|
| Especificación / Specification | [`{NN}_{Modulo}.md`]({ruta relativa a docs/core}) |
| Módulo homologado del lenguaje / Homologated module | [`{lenguaje}/core/foundations/numbers/`]({ruta relativa}) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](core/00_Project_Initialization_Guide.md) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](AGENT_Template.md) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](WORKFLOW.md) |
| Documentación oficial del lenguaje / Language official docs | `{enlace verificado}` |

**ES:** Solo referencias que se hayan consultado de verdad y sigan resolviendo. Los enlaces a documentación oficial son los únicos enlaces externos permitidos en un README de módulo.

**EN:** Only references actually consulted and still resolving. Links to official documentation are the only external links allowed in a module README.
