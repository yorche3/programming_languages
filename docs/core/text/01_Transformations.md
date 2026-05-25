---
layout: default
title: 01 — Transformations
description: Primera especificación de Texto / First Text specification — Transformaciones de cadenas (reverse, remove_blank_chars, etc.) con manejo de excepciones
nav_order: 1
parent: Texto / Text
grand_parent: Core
---

# 🚀 01 — Transformations

> [← Volver al ROADMAP](../../ROADMAP.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar un módulo `transformations` con funciones de transformación de cadenas de texto (invertir cadena, eliminar espacios en blanco, convertir a mayúsculas/minúsculas, etc.) utilizando **excepciones** para manejar errores (entradas inválidas, nulas, etc.), y validar su correctitud mediante pruebas unitarias exhaustivas. | Implement a `transformations` module with string transformation functions (reverse string, remove blank characters, convert to uppercase/lowercase, etc.) using **exceptions** to handle errors (invalid inputs, nulls, etc.), and validate their correctness through exhaustive unit tests. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
|---------|---------|
| Crear un proyecto dentro de un directorio `transformations` con un módulo del mismo nombre (`transformations.ext`) que contenga las funciones de transformación de cadenas listadas. Cada función debe recibir una cadena de texto y devolver la cadena transformada. Los algoritmos deben usar **excepciones** para indicar errores: si la entrada es inválida (`None`/`null`, tipo incorrecto, etc.), deben lanzar una excepción del tipo apropiado (`IllegalArgumentException`, `ValueError`, `TypeError`, etc., según el lenguaje). Incluir un conjunto de pruebas unitarias que verifiquen el correcto funcionamiento de todas las funciones con los casos de prueba especificados. | Create a project inside a `transformations` directory with a module of the same name (`transformations.ext`) containing the listed string transformation functions. Each function must receive a string and return the transformed string. Algorithms must use **exceptions** to indicate errors: if the input is invalid (`None`/`null`, wrong type, etc.), they must throw an exception of the appropriate type (`IllegalArgumentException`, `ValueError`, `TypeError`, etc., depending on the language). Include a set of unit tests that verify the correct behavior of all functions with the specified test cases. |

### Funciones / Functions

| # | Función | Descripción | Ejemplo (`"  Hello World!  "`) |
|---|---------|-------------|-------------------------------|
| 1 | `reverse(str)` | Invierte la cadena completamente | `"  !dlroW olleH  "` |
| 2 | `remove_blank_chars(str)` | Elimina todos los caracteres de espacio en blanco (espacios, tabs, saltos de línea) | `"HelloWorld!"` |
| 3 | `to_uppercase(str)` | Convierte todos los caracteres a mayúsculas | `"  HELLO WORLD!  "` |
| 4 | `to_lowercase(str)` | Convierte todos los caracteres a minúsculas | `"  hello world!  "` |
| 5 | `capitalize(str)` | Convierte el primer carácter a mayúscula y el resto a minúscula | `"  hello world!  "` (no modifica espacios iniciales) |
| 6 | `trim(str)` | Elimina espacios en blanco al inicio y final | `"Hello World!"` |
| 7 | `trim_start(str)` | Elimina espacios en blanco solo al inicio | `"Hello World!  "` |
| 8 | `trim_end(str)` | Elimina espacios en blanco solo al final | `"  Hello World!"` |
| 9 | `pad_left(str, total_width, pad_char)` | Rellena la cadena por la izquierda hasta alcanzar `total_width` usando `pad_char` | `pad_left("42", 5, '0')` → `"00042"` |
| 10 | `pad_right(str, total_width, pad_char)` | Rellena la cadena por la derecha hasta alcanzar `total_width` usando `pad_char` | `pad_right("42", 5, '0')` → `"42000"` |

> **ES:** La mayoría de lenguajes ya incluyen muchas de estas funciones en su biblioteca estándar. **El objetivo de este módulo es implementarlas manualmente** sin usar las funciones incorporadas del lenguaje (por ejemplo, no usar `str.reverse()` en Python, no usar `StringBuilder.reverse()` en Java, etc.), para comprender su funcionamiento interno. Se permite usar funciones básicas de acceso a caracteres (`str[i]`, `charAt(i)`, etc.) y constructores de cadenas.
>
> **EN:** Most languages already include many of these functions in their standard library. **The goal of this module is to implement them manually** without using the language's built-in functions (e.g., don't use `str.reverse()` in Python, don't use `StringBuilder.reverse()` in Java, etc.), to understand their inner workings. Basic character access functions (`str[i]`, `charAt(i)`, etc.) and string builders are allowed.

### Entrada / Input

Cada función recibe una cadena de texto (`string`) y, en algunos casos, parámetros adicionales (como `total_width` y `pad_char` para padding).

*Each function receives a string and, in some cases, additional parameters (like `total_width` and `pad_char` for padding).*

### Salida esperada / Expected Output

| Función | Entrada | Salida esperada |
|---------|---------|----------------|
| `reverse` | `"Hello"` | `"olleH"` |
| `reverse` | `""` | `""` |
| `remove_blank_chars` | `"  H e l l o  "` | `"Hello"` |
| `to_uppercase` | `"Hello"` | `"HELLO"` |
| `to_lowercase` | `"Hello"` | `"hello"` |
| `capitalize` | `"hello"` | `"Hello"` |
| `trim` | `"  Hello  "` | `"Hello"` |
| `pad_left` | `("42", 5, '0')` | `"00042"` |
| `pad_right` | `("42", 5, '0')` | `"42000"` |

Para entradas inválidas (`None`/`null`), todas las funciones deben **lanzar una excepción**.

```
Tests run: 25, Passed: 25, Failed: 0
```

> **ES:** La salida exacta depende del framework/biblioteca de pruebas del lenguaje, pero **todas las pruebas deben pasar** (failed = 0).  
> **EN:** The exact output depends on the language's test framework/library, but **all tests must pass** (failed = 0).

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan las 10 funciones de transformación (`reverse`, `remove_blank_chars`, `to_uppercase`, `to_lowercase`, `capitalize`, `trim`, `trim_start`, `trim_end`, `pad_left`, `pad_right`).  
      **EN:** All 10 transformation functions are implemented (`reverse`, `remove_blank_chars`, `to_uppercase`, `to_lowercase`, `capitalize`, `trim`, `trim_start`, `trim_end`, `pad_left`, `pad_right`).
- [ ] **ES:** Cada función maneja entradas inválidas (`None`/`null`) lanzando **excepciones** (no valores centinela).  
      **EN:** Each function handles invalid inputs (`None`/`null`) by throwing **exceptions** (not sentinel values).
- [ ] **ES:** Las funciones se implementan **manualmente** sin usar las funciones incorporadas del lenguaje (p. ej., no usar `str.reverse()`, `str.upper()`, `str.strip()`, etc.).  
      **EN:** Functions are implemented **manually** without using the language's built-in functions (e.g., don't use `str.reverse()`, `str.upper()`, `str.strip()`, etc.).
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).
- [ ] **ES:** Usa únicamente la biblioteca estándar del lenguaje (sin dependencias externas).  
      **EN:** Uses only the language's standard library (no external dependencies).
