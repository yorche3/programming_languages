---
layout: default
title: 04 — Numbers
description: Cuarta especificación / Fourth specification — Algoritmos numéricos recursivos (Fibonacci, factorial, suma)
nav_order: 4
parent: Fundamentos / Foundations
grand_parent: Core
---

# 🚀 04 — Numbers

> [← Volver a 03_Unit_Test_Demo](03_Unit_Test_Demo.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar algoritmos numéricos clásicos (Fibonacci, factorial, suma de primeros n números) usando dos enfoques recursivos distintos: recursión directa y recursión con acumulador (tail-recursive). | Implement classic numerical algorithms (Fibonacci, factorial, sum of first n numbers) using two distinct recursive approaches: direct recursion and accumulator-based recursion (tail-recursive). |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `numbers` con dos soluciones (`solution1` y `solution2`) que implementen los algoritmos de Fibonacci, factorial y suma de los primeros n números, cada una con un enfoque recursivo diferente. La primera solución usa recursión directa (definición matemática) y la segunda usa recursión con acumulador (tail-call style). Incluir pruebas unitarias para validar ambas implementaciones. | Create a `numbers` project with two solutions (`solution1` and `solution2`) that implement the Fibonacci, factorial, and sum of the first n numbers algorithms, each with a different recursive approach. The first solution uses direct recursion (mathematical definition) and the second uses accumulator-based recursion (tail-call style). Include unit tests to validate both implementations. |

### Entrada / Input

Ninguna (no requiere entrada del usuario; las pruebas definen sus propios valores).
*None (no user input required; tests define their own values).*

### Salida esperada / Expected Output

```
Tests run: 6, Passed: 6, Failed: 0
```

> **ES:** La salida exacta depende del framework de pruebas del lenguaje, pero todas las pruebas deben pasar verificando ambas soluciones.  
> **EN:** The exact output depends on the language's test framework, but all tests must pass verifying both solutions.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los tres algoritmos (Fibonacci, factorial, suma) en ambos enfoques recursivos.  
      **EN:** All three algorithms (Fibonacci, factorial, sum) are implemented in both recursive approaches.
- [ ] **ES:** `solution1` usa recursión directa (similar a la definición matemática).  
      **EN:** `solution1` uses direct recursion (similar to the mathematical definition).
- [ ] **ES:** `solution2` usa recursión con acumulador (tail-call style) para mejorar eficiencia.  
      **EN:** `solution2` uses accumulator-based recursion (tail-call style) for improved efficiency.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).
- [ ] **ES:** Usa únicamente la biblioteca estándar del lenguaje (sin dependencias externas).  
      **EN:** Uses only the language's standard library (no external dependencies).

---

## 💡 Ejemplo / Example

### Pseudocódigo / Pseudocode — Solution 1 (Direct Recursion)

```pseudocode
container solution1
    .- fibonacci(n)
        if n <= 1
            return n
        return fibonacci(n - 1) + fibonacci(n - 2)

    .- factorial(n)
        if n == 0
            return 1
        return n * factorial(n - 1)

    .- sum_of_first_n(n)
        if n == 0
            return 0
        return n + sum_of_first_n(n - 1)
end container
```

### Pseudocódigo / Pseudocode — Solution 2 (Accumulator Recursion)

```pseudocode
container solution2
    .- fibonacci(n)
        return fibonacci_iter(n, 0, 1)

    .- fibonacci_iter(n, acc2, acc1)
        if n <= 0
            return acc2
        if n <= 2
            return acc1 + acc2
        return fibonacci_iter(n - 1, acc1, acc1 + acc2)

    .- factorial(n)
        return factorial_iter(n, 1)

    .- factorial_iter(n, acc)
        if n <= 1
            return acc
        return factorial_iter(n - 1, n * acc)

    .- sum_numbers(n)
        return sum_numbers_iter(n, 0)

    .- sum_numbers_iter(n, acc)
        if n <= 0
            return acc
        return sum_numbers_iter(n - 1, n + acc)
end container
```

### Python

```python
# src/solution1.py
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

def factorial(n):
    if n == 0:
        return 1
    return n * factorial(n - 1)

def sum_of_first_n(n):
    if n == 0:
        return 0
    return n + sum_of_first_n(n - 1)
```

```python
# src/solution2.py
def fibonacci(n):
    def fibonacci_iter(n, acc2, acc1):
        if n <= 0:
            return acc2
        if n <= 2:
            return acc1 + acc2
        return fibonacci_iter(n - 1, acc1, acc1 + acc2)
    return fibonacci_iter(n, 0, 1)

def factorial(n):
    def factorial_iter(n, acc):
        if n <= 1:
            return acc
        return factorial_iter(n - 1, n * acc)
    return factorial_iter(n, 1)

def sum_numbers(n):
    def sum_numbers_iter(n, acc):
        if n <= 0:
            return acc
        return sum_numbers_iter(n - 1, n + acc)
    return sum_numbers_iter(n, 0)
```

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── foundations/
            └── numbers/
                ├── src/
                │   ├── solution1.ext    # Recursión directa / Direct recursion
                │   └── solution2.ext    # Recursión con acumulador / Accumulator recursion
                ├── test/
                │   └── test.ext          # Pruebas unitarias / Unit tests
                └── run_tests.ext         # Script opcional para ejecutar pruebas / Optional script to run tests
```

---

## ▶️ Siguiente / Next

👉 El siguiente paso depende de tu ruta de aprendizaje — Continúa con los siguientes módulos de **Core** o explora otras secciones.  
👉 The next step depends on your learning path — Continue with the next **Core** modules or explore other sections.

---

*[← Volver a 03_Unit_Test_Demo](03_Unit_Test_Demo.md) | [↑ Inicio](../../index.md)*