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
| [`📄 README_Template.md`](README_Template.md) | Plantilla de README para sub-proyectos individuales / README template for individual sub-projects |
| [`🤖 AGENT_Template.md`](AGENT_Template.md) | Guía operativa para agentes de IA que documentan o corrigen el repo / Operational guide for AI agents documenting or fixing the repo |
| [`✅ ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) | Registro de cierres que autorizan actualizaciones del roadmap / Closure record authorizing roadmap updates |
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
│       ├── foundations/           # Fase 0 (01_ a 04_)
│       │   ├── README.md
│       │   ├── 01_Hello_World.md
│       │   ├── 02_Hello_User.md
│       │   ├── 03_Unit_Test_Calculator.md
│       │   └── 04_Numbers.md
│       ├── algorithms/            # Fase 1 — Algoritmos Puros (05_ a 10_)
│       │   ├── README.md
│       │   ├── 05_Naive_Sort.md
│       │   ├── 06_Data_Structures.md
│       │   ├── 07_Structures_Apps.md
│       │   ├── 08_Efficient_Sort.md
│       │   ├── 09_Distributed_Sort.md
│       │   └── 10_Searching.md
│       ├── text/                  # Fase 2 — Procesamiento Contiguo (11_ a 15_)
│       │   ├── README.md
│       │   └── ...
│       ├── structures/            # Fase 3 — Algoritmos sobre Estructuras (16_ a 19_)
│       │   ├── README.md
│       │   ├── 16_Graph_Algorithms.md
│       │   ├── 17_Backtracking.md
│       │   ├── 18_Dynamic_Programming.md
│       │   └── 19_Greedy.md
│       ├── data/                  # Fase 4 — Abstracción y Persistencia
│       │   └── README.md
│       └── math/                  # Fase 5 — Matemáticas
│           └── README.md
├── _experimental/                 # 🧪 Sandbox / Legacy Staging (primeros acercamientos)
├── python/                        # 🐍 Implementaciones Python (submódulo o legacy)
├── java/                          # ☕ Implementaciones Java (submódulo)
├── go/                            # 🔵 Implementaciones Go (submódulo)
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

## 🔗 Submódulos y Entornos / Submodules & Environments

**ES:** El repositorio organiza sus implementaciones en tres estados o niveles:

1. **Lenguajes homologados (submódulo Git):** Migrados formalmente a la jerarquía estándar `core/{fase}/{módulo}/` documentada en este sitio. Cuentan con repositorio independiente conectado como submódulo Git (ver [`.gitmodules`](https://github.com/yorche3/programming_languages/blob/main/.gitmodules)).
2. **Lenguajes en estructura legacy:** Conservan carpetas planas en la raíz (`helloworld/`, `hellouser/`, `numbers/`, `words/`) directamente en el monorepo sin submódulo. Se migran progresivamente al estándar.
3. **`_experimental/` (Sandbox & Legacy Staging):** Espacio donde se preserva el primer acercamiento experimental del autor con cada lenguaje (estructuras con `numbers/`, `words/`, `unit_test/demo/`). Funciona como banco de pruebas y archivo histórico de implementaciones previas a su homologación en `core/`.

**EN:** The repository organizes its implementations into three tiers:

1. **Homologated languages (Git submodule):** Formally migrated to the standardized `core/{phase}/{module}/` hierarchy documented on this site. They have their own repository linked as a Git submodule (see [`.gitmodules`](https://github.com/yorche3/programming_languages/blob/main/.gitmodules)).
2. **Languages in legacy structure:** Maintain flat folders at the root (`helloworld/`, `hellouser/`, `numbers/`, `words/`) directly in the monorepo without a submodule. They are incrementally migrated to the standard.
3. **`_experimental/` (Sandbox & Legacy Staging):** Space preserving the author's initial experimental exploration with each language (folders with `numbers/`, `words/`, `unit_test/demo/`). It acts as a sandbox and historical staging area prior to formal standardization in `core/`.

> **ES:** Antes de crear o corregir documentación para un lenguaje, verifica si está en `.gitmodules` (homologado), en la raíz (legacy) o en `_experimental/` — la estructura y las plantillas aplicables difieren. Ver [`AGENT_Template.md`](AGENT_Template.md).
> **EN:** Before creating or fixing documentation for a language, check whether it is in `.gitmodules` (homologated), in the root (legacy), or in `_experimental/` — the applicable structure and templates differ. See [`AGENT_Template.md`](AGENT_Template.md).

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

**ES:** Los documentos de especificación en **Core** siguen una numeración secuencial canónica (`01_`, `02_`, `03_`… hasta `19_`). Una vez dominada la base de Core, las fases de aplicación (**UI** y **Web**) pueden abordarse en paralelo, reiniciando su curva pedagógica desde el bootstrapping elemental de la interfaz hasta servicios reales:

**EN:** Specification documents in **Core** follow a canonical sequential numbering (`01_`, `02_`, `03_`… through `19_`). Once the Core foundation is mastered, the application tracks (**UI** and **Web**) can be tackled in parallel, restarting their pedagogical curve from elemental interface bootstrapping to real-world services:

```text
📂 docs/core/
├── README.md               ← Índice general / Main index
├── foundations/            ← Fase 0 (Sintaxis, E/S básica, testing, recursión)
│   ├── README.md
│   ├── 01_Hello_World.md   ← 🚀 INICIO / START
│   ├── 02_Hello_User.md
│   ├── 03_Unit_Test_Calculator.md
│   └── 04_Numbers.md
├── algorithms/             ← Fase 1 — Algoritmos Puros (arrays, centinelas, O(n²) a O(n log n))
│   ├── README.md
│   ├── 05_Naive_Sort.md
│   ├── 06_Data_Structures.md
│   ├── 07_Structures_Apps.md
│   ├── 08_Efficient_Sort.md
│   ├── 09_Distributed_Sort.md
│   └── 10_Searching.md
├── text/                   ← Fase 2 — Procesamiento Contiguo (strings, excepciones, I/O)
│   ├── README.md
│   ├── 11_Transformations.md
│   └── ... (hasta 15_ETL_Basico.md)
├── structures/             ← Fase 3 — Algoritmos sobre Estructuras (grafos, backtracking, DP, greedy)
│   ├── README.md
│   ├── 16_Graph_Algorithms.md
│   ├── 17_Backtracking.md
│   ├── 18_Dynamic_Programming.md
│   └── 19_Greedy.md
├── data/                   ← Fase 4 — Abstracción y Persistencia (Result/Option, BD, ORM)
│   └── README.md
└── math/                   ← Fase 5 — Matemáticas (estadística, álgebra lineal)
    └── README.md

🔀 Tracks Paralelos de Aplicación (post-Core o en paralelo):
├── UI (Fase 6)            ← Bootstrapping CLI/TUI/GUI → Menús con Core → Servicios CRUD (Exit Codes)
└── Web (Fase 7)           ← Servidor MVC/REST → Despacho a Core → APIs con persistencia (HTTP Status)
```

> **Consejo / Tip:** Si estás en GitHub Pages, usa la navegación del sitio. Si estás en el repositorio directamente, abre los archivos `.md` en orden numérico dentro de `docs/core/`.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages)*