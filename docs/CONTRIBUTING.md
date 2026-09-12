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

## 🌿 Flujo de ramas / Branch workflow

**ES:** `main` es la única rama de larga duración del monorepo. Las ramas de
trabajo son cortas, nacen de `main` y se integran en `main` después de revisión.
En cada submódulo se aplica la misma regla dentro de su propio repositorio.
No se debe asumir una rama `dev` como parte del flujo normativo.

**EN:** `main` is the only long-lived branch in the monorepo. Short-lived work
branches start from `main` and are integrated into `main` after review. The same
rule applies inside each submodule's own repository. A `dev` branch must not be
assumed as part of the normative workflow.

```text
main -> docs/<scope>, feat/<scope>, fix/<scope> -> review -> main
```

No se ejecuta `git push` ni se crea un commit automáticamente sin instrucción
explícita del autor / Do not run `git push` or create a commit automatically
without the author's explicit instruction.

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

1. **Trabajar en submódulo primero:** Si modificas código de un lenguaje, trabaja en una rama corta del submódulo, verifica sus tests y deja su `main` listo para revisión.
2. **Actualizar el puntero en el monorepo:** Vuelve a la raíz, actualiza el puntero del submódulo y registra el cambio con un commit `chore(submodule): ...` cuando el autor lo solicite.
3. **Integrar en `main`:** En la raíz, integra la rama corta después de verificar el estado del submódulo, la documentación y el roadmap.

## ✅ Cierre de documentación y roadmap / Documentation and roadmap closure

Una delegación de documentación no finaliza al generar un README. Debe
verificarse el código, ejecutar los tests disponibles, comprobar el README del
módulo y registrar la evidencia en
[`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md). Solo cuando el
módulo, o todos los módulos requeridos de una fase, están completos se actualiza
[`ROADMAP.md`](ROADMAP.md) en el mismo cambio.

A documentation delegation is not complete when a README is generated. Code,
tests, and the module README must be verified, with evidence recorded in
[`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md). Only after the
module, or every required module in a phase, is complete may
[`ROADMAP.md`](ROADMAP.md) be updated in the same change.

---

*[← Volver al inicio](index.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
