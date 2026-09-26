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
| `LinkedList` | `init(capacity)`, `insert_head(value)`, `insert_tail(value)`, `delete(value)`, `is_empty()`, `size()` | Secuencia de `Node`s. Inserta en ambos extremos y elimina la primera aparición recorriendo desde la cabeza. No declara consulta de pertenencia: la búsqueda sobre secuencias pertenece al módulo `searching`. | Cabeza, `is_empty` y `size`: `O(1)`; `insert_tail`: `O(1)` con cola; `delete`: `O(n)` |
| `Stack` | `init(capacity)`, `push(value)`, `pop()`, `peek()`, `is_empty()`, `size()` | Usa `Node`s enlazados. Es LIFO: `push` y `pop` operan sobre la cabeza. | Operaciones principales: `O(1)` |
| `Queue` | `init(capacity)`, `enqueue(value)`, `dequeue()`, `peek()`, `is_empty()`, `size()` | Usa `Node`s enlazados. Es FIFO: inserta por la cola y extrae por la cabeza. | Operaciones principales: `O(1)` con cabeza y cola |

`capacity` es el máximo de elementos de la estructura. Una capacidad inválida (menor que 1 o no representable) deja la instancia **inutilizable**, y ese estado es observable: `is_empty()` devuelve verdadero, `size()` devuelve cero y toda operación que inserte, elimine o extraiga devuelve el indicador de fallo del lenguaje. Si una representación idiomática no puede expresar capacidad fija o un retorno ausente, el caso se marca como no representable y se justifica en el README del módulo, sin inventar un centinela.

`capacity` is the structure's maximum number of elements. An invalid capacity (less than 1 or not representable) leaves the instance **unusable**, and that state is observable: `is_empty()` returns true, `size()` returns zero and every operation that inserts, deletes or extracts returns the language's failure indicator. When an idiomatic representation cannot express fixed capacity or an absent return, the case is marked non-representable and justified in the module README, without inventing a sentinel.

## 📋 Política de resultados / Result policy

**ES:** El contrato fija **qué devuelve cada operación** para que los tests comparen comportamiento y no representación. El indicador concreto es el del lenguaje y se declara en su README.

**EN:** The contract fixes **what each operation returns** so tests compare behaviour and not representation. The concrete indicator is the language's and is declared in its README.

| Operación / Operation | Éxito / Success | Fallo / Failure | Efecto sobre el tamaño / Effect on size |
|---|---|---|---|
| `Node.init(value)` | Nodo con `value` y `Next` ausente | No aplica | — |
| `Node.get_value()`, `Node.get_next()` | Valor o enlace, que puede estar ausente | No aplica | No muta |
| `Node.set_next(next)` | Enlace actualizado, o nodo nuevo si el lenguaje es inmutable | No aplica | No cambia el tamaño de la estructura contenedora |
| `LinkedList.insert_head`, `insert_tail` | Éxito | Fallo si `size() == capacity` o la instancia es inutilizable | `+1` solo en éxito |
| `LinkedList.delete` | Éxito | Fallo si el valor no está o la instancia es inutilizable | `−1` solo en éxito |
| `LinkedList.is_empty`, `size` | Verdadero o falso; número de elementos | No aplica: devuelve 0 en la instancia inutilizable | No mutan |
| `Stack.push`, `Queue.enqueue` | Éxito | Fallo si `size() == capacity` o la instancia es inutilizable | `+1` solo en éxito |
| `Stack.pop`, `Queue.dequeue` | Valor extraído de la cabeza | Fallo si la estructura está vacía o es inutilizable | `−1` solo en éxito |
| `Stack.peek`, `Queue.peek` | Valor de la cabeza, sin extraer | Fallo si la estructura está vacía o es inutilizable | No muta |

## 🔌 Declaración del contrato / Contract declaration

**ES:** La especificación fija el **contrato** —operaciones, semántica, límites y complejidad—; cada lenguaje elige la **forma de declararlo**. No se exige ninguna construcción concreta: Ada lo hace con la *package specification*, C con un encabezado y un tipo opaco, Haskell con la lista de exportación del módulo, y un lenguaje con clases puede bastarse con la API pública de la clase. Declarar un tipo de contrato aparte (`interface`, `trait`, `protocol`, firma de módulo) solo tiene sentido cuando existe **más de una implementación real** de la misma abstracción; en esta fase hay una sola por estructura. La regla general y su calendario por fase están en [`AGENT_Template.md`](../../AGENT_Template.md).

**EN:** The specification fixes the **contract** —operations, semantics, limits and complexity—; each language chooses the **way to declare it**. No concrete construct is required: Ada does it with the *package specification*, C with a header and an opaque type, Haskell with the module's export list, and a language with classes may simply use the class's public API. Declaring a separate contract type (`interface`, `trait`, `protocol`, module signature) only makes sense when there is **more than one real implementation** of the same abstraction; in this phase there is a single one per structure. The general rule and its per-phase calendar are in [`AGENT_Template.md`](../../AGENT_Template.md).

