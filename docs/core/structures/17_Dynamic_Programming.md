---
layout: default
title: 17 — Dynamic Programming
description: Decimoséptima especificación / Seventeenth specification — Programación dinámica con tablas
nav_order: 3
parent: Algoritmos sobre Estructuras / Algorithms on Structures
grand_parent: Core
---

# 🚀 17 — Dynamic Programming

> [← Volver a 16_Backtracking](16_Backtracking.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar algoritmos de programación dinámica (LCS, knapsack 0/1, coin change, LIS y caminos en grid) descomponiendo el problema en subproblemas superpuestos y almacenando resultados en **tablas indexables** (secuencias indexables de enteros), sin colecciones externas ni excepciones. LCS enlaza la fase de strings con el modelo de estado bidimensional de DP. | Implement dynamic programming algorithms (LCS, 0/1 knapsack, coin change, LIS, and grid paths) by decomposing the problem into overlapping subproblems and storing results in **indexable tables** (indexable sequences of integers), without external collections or exceptions. LCS connects the string phase to DP's two-dimensional state model. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `dynamic_programming` con un módulo que implemente los cinco algoritmos usando tabulación (bottom-up) con **secuencias indexables** (ver [`04_Numbers.md`](../foundations/04_Numbers.md)), cuya representación es libre y se declara en el README. Los problemas sin solución devuelven `-1` (sentinela). | Create a `dynamic_programming` project with a module implementing the five algorithms using bottom-up tabulation with **indexable sequences** (see [`04_Numbers.md`](../foundations/04_Numbers.md)), whose representation is free and is declared in the README. Problems with no solution return `-1` (sentinel). |

### Implementaciones esperadas

| Algoritmo | Descripción |
|-----------|-------------|
| `longest_common_subsequence(left, right)` | Longitud de la subsecuencia común más larga (LCS) entre dos strings/secuencias indexables |
| `knapsack_01(weights, values, capacity)` | Valor máximo del problema de la mochila 0/1 |
| `coin_change(coins, amount)` | Mínimo número de monedas; `-1` si no se puede formar |
| `longest_increasing_subsequence(list)` | Longitud de la subsecuencia creciente más larga (LIS) |
| `grid_paths(n, m, obstacles)` | Número de caminos en una rejilla `n × m` con obstáculos |

### Pseudocódigo / Pseudocode

```pseudocode
container dynamic_programming
    .- longest_common_subsequence(left, right)
        dp = sequence(size(left) + 1, size(right) + 1, 0)
        for i = 1 to size(left)
            for j = 1 to size(right)
                if left[i - 1] == right[j - 1]
                    dp[i][j] = dp[i - 1][j - 1] + 1
                else
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
        return dp[size(left)][size(right)]

    .- knapsack_01(weights, values, capacity)
        n = size(weights)
        dp = sequence(n + 1, capacity + 1, 0)
        for i = 1 to n
            for c = 0 to capacity
                if weights[i - 1] <= c
                    dp[i][c] = max(dp[i - 1][c],
                                   values[i - 1] + dp[i - 1][c - weights[i - 1]])
                else
                    dp[i][c] = dp[i - 1][c]
        return dp[n][capacity]

    .- coin_change(coins, amount)
        dp = sequence(amount + 1, INF)     # INF como "no alcanzable"
        dp[0] = 0
        for i = 1 to amount
            for coin in coins
                if coin <= i and dp[i - coin] != INF
                    dp[i] = min(dp[i], dp[i - coin] + 1)
        return dp[amount] == INF ? -1 : dp[amount]

    .- longest_increasing_subsequence(list)
        n = size(list)
        dp = sequence(n, 1)
        for i = 0 to n - 1
            for j = 0 to i - 1
                if list[j] < list[i] and dp[j] + 1 > dp[i]
                    dp[i] = dp[j] + 1
        return max(dp)

    .- grid_paths(n, m, obstacles)
        dp = sequence(n, m, 0)
        dp[0][0] = obstacles[0][0] ? 0 : 1
        for i = 0 to n - 1
            for j = 0 to m - 1
                if obstacles[i][j]
                    dp[i][j] = 0
                else
                    dp[i][j] = dp[i][j]
                             + (i > 0 ? dp[i - 1][j] : 0)
                             + (j > 0 ? dp[i][j - 1] : 0)
        return dp[n - 1][m - 1]
end container
```

### Casos de prueba / Test Cases

| Algoritmo | Entrada | Salida esperada |
|-----------|---------|----------------|
| `longest_common_subsequence` | `"ABCBDAB"`, `"BDCABA"` | 4 |
| `longest_common_subsequence` | `"abc"`, `"def"` | 0 |
| `knapsack_01` | weights=[2,3,4], values=[4,5,8], capacity=5 | 9 |
| `knapsack_01` | weights=[3,2], values=[6,5], capacity=1 | 0 |
| `coin_change` | coins=[1,5,10], amount=11 | 2 |
| `coin_change` | coins=[2], amount=3 | -1 |
| `longest_increasing_subsequence` | [10,9,2,5,3,7,101,18] | 4 |
| `grid_paths` | 3×3 sin obstáculos | 6 |
| `grid_paths` | 3×3 con obstáculo en (1,1) | 2 |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Las soluciones usan tabulación bottom-up con **secuencias indexables** (no memoización global ni colecciones externas).
      **EN:** Solutions use bottom-up tabulation with **indexable sequences** (no global memoization or external collections).
- [ ] **ES:** Los casos sin solución devuelven `-1` (sentinela), sin excepciones.  
      **EN:** Cases without a solution return `-1` (sentinel), no exceptions.
- [ ] **ES:** El proyecto separa `src/` de `test/` y usa el framework de pruebas del lenguaje.  
      **EN:** The project separates `src/` from `test/` and uses the language's test framework.

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── structures/
            └── dynamic_programming/
                ├── src/
                │   └── dynamic_programming.ext
                └── test/
                    ├── dynamic_programming_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`18_Greedy.md`](18_Greedy.md) — Algoritmos voraces (activity selection, fractional knapsack).  
👉 Continue with [`18_Greedy.md`](18_Greedy.md) — Greedy algorithms (activity selection, fractional knapsack).

---

*[← Volver a Algoritmos sobre Estructuras](README.md) | [↑ Inicio](../../index.md)*
