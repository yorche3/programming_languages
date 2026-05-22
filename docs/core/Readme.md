---
layout: default
title: 🧱 Core
description: Documentación fundamental del proyecto — especificaciones generales, guías de implementación y ejemplos prácticos / Core project documentation — general specifications, implementation guides and practical examples
nav_order: 1
has_children: true
---

# 🧱 Core

> [← Volver al inicio / Back to home](../index.md)

---

## 📖 Descripción / Description

**ES:** El directorio `core/` contiene la documentación fundamental del proyecto: especificaciones generales, guías de implementación y ejemplos prácticos estructurados en secciones progresivas. Cada especificación define **qué** debe hacer el programa, no **cómo** hacerlo en un lenguaje específico.

**EN:** The `core/` directory contains the project's fundamental documentation: general specifications, implementation guides, and practical examples structured in progressive sections. Each specification defines **what** the program should do, not **how** to do it in a specific language.

---

## 📁 Estructura / Structure

```text
docs/core/
├── foundations/          # Fundamentos: primeros programas en cualquier lenguaje
│   ├── 01_Hello_World.md
│   ├── 02_Hello_User.md
│   ├── 03_Unit_Test_Demo.md
│   └── 04_Numbers.md
├── algorithms/           # Algoritmos y estructuras de datos / Algorithms & data structures
├── text/                 # Procesamiento de texto / Text processing
├── data/                 # Entrada/salida, modelado, bases de datos / I/O, modeling, databases
├── math/                 # Estadística, álgebra lineal / Statistics, linear algebra
└── Readme.md             # Este archivo / This file
```

---

## 🎯 Propósito / Purpose

**ES:** El objetivo principal de `core/` es proporcionar una base sólida y progresiva de conceptos de programación, implementables en cualquier lenguaje. A partir de los fundamentos, cada sección aborda un área distinta (algoritmos, texto, datos, matemáticas) construyendo sobre lo aprendido anteriormente.

**EN:** The main purpose of `core/` is to provide a solid and progressive foundation of programming concepts, implementable in any language. Starting from the foundations, each section covers a different area (algorithms, text, data, mathematics) building on previously learned concepts.

---

## 🔢 Flujo de implementación / Implementation Flow

**ES:** Los documentos dentro de cada sección están numerados secuencialmente. Sigue la numeración para avanzar en orden:

**EN:** Documents within each section are numbered sequentially. Follow the numbering to advance in order:

```text
📂 foundations/
├── 01_Hello_World.md     ← 🚀 INICIO / START
├── 02_Hello_User.md      ← Variables y entrada/salida
├── 03_Unit_Test_Demo.md  ← Pruebas unitarias con framework/biblioteca
├── 04_Numbers.md         ← Algoritmos numéricos (3 enfoques)
└── ...
```

---

## 🔬 Calidad del código / Code Quality

**ES:** Todo el código implementado a partir de estas especificaciones debe cumplir con los siguientes principios:

**EN:** All code implemented from these specifications must adhere to the following principles:

| Principio / Principle | ES | EN |
|----------------------|----|----|
| ✅ **Probado / Tested** | El código debe incluir pruebas unitarias que verifiquen su correcto funcionamiento. A partir de `03_Unit_Test_Demo.md`, toda implementación debe tener su suite de pruebas usando el framework/biblioteca estándar del lenguaje. | Code must include unit tests that verify its correct behavior. From `03_Unit_Test_Demo.md` onward, every implementation must have its test suite using the language's standard framework/library. |
| 🔧 **Mantenible / Maintainable** | El código debe ser legible, estar bien estructurado y seguir las convenciones del lenguaje. Usa nombres descriptivos, separa responsabilidades en módulos/funciones y documenta cuando sea necesario. | Code must be readable, well-structured, and follow the language's conventions. Use descriptive names, separate responsibilities into modules/functions, and document when necessary. |
| 📦 **Biblioteca estándar / Standard Library** | Usa únicamente la biblioteca estándar del lenguaje, sin dependencias externas. Esto garantiza portabilidad y facilidad de configuración. | Use only the language's standard library, with no external dependencies. This ensures portability and ease of setup. |
| 📐 **Convenciones del lenguaje / Language Conventions** | Adapta los nombres (`hello_world` → `HelloWorld.java`, `hello_world.py`, etc.) y la estructura del proyecto según las prácticas recomendadas de cada lenguaje. | Adapt names (`hello_world` → `HelloWorld.java`, `hello_world.py`, etc.) and project structure according to each language's recommended practices. |

---

## 🧭 Después de Fundamentos / Beyond Foundations

**ES:** Una vez completados los fundamentos (`foundations/`), encontrarás secciones especializadas con desarrollos tipo biblioteca o herramienta, diseñados para proporcionar una base sólida antes de avanzar a proyectos más complejos (CLI, TUI, GUI, web, etc.):

**EN:** Once you complete the foundations (`foundations/`), you will find specialized sections with library or tool-type developments, designed to provide a solid foundation before advancing to more complex projects (CLI, TUI, GUI, web, etc.):

| Sección / Section | ES | EN |
|-------------------|----|----|
| `algorithms/` | Ordenamiento, búsqueda, estructuras de datos (valores centinela, sin excepciones) | Sorting, searching, data structures (sentinel values, no exceptions) |
| `text/` | Transformaciones, patrones, expresiones regulares, parsing (excepciones) | Transformations, patterns, regex, parsing (exceptions) |
| `data/` | Entrada/salida de archivos, modelado, bases de datos | File I/O, modeling, databases |
| `math/` | Estadística, álgebra lineal | Statistics, linear algebra |

---

## 🚀 Inicio rápido / Quick Start

**ES:** Si aún no has comenzado, tu punto de entrada es el primer documento de fundamentos:

**EN:** If you haven't started yet, your entry point is the first foundations document:

👉 **[`foundations/01_Hello_World.md`](foundations/01_Hello_World.md)** ← **INICIO / START**

Luego sigue la numeración secuencial dentro de cada sección.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages)*