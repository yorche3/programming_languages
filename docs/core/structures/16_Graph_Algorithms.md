---
layout: default
title: 16 — Graph Algorithms
description: Decimosexta especificación / Sixteenth specification — Algoritmos de grafos con arrays y valores centinela
nav_order: 1
parent: Algoritmos sobre Estructuras / Algorithms on Structures
grand_parent: Core
---

# 🚀 16 — Graph Algorithms

> [← Volver a Algoritmos sobre Estructuras](README.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar los algoritmos clásicos de grafos (BFS, DFS, Dijkstra, Prim, Kruskal, orden topológico y componentes conexas) sobre grafos representados con listas de adyacencia basadas en arrays, usando únicamente las estructuras construidas en `data_structures` y valores centinela para los casos "no alcanzable". | Implement classic graph algorithms (BFS, DFS, Dijkstra, Prim, Kruskal, topological sort, and connected components) over graphs represented with array-based adjacency lists, using only the structures built in `data_structures` and sentinel values for "unreachable" cases. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `graph_algorithms` con un módulo `graph` que represente grafos con listas de adyacencia construidas desde arrays, y que implemente los algoritmos listados abajo. Los nodos no alcanzables devuelven el valor centinela `-1`. Sin excepciones. | Create a `graph_algorithms` project with a `graph` module representing graphs with array-built adjacency lists and implementing the algorithms below. Unreachable nodes return the sentinel value `-1`. No exceptions. |

### Implementaciones esperadas

| Algoritmo | Estructura clave | Descripción |
|-----------|------------------|-------------|
| `bfs(graph, start)` | queue | Recorrido en anchura; devuelve distancias desde `start` (`-1` si no alcanzable) |
| `dfs(graph, start)` | stack (o recursión) | Recorrido en profundidad; devuelve orden de visita |
| `dijkstra(graph, start)` | priority queue (heap) | Caminos mínimos en grafos con pesos no negativos |
| `prim(graph)` | priority queue (heap) | Árbol de expansión mínimo (MST) |
| `kruskal(graph)` | union-find (arrays) | MST por aristas ordenadas |
| `topological_sort(graph)` | stack / indegree | Orden topológico de un DAG (`-1` si hay ciclo) |
| `connected_components(graph)` | queue / stack | Número de componentes conexas |

> **ES:** La cola de prioridad se implementa reutilizando el heap de `efficient_sort` (Fase 1). La representación del grafo es una lista de adyacencia: `adjacency_list[u] = [(v, weight), ...]` construida desde arrays de aristas.
> **EN:** The priority queue reuses the heap from `efficient_sort` (Phase 1). The graph representation is an adjacency list: `adjacency_list[u] = [(v, weight), ...]` built from edge arrays.

### Pseudocódigo / Pseudocode

```pseudocode
container graph
    .- bfs(adjacency_list, start)
        distance = array(size(adjacency_list), -1)   # sentinela
        distance[start] = 0
        queue.enqueue(start)
        while queue is not empty
            u = queue.dequeue()
            for (v, _) in adjacency_list[u]
                if distance[v] == -1
                    distance[v] = distance[u] + 1
                    queue.enqueue(v)
        return distance

    .- dfs(adjacency_list, start)
        visited = array(size(adjacency_list), false)
        order = []
        stack.push(start)
        while stack is not empty
            u = stack.pop()
            if not visited[u]
                visited[u] = true
                order.append(u)
                for (v, _) in adjacency_list[u]
                    if not visited[v]
                        stack.push(v)
        return order

    .- dijkstra(adjacency_list, start)
        distance = array(size(adjacency_list), INF)
        distance[start] = 0
        pq = priority_queue()
        pq.push((0, start))
        while pq is not empty
            (dist_u, u) = pq.pop()
            if dist_u > distance[u]
                continue
            for (v, weight) in adjacency_list[u]
                new_dist = dist_u + weight
                if new_dist < distance[v]
                    distance[v] = new_dist
                    pq.push((new_dist, v))
        return distance      # INF -> -1 al retornar

    .- prim(adjacency_list)
        ...                 # MST: crecer el árbol con la arista mínima

    .- kruskal(edges, n)
        ...                 # ordenar aristas por peso + union-find

    .- topological_sort(adjacency_list)
        ...                 # Kahn (indegree) o DFS; -1 si detecta ciclo

    .- connected_components(adjacency_list)
        ...                 # contar componentes con BFS/DFS
end container
```

### Casos de prueba / Test Cases

| Algoritmo | Entrada | Salida esperada |
|-----------|---------|----------------|
| `bfs` | grafo de 5 nodos, aristas `(0,1),(0,2),(1,3)`, start=0 | `[0,1,1,2,-1]` |
| `dfs` | mismo grafo, start=0 | visita todos los alcanzables, 4 nodos |
| `dijkstra` | pesos: `(0,1,4),(0,2,1),(2,1,2),(1,3,1)`, start=0 | `[0,3,1,4]` |
| `prim` | grafo completo de 4 nodos con pesos dados | peso total 7 |
| `kruskal` | mismas aristas | peso total 7 |
| `topological_sort` | DAG 5→2, 5→0, 4→0, 4→1, 2→3 | orden válido con 5 antes de 2 y 3 después de 2 |
| `topological_sort` | grafo con ciclo 0→1→0 | `-1` (sentinela de ciclo) |
| `connected_components` | dos componentes: {0,1,2}, {3,4} | 2 |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Todos los algoritmos se implementan con estructuras array-backed (sin colecciones externas).  
      **EN:** All algorithms use array-backed structures (no external collections).
- [ ] **ES:** Los casos "no alcanzable"/"ciclo" devuelven `-1` (valores centinela, sin excepciones).  
      **EN:** "Unreachable"/"cycle" cases return `-1` (sentinel values, no exceptions).
- [ ] **ES:** Dijkstra usa la cola de prioridad basada en el heap de Fase 1.  
      **EN:** Dijkstra uses the priority queue based on the Phase 1 heap.
- [ ] **ES:** El proyecto separa `src/` de `test/` y usa el framework de pruebas del lenguaje.  
      **EN:** The project separates `src/` from `test/` and uses the language's test framework.

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── structures/
            └── graph_algorithms/
                ├── src/
                │   └── graph.ext                 # Módulo de grafos
                └── test/
                    ├── graph_test.ext            # Suite de pruebas
                    └── run_tests.ext             # Punto de entrada
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`17_Backtracking.md`](17_Backtracking.md) — Recursión con retroceso (N-Queens, permutaciones, laberinto).  
👉 Continue with [`17_Backtracking.md`](17_Backtracking.md) — Backtracking recursion (N-Queens, permutations, maze).

---

*[← Volver a Algoritmos sobre Estructuras](README.md) | [↑ Inicio](../../index.md)*
