# ⚠️ Política de Desviaciones / Deviation Policy

> **ES:** Este documento define **qué cuenta como desviación**, **cuándo está permitida**, **dónde se documenta** y **cómo se valida**. Es el complemento operativo del `PSEUDOCODE_CONVENTION.md`: allí se fijó el contrato canónico, aquí se define cómo registrar la distancia entre ese contrato y la implementación real. Sin este documento, la auditoría sería una opinión; con él, es un procedimiento.
>
> **EN:** This document defines **what counts as a deviation**, **when it is allowed**, **where it is documented** and **how it is validated**. It is the operational complement of `PSEUDOCODE_CONVENTION.md`: the canonical contract was set there, here we define how to record the distance between that contract and the real implementation. Without this document, the audit would be an opinion; with it, it is a procedure.

---

## 🎯 Qué es una desviación / What is a deviation

> **ES:** El **pseudocódigo esperado por familia** —la capa que dice qué se puede escribir en cada grupo de lenguajes— vive en [`PARADIGM_FAMILIES.md`](PARADIGM_FAMILIES.md). Este documento define qué hacer cuando una implementación aún se aleja de él.
>
> **EN:** The **expected pseudocode per family** —the layer stating what can be written in each group of languages— lives in [`PARADIGM_FAMILIES.md`](PARADIGM_FAMILIES.md). This document defines what to do when an implementation still departs from it.

**ES:** Una **desviación** es cualquier diferencia entre el pseudocódigo canónico (definido en `PSEUDOCODE_CONVENTION.md`) y una implementación real, en cualquiera de estos aspectos:

**EN:** A **deviation** is any difference between the canonical pseudocode (defined in `PSEUDOCODE_CONVENTION.md`) and a real implementation, in any of these aspects:

1. **Nombre** de un concepto (`constructor`, `size`, `empty`, etc.).
2. **Representación** de un valor (fallo, ausencia, enlace).
3. **Construcción** de una instancia (`init`, `new`, `apply`, etc.).
4. **Mutabilidad** de una operación (muta vs devuelve copia).
5. **Complejidad** declarada de una operación.
6. **Encapsulación** de la representación (visible vs oculta).
7. **Mecanismo de fallo** (Option, Result, null, sentinel, etc.).

**ES:** Una desviación **no es** automáticamente un defecto. Los lenguajes tienen idiosincrasias y una desviación puede ser **la forma correcta** de expresar el contrato en ese lenguaje. Lo que sí es un defecto es **no documentarla**.

**EN:** A deviation is **not** automatically a defect. Languages have idiosyncrasies and a deviation may be **the correct way** to express the contract in that language. What is a defect is **not documenting it**.

---

## 🧭 Principio rector / Governing principle

**ES:** La desviación documentada es **contrato verificable**; la desviación silenciosa es **deuda oculta**.

**EN:** A documented deviation is **verifiable contract**; a silent deviation is **hidden debt**.

**ES:** Por eso este documento define tres cosas inseparables:

**EN:** That is why this document defines three inseparable things:

1. **Cuándo** una desviación es aceptable (sección "Aceptabilidad").
2. **Cómo** se documenta (sección "Plantilla").
3. **Cómo** se valida que está documentada (sección "Validación").

**ES:** Sin las tres, no hay política.

**EN:** Without all three, there is no policy.

---

## 📂 Categorías de desviación / Deviation categories

**ES:** Hay **seis categorías**. Cada una tiene un tratamiento distinto: algunas se toleran siempre, otras solo con justificación, otras nunca.

**EN:** There are **six categories**. Each has a different treatment: some are always tolerated, others only with justification, others never.

### C1 — Desviación de nombre / Naming deviation

**ES:** El concepto se llama distinto al pseudocódigo, pero la semántica es idéntica. Es la más común y la más tolerable.

**EN:** The concept has a different name than the pseudocode, but the semantics are identical. This is the most common and most tolerable.

**Ejemplos legítimos:**

