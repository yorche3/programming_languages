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

Este módulo declara y verifica `TreeNode` y `GraphNode` en contextos distintos: enlaces izquierdo/derecho para el ABB y adyacencias dirigidas para el grafo. No importa ni reutiliza código de `data_structures_basics`; se reutiliza el concepto de nodo, no un tipo o una implementación compartidos.

This module declares and verifies `TreeNode` and `GraphNode` in different contexts: left/right links for the BST and directed adjacency for the graph. It does not import or reuse code from `data_structures_basics`; it reuses the concept of a node, not a shared type or implementation.

## 📖 Concepto: múltiples referencias / Concept: multiple links

Un `TreeNode` tiene `Value`, `Left` y `Right`. Un `GraphNode` tiene una `Label` y su propia secuencia de etiquetas vecinas. El nombre y la representación concreta son idiomáticos, pero los valores, enlaces e invariantes se observan mediante la API de cada estructura.

A `TreeNode` has `Value`, `Left` and `Right`. A `GraphNode` has a `Label` and its own sequence of neighbour labels. Names and concrete representations are idiomatic, but values, links and invariants are observed through each structure's API.

La `LinkedList<T>` de la biblioteca estándar puede almacenar la secuencia de vecinos de `GraphNode`; esa lista no sustituye al `Graph` ni cambia sus complejidades (`O(d(u))` para insertar, consultar o copiar vecinos). `BinaryTree` y las operaciones de `Graph` siguen siendo implementaciones propias; no se usan algoritmos de alto nivel que oculten el aprendizaje.

The standard library's `LinkedList<T>` may store `GraphNode`'s neighbour sequence; that list does not replace `Graph` or change its complexities (`O(d(u))` to insert, look up or copy neighbours). `BinaryTree` and `Graph` operations remain the implementation under study; no high-level algorithms may hide the learning objective.

## 📐 Contrato común y aislamiento / Common contract and isolation

1. `TreeNode` es un tipo nuevo o equivalente idiomático con valor y enlaces `Left` y `Right`. `GraphNode` es un tipo nuevo con una etiqueta y su propia secuencia de adyacencia.
2. `BinaryTree` y `Graph` tienen tipos nuevos y constructores equivalentes a `init`. `Graph` puede usar el `LinkedList<T>` de la biblioteca estándar como almacenamiento de vecinos, pero implementa manualmente sus propias operaciones e invariantes; la colección no sustituye al ADT `Graph`.
3. Los indicadores de éxito y fallo son los valores representables y no ambiguos que declare el README de cada lenguaje. No se fuerza `-1`, `null`, `nil`, `Option` o `Result` cuando el lenguaje o la fase no los admiten.
4. Los valores de prueba son enteros positivos o el subtipo entero equivalente que evite colisiones con los indicadores del lenguaje.
5. Cada adaptación de mutabilidad, ausencia, índices, vecinos o capacidad se documenta como adaptación idiomática.

1. `TreeNode` is a new type or idiomatic equivalent with a value and `Left` and `Right` links. `GraphNode` is a new type with a label and its own adjacency sequence.
2. `BinaryTree` and `Graph` have new types and constructors equivalent to `init`. `Graph` may use the standard library's `LinkedList<T>` as neighbour storage, but it manually implements its own operations and invariants; the collection does not replace the `Graph` ADT.
3. Success and failure indicators are the representable, unambiguous values documented in each language README. `-1`, `null`, `nil`, `Option` or `Result` are not forced when the language or phase does not admit them.
4. Test values are positive integers or the equivalent integer subtype that avoids collisions with the language's indicators.
5. Every adaptation for mutability, absence, indices, neighbours or capacity is documented as an idiomatic adaptation.

## 🧩 Estructuras / Structures

