# 🎚️ Niveles de Idiomaticidad / Idiomaticity Levels

> **ES:** Este documento define la **escala de 4 niveles** con la que se clasifica cada implementación de cada módulo en cada lenguaje. El nivel **no es una opinión**: se calcula aplicando una lista de verificación binaria por eje. Es la pieza que convierte la auditoría en un procedimiento reproducible.
>
> **EN:** This document defines the **4-level scale** used to classify every implementation of every module in every language. The level is **not an opinion**: it is computed by applying a binary checklist per axis. It is the piece that turns the audit into a reproducible procedure.

---

## 🧭 Principios / Principles

**ES:** Tres reglas gobiernan la escala.

**EN:** Three rules govern the scale.

1. **ES:** El nivel se calcula **por (lenguaje, módulo)**, no por lenguaje. Un mismo lenguaje puede tener `naive_sort` en `idiomatic` y `data_structures_basics` en `transitional`.
   **EN:** The level is computed **per (language, module)**, not per language. The same language may have `naive_sort` at `idiomatic` and `data_structures_basics` at `transitional`.

2. **ES:** El nivel final es el **mínimo de los ejes evaluados**. Una sola desviación bloqueante baja el nivel, aunque el resto sea perfecto.
   **EN:** The final level is the **minimum across evaluated axes**. A single blocking deviation lowers the level, even if everything else is perfect.

3. **ES:** Solo se evalúan los ejes que **aplican al lenguaje**. Un eje marcado como `N/A` no cuenta para el mínimo.
   **EN:** Only axes **applicable to the language** are evaluated. An axis marked `N/A` does not count towards the minimum.

---

## 🎚️ Los cuatro niveles / The four levels

### Nivel 1 — `idiomatic` ✅

**ES:** La implementación sigue **todas las convenciones idiomáticas** del lenguaje y del módulo. Cero desviaciones sin documentar. Es el estado objetivo.

**EN:** The implementation follows **all idiomatic conventions** of the language and the module. Zero undocumented deviations. This is the target state.

**Criterios de aceptación / Acceptance criteria:**

| # | Criterio / Criterion | Verificable por / Verified by |
|:-:|---------------------|-------------------------------|
| 1 | Constructor idiomático (`new`, `T.new`, `make-T`, `T(v)`, `T::new`, según lenguaje) | Inspección del `init`/`constructor` |
| 2 | Nombres según convención del lenguaje (`camelCase`, `snake_case`, `kebab-case`) | Inspección de firmas |
| 3 | Indicador de fallo según modelo idiomático (`Option`, `Result`, `null`, `nil`, `{}`) | Inspección de tipos de retorno |
| 4 | Acceso vía propiedad/getter idiomático (no `get_X()` cuando el lenguaje usa `x`) | Inspección de API pública |
| 5 | Constructor no devuelve valor inapropiado (no `nil`, no `undefined`, no `null`) | Test de instanciación |
| 6 | Sin `unsafe`, `@Suppress`, `#[allow]`, `unwrap`, `!!` en código de producción | Grep de tokens |
| 7 | Campos privados de acuerdo al contrato (representación oculta) | Inspección de visibilidad |
| 8 | Complejidad declarada en README, incluso si difiere de la spec | Lectura del README |
| 9 | Errores idiomáticos (sin excepciones si el lenguaje no las usa) | Inspección del flujo de fallo |
| 10 | Cero desviaciones sin documentar | Comparación con `PSEUDOCODE_CONVENTION.md` |
| 11 | Nombres canónicos mapeados (concepto → nombre del lenguaje) presentes en README | Comparación con `canonical_names.tsv` |
| 12 | Pruebas en verde, sin warnings nuevos | Salida de `test` + `verify` |

**ES:** Los 12 criterios deben cumplirse. Basta con fallar uno para bajar de nivel.

**EN:** All 12 criteria must be met. Failing one is enough to drop down.

**Ejemplos esperados / Expected examples:** C# ideal, Kotlin ideal, Ruby ideal, Rust ideal (con `Option<Box<Node>>`), Go ideal, Swift ideal.

---

### Nivel 2 — `mostly-idiomatic` 🟢

**ES:** La implementación es **casi idiomática**, con 1–2 desviaciones **menores y documentadas** respecto a la convención del lenguaje. Los criterios estructurales están todos bien.

**EN:** The implementation is **almost idiomatic**, with 1–2 **minor, documented deviations** from the language's convention. All structural criteria are met.

**Criterios de aceptación / Acceptance criteria:**

