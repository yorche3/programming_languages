---
layout: default
title: Algoritmos Puros / Algorithms Pure
description: Índice de la sección de algoritmos puros — solo secuencias indexables e indicadores de fallo / Index for the pure algorithms section — only indexable sequences and failure indicators
nav_order: 2
parent: Core
grand_parent: Programming Languages Monorepo
---

# Algoritmos Puros / Algorithms Pure

> [← Volver a Core](../README.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 📖 Descripción / Description

**ES:** Algoritmos estructurados solo con **secuencias indexables** e indicadores de fallo compatibles con cada lenguaje. Sin excepciones, sin estructuras avanzadas. La progresión va desde los más simples a los optimizados, incluyendo estructuras de datos implementadas desde cero sobre secuencias indexables.

**EN:** Algorithms structured with only **indexable sequences** and language-compatible failure indicators. No exceptions, no advanced structures. The progression goes from the simplest to the optimized, including data structures implemented from scratch over indexable sequences.

---

## 📁 Especificaciones / Specifications

| Módulo | Estado | Tema | Especificación |
|--------|--------|------|----------------|
| `naive_sort` | 🔄 | selection, bubble, insertion (O(n²)) | [`05_Naive_Sort.md`](05_Naive_Sort.md) |
| `data_structures_basics` | 📋 | Node, linked_list, stack y queue construidos desde cero | [`06_Data_Structures_Basics.md`](06_Data_Structures_Basics.md) |
| `data_structures_advanced` | 📋 | Node con múltiples enlaces, binary tree y graph dirigidos construidos desde cero | [`07_Data_Structures_Advanced.md`](07_Data_Structures_Advanced.md) |
| `efficient_sort` | 📋 | quick, merge, heap (O(n log n)) | [`08_Efficient_Sort.md`](08_Efficient_Sort.md) |
| `distributed_sort` | 📋 | radix, bucket, shell, counting | [`09_Distributed_Sort.md`](09_Distributed_Sort.md) |
| `searching` | 📋 | secuencias indexables de números; linear sin orden y binary/jump/interpolation con orden como precondición | [`10_Searching.md`](10_Searching.md) |

> **ES:** `data_structures_basics` y `data_structures_advanced` son módulos autónomos: ambos declaran y prueban su propio `Node` y no importan código entre sí. Los módulos posteriores pueden usar las colecciones optimizadas del lenguaje cuando construir la estructura ya no sea el objetivo. `searching` cierra la fase como consumidor de los ordenamientos: las búsquedas indexadas reciben una secuencia ya ordenada y las pruebas muestran explícitamente esa preparación sin incluirla en la función de búsqueda. Las strings no forman parte de Algorithms Pure.
> **EN:** `data_structures_basics` and `data_structures_advanced` are autonomous modules: both declare and test their own `Node` and do not import code from each other. Later modules may use the language's optimized collections when building the structure is no longer the goal. `searching` closes the phase as a consumer of sorting: indexed searches receive an already sorted sequence and tests explicitly show that preparation without including it in the search function. Strings are not part of Algorithms Pure.

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