- `size` en pseudocódigo → `len()` en Rust (convención del lenguaje).
- `empty` en pseudocódigo → `empty?` en Ruby (sufijo del lenguaje).
- `constructor` en pseudocódigo → `new` en C#, `T.new` en Ruby, `make-T` en Scheme.

**ES:** **Tratamiento:** permitida. No baja el nivel de idiomaticidad si el nombre es el que el lenguaje usa.

**EN:** **Treatment:** allowed. Does not lower the idiomaticity level if the name is the one the language uses.

### C2 — Desviación de representación / Representation deviation

**ES:** El valor se representa con un mecanismo distinto al canónico pero el contrato observable se preserva.

**EN:** The value is represented with a mechanism different from the canonical one but the observable contract is preserved.

**Ejemplos legítimos:**

- `absent` → `None` en Python (idiomático del lenguaje).
- `absent` → `nil` en Ruby (idiomático del lenguaje).
- `absent` → `{}` en Tcl (idiomático del lenguaje).
- `int?` en C# en vez de `Option<int>` (el lenguaje no tiene Option nativo).

**Ejemplos NO legítimos (van contra la representación declarada):**

- `absent` → `-1` en Rust, Zig, V, Nim, OCaml, Haskell (lenguajes con Option/Maybe nativo).
- `absent` → `null` en Scala 3 (el lenguaje desaconseja `null`).
- `absent` → `fatalError` en Swift `init` (rompe la construcción).

**ES:** **Tratamiento:** permitida si el mecanismo es el idiomático del lenguaje; prohibida si contradice una capacidad nativa del lenguaje.

**EN:** **Treatment:** allowed if the mechanism is the language's idiomatic one; forbidden if it contradicts a native capability of the language.

### C3 — Desviación de construcción / Construction deviation

**ES:** La forma de crear una instancia difiere del pseudocódigo, o está rota.

**EN:** The way to create an instance differs from the pseudocode, or is broken.

**Ejemplos legítimos:**

- `init` en pseudocódigo → `new T()` en C# (keyword).
- `init` en pseudocódigo → `T(v)` en Kotlin (constructor property).
- `init` en pseudocódigo → `T::new(v)` en Rust (factory).
- `init` en pseudocódigo → `make-T` en Scheme (convención Lisp).

**Ejemplos NO legítimos (construcción rota):**

- `init` que devuelve `nil`/`undefined`/`null`.
- `init` que lanza `fatalError`.
- `init` en ooRexx que devuelve un valor (rompe `new`).
- Constructor ausente cuando el lenguaje exige uno.

**ES:** **Tratamiento:** permitida la forma idiomática; prohibida cualquier forma que impida instanciar.

**EN:** **Treatment:** the idiomatic form is allowed; any form preventing instantiation is forbidden.

### C4 — Desviación de mutabilidad / Mutability deviation

**ES:** Una operación muta cuando el pseudocódigo dice "devuelve copia", o viceversa.

**EN:** An operation mutates when the pseudocode says "returns a copy", or vice versa.

**Ejemplos legítimos:**

- En un lenguaje inmutable (V2), `set_next` se convierte en `with_next` (devuelve copia).
- En un lenguaje mutable (V1), `with_next` se convierte en `set_next` (muta).
- En V3 (mixto), la elección se documenta y se justifica por módulo.

**Ejemplos NO legítimos:**

- Mutar en un lenguaje funcional sin declararlo (viola el contrato de pureza).
- Devolver copia en un lenguaje mutable cuando el pseudocódigo dice "mutación in-place" (rompe la expectativa del llamador).

**ES:** **Tratamiento:** permitida la adaptación coherente con el paradigma del lenguaje; prohibida la mezcla incoherente.

**EN:** **Treatment:** adaptation consistent with the language's paradigm is allowed; incoherent mixing is forbidden.

### C5 — Desviación de complejidad / Complexity deviation

**ES:** La operación tiene una complejidad distinta a la declarada en la spec.

**EN:** The operation has a different complexity than the one declared in the spec.

