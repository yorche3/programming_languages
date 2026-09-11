---
layout: default
title: Algoritmos sobre Estructuras / Algorithms on Structures
description: Índice de la sección de algoritmos sobre estructuras — grafos, backtracking, programación dinámica, greedy / Index for the algorithms on structures section — graphs, backtracking, dynamic programming, greedy
nav_order: 4
parent: Core
grand_parent: Programming Languages Monorepo
has_children: true
---

# Algoritmos sobre Estructuras / Algorithms on Structures

> [← Volver a Core](../README.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 📖 Descripción / Description

**ES:** Algoritmos que aplican las estructuras construidas en la Fase 1 (árboles, grafos, pilas, colas) junto con los paradigmas de optimización. Siguen implementándose desde cero, con arrays y valores centinela (sin excepciones). Su complejidad supera la de los algoritmos de texto de la Fase 2, por lo que esta sección va después de ella.

**EN:** Algorithms that apply the structures built in Phase 1 (trees, graphs, stacks, queues) together with optimization paradigms. They are still implemented from scratch, with arrays and sentinel values (no exceptions). Their complexity exceeds the Phase 2 text algorithms, so this section comes after it.

---

## 📁 Especificaciones / Specifications

| Módulo | Estado | Tema |
|--------|--------|------|
| [`graph_algorithms`](16_Graph_Algorithms.md) | 📋 | BFS, DFS, Dijkstra, Prim, Kruskal, orden topológico, componentes conexas |
| [`backtracking`](17_Backtracking.md) | 📋 | N-Queens, permutaciones, subconjuntos, laberinto |
| [`dynamic_programming`](18_Dynamic_Programming.md) | 📋 | knapsack 0/1, coin change, LIS, caminos en grid |
| [`greedy`](19_Greedy.md) | 📋 | activity selection, fractional knapsack, coin change greedy |

---

## 🧭 Flujo recomendado / Recommended flow

1. `16_Graph_Algorithms.md`
2. `17_Backtracking.md`
3. `18_Dynamic_Programming.md`
4. `19_Greedy.md`

> **ES:** El heap de `efficient_sort` (Fase 1) se reutiliza como cola de prioridad en Dijkstra. `backtracking` prepara la recursión con retroceso del `parsing` de la Fase 4. DP y greedy son insumos de la capa de abstracción.
> **EN:** The heap from `efficient_sort` (Phase 1) is reused as a priority queue in Dijkstra. `backtracking` prepares the backtracking recursion of Phase 4's `parsing`. DP and greedy are inputs for the abstraction layer.

---

## ▶️ Siguiente / Next

👉 Continúa con [`graph_algorithms`](16_Graph_Algorithms.md).  
👉 Continue with [`graph_algorithms`](16_Graph_Algorithms.md).

---

*[← Volver a Core](../README.md) | [↑ Inicio](../../index.md)*
