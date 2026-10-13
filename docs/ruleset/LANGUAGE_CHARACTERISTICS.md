# 🧬 Características del Lenguaje / Language Characteristics

> **ES:** Este documento define los **11 ejes** con los que se clasifica cada uno de los 50 lenguajes del monorepo. Cada eje afecta directamente a cómo se implementa un módulo, cómo se traduce el pseudocódigo, y qué desviaciones son aceptables. La clasificación completa vive en `data/language_characteristics.tsv`.
>
> **EN:** This document defines the **11 axes** used to classify each of the monorepo's 50 languages. Each axis directly affects how a module is implemented, how pseudocode is translated, and which deviations are acceptable. The complete classification lives in `data/language_characteristics.tsv`.

---

## 🎯 Por qué estos ejes / Why these axes

**ES:** Los ejes se eligieron porque **cada uno cambia una decisión de implementación** en al menos un módulo del monorepo. Si un eje no cambiara ninguna decisión, no estaría aquí. Los ejes son **ortogonales**: un lenguaje se clasifica independientemente en cada uno. No hay jerarquía.

**EN:** The axes were chosen because **each one changes an implementation decision** in at least one module of the monorepo. If an axis didn't change any decision, it wouldn't be here. The axes are **orthogonal**: a language is classified independently on each one. There is no hierarchy.

---

## 📐 Los 11 ejes / The 11 axes

### Eje 1 — Paradigma dominante / Dominant paradigm

**ES:** El estilo de organización del código que el lenguaje favorece por defecto. Determina si el módulo se escribe como clases, funciones, relaciones, o una mezcla.

**EN:** The code organization style the language favors by default. Determines whether the module is written as classes, functions, relations, or a mix.

| Valor | Significado | Ejemplos |
|-------|-------------|----------|
| `oo-puro` | Clases y objetos son la unidad principal | C#, Java, Kotlin, Scala, Swift, Dart, Groovy, Haxe |
| `funcional` | Funciones puras son la unidad principal | Haskell, Elm, OCaml, Erlang, Elixir, Gleam, Grain, ReScript, PureScript |
| `multi-paradigma` | Coexisten varios estilos con peso similar | C++, D, Rust, F#, Nim, Vala, Ballerina |
| `procedural` | Procedimientos y datos sueltos | C, Pascal, Ada, COBOL, Forth, REXX |
| `dinamico-scripting` | Scripts interpretados, sin tipado fuerte | Perl, Python, Ruby, Tcl, Lua, JS, PHP |
| `sistemas` | Enfoque en control de memoria y hardware | C, C++, Rust, Zig, Nim, V, D, Go, Ada |
| `logico` | Hechos y reglas, unificación | Prolog, Mercury |
| `lisp` | S-expressions y homoiconicidad | Scheme, Racket, Clojure, Common Lisp |

**ES:** Un lenguaje puede pertenecer a más de un valor. La clasificación del TSV elige **el dominante** para el módulo; el README del lenguaje documenta matices.

**EN:** A language may belong to more than one value. The TSV classification picks **the dominant one** for the module; the language README documents nuances.

---

### Eje 2 — Mutabilidad por defecto / Default mutability

**ES:** Si los valores se pueden mutar tras su creación. Determina si el módulo usa V1 (mutable) o V2 (inmutable) del pseudocódigo.

**EN:** Whether values can be mutated after creation. Determines whether the module uses V1 (mutable) or V2 (immutable) pseudocode.

| Valor | Significado | Ejemplos |
|-------|-------------|----------|
| `mutable` | Los valores mutan in-place por defecto | C#, Java, Kotlin, Dart, Go, D, JS, Lua, Perl, PHP, Python, Ruby, Tcl, Groovy, Haxe |
| `inmutable` | Los valores no mutan; se crean nuevos | Haskell, Elm, Scheme, Racket, Clojure, Common Lisp, Erlang, Elixir, Gleam, Grain, ReScript, F#, OCaml, PureScript |
| `mixta` | El programador elige por declaración | Scala, Swift, C++, Rust, Nim, Vala, Ballerina |

