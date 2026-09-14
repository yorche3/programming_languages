---
layout: default
title: 10 — String Transformations
description: Representación de cadenas y transformaciones manuales / String representation and manual transformations
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

Implementar manualmente `reverse`, `trim`, `capitalize`, `to_uppercase`, `to_lowercase`, `pad_left`, `pad_right` y `remove_blank_chars`. Se permite el buffer contiguo nativo para construir una salida, pero no una función de biblioteca que realice la transformación objetivo.

| Operación | Concepto reforzado | Contrato |
|-----------|-------------------|----------|
| `reverse(text)` | extremos e índices | Invierte las unidades de texto según la representación documentada. |
| `trim(text)` | límites de ventana | Elimina blancos iniciales y finales. |
| `capitalize(text)` | clasificación y estado | Capitaliza la primera unidad alfabética conforme a la política documentada. |
| `to_uppercase` / `to_lowercase` | recorrido lineal | Define una política ASCII o Unicode explícita. |
| `pad_left` / `pad_right` | tamaño y buffer | Completa hasta `width`; si ya alcanza el ancho, no modifica. |
| `remove_blank_chars(text)` | filtrado | Elimina los blancos definidos por la política del módulo. |

Las entradas nulas y parámetros inválidos lanzan la excepción idiomática acordada para Fase 2. Una cadena vacía es válida y devuelve una cadena vacía cuando corresponda.

## 🧪 Casos de prueba / Test Cases

Probar vacío, un carácter, texto con blancos en extremos e internos, ancho menor/igual/mayor que la longitud, y caracteres no ASCII cuando la representación lo soporte. Las pruebas deben indicar la política Unicode elegida; no se admite afirmar soporte de grafemas sin implementarlo.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] La documentación de cada lenguaje declara la unidad indexada y la política Unicode/ASCII.
- [ ] Las transformaciones objetivo no llaman a su equivalente de biblioteca.
- [ ] Se prueban excepciones para entrada o ancho inválido y resultados para entradas válidas.
- [ ] Código fuente y pruebas permanecen separados en `src/` y `test/`.

## 📂 Ubicación esperada / Expected Location

```text
{language}/core/text/transformations/
├── src/transformations.ext
└── test/transformations_test.ext
```

## ▶️ Siguiente / Next

👉 Sigue con [`11_Patterns.md`](11_Patterns.md).  
👉 Continue with [`11_Patterns.md`](11_Patterns.md).
