# 🌐 Lenguajes de Programación / Programming Languages (Monorepo)

Implementación de conceptos de programación basados en especificaciones generales y adaptaciones específicas para cada lenguaje de programación.

Implementation of programming concepts based on general specifications and specific adaptations for each programming language.

---

## 📖 Descripción / Description

Este monorepo tiene como objetivo proporcionar un entorno de aprendizaje y experimentación completo para varios lenguajes de programación. Contiene fundamentos de cada lenguaje hasta temas avanzados como microservicios, interfaces graficas y CI/CD enfocado en seguridad de código.

This monorepo aims to provide a comprehensive learning and experimentation environment for various programming languages. It covers fundamentals of each language up to advanced topics like microservices, GUIs and CI/CD focused on code security.

---

## 📁 Estructura / Structure

```text
programming_languages/
├── docs/ # Especificaciones, pseudocódigo y casos de prueba / Specification, pseudocode and test cases
├── programing_language_name/ # Implementaciones de cada lenguaje / Implementations of each language
...
```

Cada carpeta de lenguaje contiene su respectivo `Readme.md` con instrucciones detalladas de instalación y uso.


Each language folder contains its respective `Readme.md` with detailed installation and usage instructions.

---

## 🔗 Submódulos / Submodules

El repositorio convive con **dos convenciones de estructura** mientras avanza la migración lenguaje por lenguaje:

- **Lenguajes homologados (submódulo):** ya migrados al estándar `core/{fase}/{módulo}/README.md`, con repositorio propio referenciado como submódulo Git (ver [`.gitmodules`](.gitmodules)).
- **Lenguajes en estructura legacy:** conservan la organización previa (carpetas planas `helloworld/`, `hellouser/`, `numbers/`, `words/`) directamente en el monorepo, sin submódulo. Se homologan de forma incremental conforme se practica cada lenguaje.

The repository lives with **two structure conventions** while the language-by-language migration progresses:

- **Homologated languages (submodule):** already migrated to the `core/{phase}/{module}/README.md` standard, with their own repository referenced as a Git submodule (see [`.gitmodules`](.gitmodules)).
- **Languages in legacy structure:** keep the previous layout (flat `helloworld/`, `hellouser/`, `numbers/`, `words/` folders) directly in the monorepo, without a submodule. They get homologated incrementally as each language is practiced.

Para clonar el monorepo completamente con todos los submódulos usa el siguiente comando:

To clone the entire monorepo with all submodules use the following command:

```bash
git clone --recurse-submodules https://github.com/yorche3/programming_languages.git
```

Si ya tienes el monorepo clonado, pero no los submódulos, puedes inicializarlos con el siguiente comando:

If you already have the monorepo cloned, but not the submodules, you can initialize them with the following command:

```bash
git submodule update --init --recursive
```

Para actualizar los submódulos después de clonado el monorepo:

For updating the submodules after cloning the monorepo:

```bash
git submodule update --init --recursive
```

## 🚀 Uso rápido / Quick Start

1. Elige un lenguaje (por ejemplo `python/`) / Choose a language (e.g. `python/`)
2. Lee el archivo `README.md` para instalar las dependencias / Read the `README.md` to install the dependencies
3. Ejecuta el proyecto `helloworld` / Run the `helloworld` project

No hay una instalación global requerida. Cada lenguaje se configura y ejecuta de manera independiente.

There is no global installation required. Each language is configured and run independently.

## 📖 Documentación / Documentation

La documentación completa, incluyendo el roadmap, la estructura detallada y guías está disponible en la carpeta `docs` y en el sitio web del monorepo:

The complete documentation, including the roadmap, the detailed structure and guides is available in the `docs` folder and on the monorepo website:

👉 https://yorche3.github.io/programming_languages