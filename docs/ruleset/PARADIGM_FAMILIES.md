# 👨‍👩‍👧‍👦 Familias de Lenguajes / Language Families

> **ES:** Este documento agrupa los 50 lenguajes del monorepo en **9 familias prácticas**. Una familia es un conjunto de lenguajes que **comparten la forma de implementar el mismo módulo**: misma variante de pseudocódigo, mismo modelo de fallo, misma gestión de memoria. La agrupación no es por "similitud lingüística" (no es un árbol genealógico) sino por **decisión de implementación compartida**.

---

## 🧾 Pseudocódigo ajustado por familia / Adjusted pseudocode per family

> **ES:** Esta es la capa que se pidió: el **mismo contrato escrito como se puede escribir en cada familia**. Cada bloque declara variante, construcción, ausencia/fallo, memoria y complejidad, y usa los nombres reales de `data/canonical_names.tsv`. La definición canónica y la didáctica del módulo siguen en su README; esto **no** lo sustituye.
>
> **EN:** This is the requested layer: **the same contract written the way each family can write it**. Each block states variant, construction, absence/failure, memory and complexity, and uses the real names from `data/canonical_names.tsv`. The canonical definition and the module's teaching material stay in its README; this does **not** replace them.

**ES:** Además, las 9 familias prácticas de este documento se corresponden así con las **11 etiquetas `family`** del TSV (una por lenguaje, sin solapes):

**EN:** Additionally, the 9 practical families of this document map to the **11 `family` labels** of the TSV (one per language, no overlap) as follows:

| Familia práctica / Practical family | Etiquetas del TSV / TSV labels | Nº | Variante |
|---|---|:--:|:--:|
| F1 OO con null | `oo-null` (13) + `oo-option` (3) | 16 | V1 |
| F2 Scripting dinámico | `dyn-null` (8, incluye Common Lisp mutable) | 8 | V1 |
| F3 Sistemas C-lineage | `sys-pointer` (4) + `sys-sentinel` (1, d) | 5 | V1 |
| F4 Sistemas modernos | `sys-option` (4) + `sys-tuple` (1, go) + `multi` (2: cpp, rust) | 7 | V1 (clase V3) |
| F5 Funcional ML/Haskell | `func-option` (9) − los 3 Lisp funcionales | 6 | V2 |
| F6 Lisp / Scheme / Racket | los 3 Lisp de `func-option`; Common Lisp mutable está en F2 | 3 | V2 |
| F7 BEAM funcional | `func-result` (4) | 4 | V2 |
| F8 Multi-paradigma OO | clase **V3** (5: rust, scala, swift, cpp, nim), ya contados en F1/F3/F4 | 0 propios | V1 |
| F9 Lógico | `logic` (1, prolog) | 1 | V4 |
| **Total / Total** | **16 + 8 + 5 + 7 + 6 + 3 + 4 + 1** | **50** | — |

**ES:** Cada etiqueta `family` de `canonical_names.tsv` pertenece a **una sola** familia práctica. Si un lenguaje debe cambiar de familia, se cambia su etiqueta en el TSV; este documento no reparte lenguajes a mano. F8 no añade miembros: es la clase V3 de lenguajes ya contados en F1/F3/F4.

**EN:** Every `family` label in `canonical_names.tsv` belongs to **exactly one** practical family. If a language must move, change its label in the TSV; this document does not redistribute languages by hand. F8 adds no members: it is the V3 class of languages already counted in F1/F3/F4.

**ES:** Estas familias agrupan por **decisión de implementación**. La tabla «Indicador de fallo por familia» de `PSEUDOCODE_CONVENTION.md` agrupa por **mecanismo de fallo** y puede situar un mismo lenguaje en otro grupo: `ada` está en F1 por su forma OO y en «Sistemas con punteros» por usar `NULL`/`-1`. No son taxonomías rivales; cada una responde a un eje distinto.

**EN:** These families group by **implementation decision**. The “Failure indicator per family” table in `PSEUDOCODE_CONVENTION.md` groups by **failure mechanism** and may place the same language elsewhere: `ada` is in F1 for its OO shape and in “Systems with pointers” for using `NULL`/`-1`. They are not rival taxonomies; each answers a different axis.

```pseudocode
-- F1 — OO con null (16: `oo-null` 13 + `oo-option` 3)
init(value)   = new Node(value)          -- new T(v) | T(v) | T.new(v)
get_value()   = return this.value        -- propiedad o getX()
set_next(n)   = this.next = n; return this
is_empty()    = this.size == 0           -- isEmpty | is_empty | empty?
size()        = this.size                -- size | length | len
delete(v)     = ...                      -- remove si `delete` choca (d, js, ts, ruby, tcl)
-- memoria: GC (sin deinit) · insert_tail/enqueue: O(1) con tail/rear
```

