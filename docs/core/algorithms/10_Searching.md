---
layout: default
title: 10 — Searching
description: Décima especificación / Tenth specification — Algoritmos de búsqueda sobre arrays (Linear, Binary, Jump, Interpolation)
nav_order: 6
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 10 — Searching

> [← Volver a 09_Distributed_Sort](09_Distributed_Sort.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar los algoritmos fundamentales de búsqueda sobre arrays: **Linear Search**, **Binary Search**, **Jump Search** e **Interpolation Search**, analizando el compromiso entre precondiciones de ordenamiento y rendimiento temporal ($O(n)$, $O(\sqrt{n})$, $O(\log n)$ y $O(\log \log n)$), devolviendo el índice encontrado o el valor centinela `-1` si el elemento no está presente. | Implement fundamental search algorithms on arrays: **Linear Search**, **Binary Search**, **Jump Search**, and **Interpolation Search**, analyzing the trade-off between sorting preconditions and time performance ($O(n)$, $O(\sqrt{n})$, $O(\log n)$, and $O(\log \log n)$), returning the found index or the sentinel value `-1` if the element is not present. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `searching` con un módulo que contenga las funciones `linear_search(arr, target)`, `binary_search(arr, target)`, `jump_search(arr, target)` e `interpolation_search(arr, target)`. Cada función devuelve el índice base 0 donde se ubica `target` en `arr`. Si el elemento no existe, o si el array es nulo/vacío, devuelve `-1`. Sin excepciones. | Create a `searching` project with a module containing `linear_search(arr, target)`, `binary_search(arr, target)`, `jump_search(arr, target)`, and `interpolation_search(arr, target)`. Each function returns the 0-based index where `target` is located in `arr`. If the element does not exist, or if the array is null/empty, returns `-1`. No exceptions. |

### Algoritmos esperados

| Algoritmo | Precondición | Complejidad temporal | Estrategia |
|-----------|:------------:|:--------------------:|------------|
| `linear_search(arr, target)` | Ninguna (funciona en desordenado) | $O(n)$ | Recorre elemento a elemento de inicio a fin |
| `binary_search(arr, target)` | Array ordenado ascendente | $O(\log n)$ | Divide el espacio de búsqueda a la mitad en cada paso |
| `jump_search(arr, target)` | Array ordenado ascendente | $O(\sqrt{n})$ | Salta bloques de tamaño $m = \lfloor \sqrt{n} \rfloor$ y luego busca lineal |
| `interpolation_search(arr, target)` | Array ordenado y uniformemente distribuido | $O(\log \log n)$ promedio, $O(n)$ peor | Estima la posición mediante interpolación lineal de valores |

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

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los cuatro algoritmos respetando sus fórmulas de salto y cálculo de índice.  
      **EN:** All four algorithms are implemented respecting their jumping formulas and index calculations.
- [ ] **ES:** Cuando el elemento no existe o la entrada es inválida, se devuelve el indicador de fallo compatible con el lenguaje/API (por ejemplo, `-1` cuando el índice lo permite), sin excepciones.
    **EN:** When the element does not exist or input is invalid, a language/API-compatible failure indicator is returned (for example, `-1` when the index type permits it), without exceptions.
- [ ] **ES:** `binary_search` evita el desbordamiento de enteros calculando el punto medio con `low + div(high - low, 2)`.  
      **EN:** `binary_search` prevents integer overflow calculating the midpoint with `low + div(high - low, 2)`.
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
