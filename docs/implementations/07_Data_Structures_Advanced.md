# 07 — Data Structures Advanced: cómo se implementa en cada familia
# 07 — Data Structures Advanced: how it is implemented in each family

> **ES:** Guía de implementación del módulo. Explica **cómo** y **por qué** el mismo contrato se escribe de forma distinta en cada familia de lenguajes. **No añade requisitos**: los criterios están en [`07_Data_Structures_Advanced.md`](../core/algorithms/07_Data_Structures_Advanced.md) y, si esta guía y la especificación discrepan, manda la especificación.
>
> **EN:** Implementation guide for the module. It explains **how** and **why** the same contract is written differently in each language family. It **adds no requirements**: the criteria live in [`07_Data_Structures_Advanced.md`](../core/algorithms/07_Data_Structures_Advanced.md) and, should this guide and the specification disagree, the specification wins.
>
> **ES:** Esta guía se apoya en el contrato corregido el **2026-10-24** y **no incluye coste medido** ni certifica las implementaciones existentes o en ramas de trabajo. Contratos, suites y READMEs basados en capacidad requieren revisión separada antes del cierre.
>
> **EN:** This guide follows the contract corrected on **2026-10-24** and **includes no measured cost** or certification of existing implementations or working branches. Capacity-based contracts, suites and READMEs need a separate review before closure.

---

## 1. La solución canónica, en llano / The canonical solution, in plain words

**ES:** El módulo tiene tres piezas y una regla que las une:

- **`Node(value)`** es una base que **solo guarda el valor**. No tiene enlaces, no valida nada y no se instancia por sí sola: existe para declarar el valor una vez.
- **`TreeNode`** deriva de la base y añade `left`/`right`. El **ABB** mantiene la invariante «menores a la izquierda, mayores a la derecha»; `contains` baja por esa invariante, no recorre la estructura, y un duplicado **no** crea nodo ni aumenta `size`.
- **`GraphNode`** deriva de la base y añade su secuencia de vecinos, **ordenada y sin duplicados**, y el enlace al siguiente vértice del registro canónico. El **grafo** es dirigido, con vértices explícitos y etiquetas enteras no necesariamente consecutivas. `vertex_count` cuenta vértices, `edge_count` aristas distintas e `is_empty` significa «no hay vértices».

**Lo que la especificación fija de verdad:** la base con valor y sin validaciones,
la invariante ABB, vértices explícitos, extremos existentes para añadir aristas y
contadores separados. No hay capacidad contractual ni estado lleno/inutilizable.
Las aristas duplicadas son idempotentes y los bucles están permitidos. Los vecinos
ordenados son una decisión determinista del módulo, no la definición de grafo.
La colección de biblioteca solo guarda vecinos, nunca sustituye el ADT.
**Lo que es forma:** valor heredado o embebido, enlaces mutables o reconstruidos
y representación de ausencia.

**EN:** `Node(value)` only holds the value, without links, validations or direct
instances. `TreeNode` adds `left`/`right`; BST membership follows the invariant
and duplicates do not grow size. `GraphNode` adds sorted unique neighbours and
the canonical vertex-registry link. The directed graph has explicit vertices
with nonconsecutive integer labels, separate `vertex_count` and `edge_count`,
and `is_empty` means no vertices.

**What the specification fixes:** value-only base, BST invariant, explicit vertices,
existing endpoints for edges and separate counts. No contractual capacity or
full/unusable state. Duplicate edges are idempotent and self-loops allowed.
Sorted neighbours are a module policy, not the definition of a graph. A library
collection stores neighbours only, never replaces the ADT. **What is form:**
inherited or embedded value, mutated or rebuilt links and absence representation.

---

## 2. Los ejes que cambian en este módulo / The axes that change here

| Eje / Axis | Pregunta / Question | Si sí / If yes | Si no / If no |
|---|---|---|---|
| **Reutilización del valor** | ¿El lenguaje tiene herencia entre tipos de dato? | **A1**: `Node` como base real y `TreeNode`/`GraphNode` derivados | **A2**: el valor se declara **dentro** del nodo hijo (valor embebido) y no hay tipo base |
| **Mutabilidad de los enlaces** | ¿Se puede escribir `node.left = x`? | El ABB inserta enlazando y el grafo añade a la adyacencia | Cada operación devuelve árbol o grafo nuevos; la inserción reconstruye el camino |
| **Ausencia del enlace** | ¿Hay representación nativa de «no hay hijo»? | Se usa tal cual (`null`, `nil`, `None`, `Nothing`, `#f`, `()`) | Se declara la representación equivalente en el README |
| **Registro de vértices / Vertex registry** | ¿Cómo localizar una etiqueta sin asumir índices? / How to locate a label without assuming indices? | Registro enlazado propio, recorrido `O(V)` / Own linked registry, `O(V)` traversal | No se precrean vértices ni se impone capacidad / No precreated vertices or imposed capacity |
| **Vecinos** | ¿Se puede usar una lista de la biblioteca? | Solo como **almacenamiento** de la adyacencia; las operaciones del grafo siguen siendo propias | La adyacencia se implementa entera a mano |

