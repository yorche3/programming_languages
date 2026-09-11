---
layout: default
title: 🤝 Contributing
description: Guía de contribución y convención de commits / Contribution guide and commit convention
nav_order: 5
---

# 🤝 Guía de Contribución / Contributing Guide

> [← Volver al inicio / Back to home](index.md)

---

## 📖 Descripción / Description

| Español | English |
|---------|---------|
| Este proyecto sigue estándares estrictos de ingeniería de software para mantener un historial de control de versiones limpio, rastreable y automatizable en todo el monorepo y sus submódulos. | This project follows strict software engineering standards to maintain a clean, traceable, and automatable version control history across the entire monorepo and its submodules. |

---

## 📝 Convención de Commits / Conventional Commits

**ES:** Usamos [Conventional Commits](https://www.conventionalcommits.org/) v1.0.0. Cada mensaje de commit debe seguir esta estructura:

**EN:** We follow [Conventional Commits](https://www.conventionalcommits.org/) v1.0.0. Every commit message must adhere to this structure:

```text
tipo(alcance): asunto en imperativo, menos de 50 caracteres

Cuerpo del mensaje donde explicas el qué y el por qué del cambio,
no el cómo, ya que eso se ve en el código. Cada línea debe tener
un máximo de 72 caracteres para verse bien en cualquier terminal.

Footer opcional para referenciar incidencias o cambios importantes (BREAKING CHANGE).
```

---

## 🏷️ Tipos permitidos / Allowed Types

| Tipo / Type | Español | English |
|-------------|---------|---------|
| `feat` | Nueva funcionalidad o módulo implementado | New feature or module implemented |
| `fix` | Corrección de un error en código o pruebas | Bug fix in code or test suites |
| `docs` | Cambios o adiciones en la documentación (`docs/` o READMEs) | Documentation changes or additions (`docs/` or READMEs) |
| `style` | Formato, espacios, puntos y comas (sin cambios en lógica) | Formatting, whitespace, semi-colons (no logic change) |
| `refactor` | Reescritura de código sin alterar su comportamiento externo | Code rewrite without altering external behavior |
| `perf` | Optimización de rendimiento en algoritmos o I/O | Performance optimization in algorithms or I/O |
| `test` | Incorporación o corrección de suites de pruebas unitarias | Adding or correcting unit test suites |
| `chore` | Mantenimiento, submódulos, CI/CD, configuración de herramientas | Maintenance, submodules, CI/CD, tooling config |

---

## 🎯 Alcances recomendados / Recommended Scopes

**ES:** El alcance `(alcance)` es opcional pero altamente recomendado para situar el cambio:

- **Por fase:** `foundations`, `algorithms`, `text`, `structures`, `data`, `math`, `ui`, `web`
- **Por módulo:** `hello_world`, `calculator`, `numbers`, `naive_sort`, `data_structures`, `transformations`, etc.
- **Por infraestructura:** `submodule`, `ci`, `docker`, `docs`

---

## 💡 Ejemplos / Examples

```bash
# Documentación / Documentation
git commit -m "docs: update roadmap with Phase 3 structures specs" -m "Add continuous 01-19 numbering and document parallel application tracks."

# Nueva funcionalidad en lenguaje / New feature in a language
git commit -m "feat(numbers): implement recursive and iterative numbers in julia" -m "Add sum, factorial, fibonacci, gcd and lcm with 22 unit tests passing."

# Corrección en submódulo / Fix in submodule
git commit -m "fix(submodule): correct haxe repository URL in gitmodules"

# Refactorización / Refactoring
git commit -m "refactor(calculator): standardize package layout with Project.toml"
```

---

## 🔁 Flujo de Git / Git Workflow

1. **Trabajar en submódulo primero:** Si modificas código de un lenguaje, commitea y haz `git push` **dentro del repositorio del submódulo**.
2. **Actualizar el puntero en el monorepo:** Vuelve a la raíz de `programming_languages`, añade el directorio del submódulo (`git add <lenguaje>`) y crea un commit tipo `chore` o `feat`.
3. **Subir a rama `dev`:** En el monorepo raíz, publica siempre tus cambios en la rama `dev`:
   ```bash
   git push origin dev
   ```

---

*[← Volver al inicio](index.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