- [ ] **ES:** Las funciones de padding (`pad_left`, `pad_right`) lanzan excepción si `total_width` es negativo o `pad_char` no es un carácter válido.  
      **EN:** Padding functions (`pad_left`, `pad_right`) throw an exception if `total_width` is negative or `pad_char` is not a valid character.

---

## 💡 Ejemplo / Example

### Pseudocódigo / Pseudocode

A continuación se muestra el pseudocódigo para cada función. Todas asumen una cadena `str` y lanzan excepción si la entrada es inválida.

*Below is the pseudocode for each function. All assume a string `str` and throw an exception if the input is invalid.*

#### 1. Reverse

```pseudocode
function reverse(str)
    if str is None
        throw Exception("Input cannot be None")
    result = ""
    for i = length(str) - 1 down to 0
        result = result + str[i]
    return result
```

#### 2. Remove Blank Chars

```pseudocode
function remove_blank_chars(str)
    if str is None
        throw Exception("Input cannot be None")
    result = ""
    for i = 0 to length(str) - 1
        if not is_blank(str[i])
            result = result + str[i]
    return result

function is_blank(ch)
    return ch == ' ' or ch == '\t' or ch == '\n' or ch == '\r'
```

#### 3. To Uppercase

```pseudocode
function to_uppercase(str)
    if str is None
        throw Exception("Input cannot be None")
    result = ""
    for i = 0 to length(str) - 1
        if 'a' <= str[i] and str[i] <= 'z'
            result = result + char(ord(str[i]) - 32)
        else
            result = result + str[i]
    return result
```

