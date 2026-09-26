---
layout: default
title: 10 — String Transformations
description: Representación de cadenas, unidad indexada y transformaciones manuales / String representation, indexed unit and manual transformations
nav_order: 1
parent: Procesamiento Contiguo / Contiguous Processing
grand_parent: Core
---

# 🚀 10 — String Transformations

> [← Volver a Algorithms Pure](../algorithms/09_Searching.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Comprender una cadena como secuencia indexable de unidades de texto y construir transformaciones mediante recorridos, índices y buffers explícitos. Antes de usar utilidades de biblioteca, se debe documentar si el lenguaje indexa caracteres, bytes o *code units* y cómo trata Unicode. | Understand a string as an indexable sequence of text units and build transformations through explicit traversals, indices, and buffers. Before using library utilities, document whether the language indexes characters, bytes, or code units and how it treats Unicode. |

## 📝 Especificación / Specification

**ES:** Implementar manualmente `reverse`, `trim`, `capitalize`, `to_uppercase`, `to_lowercase`, `pad_left`, `pad_right` y `remove_blank_chars`. Se permite el buffer contiguo nativo para **construir la salida**, pero no una función de biblioteca que realice la transformación objetivo.

**EN:** Implement manually `reverse`, `trim`, `capitalize`, `to_uppercase`, `to_lowercase`, `pad_left`, `pad_right` and `remove_blank_chars`. The native contiguous buffer is allowed to **build the output**, but not a library function performing the target transformation.

| Operación / Operation | Concepto reforzado / Concept reinforced | Contrato / Contract |
|-----------|-------------------|----------|
| `reverse(text)` | Extremos e índices<br>Ends and indices | Invierte las unidades de texto según la representación documentada<br>Reverses the text units per the documented representation |
| `trim(text)` | Límites de ventana<br>Window bounds | Elimina blancos iniciales y finales<br>Removes leading and trailing blanks |
| `capitalize(text)` | Clasificación y estado<br>Classification and state | Capitaliza la primera unidad alfabética conforme a la política documentada<br>Capitalises the first alphabetic unit per the documented policy |
| `to_uppercase` / `to_lowercase` | Recorrido lineal<br>Linear traversal | Define una política ASCII o Unicode explícita<br>Defines an explicit ASCII or Unicode policy |
| `pad_left` / `pad_right` | Tamaño y buffer<br>Size and buffer | Completa hasta `width`; si ya alcanza el ancho, no modifica<br>Pads up to `width`; if the width is already reached, it does not change |
| `remove_blank_chars(text)` | Filtrado<br>Filtering | Elimina los blancos definidos por la política del módulo<br>Removes the blanks defined by the module policy |

### 🧱 Unidad indexada y política de texto / Indexed unit and text policy

**ES:** Una cadena es una **secuencia indexable de unidades de texto**, y la **unidad indexada** se declara por lenguaje: **carácter** (*code point*), **byte** o *code unit*. El valor por defecto es el **carácter**; quien indexe bytes o *code units* lo declara en el README junto con el efecto que tiene en las pruebas. La política de caja es **ASCII** por defecto, y el soporte Unicode completo (plegado de caso, normalización, grafemas) **no se presume**: se declara aparte y se implementa si se anuncia.

**EN:** A string is an **indexable sequence of text units**, and the **indexed unit** is declared per language: **character** (*code point*), **byte** or *code unit*. The default is the **character**; whoever indexes bytes or code units declares it in the README together with its effect on the tests. The case policy is **ASCII** by default, and full Unicode support (case folding, normalisation, graphemes) is **not assumed**: it is declared separately and implemented if announced.

**ES:** Las entradas nulas y los parámetros inválidos lanzan la excepción idiomática acordada para la Fase 2. Una cadena vacía es válida y devuelve una cadena vacía cuando corresponda.

**EN:** Null inputs and invalid parameters throw the idiomatic exception agreed for Phase 2. An empty string is valid and returns an empty string where applicable.

### 🔀 Adaptación idiomática / Idiomatic adaptation

**ES:** La representación de la cadena es **libre** y debe ser la idiomática del lenguaje: cadena nativa, secuencia de caracteres, lista de *code units*, buffer de bytes o término. Lo que no es libre es el **contrato**: mismas operaciones, mismo resultado observable y misma unidad indexada declarada. Si el lenguaje indexa **bytes** y no caracteres, se declara y se ajustan los casos con texto no ASCII; si no expone índices sobre cadenas, se opera sobre la secuencia de unidades equivalente y se declara. Cada desviación va en la tabla de *Adaptaciones idiomáticas* del README, según [`AGENT_Template.md`](../../AGENT_Template.md).

**EN:** The string's representation is **free** and must be the language's idiomatic one: native string, character sequence, list of code units, byte buffer or term. What is not free is the **contract**: same operations, same observable result and the same declared indexed unit. If the language indexes **bytes** and not characters, it is declared and the non-ASCII cases are adjusted; if it exposes no indices over strings, the equivalent unit sequence is used and declared. Every deviation goes in the README's *Idiomatic adaptations* table, per [`AGENT_Template.md`](../../AGENT_Template.md).

## 🧪 Casos de prueba / Test Cases

**ES:** Probar vacío, un carácter, texto con blancos en extremos e internos, ancho menor, igual y mayor que la longitud, y texto no ASCII cuando la representación lo soporte. Cada prueba declara la **política** elegida; no se admite afirmar soporte de grafemas sin implementarlo.

**EN:** Test empty, a single character, text with leading, trailing and inner blanks, a width smaller than, equal to and greater than the length, and non-ASCII text when the representation supports it. Every test declares the chosen **policy**; claiming grapheme support without implementing it is not allowed.

| Caso / Case | Entrada / Input | Qué comprueba / What it checks |
|---|---|---|
| Buffer de salida / Output buffer | `reverse("abc")` construida en un buffer nuevo<br>`reverse("abc")` built in a new buffer | El buffer contiene `cba` y la **entrada no cambia**<br>The buffer holds `cba` and the **input is unchanged** |
| Unidad indexada / Indexed unit | Texto con un carácter no ASCII (`"ñ"`, `"é"`) según la unidad declarada<br>Text with a non-ASCII character (`"ñ"`, `"é"`) per the declared unit | El resultado se explica por la unidad declarada: un carácter, o N bytes<br>The result is explained by the declared unit: one character, or N bytes |
| Entrada nula / Null input | `null` | Excepción idiomática de Fase 2<br>Phase 2 idiomatic exception |
| Ancho inválido / Invalid width | `pad_left("abc", -1)` | Excepción idiomática de Fase 2<br>Phase 2 idiomatic exception |

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** La documentación de cada lenguaje declara la unidad indexada y la política Unicode/ASCII.
      **EN:** Each language's documentation declares the indexed unit and the Unicode/ASCII policy.
- [ ] **ES:** Las transformaciones objetivo no llaman a su equivalente de biblioteca.
      **EN:** The target transformations do not call their library equivalent.
- [ ] **ES:** Se prueban las excepciones para entrada o ancho inválido, y los resultados para entradas válidas.
      **EN:** Exceptions are tested for invalid input or width, and results for valid inputs.
- [ ] **ES:** Se prueba una construcción con **buffer de salida** explícito y que la entrada no se muta.
      **EN:** A build with an explicit **output buffer** is tested, and the input is not mutated.
- [ ] **ES:** Cada desviación de representación está declarada en la tabla de *Adaptaciones idiomáticas* del README.
      **EN:** Every representation deviation is declared in the README's *Idiomatic adaptations* table.
- [ ] **ES:** Código fuente y pruebas permanecen separados en `src/` y `test/`.
      **EN:** Source code and tests remain separated in `src/` and `test/`.

## 📂 Ubicación esperada / Expected Location

```text
{language}/core/text/transformations/
├── src/transformations.ext
└── test/transformations_test.ext
```

## ▶️ Siguiente / Next

👉 Sigue con [`11_Patterns.md`](11_Patterns.md).  
👉 Continue with [`11_Patterns.md`](11_Patterns.md).
