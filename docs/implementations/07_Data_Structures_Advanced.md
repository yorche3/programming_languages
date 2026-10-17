# 07 — Data Structures Advanced: cómo se implementa en cada familia
# 07 — Data Structures Advanced: how it is implemented in each family

> **ES:** Guía de implementación del módulo. Explica **cómo** y **por qué** el mismo contrato se escribe de forma distinta en cada familia de lenguajes. **No añade requisitos**: los criterios están en [`07_Data_Structures_Advanced.md`](../core/algorithms/07_Data_Structures_Advanced.md) y, si esta guía y la especificación discrepan, manda la especificación.
>
> **EN:** Implementation guide for the module. It explains **how** and **why** the same contract is written differently in each language family. It **adds no requirements**: the criteria live in [`07_Data_Structures_Advanced.md`](../core/algorithms/07_Data_Structures_Advanced.md) and, should this guide and the specification disagree, the specification wins.
>
> **ES:** El módulo **todavía no tiene implementaciones** en los 50 submódulos, así que esta guía se apoya en la especificación y **no incluye coste medido** ni fragmentos de código del repo. Se completará con datos reales cuando exista la primera implementación.
>
> **EN:** The module **has no implementations** in the 50 submodules yet, so this guide relies on the specification and **includes no measured cost** or repo code snippets. It will be completed with real data once the first implementation exists.

---

## 1. La solución canónica, en llano / The canonical solution, in plain words

**ES:** El módulo tiene tres piezas y una regla que las une:

- **`Node(value)`** es una base que **solo guarda el valor**. No tiene enlaces, no valida nada y no se instancia por sí sola: existe para declarar el valor una vez.
- **`TreeNode`** deriva de la base y añade `left`/`right`. El **ABB** mantiene la invariante «menores a la izquierda, mayores a la derecha»; `contains` baja por esa invariante, no recorre la estructura, y un duplicado **no** crea nodo ni aumenta `size`.
- **`GraphNode`** deriva de la base y añade su secuencia de vecinos, **ordenada y sin duplicados**. El **grafo** es dirigido, con etiquetas `0 … capacity - 1`; `size` cuenta **aristas distintas**, no vértices, y `is_empty` significa «no hay aristas».

**Lo que la especificación fija de verdad:** la base con el valor y sin validaciones, las invariantes del ABB y de la adyacencia, la capacidad como máximo de nodos o vértices, el estado **inutilizable** cuando la capacidad es inválida, un indicador de fallo por operación declarado en el README, y que la colección de biblioteca solo puede guardar vecinos —nunca sustituir el ADT—. **Lo que es solo forma:** si el valor se hereda o se embebe, si los enlaces se mutan o se reconstruyen, y cómo se representa la ausencia de enlace.

**EN:** The module has three pieces and one rule binding them: `Node(value)` is a base that **only holds the value** (no links, no validations, never instantiated); `TreeNode` derives from it and adds `left`/`right`, with the BST invariant driving `contains` and duplicates neither creating a node nor growing `size`; `GraphNode` derives from it and adds its neighbours, **sorted and unique**, in a directed graph labelled `0 … capacity - 1` where `size` counts **distinct edges** and `is_empty` means "no edges".

**What the specification actually fixes:** the value-only base, both invariants, capacity as the node/vertex maximum, the **unusable** state for an invalid capacity, one failure indicator per operation declared in the README, and the library collection as neighbour storage only. **What is just form:** inherited or embedded value, mutated or rebuilt links, and how link absence is represented.

---

## 2. Los ejes que cambian en este módulo / The axes that change here

| Eje / Axis | Pregunta / Question | Si sí / If yes | Si no / If no |
|---|---|---|---|
| **Reutilización del valor** | ¿El lenguaje tiene herencia entre tipos de dato? | **A1**: `Node` como base real y `TreeNode`/`GraphNode` derivados | **A2**: el valor se declara **dentro** del nodo hijo (valor embebido) y no hay tipo base |
| **Mutabilidad de los enlaces** | ¿Se puede escribir `node.left = x`? | El ABB inserta enlazando y el grafo añade a la adyacencia | Cada operación devuelve árbol o grafo nuevos; la inserción reconstruye el camino |
| **Ausencia del enlace** | ¿Hay representación nativa de «no hay hijo»? | Se usa tal cual (`null`, `nil`, `None`, `Nothing`, `#f`, `()`) | Se declara la representación equivalente en el README |
| **Capacidad** | ¿La estructura puede rechazar altas? | `capacity` como máximo; capacidad inválida deja la instancia **inutilizable** y observable (`is_empty` = true, `size` = 0) | — |
| **Vecinos** | ¿Se puede usar una lista de la biblioteca? | Solo como **almacenamiento** de la adyacencia; las operaciones del grafo siguen siendo propias | La adyacencia se implementa entera a mano |