| # | Criterio / Criterion | Estado |
|:-:|---------------------|:------:|
| 1 | Constructor idiomático | ✅ obligatorio |
| 2 | Indicador de fallo idiomático | ✅ obligatorio |
| 3 | Acceso vía propiedad/getter idiomático | ✅ obligatorio |
| 4 | Constructor no devuelve valor inapropiado | ✅ obligatorio |
| 5 | Sin `unsafe`/`@Suppress`/`#[allow]` sin justificación | ✅ obligatorio |
| 6 | Campos privados | ✅ obligatorio |
| 7 | Complejidad declarada | ✅ obligatorio |
| 8 | Cero desviaciones **no documentadas** | ✅ obligatorio |
| 9 | ≤ 2 desviaciones de nombre respecto a la convención | ⚠️ permitido |
| 10 | Cada desviación documentada en README del lenguaje | ⚠️ obligatorio |
| 11 | Nombres canónicos mapeados | ⚠️ permitido 1 faltante |
| 12 | Pruebas en verde | ✅ obligatorio |

**ES:** La frontera con `idiomatic` es: existe **al menos una desviación documentada** (de nombre o mapeo) pero **ninguna estructural**.

**EN:** The boundary with `idiomatic` is: there is **at least one documented deviation** (name or mapping) but **none structural**.

**Ejemplos esperados / Expected examples:** Kotlin con `getValue()` en vez de `value` (documentado). Ruby con `delete` (paridad con la spec) en vez de `remove` (documentado). TypeScript con `snake_case` en un módulo (documentado). Go con `Size()` en vez de `Len()` (documentado).

---

### Nivel 3 — `transitional` 🟡

**ES:** La implementación **funciona** (compila, pasa los tests) pero **no es idiomática**. Hay desviaciones estructurales: construcción no idiomática, indicador de fallo no idiomático, o múltiples nombres traducidos directamente del pseudocódigo. Es un estado **de tránsito**: se está migrando activamente hacia `mostly-idiomatic` o `idiomatic`.

**EN:** The implementation **works** (compiles, tests pass) but **is not idiomatic**. There are structural deviations: non-idiomatic construction, non-idiomatic failure indicator, or multiple names directly translated from pseudocode. It is a **transitional state**: actively migrating towards `mostly-idiomatic` or `idiomatic`.

**Criterios de aceptación / Acceptance criteria:**

| # | Criterio / Criterion | Estado |
|:-:|---------------------|:------:|
| 1 | Compila sin errores | ✅ obligatorio |
| 2 | Pruebas en verde | ✅ obligatorio |
| 3 | Sin `unsafe`/`unwrap` que rompa el contrato | ✅ obligatorio |
| 4 | Constructor **NO** idiomático (ej. `init()` como método) | ⚠️ típico |
| 5 | Indicador de fallo **NO** idiomático (ej. `-1` en lenguaje con `Option`) | ⚠️ típico |
| 6 | Varios nombres traducidos literalmente (`get_value`, `set_next`) | ⚠️ típico |
| 7 | Desviaciones **documentadas** en README | ⚠️ obligatorio |
| 8 | Existe una nota de "migración pendiente" o similar | ⚠️ recomendado |

**ES:** La frontera con `mostly-idiomatic` es: la desviación afecta a **estructura (constructor o fallo)**, no solo al nombre.

**EN:** The boundary with `mostly-idiomatic` is: the deviation affects **structure (constructor or failure)**, not just the name.

**Ejemplos esperados / Expected examples:** El estado actual (octubre 2026) de varios lenguajes que revisamos — D con `init()`, Kotlin con `get_value`, Dart con `bool?` en `delete`, Go con `-1` en `Pop`, Vala con `get_value()`, Haxe con `init()`, ReScript con `Js.Nullable`, Rust con `*mut Node`.

---

### Nivel 4 — `workaround` 🔴

**ES:** La implementación **compila y probablemente pasa los tests**, pero **pelea contra el lenguaje**. Usa mecanismos que el lenguaje ofrece para casos extremos (`unsafe`, `#[allow]`, `@Suppress`, `fatalError` en `init`) donde no debería. La construcción está rota, la representación es antinatural, o la implementación se apoya en supuestos incorrectos.

**EN:** The implementation **compiles and probably passes tests**, but **fights against the language**. It uses mechanisms the language reserves for extreme cases (`unsafe`, `#[allow]`, `@Suppress`, `fatalError` inside `init`) where it should not. Construction is broken, the representation is unnatural, or the implementation relies on incorrect assumptions.

**Criterios de aceptación / Acceptance criteria:**

