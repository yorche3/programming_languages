---
layout: default
title: 14 — Controlled File I/O
description: Entrada y salida reproducible con fixtures compartidos / Reproducible input and output with shared fixtures
nav_order: 4
parent: Procesamiento Contiguo / Contiguous Processing
grand_parent: Core
---

# 🚀 14 — Controlled File I/O

> [← Volver a 13_Substr](13_Substr.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Introducir el límite entre memoria y sistema de archivos. Leer, escribir y anexar datos sin ocultar codificación, rutas ni errores, usando fixtures versionados comunes para resultados comparables entre lenguajes. | Introduce the boundary between memory and the file system. Read, write, and append data without hiding encoding, paths, or errors, using common versioned fixtures for comparable cross-language results. |

## 📝 Especificación / Specification

Implementar `read_text(path)`, `write_text(path, text)` y `append_text(path, text)`. Usar UTF-8 salvo que el lenguaje no pueda garantizarlo; la adaptación debe quedar documentada. Los fixtures canónicos viven bajo `test/fixtures/` e incluyen entrada válida, texto Unicode y archivo CSV delimitado. Las pruebas escriben exclusivamente en un directorio temporal.

Errores de ruta inexistente, permisos, decodificación y argumentos inválidos deben elevar la excepción idiomática concreta, que las pruebas verifican. No capturar y silenciar errores.

## 🧪 Casos de prueba / Test Cases

Probar lectura exacta de fixture, escritura y relectura, append conservando contenido previo, ruta inexistente, y preservación UTF-8 cuando aplique. Las pruebas no dependen del directorio de trabajo actual ni de archivos externos.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] Fixtures versionados y comunes, sin datos privados ni generados en tiempo de prueba como entrada base.
- [ ] Salidas temporales aisladas y limpiadas por el framework o el runner.
- [ ] Excepciones de frontera verificadas por tipo/clase idiomática.

## ▶️ Siguiente / Next

👉 Sigue con [`15_ETL_Basico.md`](15_ETL_Basico.md).  
👉 Continue with [`15_ETL_Basico.md`](15_ETL_Basico.md).
