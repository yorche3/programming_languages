---
layout: default
title: Guía 08 — Efficient Sort
nav_exclude: true
---

# 08 — Efficient Sort: implementación por familias y alternativas
# 08 — Efficient Sort: family implementations and alternatives

> **ES:** Esta guía desarrolla las alternativas permitidas por
> [08_Efficient_Sort.md](../core/algorithms/08_Efficient_Sort.md).
> La especificación fija contrato, fundamento, invariantes y pruebas; esta guía
> explica cómo expresarlos. No certifica implementaciones ni costes medidos.
> Los esquemas son pseudocódigo, no bibliotecas listas para importar.
>
> **EN:** This guide develops the alternatives allowed by
> [08_Efficient_Sort.md](../core/algorithms/08_Efficient_Sort.md).
> The specification defines the contract, foundation, invariants, and tests;
> this guide explains their expression. It certifies neither implementations
> nor measured costs. These are pseudocode sketches, not importable libraries.

---

## 1. Qué se conserva y qué cambia / What stays and what changes

**ES:** Las cuatro funciones ordenan enteros y conservan multiplicidad.
Quick/heap prefieren in-place; merge/rojo-negro preservan la entrada.
La representación cambia el acceso, la escritura y la propiedad, no autoriza
usar el ordenamiento o árbol balanceado de biblioteca. Se implementa una
versión por función; las demás pueden explicarse o añadirse como extras.
Una variante algorítmica (Hoare/Lomuto, LLRB/Okasaki) no es lo mismo que
V1/V2/V4, que describen cómo se expresa el estado.

**EN:** All four functions sort integers and preserve multiplicity.
Quick/heap prefer in-place; merge/red-black preserve input. Representation
changes access, updates, and ownership, not permission to use library sorting
or balanced trees. Implement one version per function; others may be explained
or added as extras. Algorithmic variants (Hoare/Lomuto, LLRB/Okasaki) are
distinct from V1/V2/V4, which describe how state is expressed.

**ES:** `absent` y `present(values)` son conceptos de la
[convención](../ruleset/PSEUDOCODE_CONVENTION.md). Usa la ausencia nativa si
no colisiona; si el vacío nativo también significa ausencia o el lenguaje no
permite comparar `absent` frente a una colección válida sin envoltorio, se admite
`Option`/`Maybe` o una salida etiquetada **por restricción del lenguaje**
(declarada en adaptaciones e indicadores de fallo), aun cuando la Fase 1 no los
adopte por estilo.
No pruebes éxito por truthiness ni uses `-1` como fallo. En lenguajes con
memoria manual, un buffer vacío válido necesita una representación distinta
de la ausencia, aunque no reserve un bloque de elementos.

**EN:** `absent` and `present(values)` follow the
[convention](../ruleset/PSEUDOCODE_CONVENTION.md). Use native absence when
unambiguous; if native empty values also mean absence or the language cannot
compare `absent` against a valid collection without a wrapper, `Option`/`Maybe`
or tagged output is allowed **by language restriction** (declared under
adaptations and failure indicators), even though Phase 1 does not adopt them by
style.
Do not test success by truthiness or use `-1` as failure. With manual memory,
a valid empty buffer needs a representation distinct from absence even if
no element block is allocated.

## 2. Familias: decisiones concretas / Families: concrete decisions

**ES:** Los grupos proceden de
[PARADIGM_FAMILIES.md](../ruleset/PARADIGM_FAMILIES.md); las capacidades concretas
se verifican en el lenguaje y tipo elegidos. Estas recomendaciones no afirman
que toda lista sea O(1), que toda recursión tenga TCO ni que todos los miembros
de una familia gestionen la memoria igual.

**EN:** Groups follow
[PARADIGM_FAMILIES.md](../ruleset/PARADIGM_FAMILIES.md); verify capabilities for
the chosen language and type. These recommendations do not assert that all
lists have O(1) access, all recursion has TCO, or every family member manages
memory alike.

