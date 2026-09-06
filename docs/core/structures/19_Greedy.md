---
layout: default
title: 19 — Greedy
description: Decimonovena especificación / Nineteenth specification — Algoritmos voraces
nav_order: 4
parent: Algoritmos sobre Estructuras / Algorithms on Structures
grand_parent: Core
---

# 🚀 19 — Greedy

> [← Volver a 18_Dynamic_Programming](18_Dynamic_Programming.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Implementar algoritmos voraces (activity selection, fractional knapsack y coin change greedy) que toman la mejor decisión local en cada paso para construir la solución global, explicando cuándo la estrategia voraz es óptima. | Implement greedy algorithms (activity selection, fractional knapsack, and greedy coin change) that take the best local decision at each step to build the global solution, explaining when the greedy strategy is optimal. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `greedy` con un módulo que implemente los tres algoritmos. Los algoritmos usan el ordenamiento de la Fase 1 como herramienta (activity selection ordena por tiempo de finalización; fractional knapsack, por ratio valor/peso). Sin colecciones externas ni excepciones. | Create a `greedy` project with a module implementing the three algorithms. The algorithms use Phase 1 sorting as a tool (activity selection sorts by finish time; fractional knapsack by value/weight ratio). No external collections or exceptions. |

### Implementaciones esperadas

| Algoritmo | Descripción |
|-----------|-------------|
| `activity_selection(starts, finishes)` | Máximo número de actividades compatibles |
| `fractional_knapsack(weights, values, capacity)` | Valor máximo con fracciones permitidas |
| `coin_change_greedy(coins, amount)` | Monedas usadas con la estrategia voraz; `-1` si no forma el monto |

> **ES:** La estrategia voraz **no siempre es óptima** (p. ej., coin change con monedas no canónicas). Documenta en el README de la implementación un contraejemplo donde la estrategia falla.
> **EN:** The greedy strategy is **not always optimal** (e.g., coin change with non-canonical coin systems). Document in the implementation README a counterexample where the strategy fails.

### Pseudocódigo / Pseudocode

```pseudocode
container greedy
    .- activity_selection(starts, finishes)
        activities = sort by finishes ascending      # usa el sort de Fase 1
        count = 0
        last_finish = -INF
        for (start, finish) in activities
            if start >= last_finish
                count = count + 1
                last_finish = finish
        return count

    .- fractional_knapsack(weights, values, capacity)
        items = sort by (values[i] / weights[i]) descending
        total_value = 0
        for (weight, value) in items
            if capacity >= weight
                capacity = capacity - weight
                total_value = total_value + value
            else
                total_value = total_value + value * (capacity / weight)
                break
        return total_value

    .- coin_change_greedy(coins, amount)
        coins = sort descending
        used = 0
        for coin in coins
            while amount >= coin
                amount = amount - coin
                used = used + 1
        return amount == 0 ? used : -1
end container
```

### Casos de prueba / Test Cases

| Algoritmo | Entrada | Salida esperada |
|-----------|---------|----------------|
| `activity_selection` | starts=[1,3,0,5], finishes=[2,4,6,7] | 2 |
| `activity_selection` | starts=[0,1,3,5], finishes=[6,2,4,8] | 4 |
| `fractional_knapsack` | weights=[10,20,30], values=[60,100,120], capacity=50 | 240 |
| `coin_change_greedy` | coins=[1,5,10], amount=11 | 2 |
| `coin_change_greedy` | coins=[1,3,4], amount=6 (contraejemplo) | 3 (voraz) vs 2 (óptimo) |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Los algoritmos usan ordenamiento como preprocesamiento y toman decisiones locales.  
      **EN:** Algorithms use sorting as preprocessing and make local decisions.
- [ ] **ES:** Los casos sin solución devuelven `-1` (sentinela), sin excepciones.  
      **EN:** Cases without a solution return `-1` (sentinel), no exceptions.
- [ ] **ES:** El README documenta cuándo la estrategia voraz es óptima y un contraejemplo.  
      **EN:** The README documents when the greedy strategy is optimal and a counterexample.
- [ ] **ES:** El proyecto separa `src/` de `test/` y usa el framework de pruebas del lenguaje.  
      **EN:** The project separates `src/` from `test/` and uses the language's test framework.

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── structures/
            └── greedy/
                ├── src/
                │   └── greedy.ext
                └── test/
                    ├── greedy_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Continúa con [Fase 4 — Abstracción y Persistencia](../data/README.md).  
👉 Continue with [Phase 4 — Abstraction & Persistence](../data/README.md).

---

*[← Volver a Algoritmos sobre Estructuras](README.md) | [↑ Inicio](../../index.md)*
