---
layout: default
title: 🧱 Core
description: Índice principal de la documentación base / Main index for the core documentation
nav_order: 1
has_children: true
---

# 🧱 Core

> [← Volver al inicio / Back to home](../index.md)

---

## 📖 Descripción / Description

**ES:** El directorio `core/` contiene las especificaciones base del monorepo. Está organizado por fases de aprendizaje y cada subcarpeta tiene su propio índice.

**EN:** The `core/` directory contains the monorepo's base specifications. It is organized by learning phases and each subfolder has its own index.

---

## 📁 Secciones / Sections

| Sección | Fase | Estado | Índice |
|---------|------|--------|--------|
| [`foundations/`](foundations/) | Fase 0 | ✅ | [`README.md`](foundations/README.md) |
| [`algorithms/`](algorithms/) | Fase 1 — Algoritmos Puros | 🔄 | [`README.md`](algorithms/README.md) |
| [`text/`](text/) | Fase 2 — Procesamiento Contiguo | 📋 | [`README.md`](text/README.md) |
| [`structures/`](structures/) | Fase 3 — Algoritmos sobre Estructuras | 📋 | [`README.md`](structures/README.md) |
| [`data/`](data/) | Fase 4 — Abstracción y Persistencia | 📋 | [`README.md`](data/README.md) |
| [`math/`](math/) | Fase 5 — Matemáticas | 📋 | [`README.md`](math/README.md) |

---

## 🎯 Propósito / Purpose

**ES:** Esta carpeta define qué debe aprenderse y en qué orden. Las implementaciones reales se realizan en los submódulos de cada lenguaje.

**EN:** This folder defines what should be learned and in which order. The actual implementations are done in each language submodule.

---

## ▶️ Siguiente / Next

👉 Empieza en [`foundations/README.md`](foundations/README.md).  
👉 Start at [`foundations/README.md`](foundations/README.md).

---

*[← Volver al inicio](../index.md)*

## 🔁 Flujo completo de trabajo / Complete workflow

1. Partir desde `main` actualizada / Start from updated `main`.

```bash
git switch main
git pull origin main
```

2. Crear una rama corta / Create a short-lived branch.

```bash
git switch -c docs/actualizar-readme
```

3. Trabajar, verificar y registrar evidencia / Work, verify, and record evidence.

```bash
git diff --check
git status --short
```

Para cerrar un módulo o fase, completa
[`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md) y actualiza
`ROADMAP.md` solo con código, tests y documentación verificados.

4. Integrar después de revisión / Integrate after review.

```bash
git switch main
git merge --no-ff docs/actualizar-readme
```

Las mismas reglas se aplican dentro de cada submódulo. No se presupone una
rama intermedia; los cambios se integran desde ramas cortas a `main`.