---
layout: default
title: 03 — Unit Testing
description: Tercera especificación / Third specification — Pruebas unitarias con operaciones aritméticas básicas
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
| Implementar un módulo `calculator` con operaciones aritméticas básicas (`addition`, `subtraction`, `multiply`, `division`) utilizando implementaciones intuitivas y educativas, y validar su correctitud mediante pruebas unitarias, creando una estructura base tipo biblioteca para futuros desarrollos. | Implement a `calculator` module with basic arithmetic operations (`addition`, `subtraction`, `multiply`, `division`) using intuitive and educational implementations, and validate their correctness through unit tests, creating a base library-style structure for future development. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto dentro de un directorio `unit_test` con un módulo `calculator` (clase/namespace) que contenga los métodos `addition(a, b)`, `subtraction(a, b)`, `multiply(a, b)` y `division(a, b)` con implementaciones intuitivas/educativas, junto con un conjunto de pruebas unitarias que verifiquen su correcto funcionamiento. | Create a project inside a `unit_test` directory with a `calculator` module (class/namespace) containing `addition(a, b)`, `subtraction(a, b)`, `multiply(a, b)` and `division(a, b)` methods with intuitive/educational implementations, along with a set of unit tests that verify their correct behavior. |

#### Implementaciones esperadas

| Operación | Implementación educativa |
|-----------|-------------------------|
| `addition(a, b)` | Suma directa (`a + b`) — operación básica |
| `subtraction(a, b)` | Resta directa (`a - b`) — operación básica |
| `multiply(a, b)` | Suma repetitiva: sumar `a` consigo mismo `b` veces |
| `division(a, b)` | Resta repetitiva: contar cuántas veces cabe `b` en `a` |

> **ES:** Estas implementaciones educativas sientan las bases para entender cómo se construyen operaciones complejas a partir de operaciones simples, concepto que se explorará a fondo en el siguiente módulo (`04_Numbers.md`).  
> **EN:** These educational implementations lay the groundwork for understanding how complex operations are built from simple ones, a concept that will be explored in depth in the next module (`04_Numbers.md`).

### Entrada / Input

Ninguna (no requiere entrada del usuario; las pruebas definen sus propios valores).
*None (no user input required; tests define their own values).*

### Salida esperada / Expected Output

```
Tests run: 4, Passed: 4, Failed: 0
```

> **ES:** La salida exacta depende del framework/biblioteca de pruebas del lenguaje (como `unittest` en Python, `JUnit` en Java, etc.), pero todas las pruebas deben pasar.  
> **EN:** The exact output depends on the language's test framework/library (like `unittest` in Python, `JUnit` in Java, etc.), but all tests must pass.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Las pruebas unitarias se ejecutan sin errores y verifican las 4 operaciones (`addition`, `subtraction`, `multiply`, `division`).  
      **EN:** Unit tests run without errors and verify all 4 operations (`addition`, `subtraction`, `multiply`, `division`).
- [ ] **ES:** `multiply` se implementa como suma repetitiva (no usa el operador `*`).  
      **EN:** `multiply` is implemented as repeated addition (does not use the `*` operator).
- [ ] **ES:** `division` se implementa como resta repetitiva (no usa el operador `/`).  
      **EN:** `division` is implemented as repeated subtraction (does not use the `/` operator).
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

    .- multiply(a, b)
        result = 0
        for i = 1 to b
            result = addition(result, a)
        return result

    .- division(a, b)
        // Division by zero is not implemented in this example
        while a >= b
            a = subtraction(a, b)
            count = count + 1
        return count
end container
```

```pseudocode
suite calculator_test extends TestBase
    .- test_addition
        assert addition(2, 3) == 5

    .- test_subtraction
        assert subtraction(5, 2) == 3

    .- test_multiply
        assert multiply(3, 4) == 12

    .- test_division
        assert division(10, 3) == 3
end suite
```

```pseudocode
runner run_tests
    execute calculator_test
    show report
