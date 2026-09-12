---
layout: default
title: 04 — Numbers
description: Cuarta especificación / Fourth specification — Algoritmos numéricos (suma, factorial, Fibonacci, MCD, MCM) en 3 enfoques
nav_order: 4
parent: Fundamentos / Foundations
grand_parent: Core
---

# 🚀 04 — Numbers

> [← Volver a 03_Unit_Test_Calculator](03_Unit_Test_Calculator.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Explorar la optimización de código implementando algoritmos numéricos clásicos (suma de primeros n números, factorial, Fibonacci, máximo común divisor, mínimo común múltiplo) en tres enfoques progresivos: recursión directa, recursión con acumulador (tail-call) e iterativo, comprendiendo las ventajas de cada uno en términos de legibilidad, eficiencia y uso de memoria. | Explore code optimization by implementing classic numerical algorithms (sum of first n numbers, factorial, Fibonacci, greatest common divisor, least common multiple) in three progressive approaches: direct recursion, accumulator recursion (tail-call), and iterative, understanding the advantages of each in terms of readability, efficiency, and memory usage. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `numbers` con un único archivo que implemente los algoritmos de suma de los primeros n números, factorial, Fibonacci, máximo común divisor y mínimo común múltiplo **en tres enfoques** (recursión directa `_rec`, recursión con acumulador `_acc` e iterativo `_ite`), más helpers privados `_help`. Incluir suites de prueba unitarias separadas por enfoque que verifiquen todas las implementaciones con los casos de prueba especificados. | Create a `numbers` project with a single file implementing the sum of first n numbers, factorial, Fibonacci, greatest common divisor, and least common multiple algorithms **in three approaches** (direct recursion `_rec`, accumulator recursion `_acc`, and iterative `_ite`), plus private `_help` helpers. Include separate unit test suites per approach that verify all implementations with the specified test cases. |

### Progresión de optimización

| Módulo | Enfoque | Características |
|--------|---------|-----------------|
| `recursive` | Recursión directa (definición matemática) | ❌ Múltiples llamadas recursivas, alto uso de pila, código más legible y cercano a la definición matemática |
| `recursive_with_accumulator` | Recursión con acumulador (tail-call style) | ✅ Una sola llamada recursiva por paso, prepara el terreno para la versión iterativa, menor uso de pila (si el lenguaje implementa tail-call optimization) |
| `iterative` | Iterativo (bucles) | ✅✅ Sin llamadas recursivas, memoria constante, máxima eficiencia en tiempo y espacio |

### Entrada / Input

Ninguna (no requiere entrada del usuario; las pruebas definen sus propios valores).
*None (no user input required; tests define their own values).*

### Salida esperada / Expected Output

```
tests runned 33
passed 33
failed 0
```

> **ES:** La salida exacta depende del framework/biblioteca de pruebas del lenguaje, pero **todas las pruebas deben pasar** (failed = 0). La cantidad de pruebas (y qué suites se implementan) depende de las capacidades del lenguaje, no de una lista fija:
>
> - **`recursive`**: se implementa y prueba siempre (11 casos). Todo lenguaje soporta al menos recursión directa.
> - **`recursive_with_accumulator`**: se prueba (11 casos) **solo si el lenguaje ofrece TCO real/garantizado** (auto-recursión de cola optimizada por el compilador/runtime, ej. Scheme, Erlang/Elixir, Clojure `recur`, Scala `@tailrec`, F#, GHC en la práctica). Si el lenguaje **no** garantiza TCO, `_acc` puede conservarse en el código fuente como puente didáctico hacia `_ite`, pero **no se le escriben pruebas unitarias propias** — no aporta ninguna ventaja medible frente a `_rec` sin TCO.
> - **`iterative`**: se prueba (11 casos) **solo si el lenguaje ofrece construcciones iterativas nativas** (bucles `for`/`while`, o combinadores equivalentes tipo `loop`/`fold`/`reduce` usados de forma explícitamente iterativa). Algunos lenguajes puramente funcionales no exponen iteración imperativa y expresan todo mediante recursión/TCO; en ese caso se omite esta suite.
>
> Combina ambos criterios de forma independiente para tu lenguaje. Ejemplos de combinaciones válidas:
> - TCO ✅ + iteración ✅ → `_rec` + `_acc` + `_ite` = 33 pruebas.
> - TCO ✅ + sin iteración nativa → `_rec` + `_acc` = 22 pruebas.
> - Sin TCO + iteración ✅ → `_rec` + `_ite` = 22 pruebas.
> - Sin TCO + sin iteración nativa → `_rec` = 11 pruebas (caso raro).
>
> Documenta en el README de tu implementación cuál combinación aplica y por qué, en vez de asumir el conteo de 33 por defecto.
>
> **EN:** The exact output depends on the language's test framework/library, but **all tests must pass** (failed = 0). The number of tests (and which suites are implemented) depends on the language's capabilities, not a fixed list:
>
> - **`recursive`**: always implemented and tested (11 cases). Every language supports at least direct recursion.
> - **`recursive_with_accumulator`**: tested (11 cases) **only if the language provides real/guaranteed TCO** (compiler/runtime-optimized self-tail-calls, e.g. Scheme, Erlang/Elixir, Clojure `recur`, Scala `@tailrec`, F#, GHC in practice). If the language does **not** guarantee TCO, `_acc` may still be kept in source code as an educational bridge toward `_ite`, but **no dedicated unit tests are written for it** — it provides no measurable benefit over `_rec` without TCO.
> - **`iterative`**: tested (11 cases) **only if the language offers native iterative constructs** (`for`/`while` loops, or equivalent combinators like `loop`/`fold`/`reduce` used in an explicitly iterative style). Some purely functional languages don't expose imperative iteration and express everything through recursion/TCO; in that case this suite is omitted.
>
> Combine both criteria independently for your language. Valid combination examples:
> - TCO ✅ + iteration ✅ → `_rec` + `_acc` + `_ite` = 33 tests.
> - TCO ✅ + no native iteration → `_rec` + `_acc` = 22 tests.
> - No TCO + iteration ✅ → `_rec` + `_ite` = 22 tests.
> - No TCO + no native iteration → `_rec` = 11 tests (rare case).
>
> Document in your implementation's README which combination applies and why, instead of assuming the default count of 33.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los cinco algoritmos (suma, factorial, Fibonacci, MCD, MCM) en los tres enfoques.  
      **EN:** All five algorithms (sum, factorial, Fibonacci, GCF, LCM) are implemented in all three approaches.
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

### Pseudocódigo / Pseudocode — recursive (`_rec`)

```pseudocode
container recursive
    .- sum_of_first_n_rec(n)
        if n == 0
            return 0
        return n + sum_of_first_n_rec(n - 1)

    .- factorial_rec(n)
        if n == 0
            return 1
        return n * factorial_rec(n - 1)

    .- fibonacci_rec(n)
        if n <= 1
            return n
        return fibonacci_rec(n - 1) + fibonacci_rec(n - 2)

    .- greatest_common_divisor_rec(a, b)
        if b == 0
            return a
        return greatest_common_divisor_rec(b, a % b)

    .- least_common_multiple_rec(a, b)
        return (a * b) / greatest_common_divisor_rec(a, b)
end container
```

### Pseudocódigo / Pseudocode — recursive_with_accumulator (`_acc`)

```pseudocode
container recursive_with_accumulator
    .- sum_of_first_n_acc(n)
        return sum_of_first_n_acc_help(n, 0)

    .- sum_of_first_n_acc_help(n, acc)
        if n <= 0
            return acc
        return sum_of_first_n_acc_help(n - 1, n + acc)

    .- factorial_acc(n)
        return factorial_acc_help(n, 1)

    .- factorial_acc_help(n, acc)
        if n <= 1
            return acc
        return factorial_acc_help(n - 1, n * acc)

    .- fibonacci_acc(n)
        return fibonacci_acc_help(n, 0, 1)

    .- fibonacci_acc_help(n, acc2, acc1)
        if n <= 0
            return acc2
        if n <= 2
            return acc1 + acc2
        return fibonacci_acc_help(n - 1, acc1, acc1 + acc2)

    .- greatest_common_divisor_acc(a, b)
        return greatest_common_divisor_acc_help(a, b)

    .- greatest_common_divisor_acc_help(a, b)
        if b == 0
            return a
        return greatest_common_divisor_acc_help(b, a % b)

    .- least_common_multiple_acc(a, b)
        return (a * b) / greatest_common_divisor_acc(a, b)
end container
```

### Pseudocódigo / Pseudocode — iterative (`_ite`)

```pseudocode
container iterative
    .- sum_of_first_n_ite(n)
        result = 0
        for i = 1 to n
            result = result + i
        return result

    .- factorial_ite(n)
        result = 1
        for i = 2 to n
            result = result * i
        return result

    .- fibonacci_ite(n)
        if n <= 1
            return n
        acc2 = 0
        acc1 = 1
        for i = 2 to n
            temp = acc1 + acc2
            acc2 = acc1
            acc1 = temp
        return acc1

    .- greatest_common_divisor_ite(a, b)
        temp = 0
        while b != 0
            temp = b
            b = a % b
            a = temp
        return a

    .- least_common_multiple_ite(a, b)
        return (a * b) / greatest_common_divisor_ite(a, b)
end container
```

### Casos de prueba / Test Cases

Las pruebas unitarias deben verificar los siguientes casos para cada módulo y algoritmo:

| Módulo | Algoritmo | Entrada | Salida esperada |
|--------|-----------|---------|----------------|
| `recursive` | `sum_of_first_n_rec(n)` | 0 | 0 |
| `recursive` | `sum_of_first_n_rec(n)` | 3 | 6 |
| `recursive` | `factorial_rec(n)` | 0 | 1 |
| `recursive` | `factorial_rec(n)` | 4 | 24 |
| `recursive` | `fibonacci_rec(n)` | 0 | 0 |
| `recursive` | `fibonacci_rec(n)` | 1 | 1 |
| `recursive` | `fibonacci_rec(n)` | 6 | 8 |
| `recursive` | `greatest_common_divisor_rec(a, b)` | 12, 8 | 4 |
| `recursive` | `greatest_common_divisor_rec(a, b)` | 7, 5 | 1 |
| `recursive` | `least_common_multiple_rec(a, b)` | 4, 6 | 12 |
| `recursive` | `least_common_multiple_rec(a, b)` | 6, 8 | 24 |
| `recursive_with_accumulator` | `sum_of_first_n_acc(n)` | 0 | 0 |
| `recursive_with_accumulator` | `sum_of_first_n_acc(n)` | 3 | 6 |
| `recursive_with_accumulator` | `factorial_acc(n)` | 0 | 1 |
| `recursive_with_accumulator` | `factorial_acc(n)` | 4 | 24 |
| `recursive_with_accumulator` | `fibonacci_acc(n)` | 0 | 0 |
| `recursive_with_accumulator` | `fibonacci_acc(n)` | 1 | 1 |
| `recursive_with_accumulator` | `fibonacci_acc(n)` | 6 | 8 |
| `recursive_with_accumulator` | `greatest_common_divisor_acc(a, b)` | 12, 8 | 4 |
| `recursive_with_accumulator` | `greatest_common_divisor_acc(a, b)` | 7, 5 | 1 |
| `recursive_with_accumulator` | `least_common_multiple_acc(a, b)` | 4, 6 | 12 |
| `recursive_with_accumulator` | `least_common_multiple_acc(a, b)` | 6, 8 | 24 |
| `iterative` | `sum_of_first_n_ite(n)` | 0 | 0 |
| `iterative` | `sum_of_first_n_ite(n)` | 3 | 6 |
| `iterative` | `factorial_ite(n)` | 0 | 1 |
| `iterative` | `factorial_ite(n)` | 4 | 24 |
| `iterative` | `fibonacci_ite(n)` | 0 | 0 |
| `iterative` | `fibonacci_ite(n)` | 1 | 1 |
| `iterative` | `fibonacci_ite(n)` | 6 | 8 |
| `iterative` | `greatest_common_divisor_ite(a, b)` | 12, 8 | 4 |
| `iterative` | `greatest_common_divisor_ite(a, b)` | 7, 5 | 1 |
| `iterative` | `least_common_multiple_ite(a, b)` | 4, 6 | 12 |
| `iterative` | `least_common_multiple_ite(a, b)` | 6, 8 | 24 |

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
                │   └── numbers.ext                  # Único archivo: 3 enfoques en 1
                └── test/
                    ├── recursive_tests.ext           # Tests: enfoque recursivo
                    ├── recursive_with_acc_tests.ext  # Tests: enfoque con acumulador
                    ├── iterative_tests.ext           # Tests: enfoque iterativo
                    └── run_tests.ext                 # Punto de entrada
```

> **ES:** Los nombres de las funciones siguen el patrón `algoritmo_(rec|acc|ite)` con helpers privados `algoritmo_(rec|acc|ite)_help`. Las suites de prueba están separadas por enfoque pero todas referencian el mismo `numbers.ext`. Para ejecutar las pruebas, usa el comando propio del framework/biblioteca de tu lenguaje.
> **EN:** Function names follow the pattern `algorithm_(rec|acc|ite)` with private helpers `algorithm_(rec|acc|ite)_help`. Test suites are separated by approach but all reference the same `numbers.ext`. To run the tests, use the command provided by your language's test framework/library.

---

## ▶️ Siguiente / Next

👉 Sigue con [`05_Naive_Sort.md`](../algorithms/05_Naive_Sort.md) — Algoritmos elementales de ordenamiento $O(n^2)$ (Selection, Bubble, Insertion).
👉 Continue with [`05_Naive_Sort.md`](../algorithms/05_Naive_Sort.md) — Elementary $O(n^2)$ sorting algorithms (Selection, Bubble, Insertion).

---

*[← Volver a 03_Unit_Test_Calculator](03_Unit_Test_Calculator.md) | [↑ Inicio](../../index.md)*