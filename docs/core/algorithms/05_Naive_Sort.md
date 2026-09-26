---
layout: default
title: 05 — Naive Sort
description: Quinta especificación / Fifth specification — Ordenamiento elemental O(n²) sobre secuencias indexables e indicadores de fallo
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
| Implementar los tres algoritmos elementales de ordenamiento ($O(n^2)$): **Selection Sort**, **Bubble Sort** e **Insertion Sort**, trabajando directamente sobre la **secuencia indexable** de entrada y utilizando comparaciones e intercambios paso a paso sin bibliotecas de ordenamiento del sistema ni estructuras auxiliares complejas. | Implement the three elementary sorting algorithms ($O(n^2)$): **Selection Sort**, **Bubble Sort**, and **Insertion Sort**, working directly over the **input indexable sequence** and using step-by-step comparisons and swaps without system sorting libraries or complex auxiliary structures. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `naive_sort` con un módulo que contenga las funciones `selection_sort(arr)`, `bubble_sort(arr)` e `insertion_sort(arr)`. Cada función recibe una **secuencia indexable de enteros** (ver [`04_Numbers.md`](../foundations/04_Numbers.md)) y devuelve la secuencia ordenada de menor a mayor (de forma in-place o retornando una copia ordenada según el paradigma del lenguaje); su representación es libre y se declara en el README. Si la entrada es nula o inválida, devuelve el indicador de fallo definido por el lenguaje o la API (`-1`, `null` u otra representación equivalente, **sin** `Option`/`Result`: llegan en la Fase 4); si está vacía, devuelve la misma secuencia vacía. No lanza excepciones. | Create a `naive_sort` project with a module containing `selection_sort(arr)`, `bubble_sort(arr)`, and `insertion_sort(arr)`. Each function takes an **indexable sequence of integers** (see [`04_Numbers.md`](../foundations/04_Numbers.md)) and returns it sorted in ascending order (in-place or returning a sorted copy depending on the language paradigm); its representation is free and is declared in the README. If the input is null or invalid, it returns the failure indicator defined by the language or API (`-1`, `null` or another equivalent representation, **without** `Option`/`Result`: they arrive in Phase 4); if empty, it returns the same empty sequence. It does not throw exceptions. |

### Implementaciones esperadas

| Algoritmo | Estrategia | Complejidad temporal | In-place |
| ----------- | ------------ | --------------------- | :--------: |
| `selection_sort(arr)` | Encuentra iterativamente el mínimo del resto no ordenado y lo ubica al inicio | $O(n^2)$ siempre | ✅ |
| `bubble_sort(arr)` | Compara e intercambia adyacentes; optimizado con bandera si no hay swaps | $O(n^2)$ peor/promedio, $O(n)$ mejor | ✅ |
| `insertion_sort(arr)` | Construye la sub-secuencia ordenada insertando cada elemento en su posición | $O(n^2)$ peor/promedio, $O(n)$ mejor | ✅ |

### Pseudocódigo / Pseudocode

```pseudocode
container naive_sort
    .- selection_sort(arr)
        if arr is null or invalid
            return failure_indicator       # representación de fallo del lenguaje
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

    .- bubble_sort(arr)
        if arr is null or invalid
            return failure_indicator
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
        if arr is null or invalid
            return failure_indicator
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
end container
```

### Casos de prueba / Test Cases

Las pruebas unitarias deben validar los siguientes casos para cada uno de los tres algoritmos:

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
| ------ | --------- | ---------------- |
| Secuencia estándar desordenada<br>Standard unordered sequence | `[5, 2, 9, 1, 5, 6]` | `[1, 2, 5, 5, 6, 9]` |
| Secuencia ya ordenada<br>Already sorted sequence | `[1, 2, 3, 4, 5]` | `[1, 2, 3, 4, 5]` |
| Secuencia en orden inverso<br>Reverse-ordered sequence | `[5, 4, 3, 2, 1]` | `[1, 2, 3, 4, 5]` |
| Elementos idénticos<br>Identical elements | `[7, 7, 7, 7]` | `[7, 7, 7, 7]` |
| Con números negativos<br>With negative numbers | `[3, -1, 4, -5, 0]` | `[-5, -1, 0, 3, 4]` |
| Un solo elemento<br>Single element | `[42]` | `[42]` |
| Secuencia vacía<br>Empty sequence | `[]` | `[]` |

> **ES:** Si el lenguaje/API puede representar una entrada nula o inválida, añade un caso controlado que compruebe el indicador de fallo correspondiente. No es una prueba para provocar una excepción: el contrato exige devolver el indicador y continuar con el runner. Si el tipo de la secuencia no admite un valor ausente, documenta la representación equivalente y conserva el resto de casos.
> **EN:** If the language/API can represent a null or invalid input, add a controlled case that checks the corresponding failure indicator. This is not an exception-triggering test: the contract requires returning the indicator and continuing through the runner. If the sequence type admits no absent value, document the equivalent representation and keep the remaining cases.

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los tres algoritmos (`selection_sort`, `bubble_sort`, `insertion_sort`) sin invocar bibliotecas nativas de sort.  
      **EN:** All three algorithms (`selection_sort`, `bubble_sort`, `insertion_sort`) are implemented without invoking native sort libraries.
- [ ] **ES:** `bubble_sort` incluye la optimización de salida temprana con bandera de intercambio (`swapped`).  
      **EN:** `bubble_sort` includes the early-exit optimization with a swap flag (`swapped`).
- [ ] **ES:** Casos inválidos/nulos retornan el indicador de fallo del lenguaje/API (`-1`, `null`, `Option/Maybe` vacío, `Result` de error o equivalente) sin lanzar excepciones.
    **EN:** Invalid/null cases return the language/API failure indicator (`-1`, `null`, empty `Option/Maybe`, error `Result`, or equivalent) without throwing exceptions.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).

> **ES:** En esta fase los casos inválidos son entradas controladas del contrato y no errores inesperados. Las excepciones y validaciones idiomáticas se introducen posteriormente en `core/text`; más adelante se formalizan retornos `Option`/`Result` en la fase de abstracción y persistencia.
> **EN:** In this phase, invalid cases are controlled contract inputs, not unexpected errors. Idiomatic exceptions and validation are introduced later in `core/text`; `Option`/`Result` returns are formalized afterward in the abstraction and persistence phase.

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

👉 Sigue con [`06_Data_Structures.md`](06_Data_Structures.md) — Estructuras de datos fundamentales: contrato fijo y representación libre.
👉 Continue with [`06_Data_Structures.md`](06_Data_Structures.md) — Fundamental data structures: fixed contract and free representation.

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
