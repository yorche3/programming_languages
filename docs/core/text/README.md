---
layout: default
title: Procesamiento Contiguo / Contiguous Processing
description: Índice de la sección de procesamiento contiguo — solo arrays, archivos, I/O / Index for the contiguous processing section — only arrays, files, I/O
nav_order: 2
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
| `transformations` | ✅ | reverse, trim, capitalize, to_uppercase, to_lowercase, pad_left/right |
| `patterns` | 📋 | palindrome, anagram (con arrays ASCII, sin HashMaps) |
| `substr` | 📋 | Naive Search, LPP, KMP, Boyer-Moore, LCS, LCP, Z-Algorithm |
| `input_output` | 📋 | Archivos (read, write, append) con excepciones y validaciones |
| `etl_basico` | 📋 | CSV parse, JSON parse básico, transformaciones de datos |

---

## 🧭 Flujo recomendado / Recommended flow

1. `transformations`
2. `patterns`
3. `substr`
4. `input_output`
5. `etl_basico`

---

## ▶️ Siguiente / Next

👉 Continúa con [`transformations`](01_Transformations.md).  
👉 Continue with [`transformations`](01_Transformations.md).

---

*[← Volver a Core](../README.md) | [↑ Inicio](../../index.md)*