> **ES:** La implementación ASCII básica es suficiente. Para soporte Unicode completo se puede extender usando las tablas Unicode del lenguaje.
> **EN:** Basic ASCII implementation is sufficient. Full Unicode support can be extended using the language's Unicode tables.

#### 4. To Lowercase

```pseudocode
function to_lowercase(str)
    if str is None
        throw Exception("Input cannot be None")
    result = ""
    for i = 0 to length(str) - 1
        if 'A' <= str[i] and str[i] <= 'Z'
            result = result + char(ord(str[i]) + 32)
        else
            result = result + str[i]
    return result
```

#### 5. Capitalize

```pseudocode
function capitalize(str)
    if str is None
        throw Exception("Input cannot be None")
    if length(str) == 0
        return ""
    result = ""
    // Find first non-blank character
    first_letter_idx = -1
    for i = 0 to length(str) - 1
        if not is_blank(str[i])
            first_letter_idx = i
            break
    
    if first_letter_idx == -1
        return str  // All blank
    
    for i = 0 to length(str) - 1
        if i == first_letter_idx
            // Uppercase first letter
            if 'a' <= str[i] and str[i] <= 'z'
                result = result + char(ord(str[i]) - 32)
            else
                result = result + str[i]
        else
            // Lowercase rest
            if 'A' <= str[i] and str[i] <= 'Z'
                result = result + char(ord(str[i]) + 32)
            else
                result = result + str[i]
    return result
```

#### 6. Trim

```pseudocode
function trim(str)
    if str is None
        throw Exception("Input cannot be None")
    start = 0
    end = length(str) - 1
    
    while start <= end and is_blank(str[start])
        start = start + 1
    while end >= start and is_blank(str[end])
        end = end - 1
    
    if start > end
        return ""
    return str[start:end+1]
```

#### 7. Trim Start

```pseudocode
function trim_start(str)
    if str is None
        throw Exception("Input cannot be None")
    start = 0
    while start < length(str) and is_blank(str[start])
        start = start + 1
    if start >= length(str)
        return ""
    return str[start:length(str)]
```

#### 8. Trim End

```pseudocode
function trim_end(str)
    if str is None
        throw Exception("Input cannot be None")
    end = length(str) - 1
    while end >= 0 and is_blank(str[end])
        end = end - 1
    if end < 0
        return ""
    return str[0:end+1]
```

#### 9. Pad Left

```pseudocode
function pad_left(str, total_width, pad_char)
    if str is None
        throw Exception("Input cannot be None")
    if total_width < 0
        throw Exception("total_width cannot be negative")
    if length(pad_char) != 1
        throw Exception("pad_char must be a single character")
    
    if length(str) >= total_width
        return str
    
    padding_count = total_width - length(str)
    result = ""
    for i = 1 to padding_count
        result = result + pad_char
    result = result + str
    return result
```

#### 10. Pad Right

```pseudocode
function pad_right(str, total_width, pad_char)
    if str is None
        throw Exception("Input cannot be None")
    if total_width < 0
        throw Exception("total_width cannot be negative")
    if length(pad_char) != 1
        throw Exception("pad_char must be a single character")
    
    if length(str) >= total_width
        return str
    
    padding_count = total_width - length(str)
    result = str
    for i = 1 to padding_count
        result = result + pad_char
    return result
```

---

### Casos de prueba / Test Cases

Cada función debe ser probada con los siguientes casos:

