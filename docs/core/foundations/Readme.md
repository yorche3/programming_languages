---
layout: default
title: Fundamentos / Foundations
description: Conceptos esenciales para empezar a programar en cualquier lenguaje — primeros programas, entrada/salida, pruebas unitarias y algoritmos numéricos / Essential concepts to start programming in any language — first programs, I/O, unit testing and numerical algorithms
nav_order: 1
parent: 🧱 Core
has_children: true
---

# 🚀 Fundamentos / Foundations

> [← Volver a Core](../Readme.md)  
> [↑ Volver al inicio / Back to home](../../index.md)

---

## 📖 Descripción / Description

**ES:** Esta sección reúne los conceptos esenciales para empezar a trabajar con diferentes lenguajes de programación. Cubre desde el programa más básico ("Hello, World!") hasta la implementación de algoritmos numéricos en tres enfoques progresivos, incluyendo la forma más atómica de probar tu código: las **pruebas unitarias** con frameworks/bibliotecas estándar.

**EN:** This section brings together the essential concepts to start working with different programming languages. It covers everything from the most basic program ("Hello, World!") to implementing numerical algorithms in three progressive approaches, including the most atomic way to test your code: **unit tests** with standard frameworks/libraries.

---

## 📁 Estructura / Structure

```text
📂 foundations/
├── 01_Hello_World.md       ← 🚀 INICIO / START
├── 02_Hello_User.md        ← Variables y entrada/salida
├── 03_Unit_Test_Demo.md    ← Pruebas unitarias (framework/biblioteca)
├── 04_Numbers.md           ← Algoritmos numéricos (3 enfoques)
└── Readme.md               ← Este archivo / This file
```

---

## 🎯 Objetivos de aprendizaje / Learning Objectives

| Módulo | Español | English |
|--------|---------|---------|
| [`01_Hello_World.md`](01_Hello_World.md) | Escribir, compilar/interpretar y ejecutar el primer programa en cualquier lenguaje. | Write, compile/interpret and run the first program in any language. |
| [`02_Hello_User.md`](02_Hello_User.md) | Declarar variables, solicitar entrada del usuario y mostrar mensajes personalizados. | Declare variables, prompt for user input and display personalized messages. |
| [`03_Unit_Test_Demo.md`](03_Unit_Test_Demo.md) | Implementar un módulo `calculator` con operaciones aritméticas y validarlo mediante pruebas unitarias con el framework/biblioteca estándar del lenguaje. | Implement a `calculator` module with arithmetic operations and validate it through unit tests using the language's standard framework/library. |
| [`04_Numbers.md`](04_Numbers.md) | Implementar Fibonacci, factorial y suma de n números en tres enfoques: recursivo directo, recursivo con acumulador e iterativo. | Implement Fibonacci, factorial and sum of n numbers in three approaches: direct recursion, accumulator recursion and iterative. |

---

## 🔢 Flujo recomendado / Recommended Flow

**ES:** Los documentos están numerados secuencialmente. Sigue el orden para construir conocimiento de forma progresiva:

**EN:** Documents are numbered sequentially. Follow the order to build knowledge progressively:

```text
01_Hello_World.md  →  02_Hello_User.md  →  03_Unit_Test_Demo.md  →  04_Numbers.md
```

Cada módulo asume que completaste el anterior.
*Each module assumes you completed the previous one.*

---

## 🔬 Principios / Principles

**ES:** Todo el código implementado en esta sección debe:

**EN:** All code implemented in this section must:

- ✅ Incluir pruebas unitarias usando el framework/biblioteca estándar del lenguaje _(Include unit tests using the language's standard framework/library)_
- 🔧 Ser mantenible: legible, bien estructurado y seguir las convenciones del lenguaje _(Be maintainable: readable, well-structured and follow the language's conventions)_
- 📦 Usar únicamente la biblioteca estándar, sin dependencias externas _(Use only the standard library, no external dependencies)_
- 📐 Adaptar nombres y estructura a las convenciones de cada lenguaje (`hello_world` → `HelloWorld.java`, `hello_world.py`, etc.) _(Adapt names and structure to each language's conventions)_

---

## ▶️ Siguiente / Next

👉 Después de completar los fundamentos, continúa con las secciones especializadas en [`../text/`](../text/) (procesamiento de texto), [`../algorithms/`](../algorithms/) (algoritmos), etc.  
👉 After completing the foundations, continue with the specialized sections in [`../text/`](../text/) (text processing), [`../algorithms/`](../algorithms/) (algorithms), etc.

---

*[← Volver a Core](../Readme.md) | [↑ Inicio](../../index.md)*