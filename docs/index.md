---
layout: default
title: 🌐 Programming Languages Monorepo
description: Implementación de conceptos de programación en múltiples lenguajes / Programming concepts implemented in multiple languages
---

# 🌐 Lenguajes de Programación / Programming Languages

> **Implementación de conceptos de programación basados en especificaciones generales y adaptaciones específicas para cada lenguaje.**  
> *Implementation of programming concepts based on general specifications and specific adaptations for each programming language.*

---

## 📖 Descripción / Description

**ES:** Este monorepo proporciona un entorno de aprendizaje y experimentación completo para varios lenguajes de programación. Cubre desde fundamentos hasta temas avanzados como microservicios, interfaces gráficas y CI/CD enfocado en seguridad de código.

**EN:** This monorepo provides a comprehensive learning and experimentation environment for various programming languages. It covers fundamentals of each language up to advanced topics like microservices, GUIs and CI/CD focused on code security.

---

## 🧭 Navegación / Navigation

| Ruta / Path | Contenido / Content |
|-------------|--------------------|
| [`🗺️ ROADMAP.md`](ROADMAP.md) | Plan de desarrollo completo / Full development plan |
| [`🧱 Core`](core/README.md) | Índice general de la documentación base / Main core documentation index |
| [`📄 Plantilla_Readme.md`](Plantilla_Readme.md) | Plantilla de README para sub-proyectos individuales / README template for individual sub-projects |
| [`🤖 Plantilla_Agente.md`](Plantilla_Agente.md) | Guía operativa para agentes de IA que documentan o corrigen el repo / Operational guide for AI agents documenting or fixing the repo |
| [`🤝 CONTRIBUTING.md`](CONTRIBUTING.md) | Convención de commits / Commit convention |

> 💡 **Convención de nombres / Naming convention:** Los documentos siguen una numeración secuencial (`01_`, `02_`, `03_`…) que indica el orden recomendado de implementación. Sigue la numeración para avanzar en el flujo.

---

## 📁 Estructura / Structure

```text
programming_languages/
├── docs/                          # 🌐 Sitio web / Website (GitHub Pages)
│   ├── index.md                   # Portada / Landing page
│   ├── ROADMAP.md                 # Plan de desarrollo / Development roadmap
│   └── core/
│       ├── README.md              # Índice general / Main core index
│       ├── foundations/
│       │   ├── README.md
│       │   ├── 01_Hello_World.md
│       │   ├── 02_Hello_User.md
│       │   ├── 03_Unit_Test_Calculator.md
│       │   └── 04_Numbers.md
│       ├── algorithms/
│       │   ├── README.md
│       │   ├── 05_Sorting.md
│       │   └── ...
│       └── text/
│           ├── README.md
│           ├── 01_Transformations.md
│           └── ...
├── python/                        # 🐍 Implementaciones Python
├── java/                          # ☕ Implementaciones Java
├── go/                            # 🔵 Implementaciones Go
└── ... (resto de lenguajes)
```

---

## 📁 Convenciones de archivos / File Naming Conventions

**ES:** En las especificaciones encontrarás referencias como `hello_world.ext`. El `.ext` es un marcador de posición (placeholder) que debes reemplazar por la extensión estándar de tu lenguaje (`.py`, `.java`, `.go`, `.rs`, etc.). El nombre base (en `snake_case` como `hello_world`) debe adaptarse a la convención de nomenclatura que dicta cada lenguaje (CamelCase, PascalCase, etc.).

**EN:** In the specifications you'll find references like `hello_world.ext`. The `.ext` is a placeholder that you must replace with your language's standard extension (`.py`, `.java`, `.go`, `.rs`, etc.). The base name (in `snake_case` like `hello_world`) must adapt to the naming convention dictated by each language (CamelCase, PascalCase, etc.).

| Ejemplo / Example | Lenguaje / Language |
|-------------------|-------------------|
| `hello_world.py` | Python |
| `HelloWorld.java` | Java |
| `hello_world.go` | Go |
| `HelloWorld.cs` | C# |
| `hello_world.rs` | Rust |
| `hello_world.ex` | Elixir |

---

## 🔗 Submódulos / Submodules

**ES:** El repositorio convive con **dos convenciones de estructura** mientras avanza la migración lenguaje por lenguaje:

- **Lenguajes homologados (submódulo):** ya migrados al estándar `core/{fase}/{módulo}/README.md` descrito en este sitio, con repositorio propio referenciado como submódulo Git (ver [`.gitmodules`](https://github.com/yorche3/programming_languages/blob/main/.gitmodules)).
- **Lenguajes en estructura legacy:** conservan la organización previa (carpetas planas `helloworld/`, `hellouser/`, `numbers/`, `words/`) directamente en el monorepo, sin submódulo. No tienen una fecha fija de migración — se homologan de forma incremental conforme el autor practica cada lenguaje.

**EN:** The repository lives with **two structure conventions** while the language-by-language migration progresses:

- **Homologated languages (submodule):** already migrated to the `core/{phase}/{module}/README.md` standard described on this site, with their own repository referenced as a Git submodule (see [`.gitmodules`](https://github.com/yorche3/programming_languages/blob/main/.gitmodules)).
- **Languages in legacy structure:** keep the previous layout (flat `helloworld/`, `hellouser/`, `numbers/`, `words/` folders) directly in the monorepo, without a submodule. There's no fixed migration date — they get homologated incrementally as the author practices each language.

> **ES:** Antes de crear o corregir documentación para un lenguaje, verifica si está en `.gitmodules` (homologado) o no (legacy) — la estructura y las plantillas aplicables difieren. Ver [`Plantilla_Agente.md`](Plantilla_Agente.md).
> **EN:** Before creating or fixing documentation for a language, check whether it's in `.gitmodules` (homologated) or not (legacy) — the applicable structure and templates differ. See [`Plantilla_Agente.md`](Plantilla_Agente.md).

```bash
# Clonar con submódulos / Clone with submodules
git clone --recurse-submodules https://github.com/yorche3/programming_languages.git

# Inicializar submódulos si ya clonaste / Initialize submodules if already cloned
git submodule update --init --recursive
```

---

## 🚀 Inicio rápido / Quick Start

**ES:** El punto de entrada recomendado es el documento [`01_Hello_World.md`](core/foundations/01_Hello_World.md). Allí encontrarás la primera especificación para implementar en el lenguaje que elijas.

**EN:** The recommended entry point is the [`01_Hello_World.md`](core/foundations/01_Hello_World.md) document. There you will find the first specification to implement in the language of your choice.

| Paso / Step | Acción / Action |
|-------------|----------------|
| 1️⃣ | Elige un lenguaje / Choose a language (e.g. `python/`) |
| 2️⃣ | Lee el `README.md` del lenguaje para instalar dependencias / Read the language's `README.md` to install dependencies |
| 3️⃣ | Sigue el flujo desde [`01_Hello_World.md`](core/foundations/01_Hello_World.md) / Follow the flow from `01_Hello_World.md` |
| 4️⃣ | Implementa, prueba y avanza al siguiente documento numerado / Implement, test, and advance to the next numbered document |

---

## 🗺️ Roadmap

**ES:** Consulta el [`ROADMAP.md`](ROADMAP.md) para ver el plan completo de desarrollo y el estado actual de cada módulo.

**EN:** Check the [`ROADMAP.md`](ROADMAP.md) for the complete development plan and current status of each module.

👉 **[Abrir ROADMAP.md →](ROADMAP.md)**

---

## 🔢 Flujo de implementación / Implementation Flow

**ES:** Los documentos de especificación están numerados secuencialmente. Así puedes seguir el camino de implementación sin perderte:

**EN:** The specification documents are numbered sequentially. This way you can follow the implementation path without getting lost:

```text
📂 docs/core/
├── README.md             ← Índice general / Main index
├── foundations/          ← Fase 0
│   ├── README.md         ← Índice / Index
│   ├── 01_Hello_World.md ← 🚀 INICIO / START
│   ├── 02_Hello_User.md
│   ├── 03_Unit_Test_Calculator.md
│   └── 04_Numbers.md
├── algorithms/           ← Fase 1 — Algoritmos Puros
│   ├── README.md
│   ├── 01_Sorting.md     ← naive_sort (O(n²))
│   └── ...
├── text/                 ← Fase 2 — Procesamiento Contiguo
│   ├── README.md
│   ├── 01_Transformations.md
│   └── ...
├── data/                 ← Fase 3 — Abstracción y Persistencia
│   └── README.md
└── math/                 ← Fase 4
    └── README.md
```

> **Consejo / Tip:** Si estás en GitHub Pages, usa la navegación del sitio. Si estás en el repositorio directamente, abre los archivos `.md` en orden numérico.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages)*