| # | Criterio / Criterion | Estado |
|:-:|---------------------|:------:|
| 1 | Compila | ✅ |
| 2 | Alguno de los siguientes (≥ 1) | ⚠️ obligatorio |
|   | — `unsafe` sin justificación | 🔴 |
|   | — `#[allow]`/`@Suppress`/`// nolint` que silencia un warning real | 🔴 |
|   | — Constructor devuelve `nil`/`undefined`/`null`/`fatalError` | 🔴 |
|   | — Representación no idiomática (ej. `*mut Node` en Rust) | 🔴 |
|   | — `unwrap()`/`!!`/`force unwrap` en código de producción | 🔴 |
| 3 | Existe una nota en README explicando la deuda técnica | ⚠️ obligatorio |

**ES:** Es un estado **aceptable temporalmente** pero **no puede ser el estado final** del módulo. La auditoría debe marcarlo como pendiente de corrección.

**EN:** It is a **temporarily acceptable** state but **cannot be the final state** of the module. The audit must flag it as pending correction.

**Ejemplos esperados / Expected examples:** Rust con `*mut Node` (debería ser `Option<Box<Node>>`), Rust con `unsafe { nil }`, Swift con `fatalError` en `init`, ooRexx con `init` devolviendo `.Nil`, D con `delete` como nombre de método, cualquier lenguaje con `unwrap()` en la ruta de éxito.

---

## 🧭 Los dos ejes principales / The two principal axes

**ES:** El estado de idiomaticidad se lee en **dos ejes principales**, y el detalle de los nueve ejes explica *por qué* cada uno está donde está.

**EN:** The idiomaticity state is read on **two principal axes**, and the detail of the nine axes explains *why* each one sits where it sits.

| Eje principal / Principal axis | Qué mide / What it measures | Valores / Values | Dónde vive / Where it lives |
|---|---|---|---|
| **1 — `idiomatic_target`** (objetivo idiomático pleno) | Estructura, variante de implementación, guardas, manejo de errores y uso de lo que dicen las buenas prácticas del lenguaje | `pendiente` · `en-curso` · `cumplido` | Es el **propósito final**: hoy los 50 están en `pendiente`. Cuando un lenguaje deje de estarlo, se añade la columna `idiomatic_target` al TSV |
| **2 — `module_fidelity`** (cercanía a lo que pide el módulo) | Cuánto se acerca la implementación a **lo que exige el módulo** y a las **idioms del lenguaje** | `idiomatic` · `mostly-idiomatic` · `transitional` · `workaround` · `not-audited` · `not-started` | Columna `module_fidelity` de `data/idiomaticity_state.tsv` |

**ES:** El **eje 2** es el que calcula el algoritmo de la sección siguiente ( mínimo de los ejes aplicables). El **eje 1** se revisa aparte: no depende de un módulo, depende del dominio de las prácticas del lenguaje, y por eso arranca en `pendiente` para todos.

**EN:** **Axis 2** is what the algorithm in the next section computes (minimum over applicable axes). **Axis 1** is reviewed separately: it does not depend on a module, it depends on mastery of the language's practices, which is why it starts at `pendiente` for everyone.

**ES:** Los **9 ejes de detalle** (`construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation`, `tests`) alimentan a los dos principales: su mínimo da el eje 2, y los que quedan bajos señalan exactamente qué separa al módulo del eje 1.

**EN:** The **9 detail axes** (`construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation`, `tests`) feed the two principal ones: their minimum yields axis 2, and the low ones point to exactly what separates the module from axis 1.

---

## 🔬 Evaluación por eje / Per-axis evaluation

**ES:** Para calcular el nivel de un (lenguaje, módulo), se evalúa cada eje de forma **independiente** y se toma el **mínimo**.

**EN:** To compute the level of a (language, module), each axis is evaluated **independently** and the **minimum** is taken.

| Eje / Axis | Qué evalúa / What it evaluates | Fuente / Source |
|-----------|-------------------------------|-----------------|
| `construction` | Idiomaticidad del constructor | `canonical_names.tsv` fila `constructor` |
| `naming` | Convención de nombres del lenguaje | `canonical_names.tsv` columnas de acceso |
| `failure` | Modelo de fallo idiomático | `canonical_names.tsv` columna `ausencia` |
| `access` | Propiedades vs métodos | `canonical_names.tsv` columna `acceder valor` |
| `encapsulation` | Campos privados, representación oculta | Inspección de la API pública |
| `unsafe` | Uso de mecanismos peligrosos | Grep de `unsafe`, `#[allow]`, `unwrap` |
| `complexity` | Complejidad real vs declarada | Lectura del README |
| `documentation` | Desviaciones documentadas | README del lenguaje |
| `tests` | Suite en verde | Salida de `test` |

