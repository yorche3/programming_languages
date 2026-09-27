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

`Node` es el único tipo de celda enlazada del módulo. `LinkedList`, `Stack` y `Queue` usan el mismo `Node(value, next)`, pero mantienen sus propios punteros y operaciones: `Stack` gestiona `top`; `Queue`, `front` y `rear`. Compartir el tipo de nodo no significa implementar una estructura envolviendo a `LinkedList`.

`Node` is the module's single linked-cell type. `LinkedList`, `Stack` and `Queue` use the same `Node(value, next)`, but keep their own pointers and operations: `Stack` manages `top`; `Queue`, `front` and `rear`. Sharing the node type does not mean implementing one structure by wrapping `LinkedList`.

El tipo puede llamarse `Node`, `Cell`, `Link` u otro nombre válido si existe un conflicto léxico. Su forma concreta puede ser un registro, una clase, un término, una unión algebraica o una representación equivalente del lenguaje.

The type may be called `Node`, `Cell`, `Link` or another valid name when there is a lexical conflict. Its concrete form may be a record, class, term, algebraic data type or equivalent language representation.

## 📐 Contrato común / Common contract

1. El módulo declara un único tipo nuevo `Node` y tipos nuevos para `LinkedList`, `Stack` y `Queue`. Las declaraciones no inicializan las instancias; antes de cualquier otra operación, cada valor debe pasar por su operación `init` (o equivalente idiomático): `Node.init(value)` o `LinkedList.init()`, `Stack.init()`, `Queue.init()`.
2. `Node` conserva su valor y permite observar o recorrer su enlace `Next`. La ausencia de enlace usa la representación nativa del lenguaje; no se fuerza `null`, `nil`, `-1` ni un tipo opcional nuevo.
3. Las operaciones conservan la semántica, el orden y la complejidad indicados. El indicador de éxito o fallo es el valor representable y no ambiguo que declare el README del lenguaje.
4. No se importan módulos previos ni posteriores para resolver este módulo. Cada ADT se implementa manualmente sobre el mismo tipo `Node`, sin delegar operaciones en `LinkedList`; las adaptaciones de mutabilidad, memoria e indicadores se documentan por lenguaje.
5. Los valores de prueba se eligen dentro del dominio entero que el lenguaje pueda representar sin confundirlos con el indicador de fallo. En Ada, por ejemplo, puede usarse `Natural`.

**ES:** `init` es el nombre conceptual uniforme. Si la convención del lenguaje expresa la inicialización como procedimiento, puede llamarse `Make` (como en Ada), pero conserva la misma obligación: declarar primero, inicializar una vez y solo después usar `is_empty` u otra operación.

**EN:** `init` is the uniform conceptual name. If the language convention expresses initialization as a procedure, it may be named `Make` (as in Ada), but preserves the same requirement: declare first, initialize once, and only then call `is_empty` or another operation.

1. The module declares one new `Node` type and new types for `LinkedList`, `Stack` and `Queue`. Declarations do not initialize instances; before any other operation, each value must pass through its `init` operation (or idiomatic equivalent): `Node.init(value)` or `LinkedList.init()`, `Stack.init()`, `Queue.init()`.
2. `Node` preserves its value and exposes or traverses its `Next` link. Link absence uses the language's native representation; `null`, `nil`, `-1` or a new optional type are not forced.
3. Operations preserve the stated semantics, order and complexity. Success and failure use a representable, unambiguous value documented in the language README.
4. Previous and later modules are not imported to solve this module. Each ADT is implemented manually over the same `Node` type, without delegating operations to `LinkedList`; adaptations for mutability, memory and indicators are documented per language.
5. Test values stay within the language's integer domain without colliding with its failure indicator. Ada may use `Natural`, for example.

## 🧩 Estructuras / Structures

