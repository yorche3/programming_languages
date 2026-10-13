# 🗣️ {Language Name} — Convenciones e Idioms / Idioms and Conventions

> **ES:** Este documento es la referencia de convenciones del lenguaje `{lang}` en el monorepo. Es la fuente de verdad para: cómo se traduce el pseudocódigo canónico, qué desviaciones existen y por qué, y cómo se ejecuta el ciclo del sprint. Complementa `docs/ruleset/PSEUDOCODE_CONVENTION.md` (el contrato) y `data/language_characteristics.tsv` (los 11 ejes clasificados).
>
> **EN:** This document is the conventions reference for the `{lang}` language in the monorepo. It is the source of truth for: how the canonical pseudocode is translated, which deviations exist and why, and how the sprint cycle runs. It complements `docs/ruleset/PSEUDOCODE_CONVENTION.md` (the contract) and `data/language_characteristics.tsv` (the 11 classified axes).

---

## 📇 Ficha rápida / Quick reference

| Campo / Field | Valor / Value |
|---------------|---------------|
| **Nombre / Name** | {Language Name} |
| **Código / Code** | `{lang}` |
| **Familia / Family** | {F1...F9} — {Family name} |
| **Variante de pseudocódigo / Pseudocode variant** | {V1 | V2 | V3 | V4} |
| **Repositorio / Repository** | `git@github.com:yorche3/{lang}.git` |

**ES:** Los datos del lenguaje **no se repiten aquí**: viven en los TSV de `data/` (`language_characteristics`, `canonical_names`, `init_sequences`, `idiomaticity_state`) y en `PARADIGM_FAMILIES.md`. Cualquier valor duplicado en este documento es un bug.

**EN:** The language facts are **not repeated here**: they live in the TSVs under `data/` (`language_characteristics`, `canonical_names`, `init_sequences`, `idiomaticity_state`) and in `PARADIGM_FAMILIES.md`. Any value duplicated in this document is a mistake.

---

## 1. Perfil del lenguaje / Language profile

**ES:** Resumen cualitativo del lenguaje: su paradigma, su modelo de memoria, su filosofía. Es la sección que un lector nuevo debería leer primero.

**EN:** Qualitative summary of the language: its paradigm, its memory model, its philosophy. This is the section a new reader should read first.

**ES:** Máximo 5–8 líneas. Referencia a la documentación oficial.

**EN:** Maximum 5–8 lines. Reference to official documentation.

**Plantilla / Template:**

> {Language Name} es un lenguaje {paradigm}, con {mutability} por defecto, {memory model}, y verificación de tipos {type system}. Su filosofía central es {core philosophy}. Se usa principalmente en {main use cases}.
>
> The community favors {community conventions}. The language was designed by {author/community} in {year} with the goal of {original goal}.

**Ejemplo relleno (Rust) / Filled example (Rust):**

> Rust es un lenguaje multi-paradigma con ownership y préstamos, verificación estática en compilación, y gestión de memoria por RAII sin GC. Su filosofía central es la seguridad de memoria sin costo en runtime. Se usa principalmente en sistemas, CLI, WASM y servicios backend.
>
> La comunidad favorece la explicitud sobre la convención implícita: si algo puede fallar, el tipo lo dice (`Result`, `Option`). Fue diseñado por Graydon Hoare en Mozilla en 2010, con el objetivo de eliminar los bugs de memoria de C/C++ sin GC.

---

## 2. Convenciones de nombres / Naming conventions

**ES:** Cómo se nombran los identificadores del lenguaje. Es la base para traducir los nombres conceptuales del pseudocódigo.

**EN:** How language identifiers are named. It is the basis for translating conceptual pseudocode names.