**ES:** Este es el eje **más determinante** del módulo. Cambia el pseudocódigo entero (V1 vs V2).

**EN:** This is the **most determining** axis of the module. It changes the entire pseudocode (V1 vs V2).

---

### Eje 3 — Sistema de tipos / Type system

**ES:** Cómo se verifican los tipos y en qué momento. Determina si el módulo puede declarar contratos verificables.

**EN:** How types are verified and when. Determines whether the module can declare verifiable contracts.

| Valor | Significado | Ejemplos |
|-------|-------------|----------|
| `estatico-fuerte` | Tipos verificados en compilación | C#, Java, Kotlin, Scala, Swift, Dart, Rust, Go, C++, D, Ada, Haskell, Elm, F#, OCaml, Nim, V, Zig |
| `dinamico` | Tipos verificados en runtime (o no verificados) | JS, Lua, Perl, PHP, Python, Ruby, Tcl, REXX |
| `gradual` | Tipos opcionales, chequeados si están | TypeScript |
| `ownership` | Sistema de préstamos y propiedad | Rust |
| `null-safety-sound` | Ausencia explícita verificada en compilación | Dart, Kotlin, Swift, ReScript |
| `dependiente` | Tipos que dependen de valores | Ballerina |

---

### Eje 4 — Gestión de memoria / Memory management

**ES:** Quién libera la memoria y cómo. Determina si el módulo necesita `deinit`/`free`/`Drop`, si hay GC, o si el allocator es explícito.

**EN:** Who frees memory and how. Determines whether the module needs `deinit`/`free`/`Drop`, whether there is GC, or whether the allocator is explicit.

| Valor | Significado | Ejemplos |
|-------|-------------|----------|
| `gc` | Recolector de basura automático | C#, Java, Kotlin, Scala, Go, JS, TS, Python, Ruby, Perl, PHP, Tcl, D, Nim, Elixir, Erlang, Elm, Haskell, OCaml, Scheme, Racket, Clojure, Common Lisp, Groovy, Haxe, Gleam, Grain, ReScript, F#, Julia, R, Ballerina, Crystal |
| `manual` | `malloc`/`free` explícitos | C, C++, Ada, Pascal, Forth, Zig |
| `raii` | Determinista por scope (RAII/ownership) | Rust, C++, Ada (controlled types), Vala, V |
| `arc` | Reference counting automático | Swift |
| `beam` | VM de Erlang, GC por proceso | Erlang, Elixir, Gleam |

**ES:** La familia `manual`/`raii` requiere declarar `deinit` en el README del lenguaje, incluso si la spec no lo pide.

**EN:** The `manual`/`raii` family requires declaring `deinit` in the language README, even if the spec doesn't ask for it.

---

### Eje 5 — Modelo de fallo / Failure model

**ES:** Cómo se representa "no hay valor" y cómo se propaga un fallo. Es el eje que más desviaciones produce.

**EN:** How "no value" is represented and how failure propagates. It is the axis that produces the most deviations.

| Valor | Significado | Ejemplos |
|-------|-------------|----------|
| `null` | `null`/`nil` como ausencia | C#, Java, Kotlin, Dart, JS, TS, Swift, Vala, Haxe, Groovy, PHP, Ruby, Lua, Perl, Tcl |
| `option` | `Option`/`Maybe`/`Optional` | Haskell, Elm, F#, OCaml, ReScript, Rust, Scala, Kotlin (`Int?`), Swift (`Int?`), Nim, V, Zig, Scheme, Racket |
| `result` | `Result`/`Either`/`{:ok, _}` | Gleam, Grain, Rust (`Result`), Elixir, Erlang, Scala, F# |
| `sentinel` | Valor reservado (`-1`, `0`, `{}`) | D, C, ooRexx (`.Nil`), Tcl (`{}`), Pascal, Assembly, COBOL |
| `tupla-(value, ok)` | Retorno dual | Go, Scheme (par `(v . s)`) |
| `excepciones` | Lanzar/atrapar excepciones | C#, Java, Kotlin, Python, Ruby, D, Ada, PHP, C++ (opt-in) |
| `mixto` | Combina varios según contexto | La mayoría de los lenguajes reales |

