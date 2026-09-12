---
layout: default
title: Procesamiento Contiguo / Contiguous Processing
description: Índice de la sección de procesamiento contiguo — solo arrays, archivos, I/O / Index for the contiguous processing section — only arrays, files, I/O
nav_order: 3
parent: Core
grand_parent: Programming Languages Monorepo
---

# Procesamiento Contiguo / Contiguous Processing

> [← Volver a Core](../README.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 📖 Descripción / Description

**ES:** Procesamiento de datos usando solo estructuras contiguas (arrays, archivos). Se introducen excepciones. Incluye transformaciones de texto, búsqueda de patrones básicos, I/O de archivos y ETL básico.

**EN:** Data processing using only contiguous structures (arrays, files). Exceptions are introduced. Includes string transformations, basic pattern matching, file I/O, and basic ETL.

---

## 📁 Especificaciones / Specifications

| Módulo | Estado | Tema |
|--------|--------|------|
| `transformations` | 🔄 | reverse, trim, capitalize, to_uppercase, to_lowercase, pad_left/right |
| `patterns` | 📋 | palindrome, anagram (con arrays ASCII, sin HashMaps) |
| `substr` | 📋 | Naive Search, LPP, KMP, Boyer-Moore, LCS, LCP, Z-Algorithm |
| `input_output` | 📋 | Archivos (read, write, append) con excepciones y validaciones |
| `etl_basico` | 📋 | CSV parse, JSON parse básico, transformaciones de datos |

> **ES:** `transformations` aún **no se ha refactorizado** a la estructura homologada `core/text/` (0/49 submódulos registrados en `.gitmodules`); su estado se marcará ✅ cuando las implementaciones estén migradas.
> **EN:** `transformations` has **not yet been refactored** to the standardized `core/text/` layout (0/49 submodules registered in `.gitmodules`); its status will return to ✅ once implementations are migrated.

---

## 🧭 Flujo recomendado / Recommended flow

1. `11_Transformations.md`
2. `12_Patterns.md`
3. `13_Substr.md`
4. `14_Input_Output.md`
5. `15_ETL_Basico.md`

---

## ▶️ Siguiente / Next

👉 Continúa con [`11_Transformations.md`](11_Transformations.md).  
👉 Continue with [`11_Transformations.md`](11_Transformations.md).

---

*[← Volver a Core](../README.md) | [↑ Inicio](../../index.md)*
