---
layout: default
title: 05 — Naive Sort
description: Quinta especificación / Fifth specification — Ordenamiento elemental O(n²) con arrays y valores centinela
nav_order: 1
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 05 — Naive Sort

> [← Volver a 04_Numbers](../foundations/04_Numbers.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar los tres algoritmos elementales de ordenamiento ($O(n^2)$): **Bubble Sort**, **Insertion Sort** y **Selection Sort**, trabajando directamente sobre arrays y utilizando comparaciones e intercambios paso a paso sin bibliotecas de ordenamiento del sistema ni estructuras auxiliares complejas. | Implement the three elementary sorting algorithms ($O(n^2)$): **Bubble Sort**, **Insertion Sort**, and **Selection Sort**, working directly over arrays and using step-by-step comparisons and swaps without system sorting libraries or complex auxiliary structures. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `naive_sort` con un módulo que contenga las funciones `bubble_sort(arr)`, `insertion_sort(arr)` y `selection_sort(arr)`. Cada función recibe un array de enteros y devuelve el array ordenado de menor a mayor (de forma in-place o retornando una copia ordenada según el paradigma del lenguaje). Si el array es nulo, devuelve un valor centinela (`-1` o indicador nulo); si está vacío, devuelve el mismo array vacío. Sin excepciones. | Create a `naive_sort` project with a module containing `bubble_sort(arr)`, `insertion_sort(arr)`, and `selection_sort(arr)`. Each function takes an integer array and returns it sorted in ascending order (in-place or returning a sorted copy depending on the language paradigm). If the array is null, returns a sentinel value (`-1` or null indicator); if empty, returns the same empty array. No exceptions. |

### Implementaciones esperadas

| Algoritmo | Estrategia | Complejidad temporal | In-place |
|-----------|------------|---------------------|:--------:|
| `bubble_sort(arr)` | Compara e intercambia adyacentes; optimizado con bandera si no hay swaps | $O(n^2)$ peor/promedio, $O(n)$ mejor | ✅ |
| `insertion_sort(arr)` | Construye el sub-array ordenado insertando cada elemento en su posición | $O(n^2)$ peor/promedio, $O(n)$ mejor | ✅ |
| `selection_sort(arr)` | Encuentra iterativamente el mínimo del resto no ordenado y lo ubica al inicio | $O(n^2)$ siempre | ✅ |

### Pseudocódigo / Pseudocode

```pseudocode
container naive_sort
    .- bubble_sort(arr)
        if arr is null
            return -1                      # centinela
        n = size(arr)
        if n <= 1
            return arr
        for i = 0 to n - 2
            swapped = false
            for j = 0 to n - 2 - i
                if arr[j] > arr[j + 1]
                    swap(arr, j, j + 1)
                    swapped = true
            if not swapped
                break
        return arr

    .- insertion_sort(arr)
        if arr is null
            return -1
        n = size(arr)
        if n <= 1
            return arr
        for i = 1 to n - 1
            key = arr[i]
            j = i - 1
            while j >= 0 and arr[j] > key
                arr[j + 1] = arr[j]
                j = j - 1
            arr[j + 1] = key
        return arr

    .- selection_sort(arr)
        if arr is null
            return -1
        n = size(arr)
        if n <= 1
            return arr
        for i = 0 to n - 2
            min_idx = i
            for j = i + 1 to n - 1
                if arr[j] < arr[min_idx]
                    min_idx = j
            if min_idx != i
                swap(arr, i, min_idx)
        return arr
end container
```

### Casos de prueba / Test Cases

Las pruebas unitarias deben validar los siguientes casos para cada uno de los tres algoritmos:

| Caso | Entrada | Salida esperada |
|------|---------|----------------|
| Array estándar desordenado | `[5, 2, 9, 1, 5, 6]` | `[1, 2, 5, 5, 6, 9]` |
| Array ya ordenado | `[1, 2, 3, 4, 5]` | `[1, 2, 3, 4, 5]` |
| Array en orden inverso | `[5, 4, 3, 2, 1]` | `[1, 2, 3, 4, 5]` |
| Elementos idénticos | `[7, 7, 7, 7]` | `[7, 7, 7, 7]` |
| Con números negativos | `[3, -1, 4, -5, 0]` | `[-5, -1, 0, 3, 4]` |
| Un solo elemento | `[42]` | `[42]` |
| Array vacío | `[]` | `[]` |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los tres algoritmos (`bubble_sort`, `insertion_sort`, `selection_sort`) sin invocar bibliotecas nativas de sort.  
      **EN:** All three algorithms (`bubble_sort`, `insertion_sort`, `selection_sort`) are implemented without invoking native sort libraries.
- [ ] **ES:** `bubble_sort` incluye la optimización de salida temprana con bandera de intercambio (`swapped`).  
      **EN:** `bubble_sort` includes the early-exit optimization with a swap flag (`swapped`).
- [ ] **ES:** Casos inválidos/nulos retornan valor centinela (`-1` o nulo del lenguaje) sin lanzar excepciones.  
      **EN:** Invalid/null cases return a sentinel value (`-1` or language null) without throwing exceptions.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── algorithms/
            └── naive_sort/
                ├── src/
                │   └── naive_sort.ext
                └── test/
                    ├── naive_sort_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`06_Data_Structures.md`](06_Data_Structures.md) — Estructuras de datos fundamentales modeladas con arrays.  
👉 Continue with [`06_Data_Structures.md`](06_Data_Structures.md) — Fundamental data structures modeled with arrays.

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
