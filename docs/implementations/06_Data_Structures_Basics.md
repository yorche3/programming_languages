# 06 — Data Structures Basics: cómo se implementa en cada familia
# 06 — Data Structures Basics: how it is implemented in each family

> **ES:** Guía de implementación del módulo. Explica **cómo** y **por qué** el mismo `Node` produce una lista, una pila y una cola en cada familia de lenguajes. **No añade requisitos**: los criterios están en [`06_Data_Structures_Basics.md`](../core/algorithms/06_Data_Structures_Basics.md) y, si esta guía y la especificación discrepan, manda la especificación.
>
> **EN:** Implementation guide for the module. It explains **how** and **why** the same `Node` yields a list, a stack and a queue in each language family. It **adds no requirements**: the criteria live in [`06_Data_Structures_Basics.md`](../core/algorithms/06_Data_Structures_Basics.md) and, should this guide and the specification disagree, the specification wins.

---

## 1. La solución canónica, en llano / The canonical solution, in plain words

**ES:** El módulo no pide cuatro estructuras: pide **un tipo de celda** —`Node`, con un valor y un enlace— y **tres formas de nombrar sus extremos**. La lista guarda `head` y `tail`, la pila guarda `top`, la cola guarda `front` y `rear`; las tres llevan además un contador. Eso es todo el estado: los punteros son lo que distingue una estructura de otra, y el contador es lo que hace `size` y `is_empty` gratuitos.

- **Lista**: `insert_head` engancha un nodo delante; `insert_tail` lo engancha detrás **porque guarda `tail`**; `delete` recorre desde `head` con un `previous` hasta la primera aparición.
- **Pila**: `push` engancha delante de `top`; `pop` mueve `top` al siguiente. Es una lista en la que solo se toca un extremo.
- **Cola**: `enqueue` engancha detrás de `rear`; `dequeue` mueve `front` al siguiente y, si la cola se vacía, deja `rear` ausente.

**Lo que la especificación fija de verdad:** el `Node` único y compartido, `init` obligatorio antes de cualquier consulta, ausencia del enlace en la representación nativa, un indicador de fallo por tipo de retorno declarado en el README, `delete` en $O(n)$ y el resto en $O(1)$, los casos como **pasos sucesivos sobre la misma instancia**, y que pila y cola **no deleguen** en la lista ni en una colección de la biblioteca. **Lo que es solo forma:** si la celda se muta o se reconstruye, si `init` es un constructor que devuelve el valor o un procedimiento que lo rellena, y cómo se llaman los tipos cuando hay conflicto léxico.

**EN:** The module does not ask for four structures: it asks for **one cell type** —`Node`, with a value and a link— and **three ways of naming its ends**. The list keeps `head` and `tail`, the stack keeps `top`, the queue keeps `front` and `rear`; all three also keep a counter. That is the whole state: the pointers are what makes one structure different from another, and the counter is what makes `size` and `is_empty` free.

**What the specification actually fixes:** the single shared `Node`, `init` before any query, link absence in the native representation, one failure indicator per return type declared in the README, `delete` in $O(n)$ and everything else in $O(1)$, the cases as **successive steps on the same instance**, and stacks and queues that **do not delegate** to the list or to a library collection. **What is just form:** whether the cell is mutated or rebuilt, whether `init` is a constructor returning the value or a procedure filling it, and how the types are named when there is a lexical conflict.

---

## 2. Los ejes que cambian en este módulo / The axes that change here

| Eje / Axis | Pregunta / Question | Si sí / If yes | Si no / If no |
|---|---|---|---|
| **Mutabilidad de la celda** | ¿Se puede actualizar el enlace de un nodo ya creado? | Los punteros se reasignan: `insert_tail` y `enqueue` son $O(1)$ de verdad | Cada operación devuelve nodo y estructura nuevos: `insert_tail` y `enqueue` bajan a $O(n)$ y se declara |
| **Forma de `init`** | ¿El tipo se declara y luego se rellena, o se construye devolviendo el valor? | Procedimiento sobre una instancia ya declarada (`Make`-style) | Constructor que devuelve el valor inicializado |
| **Ausencia del enlace** | ¿La representación nativa del lenguaje admite «no hay siguiente»? | Se usa tal cual (`null`, `nil`, `None`, `Nothing`, `#f`, `()`, puntero nulo) | Se declara la representación equivalente en el README |
| **Indicador de fallo** | ¿Qué se devuelve al extraer de una estructura vacía? | El valor centinela del tipo de retorno (`-1` en números) o el fallo booleano | — |
| **Contador** | ¿La estructura puede llevar su tamaño? | `size` e `is_empty` son $O(1)$ en las tres variantes | Sin contador habría que recorrer: no lo permite ningún lenguaje del repo |