| Estructura / Structure | Operaciones / Operations | Contrato e invariantes / Contract and invariants | Complejidad / Complexity |
|---|---|---|---|
| `TreeNode` | `init(value)`, `get_value()`, `get_left()`, `get_right()`, `set_left(node)`, `set_right(node)` | Nodo propio del ABB; un enlace ausente representa un subárbol vacío. | `O(1)` |
| `BinaryTree` | `init(capacity)`, `insert(value)`, `contains(value)`, `is_empty()`, `size()` | ABB: valores menores a la izquierda y mayores a la derecha; duplicados no aumentan el tamaño; capacidad máxima de nodos. `contains` es pertenencia por la invariante del ABB, no búsqueda sobre secuencias (módulo `searching`). | `init`, vacío y tamaño: `O(1)`; insertar y pertenencia: `O(h)`, `h` = altura actual |
| `GraphNode` | `init(label)` (interno a `Graph`) | Nodo propio del grafo; `label` identifica el vértice; conserva su secuencia de vecinos en orden creciente y sin duplicados. | `O(1)` |
| `Graph` | `init(capacity)`, `add_edge(u,v)`, `has_edge(u,v)`, `get_neighbors(u)`, `is_empty()`, `size()` | Grafo dirigido con etiquetas `0 .. capacity - 1`; cuenta aristas dirigidas distintas; la adyacencia de cada vértice está ordenada. `is_empty()` significa que no hay aristas; `size()` cuenta aristas distintas, no vértices. | `init`: `O(V)`; `add_edge` y `has_edge`: `O(d(u))`; `get_neighbors`: `O(d(u))`; vacío y tamaño: `O(1)` |

En este módulo `capacity` es el máximo de nodos del árbol o vértices del grafo. Una capacidad inválida (menor que 1 o no representable) deja la instancia **inutilizable**, y ese estado es observable: `is_empty()` devuelve verdadero, `size()` devuelve cero y las operaciones de consulta o mutación devuelven el indicador de fallo del lenguaje. Una capacidad agotada rechaza la creación de un valor nuevo o una arista nueva sin cambiar el estado. Un duplicado de ABB sigue siendo éxito aunque el árbol esté lleno, porque no crea un nodo.

In this module `capacity` is the maximum number of tree nodes or graph vertices. An invalid capacity (less than 1 or not representable) leaves the instance **unusable**, and that state is observable: `is_empty()` returns true, `size()` returns zero and query or mutation operations return the language's failure indicator. An exhausted capacity rejects creation of a new value or edge without changing the state. A duplicate BST value still succeeds when the tree is full because it creates no node.

## 📋 Política de resultados / Result policy

**ES:** El contrato fija **qué devuelve cada operación** para que los tests comparen comportamiento y no representación. El indicador concreto es el del lenguaje y se declara en su README.

**EN:** The contract fixes **what each operation returns** so tests compare behaviour and not representation. The concrete indicator is the language's and is declared in its README.

| Operación / Operation | Éxito / Success | Fallo / Failure | Efecto / Effect |
|---|---|---|---|
| `TreeNode.init(value)` | Nodo con `value` y ambos enlaces ausentes | No aplica | — |
| `TreeNode.get_value`, `get_left`, `get_right` | Valor, nodo enlazado o representación nativa de ausencia | No aplica | No mutan |
| `TreeNode.set_left`, `set_right` | Enlace actualizado, o nuevo nodo si el lenguaje es inmutable | No aplica | No cambia el tamaño del árbol contenedor |
| `GraphNode.init(label)` | Nodo con la etiqueta indicada y secuencia de vecinos vacía; operación interna a `Graph` | No aplica | — |
| `BinaryTree.insert(value)` | Éxito, también cuando el valor es un duplicado y el árbol está lleno | Fallo si la instancia es inutilizable o si el valor es nuevo y `size() == capacity` | `size()` `+1` solo si el valor es nuevo |
| `BinaryTree.contains(value)` | Éxito si el valor está en el árbol | Fallo si no está o la instancia es inutilizable | No muta |
| `BinaryTree.is_empty`, `size` | Verdadero o falso; número de nodos | No aplica: devuelve 0 en la instancia inutilizable | No mutan |
| `Graph.add_edge(u,v)` | Éxito, también cuando la arista ya existe | Fallo si `u` o `v` está fuera del dominio de nodos o la instancia es inutilizable | `size()` `+1` solo si la arista es nueva |
| `Graph.has_edge(u,v)` | Éxito si la arista dirigida existe | Fallo si no existe, si `u` o `v` está fuera de rango o la instancia es inutilizable | No muta |
| `Graph.get_neighbors(u)` | Copia de los vecinos de `u` en orden creciente de etiqueta; secuencia vacía si no tiene vecinos | Fallo si `u` está fuera de rango o la instancia es inutilizable | No muta |
| `Graph.is_empty`, `size` | Verdadero si no hay aristas; número de aristas distintas | No aplica: devuelve 0 en la instancia inutilizable | No mutan |