| Grupo / Group | Lenguajes / Languages | Nodo propio / Own node | Camino y alternativas / Path and alternatives |
|---|---|---|---|
| F1 — V1 OO | ada, ballerina, crystal, csharp, dart, groovy, haxe, java, javascript, kotlin, raku, rexx, scala, swift, typescript, vala | Clase o registro con hijos opcionales; sin padre para LLRB / Class or record with optional children; no parent for LLRB | Buffer mutable: Hoare o Lomuto; merge top-down o bottom-up; max-heap iterativo; LLRB mutable. Declarar copia al escribir si existe / Mutable buffer: Hoare or Lomuto; top-down or bottom-up merge; iterative max-heap; mutable LLRB. Declare copy-on-write when present |
| F2 — V1 dinámico / dynamic | common-lisp, lua, perl, php, python, r, ruby, tcl-tk | Tipo/registro propio; comprobar semántica de referencia / Own type/record; check reference semantics | Mismos algoritmos sobre almacenamiento verificado. Una lista o diccionario usado como registro no garantiza mutación compartida / Same algorithms over verified storage. A list or dictionary used as a record does not guarantee shared mutation |
| F3 — V1 sistemas / systems | assembly, c, cobol, d, forth | Registro propio, direcciones/enlaces y liberación cuando corresponda / Own record, addresses/links, and release where needed | Array y longitud; LLRB sin padre o convencional con padre. Merge bottom-up evita pila recursiva; no ocultar buffers ni asignaciones / Array and length; parentless LLRB or parent-linked conventional tree. Bottom-up merge avoids recursive stack; expose buffers and allocation |
| F4 — V1 sistemas modernos / modern systems | cpp, go, julia, nim, rust, v, zig | Registro propio con propiedad de hijos explícita / Own record with explicit child ownership | Buffer/slice; una vista no es copia. LLRB sin ciclos facilita mover propiedad de subárboles; el convencional necesita justificar enlaces al padre / Buffer/slice; a view is not a copy. Acyclic LLRB simplifies subtree ownership moves; conventional parent links need justification |
| F5 — V2 funcional tipado / typed functional | elm, fsharp, haskell, ocaml, purescript, rescript | `Empty` o `Node(color,key,count,left,right)` propio / Own `Empty` or `Node(...)` | Quick por partición de listas; merge por cabezas o runs; heap plano con backend verificado; LLRB persistente u Okasaki. No mutación pública / List-partition quick; head-merge or runs; flat heap with verified backend; persistent LLRB or Okasaki. No public mutation |
| F6 — V2 Lisp funcional / functional Lisp | clojure, racket, scheme | Registro/término inmutable propio / Own immutable record/term | Lista o vector según coste; mismos esquemas V2. No copiar el `setf` mutable de Common Lisp ni asumir que índice barato implica escritura barata / List or vector according to cost; same V2 sketches. Do not copy mutable Common Lisp `setf` or infer cheap updates from cheap indexing |
| F7 — V2 funcional / functional | elixir, erlang, gleam, grain | Registro/término propio reconstruido / Own rebuilt record/term | Quick de tres grupos, merge por listas/runs, LLRB persistente u Okasaki. El backend del heap se decide por coste de acceso y actualización, no por nombre «array» / Three-group quick, list/run merge, persistent LLRB or Okasaki. Choose heap backend by access/update cost, not the name “array” |
| F8 — clase transversal / cross-cutting class | cpp, nim, rust, scala, swift, ya contados / already counted | Conserva V1 de su grupo / Retains its group's V1 | Comparar representaciones no reclasifica el lenguaje ni exige dos implementaciones de paradigma / Comparing representations neither reclassifies the language nor requires two paradigm implementations |
| F9 — V4 lógico / logic | prolog | Término propio `node(Color,Key,Count,Left,Right)` / Own term | Entrada concreta y salida calculada; partición/fusión relacionales, heap plano reconstruido y balance por casos. Ausencia como resultado explícito, no mero fallo del predicado / Ground input and computed output; relational partition/merge, rebuilt flat heap, case-based balance. Absence as explicit output, not mere predicate failure |

### No hay un Node de biblioteca supuesto / No library Node is assumed

**ES:** El nodo es parte del ejercicio. Una clase o un registro puede contener
`key`, `count`, `color`, `left` y `right`; un tipo algebraico añade el caso
vacío. En memoria manual cada nodo tiene vida y dueño; en persistencia cada
actualización crea los nodos del camino cambiado y comparte subárboles intactos.
No se reconstruye todo el árbol ni se importa Node de otro módulo.
`count` pertenece a la clave, así que debe viajar con ella en toda rotación.

**EN:** Nodes are part of the exercise. A class or record contains `key`,
`count`, `color`, `left`, and `right`; an algebraic type adds the empty case.
Manual-memory nodes have lifetimes and owners; persistent updates create nodes
along the changed path and share untouched subtrees. Do not rebuild the whole
tree or import Node from another module. `count` belongs to its key and must
travel with it through every rotation.

```pseudocode
Tree = Empty | Node(color, key, count, left: Tree, right: Tree)

new_leaf(value) = Node(RED, value, 1, Empty, Empty)
is_red(Empty) = false
is_red(Node(color, _, _, _, _)) = (color == RED)
blacken(Empty) = Empty
blacken(Node(_, key, count, left, right)) =
    Node(BLACK, key, count, left, right)
```

**ES:** `Empty` equivale a `NIL` en los esquemas de árbol; no es `absent`
de la función de ordenamiento. No necesita color, clave ni hijos accesibles.
Los nombres de campos, constructores y opcionales se traducen idiomáticamente,
sin imponer herencia ni punteros al padre.

**EN:** Tree `Empty` corresponds to `NIL`; it is not the sorting function's
`absent` output. It needs no readable color, key, or children. Translate field,
constructor, and optional names idiomatically without imposing inheritance
or parent pointers.

## 3. Quick: alternativas de partición / Partition alternatives

### 3.1 Lomuto sobre buffer mutable / Lomuto over mutable storage