**ES:** Los ejes no aplicables (ej. `unsafe` en Python, `construction` en Prolog) se marcan `N/A` y no cuentan.

**EN:** Non-applicable axes (e.g. `unsafe` in Python, `construction` in Prolog) are marked `N/A` and do not count.

---

## 🧮 Cómo se calcula el nivel / How the level is computed

**ES:** Algoritmo reproducible.

**EN:** Reproducible algorithm.
para cada (lenguaje, módulo):
evaluar cada eje aplicable:
idiomatic si cumple TODOS los criterios de N1
mostly-idiomatic si cumple TODOS los obligatorios de N2
transitional si cumple TODOS los obligatorios de N3
workaround en otro caso

nivel = min(nivel_de_cada_eje_evaluado)

documentar el eje más bajo como el "eje bloqueante"
text

for each (language, module):
evaluate each applicable axis:
idiomatic if it meets ALL N1 criteria
mostly-idiomatic if it meets ALL N2 mandatory criteria
transitional if it meets ALL N3 mandatory criteria
workaround otherwise

level = min(level_of_each_evaluated_axis)

document the lowest axis as the "blocking axis"
text


> **ES:** Alcance **técnico**: la escala sirve para medir cuán idiomática es una implementación y para registrar la desviación cuando no lo es. Define **2 ejes principales** —objetivo idiomático y fidelidad al módulo— y **9 ejes de detalle** que los alimentan. La firma **Software Architect** (apoyo: *SDET*). El seguimiento editorial (changelog, actas de cierre) queda fuera de su alcance; ver [`AGENT_ROLES.md`](../AGENT_ROLES.md).
>
> **EN:** **Technical** scope: the scale measures how idiomatic an implementation is and records the deviation when it is not. It defines **2 principal axes** —idiomatic target and module fidelity— and **9 detail axes** feeding them. Signed by **Software Architect** (support: *SDET*). Editorial tracking (changelog, closure records) is out of scope; see [`AGENT_ROLES.md`](../AGENT_ROLES.md).

**ES:** El resultado se escribe en `docs/ruleset/data/idiomaticity_state.tsv` (**ya creado**, con la auditoría del módulo `data_structures_basics`). La columna `module_fidelity` es el eje principal 2; el eje principal 1 (`idiomatic_target`) es `pendiente` en los 50 y se documenta arriba. Los 50 lenguajes se agrupan en las cuatro variantes de [`PSEUDOCODE_CONVENTION.md`](PSEUDOCODE_CONVENTION.md) —V1 35 · V2 14 · V4 1 = 50, con V3 como clase transversal— y el nivel se evalúa por (lenguaje, módulo), no por lenguaje. Los casos ya medidos que alimentan esta escala están en la sección *Casos medidos en la homologación* de ese mismo documento.

**EN:** The result is written to `docs/ruleset/data/idiomaticity_state.tsv` (**already created**, with the `data_structures_basics` audit). The `module_fidelity` column is principal axis 2; principal axis 1 (`idiomatic_target`) is `pendiente` for all 50 and is documented above. The 50 languages are grouped into the four variants of [`PSEUDOCODE_CONVENTION.md`](PSEUDOCODE_CONVENTION.md) —V1 35 · V2 14 · V4 1 = 50, with V3 as a cross-cutting class— and the level is evaluated per (language, module), not per language. The cases already measured that feed this scale are in the *Cases measured during homologation* section of that same document.

| `language` | `module` | `idiomatic_target` | `module_fidelity` | `blocking_axis` | `notes` | `commit` | `last_updated` |
|-----------|----------|:------------------:|:-----------------:|:---------------:|---------|----------|----------------|
| `csharp` | `data_structures_basics` | `pendiente` | `mostly-idiomatic` | `naming` | Revisado con el autor; desviaciones sin documentar | `ed24829` | 2026-10-12 |
| `kotlin` | `data_structures_basics` | `pendiente` | `transitional` | `naming` | `get_value` en vez de `value` | `b7ae5fa` | 2026-10-12 |
| `rust` | `data_structures_basics` | `pendiente` | `workaround` | `unsafe` | `*mut Node` en vez de `Option<Box<Node>>` | `3e8204a` | 2026-10-12 |
| `elm` | `data_structures_basics` | `pendiente` | `workaround` | `construction` | Constructores vacíos; sin `Maybe` | `1fc72c2` | 2026-10-12 |