## 🔌 Declaración del contrato / Contract declaration

**ES:** Igual que en el módulo anterior, la especificación fija el **contrato** y el lenguaje elige la **forma de declararlo**: *package specification* en Ada, encabezado y tipo opaco en C, lista de exportación del módulo en Haskell o la API pública de la clase donde la haya. Declarar un tipo de contrato aparte (`interface`, `trait`, `protocol`, firma de módulo) solo se justifica cuando exista **más de una implementación real** de la misma abstracción. La regla general y su calendario por fase están en [`AGENT_Template.md`](../../AGENT_Template.md).

**EN:** As in the previous module, the specification fixes the **contract** and the language chooses the **way to declare it**: *package specification* in Ada, a header and an opaque type in C, the module's export list in Haskell, or a class's public API where there is one. Declaring a separate contract type (`interface`, `trait`, `protocol`, module signature) is only justified when there is **more than one real implementation** of the same abstraction. The general rule and its per-phase calendar are in [`AGENT_Template.md`](../../AGENT_Template.md).

## 🧠 Modelo conceptual / Conceptual model

```pseudocode
type TreeNode
    value
    left = absent
    right = absent

    init(value)
        this.value = value
        this.left = absent
        this.right = absent
        return this

    get_value() = return this.value
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
    capacity
    usable = true

    init(capacity)
        if capacity is invalid
            this.usable = false
        this.capacity = capacity
        return this

    is_empty() = return root is absent
    size()     = return count

    insert(value)
        if not usable return failure
        if root is absent
            if count == capacity return failure
            root = TreeNode.init(value)
            count = count + 1
            return success
        current = root
        while true
            if value == current.value
                return success          # duplicado: no inserta ni cambia el tamaño
            if value < current.value
                if current.left is absent
                    if count == capacity return failure
                    current.left = TreeNode.init(value)
                    count = count + 1
                    return success
                current = current.left
            else
                if current.right is absent
                    if count == capacity return failure
                    current.right = TreeNode.init(value)
                    count = count + 1
                    return success
                current = current.right

    contains(value)
        if not usable return failure
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

type GraphNode
    label
    neighbours = absent

    init(label)
        this.label = label
        this.neighbours = absent
        return this

type Graph
    nodes = array of GraphNode              # etiquetas 0 .. capacity - 1
    edges = 0
    capacity
    usable = true

    init(capacity)
        if capacity is invalid
            this.usable = false
        else
            create capacity nodes with labels 0 .. capacity - 1
        this.capacity = capacity
        return this

    is_empty() = return edges == 0
    size()     = return edges

    add_edge(u, v)
        if not usable or u or v is outside the node domain
            return failure
        previous = absent
        current = nodes[u].neighbours.head
        while current is not absent and current.label < v
            previous = current
            current = current.next
        if current is not absent and current.label == v
            return success
        insert v between previous and current in nodes[u].neighbours
        edges = edges + 1
        return success

    has_edge(u, v)
        if not usable or u or v is outside the node domain
            return failure
        current = nodes[u].neighbours.head
        while current is not absent and current.label < v
            current = current.next
        if current is not absent and current.label == v
            return success
        return failure

    get_neighbors(u)
        if not usable or u is outside the node domain
            return failure
        result = empty sequence
        current = nodes[u].neighbours
        while current is not absent
            append current.label to result
            current = current.next
        return result
```

