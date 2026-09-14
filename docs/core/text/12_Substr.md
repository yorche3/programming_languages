---
layout: default
title: 12 — Substring Search
description: Búsqueda de subcadenas con tablas auxiliares / Substring search with auxiliary tables
nav_order: 3
parent: Procesamiento Contiguo / Contiguous Processing
grand_parent: Core
---

# 🚀 12 — Substring Search

> [← Volver a 11_Patterns](11_Patterns.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Pasar de la comparación ingenua a algoritmos que preservan información en arrays auxiliares. El foco es la invariante de la tabla —prefijos en KMP, desplazamientos en Boyer–Moore o cajas Z— y no solo su complejidad. | Move from naïve comparison to algorithms that retain information in auxiliary arrays. The focus is the table invariant —prefixes in KMP, shifts in Boyer–Moore, or Z boxes— and not merely complexity. |

## 📝 Especificación / Specification

Implementar `build_lps(pattern)` y `kmp_find(text, pattern)`. Implementar también `z_array(text)` y `z_find(text, pattern)`. `boyer_moore_find` es una extensión cuando el alfabeto y la tabla de saltos puedan definirse con arrays; documenta si se implementa la regla de carácter malo solamente. `naive_find` de 12 se reutiliza como oráculo de pruebas, no se vuelve a implementar.

| Algoritmo | Tabla / precondición | Tiempo | Memoria auxiliar |
|-----------|----------------------|--------|------------------|
| KMP | LPS sobre el patrón | $O(n+m)$ | $O(m)$ |
| Z | Z-array de patrón + separador + texto | $O(n+m)$ | $O(n+m)$ |
| Boyer–Moore (ext.) | saltos por alfabeto finito | según reglas implementadas | según alfabeto/patrón |

No incluir LCS en este módulo: se desarrolla como programación dinámica en `17_Dynamic_Programming.md`.

## 🧪 Casos de prueba / Test Cases

Comparar cada resultado con `naive_find` para patrones presentes, ausentes, repetitivos, solapados y vacíos. Incluir tests unitarios para LPS y Z-array, no solo para la búsqueda final.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] Las tablas auxiliares se construyen manualmente con arrays.
- [ ] La suite verifica la equivalencia observable con `naive_find`.
- [ ] Se documentan separador, alfabeto y política de unidades de texto.

## ▶️ Siguiente / Next

👉 Sigue con [`13_Input_Output.md`](13_Input_Output.md).  
👉 Continue with [`13_Input_Output.md`](13_Input_Output.md).