```pseudocode
-- F2 — Scripting dinámico con null (8, incluye Common Lisp V1)
init(value)   = { value: value, next: absent }   -- mapa/objeto/lista
set_next(n,x) = n.next = x; return n
is_empty(c)   = not c                            -- empty? | is_empty
size(c)       = len(c)                           -- len | length | size
delete(c, v)  = ...                              -- remove si choca [D, JS, TS, ruby, tcl]
-- ausencia: nil | undef | {} · memoria: GC · el contrato lo sostiene la suite
```

```pseudocode
-- F2 · subgrupo Common Lisp (V1 mutable, nombres kebab-case, defstruct o CLOS)
(make-node :value v)             -- constructor, no new ni init()
(node-value n)                   -- accessor; no get_value
(setf (node-next n) x)           -- muta el slot; no hay with_next
(linked-list-is-empty l)         -- predicado del modulo; size con (linked-list-size l)
(linked-list-delete l v)         -- el prefijo de tipo evita el choque con cl:delete
-- ausencia: nil · fallo: centinela 0/-1 documentado (DEVIATION_POLICY C2)
-- eleccion V1 declarada: la base homologada usa defstruct + setf (C4)
-- insert_tail/enqueue: O(1) con puntero a la cola, no se reconstruye la cadena
```

```pseudocode
-- F3 — Sistemas C-lineage con sentinel (5: ada, assembly, c, cobol, forth)
init(value)   = Node{...} | Make(v) | new_node(v)
set_next(n)   = ...                      -- muta (punteros)
destroy()     = deinit | free | destroy  -- OBLIGATORIO
-- ausencia: NULL | 0 | sentinel -1 (dominio restringido) · memoria: manual
-- insert_tail/enqueue: O(1) con puntero tail
```

```pseudocode
-- F4 — Sistemas modernos con option (7: d, go, julia, nim, rust, v, zig)
init(value)   = Node{...} | Node::new(v) | new_node(v)
set_next(n)   = ...                      -- V1: muta (una sola variante)
destroy()     = deinit | free           -- rust/v: Drop; zig: allocator explícito
-- ausencia: Option | ?T | Union{Nothing,T} | (T, bool) [go] | -1 [d]
-- insert_tail: O(1) con punteros; EXCEPCIÓN: rust O(n) por ownership (declarado)
```

```pseudocode
-- F5 — Funcional ML/Haskell con option (6: elm, fsharp, haskell, ocaml, purescript, rescript)
init(value)        = Node(value, absent)
get_value(node)    = node.value
with_next(node, n) = Node(node.value, present(n))   -- NO muta
is_empty(node)     = node == absent                 -- null? | isEmpty
-- ausencia: Nothing | None · memoria: GC · insert_tail/enqueue: O(n) DECLARADO
```

```pseudocode
-- F6 — Lisp / Scheme / Racket (3: clojure, racket, scheme)
(make-node value)                  ; make-node | ->Node | make-instance
(node-value n)                     ; accessor por convención
(node-with-next n x)               ; NO muta: término nuevo
(empty? n)                         ; #f | nil | '()
-- ausencia: nil | #f | '() · memoria: GC · insert_tail/enqueue: O(n) DECLARADO
-- fuente de `absent`, `present` y `with_next` de V2
```

```pseudocode
-- F7 — BEAM funcional con result (4: elixir, erlang, gleam, grain)
init(value)        = {:ok, Node(value, absent)} | Ok(Node(value, absent))
with_next(node, n) = %{node | next: n} | Node(node.value, present(n))   -- NO muta
is_empty(node)     = node == absent
-- fallo: {:ok, _} | {:error, _} | Result · memoria: BEAM (GC por proceso)
-- insert_tail/enqueue: O(n) DECLARADO (la cola se reconstruye)
```

```pseudocode
-- F8 — Multi-paradigma OO (0 propios; clase V3 de 5: rust, scala, swift, cpp, nim, ya contados en F1/F3/F4)
-- El módulo implementa V1 (una sola variante); V3 es la CLASE, no una asignación.
-- scala: class + Option · raku: Nil + tipos opcionales · ballerina: null + tipos dependientes
-- swift: mutating dentro de #expect · cpp/rust: punteros y ownership (ver F3/F4)
init(value)   = new T(value) | T(v) | T::new(v)
set_next(n)   = this.next = n; return this
-- memoria: GC (scala, raku, ballerina) · RAII/free (swift, cpp, rust)
```

```pseudocode
-- F9 — Lógico (1: prolog)
node(Value, Next).
node_init(Value, node(Value, absent)).
node_value(node(V, _), V).
node_with_next(node(V, _), N, node(V, present(N))).
-- ausencia: fallo de unificación · sin mutación
-- complejidad: la que declare el modelo de hechos
```

**ES:** Cómo usarlo: localiza tu lenguaje en `data/canonical_names.tsv` → mira su etiqueta `family` → encuentra su familia práctica aquí → escribe el módulo con ese bloque → registra con `DEVIATION_POLICY.md` cualquier distancia que quede.