El pseudocódigo cubre **todas** las operaciones de la tabla, incluidos `contains`, `has_edge`, `is_empty`, `size` y los límites de capacidad. `Graph` usa una secuencia de adyacencia enlazada y ordenada por etiqueta: la biblioteca estándar puede aportar su `LinkedList<T>`, o el lenguaje puede adaptar los nodos enlazados manualmente. La inserción ordenada y la consulta recorren como máximo los vecinos de `u`, por eso conservan `O(d(u))`; no se ordena en cada llamada a `get_neighbors`.

The pseudocode covers **every** operation in the table, including `contains`, `has_edge`, `is_empty`, `size` and capacity limits. `Graph` uses a linked adjacency sequence ordered by label: the standard library may provide its `LinkedList<T>`, or the language may adapt linked nodes manually. Ordered insertion and lookup scan at most `u`'s neighbours, so they preserve `O(d(u))`; `get_neighbors` does not sort on every call.

## 🧪 Casos de prueba / Test cases

Los tests se agrupan por abstracción: primero `TreeNode`, después `BinaryTree` y `Graph`. Cada caso define **entrada y salida esperada** y se comprueba **solo con las operaciones del contrato**, sin leer la representación interna.

Tests are grouped by abstraction: first `TreeNode`, then `BinaryTree` and `Graph`. Every case defines **input and expected output** and is checked **only with the contract's operations**, without reading the internal representation.

**ES:** Los valores del ABB son enteros positivos (20, 30, 40, 50, 70) para no colisionar con el indicador de fallo. Las **etiquetas** del grafo no son esos valores: son índices `0 .. capacity - 1` y deben probarse por separado.

**EN:** BST values are positive integers (20, 30, 40, 50, 70) so none collide with the failure indicator. Graph **labels** are not those values: they are indices `0 .. capacity - 1` and are tested separately.

### `TreeNode`

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|---|---|---|
| Crear un nodo de árbol<br>Create a tree node | `TreeNode.init(10)` | `get_value()` = `10` |
| Enlaces iniciales ausentes<br>Absent initial links | `TreeNode.init(10)` | `get_left()` y `get_right()` = representación de ausencia<br>`get_left()` and `get_right()` = the absent representation |
| Enlazar dos hijos<br>Link two children | `set_left(TreeNode.init(20))` y `set_right(TreeNode.init(30))` sobre el padre<br>`set_left(TreeNode.init(20))` and `set_right(TreeNode.init(30))` on the parent | `get_value(get_left())` = `20`; `get_value(get_right())` = `30` |
| Recorrer cada enlace<br>Traverse each link | desde el padre, seguir `get_left()` y `get_right()` | los hijos llevan a `20` y `30`; los enlaces de los hijos son ausentes<br>children lead to `20` and `30`; the children's links are absent |
| Adaptación inmutable (si aplica)<br>Immutable adaptation (if applicable) | `set_left` sobre un `TreeNode` inmutable | devuelve un nodo nuevo con el enlace; el original no cambia<br>returns a new node with the link; the original is unchanged |

### `BinaryTree`

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|---|---|---|
| Crear con capacidad válida<br>Create with valid capacity | `init(5)` | `is_empty()` = `true`; `size()` = `0` |
| Capacidad inválida<br>Invalid capacity | `init(0)` y después `insert(50)` | instancia inutilizable: `is_empty()` = `true`, `size()` = `0` y la inserción falla<br>unusable instance: `is_empty()` = `true`, `size()` = `0` and the insertion fails |
| Insertar la raíz<br>Insert the root | `init(5)`, `insert(50)` | éxito; `size()` = `1`; `contains(50)` = éxito<br>success |
| Insertar menor y mayor<br>Insert lower and higher | `init(3)`, `insert(50)`, `insert(30)`, `insert(70)` | las tres inserciones tienen éxito; `size()` = `3`; `contains(30)` y `contains(70)` = éxito<br>all three insertions succeed; `size()` = `3` |
| Propiedad ABB<br>BST property | `init(5)`; insertar `50`, `30`, `70`, `20`, `40` | las cinco inserciones tienen éxito; `contains` de cada valor tiene éxito; `size()` = `5`<br>all five insertions succeed; `contains` for each value succeeds; `size()` = `5` |
| Valor ausente<br>Absent value | `init(3)`, `contains(99)` | falla<br>failure |
| Duplicado con capacidad llena<br>Duplicate at full capacity | `init(1)`, `insert(50)`, `insert(50)` | ambas inserciones tienen éxito; `size()` = `1`; `contains(50)` = éxito<br>both insertions succeed; `size()` = `1` |
| Capacidad agotada<br>Capacity exhausted | `init(3)`; insertar `50`, `30`, `70`, después `20` | las tres primeras tienen éxito; la cuarta falla; `size()` = `3`; `contains(20)` falla<br>first three succeed; the fourth fails; `size()` = `3` |
| Tamaño y vacío<br>Size and emptiness | `insert(50)` | `size()` = `1`; `is_empty()` = `false` |

