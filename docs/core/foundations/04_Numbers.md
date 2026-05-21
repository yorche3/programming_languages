---
layout: default
title: 04 — Numbers
description: Cuarta especificación / Fourth specification — Algoritmos numéricos (Fibonacci, factorial, suma) en 3 enfoques
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
| Explorar la optimización de código implementando algoritmos numéricos clásicos (Fibonacci, factorial, suma de primeros n números) en tres enfoques progresivos: recursión directa, recursión con acumulador (tail-call) e iterativo, comprendiendo las ventajas de cada uno en términos de legibilidad, eficiencia y uso de memoria. | Explore code optimization by implementing classic numerical algorithms (Fibonacci, factorial, sum of first n numbers) in three progressive approaches: direct recursion, accumulator recursion (tail-call), and iterative, understanding the advantages of each in terms of readability, efficiency, and memory usage. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `numbers` con tres módulos (`recursive`, `recursive_with_accumulator`, `iterative`) que implementen los algoritmos de Fibonacci, factorial y suma de los primeros n números, cada una con un enfoque diferente. Incluir una suite de pruebas unitarias que verifique todas las implementaciones con los casos de prueba especificados. | Create a `numbers` project with three modules (`recursive`, `recursive_with_accumulator`, `iterative`) that implement the Fibonacci, factorial, and sum of the first n numbers algorithms, each with a different approach. Include a unit test suite that verifies all implementations with the specified test cases. |

### Progresión de optimización

| Módulo | Enfoque | Características |
|--------|---------|-----------------|
| `recursive` | Recursión directa (definición matemática) | ❌ Múltiples llamadas recursivas, alto uso de pila, código más legible y cercano a la definición matemática |
| `recursive_with_accumulator` | Recursión con acumulador (tail-call style) | ✅ Una sola llamada recursiva por paso, prepara el terreno para la versión iterativa, menor uso de pila (si el lenguaje optimiza tail-call) |
| `iterative` | Iterativo (bucles) | ✅✅ Sin llamadas recursivas, memoria constante O(1), máxima eficiencia en tiempo y espacio |

### Entrada / Input

Ninguna (no requiere entrada del usuario; las pruebas definen sus propios valores).
*None (no user input required; tests define their own values).*

### Salida esperada / Expected Output

```
tests runned 9
passed 9
failed 0
```

> **ES:** La salida exacta depende del framework/biblioteca de pruebas del lenguaje, pero **todas las pruebas deben pasar** (failed = 0).  
> **EN:** The exact output depends on the language's test framework/library, but **all tests must pass** (failed = 0).

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los tres algoritmos (Fibonacci, factorial, suma) en los tres enfoques.  
      **EN:** All three algorithms (Fibonacci, factorial, sum) are implemented in all three approaches.
- [ ] **ES:** `recursive` usa recursión directa (similar a la definición matemática).  
      **EN:** `recursive` uses direct recursion (similar to the mathematical definition).
- [ ] **ES:** `recursive_with_accumulator` usa recursión con acumulador (tail-call style).  
      **EN:** `recursive_with_accumulator` uses accumulator-based recursion (tail-call style).
- [ ] **ES:** `iterative` usa bucles (sin recursión), logrando memoria constante O(1).  
      **EN:** `iterative` uses loops (no recursion), achieving constant O(1) memory.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).
- [ ] **ES:** Usa únicamente la biblioteca estándar del lenguaje (sin dependencias externas).  
      **EN:** Uses only the language's standard library (no external dependencies).

---

## 💡 Ejemplo / Example

### Pseudocódigo / Pseudocode — recursive

```pseudocode
container recursive
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

### Pseudocódigo / Pseudocode — recursive_with_accumulator

```pseudocode
container recursive_with_accumulator
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

### Pseudocódigo / Pseudocode — iterative

```pseudocode
container iterative
    .- fibonacci(n)
        if n <= 1
            return n
        acc2 = 0
        acc1 = 1
        for i = 2 to n
            temp = acc1 + acc2
            acc2 = acc1
            acc1 = temp
        return acc1

    .- factorial(n)
        result = 1
        for i = 2 to n
            result = result * i
        return result

    .- sum_of_first_n(n)
        result = 0
        for i = 1 to n
            result = result + i
        return result
end container
```

