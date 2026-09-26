---
layout: default
title: 13 — Substring Search
description: Búsqueda de subcadenas con tablas auxiliares indexables / Substring search with indexable auxiliary tables
nav_order: 3
parent: Procesamiento Contiguo / Contiguous Processing
grand_parent: Core
---

# 🚀 13 — Substring Search

> [← Volver a 12_Patterns](12_Patterns.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Pasar de la comparación ingenua a algoritmos que preservan información en **secuencias auxiliares indexables de enteros**. El foco es la invariante de la tabla —prefijos en KMP, desplazamientos en Boyer–Moore o cajas Z— y no solo su complejidad. | Move from naïve comparison to algorithms that retain information in **indexable auxiliary sequences of integers**. The focus is the table invariant —prefixes in KMP, shifts in Boyer–Moore, or Z boxes— and not merely complexity. |

## 📝 Especificación / Specification

**ES:** Implementar `build_lps(pattern)` y `kmp_find(text, pattern)`. Implementar también `z_array(text)` y `z_find(text, pattern)`. `boyer_moore_find` es una extensión cuando el alfabeto y la tabla de saltos puedan definirse con secuencias indexables; documenta si se implementa solo la regla del carácter malo. `naive_find` de [`12_Patterns.md`](12_Patterns.md) se reutiliza como **oráculo de pruebas**: no se vuelve a implementar.

**EN:** Implement `build_lps(pattern)` and `kmp_find(text, pattern)`. Also implement `z_array(text)` and `z_find(text, pattern)`. `boyer_moore_find` is an extension when the alphabet and the shift table can be defined with indexable sequences; document whether only the bad-character rule is implemented. `naive_find` from [`12_Patterns.md`](12_Patterns.md) is reused as a **test oracle**: it is not implemented again.

**ES:** Las **tablas auxiliares** —LPS y Z-array— son **secuencias indexables de enteros**, con una posición por unidad del patrón o del texto, y **no** arrays de arrays. Cuando el algoritmo lo requiera (por ejemplo, una tabla por patrón o una matriz de saltos) **pueden representarse como secuencias de secuencias**, y esa es una decisión idiomática del lenguaje. La representación del texto también es libre: la cadena es una secuencia indexable de unidades de texto, con su unidad declarada (ver [`11_Transformations.md`](11_Transformations.md)).

**EN:** The **auxiliary tables** —LPS and Z-array— are **indexable sequences of integers**, with one position per unit of the pattern or text, and **not** arrays of arrays. When the algorithm requires it (for example, a table per pattern or a shift matrix) they **may be represented as sequences of sequences**, and that is a language-idiomatic decision. The text's representation is free as well: the string is an indexable sequence of text units, with its declared unit (see [`11_Transformations.md`](11_Transformations.md)).

| Algoritmo / Algorithm | Tabla o precondición / Table or precondition | Tiempo / Time | Memoria auxiliar / Auxiliary memory |
|-----------|----------------------|--------|------------------|
| KMP | LPS sobre el patrón<br>LPS over the pattern | $O(n+m)$ | $O(m)$ |
| Z | Z-array de patrón + separador + texto<br>Z-array of pattern + separator + text | $O(n+m)$ | $O(n+m)$ |
| Boyer–Moore (ext.) | Saltos por alfabeto finito<br>Shifts by a finite alphabet | Según las reglas implementadas<br>Per the implemented rules | Según alfabeto y patrón<br>Per alphabet and pattern |

**ES:** Convenciones que la suite comprueba: `lps[i]` es la longitud del **prefijo propio más largo** del patrón que también es sufijo de `pattern[0..i]`; `z[0]` es el tamaño del texto (si el lenguaje usa `0` en esa posición, lo declara); y el separador del Z-array es una unidad que **no aparece** ni en el patrón ni en el texto, declarada en el README.

**EN:** Conventions the suite checks: `lps[i]` is the length of the pattern's **longest proper prefix** that is also a suffix of `pattern[0..i]`; `z[0]` is the text size (if the language uses `0` in that position, it declares it); and the Z-array separator is a unit appearing in **neither** the pattern nor the text, declared in the README.

**ES:** No incluir LCS en este módulo: se desarrolla como programación dinámica en [`18_Dynamic_Programming.md`](../structures/18_Dynamic_Programming.md). Las tablas se construyen **manualmente**, sin funciones de biblioteca equivalentes.

**EN:** Do not include LCS in this module: it is developed as dynamic programming in [`18_Dynamic_Programming.md`](../structures/18_Dynamic_Programming.md). The tables are built **manually**, without equivalent library functions.

### 🔀 Adaptación idiomática / Idiomatic adaptation

**ES:** Si el lenguaje no tiene arrays mutables, se acepta una lista o un vector **inmutable**, siempre que se conserven el **orden** y el **acceso por índice**; si no expone índices, se opera sobre la secuencia equivalente y se declara. Cada desviación va en la tabla de *Adaptaciones idiomáticas* del README, según [`AGENT_Template.md`](../../AGENT_Template.md).

**EN:** If the language has no mutable arrays, an **immutable** list or vector is accepted, as long as **order** and **index access** are preserved; if it exposes no indices, the equivalent sequence is used and declared. Every deviation goes in the README's *Idiomatic adaptations* table, per [`AGENT_Template.md`](../../AGENT_Template.md).

## 🧪 Casos de prueba / Test Cases

**ES:** Comparar cada resultado con `naive_find` para patrones presentes, ausentes, repetitivos, solapados y vacíos. Incluir pruebas unitarias de `build_lps` y `z_array`, no solo de la búsqueda final.

**EN:** Compare every result with `naive_find` for present, absent, repetitive, overlapping and empty patterns. Include unit tests for `build_lps` and `z_array`, not only for the final search.

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|---|---|---|
| LPS: tamaño / LPS: size | `build_lps("ABABAC")` | Una tabla de `size(pattern)` posiciones, es decir 6<br>A table of `size(pattern)` positions, that is 6 |
| LPS: prefijo propio más largo / LPS: longest proper prefix | `build_lps("ABABAC")` | `[0, 0, 1, 2, 3, 0]` (prefijo propio más largo que también es sufijo)<br>`[0, 0, 1, 2, 3, 0]` (longest proper prefix that is also a suffix) |
| LPS: repetición / LPS: repetition | `build_lps("AAAA")` | `[0, 1, 2, 3]` |
| LPS: sin coincidencias / LPS: no matches | `build_lps("ABCD")` | `[0, 0, 0, 0]` |
| Z-array: primera posición / Z-array: first position | `z_array(text)` | `z[0] == size(text)`, o `0` si el lenguaje lo declara<br>`z[0] == size(text)`, or `0` if the language declares it |
| Búsqueda presente / Present search | `kmp_find("ABABABCABABABC", "ABABC")` | El mismo resultado que `naive_find` (oráculo)<br>The same result as `naive_find` (oracle) |
| Búsqueda ausente / Absent search | `kmp_find("XYZ", "ABC")` | Indicador de fallo, igual que el oráculo<br>Failure indicator, same as the oracle |
| Patrón repetitivo y solapado / Repetitive and overlapping pattern | `kmp_find("AAAA", "AA")` | El primer índice de coincidencia, igual que el oráculo<br>The first match index, same as the oracle |
| Patrón vacío / Empty pattern | `kmp_find("ABC", "")` | Se declara la convención del módulo y coincide con el oráculo<br>The module's convention is declared and matches the oracle |

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Las tablas auxiliares (`LPS`, `Z-array`) se construyen **manualmente** como secuencias indexables de enteros, sin funciones de biblioteca equivalentes.
      **EN:** The auxiliary tables (`LPS`, `Z-array`) are built **manually** as indexable sequences of integers, without equivalent library functions.
- [ ] **ES:** La suite verifica la equivalencia observable con `naive_find` en patrones presentes, ausentes, repetitivos, solapados y vacíos.
      **EN:** The suite verifies the observable equivalence with `naive_find` for present, absent, repetitive, overlapping and empty patterns.
- [ ] **ES:** Se prueban `build_lps` y `z_array` por separado, con su tamaño y sus valores.
      **EN:** `build_lps` and `z_array` are tested separately, with their size and their values.
- [ ] **ES:** Se documentan el separador, el alfabeto y la unidad indexada del texto.
      **EN:** The separator, the alphabet and the text's indexed unit are documented.
- [ ] **ES:** Cada desviación de representación está declarada en la tabla de *Adaptaciones idiomáticas* del README.
      **EN:** Every representation deviation is declared in the README's *Idiomatic adaptations* table.

## ▶️ Siguiente / Next

👉 Sigue con [`14_Input_Output.md`](14_Input_Output.md).  
👉 Continue with [`14_Input_Output.md`](14_Input_Output.md).