**ES:** Hoare devuelve una frontera; Lomuto coloca el pivote en su posición
final. Antes de recorrer, mueve el pivote elegido al extremo derecho.
La región `[low, boundary)` contiene valores `<= pivot`; la región ya
examinada que sigue contiene valores mayores. Insertar un valor pequeño
en la frontera conserva esa separación. El intercambio final coloca el pivote
entre ambas regiones y la recursión lo excluye.

**EN:** Hoare returns a boundary; Lomuto places the pivot in its final
position. Move the chosen pivot to the right endpoint before scanning.
`[low, boundary)` contains values `<= pivot`; the following examined region
contains larger values. Moving a small item to the boundary preserves this
separation. The final swap places the pivot between the regions and recursion
excludes it.

```pseudocode
lomuto_partition(arr, low, high)
    swap(arr, low + div(high - low, 2), high)
    pivot = arr[high]
    boundary = low
    for j = low to high - 1
        if arr[j] <= pivot
            swap(arr, boundary, j)
            boundary = boundary + 1
    swap(arr, boundary, high)
    return boundary

quick_lomuto_help(arr, low, high)
    while low < high
        p = lomuto_partition(arr, low, high)
        if p - low < high - p
            if p > low: quick_lomuto_help(arr, low, p - 1)
            low = p + 1
        else
            if p < high: quick_lomuto_help(arr, p + 1, high)
            if p == low return
            high = p - 1
```

**ES:** El wrapper comprueba `absent` y tamaño antes de calcular `n - 1`,
como la referencia. Los límites son inclusivos. El guard de `p > low`
evita restar uno al índice cero. Lomuto es sencillo pero todos los valores
iguales dejan repetidamente una parte de tamaño `n - 1`: es `O(n²)`.
No lo presentes como la misma gestión de duplicados que Hoare.

**EN:** Its wrapper checks `absent` and size before computing `n - 1`, as
the reference does. Bounds are inclusive. Guarding `p > low` avoids decrementing
index zero. Lomuto is simple, but all-equal input repeatedly leaves a part
of size `n - 1`, costing `O(n²)`. Its duplicate handling differs from Hoare.

### 3.2 Medio, mediana de tres y aleatorio / Middle, median-of-three, and random

**ES:** La referencia usa el valor del índice medio, no la media aritmética
de las claves. Mediana de tres compara los valores de primero, medio y último
y elige el intermedio con un número constante de comparaciones propias,
sin ordenar la muestra con biblioteca. Un pivote aleatorio cuesta selección
constante bajo ese modelo y ofrece tiempo esperado `O(n log n)`, pero no
elimina el peor caso. No son exigencias de implementación.

**EN:** The reference uses the middle-index value, not the arithmetic average
of keys. Median-of-three compares first, middle, and last values and chooses
the middle-valued one with constant own comparisons, not library sample
sorting. A random pivot has constant selection cost under that model and
offers expected `O(n log n)` time, but does not eliminate the worst case.
These are not required implementations.

**ES:** No basta cambiar la línea del pivote de Hoare por cualquier índice:
elegir el máximo en el extremo derecho puede devolver `high` y no reducir
el problema. Una adaptación segura mueve el elemento elegido a `low`,
fija `pivot = arr[low]` y conserva los recorridos y límites de Hoare.
Lomuto lo mueve a `high`, según su propio esquema.

**EN:** Do not merely replace Hoare's pivot line with any index: choosing the
maximum at the right endpoint can return `high` without shrinking the problem.
A safe adaptation moves the chosen element to `low`, fixes
`pivot = arr[low]`, and retains Hoare's scans and bounds. Lomuto moves it to
`high` according to its own scheme.

### 3.3 Tres grupos sobre listas inmutables / Three groups over immutable lists

**ES:** Una lista ofrece cabeza y cola, no necesariamente índice O(1).
Separa cada valor en menor, igual o mayor que un pivote existente. El grupo
igual no se ordena recursivamente y conserva **todas** sus apariciones.
Menores e iguales y mayores pueden concatenarse sin comparar de nuevo:
por construcción sus intervalos de valores no se solapan.

**EN:** Lists offer head and tail, not necessarily O(1) indexing. Partition
every value into less, equal, or greater than an existing pivot. The equal
group needs no recursive sorting and preserves **all** occurrences.
Sorted less, equal, and sorted greater groups concatenate without new
comparisons because their value intervals do not overlap.

```pseudocode
quick_list(values)
    if values is absent return absent
    if size(values) <= 1 return values
    pivot = value_at_middle_by_traversal(values)
    less_rev = [], equal_rev = [], greater_rev = []
    for value in values
        if value < pivot: less_rev = cons(value, less_rev)
        else if value > pivot: greater_rev = cons(value, greater_rev)
        else: equal_rev = cons(value, equal_rev)
    less = reverse(less_rev)
    equal = reverse(equal_rev)
    greater = reverse(greater_rev)
    return concat(quick_list(less), equal, quick_list(greater))
```