**ES:** El roadmap prohíbe excepciones en Fase 1 y las permite en Fase 2. Este eje determina qué indicador usar en cada fase.

**EN:** The roadmap forbids exceptions in Phase 1 and allows them in Phase 2. This axis determines which indicator to use in each phase.

---

### Eje 6 — Construcción / Construction

**ES:** Cómo se crea una instancia de un tipo. Determina el nombre y la forma del `init` del pseudocódigo.

**EN:** How an instance of a type is created. Determines the name and form of the `init` of the pseudocode.

| Valor | Significado | Ejemplos |
|-------|-------------|----------|
| `keyword-new` | `new T(...)` es palabra clave | C#, Java, D, Dart, Vala, C++, Haxe |
| `method-new` | `T.new(...)` es un método | Ruby, Perl, Lua, Raku |
| `static-factory` | `T::new(...)` como estático | Rust (`T::new`), V (`new_node`), Swift (`T(v)`), Kotlin (`T(v)`) |
| `apply` | `T(...)` vía `apply` | Scala, Clojure |
| `make-*` | `make-T(...)` | Scheme, Common Lisp |
| `literal` | `T{...}` o composición directa | Go (`T{...}`), C (`(T){...}`), Zig (`T{...}`) |
| `constructor-special` | `init` con contrato especial | ooRexx (`init`, no devolver valor), TclOO (`constructor`) |
| `predicate` | Hecho/regla (lógico) | Prolog |

---

### Eje 7 — Convención de nombres / Naming convention

**ES:** Cómo se nombran funciones, variables y tipos. Determina cómo se traduce cada nombre conceptual del pseudocódigo.

**EN:** How functions, variables and types are named. Determines how each conceptual pseudocode name is translated.

| Valor | Funciones | Tipos | Ejemplos |
|-------|-----------|-------|----------|
| `camelCase` | `getValue` | `Node` | C#, Java, Kotlin, Swift, Dart, JS, TS, Haxe, Groovy, Vala, V, Go (público), ReScript |
| `snake_case` | `get_value` | `Node` | Rust, Python, Ruby, Perl, Nim, OCaml, Julia, Tcl, C, C++, D |
| `kebab-case` | `get-value` | `Node` | Raku |
| `lisp-case` | `get-value` | `Node` | Scheme, Racket, Common Lisp |
| `PascalCase-fn` | `GetValue` | `Node` | Pascal, Ada (funciones públicas) |

**ES:** Los predicados añaden sufijo `?` o prefijo `is`/`is_`/`Is` según el lenguaje. Ver `canonical_names.tsv`.

**EN:** Predicates add a `?` suffix or `is`/`is_`/`Is` prefix depending on the language. See `canonical_names.tsv`.

---

### Eje 8 — Palabras reservadas y conflictos / Reserved words and conflicts

**ES:** Nombres que **no se pueden usar** porque colisionan con keywords del lenguaje, con la BCL, o con propiedades integradas. Determina las traducciones forzosas.

**EN:** Names that **cannot be used** because they collide with language keywords, the BCL, or built-in properties. Determines forced translations.

| Conflicto | Lenguajes | Traducción forzosa |
|-----------|-----------|--------------------|
| `delete` | D, Zig | `remove` |
| `init` | D, ooRexx, V, Zig | `new`, `constructor` |
| `next` | Perl | `set_next` |
| `value` | Go | `Value` |
| `Node` | Elixir | `Cell` |
| `Queue`, `Stack`, `LinkedList` | C#, Java, Dart, Kotlin, Scala, Go | namespace |
| `size` | Rust, OCaml, Haskell, Nim | `len`/`length` |

**ES:** La lista completa está en `canonical_names.tsv`, columna `reserved_conflicts`.

**EN:** The full list is in `canonical_names.tsv`, column `reserved_conflicts`.

---

### Eje 9 — Complejidad declarada / Declared complexity

**ES:** Restricciones del lenguaje que **cambian la complejidad** de una operación respecto a la spec. Determina las desviaciones de complejidad permitidas.