| Elemento / Element | Convención / Convention | Ejemplo / Example |
|--------------------|------------------------|-------------------|
| Tipos / Types | {PascalCase / snake_case / ...} | {`Node`, `linked_list`, ...} |
| Funciones / Functions | {camelCase / snake_case / kebab-case / ...} | {`insertHead`, `insert_head`, ...} |
| Variables / Variables | {camelCase / snake_case / ...} | {`headNode`, `head_node`, ...} |
| Constantes / Constants | {SCREAMING_SNAKE_CASE / ...} | {`MAX_SIZE`, ...} |
| Módulos / Modules | {snake_case / PascalCase / ...} | {`data_structures_basics`, ...} |
| Predicados / Predicates | {prefijo `is_` / sufijo `?` / ...} | {`isEmpty`, `empty?`, ...} |
| Archivos / Files | {snake_case / kebab-case / ...} | {`linked_list.rs`, `linked-list.ts`, ...} |

**ES:** Los predicados son una convención **fuerte** del lenguaje: si `isEmpty` no es la forma idiomática, hay que documentar la desviación.

**EN:** Predicates are a **strong** convention of the language: if `isEmpty` is not the idiomatic form, the deviation must be documented.

**ES:** La traducción concepto → nombre **no se repite aquí**: es la fila de `{lang}` en `data/canonical_names.tsv`.

**EN:** The concept → name translation is **not repeated here**: it is the `{lang}` row in `data/canonical_names.tsv`.

---

## 3. Construcción / Construction

**ES:** Cómo se crea una instancia del tipo. Es la traducción de `init` en el pseudocódigo.

**EN:** How an instance of a type is created. It is the translation of `init` in the pseudocode.

**Forma idiomática / Idiomatic form:**

