---
layout: default
title: 08 — Efficient Sort
description: Octava especificación / Eighth specification — Ordenamiento óptimo por comparación O(n log n) (Quick, Merge, Heap)
nav_order: 4
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 08 — Efficient Sort

> [← Volver a 07_Structures_Apps](07_Structures_Apps.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar los tres algoritmos clásicos de ordenamiento por comparación de complejidad $O(n \log n)$: **Quick Sort**, **Merge Sort** y **Heap Sort**, comprendiendo las técnicas de divide y vencerás y la estructura implícita de montículo binario (heap) sobre arrays, la cual servirá como base directa para la cola de prioridad en fases posteriores. | Implement the three classic $O(n \log n)$ comparison-based sorting algorithms: **Quick Sort**, **Merge Sort**, and **Heap Sort**, understanding divide-and-conquer techniques and the implicit binary heap structure over arrays, which directly serves as the foundation for the priority queue in later phases. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `efficient_sort` con un módulo que contenga las funciones `quick_sort(arr)`, `merge_sort(arr)` y `heap_sort(arr)`. Cada función ordena un array de enteros en orden ascendente. Arrays nulos devuelven el indicador de fallo definido por el lenguaje/API; arrays vacíos o de un elemento se devuelven sin modificar. Sin excepciones. | Create an `efficient_sort` project with a module containing `quick_sort(arr)`, `merge_sort(arr)`, and `heap_sort(arr)`. Each function sorts an integer array in ascending order. Null arrays return the failure indicator defined by the language/API; empty or single-element arrays return unchanged. No exceptions. |

### Algoritmos esperados

| Algoritmo | Estrategia | Complejidad temporal | Memoria auxiliar |
|-----------|------------|---------------------|:----------------:|
| `quick_sort(arr)` | Partición recursiva respecto a un pivote (Hoare o Lomuto) | $O(n \log n)$ promedio, $O(n^2)$ peor | $O(\log n)$ (pila de llamadas) |
| `merge_sort(arr)` | División recursiva a la mitad y fusión ordenada de sub-arrays | $O(n \log n)$ en todos los casos | $O(n)$ (array auxiliar de fusión) |
| `heap_sort(arr)` | Construcción de max-heap in-place con `sift_down` y extracción sucesiva | $O(n \log n)$ en todos los casos | $O(1)$ in-place |

### Pseudocódigo / Pseudocode

```pseudocode
container efficient_sort
    .- quick_sort(arr)
        if arr is null return -1
        quick_sort_help(arr, 0, size(arr) - 1)
        return arr

    .- quick_sort_help(arr, low, high)
        if low < high
            p = partition(arr, low, high)
            quick_sort_help(arr, low, p)
            quick_sort_help(arr, p + 1, high)

    .- partition(arr, low, high)
        pivot = arr[low + div(high - low, 2)]
        i = low - 1
        j = high + 1
        while true
            repeat i = i + 1 until arr[i] >= pivot
            repeat j = j - 1 until arr[j] <= pivot
            if i >= j return j
            swap(arr, i, j)

    .- merge_sort(arr)
        if arr is null return -1
        if size(arr) <= 1 return arr
        mid = div(size(arr), 2)
        left = merge_sort(slice(arr, 0, mid))
        right = merge_sort(slice(arr, mid, size(arr)))
        return merge(left, right)

    .- merge(left, right)
        result = array(size(left) + size(right), 0)
        i = 0, j = 0, k = 0
        while i < size(left) and j < size(right)
            if left[i] <= right[j]
                result[k] = left[i]; i = i + 1
            else
                result[k] = right[j]; j = j + 1
            k = k + 1
        while i < size(left)
            result[k] = left[i]; i = i + 1; k = k + 1
        while j < size(right)
            result[k] = right[j]; j = j + 1; k = k + 1
        return result

    .- heap_sort(arr)
        if arr is null return -1
        n = size(arr)
        # Construir max-heap
        for i = div(n, 2) - 1 down to 0
            sift_down(arr, n, i)
        # Extraer elementos del heap
        for i = n - 1 down to 1
            swap(arr, 0, i)
            sift_down(arr, i, 0)
        return arr

    .- sift_down(arr, n, root)
        largest = root
        left = 2 * root + 1
        right = 2 * root + 2
        if left < n and arr[left] > arr[largest] largest = left
        if right < n and arr[right] > arr[largest] largest = right
        if largest != root
            swap(arr, root, largest)
            sift_down(arr, n, largest)
end container
```

### Casos de prueba / Test Cases

| Caso | Entrada | Salida esperada |
|------|---------|----------------|
| Array desordenado | `[12, 11, 13, 5, 6, 7]` | `[5, 6, 7, 11, 12, 13]` |
| Array con duplicados | `[4, 10, 3, 5, 1, 4]` | `[1, 3, 4, 4, 5, 10]` |
| Array ordenado inversamente | `[9, 8, 7, 6, 5, 4]` | `[4, 5, 6, 7, 8, 9]` |
| Array de tamaño impar y par | `[3, 1, 2]` y `[4, 2, 1, 3]` | `[1, 2, 3]` y `[1, 2, 3, 4]` |
| Array con negativos | `[0, -5, 7, -2, 3]` | `[-5, -2, 0, 3, 7]` |
| Un solo elemento y vacío | `[1]` y `[]` | `[1]` y `[]` |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los tres algoritmos (`quick_sort`, `merge_sort`, `heap_sort`) sin invocar bibliotecas nativas del sistema.  
      **EN:** All three algorithms (`quick_sort`, `merge_sort`, `heap_sort`) are implemented without invoking native system libraries.
- [ ] **ES:** `heap_sort` implementa el montículo binario mediante array plano con procedimiento explícito de `sift_down` (este procedimiento es la base de la cola de prioridad de Dijkstra).  
      **EN:** `heap_sort` implements the binary heap via flat array with explicit `sift_down` procedure (this procedure is the basis for Dijkstra's priority queue).
- [ ] **ES:** El caso nulo retorna el indicador de fallo compatible con el lenguaje/API (por ejemplo, `-1` cuando el tipo lo permite), sin excepciones.
    **EN:** Null input returns a language/API-compatible failure indicator (for example, `-1` when the type permits it), without exceptions.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── algorithms/
            └── efficient_sort/
                ├── src/
                │   └── efficient_sort.ext
                └── test/
                    ├── efficient_sort_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`09_Distributed_Sort.md`](09_Distributed_Sort.md) — Ordenamiento no comparativo y variantes avanzadas (Counting, Radix, Bucket, Shell).  
👉 Continue with [`09_Distributed_Sort.md`](09_Distributed_Sort.md) — Non-comparative sorting and advanced variants (Counting, Radix, Bucket, Shell).

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