### Casos de prueba / Test Cases

Las pruebas unitarias deben verificar los siguientes casos para cada módulo y algoritmo:

| Módulo | Algoritmo | Entrada | Salida esperada |
|--------|-----------|---------|----------------|
| `recursive` | `fibonacci(n)` | 0 | 0 |
| `recursive` | `fibonacci(n)` | 1 | 1 |
| `recursive` | `fibonacci(n)` | 6 | 8 |
| `recursive` | `factorial(n)` | 0 | 1 |
| `recursive` | `factorial(n)` | 4 | 24 |
| `recursive` | `sum_of_first_n(n)` | 0 | 0 |
| `recursive` | `sum_of_first_n(n)` | 3 | 6 |
| `recursive_with_accumulator` | `fibonacci(n)` | 0 | 0 |
| `recursive_with_accumulator` | `fibonacci(n)` | 1 | 1 |
| `recursive_with_accumulator` | `fibonacci(n)` | 6 | 8 |
| `recursive_with_accumulator` | `factorial(n)` | 0 | 1 |
| `recursive_with_accumulator` | `factorial(n)` | 4 | 24 |
| `recursive_with_accumulator` | `sum_numbers(n)` | 0 | 0 |
| `recursive_with_accumulator` | `sum_numbers(n)` | 3 | 6 |
| `iterative` | `fibonacci(n)` | 0 | 0 |
| `iterative` | `fibonacci(n)` | 1 | 1 |
| `iterative` | `fibonacci(n)` | 6 | 8 |
| `iterative` | `factorial(n)` | 0 | 1 |
| `iterative` | `factorial(n)` | 4 | 24 |
| `iterative` | `sum_of_first_n(n)` | 0 | 0 |
| `iterative` | `sum_of_first_n(n)` | 3 | 6 |

---

> **ES:** A partir de este módulo en adelante, **no se incluyen ejemplos de código en lenguajes específicos ni suites de prueba en pseudocódigo**. Las especificaciones se definen mediante pseudocódigo de implementación, y cada implementador debe traducirlo al lenguaje de su elección siguiendo las convenciones y el framework/biblioteca de pruebas que corresponda (por ejemplo, `unittest` en Python, `JUnit` en Java, `testing` en Go, etc.).  
> **EN:** From this module onward, **no specific language code examples or pseudocode test suites are included**. Implementation specifications are defined through pseudocode, and each implementer must translate it to their language of choice following the conventions and the corresponding test framework/library (e.g., `unittest` in Python, `JUnit` in Java, `testing` in Go, etc.).

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── foundations/
            └── numbers/
                ├── src/
                │   ├── recursive.ext                  # Recursión directa / Direct recursion
                │   ├── recursive_with_accumulator.ext  # Recursión con acumulador / Accumulator recursion
                │   └── iterative.ext                  # Versión iterativa / Iterative version
                └── test/
                    ├── test_numbers.ext               # Pruebas unitarias / Unit tests
                    └── run_tests.ext                  # Script opcional para ejecutar pruebas / Optional script to run tests
```

> **ES:** Para ejecutar las pruebas, usa el comando propio del framework/biblioteca de tu lenguaje (ej: `python -m unittest discover`, `mvn test`, `go test ./...`, etc.).  
> **EN:** To run the tests, use the command provided by your language's test framework/library (e.g., `python -m unittest discover`, `mvn test`, `go test ./...`, etc.).

---

## ▶️ Siguiente / Next

👉 El siguiente paso depende de tu ruta de aprendizaje — Continúa con los siguientes módulos de **Core** o explora otras secciones.  
👉 The next step depends on your learning path — Continue with the next **Core** modules or explore other sections.

---

*[← Volver a 03_Unit_Test_Demo](03_Unit_Test_Demo.md) | [↑ Inicio](../../index.md)*