**EN:** Language restrictions that **change the complexity** of an operation relative to the spec. Determines the allowed complexity deviations.

| Operación | Familia | Complejidad | Motivo |
|-----------|---------|:-----------:|--------|
| `insertTail`/`enqueue` | inmutable (`V2`) | O(n) | La cadena debe reconstruirse para añadir al final |
| `insertTail`/`enqueue` | mutable (`V1`) | O(1) | Puntero `tail`/`rear` |
| `insertTail`/`enqueue` | sistemas sin punteros | O(n) | Sin acceso O(1) al último nodo |
| `insertTail`/`enqueue` | lógico (`V4`) | según modelo | Depende de la representación elegida |

**ES:** Todas las desviaciones de complejidad se documentan en el README del lenguaje con justificación y, si aplica, la alternativa que se descartó.

**EN:** All complexity deviations are documented in the language README with justification and, if applicable, the alternative that was discarded.

---

### Eje 10 — Nivel de idiomaticidad / Idiomaticity level

**ES:** El estado actual del módulo en ese lenguaje. Se calcula con los criterios del `IDIOMATICITY_LEVELS.md`.

**EN:** The current state of the module in that language. It is computed with the criteria of `IDIOMATICITY_LEVELS.md`.

| Valor | Descripción |
|-------|-------------|
| `idiomatic` | Sigue todas las convenciones |
| `mostly-idiomatic` | 1-2 desviaciones menores documentadas |
| `transitional` | Desviaciones estructurales, en migración |
| `workaround` | Pelea contra el lenguaje, deuda técnica |

**ES:** El nivel **no vive en este documento** — vive en `data/idiomaticity_state.tsv`, indexado por (lenguaje, módulo). Aquí solo se documenta el eje.

**EN:** The level **does not live in this document** — it lives in `data/idiomaticity_state.tsv`, indexed by (language, module). Here only the axis is documented.

---

### Eje 11 — Concurrencia / Concurrency

**ES:** El modelo de concurrencia que el lenguaje favorece por defecto. No es crítico para Fase 1, pero sí para Fase 8 (`async.futures_and_promises`, `async.async_await`, `async.actor_model`, `async.channels`, `async.parallel`). Clasificar los 50 lenguajes ahora evita retrabajo cuando se llegue a esa fase.

**EN:** The concurrency model the language favors by default. Not critical for Phase 1, but for Phase 8 (`async.futures_and_promises`, `async.async_await`, `async.actor_model`, `async.channels`, `async.parallel`). Classifying all 50 languages now avoids rework when that phase arrives.

| Valor | Significado | Ejemplos |
|-------|-------------|----------|
| `threads` | Threads del SO con memoria compartida y locks | C, C++, D, Java, C#, Ada (tasks), Nim, Zig, V, Vala, Crystal, Groovy, Julia, Ruby, Python, Perl, PHP, R, Tcl, Assembly |
| `async-await` | Event loop + promesas/futuros + `await` | JS, TS, Python (asyncio), Rust (tokio), C#, Kotlin (coroutines), Swift, Dart, Ballerina, ReScript, PureScript, Grain |
| `actors` | Procesos aislados con paso de mensajes | Erlang, Elixir, Gleam, Ballerina, Scala (Akka) |
| `csp` | Canales + threads ligeros (CSP) | Go, Clojure (core.async), Crystal (channels) |
| `fibers` | Coroutines cooperativas | Lua, Ruby (fibers), Crystal (dominant) |
| `tasks` | Tasks al estilo Ada (rendezvous, protected objects) | Ada |
| `stm` | Software Transactional Memory | Haskell, Clojure (refs) |
| `dataflow` | Sin concurrencia imperativa, data flow | Elm (por diseño), PureScript (Aff) |
| `none` | Sin concurrencia estándar | Scheme (portable), COBOL, Forth, REXX |
| `multi` | Varios modelos con peso similar | Rust, Scala, Kotlin, C#, Swift, F#, OCaml, Julia, Nim, Python, R, Ruby, Raku, Vala |

