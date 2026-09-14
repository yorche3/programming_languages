---
layout: default
title: Procesamiento Contiguo / Contiguous Processing
description: Índice de procesamiento de strings y archivos contiguos / Index for contiguous string and file processing
nav_order: 3
parent: Core
grand_parent: Programming Languages Monorepo
---

# Procesamiento Contiguo / Contiguous Processing

> [← Volver a Core](../README.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 📖 Descripción / Description

**ES:** Procesamiento de strings y archivos con representaciones contiguas. La fase empieza por unidades de texto, recorridos y buffers; continúa con patrones ingenuos y tablas auxiliares; después delimita I/O mediante fixtures comunes; y cierra integrando las implementaciones previas en un ETL reproducible. Se introducen excepciones en la frontera de I/O y datos malformados.

**EN:** String and file processing with contiguous representations. The phase starts with text units, traversals, and buffers; continues with naïve patterns and auxiliary tables; then defines I/O through common fixtures; and closes by integrating previous implementations into reproducible ETL. Exceptions are introduced at the I/O and malformed-data boundary.

---

## 📁 Especificaciones / Specifications

| Módulo | Estado | Tema | Especificación |
|--------|--------|------|----------------|
| `transformations` | 🔄 | representación, reverse, trim, case, padding y blancos | [`10_Transformations.md`](10_Transformations.md) |
| `patterns` | 📋 | palindrome, anagram, búsqueda ingenua y comodines opcionales | [`11_Patterns.md`](11_Patterns.md) |
| `substr` | 📋 | LPS, KMP, Z y Boyer–Moore opcional; LCS va a DP | [`12_Substr.md`](12_Substr.md) |
| `input_output` | 📋 | fixtures comunes, read/write/append y excepciones de frontera | [`13_Input_Output.md`](13_Input_Output.md) |
| `etl_basico` | 📋 | CSV delimitado, validación, transformaciones y reuse de searching/sort | [`14_ETL_Basico.md`](14_ETL_Basico.md) |

> **ES:** `transformations` aún **no se ha refactorizado** a la estructura homologada `core/text/` (0/49 submódulos registrados en `.gitmodules`). Esta es la primera fase que introduce strings: define la unidad indexable de texto y los recorridos antes de `naive_find` y los algoritmos de subcadena. La búsqueda sobre strings no se presupone en `searching`, que trabaja exclusivamente con arrays numéricos. LCS se enseña en programación dinámica y regex completo se reserva para Fase 4. Los fixtures de entrada y salida se versionan para evitar diferencias entre runners y sistemas operativos.
> **EN:** `transformations` has **not yet been refactored** to the standardized `core/text/` layout (0/49 submodules registered in `.gitmodules`). This is the first phase that introduces strings: it defines the indexable text unit and traversals before `naive_find` and substring algorithms. String search is not assumed in `searching`, which works exclusively with numeric arrays. LCS is taught in dynamic programming and full regex is reserved for Phase 4. Input and output fixtures are versioned to avoid runner and operating-system differences.

---

## 🧭 Flujo recomendado / Recommended flow

1. `10_Transformations.md`
2. `11_Patterns.md`
3. `12_Substr.md`
4. `13_Input_Output.md`
5. `14_ETL_Basico.md`

---

## ▶️ Siguiente / Next

👉 Continúa con [`10_Transformations.md`](10_Transformations.md).
👉 Continue with [`10_Transformations.md`](10_Transformations.md).

---

*[← Volver a Core](../README.md) | [↑ Inicio](../../index.md)*