**EN:** How to use it: find your language in `data/canonical_names.tsv` → look at its `family` label → find its practical family here → write the module with that block → record with `DEVIATION_POLICY.md` any remaining distance.
>
> **EN:** This document groups the monorepo's 50 languages into **9 practical families**. A family is a set of languages that **share the way they implement the same module**: same pseudocode variant, same failure model, same memory management. The grouping is not by "linguistic similarity" (it is not a genealogical tree) but by **shared implementation decision**.

---

## 🎯 Qué es una familia / What is a family

**ES:** Una familia práctica se define por **la combinación de tres ejes** del `LANGUAGE_CHARACTERISTICS.md`:

**EN:** A practical family is defined by **the combination of three axes** from `LANGUAGE_CHARACTERISTICS.md`:

| Eje | Valores relevantes |
|-----|-------------------|
| **Variante** (derivada de ejes 1 + 2) | V1, V2, V3, V4 |
| **Modelo de fallo** (eje 5) | null, option, result, sentinel, tupla, excepciones |
| **Gestión de memoria** (eje 4) | gc, manual, raii, arc, beam |

**ES:** Los otros ejes (naming, construcción, complejidad, etc.) **varían dentro de una familia** y se documentan por lenguaje en `docs/idioms/{lang}.md`.

**EN:** The other axes (naming, construction, complexity, etc.) **vary within a family** and are documented per language in `docs/idioms/{lang}.md`.

**ES:** Una familia **no es un árbol genealógico**. Perl y Python están en la misma familia (scripting dinámico con null) aunque no comparten lineage. Rust y Zig están en familias distintas (Rust comparte `result`, Zig comparte `option` con `manual`) aunque ambos sean lenguajes de sistemas.

**EN:** A family **is not a genealogical tree**. Perl and Python are in the same family (dynamic scripting with null) even though they don't share lineage. Rust and Zig are in different families (Rust shares `result`, Zig shares `option` with `manual`) even though both are systems languages.

---

## 📊 Vista general / Overview

```text
F1 — OO con null (V1)                      16 lenguajes
F2 — Scripting dinámico con null (V1)       8 lenguajes
F3 — Sistemas C-lineage con sentinel (V1)   5 lenguajes
F4 — Sistemas modernos con option (V1; V3 es clase)   7 lenguajes
F5 — Funcional ML/Haskell con option (V2)   6 lenguajes
F6 — Lisp / Scheme / Racket (V2)            3 lenguajes
F7 — BEAM funcional con result (V2)         4 lenguajes
F8 — Multi-paradigma OO (clase V3 → V1)      0 propios
F9 — Lógico (V4)                            1 lenguaje
                                            ─────────
                                            50 lenguajes
                                            👥 Las 9 familias / The 9 families
```
F1 — OO con null (V1) — 16 lenguajes

Miembros / Members: ada, ballerina, crystal, csharp, dart, groovy, haxe, java, javascript, kotlin, raku, rexx, scala, swift, typescript, vala.