**ES:** El primer eje es el tema nuevo del módulo, y no cambia el coste: cambia **dónde vive el valor**. El segundo sí cambia el coste de escritura: en un lenguaje inmutable, insertar en un ABB reconstruye el camino desde la raíz y devuelve un árbol nuevo.
**EN:** The first axis is the module's new topic, and it does not change cost: it changes **where the value lives**. The second does change the cost of writing: in an immutable language, inserting into a BST rebuilds the path from the root and returns a new tree.

> **ES:** **A1**, **A2** y **A3** son las formas **de este módulo**: describen dónde vive el valor y quién escribe el enlace. **No** son las variantes `V1`–`V4` de [`PSEUDOCODE_CONVENTION.md`](../ruleset/PSEUDOCODE_CONVENTION.md), que describen cómo se escribe el contrato entero (mutable, inmutable, mixto, lógico).
>
> **EN:** **A1**, **A2** and **A3** are this module's **forms**: they describe where the value lives and who writes the link. They are **not** the `V1`–`V4` variants of [`PSEUDOCODE_CONVENTION.md`](../ruleset/PSEUDOCODE_CONVENTION.md), which describe how the whole contract is written (mutable, immutable, mixed, logical).

---

## 3. Las familias: cómo definen la base y los enlaces / The families: how they define the base and the links

| Familia / Family | Cómo define la base `Node(value)` / How it defines the base | Qué puede mutar / What it may mutate | Ausencia del enlace / Link absence | Forma / Form |
|---|---|---|---|---|
| **F1** OO con null | Clase base con el valor; los hijos añaden campos | Campos de la instancia | Referencia nula | A1 |
| **F2** Scripting dinámico | Objeto base o simplemente el campo en el hijo | Campos del objeto | Valor nulo del lenguaje | A2 habitual, A1 posible |
| **F3** C-lineage | No hay tipo base: el valor es el primer campo del nodo hijo | Registro y punteros | Puntero nulo | A2 |
| **F4** Sistemas modernos | Registro con el valor y enlaces en el mismo tipo, u opción nativa | El registro, si el tipo lo permite | Ausencia tipada del lenguaje | A2 (o A1 si hay clases) |
| **F5** Funcional ML/Haskell | Tipo base con solo el valor y subtipos por registro o tipo algebraico; a menudo el valor es un campo compartido | Nada | Opción nativa, solo en el enlace | A1 por subtipado, A2 por campo |
| **F6** Lisp | Clase base (CLOS) o registro; el valor es un campo | Solo con celdas mutables explícitas | Lista vacía, falso o nulo | A1 en CLOS; A2 en registro |
| **F7** BEAM | Registro con el valor y los enlaces juntos | Nada | Valor ausente del dominio | A2 |
| **F8** Multi-paradigma | Depende del tipo: clase base o registro | Según el tipo | Según el tipo | A1 o A2, declarada en el README |
| **F9** Lógico | El valor es el primer argumento del término | Nada | Fallo de unificación | A2 + A3 |

**ES:** Ninguna familia cambia **qué** se guarda: un valor y, en el hijo, sus enlaces. Lo que cambia es si el valor se hereda de un tipo base o se declara dentro del hijo. En las familias sin herencia, la forma A2 **no es una emulación**: es la forma natural de escribir el mismo contrato.
**EN:** No family changes **what** is stored: a value and, in the child, its links. What changes is whether the value is inherited from a base type or declared inside the child. In families without inheritance, form A2 is **not an emulation**: it is the natural way to write the same contract.

---

## 4. Las variaciones, en pseudocódigo / The variations, in pseudocode

### 4.1 A1: base con herencia / A1: base with inheritance

**ES:** El valor se declara una vez en la base y los hijos **añaden** sus enlaces. Las validaciones viven en el hijo: la base no tiene nada que validar.
**EN:** The value is declared once in the base and the children **add** their links. Validations live in the child: the base has nothing to validate.