**ES:** El primer eje es el que **cambia la complejidad**, y no es una preferencia: guardar `tail` o `rear` solo sirve si se puede escribir `tail.next = node`. Donde no se puede, el último enlace está al final de una cadena que hay que reconstruir, y la operación se vuelve $O(n)$.
**EN:** The first axis is the one that **changes complexity**, and it is not a preference: keeping `tail` or `rear` only pays off if `tail.next = node` can be written. Where it cannot, the last link sits at the end of a chain that must be rebuilt, and the operation becomes $O(n)$.

---

## 3. Las familias: cómo definen la celda y sus extremos / The families: how they define the cell and its ends

| Familia / Family | Cómo define la celda / How it defines the cell | Qué puede mutar / What it may mutate | Ausencia del enlace / Link absence | Variante / Variant |
|---|---|---|---|---|
| **F1** OO con null | Una clase con campos; el enlace es una referencia | Los campos de la instancia | Referencia nula | 4.1 |
| **F2** Scripting dinámico | Un objeto o registro sin tipos declarados | Los campos del objeto | Valor nulo del lenguaje | 4.1 |
| **F3** C-lineage | Un registro y un puntero al mismo registro | El registro y el puntero | Puntero nulo | 4.2 |
| **F4** Sistemas modernos | Registro con el enlace como referencia u opción del lenguaje | El registro, si el tipo lo permite | Ausencia tipada del propio lenguaje | 4.2 |
| **F5** Funcional ML/Haskell | Un tipo algebraico o registro inmutable | Nada: se devuelve un valor nuevo | La opción nativa del lenguaje, solo en el enlace | 4.3 |
| **F6** Lisp | Un registro o un par | Nada, salvo celdas mutables explícitas | Lista vacía, falso o nulo | 4.3 |
| **F7** BEAM | Un registro o mapa | Nada: se devuelve un valor nuevo | Valor ausente del dominio | 4.3 |
| **F8** Multi-paradigma | Depende del tipo elegido | Según el tipo | Según el tipo | 4.1 o 4.3, declarada en el README |
| **F9** Lógico | Un término con el valor y el enlace como argumentos | Nada | Fallo de unificación | Variante relacional, declarada en el README |

**ES:** Ninguna familia cambia **qué** se guarda: siempre un valor, un enlace y los punteros de la estructura. Lo que cambia es si el enlace se escribe o se devuelve, y por tanto si los extremos cuestan $O(1)$ o $O(n)$.
**EN:** No family changes **what** is stored: always a value, a link and the structure's pointers. What changes is whether the link is written or returned, and therefore whether the ends cost $O(1)$ or $O(n)$.

---

## 4. Las variaciones, en pseudocódigo / The variations, in pseudocode

### 4.1 La variante del módulo: celda mutable con punteros / The module's variant: mutable cell with pointers

**ES:** Es la de la especificación, resumida en las operaciones que deciden la forma. El estado de cada estructura son sus punteros y el contador; los enlaces se reasignan.
**EN:** This is the specification's own, reduced to the operations that decide the shape. Each structure's state is its pointers and the counter; links are reassigned.

```pseudocode
Node
    value, next

    init(value)
        this.value = value
        this.next  = absent        # ausencia nativa del lenguaje
        return this

LinkedList: head, tail, count
    insert_head(v): node = Node.init(v); node.next = head; head = node
                    if tail is absent: tail = node; count += 1
    insert_tail(v): node = Node.init(v)
                    if tail is absent: head = node else tail.next = node
                    tail = node; count += 1          # O(1) por tener `tail`
    delete(v):      previous = absent; current = head
                    while current is not absent
                        if current.value == v
                            previous ? previous.next = current.next : head = current.next
                            if tail == current: tail = previous
                            count -= 1; return success
                        previous = current; current = current.next
                    return failure                        # O(n): recorre

Stack: top, count
    push(v): node = Node.init(v); node.next = top; top = node; count += 1
    pop():   if top is absent: return failure
             value = top.value; top = top.next; count -= 1; return value

Queue: front, rear, count
    enqueue(v): node = Node.init(v)
                if rear is absent: front = node else rear.next = node
                rear = node; count += 1                   # O(1) por tener `rear`
    dequeue():  if front is absent: return failure
                value = front.value; front = front.next
                if front is absent: rear = absent         # la cola se vació
                count -= 1; return value
```