Perfil / Profile:
Eje	Valor dominante
Variante	V1 (mutable)
Mutabilidad	mutable
Fallo	null / nil (ada con sentinel `-1` y `Boolean`; excepciones en Java, C#)
Memoria	gc (ada con memoria manual; swift con arc)
Construcción	new T() (keyword)
Naming	camelCase, kebab-case en raku/scala

ES: Familia dominante en el monorepo (16 de 50). Son lenguajes con OO clásico, mutación in-place, null como ausencia y GC. La forma del módulo es idéntica entre ellos: constructor, getters/setters, métodos mutantes, null como indicador de fallo.

EN: The dominant family (16 of 50). Languages with classic OO, in-place mutation, null as absence and GC. The module shape is identical among them: constructor, getters/setters, mutating methods, null as failure indicator.

ES: Dentro de la familia hay subgrupos por convención de nombres y keyword de construcción:

    camelCase + new keyword: csharp, dart, haxe, java, kotlin, typescript, vala.

    camelCase + new keyword + prototype: javascript.

    camelCase + new keyword + null safety: dart, kotlin, swift.

    snake_case + T.new method: crystal (ruby pertenece a F2).

    camelCase + new keyword + ARC: swift.

    kebab-case + T.new / init(): raku, scala.

    Paquete y procedimientos: ada (`Make`/`Init`, sin GC); ballerina (`init()`, GC); rexx (`::class`).

ES: Deviations comunes a la familia (ver DEVIATION_POLICY.md para el formato):

    C1: delete → remove en C#/Java/Kotlin, pero se mantiene delete en crystal/dart.

    C2: uso de null como indicador de fallo (idiomático, no es desviación).

    C6: campos private/# para representación oculta.

EN: Family-wide deviations (see DEVIATION_POLICY.md for the format):

    C1: delete → remove in C#/Java/Kotlin, kept as delete in crystal/dart.

    C2: null as failure indicator (idiomatic, not a deviation).

    C6: private/# fields for hidden representation.

ES: Lecciones compartidas:

    El mismo módulo se implementa casi idéntico. La diferencia es el nombre del constructor y los getters.

    Los tests se escriben casi iguales (con assert/XCTAssert/expect).

    La encapsulación se hace con private (Java/C#) o # (JS/TS).

EN: Shared lessons:

    The same module is implemented nearly identically. The difference is the constructor name and the getters.

    Tests are written nearly identically (with assert/XCTAssert/expect).

    Encapsulation uses private (Java/C#) or # (JS/TS).

F2 — Scripting dinámico con null (V1) — 8 lenguajes

Miembros / Members: common-lisp, lua, perl, php, python, r, ruby, tcl-tk.

**ES:** Common Lisp conserva su notación Lisp: `(make-node :value v)`,
`(node-value n)` y `(setf (node-next n) x)`. Se agrupa aquí por su contrato
mutable con `nil` y GC, no por sintaxis ni por falta de CLOS.

**EN:** Common Lisp keeps its Lisp notation and native CLOS/structure
capabilities; this grouping reflects mutable state, `nil` and GC,
not syntax or the absence of an object system.

Perfil / Profile:
Eje	Valor dominante
Variante	V1 (mutable)
Mutabilidad	mutable
Fallo	null / nil / undef / {}
Memoria	gc
Construcción	T.new(...) (method) o literal
Naming	snake_case, kebab-case en common-lisp (tcl-tk con espacio)

ES: Lenguajes sin tipado verificado en compilación, GC, y ausencia representada con nil/undef/None/{}. La forma del módulo es la más libre de todas las familias: no hay contratos verificables por el compilador, solo por convención.

EN: Languages without compile-time type checking, GC, and absence represented with nil/undef/None/{}. The module shape is the freest of all families: no verifiable contracts by the compiler, only by convention.

ES: Subgrupos:

    nil nativo: lua, ruby, common-lisp (nil y `'()` son el mismo objeto).

    undef nativo: perl.

    None / nil / null: php (null), python (None), r (NULL/NA).

    Con OO nativo: php, python, lua (con metatables), common-lisp (CLOS y `defstruct`).

    Sin OO nativo: perl (con package/bless), tcl-tk (con TclOO).

EN: Subgroups:

    Native nil: lua, ruby, common-lisp (nil and `'()` are the same object).

    Native undef: perl.

    None / nil / null: php, python, r.

    Native OO: php, python, lua (metatables), common-lisp (CLOS and `defstruct`).

    No native OO: perl (package/bless), tcl-tk (TclOO).

ES: Deviations comunes:

    C2: null/nil/{} como ausencia (idiomático).

    C1: nombres traducidos (get_value en vez de value) son aceptables por falta de convención fuerte.

    C6: la encapsulación es solo por convención (no hay private real en Perl/Lua/Tcl) y en Common Lisp los campos de `defstruct` quedan visibles por sus accesores; se encapsula no exportando el símbolo o con `defclass` y `:reader`/`:accessor`.

EN: Common deviations:

    C2: null/nil/{} as absence (idiomatic).

    C1: translated names (get_value instead of value) are acceptable due to lack of strong convention.

    C6: encapsulation is convention-only (no real private in Perl/Lua/Tcl).

ES: Lecciones compartidas:

    El módulo se apoya en la disciplina del programador. Los tests son la única garantía.

    La ausencia (.Nil, undef, nil, {}) no distingue entre "no encontrado" y "encontrado como vacío" si el valor puede ser vacío.

    El tooling de test varía mucho (busted, prove, tcltest, etc.).

EN: Shared lessons:

    The module relies on programmer discipline. Tests are the only guarantee.

    Absence (.Nil, undef, nil, {}) does not distinguish between "not found" and "found but empty" if the value can be empty.

    Test tooling varies widely (busted, prove, tcltest, etc.).

F3 — Sistemas C-lineage con sentinel (V1) — 5 lenguajes

Miembros / Members: assembly, c, cobol, d, forth.

Perfil / Profile:
Eje	Valor dominante
Variante	V1 (mutable)
Mutabilidad	mutable
Fallo	sentinel (NULL, 0, -1)
Memoria	manual (d con GC)
Construcción	función init/make/literal
Naming	snake_case / PascalCase

ES: Lenguajes de sistemas "clásicos" con memoria manual (malloc/free) —salvo d, que recolecta— y sin tipo opcional al estilo ML. La ausencia se representa con NULL (nullptr), 0, o un sentinel documentado.

EN: "Classic" systems languages with manual memory (malloc/free) —except d, which is collected— and no ML-style optional type. Absence is represented with NULL (nullptr), 0, or a documented sentinel.

ES: Subgrupos:

    C y Assembly: NULL o 0 como ausencia, malloc/free manual.

    COBOL: espacios / NULL como ausencia, formato fijo.

    D: sentinel documentado con GC y compilación nativa.

    Forth: stack-based, todo es un número, 0 como sentinel.

EN: Subgroups:

    C and Assembly: NULL or 0 as absence, manual malloc/free.

    COBOL: spaces / NULL as absence, fixed format.

    D: documented sentinel with GC and native compilation.

    Forth: stack-based, everything is a number, 0 as sentinel.

ES: Deviations comunes:

    C2: sentinel como ausencia (idiomático para estos lenguajes).

    C3: construcción con función (new_node(v)) en vez de constructor keyword.

    C5: la complejidad de insertTail es O(1) porque hay punteros.

EN: Common deviations:

    C2: sentinel as absence (idiomatic for these languages).

    C3: construction with function (new_node(v)) instead of keyword constructor.

    C5: insertTail complexity is O(1) because pointers exist.

ES: Lecciones compartidas:

    El módulo necesita deinit/free explícito. La spec no lo pide, pero el lenguaje lo exige.

    El sentinel restringe el dominio: no puedes meter el valor reservado.

    La ausencia de verificación de tipos obliga a documentar todo por convención.

EN: Shared lessons:

    The module needs explicit deinit/free. The spec doesn't ask for it, but the language requires it.

    The sentinel restricts the domain: you cannot store the reserved value.

    The lack of type verification forces everything to be documented by convention.

F4 — Sistemas modernos con option (V1; V3 es clase) — 7 lenguajes

Miembros / Members: cpp, go, julia, nim, rust, v, zig.

Perfil / Profile:
Eje	Valor dominante
Variante	V1 (una sola; V3 es la clase, no una asignación)
Mutabilidad	mutable o mixta
Fallo	Option/?T/(T, bool)/Result/puntero nulo (cpp)
Memoria	gc / raii / manual (variado)
Construcción	new factory / literal
Naming	snake_case (cpp con camelCase parcial)

ES: Lenguajes de sistemas modernos, con tipos opcionales y verificación en compilación. A diferencia de F3, no usan sentinel: usan Option, ?T, Result o (T, bool). Cada uno gestiona memoria a su manera.

EN: Modern systems languages with optional types and compile-time verification. Unlike F3, they do not use sentinel: they use Option, ?T, Result, or (T, bool). Each manages memory its own way.

ES: Subgrupos por memoria:

    GC: go, julia, nim.

    RAII/ownership: cpp, rust, v.

    Manual explícito: zig.

ES: Subgrupos por fallo:

    Option/?T: julia, nim, rust, v, zig.

    Result: rust (también).

    (T, bool): go.

    Puntero nulo: cpp.

EN: Subgroups by memory:

    GC: go, julia, nim.

    RAII/ownership: cpp, rust, v.

    Explicit manual: zig.

EN: Subgroups by failure:

    Option/?T: julia, nim, rust, v, zig.

    Result: rust (also).

    (T, bool): go.

    Null pointer: cpp.

ES: Deviations comunes:

    C2: en rust/zig/v/julia/nim, Option es idiomático. En cpp, el puntero nulo es el mecanismo del lenguaje y se declara.

    C5: insertTail es O(1) con punteros/referencias; **excepción medida**: en ownership (rust) es O(n) porque el nodo no se puede reubicar sin mover la cadena. Se declara.

    C6: zig no tiene private de campos; la encapsulación es por convención.

EN: Common deviations:

    C2: in rust/zig/v/julia/nim, Option is idiomatic. In cpp, the null pointer is the language mechanism and is declared.

    C5: insertTail is O(1) with pointers/references; **measured exception**: under ownership (rust) it is O(n) because the node cannot be relocated without moving the chain. It is declared.

    C6: zig has no field private; encapsulation is by convention.

ES: Lecciones compartidas:

    rust/zig/v requieren allocator explícito o deinit.

    go usa (T, bool) como indicador — el único del monorepo.

    julia usa Union{Nothing, T} — tipo suma nativo.

    nim compila a C/C++/JS; el módulo es portable entre targets.

EN: Shared lessons:

    rust/zig/v require explicit allocator or deinit.

    go uses (T, bool) as indicator — the only one in the monorepo.

    julia uses Union{Nothing, T} — native sum type.

    nim compiles to C/C++/JS; the module is portable across targets.

F5 — Funcional ML/Haskell con option (V2) — 6 lenguajes

Miembros / Members: elm, fsharp, haskell, ocaml, purescript, rescript.

Perfil / Profile:
Eje	Valor dominante
Variante	V2 (inmutable)
Mutabilidad	inmutable o mixta
Fallo	Maybe/Option
Memoria	gc
Construcción	T.create/T(v)/newNode
Naming	camelCase (excepto ocaml con snake_case)

ES: Lenguajes funcionales con verificación fuerte de tipos, inmutabilidad por defecto, y Maybe/Option como ausencia. La forma del módulo es la misma: with_next en vez de set_next, tipos Maybe/Option, ausencia con Nothing/None.

EN: Functional languages with strong type verification, immutability by default, and Maybe/Option as absence. The module shape is the same: with_next instead of set_next, Maybe/Option types, absence with Nothing/None.

ES: Subgrupos:

    Haskell puro: haskell, elm, purescript.

    Haskell-like para JS: purescript, rescript.

    ML/OCaml-like: ocaml, fsharp, rescript.

    .NET funcional: fsharp.

EN: Subgroups:

    Pure Haskell: haskell, elm, purescript.

    Haskell-like for JS: purescript, rescript.

    ML/OCaml-like: ocaml, fsharp, rescript.

    .NET functional: fsharp.

ES: Deviations comunes:

    C4: todas las operaciones devuelven copia. insert_tail/enqueue son O(n) por inmutabilidad. Desviación C5 común a toda la familia.

    C1: nombres sin prefijo get_ (value, next, head).

    C2: Nothing/None como ausencia (idiomático).

EN: Common deviations:

    C4: every operation returns a copy. insert_tail/enqueue are O(n) due to immutability. C5 deviation shared across the entire family.

    C1: names without get_ prefix (value, next, head).

    C2: Nothing/None as absence (idiomatic).

ES: Lecciones compartidas:

    El módulo se escribe con funciones puras. No hay mutación en ningún punto.

    Los tests usan assert sobre valores inmutables; la comparación es estructural, no por identidad.

    insert_tail/enqueue en O(n) es inevitable. Todos los lenguajes de la familia lo documentan igual.

EN: Shared lessons:

    The module is written with pure functions. There is no mutation anywhere.

    Tests use assert over immutable values; comparison is structural, not by identity.

    insert_tail/enqueue in O(n) is inevitable. All languages in the family document it the same way.

F6 — Lisp / Scheme / Racket (V2) — 3 lenguajes

Miembros / Members: clojure, racket, scheme.

**ES:** Common Lisp no pertenece a esta familia de implementación V2:
en el monorepo usa registros mutables (`defstruct` + `setf`), ausencia
`nil` y GC, por lo que se agrupa en F2 / `dyn-null`. Su genealogía Lisp
no obliga a usar persistencia. SBCL vía Roswell admite mutación de slots
sin celdas auxiliares; con tail/rear, inserción al final y enqueue son O(1).

**EN:** Common Lisp's chosen implementation is V1 with mutable records,
`nil` and GC, so it belongs to F2 / `dyn-null`, not this V2 family.
Lisp ancestry does not require persistence. SBCL through Roswell supports
slot mutation directly and O(1) insertion/enqueue with tail/rear.

Perfil / Profile:
Eje	Valor dominante
Variante	V2 (inmutable)
Mutabilidad	inmutable (con set! opcional)
Fallo	nil/#f/None
Memoria	gc
Construcción	make-node / (->Node ...)
Naming	kebab-case / lisp-case

ES: Lenguajes de la familia Lisp, con homoiconicidad, paréntesis, y evaluación de s-expressions. La forma del módulo es distinta a la de F5: no hay constructores tipados, hay funciones make-* y el módulo se apoya en la cultura Lisp de "todo es una lista".

EN: Languages of the Lisp family, with homoiconicity, parentheses, and s-expression evaluation. The module shape is different from F5: no typed constructors, just make-* functions, and the module relies on the Lisp culture of "everything is a list".

ES: Subgrupos:

    Scheme/Lisp mínimos: scheme, racket.

    Lisp sobre JVM: clojure.

    Lisp funcional puro: racket.

EN: Subgroups:

    Minimal Scheme/Lisp: scheme, racket.

    Lisp on JVM: clojure.

    Pure functional Lisp: racket.

ES: Deviations comunes:

    C1: nombres con make- (Scheme) o ->Node (Clojure).

    C2: #f (Scheme/Racket) o nil (Clojure) como ausencia.

    C4: inmutable, insert_tail/enqueue O(n).

    C6: encapsulación por convención (no hay private real).

EN: Common deviations:

    C1: names with make- (Scheme) or ->Node (Clojure).

    C2: #f (Scheme/Racket) or nil (Clojure) as absence.

    C4: immutable, insert_tail/enqueue O(n).

    C6: encapsulation by convention (no real private).

ES: Lecciones compartidas:

    El módulo se escribe con define-record-type (Scheme/Racket) o defrecord (Clojure).

    Los tests se escriben con (check-equal? ...) o (is ...) o (assert ...).

    La encapsulación es débil en toda la familia: no hay private real.

EN: Shared lessons:

    The module is written with define-record-type (Scheme/Racket) or defrecord (Clojure).

    Tests are written with (check-equal? ...) or (is ...) or (assert ...).

    Encapsulation is weak across the family: no real private.

F7 — BEAM funcional con result (V2) — 4 lenguajes

Miembros / Members: elixir, erlang, gleam, grain.

Perfil / Profile:
Eje	Valor dominante
Variante	V2 (inmutable)
Mutabilidad	inmutable
Fallo	Result / {:ok, _} / {:error, _}
Memoria	beam (VM Erlang) o gc (grain)
Construcción	Node.new / node_new / Node (literal)
Naming	snake_case

ES: Lenguajes funcionales con inmutabilidad estricta, concurrencia por actors y fallo tipado con Result. Tres corren sobre BEAM (Erlang VM); grain compila a Wasm pero adopta el mismo modelo funcional.

EN: Functional languages with strict immutability, actor concurrency, and typed failure with Result. Three run on BEAM (Erlang VM); grain compiles to Wasm but adopts the same functional model.

ES: Subgrupos:

    BEAM dinámico: elixir, erlang.

    BEAM tipado: gleam.

    Wasm funcional: grain.

EN: Subgroups:

    Dynamic BEAM: elixir, erlang.

    Typed BEAM: gleam.

    Functional Wasm: grain.

ES: Deviations comunes:

    C1: Node → Cell en Elixir (colisión con Elixir.Node).

    C2: Result/{:ok, _} en vez de null/Option.

    C4: todas las operaciones devuelven copia.

    C5: insert_tail/enqueue O(n).

EN: Common deviations:

    C1: Node → Cell in Elixir (collision with Elixir.Node).

    C2: Result/{:ok, _} instead of null/Option.

    C4: every operation returns a copy.

    C5: insert_tail/enqueue O(n).

ES: Lecciones compartidas:

    El módulo se apoya en pattern matching en vez de if/switch.

    Los tests usan ExUnit (Elixir), eunit/ct (Erlang), gleeunit (Gleam), grain test (Grain).

    El fallo tipado {:ok, _} / {:error, _} es la forma de comunicar operaciones fallibles.

EN: Shared lessons:

    The module relies on pattern matching instead of if/switch.

    Tests use ExUnit (Elixir), eunit/ct (Erlang), gleeunit (Gleam), grain test (Grain).

    Typed failure {:ok, _} / {:error, _} is the way to communicate fallible operations.

F8 — Multi-paradigma OO (clase V3 → V1) — 0 propios (clase de 5)

Miembros / Members (clase, ya contados en F1/F3/F4): cpp, nim, rust, scala, swift.

Perfil / Profile:
Eje	Valor dominante
Variante	V1 (la clase V3 se resolvió a V1; sin alternativas)
Mutabilidad	mixta
Fallo	option (scala, nim), option/result (rust), null (cpp)
Memoria	raii (cpp, rust), arc (swift), gc (scala, nim)
Construcción	new keyword / T.new / T()
Naming	camelCase / snake_case

ES: Lenguajes multi-paradigma que permiten tanto V1 como V2 según el módulo. La elección se documenta en el README del lenguaje por módulo. No comparten un modelo único; su rasgo común es que no encajan en ninguna otra familia.

EN: Multi-paradigm languages that allow both V1 and V2 depending on the module. The choice is documented in the language README per module. They do not share a single model; their common trait is that they fit no other family.

ES: Perfiles individuales:

    cpp: RAII, plantillas, multi-paradigma histórico. El módulo elige V1 por pedagogía. (Contado en F4 por la etiqueta `multi`.)

    rust: ownership y préstamos, con `Option`/`Result`. Implementa V1 (V3 es su clase). (Contado en F4.)

    scala: JVM, funcional + OO, con Option/Either. Implementa V1 (V3 es su clase). (Contado en F1 por `oo-option`.)

    swift: ARC y protocolos, con Optional. Implementa V1 (V3 es su clase). (Contado en F1.)

    nim: multi-paradigma con Option y GC. Implementa V1 (V3 es su clase). (Contado en F4 por `sys-option`.)

EN: Individual profiles:

    cpp: RAII, templates, historic multi-paradigm. The module chooses V1 for pedagogy. (Counted in F4 through the `multi` label.)

    rust: ownership and borrowing, with `Option`/`Result`. It implements V1 (V3 is its class). (Counted in F4.)

    scala: JVM, functional + OO, with Option/Either. It implements V1 (V3 is its class). (Counted in F1 through `oo-option`.)

    swift: ARC and protocols, with Optional. It implements V1 (V3 is its class). (Counted in F1.)

    nim: multi-paradigm with Option and GC. It implements V1 (V3 is its class). (Counted in F4 through `sys-option`.)

ES: Deviations comunes:

    C2: cada uno elige su indicador (varía).

    C3: cada uno elige su constructor (varía).

    No hay deviations comunes a toda la familia: V3 es solo la clase; la variante implementada es V1.

EN: Common deviations:

    C2: each one chooses its indicator (varies).

    C3: each one chooses its constructor (varies).

    No deviations common to the entire family: V3 is only the class; the implemented variant is V1.

ES: Lecciones compartidas:

    La decisión V1 vs V2 se toma por módulo, no por lenguaje.

    El README del lenguaje debe declarar cuál se eligió y por qué.

    No hay reutilización de código entre ellos, pero sí decisiones de auditoría comunes.

EN: Shared lessons:

    The V1 vs V2 decision is made per module, not per language.

    The language README must declare which was chosen and why.

    There is no code reuse among them, but there are common audit decisions.

F9 — Lógico (V4) — 1 lenguaje

Miembros / Members: prolog.

Perfil / Profile:
Eje	Valor dominante
Variante	V4 (lógico)
Mutabilidad	inmutable (todo es unificación)
Fallo	fallo de unificación
Memoria	gc
Construcción	predicado/fact
Naming	snake_case

ES: Familia de un solo miembro. Prolog no es un lenguaje imperativo ni funcional; es lógico. El pseudocódigo V4 es distinto al resto: no hay constructores, hay hechos; no hay métodos, hay reglas.

EN: Single-member family. Prolog is neither imperative nor functional; it is logic. V4 pseudocode differs from the rest: no constructors, just facts; no methods, just rules.

ES: Deviations comunes:

    C3: no hay "constructor" — hay un hecho node_init(V, N).

    C4: no hay mutación — todo es unificación.

    C6: no aplica — todo es público por definición.

EN: Common deviations:

    C3: no "constructor" — there is a fact node_init(V, N).

    C4: no mutation — everything is unification.

    C6: not applicable — everything is public by definition.

ES: Lecciones compartidas:

    El pseudocódigo V4 es único. Los otros lenguajes no lo comparten.

    La auditoría de Prolog es independiente de las otras familias.

    El módulo se escribe con cláusulas y backtracking.

EN: Shared lessons:

    V4 pseudocode is unique. Other languages do not share it.

    Prolog's audit is independent of the other families.

    The module is written with clauses and backtracking.

🔀 Lenguajes en más de una familia / Languages in more than one family

ES: Algunos lenguajes podrían clasificarse en dos familias por su naturaleza dual. La familia asignada es la principal; el README del lenguaje documenta la secundaria.

EN: Some languages could be classified in two families due to their dual nature. The assigned family is the primary one; the language README documents the secondary one.
Lenguaje	Familia principal	Familia secundaria	Razón
swift	F1 (OO con null)	F4 (sistemas con option)	Usa ARC + Optional, no GC + null
crystal	F1 (OO con null)	F2 (scripting dinámico)	Sintaxis Ruby pero tipado estático
ruby	F1 (OO con null)	F2 (scripting dinámico)	OO + scripting dinámico
javascript	F1 (OO con null)	F2 (scripting dinámico)	OO por clases + scripting dinámico
python	F2 (scripting dinámico)	F1 (OO con null)	Scripting + OO nativo
d	F4 (sistemas modernos)	F1 (OO con null)	GC + sentinel + OOP
nim	F4 (sistemas modernos)	F1 (OO con null)	GC + Option + OOP
v	F4 (sistemas modernos)	F1 (OO con null)	RAII + Option + OOP
fsharp	F5 (funcional ML)	F8 (multi-paradigma)	ML + .NET OOP
scala	F8 (multi-paradigma)	F1 (OO con null)	JVM + funcional + OO
cpp	F8 (multi-paradigma)	F3 (sistemas C-lineage)	RAII + manual + multi-paradigma

ES: Esta doble clasificación no genera trabajo doble. La familia principal determina el estilo del módulo; la secundaria se menciona en el README si aplica.

EN: This dual classification does not generate double work. The primary family determines the module's style; the secondary one is mentioned in the README if applicable.
🧭 Cómo usar este documento / How to use this document

ES: Tres usos concretos.

EN: Three concrete uses.
1. Reutilizar decisiones entre lenguajes de la misma familia

ES: Cuando cierres un módulo en rust, las decisiones aplican casi idénticas a zig, v, nim (todos en F4). El README de rust sirve como plantilla para los otros.

EN: When you close a module in rust, the decisions apply nearly identically to zig, v, nim (all in F4). The rust README serves as a template for the others.
2. Detectar bugs por analogía

ES: Si encuentras un bug en elixir, revisa erlang, gleam, grain (misma familia F7). Es probable que compartan el bug.

EN: If you find a bug in elixir, check erlang, gleam, grain (same family F7). They likely share the bug.
3. Organizar el trabajo de auditoría por familia

ES: La auditoría se puede hacer por familia: cerrar F1 completa (16 lenguajes), luego F2 (8), etc. Es más eficiente que hacerla por lenguaje aislado.

EN: The audit can be done by family: close F1 completely (16 languages), then F2 (8), etc. It is more efficient than doing it per isolated language.
📋 Criterios de aceptación del propio documento

    □

    Los 50 lenguajes están asignados a exactamente una familia principal.
    □

    Cada familia tiene: miembros, perfil, subgrupos, deviations comunes, lecciones.
    □

    Las 11 familias no se solapan (salvo la tabla de "lenguajes en más de una familia", que es explícita).
    □

    Cada familia tiene un identificador F1...F9 estable.
    □

    El documento es usable para organizar la auditoría.
    □

    Cada familia referencia las deviations de DEVIATION_POLICY.md.

🔗 Referencias / References

    docs/PSEUDOCODE_CONVENTION.md — El contrato del pseudocódigo.

    docs/IDIOMATICITY_LEVELS.md — La escala de 4 niveles.

    docs/LANGUAGE_CHARACTERISTICS.md — Los 11 ejes por lenguaje.

    docs/DEVIATION_POLICY.md — Cómo documentar cada desviación.

    data/language_characteristics.tsv — La clasificación máquina-legible.

    data/canonical_names.tsv — La tabla de traducción.

*Última actualización / Last update: 2026-11-02*