end runner
```

> **ES:** `calculator_test` agrupa todas las pruebas del módulo `calculator`. La cláusula `extends TestBase` indica que la suite se adapta o hereda de la biblioteca/framework de pruebas del lenguaje (ej: `unittest.TestCase` en Python, `junit.framework.TestCase` en Java). Cada función/método `test_*` puede tener una o más aserciones. `run_tests` es el punto de entrada que ejecuta todas las suites y muestra el resumen (se crea solo en caso de que el lenguaje no lo incluya).  
> **EN:** `calculator_test` groups all tests for the `calculator` module. The `extends TestBase` clause indicates that the suite adapts or inherits from the language's testing library/framework (e.g., `unittest.TestCase` in Python, `junit.framework.TestCase` in Java). Each `test_*` function/method can have one or more assertions. `run_tests` is the entry point that executes all suites and shows the summary (created only if the language doesn't include it).

### Python

```python
# src/calculator.py
class Calculator:
    @staticmethod
    def addition(a, b):
        return a + b

    @staticmethod
    def subtraction(a, b):
        return a - b

    @staticmethod
    def multiply(a, b):
        result = 0
        for _ in range(b):
            result = Calculator.addition(result, a)
        return result

    @staticmethod
    def division(a, b):
        if b == 0:
            raise ValueError("Division by zero")
        count = 0
        while a >= b:
            a = Calculator.subtraction(a, b)
            count += 1
        return count
```

```python
# test/test_calculator.py
import unittest
from src.calculator import Calculator

class TestCalculator(unittest.TestCase):
    def test_addition(self):
        self.assertEqual(Calculator.addition(2, 3), 5)

    def test_subtraction(self):
        self.assertEqual(Calculator.subtraction(5, 2), 3)

    def test_multiply(self):
        self.assertEqual(Calculator.multiply(3, 4), 12)

    def test_division(self):
        self.assertEqual(Calculator.division(10, 3), 3)

if __name__ == "__main__":
    unittest.main()
```

### Java

```java
// src/Calculator.java
public class Calculator {
    public static int addition(int a, int b) {
        return a + b;
    }

    public static int subtraction(int a, int b) {
        return a - b;
    }

    public static int multiply(int a, int b) {
        int result = 0;
        for (int i = 0; i < b; i++) {
            result = addition(result, a);
        }
        return result;
    }

    public static int division(int a, int b) {
        int count = 0;
        while (a >= b) {
            a = subtraction(a, b);
            count++;
        }
        return count;
    }
}
```

```java
// test/CalculatorTest.java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorTest {

    @Test
    public void testAddition() {
        assertEquals(5, Calculator.addition(2, 3));
    }

    @Test
    public void testSubtraction() {
        assertEquals(3, Calculator.subtraction(5, 2));
    }

    @Test
    public void testMultiply() {
        assertEquals(12, Calculator.multiply(3, 4));
    }

    @Test
    public void testDivision() {
        assertEquals(3, Calculator.division(10, 3));
    }
}
```

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── foundations/
            └── unit_test/
                └── calculator/
                    ├── src/
                    │   └── calculator.ext          # Código fuente / Source code
                    └── test/
                        ├── calculator_test.ext     # Suite de pruebas / Test suite
                        └── run_tests.ext           # Punto de entrada / Entry point
```

> **ES:** `calculator_test.ext` es la suite que contiene todas las pruebas. `run_tests.ext` es el punto de entrada que ejecuta las suites y muestra el resumen.  
> **EN:** `calculator_test.ext` is the suite containing all tests. `run_tests.ext` is the entry point that executes suites and shows the summary.

---

## ▶️ Siguiente / Next

👉 Sigue con [`04_Numbers.md`](04_Numbers.md) — Algoritmos numéricos recursivos e iterativos (Fibonacci, factorial, suma).  
👉 Continue with [`04_Numbers.md`](04_Numbers.md) — Recursive and iterative numerical algorithms (Fibonacci, factorial, sum).

---

*[← Volver a 02_Hello_User](02_Hello_User.md) | [↑ Inicio](../../index.md)*