### `Graph`

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|---|---|---|
| Crear con capacidad válida<br>Create with valid capacity | `init(4)` | `is_empty()` = `true`; `size()` = `0` |
| Capacidad inválida<br>Invalid capacity | `init(0)` y después `add_edge(0, 0)` | instancia inutilizable: `is_empty()` = `true`, `size()` = `0` y la arista falla<br>unusable instance: `is_empty()` = `true`, `size()` = `0` and the edge fails |
| Arista dirigida<br>Directed edge | `init(4)`, `add_edge(0, 1)` | éxito; `has_edge(0, 1)` = éxito; `size()` = `1`<br>success |
| Dirección inversa<br>Reverse direction | `init(4)`, `add_edge(0, 1)`, `has_edge(1, 0)` | insertar tiene éxito; consulta falla: la arista inversa no existe<br>insertion succeeds; query fails: the reverse edge does not exist |
| Arista duplicada<br>Duplicate edge | `init(4)`, `add_edge(0, 1)` dos veces<br>`init(4)`, `add_edge(0, 1)` twice | éxito las dos veces; `size()` = `1`, las aristas distintas cuentan una vez<br>success both times; distinct edges count once |
| Nodo fuera de rango<br>Out-of-range node | `init(4)`, `add_edge(0, 4)` | falla; `size()` = `0`<br>failure |
| Vecinos en orden creciente<br>Neighbours in increasing order | `init(4)`, `add_edge(0, 3)`, `add_edge(0, 1)`, `add_edge(0, 2)` | cada arista tiene éxito; `get_neighbors(0)` = `1`, `2`, `3` en ese orden; `size()` = `3`<br>each edge succeeds; `get_neighbors(0)` = `1`, `2`, `3` in order; `size()` = `3` |
| Nodo sin aristas<br>Node with no edges | `init(4)`, `get_neighbors(0)` | secuencia de vecinos vacía<br>empty neighbour sequence |
| Vecinos de un nodo fuera de rango<br>Neighbours of an out-of-range node | `init(4)`, `get_neighbors(4)` | falla<br>failure |
| Contar aristas y vacío<br>Count edges and emptiness | `init(4)`; `add_edge(0, 1)`, `add_edge(0, 2)`, `add_edge(1, 2)` | las tres tienen éxito; `size()` = `3`; `is_empty()` = `false`; en el grafo recién creado `is_empty()` = `true`<br>all three succeed; `size()` = `3`; `is_empty()` = `false`; it is `true` on the empty graph |

### Casos no representables / Not representable cases

**ES:** Cuando el lenguaje no pueda representar un caso (por ejemplo, una capacidad negativa, una etiqueta de nodo negativa o un retorno ausente), se omite y se registra con `Omitido` y su motivo en la tabla de cobertura del README; no se sustituye por otro caso ni se inventa un centinela.

**EN:** When the language cannot represent a case (for example, a negative capacity, a negative node label or an absent return), it is omitted and recorded as `Omitted` with its reason in the README's coverage table; it is not replaced with another case nor is a sentinel invented.

## ✅ Criterios de aceptación / Acceptance criteria

- [ ] `TreeNode` y `GraphNode` son tipos propios; `BinaryTree` y `Graph` mantienen sus nodos, estado y contratos independientes.
- [ ] `Graph` puede usar `LinkedList<T>` de biblioteca solo para su adyacencia; el ADT y sus operaciones se implementan manualmente y conservan la complejidad declarada.
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