**ES:** La mayoría de los lenguajes modernos caen en `multi` porque combinan threads del SO con un modelo de más alto nivel. La asignación del TSV registra el **dominante**; el README del lenguaje documenta el resto.

**EN:** Most modern languages fall into `multi` because they combine OS threads with a higher-level model. The TSV assignment records the **dominant** one; the language README documents the rest.

**ES:** Este eje **no aplica a Fase 1 ni Fase 2** del roadmap. Se activa a partir de Fase 8 (`async.*`). Se incluye aquí para tener la clasificación completa desde el inicio.

**EN:** This axis **does not apply to Phase 1 or Phase 2** of the roadmap. It activates from Phase 8 (`async.*`). It is included here to have the full classification from the start.

---

## 📋 Clasificación completa por familia / Full classification per family

**ES:** Cada lenguaje se clasifica en los 11 ejes. Los valores exactos viven en `data/language_characteristics.tsv`. Aquí va el resumen por familia: la misma etiqueta `family` de `canonical_names.tsv`, exactamente una por lenguaje (una única implementación elegida por lenguaje).

**EN:** Each language is classified across the 11 axes. Exact values live in `data/language_characteristics.tsv`. Here is the summary by family: the same `family` label as in `canonical_names.tsv`, exactly one per language (a single chosen implementation per language).

### Familia `oo-null` (13)

**ES:** OO mutable con `null`. Construcción con `new`/`new(...)`, propiedades/getters, fallo con `null`, GC.

**EN:** Mutable OO with `null`. Construction with `new`/`new(...)`, properties/getters, failure with `null`, GC.

`ada` (procedural, pero con OO vía tagged types), `ballerina`, `crystal`, `csharp`, `dart`, `groovy`, `haxe`, `java`, `javascript`, `kotlin`, `rexx`, `typescript`, `vala`.

### Familia `oo-option` (3)

**ES:** OO mutable con `Option`/`Optional`. Fallo tipado, sin `null` idiomático.

**EN:** Mutable OO with `Option`/`Optional`. Typed failure, no idiomatic `null`.

`raku`, `scala`, `swift`.

### Familia `func-option` (10)

**ES:** Funcional inmutable con `Maybe`/`Option`. Todo devuelve copia, `with_*` en vez de `set_*`.

**EN:** Immutable functional with `Maybe`/`Option`. Everything returns a copy, `with_*` instead of `set_*`.

`clojure`, `common-lisp`, `elm`, `fsharp`, `haskell`, `ocaml`, `purescript`, `racket`, `rescript`, `scheme`.

### Familia `func-result` (4)

**ES:** Funcional inmutable con `Result`/`{:ok, _}`. El fallo transporta un valor de error, no solo la ausencia.

**EN:** Immutable functional with `Result`/`{:ok, _}`. Failure carries an error value, not just absence.

`elixir`, `erlang`, `gleam`, `grain`.

### Familia `sys-pointer` (4)

**ES:** Sistemas con punteros crudos y `NULL`. Sin GC (o GC opcional), con `free`/`dispose` explícito.

**EN:** Systems with raw pointers and `NULL`. No GC (or optional GC), with explicit `free`/`dispose`.

`assembly`, `c`, `cobol`, `forth`.

### Familia `sys-option` (4)

**ES:** Sistemas con tipos opcionales (`Option`, `?T`, `Union{Nothing, T}`). Fallo tipado, sin `NULL`.

**EN:** Systems with optional types (`Option`, `?T`, `Union{Nothing, T}`). Typed failure, no `NULL`.

`julia`, `nim`, `v`, `zig`.

### Familia `sys-tuple` (1)

**ES:** Sistemas con retorno dual `(value, ok)`.

**EN:** Systems with dual return `(value, ok)`.

`go`.

### Familia `sys-sentinel` (1)

**ES:** Sistemas con sentinel (`-1` o similar). El dominio se restringe para reservar el sentinel.

**EN:** Systems with sentinel (`-1` or similar). The domain is restricted to reserve the sentinel.

`d`.

### Familia `dyn-null` (7)

