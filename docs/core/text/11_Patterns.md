---
layout: default
title: 11 — String Properties and Naïve Patterns
description: Propiedades de cadenas y patrones explícitos / String properties and explicit patterns
nav_order: 2
parent: Procesamiento Contiguo / Contiguous Processing
grand_parent: Core
---

# 🚀 11 — String Properties and Naïve Patterns

> [← Volver a 10_Transformations](10_Transformations.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Reutilizar recorridos de strings para decidir propiedades y reconocer patrones pequeños antes de estudiar tablas de salto. El objetivo es distinguir comparación directa, normalización y coste de memoria auxiliar. | Reuse string traversals to decide properties and recognize small patterns before studying skip tables. The goal is to distinguish direct comparison, normalization, and auxiliary-memory cost. |

## 📝 Especificación / Specification

Implementar `is_palindrome(text)`, `are_anagrams(left, right)` y `naive_find(text, pattern)`. Añadir opcionalmente `matches_wildcard(text, pattern)`, donde solo `?` representa una unidad y `*` una secuencia; no se usa un motor regex.

| Algoritmo | Representación / Restricción | Complejidad |
|-----------|------------------------------|-------------|
| Palíndromo | Dos índices; documenta normalización | $O(n)$ tiempo, $O(1)$ auxiliar sin normalizar |
| Anagrama | Tabla de frecuencias por array para alfabeto definido; sin hash map | $O(n + k)$ |
| Búsqueda ingenua | String indexable, sin conversión oculta | $O(nm)$ peor caso |
| Comodines opcionales | Coincidencia manual limitada | Debe documentar su estrategia y límites |

La coincidencia vacía se define explícitamente: por defecto `naive_find(text, "")` retorna `0`. Parámetros nulos o política inválida lanzan excepciones idiomáticas.

## 🧪 Casos de prueba / Test Cases

Cubrir palíndromos con y sin normalización, anagramas positivos/negativos y longitudes distintas, patrón al inicio/medio/final/ausente, patrón vacío y patrón más largo que el texto. Si se implementan comodines, añadir `?`, `*` y casos sin coincidencia.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] No se usan mapas/hash tables ni motores regex.
- [ ] El alfabeto y la normalización son parte pública del contrato de anagramas y palíndromos.
- [ ] `naive_find` sirve como línea base verificable para los algoritmos del módulo 13.

## ▶️ Siguiente / Next

👉 Sigue con [`12_Substr.md`](12_Substr.md).  
👉 Continue with [`12_Substr.md`](12_Substr.md).
