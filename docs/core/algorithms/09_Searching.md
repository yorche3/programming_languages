---
layout: default
title: 09 — Searching
description: Novena especificación / Ninth specification — Algoritmos de búsqueda sobre arrays (Linear, Binary, Jump, Interpolation)
nav_order: 5
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 09 — Searching

> [← Volver a 08_Distributed_Sort](08_Distributed_Sort.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar algoritmos de búsqueda sobre **arrays numéricos** y razonar sobre las precondiciones que hacen aplicable cada uno. `linear_search` no requiere orden; **Binary**, **Jump** e **Interpolation** requieren un array en orden ascendente, e Interpolation además una distribución aproximadamente uniforme. Este módulo consume los ordenamientos de la fase: la búsqueda no ordena, copia ni modifica su entrada. | Implement search algorithms over **numeric arrays** and reason about the preconditions that make each applicable. `linear_search` requires no ordering; **Binary**, **Jump**, and **Interpolation** require an ascending array, and Interpolation additionally needs an approximately uniform distribution. This module consumes the phase's sorting algorithms: search does not sort, copy, or mutate its input. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `searching` con un módulo que contenga las funciones `linear_search(arr, target)`, `binary_search(arr, target)`, `jump_search(arr, target)` e `interpolation_search(arr, target)`. Cada función devuelve el índice base 0 donde se ubica `target` en `arr`. Si el elemento no existe, o si el array es nulo/vacío, devuelve el indicador de fallo compatible con el lenguaje/API. Sin excepciones. | Create a `searching` project with a module containing `linear_search(arr, target)`, `binary_search(arr, target)`, `jump_search(arr, target)`, and `interpolation_search(arr, target)`. Each function returns the 0-based index where `target` is located in `arr`. If the element does not exist, or if the array is null/empty, returns the language/API-compatible failure indicator. No exceptions. |

### Algoritmos esperados

| Algoritmo | Precondición | Complejidad temporal | Estrategia |
|-----------|:------------:|:--------------------:|------------|
| `linear_search(arr, target)` | Ninguna (funciona en desordenado) | $O(n)$ | Recorre elemento a elemento de inicio a fin |
| `binary_search(arr, target)` | Array ordenado ascendente | $O(\log n)$ | Divide el espacio de búsqueda a la mitad en cada paso |
| `jump_search(arr, target)` | Array ordenado ascendente | $O(\sqrt{n})$ | Salta bloques de tamaño $m = \lfloor \sqrt{n} \rfloor$ y luego busca lineal |
| `interpolation_search(arr, target)` | Array ordenado y uniformemente distribuido | $O(\log \log n)$ promedio, $O(n)$ peor | Estima la posición mediante interpolación lineal de valores |

> **ES:** **Precondición contractual:** `binary_search`, `jump_search` e `interpolation_search` reciben arrays ya ordenados; no llaman a `sort()` ni a un algoritmo propio internamente. La suite debe incluir, además de arrays literales ordenados, un caso de composición: crear un array desordenado, ordenar una **copia** con uno de los algoritmos previos (`selection_sort`, `quick_sort`, `counting_sort` u otro aplicable) y después invocar la búsqueda. La aserción debe comprobar que la búsqueda no mutó el array ordenado. Strings y listas quedan fuera de este módulo.
> **EN:** **Contractual precondition:** `binary_search`, `jump_search`, and `interpolation_search` receive already sorted arrays; they do not call `sort()` or an own algorithm internally. Beyond sorted literal arrays, the suite must include one composition case: create an unordered array, sort a **copy** with a previous algorithm (`selection_sort`, `quick_sort`, `counting_sort`, or another applicable one), and then invoke search. The assertion must verify that search did not mutate the sorted array. Strings and lists are outside this module.

### Pseudocódigo / Pseudocode

```pseudocode
container searching
    .- linear_search(arr, target)
        if arr is null return -1
        for i = 0 to size(arr) - 1
            if arr[i] == target
                return i
        return -1

    .- binary_search(arr, target)
        if arr is null return -1
        low = 0
        high = size(arr) - 1
        while low <= high
            mid = low + div(high - low, 2)
            if arr[mid] == target
                return mid
            else if arr[mid] < target
                low = mid + 1
            else
                high = mid - 1
        return -1

    .- jump_search(arr, target)
        if arr is null or size(arr) == 0 return -1
        n = size(arr)
        step = floor(sqrt(n))
        prev = 0
        while prev < n and arr[min(step, n) - 1] < target
            prev = step
            step = step + floor(sqrt(n))
            if prev >= n
                return -1
        for i = prev to min(step, n) - 1
            if arr[i] == target
                return i
        return -1

    .- interpolation_search(arr, target)
        if arr is null or size(arr) == 0 return -1
        low = 0
        high = size(arr) - 1
        while low <= high and target >= arr[low] and target <= arr[high]
            if low == high
                return arr[low] == target ? low : -1
            # Proporción de interpolación
            pos = low + div((target - arr[low]) * (high - low), arr[high] - arr[low])
            if arr[pos] == target
                return pos
            else if arr[pos] < target
                low = pos + 1
            else
                high = pos - 1
        return -1
end container
```

### Casos de prueba / Test Cases

| Algoritmo | Array de prueba | Target | Salida esperada |
|-----------|-----------------|:------:|:---------------:|
| `linear_search` | `[10, 50, 30, 70, 80, 20]` (desordenado) | 30 | 2 |
| `linear_search` | `[10, 50, 30, 70, 80, 20]` | 99 | -1 |
| `binary_search` | `[2, 5, 8, 12, 16, 23, 38, 56, 72, 91]` (ordenado) | 23 | 5 |
| `binary_search` | `[2, 5, 8, 12, 16, 23, 38, 56, 72, 91]` | 50 | -1 |
| `jump_search` | `[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]` | 55 | 10 |
| `jump_search` | `[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]` | 7 | -1 |
| `interpolation_search` | `[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]` | 70 | 6 |
| `interpolation_search` | `[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]` | 15 | -1 |
| Todos | `[]` (vacío) | 5 | -1 |
| Todos | `[42]` (un elemento) | 42 | 0 |
| Composición | Copia de `[10, 50, 30, 70, 80, 20]`, ordenada previamente con un sort propio | 70 | Índice de `70`; la búsqueda conserva el array ordenado |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los cuatro algoritmos respetando sus fórmulas de salto y cálculo de índice.  
      **EN:** All four algorithms are implemented respecting their jumping formulas and index calculations.
- [ ] **ES:** Cuando el elemento no existe o la entrada es inválida, se devuelve el indicador de fallo compatible con el lenguaje/API (por ejemplo, `-1` cuando el índice lo permite), sin excepciones.
    **EN:** When the element does not exist or input is invalid, a language/API-compatible failure indicator is returned (for example, `-1` when the index type permits it), without exceptions.
- [ ] **ES:** `binary_search` evita el desbordamiento de enteros calculando el punto medio con `low + div(high - low, 2)`.  
      **EN:** `binary_search` prevents integer overflow calculating the midpoint with `low + div(high - low, 2)`.
- [ ] **ES:** Las pruebas muestran al menos una composición explícita con un ordenamiento anterior; ninguna función de búsqueda ordena o muta el array recibido.
    **EN:** Tests show at least one explicit composition with a preceding sort; no search function sorts or mutates the received array.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── algorithms/
            └── searching/
                ├── src/
                │   └── searching.ext
                └── test/
                    ├── searching_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Concluye la Fase 1. Continúa con [Fase 2 — Procesamiento Contiguo](../text/README.md).  
👉 Completes Phase 1. Continue with [Phase 2 — Contiguous Processing](../text/README.md).

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
