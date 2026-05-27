---
layout: default
title: Abstracción y Persistencia / Abstraction & Persistence
description: Índice de la sección de abstracción y persistencia — modelado, regex, parsing, BD, ETL integrado / Index for the abstraction and persistence section — modeling, regex, parsing, DB, integrated ETL
nav_order: 3
parent: Core
grand_parent: Programming Languages Monorepo
---

# Abstracción y Persistencia / Abstraction & Persistence

> [← Volver a Core](../README.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 📖 Descripción / Description

**ES:** Capa de abstracción sobre el procesamiento contiguo. Se introducen tipos de retorno (Option/Result), modelado de datos, expresiones regulares, parsing formal, bases de datos y pipelines ETL completos.

**EN:** Abstraction layer over contiguous processing. Return types (Option/Result), data modeling, regular expressions, formal parsing, databases, and complete ETL pipelines are introduced.

---

## 📁 Especificaciones / Specifications

| Módulo | Estado | Tema |
|--------|--------|------|
| `modeling` | 📋 | user, product, order… |
| `strsearch` | 📋 | String search con abstracciones y tipos de retorno |
| `regex` | 📋 | Patrones de email, teléfono, etc. |
| `parsing` | 📋 | csv_parser, json_parser, arithmetic_parser |
| `data_base` | 📋 | raw_queries, ORM, connection_pool |
| `integracion_etl` | 📋 | Pipelines ETL que integran I/O, regex y BD |

---

## 🧭 Flujo recomendado / Recommended flow

1. `modeling`
2. `strsearch`
3. `regex`
4. `parsing`
5. `data_base`
6. `integracion_etl`

---

*[← Volver a Core](../README.md) | [↑ Inicio](../../index.md)*