```{lang}
{code example: how to construct a Node and a LinkedList}

Notas / Notes:

    {ES: restricciones, invariantes, cuándo se inicializan los campos}

    {EN: restrictions, invariants, when fields are initialized}

Anti-patrones / Anti-patterns:

    {ES: qué NO hacer (ej. init() como método en vez de constructor)}

    {EN: what NOT to do}

Ejemplo relleno (Rust) / Filled example (Rust):
rust

let n = Node::new(10);
let l = LinkedList::new();

Notes:

    Los campos se inicializan en el constructor. LinkedList::new() produce una lista vacía.

    Default está implementado para LinkedList, Stack, Queue — LinkedList::default() es equivalente a LinkedList::new().

Anti-patterns:

    ❌ fn init(&mut self, v: i32) — init no es idiomático en Rust; el constructor es new().

    ❌ LinkedList { head: None, count: 0 } directamente desde fuera — usar LinkedList::new().

## 4. Fallo / Failure

ES: Cómo se representa "no hay valor" y cómo se propaga un fallo. Determina el indicador de la spec.

EN: How "no value" is represented and how failure propagates. Determines the spec's indicator.

Modelo idiomático / Idiomatic model:
Operación fallible / Fallible operation	Retorno / Return
{head, pop, peek, dequeue}	{Option<i32> / int? / (T, bool) / ...}
{operaciones que devuelven valor + estado}	{Option<(i32, T)> / ...}

Ejemplo / Example:
{lang}

{code example: how to check and unwrap a fallible result}

Anti-patrones / Anti-patterns:

    {ES: usar sentinel -1 cuando el lenguaje tiene Option}

    {EN: using sentinel -1 when the language has Option}

Ejemplo relleno (Rust) / Filled example (Rust):
rust

match stack.pop() {
    Some(v) => println!("popped {}", v),
    None    => println!("empty"),
}

Anti-patterns:

    ❌ fn pop(&mut self) -> i32 { -1 } — Rust tiene Option<i32>; -1 no es idiomático.

    ❌ panic!("empty") en pop — viola la política de no excepciones en Fase 1.

## 5. Acceso / Access

ES: Cómo se lee y escribe un campo. Determina si se usan propiedades, métodos o acceso directo.

EN: How a field is read and written. Determines whether properties, methods or direct access are used.

Forma idiomática / Idiomatic form:
Operación / Operation	Forma / Form
Leer value	{node.value / node.value() / (node-value n) / ...}
Leer next	{node.next / node.next() / ...}
Escribir next	{node.next = x / node.set_next(x) / node.with_next(x) / ...}

Ejemplo relleno (Rust) / Filled example (Rust):
Operación / Operation	Forma / Form
Leer value	node.value()
Leer next	node.next() → Option<&Node>
Escribir next	node.set_next(Some(box nuevo))

Notas:

    En Rust, value es un método porque el campo es privado.

    next() devuelve un préstamo, no una copia. Para mutar, existe next_mut().

## 6. Encapsulación / Encapsulation

ES: Cómo se oculta la representación interna. Determina si los campos son privados, públicos o accesibles por convención.

EN: How the internal representation is hidden. Determines whether fields are private, public, or accessible by convention.
Nivel / Level	Forma / Form
Campos privados	{private / # / _ prefix / mut: block / ...}
Módulo / namespace	{pub / export / :: / ...}
API pública	{lista de operaciones expuestas}

Ejemplo relleno (Rust) / Filled example (Rust):
Nivel / Level	Forma / Form
Campos privados	Sí — value: i32, next: Option<Box<Node>> sin pub
Módulo / namespace	pub mod data_structures_basics; en lib.rs
API pública	Node::new, Node::value, Node::next, LinkedList::new, ...

Notas:

    Rust no tiene private de módulo por campo; la visibilidad es por ítem.

    Si un campo no lleva pub, es privado para el módulo.

## 7. Palabras reservadas y conflictos / Reserved words and conflicts

ES: Nombres que no se pueden usar porque colisionan con keywords del lenguaje, con la BCL, o con propiedades integradas.

EN: Names that cannot be used because they collide with language keywords, the BCL, or built-in properties.
Nombre canónico / Canonical name	Conflicto / Conflict	Traducción forzosa / Forced translation
{delete}	{keyword}	{remove}
{next}	{method of Iterator}	{next_of / siguiente}
{size}	{preferido len}	{len}

Ejemplo relleno (Rust) / Filled example (Rust):
Nombre canónico / Canonical name	Conflicto / Conflict	Traducción forzosa / Forced translation
size	Convención de la stdlib prefiere len	len()
next	Método de Iterator	next() sobre &self es distinto por firma; se acepta
## 8. Complejidad / Complexity

ES: Complejidad real de las operaciones, especialmente si difiere de la spec.

EN: Real complexity of the operations, especially if it differs from the spec.
Operación / Operation	Spec	Real	Desviación / Deviation
insert_head	O(1)	{O(1)}	Ninguna
insert_tail	O(1)	{O(n)}	{C5 — inmutabilidad}
delete	O(n)	{O(n)}	Ninguna

Justificación / Justification:

    {ES: por qué la complejidad real difiere; alternativa descartada}

    {EN: why the real complexity differs; discarded alternative}

Ejemplo relleno (Rust) / Filled example (Rust):
Operación / Operation	Spec	Real	Desviación / Deviation
insert_head	O(1)	O(1)	Ninguna
insert_tail	O(1)	O(n)	C5
delete	O(n)	O(n)	Ninguna

Justificación: con Option<Box<Node>>, extender la cadena al final requiere recorrerla completa. O(1) requeriría Rc<RefCell<>> (con costo de ref-counting) o punteros crudos con unsafe (descartado por política). Se elige O(n) manteniendo la seguridad.
## 9. Desviaciones del pseudocódigo canónico / Deviations from the canonical pseudocode

> **ES:** Esta sección declara las **peculiaridades del lenguaje que causan desviaciones** (estables). La desviación **concreta de cada módulo** se justifica en el README de ese módulo con el formato de `DEVIATION_POLICY.md`, y su estado está en `data/idiomaticity_state.tsv`.
>
> **EN:** This section states the **language peculiarities that cause deviations** (stable). The **concrete deviation of each module** is justified in that module's README using the `DEVIATION_POLICY.md` format, and its state lives in `data/idiomaticity_state.tsv`.

ES: Lista de desviaciones siguiendo la plantilla de DEVIATION_POLICY.md. Cada desviación tiene categoría (C1–C6), severidad (🟢🟡🟠🔴) y estado.

EN: List of deviations following the DEVIATION_POLICY.md template. Each deviation has category (C1–C6), severity (🟢🟡🟠🔴) and state.

ES: Si no hay desviaciones, se escribe "No hay desviaciones / No deviations" y el lenguaje puede aspirar a idiomatic.

EN: If there are no deviations, write "No hay desviaciones / No deviations" and the language may aspire to idiomatic.
D1 — {Título corto / Short title}

Concepto / Concept: {nombre canónico del pseudocódigo}
Categoría / Category: {C1 | C2 | C3 | C4 | C5 | C6}
Severidad / Severity: {🟢 | 🟡 | 🟠 | 🔴}
Estado / State: {active | under-revision | scheduled-for-fix}

Desviación / Deviation:
{Qué es lo que difiere. Una frase clara.}

Motivo / Reason:
{Por qué el lenguaje requiere esta desviación.}

Impacto / Impact:
{Qué debe saber el lector. Qué NO cambia del contrato.}

Alternativas descartadas / Discarded alternatives:
{Qué otras opciones se consideraron y por qué no se eligieron.}

Evidencia / Evidence:
{Commit o PR donde se introdujo. Link a la línea del código.}
D2 — ...

{...}
## 10. Tests / Tests

ES: Convenciones de testing del lenguaje: framework, estructura, cómo se ejecuta.

EN: Language testing conventions: framework, structure, how it is run.
Aspecto / Aspect	Valor / Value
Framework	{nombre del framework}
Ubicación / Location	{tests/ / inline / test/}
Comando / Command	{cargo test / sbt test / ...}
Convención de nombre / Naming convention	{*_test.rs / *_spec.rb / ...}

ES: El runner se declara en data/init_sequences.tsv y language_characteristics.tsv.

EN: The runner is declared in data/init_sequences.tsv and language_characteristics.tsv.

Ejemplo / Example:
{lang}

{code example: a simple test for the module}

## 11. Tooling / Tooling

ES: Comandos exactos del ciclo del sprint.

EN: Exact commands of the sprint cycle.
Paso del sprint / Sprint step	Comando / Command
Scaffold	{comando de init / create}
Build	{comando de build}
Test	{comando de test}
Lint / verify	{comando de lint}
Format	{comando de format}
Package	{comando de package / publish, si aplica}

ES: Los comandos canónicos viven en data/init_sequences.tsv. Aquí se listan para referencia rápida.

EN: Canonical commands live in data/init_sequences.tsv. Listed here for quick reference.

Ejemplo relleno (Rust) / Filled example (Rust):
Paso del sprint / Sprint step	Comando / Command
Scaffold	cargo init --lib
Build	cargo build
Test	cargo test
Lint / verify	cargo clippy -- -D warnings
Format	cargo fmt -- --check
Package	cargo publish
## 12. Referencias / References

ES: Documentación oficial y recursos recomendados.

EN: Official documentation and recommended resources.

    Official docs: {URL}

    Style guide / API guidelines: {URL}

    Community conventions: {URL}

    Related families in this monorepo: {F4 — Sistemas modernos con option}

    Related languages in this monorepo: {zig, v, nim, julia, go, d}

📋 Criterios de aceptación del documento / Acceptance criteria

ES: Un docs/ruleset/idioms/{lang}.md está completo cuando:

EN: A docs/ruleset/idioms/{lang}.md is complete when:

    □

    La ficha rápida declara nombre, código, familia, variante y repositorio, y **no repite** valores de los TSV.
    □

    La sección de nombres declara las convenciones del lenguaje (la traducción vive en `canonical_names.tsv`).
    □

    La sección de construcción tiene ejemplo y anti-patrones.
    □

    La sección de fallo declara el indicador y justifica.
    □

    La sección de acceso declara la forma idiomática de lectura/escritura.
    □

    La sección de encapsulación declara el nivel de ocultamiento.
    □

    La sección de palabras reservadas lista los conflictos conocidos.
    □

    La sección de complejidad declara la real y justifica desviaciones.
    □

    Todas las desviaciones siguen la plantilla de DEVIATION_POLICY.md.
    □

    La sección de tests declara framework y comando.
    □

    La sección de tooling lista los comandos del sprint.
    □

    Las referencias están completas.

ES: Las desviaciones concretas quedan justificadas en el README del módulo y contadas en deviations_documented de data/idiomaticity_state.tsv.

EN: The number of deviations in section 9 matches deviations_documented in data/idiomaticity_state.tsv.

Última actualización / Last update: {YYYY-MM-DD}