**Ejemplos legítimos:**

- `insertTail`/`enqueue` en lenguajes inmutables: O(n) en vez de O(1) porque la cadena debe reconstruirse.
- `LinkedList` sin puntero a `tail` en lenguajes sin reference semantics: O(n) en vez de O(1).
- `delete` en una lista sin índice: O(n) (ya es la spec).

**Ejemplos NO legítimos:**

- Cambiar O(n) a O(n²) sin justificación.
- Declarar O(1) cuando la implementación real es O(n) (mentir en el README).

**ES:** **Tratamiento:** permitida solo si la complejidad real se declara **explícitamente** en el README del lenguaje, con justificación y, si aplica, alternativa descartada.

**EN:** **Treatment:** allowed only if the real complexity is **explicitly** declared in the language README, with justification and, if applicable, discarded alternative.

### C6 — Desviación de encapsulación / Encapsulation deviation

**ES:** La representación interna es visible cuando el pseudocódigo dice "oculta".

**EN:** The internal representation is visible when the pseudocode says "hidden".

**Ejemplos legítimos:**

- Zig: no tiene `private` de campos. Los campos son públicos; la convención se documenta.
- Scheme: `define-record-type` sin setter deja los campos visibles por el accessor. La encapsulación es por no exponer setters.
- Lua: las tablas son transparentes; la encapsulación se hace con metatables o por convención.

**Ejemplos NO legítimos:**

- Exponer campos `pub` en Rust/C#/Kotlin cuando la spec dice "representación oculta".
- Devolver la referencia interna mutable desde un getter en un lenguaje inmutable.
- `#field` en JS/TS accesible desde otro módulo (no puede pasar, pero conceptualmente).

**ES:** **Tratamiento:** permitida cuando el lenguaje **no tiene** un mecanismo de encapsulación adecuado, y se documenta la convención; prohibida cuando el lenguaje sí lo tiene y no se usa.

**EN:** **Treatment:** allowed when the language **lacks** a suitable encapsulation mechanism, and the convention is documented; forbidden when the language has one and it is not used.

---

## 🎚️ Niveles de severidad / Severity levels

**ES:** Cada desviación tiene un nivel de severidad que determina su impacto en el nivel de idiomaticidad (ver `IDIOMATICITY_LEVELS.md`).

**EN:** Each deviation has a severity level that determines its impact on the idiomaticity level (see `IDIOMATICITY_LEVELS.md`).

| Severidad | Impacto | Ejemplo |
|-----------|---------|---------|
| 🟢 `informational` | No baja nivel. Nombre idiomático distinto. | `len` en vez de `size` en Rust |
| 🟡 `warning` | Baja de `idiomatic` a `mostly-idiomatic`. Nombre no idiomático pero funcional. | `getValue()` en Kotlin en vez de `value` |
| 🟠 `structural` | Baja de `mostly-idiomatic` a `transitional`. Cambia una decisión de diseño. | `init()` como método en vez de constructor |
| 🔴 `blocking` | Baja a `workaround`. Rompe el contrato o usa mecanismos peligrosos. | `*mut Node` en Rust, `fatalError` en `init` de Swift |

**ES:** La severidad se asigna **por desviación**, no por categoría. Una desviación de nombre puede ser 🟢 o 🟡 según si el nombre es el idiomático del lenguaje.

**EN:** Severity is assigned **per deviation**, not per category. A naming deviation may be 🟢 or 🟡 depending on whether the name is the language's idiomatic one.

---

## ✅ Aceptabilidad de una desviación / Deviation acceptability

**ES:** Antes de documentar una desviación, se decide si es aceptable. El siguiente árbol de decisión es la regla.

**EN:** Before documenting a deviation, one decides whether it is acceptable. The following decision tree is the rule.

