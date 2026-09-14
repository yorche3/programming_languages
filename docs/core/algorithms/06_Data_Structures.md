---
layout: default
title: 06 — Data Structures
description: Sexta especificación / Sixth specification — Construcción y contratos de estructuras fundamentales
nav_order: 2
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 06 — Data Structures

> [← Volver a 05_Naive_Sort](05_Naive_Sort.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Construir las estructuras fundamentales (**Stack**, **Queue**, **Linked List**, **Binary Tree** y **Graph**) sobre **arrays e índices** para comprender su representación, capacidad, invariantes y contratos. El objetivo del módulo es construir y verificar los ADTs; las aplicaciones posteriores pueden usar el ADT o colección optimizada del lenguaje cuando implementar la estructura ya no sea el objetivo. | Build fundamental data structures (**Stack**, **Queue**, **Linked List**, **Binary Tree**, and **Graph**) over **arrays and indices** to understand their representation, capacity, invariants, and contracts. This module's goal is to build and verify ADTs; later applications may use the language's optimized ADT or collection when implementing the structure is no longer the goal. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear `data_structures` como un paquete o módulo importable. Implementa las cinco estructuras usando arrays como almacenamiento interno y publica una API mínima. La suite de pruebas valida representación, overflow, underflow, límites, orden de extracción y resultados. Cada operación fallida devuelve el indicador compatible con el tipo; no lanza excepciones. | Create `data_structures` as an importable package or module. Implement the five structures using arrays as internal storage and expose a minimal API. The test suite validates representation, overflow, underflow, boundaries, removal order, and results. Every failed operation returns the type-compatible indicator; it does not throw exceptions. |

### Estructuras y Operaciones esperadas

| Estructura | Representación interna | Operaciones clave | Valor centinela |
|------------|------------------------|-------------------|:---------------:|
| `Stack` | Array + índice `top` | `push(val)`, `pop()`, `peek()`, `is_empty()` | `pop`/`peek` en vacío devuelve `-1`; `push` en lleno devuelve `-1` |
| `Queue` | Array circular + `head`, `tail`, `size` | `enqueue(val)`, `dequeue()`, `peek()`, `is_empty()` | `dequeue`/`peek` en vacío devuelve `-1`; `enqueue` en lleno devuelve `-1` |
| `LinkedList` | Arrays paralelos `values[]` y `next[]` | `insert_head(val)`, `insert_tail(val)`, `delete(val)`, `search(val)` | Elemento no encontrado devuelve `-1` |
| `BinaryTree` | Array 1D (hijo izq: $2i+1$, hijo der: $2i+2$) | `insert(val)`, `contains(val)`, `size()` | No encontrado devuelve `-1` o `false` |
| `Graph` | Matriz de adyacencia (`adj[u][v]`) con arrays | `add_edge(u, v)`, `has_edge(u, v)`, `get_neighbors(u)` | Nodo inexistente devuelve `-1` |

### Pseudocódigo / Pseudocode

```pseudocode
container array_stack
    .- init(capacity)
        storage = array(capacity, 0)
        top = -1
        max_cap = capacity

    .- push(val)
        if top >= max_cap - 1
            return -1              # overflow centinela
        top = top + 1
        storage[top] = val
        return 0                   # éxito

    .- pop()
        if top < 0
            return -1              # underflow centinela
        val = storage[top]
        top = top - 1
        return val

    .- peek()
        return top < 0 ? -1 : storage[top]
end container

container array_queue
    .- init(capacity)
        storage = array(capacity, 0)
        head = 0
        tail = 0
        count = 0
        max_cap = capacity

    .- enqueue(val)
        if count == max_cap
            return -1              # overflow
        storage[tail] = val
        tail = (tail + 1) % max_cap
        count = count + 1
        return 0

    .- dequeue()
        if count == 0
            return -1              # underflow
        val = storage[head]
        head = (head + 1) % max_cap
        count = count - 1
        return val
end container

container array_linked_list
    .- init(capacity)
        values = array(capacity, 0)
        next_ptr = array(capacity, -1)
        head_idx = -1
        free_idx = 0
        # enlazar libres: 0 -> 1 -> 2 -> ... -> -1
        for i = 0 to capacity - 2
            next_ptr[i] = i + 1
        next_ptr[capacity - 1] = -1

    .- insert_head(val)
        if free_idx == -1
            return -1              # lleno
        new_node = free_idx
        free_idx = next_ptr[free_idx]
        values[new_node] = val
        next_ptr[new_node] = head_idx
        head_idx = new_node
        return 0
end container
```

### Casos de prueba / Test Cases

| Estructura | Prueba | Operaciones | Salida esperada |
|------------|--------|-------------|----------------|
| `Stack` | Push y Pop LIFO | `push(10)`, `push(20)`, `pop()`, `pop()` | `20`, luego `10` |
| `Stack` | Underflow | `pop()` en pila vacía | `-1` |
| `Queue` | Enqueue y Dequeue FIFO | `enqueue(1)`, `enqueue(2)`, `dequeue()`, `dequeue()` | `1`, luego `2` |
| `Queue` | Circularidad | llenar, extraer 1, insertar 1 | Éxito sin desbordar |
| `LinkedList` | Inserción y búsqueda | `insert_head(5)`, `insert_tail(8)`, `search(8)` | Índice o valor encontrado; `search(99) == -1` |
| `BinaryTree` | Raíz e hijos | insertar 50, 30 (izq), 70 (der) | `contains(30) == true`, `contains(99) == false` |
| `Graph` | Aristas | `add_edge(0, 1)`, `has_edge(0, 1)` | `true`, `has_edge(1, 0) == false` (dirigido) |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Las cinco estructuras se modelan usando arrays e índices enteros como mecanismo de almacenamiento primario.  
      **EN:** All five structures are modeled using arrays and integer indices as primary storage mechanism.
- [ ] **ES:** Operaciones inválidas (underflow, overflow, nodo no encontrado) devuelven el indicador de fallo compatible con el lenguaje/API (por ejemplo, `-1` cuando el tipo lo permite), sin excepciones.
    **EN:** Invalid operations (underflow, overflow, node not found) return a language/API-compatible failure indicator (for example, `-1` when the type permits it), without exceptions.
- [ ] **ES:** Se implementa cola circular que reutiliza posiciones liberadas mediante aritmética modular.  
      **EN:** A circular queue is implemented reusing freed slots via modular arithmetic.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── algorithms/
            └── data_structures/
                ├── src/
                │   └── data_structures.ext
                └── test/
                    ├── data_structures_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`07_Efficient_Sort.md`](07_Efficient_Sort.md).
👉 Continue with [`07_Efficient_Sort.md`](07_Efficient_Sort.md).

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
