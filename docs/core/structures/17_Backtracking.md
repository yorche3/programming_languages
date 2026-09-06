---
layout: default
title: 17 — Backtracking
description: Decimoséptima especificación / Seventeenth specification — Recursión con retroceso
nav_order: 2
parent: Algoritmos sobre Estructuras / Algorithms on Structures
grand_parent: Core
---

# 🚀 17 — Backtracking

> [← Volver a 16_Graph_Algorithms](16_Graph_Algorithms.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar algoritmos de recursión con retroceso (N-Queens, permutaciones, subconjuntos y laberinto) explorando el espacio de soluciones con una pila implícita de recursión, sin colecciones externas ni excepciones. | Implement backtracking recursion algorithms (N-Queens, permutations, subsets, and maze) exploring the solution space with an implicit recursion stack, without external collections or exceptions. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `backtracking` con un módulo que implemente los cuatro algoritmos. Cada exploración construye una solución parcial, avanza, y **retrocede** (deshace el último paso) cuando no es válida. Las búsquedas sin solución devuelven `-1`. | Create a `backtracking` project with a module implementing the four algorithms. Each exploration builds a partial solution, advances, and **backtracks** (undoes the last step) when invalid. Searches with no solution return `-1`. |

### Implementaciones esperadas

| Algoritmo | Descripción |
|-----------|-------------|
| `n_queens_count(n)` | Número de soluciones del problema de las N reinas |
| `permutations(list)` | Todas las permutaciones de una lista |
| `subsets(list)` | Todos los subconjuntos de una lista (potencia) |
| `maze_path(maze, start, end)` | Camino en un laberinto 2D; `-1` si no existe |

### Pseudocódigo / Pseudocode

```pseudocode
container backtracking
    .- n_queens_solve(board, row, n)
        if row == n
            return 1                       # solución encontrada
        count = 0
        for col = 0 to n - 1
            if is_safe(board, row, col)
                board[row] = col           # avanza
                count = count + n_queens_solve(board, row + 1, n)
                board[row] = -1            # retrocede
        return count

    .- permutations_help(current, remaining)
        if remaining is empty
            solutions.append(copy(current))
            return
        for each element in remaining
            current.append(element)
            permutations_help(current, remaining - element)   # avanza
            current.remove_last()                             # retrocede

    .- subsets_help(index, current, list)
        if index == size(list)
            solutions.append(copy(current))
            return
        subsets_help(index + 1, current, list)                # sin list[index]
        current.append(list[index])
        subsets_help(index + 1, current, list)                # con list[index]
        current.remove_last()

    .- maze_help(maze, x, y, end, visited)
        if (x, y) == end
            return true
        for (dx, dy) in [(1,0),(-1,0),(0,1),(0,-1)]
            nx, ny = x + dx, y + dy
            if inside(maze, nx, ny) and not wall(maze, nx, ny) and not visited[nx][ny]
                visited[nx][ny] = true
                if maze_help(maze, nx, ny, end, visited)
                    return true
                visited[nx][ny] = false    # retrocede
        return false
end container
```

### Casos de prueba / Test Cases

| Algoritmo | Entrada | Salida esperada |
|-----------|---------|----------------|
| `n_queens_count` | n=4 | 2 |
| `n_queens_count` | n=8 | 92 |
| `permutations` | `[1, 2, 3]` | 6 permutaciones |
| `subsets` | `[1, 2, 3]` | 8 subconjuntos |
| `maze_path` | laberinto 3×3 con camino libre | `true` (camino existe) |
| `maze_path` | laberinto 3×3 sin salida | `-1` / `false` (sentinela) |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Los algoritmos usan recursión con retroceso explícito (avanzar/deshacer), no fuerza bruta por enumeración completa.  
      **EN:** Algorithms use explicit backtracking recursion (advance/undo), not full brute-force enumeration.
- [ ] **ES:** Los casos sin solución devuelven `-1` o `false` (sentinela), sin excepciones.  
      **EN:** Cases without a solution return `-1` or `false` (sentinel), no exceptions.
- [ ] **ES:** El proyecto separa `src/` de `test/` y usa el framework de pruebas del lenguaje.  
      **EN:** The project separates `src/` from `test/` and uses the language's test framework.

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── structures/
            └── backtracking/
                ├── src/
                │   └── backtracking.ext
                └── test/
                    ├── backtracking_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`18_Dynamic_Programming.md`](18_Dynamic_Programming.md) — Optimización con tablas (knapsack, coin change, LIS).  
👉 Continue with [`18_Dynamic_Programming.md`](18_Dynamic_Programming.md) — Table-based optimization (knapsack, coin change, LIS).

---

*[← Volver a Algoritmos sobre Estructuras](README.md) | [↑ Inicio](../../index.md)*