**ES:** Estos ejes no conceden excepciones nuevas: la especificación exige el
registro global y su búsqueda manuales en todas las familias, sin `Map`, `Dict`,
`HashMap`, `Set` ni equivalentes de biblioteca. La lista permitida solo almacena
vecinos; recorrer, detectar duplicados e insertar en orden sigue siendo trabajo
propio. Un término o registro persistente adapta los enlaces, no delega el
algoritmo en una colección.

**EN:** These axes grant no new exceptions: the specification requires a manual
global registry and lookup in every family, without library maps, dictionaries,
hash maps, sets or equivalents. The permitted list only stores neighbours;
traversal, duplicate detection and sorted insertion remain own code. Terms or
persistent records adapt links, not delegate the algorithm to a collection.

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
    next_vertex = absent        # registro de vértices
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
    next_vertex = absent
```

**ES:** La diferencia con 4.1 se ve en una línea: en A1 el hijo **no repite** `value`; en A2 lo declara. El resto —invariante, vértices, vecinos, indicadores— es idéntico.
**EN:** The difference from 4.1 shows in one line: in A1 the child **does not repeat** `value`; in A2 it declares it. Everything else — invariant, vertices, neighbours, indicators — is identical.

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

**ES:** El árbol nuevo conserva los valores previos y actualiza `count` solo
para un valor nuevo; no hay cota que comprobar. El grafo inmutable devuelve el
registro reconstruido con sus contadores: `add_vertex` conserva las adyacencias,
y una arista con extremo inexistente falla sin cambiar el valor original.
**EN:** The new tree preserves previous values and updates `count` only for a new
value; no capacity check exists. An immutable graph returns the rebuilt registry
with its counts: `add_vertex` preserves adjacency, and a missing-endpoint edge
fails without changing the original value.

### 4.4 A2 + A3 en la familia lógica: el árbol como relación / A2 + A3 in the logical family: the tree as a relation

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

**ES:** El grafo necesita representar tanto `vertice(U)` como `arista(U,V)`:
deducir los vértices solo de las aristas perdería los aislados. La relación de
vecinos es ordenada y sin duplicados; se comprueban ambos extremos antes de
crear una arista. El valor devuelto conserva contadores, invariantes y datos
previos, sin cota artificial; el README declara la representación.
**EN:** A graph needs both `vertex(U)` and `edge(U,V)`: inferring vertices only
from edges would lose isolated vertices. Neighbours are sorted and unique;
check both endpoints before adding an edge. The returned value preserves counts,
invariants and existing data without an artificial bound; declare representation
in the README.

---

**ES:** En las cuatro formas se guarda lo mismo y se responde lo mismo; lo que se mueve es **dónde vive el valor** (base o hijo) y **quién escribe el enlace** (la estructura o el valor devuelto).
**EN:** All four forms store the same and answer the same; what moves is **where the value lives** (base or child) and **who writes the link** (the structure or the returned value).

---

## 5. Consecuencias, leídas desde el pseudocódigo / Consequences, read from the pseudocode

**ES:** El coste se lee del propio pseudocódigo:

- **La base no cuesta nada.** `Node` solo asigna y lee un valor: ni tiempo ni memoria extra. Su papel es de contrato, no de rendimiento.
- **El ABB paga la altura.** `insert` y `contains` bajan un nivel por comparación: `O(h)`. Con datos ordenados el árbol degenera y `h` tiende a `n`, así que el peor caso es `O(n)`; la especificación no pide balanceo y el README debe declararlo.
- **El grafo paga localizar y recorrer.** El registro enlazado localiza etiquetas
  en `O(V)`; después recorre la adyacencia en `O(d(u))`. `add_vertex` es `O(V)`;
  `add_edge`, `has_edge` y `get_neighbors` son `O(V + d(u))`. No se promete acceso
  indexado constante. Inicializar vacío y leer contadores es `O(1)`.
- **La memoria crece con los datos.** ABB `O(n)`; grafo `O(V + E)`. Una copia
  de vecinos añade `O(d(u))`. Un presupuesto físico del lenguaje se documenta
  sin convertirlo en capacidad del contrato ni prueba artificial de «lleno».
- **La inmutabilidad se paga en asignaciones.** En 4.3, insertar reconstruye `h` nodos: mismo `O(h)` en comparaciones, pero `O(h)` asignaciones por inserción.

**EN:** Cost follows the pseudocode: the BST pays height (`O(h)`, worst-case
`O(n)` without balancing). Graph vertex lookup costs `O(V)`, plus `O(d(u))`
for adjacency; adding a vertex is `O(V)`, and edge insertion/query and neighbour
copy are `O(V + d(u))`. Empty initialisation and count reads are `O(1)`. Storage
is `O(n)` for BST, `O(V + E)` for graph and an extra `O(d(u))` for neighbour
copies. Document physical memory budgets without turning them into contractual
capacity or full-state tests. Form 4.3 adds `O(h)` allocations per tree insertion.

**ES:** `get_neighbors` puede devolver el valor inmutable existente sin copiarlo:
se exige aislamiento observable, no identidad física distinta. En mutables se
devuelve una copia independiente; en ambos casos el resultado guardado no cambia
por inserciones posteriores. Compartir un valor inmutable puede ahorrar el coste
de copia sin invalidar la cota superior declarada.

**EN:** `get_neighbors` may return an existing immutable value without copying:
observable isolation, not distinct physical identity, is required. Mutable
representations return an independent copy; in both cases a saved result is
unchanged by later insertions. Sharing an immutable value can avoid copy cost
without invalidating the declared upper bound.

---

## 6. Trampas para quien llega nuevo / Traps for newcomers

- **La base no valida.** Si `Node` empieza a comprobar enlaces o a devolver indicadores, el contrato se ha movido al sitio equivocado: cada hijo valida lo suyo.
- **El `Node` del 07 no es el del 06.** Uno es `value + next` y pertenece a otro contrato; aquí la base tiene **solo** el valor y no se importa nada del módulo anterior.
- **No hay capacidad contractual.** `init()` crea un ABB o grafo vacío utilizable;
  no se valida `capacity` ni se inventa un estado lleno. Un duplicado no aumenta
  los contadores y no borra lo ya enlazado.
- **Vértices no son aristas.** `vertex_count` y `edge_count` son independientes.
  Un grafo con un vértice aislado no está vacío; sus vecinos sí lo están.
- **Etiqueta no es índice.** Registrar `10` y `70` no crea vértices intermedios.
  Una arista requiere extremos registrados; consultar un inexistente falla y
  no lo crea. Un bucle permitido cuenta una arista.
- **La adyacencia va ordenada y sin duplicados.** Si se acepta una arista repetida, `size` deja de ser el número de aristas distintas.
- **`contains` es del ABB, no una búsqueda lineal.** Bajar por la invariante es lo que hace que el módulo enseñe el árbol y no una lista.
- **La lista de biblioteca es almacenamiento, no algoritmo.** Se permiten sus
  primitivas de enlace e iteración; el código del módulo controla el recorrido,
  las comparaciones, los duplicados y el punto de inserción.
- **El registro global no tiene esa excepción.** No se sustituye por un mapa,
  diccionario o conjunto. Revisar el código es necesario: los mismos resultados
  con una colección optimizada no cumplen la intención manual del módulo.
- **Ausencia no es secuencia vacía.** `get_neighbors` falla para un vértice
  inexistente y devuelve una copia vacía para uno aislado; el README declara
  resultados distinguibles y compatibles con la fase.
- **Sin balanceo, el árbol puede degenerar.** Es una consecuencia aceptada del módulo; se documenta en el README, no se «arregla» con una estructura de biblioteca.

---

## 7. Dónde seguir / Where next

| Capa / Layer | Documento / Document |
|---|---|
| Qué se exige / What is required | [`07_Data_Structures_Advanced.md`](../core/algorithms/07_Data_Structures_Advanced.md) |
| Las familias en general / Families in general | [`PARADIGM_FAMILIES.md`](../ruleset/PARADIGM_FAMILIES.md) |
| Qué obliga tu lenguaje / What your language mandates | [`idioms/{lang}.md`](../ruleset/idioms/) |
