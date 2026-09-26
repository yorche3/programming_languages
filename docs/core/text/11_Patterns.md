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

**ES:** El texto es una **secuencia indexable de unidades de texto**: la unidad indexada (carácter, byte o *code unit*) y la política Unicode/ASCII son las que declare cada lenguaje, como en [`10_Transformations.md`](10_Transformations.md). La tabla de frecuencias es una **secuencia indexable de enteros**, no un mapa ni una tabla hash, y su representación es libre.

**EN:** The text is an **indexable sequence of text units**: the indexed unit (character, byte or *code unit*) and the Unicode/ASCII policy are the ones each language declares, as in [`10_Transformations.md`](10_Transformations.md). The frequency table is an **indexable sequence of integers**, not a map or a hash table, and its representation is free.

| Algoritmo / Algorithm | Representación o restricción / Representation or restriction | Complejidad / Complexity |
|-----------|------------------------------|-------------|
| Palíndromo / Palindrome | Dos índices; documenta la normalización<br>Two indices; document the normalisation | $O(n)$ tiempo, $O(1)$ auxiliar sin normalizar<br>$O(n)$ time, $O(1)$ auxiliary without normalising |
| Anagrama / Anagram | Secuencia indexable de frecuencias para un alfabeto definido; sin mapa ni hash<br>Indexable frequency sequence for a defined alphabet; no map or hash | $O(n + k)$ |
| Búsqueda ingenua / Naïve search | Texto indexable, sin conversión oculta<br>Indexable text, with no hidden conversion | $O(nm)$ peor caso<br>$O(nm)$ worst case |
| Comodines opcionales / Optional wildcards | Coincidencia manual limitada<br>Limited manual matching | Debe documentar su estrategia y límites<br>It must document its strategy and limits |

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
