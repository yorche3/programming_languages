---
layout: default
title: 09 — Distributed Sort
description: Octava especificación / Eighth specification — Algoritmos no comparativos y distribuidos (Counting, Radix, Bucket, Shell)
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
| Implementar algoritmos de ordenamiento distributivo y no comparativo: **Counting Sort**, **Radix Sort**, **Bucket Sort** y **Shell Sort**, comprendiendo cómo romper la barrera teórica de $\Omega(n \log n)$ de los ordenamientos por comparación mediante el conteo de frecuencias, la posición de dígitos y la distribución en cubetas sobre **secuencias indexables**. | Implement non-comparative and distributive sorting algorithms: **Counting Sort**, **Radix Sort**, **Bucket Sort**, and **Shell Sort**, understanding how to break the theoretical $\Omega(n \log n)$ bound of comparison sorts through frequency counts, digit positions, and bucket distribution over **indexable sequences**. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `distributed_sort` con un módulo que implemente `counting_sort(arr)`, `radix_sort(arr)`, `bucket_sort(arr)` y `shell_sort(arr)`. Cada algoritmo ordena enteros no negativos (o con rango conocido) en orden ascendente sobre una **secuencia indexable de enteros** (ver [`04_Numbers.md`](../foundations/04_Numbers.md)), cuya representación es libre y se declara en el README. Los casos nulos devuelven el indicador de fallo definido por el lenguaje/API. Sin excepciones. | Create a `distributed_sort` project with a module implementing `counting_sort(arr)`, `radix_sort(arr)`, `bucket_sort(arr)`, and `shell_sort(arr)`. Each algorithm sorts non-negative integers (or integers in a known range) in ascending order over an **indexable sequence of integers** (see [`04_Numbers.md`](../foundations/04_Numbers.md)), whose representation is free and is declared in the README. Null cases return the failure indicator defined by the language/API. No exceptions. |

### Algoritmos esperados

| Algoritmo | Estrategia | Complejidad temporal | Requisito clave |
|-----------|------------|---------------------|-----------------|
| `counting_sort(arr)` | Tabla de conteo acumulado y colocación estable | $O(n + k)$ donde $k$ es el rango de valores | Rango de valores $k$ acotado |
| `radix_sort(arr)` | Counting sort estable por dígito (LSD: menos a más significativo) | $O(d \cdot (n + b))$ donde $d$ son dígitos y $b$ la base (10) | Enteros no negativos |
| `bucket_sort(arr)` | Distribución en cubetas con secuencias auxiliares + ordenamiento interno | $O(n + k)$ promedio | Distribución uniforme de valores |
| `shell_sort(arr)` | Insertion sort generalizado con brechas decrecientes ($gap = \lfloor gap / 2 \rfloor$) | $O(n^{3/2})$ o $O(n \log^2 n)$ | Comparativo, sin memoria extra |

## 🔌 Declaración del contrato / Contract declaration

**ES:** Los cuatro algoritmos comparten **una sola firma** —`sort(secuencia) → secuencia ordenada`—, así que el módulo declara **una forma de contrato común** y cada algoritmo la cumple. Valen las dos formas: la **nativa** del lenguaje (`interface`, `trait`, `protocol`, `behaviour`, `type class`, interfaz de Ada…) o su **equivalente declarado** (cabecera con puntero a función en C, clase con métodos puros en C++, registro de funciones en un lenguaje funcional, tabla de despacho…). El README declara cuál se usa y la suite recorre las cuatro implementaciones a través de ella.

**EN:** The four algorithms share **a single signature** —`sort(sequence) → sorted sequence`— so the module declares **one common contract form** and every algorithm fulfils it. Both forms are valid: the language's **native** one (`interface`, `trait`, `protocol`, `behaviour`, `type class`, Ada's interface…) or its **declared equivalent** (a C header with a function pointer, a C++ class with pure methods, a record of functions in a functional language, a dispatch table…). The README declares which one is used and the suite walks the four implementations through it.

> **ES:** Es el **primer módulo del roadmap** donde la regla de [`AGENT_Template.md`](../../AGENT_Template.md) —un tipo de contrato aparte solo cuando hay **más de una implementación real**— se cumple: cuatro algoritmos con la misma firma. En el 06 había una implementación por estructura y por eso no se exigía.
>
> **EN:** It is the **first roadmap module** where the [`AGENT_Template.md`](../../AGENT_Template.md) rule —a separate contract type only with **more than one real implementation**— actually holds: four algorithms with the same signature. Module 06 had one implementation per structure, which is why it was not required there.

> **ES:** Las precondiciones **no se borran**: `counting_sort` exige rango acotado, `radix_sort` enteros no negativos, `bucket_sort` distribución uniforme y `shell_sort` es comparativo. Los casos compartidos son los que cumplen todas; los específicos se prueban por algoritmo.
>
> **EN:** Preconditions are **not erased**: `counting_sort` needs a bounded range, `radix_sort` non-negative integers, `bucket_sort` a uniform distribution, and `shell_sort` is comparative. Shared cases are those meeting all of them; specific ones are tested per algorithm.

### Pseudocódigo / Pseudocode

```pseudocode
container distributed_sort
    .- counting_sort(arr)
        if arr is null return -1
        if size(arr) <= 1 return arr
        max_val = max(arr)
        count = sequence(max_val + 1, 0)
        output = sequence(size(arr), 0)

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
| Todos / All | Secuencia vacía `[]` y unitaria `[5]`<br>Empty `[]` and single-element `[5]` sequence | `[]` y `[5]` |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** `counting_sort` es estable (recorre de fin a inicio al colocar elementos en la salida).  
      **EN:** `counting_sort` is stable (traverses back-to-front when placing elements in output).
- [ ] **ES:** `radix_sort` opera dígito a dígito de forma LSD (Least Significant Digit).  
      **EN:** `radix_sort` operates digit-by-digit in LSD (Least Significant Digit) fashion.
- [ ] **ES:** Entradas nulas devuelven el indicador de fallo compatible con el lenguaje/API (por ejemplo, `-1` cuando el tipo lo permite), sin excepciones.
    **EN:** Null inputs return a language/API-compatible failure indicator (for example, `-1` when the type permits it), without exceptions.
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
