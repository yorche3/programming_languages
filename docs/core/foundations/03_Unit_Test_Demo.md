---
layout: default
title: 03 — Unit Testing
description: Tercera especificación / Third specification — Pruebas unitarias con algoritmos recursivos
nav_order: 3
parent: Fundamentos / Foundations
grand_parent: Core
---

# 🚀 03 — Unit Testing

> [← Volver a 02_Hello_User](02_Hello_User.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar algoritmos recursivos clásicos (similares a su definición matemática) y validar su correctitud mediante pruebas unitarias, creando una estructura base tipo librería para futuros desarrollos. | Implement classic recursive algorithms (similar to their mathematical definition) and validate their correctness through unit tests, creating a base library-style structure for future development. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto dentro de un directorio `unit_test` con los siguientes módulos: `Calculator` (clase/namespace) que contenga los métodos `addition(a, b)` y `subtracttion(a, b)`, `Recursive` (clase/namespace) que contenga los métodos `sum_of_first_n(n)`, `factorial(n)`, y `fibonacci(n)` con su implementación recursiva más intuitiva posible, `Recursive With Accumulator` (clase/namespace) que contenga los métodos `sum_of_first_n`, `factorial`, y `fibonacci` con su implementación recursiva con acumulador (tail-call optimization *No todos los lenguajes lo soportan*) y cada uno de estos módulos debe tener su correspondiente suite de pruebas unitarias que cubran todas las funcionalidades implementadas. | Create a project within a `unit_test` directory with the following modules: `Calculator` (class/namespace) that contains the `addition(a, b)` and `subtracttion(a, b)` methods, `Recursive` (class/namespace) that contains the `sum_of_first_n(n)`, `factorial(n)`, and `fibonacci(n)` methods with their direct recursive implementation, `Recursive With Accumulator` (class/namespace) that contains the `sum_of_first_n`, `factorial`, and `fibonacci` methods with their recursive implementation with accumulator (tail-call optimization *Not all languages support it*) and each of these modules should have its corresponding unit tests suite that covers all implemented functionalities. |

### Entrada / Input

Ninguna (no requiere entrada del usuario; las pruebas definen sus propios valores).
*None (no user input required; tests define their own values).*

### Salida esperada / Expected Output

```
Tests run: 2, Passed: 2, Failed: 0
```

> **ES:** La salida exacta depende del framework de pruebas del lenguaje, pero todas las pruebas deben pasar.  
> **EN:** The exact output depends on the language's test framework, but all tests must pass.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Las pruebas unitarias se ejecutan sin errores y verifican las funciones/métodos de cada clase/namespace.  
      **EN:** Unit tests run without errors and verify both operations (`add` and `subtract`).
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).
- [ ] **ES:** Usa únicamente la biblioteca estándar del lenguaje (sin dependencias externas).  
      **EN:** Uses only the language's standard library (no external dependencies).

---

## 💡 Ejemplo / Example

### Pseudocódigo / Pseudocode

```pseudocode
container calculator
    .- addition(a, b)
        return a + b
    .- subtraction(a, b)
        return a - b
end container
```

```pseudocode
container recursive
    .- sum_of_first_n(n)
        if n == 0
            return 0
        return n + sum_of_first_n(n - 1)
    .- factorial(n)
        if n == 0
            return 1
        return n * factorial(n - 1)
    .- fibonacci(n)
        if n <= 1
            return n
        return fibonacci(n - 1) + fibonacci(n - 2)
end container
```

```pseudocode
container recursive_with_accumulator
    .- sum_of_first_n(n)
        return sum_of_first_n_iter(n, 0)
    .- sum_of_first_n_iter(n, acc)
        if n <= 0
            return acc
        return sum_of_first_n_iter(n - 1, n + acc)
    .- factorial(n)
        return factorial_iter(n, 1)
    .- factorial_iter(n, acc)
        if n <= 1
            return acc
        return factorial_iter(n - 1, n * acc)
    .- fibonacci(n)
        return fibonacci_iter(n, 0, 1)
    .- fibonacci_iter(n, acc2, acc1)
        if n <= 0
            return acc2
        if n <= 2
            return acc1 + acc2
        return fibonacci_iter(n - 1, acc1, acc1 + acc2)
end container
```

```pseudocode
suite test_container_name
    .- test_function/method_name
        assert container_name.function/method_name(input) == expected_output
end suite
```

### Casos de prueba / Test Cases

Para las pruebas unitarias, se deben considerar los siguientes escenarios:

- Casos normales: Entradas válidas y salidas esperadas.

La suite de pruebas del contenedor `calculator` debe incluir pruebas para las funciones `addition` y `subtraction` con las siguientes entradas y salidas:

addition:
- Entrada: (2, 3) -> Salida: 5
subtraction:
- Entrada: (5, 2) -> Salida: 3

La suite de pruebas del contenedor `recursive` debe incluir pruebas para las funciones `sum_of_first_n`, `factorial`, y `fibonacci` con las siguientes entradas y salidas:

sum_of_first_n:
- Entrada: 3 -> Salida: 6 (1 + 2 + 3)
factorial:
- Entrada: 4 -> Salida: 24 (1 * 2 * 3 * 4)
fibonacci:
- Entrada: 6 -> Salida: 8 (0, 1, 1, 2, 3, 5)

La suite de pruebas del contenedor `recursive_with_accumulator` debe incluir pruebas para las funciones `sum_of_first_n`, `factorial`, y `fibonacci` con las siguientes entradas y salidas:

sum_of_first_n:
- Entrada: 3 -> Salida: 6 (1 + 2 + 3)
factorial:
- Entrada: 4 -> Salida: 24 (1 * 2 * 3 * 4)
fibonacci:
- Entrada: 6 -> Salida: 8 (0, 1, 1, 2, 3, 5)

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── foundations/
            └── unit_test/
                └── demo/
                    ├── src/
                    │   └── calculator.ext       # Código fuente / Source code
                    ├── test/
                    │   └── test.ext             # Pruebas unitarias / Unit tests
                    └── run_tests.ext            # Script opcional para ejecutar pruebas / Optional script to run tests
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`04_Numbers.md`](04_Numbers.md) — Algoritmos numéricos recursivos (Fibonacci, factorial, suma).  
👉 Continue with [`04_Numbers.md`](04_Numbers.md) — Recursive numerical algorithms (Fibonacci, factorial, sum).

---

*[← Volver a 02_Hello_User](02_Hello_User.md) | [↑ Inicio](../../index.md)*