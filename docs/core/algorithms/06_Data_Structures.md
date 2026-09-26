---
layout: default
title: 06 — Data Structures
description: Sexta especificación / Sixth specification — Construcción y contratos de estructuras fundamentales
nav_order: 2
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 06 — Data Structures

> [← Volver a 05_Naive_Sort](05_Naive_Sort.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Construir **desde cero** las cinco estructuras fundamentales (**Stack**, **Queue**, **Linked List**, **Binary Tree** y **Graph**) para comprender su representación, su capacidad, sus invariantes y su contrato. El fin es pedagógico: **implementar** la estructura, no usarla. Las aplicaciones posteriores pueden usar el ADT o la colección optimizada del lenguaje cuando implementar la estructura ya no sea el objetivo. | Build the five fundamental data structures (**Stack**, **Queue**, **Linked List**, **Binary Tree** and **Graph**) **from scratch** to understand their representation, capacity, invariants and contract. The goal is pedagogical: **implement** the structure, not use it. Later applications may use the language's ADT or optimized collection once implementing the structure is no longer the goal. |

**ES:** Este módulo fija el **contrato** —qué hace cada operación, qué orden garantiza, qué devuelve cuando falla y qué complejidad se espera— y deja **libre la representación interna**, que debe ser la idiomática del lenguaje. Una lista, un vector inmutable, un término o un diccionario son representaciones válidas mientras cumplan el contrato.

**EN:** This module fixes the **contract** —what each operation does, what order it guarantees, what it returns on failure and what complexity is expected— and leaves the **internal representation free**, and it must be the language's idiomatic one. A list, an immutable vector, a term or a dictionary are valid representations as long as they meet the contract.

**ES:** Fase 1 del roadmap: las operaciones fallidas devuelven el **indicador compatible con el lenguaje** (`-1`, `None`, `null`, `nil`, `false`…) y **no se lanzan excepciones**. Tampoco se introducen `Option`/`Result`/`Maybe`/`Either`: eso llega en la Fase 4.

**EN:** Roadmap Phase 1: failed operations return the **language-compatible indicator** (`-1`, `None`, `null`, `nil`, `false`…) and **no exceptions are thrown**. Neither are `Option`/`Result`/`Maybe`/`Either` introduced: that arrives in Phase 4.

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
|---------|---------|
| Crear `data_structures` como un paquete o módulo importable con las cinco estructuras implementadas desde cero y una API mínima. La suite valida el contrato (operaciones exitosas y sus retornos), los límites (sin capacidad, estructura vacía, nodo inexistente, capacidad inválida), el orden de extracción y los casos que el lenguaje no pueda representar. Cada operación fallida devuelve el indicador de fallo compatible; no lanza excepciones. | Create `data_structures` as an importable package or module with the five structures implemented from scratch and a minimal API. The suite validates the contract (successful operations and their returns), the limits (no capacity, empty structure, missing node, invalid capacity), the removal order and the cases the language cannot represent. Every failed operation returns the compatible failure indicator; it does not throw exceptions. |

### 📐 Contrato único / Single contract

**ES:** Esta tabla es lo único que **no** cambia de un lenguaje a otro. Dos reglas generales: las operaciones que no devuelven un valor devuelven el **indicador de éxito** del lenguaje (`0`, `true`…) o, si fallan, el de fallo; y `init(capacity)` recibe la capacidad como parámetro del contrato, de modo que `capacity` es siempre un dato de entrada, aunque la representación lo trate como límite real o como máximo declarado.

**EN:** This table is the only thing that **does not** change from one language to another. Two general rules: operations that return no value return the language's **success indicator** (`0`, `true`…) or, on failure, the failure one; and `init(capacity)` takes capacity as a contract parameter, so `capacity` is always an input datum, even if the representation treats it as a real limit or as a declared maximum.

| Estructura / Structure | Operaciones / Operations | Semántica / Semantics | Indicador de fallo / Failure indicator | Complejidad esperada / Expected complexity |
|---|---|---|---|---|
| `Stack` | `init(capacity)`, `push(val)`, `pop()`, `peek()`, `is_empty()`, `size()` | **LIFO**: `push` añade arriba, `pop` extrae y devuelve el último insertado, `peek` lo devuelve sin extraerlo<br>**LIFO**: `push` adds on top, `pop` removes and returns the last inserted value, `peek` returns it without removing it | `pop` y `peek` con la estructura vacía; `push` sin capacidad<br>`pop` and `peek` on an empty structure; `push` with no capacity | `push`, `pop`, `peek`, `is_empty`, `size`: $O(1)$ |
| `Queue` | `init(capacity)`, `enqueue(val)`, `dequeue()`, `peek()`, `is_empty()`, `size()` | **FIFO**: `enqueue` añade al final, `dequeue` extrae y devuelve el más antiguo, `peek` lo devuelve sin extraerlo; cuando la representación fija posiciones, las liberadas se reutilizan<br>**FIFO**: `enqueue` adds at the back, `dequeue` removes and returns the oldest one, `peek` returns it without removing it; when the representation fixes slots, freed ones are reused | `dequeue` y `peek` con la estructura vacía; `enqueue` sin capacidad<br>`dequeue` and `peek` on an empty structure; `enqueue` with no capacity | `enqueue`, `dequeue`, `peek`, `is_empty`, `size`: $O(1)$ |
| `LinkedList` | `init(capacity)`, `insert_head(val)`, `insert_tail(val)`, `delete(val)`, `search(val)`, `is_empty()`, `size()` | Secuencia lineal: `insert_head` añade al principio, `insert_tail` al final, `delete` quita la **primera aparición** del valor y `search` responde si el valor está<br>Linear sequence: `insert_head` adds at the front, `insert_tail` at the back, `delete` removes the value's **first occurrence** and `search` answers whether the value is present | `insert_head`/`insert_tail` sin capacidad; `delete` de un valor ausente<br>`insert_head`/`insert_tail` with no capacity; `delete` of an absent value | `insert_head`: $O(1)$ · `insert_tail`: $O(1)$ con referencia al final y $O(n)$ sin ella · `delete`, `search`: $O(n)$ · `is_empty`, `size`: $O(1)$ |
| `BinaryTree` | `init(capacity)`, `insert(val)`, `contains(val)`, `is_empty()`, `size()` | Árbol binario de **búsqueda**: en cada nodo, los valores menores están en su subárbol izquierdo y los mayores en el derecho; `insert` añade respetando esa propiedad y un valor repetido no se inserta; `contains` responde si el valor está<br>**Binary search tree**: at each node, smaller values are in its left subtree and larger ones in its right; `insert` adds respecting that property and a repeated value is not inserted; `contains` answers whether the value is present | `insert` sin capacidad<br>`insert` with no capacity | `insert`, `contains`: $O(h)$ con $h$ la altura — $O(\log n)$ si está equilibrado y $O(n)$ en el peor caso · `is_empty`, `size`: $O(1)$ |
| `Graph` | `init(capacity)`, `add_edge(u, v)`, `has_edge(u, v)`, `get_neighbors(u, out)`, `is_empty()`, `size()` | Grafo **dirigido**: `add_edge` crea la arista $u \to v$, `has_edge` responde si existe, `get_neighbors` escribe en `out` los vecinos de $u$ **en orden creciente** de etiqueta y devuelve cuántos son, y `size` cuenta aristas distintas<br>**Directed** graph: `add_edge` creates the edge $u \to v$, `has_edge` answers whether it exists, `get_neighbors` writes into `out` the neighbours of $u$ **in increasing** label order and returns how many there are, and `size` counts distinct edges | `add_edge` con algún nodo fuera de rango; `get_neighbors` si el nodo no existe (`has_edge` devuelve `false`)<br>`add_edge` with a node out of range; `get_neighbors` when the node does not exist (`has_edge` returns `false`) | `add_edge`, `has_edge`, `is_empty`, `size`: $O(1)$ · `get_neighbors`: $O(V)$ |

### 🔀 Adaptación idiomática / Idiomatic adaptation

**ES:** La representación interna es **libre** y debe ser la idiomática del lenguaje. Lo que no es libre es el contrato:

1. **Semántica**: cada operación hace lo que dice la tabla.
2. **Orden observable**: LIFO en la pila, FIFO en la cola, orden creciente de vecinos en el grafo y propiedad de búsqueda en el árbol.
3. **Indicador de fallo**: el nativo del lenguaje, uno solo y el mismo en todas las operaciones.
4. **Complejidad esperada**: la de la tabla; si la representación elegida no la alcanza, se declara.

**EN:** The internal representation is **free** and must be the language's idiomatic one. What is not free is the contract:

1. **Semantics**: every operation does what the table says.
2. **Observable order**: LIFO in the stack, FIFO in the queue, increasing neighbour order in the graph and search-tree property in the tree.
3. **Failure indicator**: the language's native one, a single one and the same across operations.
4. **Expected complexity**: the table's; if the chosen representation cannot reach it, it is declared.

**ES:** Si el lenguaje no puede representar un caso, **no se inventa un centinela**: el caso se declara **no representable**, se omite de la suite con su motivo y se registra en el README. Los tres que más se repiten son el **overflow** (una colección dinámica no tiene estado «lleno»), el **underflow** (un tipo que no admite valor ausente en esta fase) y el **indicador `-1`** (un retorno que no lo admite).

**EN:** If the language cannot represent a case, **no sentinel is invented**: the case is declared **not representable**, omitted from the suite with its reason and recorded in the README. The three most common are **overflow** (a dynamic collection has no «full» state), **underflow** (a type that admits no absent value in this phase) and the **`-1` indicator** (a return that does not admit it).

**ES:** Cada desviación se escribe en la tabla de *Adaptaciones idiomáticas* del README del módulo, con la regla, la forma elegida y su justificación. Las reglas generales y las familias de limitación están en [`AGENT_Template.md`](../../AGENT_Template.md).

**EN:** Every deviation is written in the module README's *Idiomatic adaptations* table, with the rule, the chosen form and its justification. The general rules and the limitation families are in [`AGENT_Template.md`](../../AGENT_Template.md).

### 🧬 Adaptaciones esperadas por familia / Expected adaptations per family

**ES:** Orientativo, por **familia de limitación**. El dato de cada lenguaje concreto lo declara el README de su módulo, no esta especificación.

**EN:** Indicative, by **limitation family**. Each concrete language's datum is declared by its module README, not by this specification.

| Familia / Family | Ejemplos / Examples | Representación típica / Typical representation | Casos no representables esperados / Expected non-representable cases |
|---|---|---|---|
| Funcional con inmutabilidad / Functional with immutability | Haskell, Elm, PureScript, Scheme, Clojure, Common Lisp, Erlang, Elixir, Gleam, F# | Lista o árbol **inmutable**: cada operación devuelve una estructura nueva<br>**Immutable** list or tree: every operation returns a new structure | Overflow, mutación en el sitio y, a veces, el indicador `-1`<br>Overflow, in-place mutation and, at times, the `-1` indicator |
| Lógico / Logic | Prolog | Términos, listas y hechos: la operación es un predicado<br>Terms, lists and facts: the operation is a predicate | El indicador **como valor** (el fallo es del predicado) y la mutación<br>The indicator **as a value** (failure belongs to the predicate) and mutation |
| Imperativo con arrays / Imperative with arrays | C, Assembly, Ada, COBOL, Forth | Array con **capacidad explícita** e índices: el overflow es representable<br>Array with **explicit capacity** and indices: overflow is representable | La complejidad $O(1)$ de `insert_tail` si solo hay arrays paralelos<br>`insert_tail`'s $O(1)$ complexity if only parallel arrays exist |
| Imperativo moderno / Modern imperative | Go, Java, C#, Kotlin, Swift, Dart, Python, Ruby, JavaScript, TypeScript, PHP | Clase o registro con una colección del lenguaje detrás<br>Class or record with a language collection behind it | Overflow, porque la colección crece sola<br>Overflow, because the collection grows on its own |
| Sistemas / Systems | Rust, C++, Zig, V, Vala, D, Nim, Crystal | Vector o slice con propiedad explícita; índices que pueden no admitir signo<br>Vector or slice with explicit ownership; indices that may not admit a sign | Overflow y el indicador `-1` cuando el índice no admite negativos<br>Overflow and the `-1` indicator when the index admits no negatives |
| Con valor ausente propio / With a native absent value | Lua, Tcl/Tk, REXX, Raku, Perl, R | El valor ausente del lenguaje: `nil`, `undef`, cadena vacía…<br>The language's absent value: `nil`, `undef`, empty string… | Overflow y la distinción entre «vacío» y «valor por defecto»<br>Overflow and the distinction between «empty» and «default value» |

### Pseudocódigo / Pseudocode

**ES:** Este bloque es el **contrato**, no una implementación: describe qué hace cada operación y qué devuelve. La representación interna y las técnicas para conseguirla (arrays paralelos, aritmética modular, celdas libres, nodos enlazados…) son decisión del implementador.

**EN:** This block is the **contract**, not an implementation: it describes what each operation does and returns. The internal representation and the techniques to achieve it (parallel arrays, modular arithmetic, free cells, linked nodes…) are the implementer's decision.

```pseudocode
structure Stack
    init(capacity)     # ES: prepara la estructura para capacity elementos. Éxito, o fallo si la capacidad no es válida.
                       # EN: prepares the structure for capacity elements. Success, or failure if capacity is invalid.
    push(val)          # ES: añade val arriba. Éxito, o fallo si no hay capacidad.
                       # EN: adds val on top. Success, or failure if there is no capacity.
    pop()              # ES: devuelve y extrae el último insertado; fallo si está vacía.
                       # EN: returns and removes the last inserted value; failure if empty.
    peek()             # ES: devuelve el último insertado sin extraerlo; fallo si está vacía.
                       # EN: returns the last inserted value without removing it; failure if empty.
    is_empty()         # ES: true si no hay elementos. · EN: true if there are no elements.
    size()             # ES: número de elementos. · EN: number of elements.

structure Queue
    init(capacity)
    enqueue(val)       # ES: añade val al final. Éxito, o fallo si no hay capacidad.
                       # EN: adds val at the back. Success, or failure if there is no capacity.
    dequeue()          # ES: devuelve y extrae el más antiguo; fallo si está vacía.
                       # EN: returns and removes the oldest value; failure if empty.
    peek()             # ES: devuelve el más antiguo sin extraerlo; fallo si está vacía.
                       # EN: returns the oldest value without removing it; failure if empty.
    is_empty()         # ES: true si no hay elementos. · EN: true if there are no elements.
    size()             # ES: número de elementos. · EN: number of elements.

structure LinkedList
    init(capacity)
    insert_head(val)   # ES: añade val al principio. Éxito, o fallo si no hay capacidad.
                       # EN: adds val at the front. Success, or failure if there is no capacity.
    insert_tail(val)   # ES: añade val al final. Éxito, o fallo si no hay capacidad.
                       # EN: adds val at the back. Success, or failure if there is no capacity.
    delete(val)        # ES: quita la primera aparición de val; fallo si no está.
                       # EN: removes the first occurrence of val; failure if it is not there.
    search(val)        # ES: true si val está en la secuencia. · EN: true if val is in the sequence.
    is_empty()         # ES: true si no hay elementos. · EN: true if there are no elements.
    size()             # ES: número de elementos. · EN: number of elements.

structure BinaryTree
    init(capacity)
    insert(val)        # ES: inserta val respetando la propiedad de búsqueda; un valor repetido no se inserta.
                       #     Éxito, o fallo si no hay capacidad.
                       # EN: inserts val respecting the search property; a repeated value is not inserted.
                       #     Success, or failure if there is no capacity.
    contains(val)      # ES: true si val está en el árbol. · EN: true if val is in the tree.
    is_empty()         # ES: true si no hay nodos. · EN: true if there are no nodes.
    size()             # ES: número de nodos. · EN: number of nodes.

structure Graph
    init(capacity)
    add_edge(u, v)     # ES: crea la arista u -> v. Éxito, o fallo si algún nodo está fuera de rango.
                       # EN: creates the edge u -> v. Success, or failure if a node is out of range.
    has_edge(u, v)     # ES: true si la arista existe; false si no existe o si algún nodo está fuera de rango.
                       # EN: true if the edge exists; false if it does not or if a node is out of range.
    get_neighbors(u, out)
                       # ES: escribe en out los vecinos de u en orden creciente de etiqueta y devuelve
                       #     cuántos son; fallo si el nodo no existe.
                       # EN: writes into out the neighbours of u in increasing label order and returns
                       #     how many there are; failure if the node does not exist.
    is_empty()         # ES: true si no hay aristas. · EN: true if there are no edges.
    size()             # ES: número de aristas distintas. · EN: number of distinct edges.
```

---

## 🧪 Casos de prueba / Test Cases

**ES:** Los casos se agrupan por **enfoque**, no por estructura: el mismo grupo se aplica a las cinco. En las tablas, «indicador de fallo» significa el que el lenguaje declare y el README documente.

**EN:** Cases are grouped by **focus**, not by structure: the same group applies to all five. In the tables, "failure indicator" means the one the language declares and the README documents.

### Grupo 1 — Contrato / Contract

| Estructura / Structure | Caso / Case | Operaciones / Operations | Resultado esperado / Expected result |
|---|---|---|---|
| `Stack` | Apilar y desapilar / Push and pop | `push(10)`, `push(20)`, `pop()`, `pop()` | `20` y después `10` · `20` and then `10` |
| `Queue` | Encolar y desencolar / Enqueue and dequeue | `enqueue(1)`, `enqueue(2)`, `dequeue()`, `dequeue()` | `1` y después `2` · `1` and then `2` |
| `LinkedList` | Inserción por los dos extremos / Insertion at both ends | `insert_head(5)`, `insert_tail(8)`, `search(5)`, `search(8)`, `size()` | `true`, `true`, `2` |
| `LinkedList` | Borrado / Deletion | `insert_head(5)`, `insert_tail(8)`, `delete(5)`, `search(5)`, `size()` | Éxito, `false`, `1` · Success, `false`, `1` |
| `BinaryTree` | Raíz y descendientes / Root and descendants | `insert(50)`, `insert(30)`, `insert(70)`, `contains(30)`, `contains(70)`, `contains(99)` | `true`, `true`, `false` |
| `BinaryTree` | Valor repetido / Repeated value | `insert(50)`, `insert(50)`, `size()` | Éxito y `size() == 1` · Success and `size() == 1` |
| `Graph` | Aristas dirigidas / Directed edges | `add_edge(0, 1)`, `has_edge(0, 1)`, `has_edge(1, 0)` | `true`, `false` |
| `Graph` | Arista repetida no cuenta dos veces / Repeated edge does not count twice | `add_edge(0, 1)`, `add_edge(0, 1)`, `size()` | `1` |
| Todas / All | Capacidad válida / Valid capacity | `init(4)` | Éxito · Success |

### Grupo 2 — Límites / Limits

| Estructura / Structure | Caso / Case | Operaciones / Operations | Resultado esperado / Expected result |
|---|---|---|---|
| `Stack` | Vacía / Empty | `pop()`, `peek()` | Indicador de fallo en las dos · Failure indicator in both |
| `Stack` | Sin capacidad / No capacity | `push(val)` con la capacidad agotada · `push(val)` with capacity exhausted | Indicador de fallo y contenido intacto · Failure indicator and content unchanged |
| `Queue` | Vacía / Empty | `dequeue()`, `peek()` | Indicador de fallo en las dos · Failure indicator in both |
| `Queue` | Sin capacidad / No capacity | `enqueue(val)` con la capacidad agotada · `enqueue(val)` with capacity exhausted | Indicador de fallo y contenido intacto · Failure indicator and content unchanged |
| `LinkedList` | Borrado ausente / Absent deletion | `delete(99)` | Indicador de fallo · Failure indicator |
| `LinkedList` | Sin capacidad / No capacity | `insert_head(val)` con la estructura llena · `insert_head(val)` on a full structure | Indicador de fallo · Failure indicator |
| `BinaryTree` | Sin capacidad / No capacity | `insert(val)` cuando no queda sitio · `insert(val)` when there is no room | Indicador de fallo · Failure indicator |
| `Graph` | Nodo fuera de rango / Node out of range | `add_edge(0, 99)`, `get_neighbors(99, out)`, `has_edge(0, 99)` con capacidad `3` · with capacity `3` | Fallo, fallo y `false` · Failure, failure and `false` |
| Todas / All | Capacidad inválida / Invalid capacity | `init(0)` | Indicador de fallo · Failure indicator |

### Grupo 3 — Orden de extracción / Removal order

| Estructura / Structure | Caso / Case | Operaciones / Operations | Resultado esperado / Expected result |
|---|---|---|---|
| `Stack` | LIFO | `push(1)`, `push(2)`, `push(3)`, `pop()`, `pop()` | `3` y después `2` · `3` and then `2` |
| `Queue` | FIFO | `enqueue(1)`, `enqueue(2)`, `enqueue(3)`, `dequeue()`, `dequeue()` | `1` y después `2` · `1` and then `2` |
| `Queue` | Reutilización de posiciones / Slot reuse | Llenar, extraer uno, insertar otro · Fill, remove one, insert another | La inserción tiene éxito y el orden se conserva · The insertion succeeds and the order is preserved |
| `LinkedList` | Orden establecido por los extremos / Order set by both ends | `insert_tail(1)`, `insert_tail(2)`, `insert_head(0)` | Al extraer por búsqueda, `0` precede a `1` y `1` a `2` · Searching finds `0` before `1` and `1` before `2` |
| `BinaryTree` | Propiedad de búsqueda / Search property | `insert(50)`, `insert(30)`, `insert(70)`, `contains(...)` | Se encuentran los tres y `size() == 3` · All three are found and `size() == 3` |
| `Graph` | Vecinos en orden creciente / Neighbours in increasing order | `add_edge(0, 2)`, `add_edge(0, 1)`, `get_neighbors(0, out)` | `2` vecinos: primero `1` y después `2` · `2` neighbours: `1` first and then `2` |

### Grupo 4 — Casos no representables / Non-representable cases

**ES:** No se prueba aquí si un caso no se puede modelar: se **declara** y se omite, dejándolo por escrito en el README del módulo. Esta tabla es la lista de expectativas; el detalle real lo fija cada lenguaje.

**EN:** A case that cannot be modelled is not tested here: it is **declared** and omitted, put in writing in the module README. This table is the list of expectations; the real detail is set by each language.

| Caso / Case | Cuándo no es representable / When it is not representable | Qué se hace / What is done |
|---|---|---|
| Overflow (`push`, `enqueue`, `insert`) | La colección crece sola y no existe el estado «lleno»<br>The collection grows on its own and there is no «full» state | Se declara; `capacity` pasa a ser un máximo declarado o ilimitado<br>It is declared; `capacity` becomes a declared maximum or is unbounded |
| Underflow (`pop`, `dequeue`, `peek`) | El tipo de retorno no admite un valor ausente y la fase prohíbe `Option`/`Maybe`<br>The return type admits no absent value and the phase forbids `Option`/`Maybe` | Se declara la representación equivalente del indicador, o se omite el caso<br>The indicator's equivalent representation is declared, or the case is omitted |
| Indicador `-1` | El tipo no admite negativos (índices sin signo, cadenas, tipos de valor)<br>The type admits no negatives (unsigned indices, strings, value types) | Se usa el indicador nativo del lenguaje y se declara<br>The language's native indicator is used and declared |
| `get_neighbors(u, out)` | El lenguaje devuelve colecciones de forma idiomática<br>The language returns collections idiomatically | Se devuelve la colección en lugar de escribir en `out`<br>The collection is returned instead of writing into `out` |
| Mutación de la estructura | El lenguaje es inmutable: las operaciones devuelven una estructura nueva<br>The language is immutable: operations return a new structure | Se declara la desviación; se conservan semántica, orden y complejidad<br>The deviation is declared; semantics, order and complexity are preserved |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Las cinco estructuras se implementan **desde cero**, sin apoyarse en la colección del lenguaje para la operación que el módulo existe para construir.
      **EN:** All five structures are implemented **from scratch**, without relying on the language collection for the operation the module exists to build.
- [ ] **ES:** El contrato se respeta: semántica de cada operación, orden observable, indicador de fallo y complejidad esperada.
      **EN:** The contract is respected: each operation's semantics, observable order, failure indicator and expected complexity.
- [ ] **ES:** Las pruebas están agrupadas por enfoque (contrato, límites, orden de extracción y casos no representables).
      **EN:** Tests are grouped by focus (contract, limits, removal order and non-representable cases).
- [ ] **ES:** Cada desviación está declarada en la tabla de *Adaptaciones idiomáticas* del README, incluidos los casos no representables que se hayan omitido.
      **EN:** Every deviation is declared in the README's *Idiomatic adaptations* table, including the non-representable cases that were omitted.
- [ ] **ES:** El README se genera desde [`README_Template.md`](../../README_Template.md) y declara la cobertura caso por caso.
      **EN:** The README is generated from [`README_Template.md`](../../README_Template.md) and states the coverage case by case.
- [ ] **ES:** La evidencia de ejecución está en `docs/evidence/{fase}/{módulo}/{lenguaje}.md`, enlazada desde el README.
      **EN:** The execution evidence is in `docs/evidence/{phase}/{module}/{language}.md`, linked from the README.

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── algorithms/
            └── data_structures/
                ├── src/
                │   └── data_structures.ext
                └── test/
                    ├── data_structures_test.ext
                    └── run_tests.ext
```

**ES:** Ese árbol es el propuesto. El layout real de cada lenguaje (carpeta de pruebas, manifiesto, runner) es el que fija [`00_Project_Initialization_Guide.md`](../00_Project_Initialization_Guide.md), y cuando se desvíe se declara en la tabla de *Adaptaciones idiomáticas* del README del módulo.

**EN:** That tree is the proposed one. Each language's real layout (test folder, manifest, runner) is the one set by [`00_Project_Initialization_Guide.md`](../00_Project_Initialization_Guide.md), and any deviation is declared in the module README's *Idiomatic adaptations* table.

---

## ▶️ Siguiente / Next

👉 Sigue con [`07_Efficient_Sort.md`](07_Efficient_Sort.md).
👉 Continue with [`07_Efficient_Sort.md`](07_Efficient_Sort.md).

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
