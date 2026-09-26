---
layout: default
title: 15 — Basic ETL
description: Pipeline ETL reproducible que reutiliza algoritmos propios / Reproducible ETL pipeline reusing own algorithms
nav_order: 5
parent: Procesamiento Contiguo / Contiguous Processing
grand_parent: Core
---

# 🚀 15 — Basic ETL

> [← Volver a 14_Input_Output](14_Input_Output.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Integrar archivos, strings y algoritmos previamente construidos en un pipeline pequeño y determinista. La meta es hacer visibles las decisiones de representación: filas contiguas, secuencias de campos, validación y coste de ordenar o buscar. | Integrate files, strings, and previously built algorithms into a small deterministic pipeline. The goal is to make representation choices visible: contiguous rows, field sequences, validation, and the cost of sorting or searching. |

## 📝 Especificación / Specification

Consumir un fixture CSV delimitado y producir un archivo de salida canónico. El pipeline debe: (1) leer UTF-8 mediante el módulo 14; (2) separar campos manualmente, con comillas fuera de alcance; (3) validar número de columnas, entero y texto requerido; (4) normalizar al menos un campo con módulo 11; (5) filtrar o localizar registros con una búsqueda propia; (6) ordenar resultados con un algoritmo propio cuando el resultado requiera orden; y (7) escribir la salida.

Se permite importar `searching` y un módulo de ordenamiento ya implementado; no usar `sort()` ni una búsqueda de biblioteca. Si todavía no existe una implementación del lenguaje, se documenta el bloqueo de dependencia en vez de sustituirla silenciosamente. JSON y un parser CSV completo quedan para Fase 4.

## 🧪 Casos de prueba / Test Cases

Los fixtures compartidos incluyen filas válidas, una fila con número inválido, una fila con columnas incompletas y valores con blancos. Probar salida exacta, reporte/colección de filas rechazadas definida por el contrato, filtro sin coincidencias y orden estable cuando sea requerido.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] El pipeline usa I/O y al menos una transformación propia.
- [ ] El filtrado/búsqueda y el ordenamiento reutilizan implementaciones propias mediante importación.
- [ ] No se usan parser CSV completo, JSON, regex completo, `sort()` ni búsqueda nativa.
- [ ] La salida es determinista y se compara con un fixture esperado versionado.

## 📂 Ubicación esperada / Expected Location

```text
{language}/core/text/etl_basico/
├── src/etl_basico.ext
└── test/
    ├── etl_basico_test.ext
    └── fixtures/
        ├── input.csv
        └── expected_output.csv
```

## ▶️ Siguiente / Next

👉 Continúa con [`16_Graph_Algorithms.md`](../structures/16_Graph_Algorithms.md).  
👉 Continue with [`16_Graph_Algorithms.md`](../structures/16_Graph_Algorithms.md).