**ES:** Lenguajes dinámicos con `nil`/`undef`/`{}`. Sin verificación de tipos, sin contratos formales.

**EN:** Dynamic languages with `nil`/`undef`/`{}`. No type checking, no formal contracts.

`lua`, `perl`, `php`, `python`, `r`, `ruby`, `tcl-tk`.

### Familia `logic` (1)

**ES:** Lógico puro. Hechos y reglas.

**EN:** Pure logic. Facts and rules.

`prolog`.

### Familia `multi` (2)

**ES:** Multi-paradigma que puede elegir V1 o V2 según el módulo. La decisión se documenta por módulo.

**EN:** Multi-paradigm that may choose V1 or V2 per module. The decision is documented per module.

`cpp`, `rust`.

---

## 🔗 Relación entre ejes y variantes de pseudocódigo

**ES:** Los ejes **determinan** la variante de pseudocódigo.

**EN:** The axes **determine** the pseudocode variant.

| Eje 2 (mutabilidad) | Eje 1 (paradigma) | Variante |
|---------------------|-------------------|:--------:|
| `mutable` | cualquiera salvo `logico` | V1 |
| `inmutable` | `funcional`/`lisp` | V2 |
| `mixta` | cualquiera (clase **V3** si es `multi-paradigma`) | **V1** o **V2**: una sola, declarada en el README |
| cualquiera | `logico` | V4 |

**ES:** Esta tabla es la regla de asignación: **una sola variante por lenguaje**, sin explorar alternativas; la elección se documenta en el README del lenguaje.

**EN:** This table is the assignment rule: **a single variant per language**, with no alternatives explored; the choice is documented in the language README.

---

## 📊 Cómo se usa este documento

**ES:** Tres usos concretos.

**EN:** Three concrete uses.

1. **Antes de implementar un módulo en un lenguaje nuevo:** consultar los 11 ejes del lenguaje para saber qué esperar.
2. **Durante la auditoría:** comparar la implementación real con la clasificación declarada. Una discrepancia es un hallazgo.
3. **Al añadir un lenguaje:** clasificarlo en los 11 ejes antes de implementar el primer módulo.

1. **Before implementing a module in a new language:** consult the language's 11 axes to know what to expect.
2. **During the audit:** compare the real implementation with the declared classification. A discrepancy is a finding.
3. **When adding a language:** classify it across the 11 axes before implementing the first module.

---

## 📝 Criterios de aceptación del propio documento

- [ ] Los 11 ejes están definidos con valores cerrados (no listas abiertas).
- [ ] Cada eje tiene al menos un ejemplo por valor.
- [ ] Cada eje explica **qué decisión de implementación cambia**.
- [ ] La clasificación de los 50 cubre los 50 lenguajes del `.gitmodules`.
- [ ] La tabla `eje 2 + eje 1 → variante` es completa.
- [ ] Los ejes no se solapan (un cambio en uno no implica cambio en otro).
- [ ] El eje 11 está marcado como **diferido a Fase 8**.
- [ ] El TSV de salida es máquina-legible.

---

## 🔗 Referencias / References

- [`ruleset/PSEUDOCODE_CONVENTION.md`](PSEUDOCODE_CONVENTION.md) — El contrato del pseudocódigo.
- [`ruleset/IDIOMATICITY_LEVELS.md`](IDIOMATICITY_LEVELS.md) — La escala de 4 niveles.
- `ruleset/DEVIATION_POLICY.md` (por crear / to be created) — Cómo documentar cada desviación.
- `ruleset/PARADIGM_FAMILIES.md` (por crear / to be created) — La agrupación de los 50 lenguajes.
- [`data/language_characteristics.tsv`](data/language_characteristics.tsv) — La clasificación máquina-legible.
- [`data/canonical_names.tsv`](data/canonical_names.tsv) — La tabla de traducción.
- [`../../scripts/data/init_sequences.tsv`](../../scripts/data/init_sequences.tsv) — Tooling por lenguaje (fuente canónica, no duplicar aquí).

---

*Última actualización / Last update: 2026-10-12*