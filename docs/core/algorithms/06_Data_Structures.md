---
layout: default
title: 06 — Data Structures
description: Sexta especificación / Sixth specification — Estructuras fundamentales (Stack, Queue, LinkedList, Tree, Graph) con arrays
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
| Construir las estructuras de datos fundamentales (**Stack**, **Queue**, **Linked List**, **Binary Tree** y **Graph**) modeladas directamente sobre **arrays e índices**, comprendiendo la mecánica de memoria subyacente y empleando valores centinela (`-1`) para manejar condiciones de desbordamiento (overflow) o subdesbordamiento (underflow) sin excepciones. | Build fundamental data structures (**Stack**, **Queue**, **Linked List**, **Binary Tree**, and **Graph**) modeled directly on **arrays and indices**, understanding underlying memory mechanics and using sentinel values (`-1`) to handle overflow and underflow conditions without exceptions. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `data_structures` que contenga las cinco estructuras de datos clásicas implementadas usando arrays como almacenamiento de memoria interno. Cada operación devuelve `-1` cuando falla (pila/cola vacía al extraer, o llena al insertar en capacidad fija). | Create a `data_structures` project containing the five classic data structures implemented using arrays as internal memory storage. Each operation returns `-1` when it fails (empty stack/queue on extraction, or full on fixed-capacity insertion). |

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

👉 Sigue con [`07_Structures_Apps.md`](07_Structures_Apps.md) — Aplicaciones directas de estructuras sobre arrays (paréntesis, RPN, recorridos).  
👉 Continue with [`07_Structures_Apps.md`](07_Structures_Apps.md) — Direct applications of array-based structures (parentheses, RPN, traversals).

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
