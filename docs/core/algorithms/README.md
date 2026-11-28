---
layout: default
title: Algoritmos Puros / Algorithms Pure
description: Algoritmos sobre secuencias y estructuras enlazadas con indicadores de fallo / Algorithms on sequences and linked structures with failure indicators
nav_order: 2
parent: Core
has_children: true
---

# Algoritmos Puros / Algorithms Pure

> [← Volver a Core](../README.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 📖 Descripción / Description

**ES:** Algoritmos sobre secuencias y estructuras de datos construidas desde cero,
con indicadores de fallo compatibles y sin excepciones. Ordenamiento y búsqueda
usan las secuencias que pide cada contrato; listas, pilas, colas, ABB y grafos
enseñan sus nodos, enlaces e invariantes. Preferir arrays para ordenar no impone
esa representación ni una capacidad máxima a las estructuras enlazadas.

**EN:** Algorithms on sequences and data structures built from scratch, using
compatible failure indicators and no exceptions. Sorting and searching use the
sequences required by their contracts; lists, stacks, queues, BSTs and graphs
teach their nodes, links and invariants. Preferring arrays for sorting does not
impose that representation or a maximum capacity on linked structures.

---

## 📁 Especificaciones / Specifications

| Módulo | Tema | Especificación |
|--------|------|----------------|
| `naive_sort` | selection, bubble, insertion (O(n²)) | [`05_Naive_Sort.md`](05_Naive_Sort.md) |
| `data_structures_basics` | Node, linked_list, stack y queue construidos desde cero | [`06_Data_Structures_Basics.md`](06_Data_Structures_Basics.md) |
| `data_structures_advanced` | Node con múltiples enlaces, binary tree y graph dirigidos construidos desde cero | [`07_Data_Structures_Advanced.md`](07_Data_Structures_Advanced.md) |
| `efficient_sort` | quick, merge, heap, Node propio y LLRB; alternativas / own Node and LLRB; alternatives | [`08_Efficient_Sort.md`](08_Efficient_Sort.md) |
| `distributed_sort` | radix, bucket, shell, counting | [`09_Distributed_Sort.md`](09_Distributed_Sort.md) |
| `searching` | secuencias indexables de números; linear sin orden y binary/jump/interpolation con orden como precondición | [`10_Searching.md`](10_Searching.md) |

**ES:** Consulta el [roadmap](../../ROADMAP.md) para el estado de cada módulo.
**EN:** See the [roadmap](../../ROADMAP.md) for each module's status.

> **ES:** `data_structures_basics` y `data_structures_advanced` son módulos autónomos y no importan código entre sí. En 06, `LinkedList`, `Stack` y `Queue` comparten un único `Node` y cada instancia se inicializa explícitamente; en 07, el árbol y el grafo tienen nodos especializados (`TreeNode`, `GraphNode`). Los módulos posteriores pueden usar las colecciones optimizadas del lenguaje cuando construir la estructura ya no sea el objetivo. `searching` cierra la fase como consumidor de los ordenamientos: las búsquedas indexadas reciben una secuencia ya ordenada y las pruebas muestran explícitamente esa preparación sin incluirla en la función de búsqueda. Las strings no forman parte de Algorithms Pure.
> **EN:** `data_structures_basics` and `data_structures_advanced` are autonomous modules and do not import code from each other. In 06, `LinkedList`, `Stack` and `Queue` share one `Node`, and each instance is explicitly initialized; in 07, the tree and graph have specialised nodes (`TreeNode`, `GraphNode`). Later modules may use the language's optimized collections when building the structure is no longer the goal. `searching` closes the phase as a consumer of sorting: indexed searches receive an already sorted sequence and tests explicitly show that preparation without including it in the search function. Strings are not part of Algorithms Pure.

---

**ES:** En 08, las colecciones de biblioteca son almacenamiento auxiliar:
los cuatro ordenamientos, el heap plano y el árbol balanceado siguen siendo
manuales. El contrato devuelve colección o `absent`, con vacío presente
distinguible (y `Option`/`Maybe` solo por restricción del lenguaje para
comparar `absent`); esto no cambia los indicadores de los módulos anteriores.
Cuando `test/` no accede a privados (Vía B), el contrato declara los helpers
mínimos de paso e inspección de invariantes exigidos por la especificación sin
penalizar encapsulación (C6).
La [guía 08 por familias](../../implementations/08_Efficient_Sort.md) desarrolla
los nodos y las variantes, mientras la especificación explica su fundamento.

**EN:** In 08, library collections provide auxiliary storage: all four sorts,
the flat heap, and the balanced tree remain manual. Its contract returns a
collection or `absent`, distinguishable from present empty output (allowing
`Option`/`Maybe` only by language restriction to compare `absent`); this does
not change earlier modules' indicators. When `test/` lacks private access
(Path B), the contract declares the minimal step and invariant-inspection
helpers required by the specification without penalizing encapsulation (C6).
The [08 family guide](../../implementations/08_Efficient_Sort.md) develops nodes
and variants, while the specification explains their foundation.

---

## 🧭 Flujo recomendado / Recommended flow

1. `05_Naive_Sort.md`
2. `06_Data_Structures_Basics.md`
3. `07_Data_Structures_Advanced.md`
4. `08_Efficient_Sort.md`
5. `09_Distributed_Sort.md`
6. `10_Searching.md`

---

## ▶️ Siguiente / Next

👉 Comienza con [`05_Naive_Sort.md`](05_Naive_Sort.md).  
👉 Start with [`05_Naive_Sort.md`](05_Naive_Sort.md).

---

*[← Volver a Core](../README.md) | [↑ Inicio](../../index.md)*
