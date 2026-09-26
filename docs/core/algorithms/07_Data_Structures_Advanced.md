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

Este módulo vuelve a declarar y verificar el contrato de `Node` en el contexto de múltiples referencias. No importa ni reutiliza código de `data_structures_basics`; la repetición es deliberada porque el objetivo es comparar cómo cambia el nodo cuando deja de ser lineal.

This module declares and verifies the `Node` contract again in the context of multiple references. It does not import or reuse code from `data_structures_basics`; the repetition is deliberate because the goal is to compare how a node changes when the structure is no longer linear.

## 📖 Concepto: múltiples referencias / Concept: multiple links

Un nodo de árbol tiene `Value`, `Left` y `Right`. Un nodo de grafo tiene `Value` y una colección de enlaces a vecinos. El nombre y la representación concreta son idiomáticos, pero el valor, los enlaces y las invariantes son observables mediante la API definida.

A tree node has `Value`, `Left` and `Right`. A graph node has `Value` and a collection of links to neighbours. The name and concrete representation are idiomatic, but the value, links and invariants are observable through the defined API.

La biblioteca estándar puede apoyar la representación interna de vecinos, índices o almacenamiento auxiliar. No puede sustituir la implementación de `BinaryTree` o `Graph`, ni convertir una operación del contrato en una llamada de alto nivel que oculte el aprendizaje.

The standard library may support the internal representation of neighbours, indices or auxiliary storage. It cannot replace the implementation of `BinaryTree` or `Graph`, or turn a contract operation into a high-level call that hides the learning objective.

## 📐 Contrato común y aislamiento / Common contract and isolation

1. `Node` es un tipo nuevo o equivalente idiomático, con valor y múltiples referencias. Sus tests verifican creación, lectura del valor, enlaces ausentes y enlaces a hijos o vecinos.
2. `BinaryTree` y `Graph` tienen tipos nuevos y constructores equivalentes a `init`. No importan `data_structures_basics` ni otras implementaciones de estructuras del proyecto.
3. Los indicadores de éxito y fallo son los valores representables y no ambiguos que declare el README de cada lenguaje. No se fuerza `-1`, `null`, `nil`, `Option` o `Result` cuando el lenguaje o la fase no los admiten.
4. Los valores de prueba son enteros positivos o el subtipo entero equivalente que evite colisiones con los indicadores del lenguaje.
5. Cada adaptación de mutabilidad, ausencia, índices, vecinos o capacidad se documenta como adaptación idiomática.

1. `Node` is a new type or idiomatic equivalent, with a value and multiple links. Its tests verify creation, value access, absent links and links to children or neighbours.
2. `BinaryTree` and `Graph` have new types and constructors equivalent to `init`. They do not import `data_structures_basics` or other project structure implementations.
3. Success and failure indicators are the representable, unambiguous values documented in each language README. `-1`, `null`, `nil`, `Option` or `Result` are not forced when the language or phase does not admit them.
4. Test values are positive integers or the equivalent integer subtype that avoids collisions with the language's indicators.
5. Every adaptation for mutability, absence, indices, neighbours or capacity is documented as an idiomatic adaptation.

## 🧩 Estructuras / Structures

| Estructura / Structure | Operaciones / Operations | Contrato e invariantes / Contract and invariants | Complejidad / Complexity |
|---|---|---|---|
| `Node` | `init(value)`, `get_value()`, `get_left()`, `get_right()`, `set_left(node)`, `set_right(node)` | Un nodo puede enlazar hasta dos hijos; un enlace ausente representa un subárbol vacío. | `O(1)` |
| `BinaryTree` | `init(capacity)`, `insert(value)`, `contains(value)`, `is_empty()`, `size()` | ABB: valores menores a la izquierda, mayores a la derecha; duplicados no aumentan el tamaño; capacidad máxima de nodos. `contains` es una consulta de pertenencia intrínseca a la invariante ABB, no un algoritmo de búsqueda: la búsqueda sobre secuencias indexables pertenece al módulo `searching`. | `O(h)` para insertar y comprobar pertenencia; `O(1)` para vacío y tamaño |
| `Graph` | `init(capacity)`, `add_edge(u,v)`, `has_edge(u,v)`, `get_neighbors(u)`, `is_empty()`, `size()` | Dirigido; nodos identificados dentro de la capacidad; aristas distintas cuentan una vez; vecinos en orden creciente; `is_empty()` es verdadero cuando no hay aristas y `size()` cuenta aristas distintas, no nodos. | `O(1)` para acceso directo; `O(V)` para vecinos, según representación |

