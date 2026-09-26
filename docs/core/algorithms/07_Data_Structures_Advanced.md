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
| `BinaryTree` | `init(capacity)`, `insert(value)`, `contains(value)`, `is_empty()`, `size()` | ABB: valores menores a la izquierda, mayores a la derecha; duplicados no aumentan el tamaño; capacidad máxima de nodos. | `O(h)` para insertar y buscar; `O(1)` para vacío y tamaño |
| `Graph` | `init(capacity)`, `add_edge(u,v)`, `has_edge(u,v)`, `get_neighbors(u)`, `is_empty()`, `size()` | Dirigido; nodos identificados dentro de la capacidad; aristas distintas cuentan una vez; vecinos en orden creciente. | `O(1)` para acceso directo; `O(V)` para vecinos, según representación |

En este módulo `capacity` es el máximo de nodos del árbol o grafo. `Graph.size()` cuenta aristas distintas, no nodos. Una estructura dinámica que no pueda expresar overflow declara esa limitación y conserva el contrato observable que sí pueda representar.

In this module `capacity` is the maximum number of tree or graph nodes. `Graph.size()` counts distinct edges, not nodes. A dynamic structure that cannot express overflow declares that limitation and preserves the observable contract it can represent.

## 🧠 Modelo conceptual / Conceptual model

```pseudocode
type TreeNode
    value
    left = absent
    right = absent

type BinaryTree
    root = absent

    insert(value)
        if root is absent
            root = TreeNode.init(value)
            return success
        current = root
        while true
            if value == current.value
                return success
            if value < current.value
                if current.left is absent
                    current.left = TreeNode.init(value)
                    return success
                current = current.left
            else
                if current.right is absent
                    current.right = TreeNode.init(value)
                    return success
                current = current.right

type GraphNode
    value
    neighbours = empty collection

type Graph
    nodes = capacity-sized representation
    edges = 0

    add_edge(u, v)
        if u or v is outside the node domain
            return failure
        if v is not already in nodes[u].neighbours
            add v
            edges = edges + 1
        return success

    get_neighbors(u)
        if u is outside the node domain
            return failure
        return neighbours of u in increasing label order
```

La colección de vecinos puede ser una lista, un array, un mapa de conjuntos u otra representación del lenguaje. Esa elección no elimina el contrato de `GraphNode` ni permite importar la implementación del módulo básico.

The neighbour collection may be a list, array, set map or another language representation. That choice does not remove the `GraphNode` contract or permit importing the basic module's implementation.

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
- [ ] Se documentan indicadores, adaptaciones y casos no representables por lenguaje.
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