## 🧠 Modelo conceptual / Conceptual model

```pseudocode
type Node
    value
    next = absent

    init(value)
        this.value = value
        this.next = absent
        return this

    get_value() = return this.value
    get_next()  = return this.next

    set_next(next)
        this.next = next
        return this

type LinkedList
    head = absent
    tail = absent
    count = 0
    capacity
    usable = true

    init(capacity)
        if capacity is invalid
            this.usable = false
        this.capacity = capacity
        return this

    is_empty() = return count == 0
    size()     = return count
    can_insert() = return usable and count < capacity

    insert_head(value)
        if not can_insert() return failure
        node = Node.init(value)
        node.next = head
        head = node
        if tail is absent
            tail = node
        count = count + 1
        return success

    insert_tail(value)
        if not can_insert() return failure
        node = Node.init(value)
        if tail is absent
            head = node
        else
            tail.next = node
        tail = node
        count = count + 1
        return success

    delete(value)
        if not usable return failure
        previous = absent
        current = head
        while current is not absent
            if current.value == value
                if previous is absent
                    head = current.next
                else
                    previous.next = current.next
                if tail == current
                    tail = previous
                count = count - 1
                return success
            previous = current
            current = current.next
        return failure

type Stack
    # el tope es la cabeza de la lista
    list = LinkedList.init(capacity)

    is_empty() = return list.is_empty()
    size()     = return list.size()
    push(value) = return list.insert_head(value)

    peek()
        if list.is_empty() return failure
        return list.head.value

    pop()
        if list.is_empty() return failure
        value = list.head.value
        list.head = list.head.next
        if list.head is absent
            list.tail = absent
        list.count = list.count - 1
        return value

type Queue
    # la cabeza de la lista es el frente de la cola
    list = LinkedList.init(capacity)

    is_empty() = return list.is_empty()
    size()     = return list.size()
    enqueue(value) = return list.insert_tail(value)

    peek()
        if list.is_empty() return failure
        return list.head.value

    dequeue()
        if list.is_empty() return failure
        value = list.head.value
        list.head = list.head.next
        if list.head is absent
            list.tail = absent
        list.count = list.count - 1
        return value
```

El pseudocódigo cubre **todas** las operaciones de la tabla, incluidos `is_empty`, `size` y los límites de capacidad. `Stack` y `Queue` se componen sobre `LinkedList` y operan sobre su cabeza, que es el tope y el frente respectivamente. Cada lenguaje adapta la sintaxis, la mutabilidad y la representación de ausencia; el pseudocódigo no autoriza a implementar `LinkedList` con la lista estándar del lenguaje.

The pseudocode covers **every** operation in the table, including `is_empty`, `size` and the capacity limits. `Stack` and `Queue` compose over `LinkedList` and operate on its head, which is the top and the front respectively. Each language adapts syntax, mutability and absence representation; the pseudocode does not authorise implementing `LinkedList` with the language's standard list.

## 🧪 Casos de prueba / Test cases

Los tests se agrupan en dos niveles: primero el contrato de `Node`, después el contrato y comportamiento de cada estructura.

Tests have two levels: first the `Node` contract, then each structure's contract and behaviour.

| Grupo / Group | Casos mínimos / Minimum cases |
|---|---|
| `Node` | Crear con un valor; leer el valor; comprobar enlace inicialmente ausente; enlazar dos nodos; recorrer del primero al segundo; comprobar la adaptación inmutable si aplica. |
| `LinkedList` | Crear con capacidad válida e inválida; insertar en cabeza y cola; eliminar la primera aparición y un valor ausente; comprobar tamaño, vacío, límite de capacidad y el estado inutilizable de una capacidad inválida. |
| `Stack` | LIFO con tres valores; `peek` no elimina; `pop` en vacío; `push` con capacidad agotada; tamaño y vacío; capacidad inválida. |
| `Queue` | FIFO con tres valores; `peek` no elimina; `dequeue` en vacío; `enqueue` con capacidad agotada; reutilización de posiciones cuando aplica; tamaño y vacío; capacidad inválida. |
| No representables | Cada caso omitido se registra con `Omitido` y su motivo en el README; no se reemplaza por una prueba distinta. |

## ✅ Criterios de aceptación / Acceptance criteria

- [ ] `Node` es un tipo nuevo, se crea con el constructor idiomático y conserva valor y enlace.
- [ ] `LinkedList`, `Stack` y `Queue` se construyen desde `Node`, sin usar la colección estándar como sustituto.
- [ ] Los tests cubren el contrato de `Node`, la semántica, los límites y el orden observable de cada estructura.
- [ ] Cada operación declara su resultado de éxito y su resultado de fallo, y el pseudocódigo cubre todas las operaciones de la tabla, sin `…` ni «etc.».
- [ ] Cada indicador de éxito, fallo o caso no representable queda documentado por lenguaje.
- [ ] No se exige un tipo de contrato aparte (`interface`, `trait`, `protocol`) mientras haya una sola implementación; la forma elegida se declara en el README.
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