En este módulo `capacity` es el máximo de nodos del árbol o grafo. Una capacidad inválida (menor que 1 o no representable) deja la instancia **inutilizable**, y ese estado es observable: `is_empty()` devuelve verdadero, `size()` devuelve cero y toda operación devuelve el indicador de fallo del lenguaje. Una estructura dinámica que no pueda expresar overflow declara esa limitación y conserva el contrato observable que sí pueda representar.

In this module `capacity` is the maximum number of tree or graph nodes. An invalid capacity (less than 1 or not representable) leaves the instance **unusable**, and that state is observable: `is_empty()` returns true, `size()` returns zero and every operation returns the language's failure indicator. A dynamic structure that cannot express overflow declares that limitation and preserves the observable contract it can represent.

## 📋 Política de resultados / Result policy

**ES:** El contrato fija **qué devuelve cada operación** para que los tests comparen comportamiento y no representación. El indicador concreto es el del lenguaje y se declara en su README.

**EN:** The contract fixes **what each operation returns** so tests compare behaviour and not representation. The concrete indicator is the language's and is declared in its README.

| Operación / Operation | Éxito / Success | Fallo / Failure | Efecto / Effect |
|---|---|---|---|
| `TreeNode.init(value)` | Nodo con `value` y ambos enlaces ausentes | No aplica | — |
| `BinaryTree.insert(value)` | Éxito, también cuando el valor es un duplicado | Fallo si `size() == capacity` o la instancia es inutilizable | `size()` `+1` solo si el valor es nuevo |
| `BinaryTree.contains(value)` | Éxito si el valor está en el árbol | Fallo si no está o la instancia es inutilizable | No muta |
| `BinaryTree.is_empty`, `size` | Verdadero o falso; número de nodos | No aplica: devuelve 0 en la instancia inutilizable | No mutan |
| `Graph.add_edge(u,v)` | Éxito, también cuando la arista ya existe | Fallo si `u` o `v` está fuera del dominio de nodos o la instancia es inutilizable | `size()` `+1` solo si la arista es nueva |
| `Graph.has_edge(u,v)` | Éxito si la arista dirigida existe | Fallo si no existe, si `u` o `v` está fuera de rango o la instancia es inutilizable | No muta |
| `Graph.get_neighbors(u)` | Vecinos de `u` en orden creciente de etiqueta | Fallo si `u` está fuera de rango o la instancia es inutilizable | No muta |
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
        if not usable or count == capacity
            return failure
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

type GraphNode
    value
    neighbours = empty collection

type Graph
    nodes = capacity-sized representation   # etiquetas 0 .. capacity - 1
    edges = 0
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
        if v is not already in nodes[u].neighbours
            add v
            edges = edges + 1
        return success

    has_edge(u, v)
        if not usable or u or v is outside the node domain
            return failure
        if v is in nodes[u].neighbours
            return success
        return failure

    get_neighbors(u)
        if not usable or u is outside the node domain
            return failure
        return neighbours of u in increasing label order
```

El pseudocódigo cubre **todas** las operaciones de la tabla, incluidos `contains`, `has_edge`, `is_empty`, `size` y los límites de capacidad. La colección de vecinos puede ser una lista, un array, un mapa de conjuntos u otra representación del lenguaje; esa elección no elimina el contrato de `GraphNode` ni permite importar la implementación del módulo básico.

The pseudocode covers **every** operation in the table, including `contains`, `has_edge`, `is_empty`, `size` and the capacity limits. The neighbour collection may be a list, array, set map or another language representation; that choice does not remove the `GraphNode` contract or permit importing the basic module's implementation.

## 🧪 Casos de prueba / Test cases

| Grupo / Group | Casos mínimos / Minimum cases |
|---|---|
| `Node` | Crear un nodo; leer su valor; verificar enlaces izquierdo y derecho ausentes; enlazar dos hijos; recorrer cada enlace; comprobar la adaptación inmutable si aplica. |
| `BinaryTree` | Insertar raíz, menor y mayor; buscar existentes y ausentes; ignorar duplicado; rechazar inserción al agotar capacidad; tamaño y vacío; capacidad inválida; verificar la propiedad ABB. |
| `Graph` | Crear capacidad válida e inválida; añadir aristas dirigidas; comprobar que la dirección inversa no aparece; ignorar arista duplicada; rechazar nodos fuera de rango; obtener vecinos ordenados; contar aristas y vacío. |
| No representables | Registrar cada omisión y su causa en el README del lenguaje; no inventar centinelas para hacer pasar la prueba. |

## ✅ Criterios de aceptación / Acceptance criteria

- [ ] `Node` se define y prueba de nuevo con múltiples referencias.
- [ ] `BinaryTree` y `Graph` se implementan manualmente y no importan módulos previos.
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