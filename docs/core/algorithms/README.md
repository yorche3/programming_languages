---
layout: default
title: Algoritmos Puros / Algorithms Pure
description: Índice de la sección de algoritmos puros — solo arrays e indicadores de fallo / Index for the pure algorithms section — only arrays and failure indicators
nav_order: 2
parent: Core
grand_parent: Programming Languages Monorepo
---

# Algoritmos Puros / Algorithms Pure

> [← Volver a Core](../README.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 📖 Descripción / Description

**ES:** Algoritmos estructurados solo con arrays e indicadores de fallo compatibles con cada lenguaje. Sin excepciones, sin estructuras avanzadas. La progresión va desde los más simples a los optimizados, incluyendo estructuras de datos implementadas con arrays.

**EN:** Algorithms structured with only arrays and language-compatible failure indicators. No exceptions, no advanced structures. The progression goes from the simplest to the optimized, including data structures implemented with arrays.

---

## 📁 Especificaciones / Specifications

| Módulo | Estado | Tema | Especificación |
|--------|--------|------|----------------|
| `naive_sort` | 🔄 | selection, bubble, insertion (O(n²)) | [`05_Naive_Sort.md`](05_Naive_Sort.md) |
| `data_structures` | 📋 | construcción y contrato de stack, queue, linked_list, tree y graph sobre arrays | [`06_Data_Structures.md`](06_Data_Structures.md) |
| `efficient_sort` | 📋 | quick, merge, heap (O(n log n)) | [`07_Efficient_Sort.md`](07_Efficient_Sort.md) |
| `distributed_sort` | 📋 | radix, bucket, shell, counting | [`08_Distributed_Sort.md`](08_Distributed_Sort.md) |
| `searching` | 📋 | arrays numéricos; linear sin orden y binary/jump/interpolation con orden como precondición | [`09_Searching.md`](09_Searching.md) |

> **ES:** `data_structures` construye el ADT y verifica sus invariantes; los módulos siguientes pueden usar las colecciones optimizadas del lenguaje cuando construir la estructura no sea el objetivo. `searching` cierra la fase como consumidor de los ordenamientos: las búsquedas indexadas reciben un array ya ordenado y las pruebas muestran explícitamente esa preparación sin incluirla en la función de búsqueda. Las strings no forman parte de Algorithms Pure.
> **EN:** `data_structures` builds the ADT and verifies its invariants; later modules may use the language's optimized collections when building the structure is not the objective. `searching` closes the phase as a consumer of sorting: indexed searches receive an already sorted array and tests explicitly show that preparation without including it in the search function. Strings are not part of Algorithms Pure.

---

## 🧭 Flujo recomendado / Recommended flow

1. `05_Naive_Sort.md`
2. `06_Data_Structures.md`
3. `07_Efficient_Sort.md`
4. `08_Distributed_Sort.md`
5. `09_Searching.md`

---

## ▶️ Siguiente / Next

👉 Comienza con [`05_Naive_Sort.md`](05_Naive_Sort.md).  
👉 Start with [`05_Naive_Sort.md`](05_Naive_Sort.md).

---

*[← Volver a Core](../README.md) | [↑ Inicio](../../index.md)*
