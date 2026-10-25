---
layout: default
title: 07 — Data Structures Advanced
description: Séptima especificación / Seventh specification — Node con múltiples enlaces, árboles y grafos
nav_order: 3
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 07 — Data Structures Advanced

> [← Volver a 06_Data_Structures_Basics](06_Data_Structures_Basics.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

## 🎯 Objetivo / Objective

| Español | English |
|---|---|
| Construir estructuras que requieren más de un enlace por nodo: un árbol binario de búsqueda y un grafo dirigido. | Build structures that require more than one link per node: a binary search tree and a directed graph. |

Este módulo declara una **base `Node` con el valor** y dos nodos derivados: `TreeNode` (enlaces izquierdo/derecho) y `GraphNode` (adyacencias dirigidas). La base **no valida nada** —no tiene enlaces ni indicadores de fallo—: cada hijo valida los suyos. No importa ni reutiliza código de `data_structures_basics`: la base es local al módulo, y el `Node` del 06 (`value` + `next`) no es el mismo tipo.

This module declares a **`Node` base carrying the value** and two derived nodes: `TreeNode` (left/right links) and `GraphNode` (directed adjacency). The base **validates nothing** — it has no links and no failure indicators; each child validates its own. It does not import or reuse code from `data_structures_basics`: the base is local to this module, and module 06's `Node` (`value` + `next`) is not the same type.

---

## 🧭 Cómo leer este módulo / How to read this module

> **ES:** Esta página fija **qué** se exige. Para el **cómo** y el **porqué** de cada familia de lenguajes (base con valor por herencia o embebida, mutabilidad de enlaces y registro de vértices), la guía del módulo: [`implementations/07_Data_Structures_Advanced.md`](../../implementations/07_Data_Structures_Advanced.md).
>
> **EN:** This page fixes **what** is required. For the **how** and the **why** of each language family (value base through inheritance or embedding, link mutability and vertex registration), see the module guide: [`implementations/07_Data_Structures_Advanced.md`](../../implementations/07_Data_Structures_Advanced.md).

## 📖 Concepto: múltiples referencias / Concept: multiple links

Un `TreeNode` tiene `Value`, `Left` y `Right`. Un `GraphNode` tiene una `Label` y su propia secuencia de etiquetas vecinas. El nombre y la representación concreta son idiomáticos, pero los valores, enlaces e invariantes se observan mediante la API de cada estructura.

A `TreeNode` has `Value`, `Left` and `Right`. A `GraphNode` has a `Label` and its own sequence of neighbour labels. Names and concrete representations are idiomatic, but values, links and invariants are observed through each structure's API.

La base es **`Node(value)`**: solo el valor, sin enlaces y **sin validaciones**; no se instancia por sí sola. Admite **dos formas**: herencia real del tipo base donde el lenguaje la tenga, o **valor embebido** (el valor declarado dentro del propio nodo hijo, sin tipo base). Las dos son válidas y el README declara cuál se usa.

The base is **`Node(value)`**: only the value, no links and **no validations**; it is not instantiated on its own. It admits **two forms**: real inheritance from the base type where the language has it, or an **embedded value** (the value declared inside the child node itself, with no base type). Both are valid and the README declares which one is used.

La `LinkedList<T>` de la biblioteca estándar puede almacenar la secuencia de vecinos de `GraphNode`; esa lista no sustituye al `Graph`. Localizar un vértice y recorrer sus vecinos son costes distintos. `BinaryTree` y las operaciones de `Graph` siguen siendo implementaciones propias; no se usan algoritmos de alto nivel que oculten el aprendizaje.

The standard library's `LinkedList<T>` may store `GraphNode`'s neighbour sequence; that list does not replace `Graph`. Locating a vertex and traversing its neighbours are distinct costs. `BinaryTree` and `Graph` operations remain the implementation under study; no high-level algorithms may hide the learning objective.

## 📐 Contrato común y aislamiento / Common contract and isolation

1. El módulo declara una base `Node` que **solo** contiene el valor (`init(value)`, `get_value()`), sin enlaces y sin validaciones; no se instancia. `TreeNode` deriva de ella y añade los enlaces `Left`/`Right`, validando ambos. `GraphNode` deriva de ella y añade su secuencia de adyacencia, validando orden creciente y ausencia de duplicados. La reutilización del valor se hace por herencia o por valor embebido, según declare el README.
2. `BinaryTree` y `Graph` tienen tipos nuevos y constructores equivalentes a `init`. `Graph` puede usar el `LinkedList<T>` de la biblioteca estándar como almacenamiento de vecinos, pero implementa manualmente sus propias operaciones e invariantes; la colección no sustituye al ADT `Graph`.
3. Los indicadores de éxito y fallo son los valores representables y no ambiguos que declare el README de cada lenguaje. No se fuerza `-1`, `null`, `nil`, `Option` o `Result` cuando el lenguaje o la fase no los admiten.
4. Los valores de prueba son enteros positivos o el subtipo entero equivalente que evite colisiones con los indicadores del lenguaje.
5. Cada adaptación de mutabilidad, ausencia, memoria o vecinos se documenta como adaptación idiomática; no se impone un array ni una capacidad máxima al ADT.

1. The module declares a `Node` base that holds **only** the value (`init(value)`, `get_value()`), with no links and no validations; it is not instantiated. `TreeNode` derives from it and adds the `Left`/`Right` links, validating both. `GraphNode` derives from it and adds its adjacency sequence, validating ascending order and absence of duplicates. The value is reused through inheritance or an embedded value, as declared in the README.
2. `BinaryTree` and `Graph` have new types and constructors equivalent to `init`. `Graph` may use the standard library's `LinkedList<T>` as neighbour storage, but it manually implements its own operations and invariants; the collection does not replace the `Graph` ADT.
3. Success and failure indicators are the representable, unambiguous values documented in each language README. `-1`, `null`, `nil`, `Option` or `Result` are not forced when the language or phase does not admit them.
4. Test values are positive integers or the equivalent integer subtype that avoids collisions with the language's indicators.
5. Every adaptation for mutability, absence, memory or neighbours is documented as an idiomatic adaptation; neither an array nor a maximum capacity is imposed on the ADT.

**ES:** **Implementación manual obligatoria en este módulo.** El registro global
de vértices se construye con nodos/enlaces propios (o términos y reconstrucción
persistente equivalentes), y su búsqueda por etiqueta se escribe recorriéndolos.
No se delega ese registro en `HashMap`, `Dict`, `Map`, `Set`, diccionarios,
tablas hash, árboles de biblioteca ni índices por etiqueta. La excepción de
`LinkedList<T>` se limita al almacenamiento de vecinos: la búsqueda, detección
de duplicados e inserción ordenada de la adyacencia se escriben manualmente.
No se delegan en conjuntos, mapas ni operaciones de búsqueda, ordenación o
inserción ordenada de biblioteca. Las primitivas de asignación, enlace y recorrido
del lenguaje o de la lista permitida sí pueden usarse. La revisión de código
comprueba estas decisiones; los tests de resultados y una cota `O(V)` por sí
solos no distinguen una implementación manual de una colección optimizada.

**EN:** **Manual implementation is required in this module.** Build the global
vertex registry with own nodes/links (or equivalent terms and persistent
reconstruction), and write label lookup by traversing them. Do not delegate this
registry to `HashMap`, `Dict`, `Map`, `Set`, dictionaries, hash tables, library
trees or label indexes. The `LinkedList<T>` exception applies only to neighbour
storage: write adjacency lookup, duplicate detection and sorted insertion
manually. Do not delegate them to sets, maps or library search, sorting or
sorted-insertion operations. Language or permitted-list allocation, linking and
traversal primitives are allowed. Code review checks these choices; output tests
and an `O(V)` upper bound alone do not distinguish manual implementation from
an optimised collection.

## 🧩 Estructuras / Structures

| Estructura / Structure | Operaciones / Operations | Contrato e invariantes / Contract and invariants | Complejidad / Complexity |
|---|---|---|---|
| `Node` | `init(value)`, `get_value()` | Base local del módulo: **solo el valor**. Sin enlaces, sin validaciones y sin instancias propias; el valor se reutiliza por herencia o embebido. | `O(1)` |
| `TreeNode` | `init(value)`, `get_value()`, `get_left()`, `get_right()`, `set_left(node)`, `set_right(node)` | Nodo propio del ABB; un enlace ausente representa un subárbol vacío. | `O(1)` |
| `BinaryTree` | `init()`, `insert(value)`, `contains(value)`, `is_empty()`, `size()` | ABB sin capacidad máxima contractual: menores a la izquierda, mayores a la derecha; duplicados no aumentan el tamaño. `contains` sigue la invariante del ABB, no una búsqueda sobre secuencias. / BST without a contractual maximum capacity; duplicates do not grow size; membership follows the BST invariant. | `init`, vacío y tamaño: `O(1)`; insertar y pertenencia: `O(h)`, `h` = altura actual |
| `GraphNode` | `init(label)` (interno a `Graph`) | Etiqueta única del vértice, secuencia de vecinos sin duplicados y enlace al siguiente vértice del registro canónico. / Unique vertex label, unique neighbours and a link to the next vertex in the canonical registry. | `O(1)` |
| `Graph` | `init()`, `add_vertex(label)`, `add_edge(u,v)`, `has_edge(u,v)`, `get_neighbors(u)`, `is_empty()`, `vertex_count()`, `edge_count()` | Grafo dirigido sin aristas paralelas; admite bucles. Vértices explícitos con etiquetas enteras, no índices de array. Vacío significa sin vértices; contadores separados. Vecinos en orden creciente por decisión del módulo. / Directed graph without parallel edges; self-loops allowed. Explicit integer-labelled vertices, not array indices. Empty means no vertices; separate counts. Ascending neighbours are a module decision. | Registro enlazado canónico: `init`, vacío y contadores: `O(1)`; `add_vertex`: `O(V)`; `add_edge`, `has_edge`, `get_neighbors`: `O(V + d(u))` |

> **ES:** Decisión del **2026-10-17**: la base es `Node(value)`, **solo el valor y sin validaciones** —no tiene enlaces ni indicador de fallo— y no se instancia. `TreeNode` y `GraphNode` la reutilizan por **herencia** (donde el lenguaje la tenga) o por **valor embebido** (composición), y **cada hijo valida sus propios enlaces**. Las dos formas son válidas y el README declara cuál se usa. No se confunde con el `Node` del módulo 06, que es `value + next` y pertenece a otro contrato.
>
> **EN:** Decision of **2026-10-17**: the base is `Node(value)`, **value only and no validations** — no links and no failure indicator — and it is not instantiated. `TreeNode` and `GraphNode` reuse it through **inheritance** (where the language has it) or an **embedded value** (composition), and **each child validates its own links**. Both forms are valid and the README declares which one is used. It is not to be confused with module 06's `Node`, which is `value + next` and belongs to another contract.

**ES:** Corrección de contrato del **2026-10-24**: `BinaryTree.init()` y
`Graph.init()` crean estructuras vacías utilizables, sin parámetro `capacity`,
estado «lleno» ni instancia inutilizable. Un ABB no es acotado por definición;
un grafo se define por vértices y aristas, no por índices preasignados.
`add_vertex(label)` registra explícitamente cada vértice, incluidos los aislados.
Las etiquetas son valores enteros representables y distintos, no necesariamente
consecutivos. `add_edge` exige ambos extremos existentes. Los bucles están
permitidos y las aristas repetidas no se multiplican.

**EN:** Contract correction of **2026-10-24**: `BinaryTree.init()` and
`Graph.init()` create usable empty structures, without a `capacity` parameter,
full state or unusable instance. A BST is not bounded by definition; a graph is
defined by vertices and edges, not preallocated indices. `add_vertex(label)`
explicitly registers each vertex, including isolated ones. Labels are distinct
representable integers, not necessarily consecutive. `add_edge` requires both
endpoints to exist. Self-loops are allowed; repeated edges are not multiplied.

**ES:** Ordenar vecinos es una política para resultados deterministas, no una
propiedad universal del grafo. Los límites físicos de memoria y las adaptaciones
del toolchain se documentan por lenguaje; no se convierten en una capacidad
arbitraria del contrato ni en casos de «estructura llena». No se exige simular
agotamiento de memoria. Arrays y secuencias indexables pueden ser apropiados en
otros módulos (por ejemplo, ordenamiento), sin imponerse a estas estructuras.
Esta corrección exige revisar contratos, suites y READMEs previos del 07; no
certifica ni modifica implementaciones existentes.

**EN:** Sorted neighbours are a deterministic-output policy, not a universal
graph property. Document physical memory limits and toolchain adaptations per
language; do not turn them into arbitrary contractual capacity or full-structure
cases. Simulating memory exhaustion is not required. Arrays and indexable
sequences may suit other modules, such as sorting, without being imposed here.
This correction requires reviewing prior module 07 contracts, suites and READMEs;
it does not certify or modify existing implementations.

## 📋 Política de resultados / Result policy

**ES:** El contrato fija **qué devuelve cada operación** para que los tests comparen comportamiento y no representación. El indicador concreto es el del lenguaje y se declara en su README.

**EN:** The contract fixes **what each operation returns** so tests compare behaviour and not representation. The concrete indicator is the language's and is declared in its README.

| Operación / Operation | Éxito / Success | Fallo / Failure | Efecto / Effect |
|---|---|---|---|
| `TreeNode.init(value)` | Nodo con `value` y ambos enlaces ausentes | No aplica | — |
| `TreeNode.get_value`, `get_left`, `get_right` | Valor, nodo enlazado o representación nativa de ausencia | No aplica | No mutan |
| `TreeNode.set_left`, `set_right` | Enlace actualizado, o nuevo nodo si el lenguaje es inmutable | No aplica | No cambia el tamaño del árbol contenedor |
| `GraphNode.init(label)` | Nodo con la etiqueta indicada y secuencia de vecinos vacía; operación interna a `Graph` | No aplica | — |
| `BinaryTree.init()` | Árbol vacío utilizable / Usable empty tree | No aplica / Not applicable | Raíz ausente, tamaño 0 / Absent root, size 0 |
| `BinaryTree.insert(value)` | Inserta; duplicado también es éxito / Inserts; duplicates also succeed | Sin fallo por límite contractual / No contractual limit failure | `size()` `+1` solo si es nuevo / only for a new value |
| `BinaryTree.contains(value)` | Éxito si está / Success if present | Fallo si no está / Failure if absent | No muta / Does not mutate |
| `BinaryTree.is_empty`, `size` | Si no hay nodos; número de nodos / Whether there are no nodes; node count | No aplica / Not applicable | No mutan / Do not mutate |
| `Graph.init()` | Grafo vacío utilizable / Usable empty graph | No aplica / Not applicable | 0 vértices, 0 aristas / 0 vertices, 0 edges |
| `Graph.add_vertex(label)` | Éxito, también duplicado / Success, including duplicates | Sin fallo por límite contractual / No contractual limit failure | `vertex_count()` `+1` solo si es nuevo; conserva vecinos / only if new; preserves neighbours |
| `Graph.add_edge(u,v)` | Éxito, también duplicada o bucle / Success, including duplicates or self-loops | Fallo si falta un extremo / Failure if either endpoint is missing | `edge_count()` `+1` solo si es nueva; fallo no muta ni crea vértices / only if new; failure neither mutates nor creates vertices |
| `Graph.has_edge(u,v)` | Éxito si existe / Success if present | Fallo si no existe o falta un extremo / Failure if absent or either endpoint is missing | No muta / Does not mutate |
| `Graph.get_neighbors(u)` | Secuencia ordenada: copia independiente o valor inmutable compartido; vacía para vértice aislado / Sorted sequence: independent copy or shared immutable value; empty for isolated vertex | Fallo si no existe `u` / Failure if `u` is missing | No muta; el resultado no permite modificar el grafo ni cambia con altas posteriores / Does not mutate; the result cannot modify the graph and is unchanged by later insertions |
| `Graph.is_empty`, `vertex_count`, `edge_count` | Sin vértices; cantidad de vértices; cantidad de aristas / No vertices; vertex count; edge count | No aplica / Not applicable | No mutan / Do not mutate |

## 🔌 Declaración del contrato / Contract declaration

**ES:** Igual que en el módulo anterior, la especificación fija el **contrato** y el lenguaje elige la **forma de declararlo**: *package specification* en Ada, encabezado y tipo opaco en C, lista de exportación del módulo en Haskell o la API pública de la clase donde la haya. Declarar un tipo de contrato aparte (`interface`, `trait`, `protocol`, firma de módulo) solo se justifica cuando exista **más de una implementación real** de la misma abstracción. La regla general y su calendario por fase están en [`AGENT_Template.md`](../../AGENT_Template.md).

**EN:** As in the previous module, the specification fixes the **contract** and the language chooses the **way to declare it**: *package specification* in Ada, a header and an opaque type in C, the module's export list in Haskell, or a class's public API where there is one. Declaring a separate contract type (`interface`, `trait`, `protocol`, module signature) is only justified when there is **more than one real implementation** of the same abstraction. The general rule and its per-phase calendar are in [`AGENT_Template.md`](../../AGENT_Template.md).

## 🧠 Modelo conceptual / Conceptual model

**ES:** El registro enlazado de vértices que sigue es la representación canónica
para expresar el algoritmo sin un array de índices. `next_vertex` es un detalle
de ese registro, no una arista del grafo ni una operación pública. Una adaptación
idiomática puede expresarlo con términos o registros persistentes, conservando
la API, los vértices aislados y las cotas declaradas; no debe introducir una
capacidad arbitraria ni sustituir el grafo por uno de biblioteca.

**EN:** The linked vertex registry below is the canonical representation for
expressing the algorithm without an index array. `next_vertex` is a registry
detail, not a graph edge or public operation. An idiomatic adaptation may express
it with terms or persistent records while preserving the API, isolated vertices
and declared bounds; it must not impose arbitrary capacity or substitute a
library graph.

```pseudocode
type Node
    value

    init(value)
        this.value = value
        return this

    get_value() = return this.value

type TreeNode extends Node
    left = absent
    right = absent

    init(value)
        super(value)                # el valor vive en la base
        this.left = absent
        this.right = absent
        return this

    get_left()  = return this.left
    get_right() = return this.right

    set_left(node)
        this.left = node
        return this

    set_right(node)
        this.right = node
        return this

type BinaryTree
    root = absent
    count = 0

    init()
        this.root = absent
        this.count = 0
        return this

    is_empty() = return root is absent
    size()     = return count

    insert(value)
        if root is absent
            root = TreeNode.init(value)
            count = count + 1
            return success
        current = root
        while true
            if value == current.value
                return success          # duplicado: no inserta ni cambia el tamaño
            if value < current.value
                if current.left is absent
                    current.left = TreeNode.init(value)
                    count = count + 1
                    return success
                current = current.left
            else
                if current.right is absent
                    current.right = TreeNode.init(value)
                    count = count + 1
                    return success
                current = current.right

    contains(value)
        current = root
        while current is not absent
            if value == current.value
                return success
            if value < current.value
                current = current.left
            else
                current = current.right
        return failure

type NeighborNode
    label
    next = absent

type GraphNode extends Node
    neighbours = absent             # la etiqueta es el valor heredado
    next_vertex = absent

    init(label)
        super(label)
        this.neighbours = absent
        this.next_vertex = absent
        return this

type Graph
    vertices = absent                       # registro enlazado de vértices
    vertex_total = 0
    edges = 0

    init()
        this.vertices = absent
        this.vertex_total = 0
        this.edges = 0
        return this

    is_empty()     = return vertex_total == 0
    vertex_count() = return vertex_total
    edge_count()   = return edges

    find_vertex(label)                      # helper interno / internal helper
        current = vertices
        while current is not absent
            if current.value == label return current
            current = current.next_vertex
        return absent

    add_vertex(label)
        if find_vertex(label) is not absent return success
        node = GraphNode.init(label)
        node.next_vertex = vertices
        vertices = node
        vertex_total = vertex_total + 1
        return success

    add_edge(u, v)
        source = find_vertex(u)
        target = find_vertex(v)
        if source is absent or target is absent return failure
        previous = absent
        current = source.neighbours
        while current is not absent and current.label < v
            previous = current
            current = current.next
        if current is not absent and current.label == v
            return success
        neighbour = new NeighborNode(label = v, next = current)
        if previous is absent
            source.neighbours = neighbour
        else
            previous.next = neighbour
        edges = edges + 1
        return success

    has_edge(u, v)
        source = find_vertex(u)
        target = find_vertex(v)
        if source is absent or target is absent return failure
        current = source.neighbours
        while current is not absent and current.label < v
            current = current.next
        if current is not absent and current.label == v
            return success
        return failure

    get_neighbors(u)
        source = find_vertex(u)
        if source is absent return failure
        result = empty sequence
        current = source.neighbours
        while current is not absent
            append current.label to result
            current = current.next
        return result
```

El pseudocódigo cubre **todas** las operaciones de la tabla. `Graph` mantiene un
registro enlazado propio: `find_vertex` cuesta `O(V)`, no `O(1)` por indexación.
Después, la adyacencia ordenada cuesta `O(d(u))`; no se ordena al consultar.
La biblioteca puede aportar su lista solo para vecinos. Una copia usa acumulación
con extremo final o equivalente para no convertir el recorrido en `O(d(u)^2)`.
Memoria: `O(n)` para el ABB y `O(V + E)` para el grafo; `get_neighbors` usa
`O(d(u))` adicional. Las adaptaciones inmutables conservan datos y contrato.
Si la adyacencia ya es un valor inmutable, se permite compartirlo sin copiar:
el resultado conserva su valor aunque posteriormente se añadan aristas. La cota
`O(V + d(u))` sigue siendo válida; no se exige una asignación artificial.

The pseudocode covers **every** operation in the table. `Graph` owns a linked
registry: `find_vertex` costs `O(V)`, not indexed `O(1)`. Sorted adjacency then
costs `O(d(u))`; reads do not sort. A library list may store neighbours only.
Copy with a tail accumulator or equivalent to avoid `O(d(u)^2)` traversal.
Storage is `O(n)` for the BST and `O(V + E)` for the graph; `get_neighbors` uses
an extra `O(d(u))`. Immutable adaptations preserve data and contract.
Already immutable adjacency may be shared without copying: the result retains
its value after later edge insertions. The `O(V + d(u))` bound remains valid;
no artificial allocation is required.

## 🧪 Casos de prueba / Test cases

Los tests se agrupan por abstracción: primero `TreeNode`, después `BinaryTree` y `Graph`. Cada caso define **entrada y salida esperada** y se comprueba **solo con las operaciones del contrato**, sin leer la representación interna.

Tests are grouped by abstraction: first `TreeNode`, then `BinaryTree` and `Graph`. Every case defines **input and expected output** and is checked **only with the contract's operations**, without reading the internal representation.

**ES:** Los valores del ABB son enteros positivos (20, 30, 40, 50, 70).
Las etiquetas del grafo son valores (10, 30, 50, 70), no posiciones. Cada fila
usa una instancia recién inicializada y ejecuta sus pasos en orden; el indicador
de fallo no debe confundirse con una secuencia de vecinos vacía.

**EN:** BST values are positive integers (20, 30, 40, 50, 70).
Graph labels are values (10, 30, 50, 70), not positions. Each row uses a freshly
initialised instance and executes its steps in order; distinguish failure from
an empty neighbour sequence.

### `TreeNode`

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|---|---|---|
| Crear un nodo de árbol<br>Create a tree node | `TreeNode.init(10)` | `get_value()` = `10` |
| Enlaces iniciales ausentes<br>Absent initial links | `TreeNode.init(10)` | `get_left()` y `get_right()` = representación de ausencia<br>`get_left()` and `get_right()` = the absent representation |
| Enlazar dos hijos<br>Link two children | `set_left(TreeNode.init(20))` y `set_right(TreeNode.init(30))` sobre el padre<br>`set_left(TreeNode.init(20))` and `set_right(TreeNode.init(30))` on the parent | `get_value(get_left())` = `20`; `get_value(get_right())` = `30` |
| Recorrer cada enlace<br>Traverse each link | desde el padre, seguir `get_left()` y `get_right()` | los hijos llevan a `20` y `30`; los enlaces de los hijos son ausentes<br>children lead to `20` and `30`; the children's links are absent |
| Desenlazar hijos / Unlink children | inicializar padre 10 e hijos 20 y 30; enlazar ambos; `set_left(absent)` y después `set_right(absent)` / initialise parent 10 and children 20 and 30; link both; clear left, then right | al quitar izquierdo, valor 10 y derecho 30 se conservan; al quitar derecho, ambos enlaces ausentes y valor 10 / clearing left preserves value 10 and right child 30; clearing right leaves both links absent and value 10 |
| Adaptación inmutable (si aplica)<br>Immutable adaptation (if applicable) | `set_left` sobre un `TreeNode` inmutable | devuelve un nodo nuevo con el enlace; el original no cambia<br>returns a new node with the link; the original is unchanged |

### `BinaryTree`

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|---|---|---|
| Crear vacío / Create empty | `init()` | `is_empty()` = `true`; `size()` = `0`; `contains(50)` = fallo / failure |
| Insertar la raíz / Insert the root | `init()`, `insert(50)` | éxito / success; `size()` = `1`; `is_empty()` = `false`; `contains(50)` = éxito / success |
| Insertar menor y mayor / Insert lower and higher | `init()`; insertar / insert `50`, `30`, `70` | éxito en cada alta; tamaño 3 y pertenencia de los tres / each succeeds; size 3, all three present |
| Ramas de varios niveles / Multilevel branches | `init()`; insertar / insert `50`, `30`, `70`, `20`, `40` | cinco éxitos; pertenencia de cada valor; `size()` = `5` / five successes; each value present |
| Valor ausente en árbol no vacío / Missing value in nonempty tree | `init()`; `insert(50)`; `contains(99)` | fallo; tamaño 1, `contains(50)` sigue en éxito / failure; size 1, 50 still present |
| Duplicado idempotente / Idempotent duplicate | `init()`; insertar / insert `50`, `30`, `70`, `30` | cuatro éxitos; `size()` = `3`; conserva los tres valores / four successes; preserves all three values |
| Inserciones ordenadas / Ordered insertions | `init()`; insertar / insert `20`, `30`, `40`, `50`, `70` | cinco éxitos; `size()` = `5`; todos presentes; `contains(99)` falla / all present; 99 absent |

**ES:** Los casos observan pertenencia y tamaño; la revisión de código verifica
la invariante ABB y el recorrido `O(h)`, que una salida correcta por sí sola no
demuestra. No se exige balanceo ni un test de capacidad agotada.

**EN:** Cases observe membership and size; code review verifies the BST invariant
and `O(h)` traversal, which correct output alone cannot prove. Neither balancing
nor an exhausted-capacity test is required.

### `Graph`

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|---|---|---|
| Crear vacío / Create empty | `init()` | `is_empty()` = `true`; `vertex_count()` = `0`; `edge_count()` = `0`; `has_edge(10,30)` y / and `get_neighbors(10)` fallan / fail |
| Vértice aislado / Isolated vertex | `init()`; `add_vertex(10)` | éxito; no vacío; 1 vértice, 0 aristas; vecinos de 10 vacíos / success; not empty; 1 vertex, 0 edges; empty neighbours of 10 |
| Etiquetas no consecutivas y arista dirigida / Nonconsecutive labels and directed edge | `init()`; registrar / register `10`, `70`; `add_edge(10,70)` | éxito; `has_edge(10,70)` = éxito; `has_edge(70,10)` = fallo; 2 vértices, 1 arista / success; forward present, reverse absent; 2 vertices, 1 edge |
| Vértice duplicado conserva adyacencia / Duplicate vertex preserves adjacency | `init()`; registrar / register `10`, `30`; `add_edge(10,30)`; `add_vertex(10)` | todas en éxito; 2 vértices, 1 arista; vecinos de 10 = `[30]` / all succeed; 2 vertices, 1 edge; neighbours of 10 = `[30]` |
| Arista duplicada / Duplicate edge | `init()`; registrar / register `10`, `30`; `add_edge(10,30)` dos veces / twice | ambos éxitos; 2 vértices, 1 arista; vecinos de 10 = `[30]` / both succeed; 2 vertices, 1 edge; neighbours of 10 = `[30]` |
| Extremo inexistente sin mutación / Missing endpoint without mutation | `init()`; registrar / register `10`, `30`; `add_edge(10,30)`; intentar / try `add_edge(10,99)`, `add_edge(99,10)`, `add_edge(98,99)`, `add_edge(99,99)` | cuatro fallos; siguen 2 vértices y 1 arista; vecinos de 10 = `[30]`; vecinos de 30 vacíos; consultas de aristas intentadas fallan; `get_neighbors(98)` y `get_neighbors(99)` fallan / four failures; still 2 vertices, 1 edge; original adjacency preserved; attempted edges and missing vertices remain absent |
| Vecinos ordenados y contadores / Sorted neighbours and counts | `init()`; registrar / register `10`, `30`, `50`, `70`; añadir / add `(10,70)`, `(10,30)`, `(10,50)`, `(30,50)` | todos en éxito; vecinos de 10 = `[30,50,70]`, de 30 = `[50]`, de 50 y 70 vacíos; 4 vértices, 4 aristas / all succeed; neighbours as listed; 4 vertices, 4 edges |
| Consulta de arista ausente / Missing-edge query | `init()`; registrar / register `10`, `30`; `has_edge(10,30)` | fallo; 2 vértices, 0 aristas; no vacío / failure; 2 vertices, 0 edges; not empty |
| Vecinos de vértice inexistente / Neighbours of missing vertex | `init()`; `add_vertex(10)`; `get_neighbors(99)` | fallo, distinto de los vecinos vacíos de 10; 1 vértice, 0 aristas / failure, distinct from empty neighbours of 10; 1 vertex, 0 edges |
| Bucle y duplicado / Self-loop and duplicate | `init()`; `add_vertex(10)`; `add_edge(10,10)` dos veces / twice | ambos éxitos; `has_edge(10,10)` = éxito; vecinos `[10]`; 1 vértice, 1 arista / both succeed; loop present; neighbours `[10]`; 1 vertex, 1 edge |
| Aislamiento del resultado de vecinos / Neighbour-result isolation | `init()`; registrar / register `10`, `30`, `50`; `add_edge(10,30)`; guardar vecinos de 10; si el resultado es mutable, modificar otra copia devuelta; añadir / save neighbours of 10; if mutable, change another returned copy; add `add_edge(10,50)` | modificar la copia no cambia el grafo; resultado guardado sigue `[30]`; nueva consulta `[30,50]`; 3 vértices, 2 aristas / changing the copy does not change the graph; saved result remains `[30]`; fresh query `[30,50]`; 3 vertices, 2 edges |

### Casos no representables / Not representable cases

**ES:** Cuando el lenguaje no pueda representar un caso requerido (por ejemplo,
modificar una secuencia inmutable o un retorno ausente), se declara la parte no
representable y su motivo en la cobertura del README; no se elimina el resto
del escenario ni se inventa un centinela. No hay casos de capacidad negativa,
agotada ni de etiqueta «fuera de rango» por posición: se prueba existencia.

**EN:** If a language cannot represent a required case, such as modifying an
immutable sequence or an absent return, declare the unrepresentable part and
reason in README coverage; neither drop the rest of the scenario nor invent a
sentinel. There are no negative/exhausted capacity or positional out-of-range
label cases: test existence instead.

## ✅ Criterios de aceptación / Acceptance criteria

- [ ] Existe una base `Node` con el valor y **sin** validaciones; `TreeNode` y `GraphNode` la reutilizan por herencia o por valor embebido, y **cada hijo** valida sus propios enlaces.
- [ ] `TreeNode` y `GraphNode` son tipos propios; `BinaryTree` y `Graph` mantienen sus nodos, estado y contratos independientes.
- [ ] Inicialización sin capacidad; no hay estado lleno ni inutilizable. / Initialisation without capacity; no full or unusable state.
- [ ] Vértices explícitos, etiquetas no indexadas, vértices aislados y contadores de vértices/aristas separados. / Explicit vertices, non-index labels, isolated vertices and separate vertex/edge counts.
- [ ] Las aristas exigen extremos existentes; se prueban dirección, duplicados, bucles y ausencia de mutación al fallar. / Edges require existing endpoints; test direction, duplicates, self-loops and nonmutation on failure.
- [ ] `Graph` puede usar `LinkedList<T>` de biblioteca solo para su adyacencia; el ADT y sus operaciones se implementan manualmente y conservan la complejidad declarada.
- [ ] La revisión de código verifica el registro propio, su recorrido manual y las operaciones manuales de adyacencia; no basta una suite verde ni se acepta un mapa/conjunto de biblioteca como sustituto. / Code review verifies the own registry, manual traversal and manual adjacency operations; green tests alone are insufficient and a library map/set is not a substitute.
- [ ] Los tests verifican el contrato del nodo, las invariantes y el comportamiento observable.
- [ ] Cada operación declara su resultado de éxito y su resultado de fallo, y el pseudocódigo cubre todas las operaciones de la tabla, sin `…` ni «etc.».
- [ ] Se documentan indicadores, adaptaciones y casos no representables por lenguaje.
- [ ] No se exige un tipo de contrato aparte (`interface`, `trait`, `protocol`) mientras haya una sola implementación; la forma elegida se declara en el README.
- [ ] La biblioteca estándar solo apoya representaciones internas permitidas; no sustituye el algoritmo o la estructura enseñada.
- [ ] El README del lenguaje sigue la plantilla y enlaza la evidencia real.

## 📂 Ubicación esperada / Expected location

```text
{language}/core/algorithms/data_structures_advanced/
├── src/
│   └── data_structures_advanced.ext
└── test/
    ├── data_structures_advanced_test.ext
    └── run_tests.ext
```

El layout real puede seguir las convenciones del lenguaje; toda desviación se declara en el README.

The real layout may follow the language's conventions; every deviation is declared in the README.

## ▶️ Siguiente / Next

👉 Sigue con [`08_Efficient_Sort.md`](08_Efficient_Sort.md).

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*