**ES:** Los dos `if ... is absent` de `insert_tail` y `enqueue` son el caso «estructura vacía», y el `rear = absent` de `dequeue` es el que evita que el siguiente `enqueue` escriba sobre un nodo que ya no está en la cola. Sin esas tres guardas la estructura funciona hasta que deja de hacerlo.
**EN:** The two `if ... is absent` checks in `insert_tail` and `enqueue` are the empty-single case, and `rear = absent` in `dequeue` is what stops the next `enqueue` from writing through a node that has left the queue. Without those three guards the structure works until it stops working.

### 4.2 La de la celda preasignada: `init` como procedimiento / Pre-allocated cell: `init` as a procedure

**ES:** Cuando el lenguaje no tiene constructores que devuelvan valores, la instancia se **declara** y `init` la rellena. El enlace es un puntero nulo y la ausencia, ese mismo valor.
**EN:** When the language has no constructors that return values, the instance is **declared** and `init` fills it. The link is a null pointer and absence is that same value.

```pseudocode
procedure Node.init(nb: out Node; value: int)
    nb.value = value
    nb.next  = null

procedure LinkedList.init(lb: out LinkedList)
    lb.head = null; lb.tail = null; lb.count = 0

procedure insert_tail(lb: in out LinkedList; value: int)
    node = allocate(Node); Node.init(node, value)
    if lb.tail == null: lb.head = node
    else:               lb.tail.next = node      # escribe a través del puntero
    lb.tail = node; lb.count += 1
```

**ES:** La diferencia con 4.1 no está en el algoritmo sino en quién posee el valor: aquí toda operación recibe `in out` la estructura y la muta, y la ausencia del enlace se comprueba con `== null`, no con un tipo opcional.
**EN:** The difference from 4.1 is not in the algorithm but in who owns the value: here every operation takes the structure as `in out` and mutates it, and link absence is checked with `== null`, not with an optional type.

### 4.3 La variante por casos: la celda no se muta / The clause-based variant: the cell is not mutated

**ES:** Si el nodo es inmutable, `set_next` **devuelve un nodo nuevo** y toda operación devuelve también la estructura nueva. Los extremos siguen existiendo, pero el último enlace ya no se puede escribir: se reconstruye el camino, y por eso `insert_tail` y `enqueue` pasan a $O(n)$.
**EN:** If the node is immutable, `set_next` **returns a new node** and every operation also returns the new structure. The ends still exist, but the last link can no longer be written: the path is rebuilt, which is why `insert_tail` and `enqueue` drop to $O(n)$.

```pseudocode
insert_tail(xs, v)                       # reconstruye el camino hasta el final
    xs == empty          -> single(init(v))
    single(x)            -> init(x, next = init(v))
    node(x, rest)        -> node(x, next = insert_tail(rest, v))

delete(xs, v)                            # devuelve (éxito, estructura)
    xs == empty          -> (failure, xs)
    node(x, rest) where x == v -> (success, rest)
    node(x, rest)        -> let (ok, rest') = delete(rest, v) in (ok, node(x, rest'))

push(s, v)   -> Stack(top = node(v, next = s.top), count = s.count + 1)   # devuelve la pila nueva
pop(s)       -> s.top == absent ? (failure, s)
                                : (value(s.top), Stack(top = next(s.top), count - 1))
```

**ES:** El contador sigue dentro de la estructura devuelta, así que `size` e `is_empty` siguen siendo $O(1)$; lo que se paga es la reconstrucción de los nodos, no la lectura de los extremos.
**EN:** The counter still travels inside the returned structure, so `size` and `is_empty` remain $O(1)$; what is paid for is node rebuilding, not reading the ends.

---

**ES:** En las tres variantes se guarda lo mismo y se responde lo mismo; lo que se mueve es **quién escribe el enlace** (la estructura, el puntero o el valor devuelto) y, con ello, si los extremos cuestan $O(1)$ o $O(n)$.
**EN:** All three variants store the same and answer the same; what moves is **who writes the link** (the structure, the pointer, or the returned value) and, with it, whether the ends cost $O(1)$ or $O(n)$.

---

## 5. Consecuencias, leídas desde el pseudocódigo / Consequences, read from the pseudocode

**ES:** El coste de cada operación se lee directamente del código, no de una tabla aparte:

- **4.1 y 4.2 — todo $O(1)$ salvo `delete`.** `insert_head`, `insert_tail`, `push`, `enqueue`, `pop`, `dequeue`, `peek`, `size`, `is_empty` y `get_head` tocan punteros y un contador. `delete` recorre con `previous`/`current` y es $O(n)$, como fija la especificación. La memoria es un nodo por elemento, sin capacidad reservada.
- **4.2 — el coste oculto es la reserva.** Cada inserción pide memoria nueva; en un lenguaje con gestión manual, ese `allocate` es también parte del coste y de la responsabilidad de liberar.
- **4.3 — los extremos cuestan $O(n)$.** `insert_tail` y `enqueue` reconstruyen el camino hasta el último nodo, y cada reconstrucción asigna $O(n)$ nodos. Las lecturas de extremos (`get_head`, `peek`, `pop`, `dequeue`) siguen en $O(1)$ porque están en la cabeza, `top` o `front`; `size` e `is_empty` también, porque el contador viaja en el valor devuelto. `delete` es $O(n)$ en todas las variantes.
- **El contador no es decoración.** Sin él, `size` sería un recorrido y `is_empty` una comparación con la ausencia; con él, ambos son una lectura. En 4.3 es lo único que evita convertir tres operaciones en $O(n)$.

**Coste de expresión medido** (líneas de la fuente del módulo por lenguaje, 2026-10-17): de **94** en `ada` a **371** en `clojure`, **844** en `rust`, **893** en `cobol` y **1167** en `assembly`. Cuatro estructuras, el mismo `Node` y los mismos casos.

**EN:** The cost of each operation reads straight off the code: in 4.1 and 4.2 everything is $O(1)$ except `delete` ($O(n)$ by specification), with one node per element and no reserved capacity; 4.2 adds the allocation cost; in 4.3 the ends cost $O(n)$ because the path to the last node is rebuilt with $O(n)$ allocations, while head reads, `size` and `is_empty` stay $O(1)$ thanks to the counter, and `delete` remains $O(n)$ everywhere. Measured expression cost: 94 lines in Ada to 1167 in Assembly.

---

## 6. Trampas para quien llega nuevo / Traps for newcomers

- **Compartir el `Node` no es envolver la lista.** `Stack` y `Queue` usan el mismo tipo de celda, pero llevan sus propios punteros y su propio contador; si `push` acaba llamando a `insert_head`, el módulo ya no implementa tres ADT.
- **`init` no es opcional.** La instancia se declara sin valores definidos y solo `init` la deja usable; consultar `is_empty` antes es un caso fuera de contrato, no un fallo que haya que tolerar.
- **El indicador depende del tipo de retorno.** Un número que puede faltar devuelve el centinela (`-1`); una operación de éxito/fallo devuelve el booleano del lenguaje. Mezclarlos es lo que hace ambiguo el contrato.
- **La ausencia del enlace no es un indicador de fallo.** `next` ausente significa «fin de cadena» y usa la representación nativa; `-1` no es un enlace ausente.
- **Tres guardas que se olvidan siempre:** el primer `insert_tail` sobre una lista vacía, el primer `enqueue` sobre una cola vacía, y `rear = absent` al sacar el último elemento.
- **`delete` del último elemento debe mover `tail`.** Si no, el siguiente `insert_tail` escribe a través de un nodo que ya no está y la lista queda rota.
- **Con celdas inmutables, `insert_tail` y `enqueue` no son $O(1)$.** No es un defecto de la implementación: es lo que cuesta no poder escribir el enlace. Se declara en el README, con la misma honestidad con la que se declara una desviación.
- **Los valores de prueba son positivos** para no confundirse con el centinela de fallo.
- **Nada de colecciones de la biblioteca ni de imports de otros módulos**: la estructura se construye desde cero o el módulo no existe.

---

## 7. Dónde seguir / Where next

| Capa / Layer | Documento / Document |
|---|---|
| Qué se exige / What is required | [`06_Data_Structures_Basics.md`](../core/algorithms/06_Data_Structures_Basics.md) |
| Las familias en general / Families in general | [`PARADIGM_FAMILIES.md`](../ruleset/PARADIGM_FAMILIES.md) |
| Qué obliga tu lenguaje / What your language mandates | [`idioms/{lang}.md`](../ruleset/idioms/) |
| Qué se verificó en los 50 / What was verified across the 50 | [`06_Audited_Data_Structures_Basics.md`](../audits/06_Audited_Data_Structures_Basics.md) |
