---
layout: default
title: 09 — Distributed Sort
description: Novena especificación / Ninth specification — Algoritmos no comparativos y distribuidos (Counting, Radix, Bucket, Shell)
nav_order: 5
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 09 — Distributed Sort

> [← Volver a 08_Efficient_Sort](08_Efficient_Sort.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar algoritmos de ordenamiento distributivo y no comparativo: **Counting Sort**, **Radix Sort**, **Bucket Sort** y **Shell Sort**, comprendiendo cómo romper la barrera teórica de $\Omega(n \log n)$ de los ordenamientos por comparación mediante el conteo de frecuencias, la posición de dígitos y la distribución en cubetas sobre arrays. | Implement non-comparative and distributive sorting algorithms: **Counting Sort**, **Radix Sort**, **Bucket Sort**, and **Shell Sort**, understanding how to break the theoretical $\Omega(n \log n)$ bound of comparison sorts through frequency counts, digit positions, and bucket distribution over arrays. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `distributed_sort` con un módulo que implemente `counting_sort(arr)`, `radix_sort(arr)`, `bucket_sort(arr)` y `shell_sort(arr)`. Cada algoritmo ordena enteros no negativos (o con rango conocido) en orden ascendente. Casos nulos devuelven el centinela `-1`. Sin excepciones. | Create a `distributed_sort` project with a module implementing `counting_sort(arr)`, `radix_sort(arr)`, `bucket_sort(arr)`, and `shell_sort(arr)`. Each algorithm sorts non-negative integers (or known-range integers) in ascending order. Null cases return the sentinel `-1`. No exceptions. |

### Algoritmos esperados

| Algoritmo | Estrategia | Complejidad temporal | Requisito clave |
|-----------|------------|---------------------|-----------------|
| `counting_sort(arr)` | Tabla de conteo acumulado y colocación estable | $O(n + k)$ donde $k$ es el rango de valores | Rango de valores $k$ acotado |
| `radix_sort(arr)` | Counting sort estable por dígito (LSD: menos a más significativo) | $O(d \cdot (n + b))$ donde $d$ son dígitos y $b$ la base (10) | Enteros no negativos |
| `bucket_sort(arr)` | Distribución en cubetas con arrays + ordenamiento interno | $O(n + k)$ promedio | Distribución uniforme de valores |
| `shell_sort(arr)` | Insertion sort generalizado con brechas decrecientes ($gap = \lfloor gap / 2 \rfloor$) | $O(n^{3/2})$ o $O(n \log^2 n)$ | Comparativo, sin memoria extra |

### Pseudocódigo / Pseudocode

```pseudocode
container distributed_sort
    .- counting_sort(arr)
        if arr is null return -1
        if size(arr) <= 1 return arr
        max_val = max(arr)
        count = array(max_val + 1, 0)
        output = array(size(arr), 0)

        for x in arr
            count[x] = count[x] + 1
        for i = 1 to max_val
            count[i] = count[i] + count[i - 1]
        for i = size(arr) - 1 down to 0
            output[count[arr[i]] - 1] = arr[i]
            count[arr[i]] = count[arr[i]] - 1
        return output

    .- radix_sort(arr)
        if arr is null return -1
        if size(arr) <= 1 return arr
        max_val = max(arr)
        exp = 1
        while div(max_val, exp) > 0
            arr = counting_sort_by_digit(arr, exp)
            exp = exp * 10
        return arr

    .- shell_sort(arr)
        if arr is null return -1
        n = size(arr)
        gap = div(n, 2)
        while gap > 0
            for i = gap to n - 1
                temp = arr[i]
                j = i
                while j >= gap and arr[j - gap] > temp
                    arr[j] = arr[j - gap]
                    j = j - gap
                arr[j] = temp
            gap = div(gap, 2)
        return arr
end container
```

### Casos de prueba / Test Cases

| Algoritmo | Entrada | Salida esperada |
|-----------|---------|----------------|
| `counting_sort` | `[4, 2, 2, 8, 3, 3, 1]` | `[1, 2, 2, 3, 3, 4, 8]` |
| `radix_sort` | `[170, 45, 75, 90, 802, 24, 2, 66]` | `[2, 24, 45, 66, 75, 90, 170, 802]` |
| `shell_sort` | `[12, 34, 54, 2, 3]` | `[2, 3, 12, 34, 54]` |
| `counting_sort` | `[0, 0, 1, 0]` | `[0, 0, 0, 1]` |
| Todos | Array vacío `[]` y unitario `[5]` | `[]` y `[5]` |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** `counting_sort` es estable (recorre de fin a inicio al colocar elementos en la salida).  
      **EN:** `counting_sort` is stable (traverses back-to-front when placing elements in output).
- [ ] **ES:** `radix_sort` opera dígito a dígito de forma LSD (Least Significant Digit).  
      **EN:** `radix_sort` operates digit-by-digit in LSD (Least Significant Digit) fashion.
- [ ] **ES:** Entradas nulas devuelven `-1` (valor centinela), sin excepciones.  
      **EN:** Null inputs return `-1` (sentinel value), no exceptions.
- [ ] **ES:** El proyecto separa `src/` de `test/` y usa el framework de pruebas del lenguaje.  
      **EN:** The project separates `src/` from `test/` and uses the language's test framework.

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── algorithms/
            └── distributed_sort/
                ├── src/
                │   └── distributed_sort.ext
                └── test/
                    ├── distributed_sort_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`10_Searching.md`](10_Searching.md) — Algoritmos de búsqueda (Linear, Binary, Jump, Interpolation).  
👉 Continue with [`10_Searching.md`](10_Searching.md) — Searching algorithms (Linear, Binary, Jump, Interpolation).

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
