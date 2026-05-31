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
| [`algorithms/`](algorithms/) | Fase 1 — Algoritmos Puros | ✅ | [`README.md`](algorithms/README.md) |
| [`text/`](text/) | Fase 2 — Procesamiento Contiguo | ✅ | [`README.md`](text/README.md) |
| [`data/`](data/) | Fase 3 — Abstracción y Persistencia | 📋 | [`README.md`](data/README.md) |
| [`math/`](math/) | Fase 4 | 📋 | [`README.md`](math/README.md) |

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

🔁 Flujo completo de trabajo paso a paso
1️⃣ Partir desde dev actualizada
bash

git switch dev
git pull origin dev   # actualiza dev con los últimos cambios remotos

2️⃣ Crear una nueva rama feature desde dev
bash

git switch -c feature/autenticacion   # ejemplo: feature/autenticacion

3️⃣ Trabajar en la feature (commits normales)
bash

# ... editas archivos ...
git add .
git commit -m "Añadir login básico"
git push -u origin feature/autenticacion   # primera subida (opcional)

4️⃣ Integrar la feature terminada en dev
Opción A – Merge directo (recomendada para features pequeñas)
bash

git switch dev
git pull origin dev                # aseguras dev actualizada
git merge --no-ff feature/autenticacion   # fusiona la feature
git push origin dev

Opción B – Con integración previa de dev en la feature (para evitar conflictos grandes)
bash

git switch feature/autenticacion
git merge dev                       # trae lo último de dev a tu feature
# (resuelves conflictos si los hay)
git add . && git commit -m "Merge dev into feature"
git switch dev
git merge --no-ff feature/autenticacion
git push origin dev

5️⃣ Eliminar la rama feature (local y remota)
bash

git branch -d feature/autenticacion
git push origin --delete feature/autenticacion

6️⃣ Cuando dev está estable, fusionarla a main
bash

git switch main
git pull origin main
git merge --no-ff dev
git push origin main