| Estructura / Structure | Operaciones / Operations | Contrato observable / Observable contract | Complejidad / Complexity |
|---|---|---|---|
| `Node` | `init(value)`, `get_value()`, `get_next()`, `set_next(next)` | `init` asigna `value` y deja `next` ausente; `set_next` enlaza otro nodo o devuelve un nodo nuevo si el lenguaje es inmutable. Es el nodo compartido. | `O(1)` |
| `LinkedList` | `init()`, `get_head()`, `insert_head(value)`, `insert_tail(value)`, `delete(value)`, `is_empty()`, `size()` | `init` asigna cabeza/cola ausentes y tamaño cero. Tras `init`, `is_empty` informa si no contiene nodos; `get_head` devuelve el valor de la cabeza o el indicador de fallo si está vacía. Inserta en ambos extremos y elimina la primera aparición. | `init`, cabeza, cola, `get_head`, `is_empty`, `size`, inserciones: `O(1)`; `delete`: `O(n)` |
| `Stack` | `init()`, `push(value)`, `pop()`, `peek()`, `is_empty()`, `size()` | `init` asigna `top` ausente y tamaño cero. ADT LIFO independiente sobre `Node`; `top` señala el nodo más reciente y `next` enlaza con el anterior. | `init` y todas las operaciones: `O(1)` |
| `Queue` | `init()`, `enqueue(value)`, `dequeue()`, `peek()`, `is_empty()`, `size()` | `init` asigna `front`/`rear` ausentes y tamaño cero. ADT FIFO independiente sobre `Node`; `front` es el próximo en salir y `rear` el último insertado. | `init` y todas las operaciones: `O(1)` |

Las instancias se declaran primero **sin valores iniciales definidos por la especificación** y se inicializan mediante `init`: `Node.init(value)` asigna su valor y deja `next` ausente; las otras tres operaciones `init()` asignan sus enlaces ausentes y contadores a cero. `is_empty()` solo se invoca después de `init`; devuelve verdadero exactamente cuando el tamaño es cero y se vuelve falso tras insertar el primer elemento.

Instances are first declared **without values defined by this specification**, then initialized through `init`: `Node.init(value)` sets its value and leaves `next` absent; the other three `init()` operations set links to absent and counters to zero. Call `is_empty()` only after `init`; it returns true exactly when size is zero and becomes false after the first insertion.

## 📋 Política de resultados / Result policy

**ES:** El contrato fija **qué devuelve cada operación** para que los tests comparen comportamiento y no representación. El indicador concreto es el del lenguaje y se declara en su README.

**EN:** The contract fixes **what each operation returns** so tests compare behaviour and not representation. The concrete indicator is the language's and is declared in its README.

| Operación / Operation | Éxito / Success | Fallo / Failure | Efecto sobre el tamaño / Effect on size |
|---|---|---|---|
| `Node.init(value)` | Nodo con `value` y `Next` ausente | No aplica | — |
| `Node.get_value()`, `Node.get_next()` | Valor o enlace, que puede estar ausente | No aplica | No muta |
| `Node.set_next(next)` | Enlace actualizado, o nodo nuevo si el lenguaje es inmutable | No aplica | No cambia el tamaño de la estructura contenedora |
| `LinkedList.init()`, `Stack.init()`, `Queue.init()` | Inicializa todos sus enlaces ausentes y tamaño cero | No aplica | Establece tamaño `0` |
| `LinkedList.is_empty`, `Stack.is_empty`, `Queue.is_empty` | `true` después de `init`; `false` tras insertar al menos un elemento | Solo se invoca sobre una instancia inicializada | No mutan |
| `LinkedList.get_head()` | Valor de la cabeza | Indicador natural de fallo si la lista está vacía | No muta |
| `LinkedList.insert_head`, `insert_tail` | Inserta el nodo y aumenta `size()` en uno; operación sin resultado de fallo por límite | No hay límite de capacidad | `+1` |
| `LinkedList.delete` | Elimina la primera aparición y devuelve éxito | Devuelve el indicador natural de fallo si el valor no está | `−1` solo en éxito |
| `LinkedList.size`, `Stack.size`, `Queue.size` | Número de elementos desde la última inicialización | Solo se invocan sobre una instancia inicializada | No mutan |
| `Stack.push` | Coloca el valor sobre `top`; operación sin resultado de fallo por límite | No hay límite de capacidad | `+1` |
| `Stack.pop`, `peek` | `pop` extrae el tope; `peek` lo observa sin extraer | Devuelven el indicador natural de fallo si la pila está vacía | `pop`: `−1` en éxito; `peek`: no muta |
| `Queue.enqueue` | Añade el valor tras `rear`; operación sin resultado de fallo por límite | No hay límite de capacidad | `+1` |
| `Queue.dequeue`, `peek` | `dequeue` extrae `front`; `peek` lo observa sin extraer | Devuelven el indicador natural de fallo si la cola está vacía | `dequeue`: `−1` en éxito; `peek`: no muta |