**ES:** Tamaño, acceso al medio, partición y reversión pueden costar O(n) por
llamada; eso sigue siendo una partición lineal, no acceso indexado constante.
Partes equilibradas dan O(n log n); el peor caso sigue siendo O(n²).
Todos iguales terminan tras una partición lineal. `concat` copia la parte
izquierda en listas persistentes y debe contabilizarse. Este esquema no
hereda la pila O(log n) del buffer: dos llamadas recursivas, concatenaciones
y particiones retenidas requieren análisis de memoria y TCO reales.
Para evitar profundidad excesiva puede expresarse con una pila explícita de
tareas; no basta afirmar que toda recursión es de cola.

**EN:** Size, middle traversal, partitioning, and reversal may each cost O(n)
per call; the partition is still linear, not constant-time indexed access.
Balanced parts give O(n log n); worst case remains O(n²). All-equal input
ends after one linear partition. Persistent-list `concat` copies the left
part and must be counted. This sketch does not inherit the buffer's O(log n)
stack: two recursive calls, concatenations, and retained partitions need
actual memory/TCO analysis. An explicit task stack can avoid excessive call
depth; not every recursive call is tail-recursive.

## 4. Merge: orden de ejecución y almacenamiento / Execution order and storage

### 4.1 Bottom-up sobre arrays / Bottom-up over arrays

**ES:** Cada elemento es inicialmente un bloque ordenado de longitud uno.
Después de una pasada, cada par de bloques forma un bloque ordenado del doble
de anchura. La invariante de pasada es esa ordenación por bloques.
El último bloque puede ser más corto o no tener pareja; se fusiona con una
parte vacía, sin leer fuera de la secuencia.

**EN:** Every item starts as a sorted singleton block. Each pass merges block
pairs into sorted blocks of twice the width. That block ordering is the
pass invariant. The last block may be shorter or unpaired; merge it with an
empty part without reading beyond the sequence.

```pseudocode
merge_bottom_up(arr)
    if arr is absent return absent
    result = copy_sequence(arr)
    n = size(result)
    if n <= 1 return result
    scratch = sequence(n, 0)
    width = 1
    while width < n
        begin = 0
        while begin < n
            mid = begin + min(width, n - begin)
            end = mid + min(width, n - mid)
            merge_runs(result, scratch, begin, mid, end)
            begin = end
        swap_references(result, scratch)
        if width >= n - width return result
        width = width + width
    return result
```

**ES:** `merge_runs` aplica la fusión manual de la especificación a
`[begin, mid)` y `[mid, end)` y escribe todo `[begin, end)` en el destino,
prefiriendo izquierda en igualdad. `min` solo limita tamaños, no selecciona
claves ni ordena. Las sumas no superan `n`; el guard evita desbordar al duplicar
`width`. Tiempo O(n log n), buffers O(n) y sin pila de división recursiva.
La copia inicial conserva la entrada.

**EN:** `merge_runs` applies the specification's manual merge to
`[begin, mid)` and `[mid, end)`, writing all of `[begin, end)` to the destination,
preferring the left on ties. `min` only bounds sizes, not keys or sorting.
Sums stay within `n`; the guard prevents width-doubling overflow.
Time is O(n log n), buffers O(n), with no recursive division stack.
The initial copy preserves input.

### 4.2 Fusión por cabezas / Head-based merging

**ES:** En V2/V4 se consume cada lista por cabeza y cola. El acumulador
guarda lo emitido al revés para añadir en O(1); al terminar se invierte sobre
el resto pendiente. Así no se concatena toda la salida en cada paso.
El coste es lineal en las longitudes sumadas.

**EN:** V2/V4 consume list heads and tails. A reversed accumulator permits
O(1) prepending; completion reverses it onto the pending remainder.
This avoids whole-output concatenation at every step and costs linear time
in the combined lengths.

```pseudocode
merge_lists(left, right) = merge_acc(left, right, [])

merge_acc([], right, reversed) = reverse_onto(reversed, right)
merge_acc(left, [], reversed) = reverse_onto(reversed, left)
merge_acc([x | xs], [y | ys], reversed)
    if x <= y: return merge_acc(xs, [y | ys], cons(x, reversed))
    return merge_acc([x | xs], ys, cons(y, reversed))

reverse_onto([], tail) = tail
reverse_onto([x | xs], tail) = reverse_onto(xs, cons(x, tail))

merge_list_sort(values)
    if values is absent return absent
    if size(values) <= 1 return values
    (left, right) = split_at_by_traversal(values, div(size(values), 2))
    return merge_lists(merge_list_sort(left), merge_list_sort(right))
```

**ES:** El caso `([], [])` se resuelve una sola vez antes de las reglas
solapadas al traducir a pattern matching o relaciones. Las mitades conservan
el orden de entrada para preservar estabilidad. La división usa recorrido
lineal; no obtiene cada posición mediante un recorrido nuevo.
El esquema de fusión es de cola, pero su pila depende del TCO del runtime.
Otra opción bottom-up crea runs singleton y fusiona pares adyacentes en
pasadas; usa la misma `merge_lists`, sin acceso aleatorio ni división recursiva.