---

## 🔀 Transiciones de estado / State transitions

**ES:** Un lenguaje × módulo puede **subir** de nivel. Las transiciones documentan el trabajo hecho.

**EN:** A language × module can **move up** a level. Transitions document the work done.

| De → A | Se hace cuando / Triggered when |
|--------|--------------------------------|
| `workaround` → `transitional` | Se elimina el mecanismo de `unsafe`/`#[allow]`/`fatalError`; la construcción ya no revienta |
| `transitional` → `mostly-idiomatic` | El constructor se vuelve idiomático y el indicador de fallo también; quedan solo desviaciones de nombre |
| `mostly-idiomatic` → `idiomatic` | Se eliminan las últimas desviaciones de nombre |
| `idiomatic` → `mostly-idiomatic` | Se introduce una nueva desviación (raro; solo si cambia la spec) |

**ES:** Las transiciones **nunca son automáticas**. Requieren un commit que cambie el código y un commit que actualice `idiomaticity_state.tsv`. La justificación va en el changelog del lenguaje.

**EN:** Transitions are **never automatic**. They require a commit changing the code and a commit updating `idiomaticity_state.tsv`. The justification goes in the language's changelog.

---

## ⚖️ Ejemplos de evaluación completa / Full evaluation examples

### Ejemplo 1 — Kotlin actual (transicional)

Axis	Result	Reason
construction	transitional	init() as method instead of new
naming	transitional	get_value instead of value
failure	idiomatic	uses Int?
access	transitional	methods instead of properties
encapsulation	idiomatic	private fields
unsafe	N/A	
complexity	idiomatic	O(1) declared
documentation	transitional	deviations not documented yet
tests	idiomatic	passing
────────────────────────────────────────────────────────────────		
Final level	transitional	
Blocking axes	construction, naming, access, documentation	
text


### Ejemplo 2 — Rust actual (workaround)

Axis	Result	Reason
construction	transitional	init() instead of new()
naming	transitional	get_value / get_next
failure	workaround	-1 instead of Option<i32>
access	transitional	methods instead of fields
encapsulation	idiomatic	private fields
unsafe	workaround	*mut Node with ptr::null_mut()
complexity	idiomatic	O(1) for insert_head
documentation	transitional	deviations not documented
tests	idiomatic	passing
────────────────────────────────────────────────────────────────		
Final level	workaround	
Blocking axes	failure, unsafe	
text


### Ejemplo 3 — Ruby ideal (idiomático)

Axis	Result	Reason
construction	idiomatic	Node.new(v)
naming	idiomatic	attr_accessor :value
failure	idiomatic	nil
access	idiomatic	properties
encapsulation	idiomatic	private fields
unsafe	N/A	
complexity	idiomatic	O(1) declared
documentation	idiomatic	no deviations
tests	idiomatic	passing
────────────────────────────────────────────────────────────────		
Final level	idiomatic	
Blocking axes	(none)	
text


---

## 📋 Criterios de aceptación del propio documento / Acceptance criteria

**ES:** Este documento se considera correcto cuando:

**EN:** This document is considered correct when:

- [ ] Los 4 niveles tienen criterios binarios verificables.
- [ ] Cada eje de evaluación tiene fuente declarada en `canonical_names.tsv` o inspección directa.
- [ ] El algoritmo de cálculo está en pseudocódigo reproducible.
- [ ] Hay 3 ejemplos completos que cubren 3 niveles distintos.
- [ ] Las transiciones están definidas y son trazables.
- [ ] El documento no opina: solo describe criterios.

---

## 🔗 Referencias / References

- [`ruleset/PSEUDOCODE_CONVENTION.md`](PSEUDOCODE_CONVENTION.md) — El contrato del pseudocódigo.
- [`ruleset/LANGUAGE_CHARACTERISTICS.md`](LANGUAGE_CHARACTERISTICS.md) — Los 11 ejes por lenguaje.
- `ruleset/DEVIATION_POLICY.md` (por crear / to be created) — Cómo documentar cada desviación.
- [`ruleset/PARADIGM_FAMILIES.md`](PARADIGM_FAMILIES.md) — La agrupación de los 50 lenguajes.
- `ruleset/data/idiomaticity_state.tsv` (por crear / to be created) — El estado actual por (lenguaje, módulo).
- [`ruleset/data/canonical_names.tsv`](data/canonical_names.tsv) — La tabla de traducción máquina-legible.

---

*Última actualización / Last update: 2026-10-12*