`Stack` y `Queue` reutilizan el mismo `Node` de `LinkedList`; cada ADT solo mantiene sus propios punteros (`top` o `front`/`rear`) y contador. No hay tipos de nodo duplicados ni dependencia operacional de `LinkedList`.

`Stack` and `Queue` reuse the same `Node` as `LinkedList`; each ADT only keeps its own pointers (`top` or `front`/`rear`) and count. There are no duplicate node types or operational dependency on `LinkedList`.

## 🔌 Declaración del contrato / Contract declaration

**ES:** La especificación fija el **contrato** —operaciones, semántica, límites y complejidad—; cada lenguaje elige la **forma de declararlo**. No se exige ninguna construcción concreta: Ada lo hace con la *package specification*, C con un encabezado y un tipo opaco, Haskell con la lista de exportación del módulo, y un lenguaje con clases puede bastarse con la API pública de la clase. Declarar un tipo de contrato aparte (`interface`, `trait`, `protocol`, firma de módulo) solo tiene sentido cuando existe **más de una implementación real** de la misma abstracción; en esta fase hay una sola por estructura. La regla general y su calendario por fase están en [`AGENT_Template.md`](../../AGENT_Template.md).

**EN:** The specification fixes the **contract** —operations, semantics, limits and complexity—; each language chooses the **way to declare it**. No concrete construct is required: Ada does it with the *package specification*, C with a header and an opaque type, Haskell with the module's export list, and a language with classes may simply use the class's public API. Declaring a separate contract type (`interface`, `trait`, `protocol`, module signature) only makes sense when there is **more than one real implementation** of the same abstraction; in this phase there is a single one per structure. The general rule and its per-phase calendar are in [`AGENT_Template.md`](../../AGENT_Template.md).

## 🧠 Modelo conceptual / Conceptual model

```pseudocode
type Node
    value
    next

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
    head
    tail
    count

    init()
        head = absent
        tail = absent
        count = 0

    is_empty() = return count == 0
    size()     = return count

    get_head()
        if is_empty() return failure
        return head.value

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
    top
    count

    init()
        top = absent
        count = 0

    is_empty() = return count == 0
    size()     = return count

    push(value)
        node = Node.init(value)
        node.next = top
        top = node
        count = count + 1

    peek()
        if top is absent return failure
        return top.value

    pop()
        if top is absent return failure
        value = top.value
        top = top.next
        count = count - 1
        return value

type Queue
    front
    rear
    count

    init()
        front = absent
        rear = absent
        count = 0

    is_empty() = return count == 0
    size()     = return count

    enqueue(value)
        node = Node.init(value)
        if rear is absent
            front = node
        else
            rear.next = node
        rear = node
        count = count + 1

    peek()
        if front is absent return failure
        return front.value

    dequeue()
        if front is absent return failure
        value = front.value
        front = front.next
        if front is absent
            rear = absent
        count = count - 1
        return value
```

El pseudocódigo cubre **todas** las operaciones de la tabla, incluidos `get_head`, `is_empty` y `size`. Las tres estructuras usan `Node`, pero gestionan independientemente sus punteros y estado. No hay capacidad artificial ni delegación de Stack/Queue en LinkedList. Cada lenguaje adapta la construcción de una instancia vacía, la mutabilidad y la representación de ausencia, conservando las cotas de complejidad declaradas.

The pseudocode covers **every** operation in the table, including `get_head`, `is_empty` and `size`. All three structures use `Node` but independently manage their pointers and state. There is no artificial capacity and Stack/Queue do not delegate to LinkedList. Each language adapts empty-instance construction, mutability and absent-value representation while preserving the declared complexity bounds.

## 🧪 Casos de prueba / Test cases

Los casos de cada estructura son **pasos sucesivos sobre un mismo estado lógico**: se declara una instancia sin consultar sus campos y se invoca `init` una sola vez antes de continuar con la fila siguiente, sin reiniciar el escenario. En un lenguaje mutable se conserva la instancia; en uno inmutable se continúa con la estructura devuelta por `init` y las operaciones siguientes. Los valores son enteros positivos para no colisionar con el indicador natural de fallo. Las aserciones observan solo operaciones del contrato, no campos internos.

Cases for each structure are **successive steps on the same logical state**: declare an instance without inspecting its fields, call `init` once, then continue with the next row without resetting the scenario. A mutable language keeps the instance; an immutable one continues with the structure returned by `init` and the following operations. Values are positive integers so they do not collide with the natural failure indicator. Assertions use only contract operations, not internal fields.