**EN:** Resolve `([], [])` once before overlapping cases when translating
to pattern matching or relations. Halves retain input order for stability.
Splitting traverses linearly, not by restarting traversal for each index.
Merge calls are tail-recursive, but stack use depends on runtime TCO.
Another bottom-up option starts with singleton runs and merges adjacent pairs
in passes using the same `merge_lists`, without random access or recursive
division.

## 5. Heap: variantes sin cambiar su definición / Variants retaining the heap definition

### 5.1 Descenso recursivo / Recursive sift-down

**ES:** Es el mismo max-heap y la misma decisión de intercambiar con el mayor
hijo. Cambia el control: una llamada representa el próximo nivel.
Solo es alternativa; la referencia iterativa evita esa pila.

**EN:** This retains the max-heap and larger-child decision. Control changes:
a call represents the next level. It is an alternative; the iterative
reference avoids that stack.

```pseudocode
sift_down_recursive(arr, n, root)
    if root >= div(n, 2) return
    left = 2 * root + 1
    largest = root
    if arr[left] > arr[largest]: largest = left
    if left < n - 1 and arr[left + 1] > arr[largest]: largest = left + 1
    if largest != root
        swap(arr, root, largest)
        sift_down_recursive(arr, n, largest)
```

**ES:** Tiempo O(log n) por descenso. Sin eliminación garantizada de esa
llamada, memoria de pila O(log n), no O(1). Las precondiciones y los guards
de helpers públicos son los de la especificación.

**EN:** Time is O(log n) per descent. Without guaranteed call elimination,
stack space is O(log n), not O(1). Preconditions and public-helper guards
follow the specification.

### 5.2 Min-heap como alternativa del lector / Min-heap reader alternative

**ES:** Invertir comparaciones permite mantener padre `<=` hijos. Pero mover
el mínimo al último lugar activo produce salida **descendente**.
Para conservar el contrato ascendente, esta alternativa termina con una
reversión manual in-place. La referencia max-heap no necesita esa pasada.

**EN:** Reversing comparisons maintains parent `<=` children. But moving
each minimum to the last active position produces **descending** output.
This alternative ends with manual in-place reversal to retain ascending
output. The max-heap reference needs no such pass.

```pseudocode
heap_sort_via_min(arr)
    if arr is absent return absent
    if size(arr) <= 1 return arr
    build_min_heap_bottom_up(arr)
    active = size(arr)
    while active > 1
        swap(arr, 0, active - 1)
        active = active - 1
        sift_down_min(arr, active, 0)
    reverse_in_place_by_swaps(arr)
    return arr
```

**ES:** Construcción y descenso siguen los esquemas max-heap con `<` y el
menor hijo. La reversión cuesta O(n), sin alterar O(n log n) total ni O(1)
auxiliar con descenso iterativo. No es una cola de prioridad pública.

**EN:** Build and descent follow max-heap sketches with `<` and the smaller
child. Reversal costs O(n), retaining O(n log n) total and O(1) auxiliary
space with iterative descent. This is not a public priority-queue API.

### 5.3 Heap plano sin escritura constante / Flat heap without constant-cost updates

**ES:** En persistencia mantén la secuencia plana y sus índices de hijos,
pero pasa el nuevo almacenamiento de una operación a la siguiente:
`storage = swap_values(storage, i, j)`. El descenso devuelve también el
almacenamiento, no solo el índice. Si un intercambio reconstruye O(n)
elementos, no cuesta O(1); si las actualizaciones cuestan O(log n), hay que
contarlas en cada descenso. Ni una lista indexada por recorrido ni una tupla
copiada completa justifican las cotas del array mutable.

**EN:** Persistence retains flat storage and child indices, but threads each
new storage value into the next operation:
`storage = swap_values(storage, i, j)`. Descent also returns storage, not
merely an index. A swap rebuilding O(n) elements is not O(1); O(log n)
updates must be counted at every descent. Neither traversal-indexed lists
nor whole-tuple copies justify mutable-array bounds.

**ES:** Escoge el almacenamiento plano permitido con mejor coste verificable,
contando conversión, lectura y actualización: el heap debe conservar su forma
teórica y **preferir un heap plano** optimizado según las características del
lenguaje (buffer mutable local cuando la variante lo permita, o vector/array
persistente `O(log n)` / `O(log₃₂ n)`). No cambies silenciosamente a otro tipo
de heap enlazado ni a un ADT de biblioteca. La adaptación documenta su coste
real; la invariancia de prefijo heap y sufijo ordenado permanece.

**EN:** Choose the allowed flat storage with the best verified costs, counting
conversion, reads, and updates: the heap must preserve its theoretical shape
and **prefer a flat heap** optimized for the language's characteristics (a local
mutable buffer when the variant allows it, or an `O(log n)` / `O(log₃₂ n)`
persistent vector/array). Do not silently replace the flat heap with another
linked heap type or a library ADT. Document actual adaptation costs; the
heap-prefix/sorted-suffix invariant remains.

