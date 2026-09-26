---
layout: default
title: 06 — Data Structures Basics
description: Sexta especificación / Sixth specification — Node, listas enlazadas, pilas y colas
nav_order: 2
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 06 — Data Structures Basics

> [← Volver a 05_Naive_Sort](05_Naive_Sort.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

## 🎯 Objetivo / Objective

| Español | English |
|---|---|
| Comprender `Node` como unidad mínima de una estructura enlazada y construir desde cero una lista enlazada, una pila y una cola. | Understand `Node` as the minimum unit of a linked structure and build a linked list, a stack and a queue from scratch. |

Este módulo enseña cómo un elemento enlaza con el siguiente y cómo una secuencia de `Node`s produce estructuras con distintos contratos de acceso. El objetivo es implementar la estructura, no sustituirla por una colección de la biblioteca estándar.

This module teaches how one element links to the next and how a sequence of `Node`s produces structures with different access contracts. The goal is to implement the structure, not replace it with a standard-library collection.

## 📖 Concepto: `Node` / Concept: `Node`

Un `Node` es un tipo nuevo con un valor y un enlace al siguiente `Node` o a la representación de ausencia del lenguaje. El recorrido pasa del nodo actual al nodo enlazado; una secuencia se construye encadenando esos enlaces.

A `Node` is a new type with a value and a link to the next `Node`, or to the language's absent representation. Traversal moves from the current node to its linked node; a sequence is built by chaining those links.

`Node` es obligatorio como concepto y como tipo equivalente. Puede llamarse `Node`, `Cell`, `Link` u otro nombre válido si existe un conflicto léxico. La forma concreta puede ser un registro, una clase, un término, una unión algebraica o una representación equivalente del lenguaje.

`Node` is mandatory as a concept and as an equivalent type. It may be called `Node`, `Cell`, `Link` or another valid name when a lexical conflict exists. The concrete form may be a record, class, term, algebraic data type or equivalent language representation.

## 📐 Contrato común / Common contract

1. Cada módulo declara un tipo nuevo para `Node` y para cada estructura. Los tests crean esas instancias mediante el constructor o procedimiento idiomático equivalente a `init`.
2. `Node` conserva su valor y permite observar o recorrer su enlace `Next`. La ausencia de enlace usa la representación nativa del lenguaje; no se fuerza `null`, `nil`, `-1` ni un tipo opcional nuevo.
3. Las operaciones conservan la semántica, el orden y la complejidad indicados. El indicador de éxito o fallo es el valor representable y no ambiguo que declare el README del lenguaje.
4. No se importan módulos previos ni posteriores para resolver este módulo. Las estructuras se implementan manualmente; las adaptaciones de mutabilidad, memoria, índices y retorno se documentan por lenguaje.
5. Los valores de prueba se eligen dentro del dominio entero que el lenguaje pueda representar sin confundirlos con el indicador de fallo. En Ada, por ejemplo, puede usarse `Natural`.

1. Each module declares a new type for `Node` and for every structure. Tests create those instances through the constructor or idiomatic procedure equivalent to `init`.
2. `Node` preserves its value and exposes or traverses its `Next` link. Link absence uses the language's native representation; `null`, `nil`, `-1` or a new optional type are not forced.
3. Operations preserve the stated semantics, order and complexity. Success and failure use a representable, unambiguous value documented in the language README.
4. Previous and later modules are not imported to solve this module. Structures are implemented manually; adaptations for mutability, memory, indices and returns are documented per language.
5. Test values stay within the language's integer domain without colliding with its failure indicator. Ada may use `Natural`, for example.

## 🧩 Estructuras / Structures

| Estructura / Structure | Operaciones / Operations | Contrato observable / Observable contract | Complejidad / Complexity |
|---|---|---|---|
| `Node` | `init(value)`, `get_value()`, `get_next()`, `set_next(next)` | Conserva `value`; `Next` comienza ausente; `set_next` enlaza con otro nodo o devuelve una estructura nueva si el lenguaje es inmutable. | `O(1)` |
| `LinkedList` | `init(capacity)`, `insert_head(value)`, `insert_tail(value)`, `delete(value)`, `search(value)`, `is_empty()`, `size()` | Secuencia de `Node`s. Inserta en ambos extremos, elimina la primera aparición y busca por recorrido desde la cabeza. | Cabeza y `size`: `O(1)`; `insert_tail`: `O(1)` con cola; `delete` y `search`: `O(n)` |
| `Stack` | `init(capacity)`, `push(value)`, `pop()`, `peek()`, `is_empty()`, `size()` | Usa `Node`s enlazados. Es LIFO: `push` y `pop` operan sobre la cabeza. | Operaciones principales: `O(1)` |
| `Queue` | `init(capacity)`, `enqueue(value)`, `dequeue()`, `peek()`, `is_empty()`, `size()` | Usa `Node`s enlazados. Es FIFO: inserta por la cola y extrae por la cabeza. | Operaciones principales: `O(1)` con cabeza y cola |

`capacity` es el máximo de elementos de la estructura. Una capacidad inválida deja la instancia inutilizable. Si una representación idiomática no puede expresar capacidad fija o un retorno ausente, el caso se marca como no representable y se justifica en el README del módulo, sin inventar un centinela.

`capacity` is the structure's maximum number of elements. An invalid capacity leaves the instance unusable. When an idiomatic representation cannot express fixed capacity or an absent return, the case is marked non-representable and justified in the module README, without inventing a sentinel.

## 🧠 Modelo conceptual / Conceptual model

```pseudocode
type Node
    value
    next = absent

    init(value)
    get_value()
    get_next()
    set_next(next)

type LinkedList
    head = absent
    tail = absent
    count = 0
    capacity

    insert_head(value)
        node = Node.init(value)
        node.next = head
        head = node
        if tail is absent
            tail = node
        count = count + 1

    insert_tail(value)
        node = Node.init(value)
        if tail is absent
            head = node
        else
            tail.next = node
        tail = node
        count = count + 1

    delete(value)
        previous = absent
        current = head
        while current is not absent
            if current.value == value
                unlink current from previous
                count = count - 1
                return success
            previous = current
            current = current.next
        return failure

type Stack
    list = LinkedList.init(capacity)
    push(value) = list.insert_head(value)
    pop() = remove and return list.head
    peek() = return list.head.value without removal

type Queue
    list = LinkedList.init(capacity)
    enqueue(value) = list.insert_tail(value)
    dequeue() = remove and return list.head
    peek() = return list.head.value without removal
```

El pseudocódigo muestra la relación conceptual; cada lenguaje adapta la sintaxis, la mutabilidad y la representación de ausencia. No autoriza a implementar `LinkedList` con la lista estándar del lenguaje.

The pseudocode shows the concept; each language adapts syntax, mutability and absence representation. It does not authorise implementing `LinkedList` with the language's standard list.

## 🧪 Casos de prueba / Test cases

Los tests se agrupan en dos niveles: primero el contrato de `Node`, después el contrato y comportamiento de cada estructura.

Tests have two levels: first the `Node` contract, then each structure's contract and behaviour.

| Grupo / Group | Casos mínimos / Minimum cases |
|---|---|
| `Node` | Crear con un valor; leer el valor; comprobar enlace inicialmente ausente; enlazar dos nodos; recorrer del primero al segundo; comprobar la adaptación inmutable si aplica. |
| `LinkedList` | Crear con capacidad válida e inválida; insertar en cabeza y cola; buscar valores presentes y ausentes; eliminar la primera aparición; eliminar un valor ausente; comprobar tamaño, vacío y límite de capacidad. |
| `Stack` | LIFO con tres valores; `peek` no elimina; `pop` en vacío; `push` con capacidad agotada; tamaño y vacío; capacidad inválida. |
| `Queue` | FIFO con tres valores; `peek` no elimina; `dequeue` en vacío; `enqueue` con capacidad agotada; reutilización de posiciones cuando aplica; tamaño y vacío; capacidad inválida. |
| No representables | Cada caso omitido se registra con `Omitido` y su motivo en el README; no se reemplaza por una prueba distinta. |

## ✅ Criterios de aceptación / Acceptance criteria

- [ ] `Node` es un tipo nuevo, se crea con el constructor idiomático y conserva valor y enlace.
- [ ] `LinkedList`, `Stack` y `Queue` se construyen desde `Node`, sin usar la colección estándar como sustituto.
- [ ] Los tests cubren el contrato de `Node`, la semántica, los límites y el orden observable de cada estructura.
- [ ] Cada indicador de éxito, fallo o caso no representable queda documentado por lenguaje.
- [ ] No existen imports hacia otros módulos del roadmap.
- [ ] El README del lenguaje sigue la plantilla, declara adaptaciones y enlaza la evidencia real.

## 📂 Ubicación esperada / Expected location

```text
{language}/core/algorithms/data_structures_basics/
├── src/
│   └── data_structures_basics.ext
└── test/
    ├── data_structures_basics_test.ext
    └── run_tests.ext
```

El layout real puede seguir las convenciones del lenguaje; toda desviación se declara en el README.

The real layout may follow the language's conventions; every deviation is declared in the README.

## ▶️ Siguiente / Next

👉 Sigue con [`07_Data_Structures_Advanced.md`](07_Data_Structures_Advanced.md).

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*