### `Node`

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|---|---|---|
| Inicializar y observar valor/enlace<br>Initialize and observe value/link | Declarar `a`; `init(a, 10)` (`Make(a, 10)` en Ada) | `get_value(a)` = `10`; `get_next(a)` = ausencia nativa<br>`get_value(a)` = `10`; `get_next(a)` = native absence |
| Inicializar otro nodo, enlazar y recorrer<br>Initialize another node, link and traverse | Declarar `b`; `init(b, 20)`; `set_next(a, b)` | `get_value(get_next(a))` = `20`; el siguiente de `b` es ausente<br>`get_value(get_next(a))` = `20`; `b`'s next is absent |

### `LinkedList`

| Paso / Step | Operación sobre la misma lista / Operation on the same list | Resultado esperado / Expected result |
|---|---|---|
| Estado vacío<br>Empty state | Declarar la lista; `init()` (`Make(List)` en Ada); consultar `is_empty`, `size`, `get_head` | `true`, `0`, indicador natural de fallo |
| Insertar por ambos extremos<br>Insert at both ends | `insert_tail(10)`, `insert_tail(20)`, `insert_head(5)`, `insert_tail(10)` | `size()` = `4`; recorrido desde `get_head()` = `5, 10, 20, 10` |
| Eliminar primera aparición<br>Delete first occurrence | `delete(10)` | éxito; recorrido = `5, 20, 10`; `size()` = `3` |
| Valor ausente<br>Absent value | `delete(99)` | fallo; recorrido y tamaño no cambian |
| Vaciar<br>Empty the list | `delete(5)`, `delete(20)`, `delete(10)` | las tres tienen éxito; `is_empty()` = `true`; `size()` = `0`; `get_head()` = indicador natural de fallo |

### `Stack`

| Paso / Step | Operación sobre la misma pila / Operation on the same stack | Resultado esperado / Expected result |
|---|---|---|
| Estado vacío y extracción fallida<br>Empty state and failed removal | Declarar la pila; `init()` (`Make(S)` en Ada); consultar `is_empty`, `size`, `peek`; llamar `pop` | `true`, `0`; `peek` y `pop` devuelven el indicador natural de fallo |
| LIFO y `peek` no mutante<br>LIFO and non-mutating `peek` | `push(10)`, `push(20)`, `push(30)`, `peek()` | `peek()` = `30`; `size()` = `3` |
| Extracción y reutilización<br>Removal and reuse | `pop()`, `push(40)`, después tres `pop()` | resultados: `30`, `40`, `20`, `10`; al final `is_empty()` = `true`, `size()` = `0` |
| Vacío tras extracción<br>Empty after removal | `pop()` | fallo; `is_empty()` sigue `true` |

### `Queue`

| Paso / Step | Operación sobre la misma cola / Operation on the same queue | Resultado esperado / Expected result |
|---|---|---|
| Estado vacío y extracción fallida<br>Empty state and failed removal | Declarar la cola; `init()` (`Make(Q)` en Ada); consultar `is_empty`, `size`, `peek`; llamar `dequeue` | `true`, `0`; `peek` y `dequeue` devuelven el indicador natural de fallo |
| FIFO y `peek` no mutante<br>FIFO and non-mutating `peek` | `enqueue(10)`, `enqueue(20)`, `enqueue(30)`, `peek()` | `peek()` = `10`; `size()` = `3` |
| Extracción y reutilización<br>Removal and reuse | `dequeue()`, `enqueue(40)`, después tres `dequeue()` | resultados: `10`, `20`, `30`, `40`; al final `is_empty()` = `true`, `size()` = `0` |
| Vacío tras extracción<br>Empty after removal | `dequeue()` | fallo; `is_empty()` sigue `true` |

## ✅ Criterios de aceptación / Acceptance criteria

- [ ] Un único `Node` con `value` y `next` es compartido por `LinkedList`, `Stack` y `Queue`; cada ADT gestiona directamente sus punteros.
- [ ] Cada `Node` y estructura se inicializa explícitamente con `init` (o equivalente idiomático) antes de consultar `is_empty` o cualquier otra operación; no hay límite de capacidad.
- [ ] `LinkedList`, `Stack` y `Queue` implementan manualmente sus contratos; `Stack` y `Queue` no envuelven ni delegan operaciones en `LinkedList` ni en una colección estándar.
- [ ] Los tests recorren varias operaciones sobre la misma instancia de cada ADT y cubren su semántica y orden observable.
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