## 6. Rojo-negro: tres reparaciones separadas / Three separate red-black repairs

### 6.1 LLRB persistente / Persistent LLRB

**ES:** Conserva las tres reglas locales de LLRB. En vez de escribir hijos,
construye otro Node con el hijo cambiado. Las rotaciones crean dos nodos y
comparten los subárboles `a`, `b`, `c`: no copian sus valores.
Los contadores se conservan junto a las claves.

**EN:** Retain LLRB's three local rules. Replace child writes with constructing
another Node holding the changed child. Rotations create two nodes and share
subtrees `a`, `b`, `c`, without copying their values. Counts stay with keys.

```pseudocode
llrb_insert_persistent(Empty, value) = new_leaf(value)
llrb_insert_persistent(Node(color, key, count, left, right), value)
    if value < key
        h = Node(color, key, count, llrb_insert_persistent(left, value), right)
    else if value > key
        h = Node(color, key, count, left, llrb_insert_persistent(right, value))
    else
        h = Node(color, key, count + 1, left, right)
    if is_red(h.right) and not is_red(h.left): h = llrb_left_persistent(h)
    if is_red(h.left) and is_red(h.left.left): h = llrb_right_persistent(h)
    if is_red(h.left) and is_red(h.right): h = llrb_flip_persistent(h)
    return h

llrb_left_persistent(Node(color, x, cx, a, Node(RED, y, cy, b, c))) =
    Node(color, y, cy, Node(RED, x, cx, a, b), c)

llrb_right_persistent(Node(color, y, cy, Node(RED, x, cx, a, b), c)) =
    Node(color, x, cx, a, Node(RED, y, cy, b, c))

llrb_flip_persistent(Node(color, key, count,
                          Node(RED, x, cx, a, b), Node(RED, y, cy, c, d))) =
    Node(opposite(color), key, count,
         Node(BLACK, x, cx, a, b), Node(BLACK, y, cy, c, d))

llrb_add(tree, value) = blacken(llrb_insert_persistent(tree, value))
```

**ES:** Estas transformaciones solo se llaman con sus precondiciones.
`llrb_add` cierra la inserción pintando la raíz negra; inspeccionar antes
puede observar reparación pendiente. Con construcción constante por nodo,
cada inserción visita y reconstruye O(log(d + 1)) nodos.

**EN:** Call these transforms only under their preconditions. `llrb_add`
completes insertion by blackening the root; earlier inspection may see
pending repair. With constant-cost node construction, each insertion visits
and rebuilds O(log(d + 1)) nodes.

### 6.2 Okasaki: cuatro formas, una reconstrucción / Four shapes, one reconstruction

**ES:** Esta alternativa funcional no impone inclinación izquierda.
Busca por orden ABB y al volver considera un abuelo negro con dos rojos
consecutivos. Las cuatro posiciones izquierda-izquierda, izquierda-derecha,
derecha-izquierda y derecha-derecha tienen el mismo orden in-order:
`a, x, b, y, c, z, d`. Se reconstruyen con raíz `y` roja y dos hijos negros.
Eso conserva el orden y la altura negra; un posible conflicto rojo se
propaga al padre y finalmente se cierra pintando negra la raíz.

**EN:** This functional alternative imposes no left leaning. Search by BST
order and, on return, consider a black grandparent with consecutive reds.
Left-left, left-right, right-left, and right-right share in-order sequence
`a, x, b, y, c, z, d`. Reconstruct them with red root `y` and black children.
Ordering and black height are preserved; any red conflict propagates upward
and completion blackens the root.

```pseudocode
okasaki_insert(Empty, value) = new_leaf(value)
okasaki_insert(Node(color, key, count, left, right), value)
    if value < key
        return okasaki_balance(
            Node(color, key, count, okasaki_insert(left, value), right))
    if value > key
        return okasaki_balance(
            Node(color, key, count, left, okasaki_insert(right, value)))
    return Node(color, key, count + 1, left, right)

okasaki_balance(tree)
    match tree with any of:
        Node(BLACK, z, cz, Node(RED, y, cy, Node(RED, x, cx, a, b), c), d)
        Node(BLACK, z, cz, Node(RED, x, cx, a, Node(RED, y, cy, b, c)), d)
        Node(BLACK, x, cx, a, Node(RED, z, cz, Node(RED, y, cy, b, c), d))
        Node(BLACK, x, cx, a, Node(RED, y, cy, b, Node(RED, z, cz, c, d)))
            return Node(RED, y, cy,
                        Node(BLACK, x, cx, a, b), Node(BLACK, z, cz, c, d))
    otherwise return tree

okasaki_add(tree, value) = blacken(okasaki_insert(tree, value))
```

**ES:** No sustituyas esta `balance` por la de LLRB ni añadas sus rotaciones
de color. Los casos sin patrón se conservan porque no hay conflicto local,
no porque se ignore un error. La suite verifica las invariantes rojo-negras
comunes, no «sin enlaces rojos derechos».