| # | Función | Entrada | Salida esperada | Comportamiento esperado |
|---|---------|---------|----------------|------------------------|
| 1 | `reverse` | `"Hello"` | `"olleH"` | Normal |
| 2 | `reverse` | `""` | `""` | Cadena vacía |
| 3 | `reverse` | `"a"` | `"a"` | Un solo carácter |
| 4 | `reverse` | `None` | ❌ Excepción | Error |
| 5 | `remove_blank_chars` | `" H e l l o "` | `"Hello"` | Normal |
| 6 | `remove_blank_chars` | `""` | `""` | Cadena vacía |
| 7 | `remove_blank_chars` | `"   "` | `""` | Solo espacios |
| 8 | `remove_blank_chars` | `None` | ❌ Excepción | Error |
| 9 | `to_uppercase` | `"Hello"` | `"HELLO"` | Normal |
| 10 | `to_uppercase` | `"123!@#"` | `"123!@#"` | Sin cambios en no letras |
| 11 | `to_uppercase` | `None` | ❌ Excepción | Error |
| 12 | `to_lowercase` | `"Hello"` | `"hello"` | Normal |
| 13 | `to_lowercase` | `None` | ❌ Excepción | Error |
| 14 | `capitalize` | `"hello"` | `"Hello"` | Normal |
| 15 | `capitalize` | `"  hello"` | `"  Hello"` | Espacios iniciales |
| 16 | `capitalize` | `""` | `""` | Cadena vacía |
| 17 | `capitalize` | `None` | ❌ Excepción | Error |
| 18 | `trim` | `"  Hello  "` | `"Hello"` | Normal |
| 19 | `trim` | `"   "` | `""` | Solo espacios |
| 20 | `trim` | `None` | ❌ Excepción | Error |
| 21 | `trim_start` | `"  Hello  "` | `"Hello  "` | Normal |
| 22 | `trim_end` | `"  Hello  "` | `"  Hello"` | Normal |
| 23 | `pad_left` | `("42", 5, '0')` | `"00042"` | Normal |
| 24 | `pad_left` | `("42", 2, '0')` | `"42"` | Ya tiene el ancho |
| 25 | `pad_left` | `("42", -1, '0')` | ❌ Excepción | Ancho negativo |
| 26 | `pad_left` | `("42", 5, '')` | ❌ Excepción | pad_char vacío |
| 27 | `pad_right` | `("42", 5, '0')` | `"42000"` | Normal |
| 28 | `pad_right` | `("42", 2, '0')` | `"42"` | Ya tiene el ancho |
| 29 | `pad_right` | `("42", -1, '0')` | ❌ Excepción | Ancho negativo |
| 30 | `pad_right` | `None` | ❌ Excepción | Error |

---

## 🔬 Nota sobre manejo de errores / Note on Error Handling

| Español | English |
|---------|---------|
| En esta fase (Texto), **se usan excepciones** para indicar errores. A diferencia de la fase anterior (Algoritmos) donde se usaban valores centinela, aquí las funciones deben lanzar excepciones ante entradas inválidas. Esto permite diferenciar claramente entre las dos estrategias de manejo de errores y entender cuándo es apropiado usar cada una. | In this phase (Text), **exceptions are used** to indicate errors. Unlike the previous phase (Algorithms) where sentinel values were used, here functions must throw exceptions for invalid inputs. This allows clearly differentiating between the two error handling strategies and understanding when each is appropriate. |

| Lenguaje / Language | Tipo de excepción / Exception type |
|---------------------|-----------------------------------|
| Python | `ValueError` o `TypeError` |
| Java | `IllegalArgumentException` |
| Go | `errors.New("...")` o `fmt.Errorf(...)` |
| Rust | `panic!()` o `Result::Err` |
| JavaScript | `new Error("...")` o `TypeError` |
| C# | `ArgumentException` |
| C++ | `std::invalid_argument` |

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── text/
            └── transformations/
                ├── src/
                │   └── transformations.ext         # Único archivo: 10 funciones
                └── test/
                    ├── transformations_test.ext    # Suite de pruebas unitarias
                    └── run_tests.ext               # Punto de entrada (opcional)
```

> **ES:** El archivo `transformations.ext` contiene las 10 funciones. `transformations_test.ext` contiene las pruebas unitarias. Los nombres siguen la convención del lenguaje (`Transformations.java`, `transformations.py`, `transformations.go`, etc.).
>
> **EN:** The `transformations.ext` file contains all 10 functions. `transformations_test.ext` contains the unit tests. Names follow the language's convention (`Transformations.java`, `transformations.py`, `transformations.go`, etc.).

---

## ▶️ Siguiente / Next

👉 Sigue con [`02_Patterns.md`](02_Patterns.md) — Algoritmos de búsqueda de patrones en cadenas (palindrome, anagram, substring, KMP, etc.).  
👉 Continue with [`02_Patterns.md`](02_Patterns.md) — String pattern matching algorithms (palindrome, anagram, substring, KMP, etc.).

---

*[← Volver al ROADMAP](../../ROADMAP.md) | [↑ Inicio](../../index.md)*