```pseudocode
type Node                       # base: solo el valor, nunca se instancia
    value

    init(value)
        this.value = value
        return this

    get_value() = return this.value

type TreeNode extends Node      # hijo: añade enlaces y valida
    left  = absent
    right = absent

    init(value)
        super(value)            # o el equivalente del lenguaje
        this.left  = absent
        this.right = absent
        return this

    set_left(node)  -> this.left  = node
    set_right(node) -> this.right = node

type GraphNode extends Node
    neighbours = absent         # secuencia ordenada y sin duplicados
```

```pseudocode
insert(root, value)              # ABB: baja por la invariante y enlaza
    root == absent          -> TreeNode.init(value)
    value < root.value      -> root.left  = insert(root.left, value)
    value > root.value      -> root.right = insert(root.right, value)
    value == root.value     -> root            # duplicado: no crea nodo
```

### 4.2 A2: valor embebido, sin tipo base / A2: embedded value, no base type

**ES:** Donde no hay herencia, el valor es **un campo más** del nodo hijo. El contrato no cambia: `init(value)` sigue fijando el valor y la ausencia de enlaces, y las validaciones siguen en el hijo.
**EN:** Where there is no inheritance, the value is **just another field** of the child node. The contract does not change: `init(value)` still sets the value and the absent links, and validations stay in the child.

```pseudocode
type TreeNode
    value                       # el valor, embebido
    left  = absent
    right = absent

    init(value)
        this.value = value
        this.left  = absent
        this.right = absent
        return this

type GraphNode
    value                       # la etiqueta del vértice
    neighbours = absent
```

**ES:** La diferencia con 4.1 se ve en una línea: en A1 el hijo **no repite** `value`; en A2 lo declara. El resto —invariante, capacidad, vecinos, indicadores— es idéntico.
**EN:** The difference from 4.1 shows in one line: in A1 the child **does not repeat** `value`; in A2 it declares it. Everything else — invariant, capacity, neighbours, indicators — is identical.

### 4.3 A3: enlaces que no se mutan, el árbol se reconstruye / A3: links that are not mutated, the tree is rebuilt

**ES:** Si los enlaces son inmutables, `insert` no escribe: **devuelve** un árbol nuevo con el camino reconstruido. `contains` sigue bajando por la invariante y no cambia.
**EN:** If the links are immutable, `insert` does not write: it **returns** a new tree with the path rebuilt. `contains` still descends along the invariant and does not change.

```pseudocode
insert(tree, value)
    tree == empty           -> node(init(value))
    value < value(tree)     -> tree(left = insert(left(tree), value))
    value > value(tree)     -> tree(right = insert(right(tree), value))
    value == value(tree)    -> tree                 # duplicado: sin cambios

contains(tree, value)                               # lectura, igual en A1, A2 y A3
    tree == empty        -> failure
    value == value(tree) -> success
    value <  value(tree) -> contains(left(tree),  value)
    value >  value(tree) -> contains(right(tree), value)
```

**ES:** La capacidad y los indicadores no cambian de forma: el árbol nuevo conserva `count` y `capacity`, y el rechazo por capacidad se decide **antes** de reconstruir nada.
**EN:** Capacity and indicators do not change shape: the new tree keeps `count` and `capacity`, and a capacity rejection is decided **before** rebuilding anything.

### 4.4 A3 en la familia lógica: el árbol como relación / A3 in the logical family: the tree as a relation

**ES:** Donde no hay estructuras ni campos, el nodo es un **término** y el enlace es un argumento: la invariante vive en las cláusulas, no en un campo. La ausencia de hijo es `empty`; un duplicado no crea término nuevo, igual que en A1.
**EN:** Where there are no structures or fields, the node is a **term** and the link is an argument: the invariant lives in the clauses, not in a field. A missing child is `empty`; a duplicate creates no new term, just as in A1.

```pseudocode
nodo(Valor, Izq, Der).

insertar(empty, V, nodo(V, empty, empty)).
insertar(nodo(R, I, D), V, nodo(R, I2, D)) :- V < R, insertar(I, V, I2).
insertar(nodo(R, I, D), V, nodo(R, I, D2)) :- V > R, insertar(D, V, D2).
insertar(nodo(R, I, D), V, nodo(R, I, D))   :- V =:= R.        # duplicado: sin cambio

pertenece(nodo(R, _, _), V) :- V =:= R.
pertenece(nodo(R, I, _), V) :- V < R, pertenece(I, V).
pertenece(nodo(R, _, D), V) :- V > R, pertenece(D, V).
```