**EN:** Do not replace this balance with LLRB's or add LLRB's color rotations.
Unmatched cases remain unchanged because there is no local conflict, not
because an error is ignored. Test shared red-black invariants, not
“no red right links.”

### 6.3 Convencional con padre / Conventional parent-linked variant

**ES:** Aquí Node añade `parent`. Se inserta rojo por orden ABB; duplicados
aumentan contador sin reparar. La reparación sube mientras el padre es rojo.
El tío rojo permite recolorear; con tío negro, una configuración triangular
se convierte en línea y se rota el abuelo. Las rotaciones de esta variante
cambian **enlaces**, no colores: la reparación decide los colores.

**EN:** Node adds `parent`. Insert red by BST order; duplicates increase count
without repair. Repair climbs while the parent is red. A red uncle permits
recoloring; with a black uncle, turn a triangle into a line and rotate the
grandparent. These rotations change **links**, not colors: repair assigns
colors.

```pseudocode
repair_conventional(root, node)
    while node.parent != NIL and is_red(node.parent)
        parent = node.parent
        grandparent = parent.parent
        if parent == grandparent.left
            uncle = grandparent.right
            if is_red(uncle)
                parent.color = BLACK
                uncle.color = BLACK
                grandparent.color = RED
                node = grandparent
            else
                if node == parent.right
                    node = parent
                    root = rotate_left_links(root, node)
                node.parent.color = BLACK
                node.parent.parent.color = RED
                root = rotate_right_links(root, node.parent.parent)
        else
            uncle = grandparent.left
            if is_red(uncle)
                parent.color = BLACK
                uncle.color = BLACK
                grandparent.color = RED
                node = grandparent
            else
                if node == parent.left
                    node = parent
                    root = rotate_right_links(root, node)
                node.parent.color = BLACK
                node.parent.parent.color = RED
                root = rotate_left_links(root, node.parent.parent)
    root.color = BLACK
    return root

rotate_left_links(root, node)
    child = node.right
    node.right = child.left
    if child.left != NIL: child.left.parent = node
    child.parent = node.parent
    if node.parent == NIL: root = child
    else if node == node.parent.left: node.parent.left = child
    else: node.parent.right = child
    child.left = node
    node.parent = child
    return root

rotate_right_links(root, node)
    child = node.left
    node.left = child.right
    if child.right != NIL: child.right.parent = node
    child.parent = node.parent
    if node.parent == NIL: root = child
    else if node == node.parent.right: node.parent.right = child
    else: node.parent.left = child
    child.right = node
    node.parent = child
    return root
```

**ES:** El wrapper enlaza el nuevo Node con padre e hijos y actualiza la raíz
antes de reparar. `parent` de la raíz es `NIL`; el padre rojo no puede ser
la raíz negra al entrar en el bucle, así que existe abuelo.
No se accede a `NIL.color`: se usa `is_red`.
Comprueba también coherencia de padres en esta variante. Gestión de propiedad
y ciclos se documentan por lenguaje; no se impone ese coste a LLRB.

**EN:** The wrapper attaches the new Node to parent/children and updates root
before repair. The root's parent is `NIL`; a red parent cannot be the black
root on loop entry, so a grandparent exists. Use `is_red`, not `NIL.color`.
Also check parent consistency for this variant. Document ownership and
cycles per language rather than imposing them on LLRB.

### 6.4 Emisión lineal para árboles persistentes / Linear persistent-tree emission

**ES:** El acumulador representa la cola ya ordenada. Procesar derecha primero,
anteponer la clave tantas veces como indica su contador y después procesar
izquierda construye el mismo in-order sin concatenaciones repetidas.

**EN:** The accumulator is an already sorted tail. Process right first,
prepend the counted key occurrences, then process left: this constructs the
same in-order output without repeated concatenation.

```pseudocode
emit_onto(Empty, tail) = tail
emit_onto(Node(_, key, count, left, right), tail)
    result = emit_onto(right, tail)
    repeat count times: result = cons(key, result)
    return emit_onto(left, result)

tree_output(tree) = emit_onto(tree, [])
```

**ES:** Visita O(d) nodos y crea n celdas: Θ(n) tiempo con `cons` constante.
No es un sort de biblioteca ni un recorrido del heap. Si se convierte la
lista a array, cuenta ese O(n) adicional. La pila depende del recorrido y de
cómo el runtime expresa la repetición; no presupongas TCO universal.
En persistencia distingue árbol vivo O(d), salida O(n) y asignaciones
acumuladas O(n log(d + 1)); guardar todas las versiones puede aumentar la
memoria viva y no es necesario para ordenar.

**EN:** It visits O(d) nodes and creates n cells: Θ(n) time with constant
`cons`. It is neither library sorting nor heap traversal. Count an additional
O(n) if converting the list to an array. Stack use depends on traversal and
the runtime's repetition mechanism; do not assume universal TCO.
For persistence distinguish live tree O(d), output O(n), and cumulative
O(n log(d + 1)) allocations; retaining all versions may increase live memory
and is unnecessary for sorting.