```text
¿La desviación cambia la semántica observable del contrato?
├── SÍ → 🔴 NO aceptable. Es un defecto, no una desviación.
└── NO ↓

¿El lenguaje tiene un mecanismo nativo que evita la desviación?
├── SÍ → 🔴 NO aceptable. Úsalo. (Ej. Option en Rust, constructor en Swift)
└── NO ↓

¿La desviación cambia la complejidad declarada?
├── SÍ → ¿Está documentada con justificación y alternativa descartada?
│       ├── SÍ → 🟠 Aceptable con documentación.
│       └── NO → 🔴 NO aceptable. Documentar primero.
└── NO ↓

¿La desviación usa un mecanismo peligroso (unsafe, @Suppress, fatalError)?
├── SÍ → ¿Está aislado, justificado y con plan de retirada?
│       ├── SÍ → 🟠 Aceptable con documentación (deuda técnica).
│       └── NO → 🔴 NO aceptable.
└── NO ↓

¿La desviación afecta la construcción?
├── SÍ → 🟠 Aceptable si la construcción es idiomática; 🔴 si está rota.
└── NO ↓

¿La desviación es solo de nombre?
├── SÍ → ¿El nombre es el idiomático del lenguaje?
│       ├── SÍ → 🟢 Aceptable sin marcar.
│       └── NO → 🟡 Aceptable con documentación.
└── NO → Revisar manualmente.

## 📂 Dónde vive cada desviación / Where each deviation lives

**ES:** Las desviaciones viven en **cuatro** lugares, con propósitos distintos.

**EN:** Deviations live in **four** places, with different purposes.

| Lugar / Place | Qué contiene / What it holds | Cuándo se actualiza / Updated when |
|---|---|---|
| [`idioms/{lang}.md`](idioms/) | La desviación completa, con su plantilla | Cuando se introduce o se corrige |
| `data/idiomaticity_state.tsv` | El nivel derivado, el eje bloqueante, la fecha y el commit verificado | Cuando cambia el nivel |
| `docs/audits/{NN}_Audited_{Modulo}.md` | El registro de verificaciones del pase: fecha, alcance, comando y resultado | En cada pase de auditoría |
| Commit de código / Code commit | La implementación real | Al implementar / When implementing |

**ES:** La fuente de verdad de la desviación es la ficha del lenguaje; el estado, el registro del pase y el commit son índices o registros. **No hay changelog aparte**: el «cuándo se corrigió» ya está en el registro de verificaciones del pase y en la fecha y el commit de la fila del estado, y el historial de git queda como respaldo, no como un artefacto más que mantener.

**EN:** The source of truth for a deviation is the language's record; the state, the pass record and the commit are indexes or logs. **There is no separate changelog**: the "when it was fixed" already sits in the pass's verification log and in the state row's date and commit, and git history stays as a backup rather than one more artefact to maintain.

## 🔍 Validación / Validation

ES: La documentación de desviaciones se valida con dos mecanismos.

EN: Deviation documentation is validated with two mechanisms.
Validación local (por lenguaje) / Local validation (per language)

ES: Un script que verifica que cada desviación en el README del lenguaje tiene la plantilla completa.

EN: A script that verifies every deviation in the language README has the full template.
text

for each docs/ruleset/idioms/{lang}.md:
    read file
    find section "Deviations from the canonical pseudocode"

    for each deviation block:
        assert block has "Concepto:" or "Concept:"
        assert block has "Categoría:" or "Category:"
        assert block has "Severidad:" or "Severity:"
        assert block has "Estado:" or "State:"
        assert block has "Desviación:" or "Deviation:"
        assert block has "Motivo:" or "Reason:"
        assert block has "Impacto:" or "Impact:"
        assert block has "Evidencia:" or "Evidence:"
        assert category in {C1, C2, C3, C4, C5, C6}
        assert severity in {🟢, 🟡, 🟠, 🔴}
        assert state in {active, under-revision, scheduled-for-fix}

Validación cruzada (monorepo) / Cross validation (monorepo)

ES: Un script que verifica que idiomaticity_state.tsv es coherente con las desviaciones declaradas.

EN: A script that verifies idiomaticity_state.tsv is consistent with the declared deviations.
text

for each row in idiomaticity_state.tsv:
    lang = row.language
    module = row.module

    read docs/ruleset/idioms/{lang}.md
    deviations = [d for d in file if d.module == module]

    expected_level = derive_level(deviations)
    if expected_level != row.level:
        error "level mismatch for {lang}/{module}: file says {expected_level}, state says {row.level}"

    blocking_axes = [d.axis for d in deviations if d.severity in {🟠, 🔴}]
    if blocking_axes != [row.blocking_axis]:
        error "blocking_axis mismatch for {lang}/{module}"

ES: Si los dos scripts pasan, la política se está cumpliendo.

EN: If both scripts pass, the policy is being followed.
🚫 Anti-ejemplos / Anti-examples

ES: Cómo NO documentar una desviación.

EN: How NOT to document a deviation.
Anti-ejemplo 1 — Sin motivo / Without reason
markdown

### D1 — No usamos size

**Desviación:** usamos `len` en vez de `size`.

**Motivo:** porque sí.

ES: El motivo debe referenciar una característica del lenguaje o de la comunidad, no una preferencia.

EN: The reason must reference a language or community characteristic, not a preference.
Anti-ejemplo 2 — Sin evidencia / Without evidence
markdown

### D2 — Diferente indicador de fallo

**Desviación:** usamos `-1`.

**Motivo:** funciona.

ES: Falta: categoría, severidad, estado, evidencia y la justificación idiomática. Además, -1 en Rust es probablemente 🔴, no 🟢.

EN: Missing: category, severity, state, evidence and idiomatic justification. Additionally, -1 in Rust is probably 🔴, not 🟢.
Anti-ejemplo 3 — Dos desviaciones mezcladas / Two deviations merged
markdown

### D3 — Cambiamos nombres y agregamos deinit

**Desviación:** usamos `new` en vez de `init` y añadimos `deinit` para liberar memoria.

ES: Cada desviación va en su propia entrada. La de construcción (C3) y la de API adicional (que no es desviación, es extensión) deben separarse.

EN: Each deviation goes in its own entry. The construction one (C3) and the API addition (not a deviation, an extension) must be separated.
Anti-ejemplo 4 — Desviación no listada en la tabla de estados / Deviation not listed in the state table

ES: Si el README del lenguaje dice que hay 3 desviaciones y idiomaticity_state.tsv no las refleja, el tooling debe fallar. Si no falla, la política no está siendo efectiva.

EN: If the language README says there are 3 deviations and idiomaticity_state.tsv doesn't reflect them, the tooling must fail. If it doesn't fail, the policy is not effective.
📋 Criterios de aceptación del propio documento

    □

    Las 6 categorías están definidas con ejemplos legítimos y no legítimos.
    □

    Los 4 niveles de severidad están definidos con impacto concreto.
    □

    El árbol de decisión cubre todos los casos.
    □

    La plantilla es completa y usable.
    □

    Hay al menos 1 ejemplo completo y 4 anti-ejemplos.
    □

    Los 4 lugares donde viven las desviaciones están especificados.
    □

    Los scripts de validación local y cruzada están en pseudocódigo.
    □

    El documento no repite el PSEUDOCODE_CONVENTION.md — solo lo extiende.

🔗 Referencias / References

    docs/PSEUDOCODE_CONVENTION.md — El contrato del pseudocódigo (define qué se desvía).

    docs/IDIOMATICITY_LEVELS.md — La escala de 4 niveles (define cuánto baja).

    docs/LANGUAGE_CHARACTERISTICS.md — Los 11 ejes (define por qué se desvía).

    docs/PARADIGM_FAMILIES.md — La agrupación de los 50 lenguajes.

    data/canonical_names.tsv — La tabla de traducción.

    data/language_characteristics.tsv — La clasificación máquina-legible.

    data/idiomaticity_state.tsv — El estado actual por (lenguaje, módulo).

Última actualización / Last update: 2026-10-12