**ES:** La capacidad se comprueba **antes** de insertar (contando términos o con un argumento de cota), y el grafo se escribe igual con `arista(U, V)` y una relación de vecinos ordenada. Lo que no cambia es el contrato: misma invariante, mismo resultado y la misma obligación de declarar la representación en el README.
**EN:** Capacity is checked **before** inserting (counting terms or with a bound argument), and the graph is written the same way with `arista(U, V)` plus an ordered neighbour relation. The contract does not change: same invariant, same result and the same duty to declare the representation in the README.

---

**ES:** En las cuatro formas se guarda lo mismo y se responde lo mismo; lo que se mueve es **dónde vive el valor** (base o hijo) y **quién escribe el enlace** (la estructura o el valor devuelto).
**EN:** All four forms store the same and answer the same; what moves is **where the value lives** (base or child) and **who writes the link** (the structure or the returned value).

---

## 5. Consecuencias, leídas desde el pseudocódigo / Consequences, read from the pseudocode

**ES:** El coste se lee del propio pseudocódigo:

- **La base no cuesta nada.** `Node` solo asigna y lee un valor: ni tiempo ni memoria extra. Su papel es de contrato, no de rendimiento.
- **El ABB paga la altura.** `insert` y `contains` bajan un nivel por comparación: `O(h)`. Con datos ordenados el árbol degenera y `h` tiende a `n`, así que el peor caso es `O(n)`; la especificación no pide balanceo y el README debe declararlo.
- **El grafo paga el grado.** `add_edge` y `has_edge` recorren o insertan en la adyacencia ordenada de `u`: `O(d(u))`. `init` reserva la estructura de vértices: `O(V)`.
- **La capacidad es una comprobación.** Rechazar un alta es `O(1)` y ocurre antes de tocar la estructura; por eso una instancia inutilizable se comporta igual en todas las formas.
- **La inmutabilidad se paga en asignaciones.** En 4.3, insertar reconstruye `h` nodos: mismo `O(h)` en comparaciones, pero `O(h)` asignaciones por inserción.

**EN:** Cost reads off the pseudocode: the base costs nothing (contract, not performance); the BST pays height (`O(h)`, degenerating to `O(n)` without balancing, which the README must declare); the graph pays degree (`O(d(u))` for `add_edge`/`has_edge`, `O(V)` in `init`); the capacity check is `O(1)` and happens before touching the structure; and form 4.3 pays `O(h)` allocations per insertion on top of the same `O(h)` comparisons.

---

## 6. Trampas para quien llega nuevo / Traps for newcomers

- **La base no valida.** Si `Node` empieza a comprobar enlaces o a devolver indicadores, el contrato se ha movido al sitio equivocado: cada hijo valida lo suyo.
- **El `Node` del 07 no es el del 06.** Uno es `value + next` y pertenece a otro contrato; aquí la base tiene **solo** el valor y no se importa nada del módulo anterior.
- **Capacidad no es tamaño.** `capacity` es el máximo; `size` es lo ocupado. Un duplicado del ABB es **éxito** aunque el árbol esté lleno, porque no crea nodo.
- **`Graph.size` cuenta aristas, no vértices.** Y `is_empty` significa «sin aristas»: un grafo con vértices y ninguna arista está vacío por contrato.
- **La adyacencia va ordenada y sin duplicados.** Si se acepta una arista repetida, `size` deja de ser el número de aristas distintas.
- **`contains` es del ABB, no una búsqueda lineal.** Bajar por la invariante es lo que hace que el módulo enseñe el árbol y no una lista.
- **La lista de biblioteca es almacenamiento, no algoritmo.** Guardar vecinos en una colección está permitido; delegarle el recorrido o el alta de aristas, no.
- **La instancia inutilizable es observable.** No es un error silencioso: `is_empty` devuelve verdadero, `size` cero y las operaciones, el indicador declarado.
- **Sin balanceo, el árbol puede degenerar.** Es una consecuencia aceptada del módulo; se documenta en el README, no se «arregla» con una estructura de biblioteca.

---

## 7. Dónde seguir / Where next

| Capa / Layer | Documento / Document |
|---|---|
| Qué se exige / What is required | [`07_Data_Structures_Advanced.md`](../core/algorithms/07_Data_Structures_Advanced.md) |
| Las familias en general / Families in general | [`PARADIGM_FAMILIES.md`](../ruleset/PARADIGM_FAMILIES.md) |
| Qué obliga tu lenguaje / What your language mandates | [`idioms/{lang}.md`](../ruleset/idioms/) |