## 7. V4: relaciones con entradas concretas / Relations with ground inputs

**ES:** Los enteros se reciben instanciados. `<`, `>` e igualdad deciden el
caso; no se pretende generar todas las permutaciones y comprobar cuál ordena.
Node es un término propio. Las cuatro formas de Okasaki pueden traducirse a
cláusulas que reconstruyen términos, sin exigir inclinación izquierda.
También puede traducirse LLRB manteniendo sus propias reglas.

**EN:** Integer inputs are ground. `<`, `>`, and equality select cases;
do not generate all permutations and test which is sorted. Node is an own
term. Okasaki's four shapes can become term-rebuilding clauses without
requiring left leaning. LLRB can also be translated retaining its own rules.

```pseudocode
red_black_sort(absent, absent).
red_black_sort(present(Values), present(Sorted)) :-
    build_tree(Values, empty, Root),
    emit_onto_relation(Root, [], Sorted).

build_tree([], Root, Root).
build_tree([Value | Rest], Root0, Root) :-
    insert_by_cases(Root0, Value, Candidate),
    blacken_relation(Candidate, Root1),
    build_tree(Rest, Root1, Root).
```

**ES:** `insert_by_cases` expresa **una** variante anterior, con el mismo
contador; `emit_onto_relation` expresa la emisión lineal. Quick usa relaciones
para los tres grupos y merge para cabezas; el heap pasa una secuencia plana
nueva tras cada intercambio. Estos modos son cálculo de salida, no búsquedas
arbitrarias sobre variables libres. El caso ausente produce una respuesta
explícita; `present([])` sigue siendo éxito.
En esta notación Prolog, `empty` es un átomo para la hoja vacía, no una
variable libre llamada `Empty`. El incremento usa evaluación aritmética
(`Count1 is Count + 1`) y la igualdad numérica usa `=:=`; la unificación
descompone los términos, no sustituye esas operaciones.

**EN:** `insert_by_cases` expresses **one** preceding variant with the same
counter; `emit_onto_relation` expresses linear emission. Quick uses three-group
relations, merge uses head relations, and heap threads new flat storage after
each swap. These modes compute output rather than search arbitrary free
variables. Absent input yields an explicit answer; `present([])` remains success.
In this Prolog notation, `empty` is the empty-leaf atom, not a free variable
named `Empty`. Increment uses arithmetic evaluation (`Count1 is Count + 1`)
and numeric equality uses `=:=`; unification decomposes terms rather than
replacing those operations.

## 8. Cómo validar y explicar la elección / Validating and explaining a choice

**ES:** La suite toma los casos de la especificación. Añade la comprobación
estructural correspondiente a la variante, no la forma exacta de otro árbol:
LLRB sin enlaces derechos rojos; convencional y Okasaki con las invariantes
comunes; padres coherentes solo donde existen. Un snapshot o iterador de
inspección necesita estructura, colores y contadores, no solo enteros ordenados.
Helpers públicos inválidos devuelven `absent` antes de mutar.

**EN:** Tests use the specification's cases. Add the chosen variant's structural
checks, not another tree's exact shape: no red right links for LLRB, common
invariants for conventional and Okasaki, and parent consistency only where
parents exist. Inspection snapshots or iterators need structure, colors, and
counts, not just sorted integers. Invalid public helpers return `absent`
before mutation.

**ES:** En el README deja claro:
1. Qué Node propio y qué almacenamiento de secuencia existen.
2. Qué algoritmo/variante se implementó y cuál se explica como alternativa.
3. Por qué sus pasos conservan orden, multiplicidad e invariantes, con un
   ejemplo pequeño; no solo «es idiomático».
4. Qué se comparte, copia, reconstruye o libera y qué costes reales tiene.
5. Qué grupos de la suite prueban salida, propiedad y estructura.

**EN:** State in the README:
1. Which own Node and sequence storage exist.
2. Which algorithm/variant is implemented and which is a explained alternative.
3. Why steps preserve ordering, multiplicity, and invariants, with a small
   example, not merely “it is idiomatic.”
4. What is shared, copied, rebuilt, or released and its actual costs.
5. Which test groups cover output, ownership, and structure.

**ES:** Las fuentes de la teoría están en la
[especificación](../core/algorithms/08_Efficient_Sort.md).
Para la explicación funcional también se contrastó la
[lección de Cornell sobre rojo-negro](https://www.cs.cornell.edu/courses/cs3110/2010fa/lectures/lec11.html).
El borrado sigue siendo una referencia futura, no un requisito de esta guía.

**EN:** Theoretical sources are in the
[specification](../core/algorithms/08_Efficient_Sort.md).
The functional explanation was also checked against
[Cornell's red-black lecture](https://www.cs.cornell.edu/courses/cs3110/2010fa/lectures/lec11.html).
Deletion remains a future reference, not a requirement of this guide.
