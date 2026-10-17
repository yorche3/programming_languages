# 05 — Naive Sort: cómo se implementa en cada familia
# 05 — Naive Sort: how it is implemented in each family

> **ES:** Guía de implementación del módulo. Explica **cómo** y **por qué** los tres ordenamientos elementales se escriben de forma distinta en cada familia de lenguajes. **No añade requisitos**: los criterios están en [`05_Naive_Sort.md`](../core/algorithms/05_Naive_Sort.md) y, si esta guía y la especificación discrepan, manda la especificación.
>
> **EN:** Implementation guide for the module. It explains **how** and **why** the three elementary sorts are written differently in each language family. It **adds no requirements**: the criteria live in [`05_Naive_Sort.md`](../core/algorithms/05_Naive_Sort.md) and, should this guide and the specification disagree, the specification wins.

---

## 1. La solución canónica, en llano / The canonical solution, in plain words

**ES:** El módulo pide **tres algoritmos** —selección, burbuja e inserción— sobre la **misma secuencia de enteros**, y la diferencia entre ellos no es el resultado (los tres ordenan) sino **qué se mueve y cuándo**:

- **Selección** crece un prefijo ya ordenado y, en cada pasada, **busca el mínimo del resto** y lo coloca en la frontera. Un solo intercambio por pasada: `n - 1` intercambios en total, muchas comparaciones.
- **Burbuja** compara **pares adyacentes** y sube el mayor al final en cada pasada. Su rasgo propio es la **bandera de corte**: si una pasada completa no intercambia nada, el resto ya está ordenado y el algoritmo termina antes. Sin esa bandera la burbuja es $O(n^2)$ siempre; con ella es $O(n)$ sobre una secuencia ya ordenada.
- **Inserción** crece un prefijo ordenado de uno en uno: toma el elemento siguiente y **desplaza** los mayores hacia la derecha hasta encontrar su hueco. No intercambia, desplaza, y por eso es $O(n)$ sobre una secuencia casi ordenada.

**Lo que la especificación fija de verdad:** los tres algoritmos, los 7 casos, la comparación **paso a paso** (sin ordenamiento ni selección de la biblioteca, decisión del autor del 2026-10-17), el corte temprano de la burbuja, el indicador de fallo sin excepciones ni `Option`/`Result`, la secuencia vacía devuelta igual, la representación declarada en el README, el techo $O(n^2)$ y la separación código/pruebas. **Lo que es solo forma:** si la secuencia se ordena in-place o se devuelve una copia, si los tres algoritmos viven en un archivo o en tres, y cómo se expresa el corte de la burbuja.

**EN:** The module asks for **three algorithms** —selection, bubble and insertion— over the **same integer sequence**, and what separates them is not the result (all three sort) but **what moves and when**: selection grows a sorted prefix and finds the minimum of the rest (one swap per pass, `n - 1` in total); bubble compares **adjacent pairs** and its own trait is the **early-exit flag** (a pass with no swaps ends the sort, which is what makes it $O(n)$ on already sorted input); insertion grows the prefix one element at a time by **shifting** greater elements right (no swaps, and $O(n)$ on nearly sorted input).

**What the specification actually fixes:** the three algorithms, the 7 cases, **step-by-step** comparison (no library sort and no library selection, author's decision of 2026-10-17), bubble's early exit, the failure indicator with no exceptions and no `Option`/`Result`, the empty sequence returned as is, the representation declared in the README, the $O(n^2)$ ceiling and the source/test split. **What is just form:** in-place versus returned copy, one file or three, and how the early exit is expressed.

---

## 2. Los ejes que cambian en este módulo / The axes that change here

| Eje / Axis | Pregunta / Question | Si sí / If yes | Si no / If no |
|---|---|---|---|
| **Mutabilidad de la secuencia** | ¿Se puede modificar la secuencia recibida? | In-place: selección y burbuja **intercambian**, inserción **desplaza** | Se construye una copia ordenada y se devuelve; inserción reconstruye la cola |
| **Iteración nativa** | ¿Hay bucles `for`/`while`? | Un bucle por algoritmo, con índices | Recursión de cola: la burbuja es *pasada + recursión*, la inserción es `insert` sobre la cola ya ordenada |
| **Indicador de fallo representable** | ¿La secuencia admite un valor ausente (`null`, `nil`, `undef`, `()`)? | Se devuelve ese valor tal cual | El README declara que el tipo de secuencia no admite ausencia (F5, F6 y las familias cuyo tipo no lo permite) |
| **Memoria extra** | ¿Cuánto cuesta ordenar? | In-place: $O(1)$ (un temporal y la bandera) | Copia: $O(n)$ por llamada; inserción sobre lista inmutable, $O(n^2)$ en asignaciones |

**ES:** El primer eje lo decide el **tipo de secuencia**, no el gusto de quien escribe: si el lenguaje entrega listas inmutables, el in-place no existe y la copia no es una optimización que se haya elegido. El segundo y el tercero son independientes entre sí.
**EN:** The first axis is decided by the **sequence type**, not by taste: if the language hands out immutable lists, in-place does not exist and the copy is not a chosen optimisation. The second and third axes are independent of each other.

---

## 3. Las familias: cómo definen el recorrido / The families: how they define traversal

**ES:** Lo que separa a las familias no es el resultado —las tres ordenan— sino **cómo se define recorrer una secuencia** y **qué se puede tocar** al hacerlo. Ahí está el cambio real: dónde vive el «apuntador», si existe el acceso por índice y qué se hace cuando no hay nada que devolver.
**EN:** What separates the families is not the result — all three sort — but **how traversal is defined** and **what may be touched** while doing it. That is the real change: where the “pointer” lives, whether indexed access exists, and what happens when there is nothing to return.

| Familia / Family | Cómo define el recorrido / How it defines traversal | Qué puede mutar / What it may mutate | Cómo trata la ausencia / How it handles absence | Variante / Variant |
|---|---|---|---|---|
| **F1** OO con null | Contenedor indexable: se avanza con índices enteros y la longitud es del propio contenedor | La secuencia recibida | Un valor nulo del mismo tipo | 4.1 |
| **F2** Scripting dinámico | Igual que F1, pero sin tipos: el índice es un entero por convención, no por contrato | La secuencia recibida | Un valor «sin valor» | 4.1, con el contrato sostenido por la suite |
| **F3** C-lineage | Array y longitud explícita: el recorrido es aritmética de índices y el final se reconoce por la longitud | Memoria propia | Puntero nulo o centinela del dominio | 4.1 |
| **F4** Sistemas modernos | Vista o slice con longitud: se indexa, pero una vista no es una copia | El buffer o la vista, según el tipo | Ausencia tipada o par «valor + bandera» | 4.1; el coste de la vista no es el de la copia |
| **F5** Funcional ML/Haskell | La secuencia es una lista: sólo se descompone en cabeza y cola, y cada paso se decide por casos | Nada | La secuencia no admite ausencia: se declara | 4.3 |
| **F6** Lisp | Un término (lista o par): recorrido recursivo con funciones de apoyo para localizar y extraer | Sólo si el lenguaje ofrece celdas mutables | Lista vacía, falso o nulo | 4.3, con helpers propios |
| **F7** BEAM | Lista inmutable y recursión de cola: el estado del recorrido viaja en argumentos | Nada | Un valor ausente del dominio | 4.3; la pasada devuelve el corte |
| **F8** Multi-paradigma | Depende del tipo elegido: indexable mutable o colección inmutable | Según el tipo | Según el tipo | 4.1 o 4.3; el README declara cuál |
| **F9** Lógico | No hay recorrido imperativo: el orden se expresa como relación y el motor unifica | Nada | Fallo de unificación | Variante relacional, declarada en el README |

**ES:** De ahí salen las dos únicas cosas que cambian de verdad en el código: **el apuntador** (un índice, un cursor o la propia recursión) y **qué se devuelve** (la misma secuencia o una nueva). Las tres variantes de pseudocódigo recogen justo eso.
**EN:** Hence the only two things that really change in the code: **the pointer** (an index, a cursor, or recursion itself) and **what is returned** (the same sequence or a new one). The three pseudocode variants below capture exactly that.

---

## 4. Las variaciones, en pseudocódigo / The variations, in pseudocode

### 4.1 La variante del módulo: secuencia indexable / The module's variant: indexable sequence

**ES:** Es la de la especificación, repetida aquí para poder compararla. Todo lo que hace falta para recorrer está en dos enteros y en el operador de índice: el apuntador es `i`/`j` y se devuelve **la misma** secuencia.
**EN:** This is the specification's own, repeated here so it can be compared. Everything needed to traverse lives in two integers and the index operator: the pointer is `i`/`j` and **the same** sequence is returned.

```pseudocode
selection_sort(arr)
    if arr is null or invalid: return failure_indicator
    n = size(arr)
    if n <= 1: return arr
    for i = 0 to n - 2
        min_idx = i
        for j = i + 1 to n - 1
            if arr[j] < arr[min_idx]: min_idx = j
        if min_idx != i: swap(arr, i, min_idx)
    return arr

bubble_sort(arr)
    if arr is null or invalid: return failure_indicator
    n = size(arr)
    if n <= 1: return arr
    for i = 0 to n - 2
        swapped = false
        for j = 0 to n - 2 - i
            if arr[j] > arr[j + 1]
                swap(arr, j, j + 1)
                swapped = true
        if not swapped: break
    return arr

insertion_sort(arr)
    if arr is null or invalid: return failure_indicator
    n = size(arr)
    if n <= 1: return arr
    for i = 1 to n - 1
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key
            arr[j + 1] = arr[j]
            j = j - 1
        arr[j + 1] = key
    return arr
```

**ES:** El corte es la bandera `swapped`. Y el mínimo se busca con un bucle (`for j`), no con una función: por eso este pseudocódigo hace visible el conteo de comparaciones.
**EN:** The early exit is the `swapped` flag, and the minimum is found with a loop (`for j`), not a function — which is why this pseudocode makes the comparison count visible.

### 4.2 Variante del apuntador: no se indexa, pero sí se muta / Pointer variant: no indexing, but mutation allowed

**ES:** Cuando la secuencia es una estructura enlazada, `arr[j]` no existe: el recorrido avanza con un cursor y la posición se recuerda guardando el cursor, no un índice. El algoritmo no cambia; cambia que cada paso pide `siguiente(cursor)`.
**EN:** When the sequence is a linked structure, `arr[j]` does not exist: traversal advances a cursor and position is remembered by keeping the cursor, not an index. The algorithm does not change; what changes is that each step asks for `siguiente(cursor)`.

```pseudocode
selection_sort(seq)
    if seq is null or invalid: return failure_indicator
    cursor = primero(seq)
    while cursor != fin
        best = cursor
        scan = siguiente(cursor)
        while scan != fin
            if valor(scan) < valor(best): best = scan
            scan = siguiente(scan)
        if best != cursor: intercambiar_valores(cursor, best)
        cursor = siguiente(cursor)
    return seq

bubble_sort(seq)
    if seq is null or invalid: return failure_indicator
    swapped = true
    while swapped
        swapped = false
        cursor = primero(seq)
        while siguiente(cursor) != fin
            if valor(cursor) > valor(siguiente(cursor))
                intercambiar_valores(cursor, siguiente(cursor))
                swapped = true
            cursor = siguiente(cursor)
    return seq
```

**ES:** Dos detalles que 4.1 no muestra: `primero`/`siguiente`/`fin` son **funciones de apoyo** que hay que tener o escribir, y `min`/`max` de la biblioteca no sirven aunque existan, porque hacen falta **posiciones**, no valores. La inserción, en cambio, deja de desplazar elementos y pasa a re-enlazar: su forma práctica es la de 4.3.
**EN:** Two details 4.1 does not show: `primero`/`siguiente`/`fin` are **helper functions** you must have or write, and the library's `min`/`max` do not help even when they exist, because **positions** are needed, not values. Insertion, on the other hand, stops shifting elements and starts re-linking: its practical shape is 4.3's.

### 4.3 La variante por casos: no se muta nada / The clause-based variant: nothing is mutated

**ES:** Es la forma de las familias que no pueden mutar. Ya no hay apuntador: el recorrido **es** la descomposición en cabeza y cola, y cada algoritmo se escribe como casos. Lo que en 4.1 era una bandera, aquí es un valor que la pasada devuelve; lo que era un índice, aquí es la posición del elemento dentro de la lista.
**EN:** This is the form used by families that cannot mutate. There is no pointer any more: traversal **is** the head/tail decomposition, and each algorithm is written as clauses. What was a flag in 4.1 is a value the pass returns; what was an index is the element's position in the list.

```pseudocode
# selección: se extrae el mínimo y se ordena el resto
selection_sort([])    = []
selection_sort([h|t]) = m :: selection_sort(quitar_una(m, [h|t]))
    where m = minimo([h|t])          # devuelve el ELEMENTO mínimo, no su índice

# burbuja: la pasada devuelve la lista y si cambió algo
bubble_sort([])  = []
bubble_sort([x]) = [x]
bubble_sort(xs)  = if not cambio(pasada(xs)) then xs
                   else bubble_sort(lista(pasada(xs)))

pasada([])      = ([], no_cambió)
pasada([x])     = ([x], no_cambió)
pasada(x::y::t) = if x > y then y :: resto(pasada(x::t))  (cambió)
                          else x :: resto(pasada(y::t))

# inserción: se ordena la cola y se inserta la cabeza
insertion_sort([])    = []
insertion_sort([h|t]) = insertar(h, insertion_sort(t))

insertar(x, [])   = [x]
insertar(x, y::t) = if x <= y then x :: y :: t
                    else y :: insertar(x, t)
```

**ES:** `minimo` y `quitar_una` son helpers que reciben y devuelven listas: sirven para **localizar** y **extraer**, no para comparar valores sueltos. La ausencia tampoco se resuelve devolviendo otro tipo: se **declara** en el README del lenguaje.
**EN:** `minimo` and `quitar_una` are helpers that take and return lists: they **locate** and **extract**, they do not compare bare values. Absence is not solved by returning another type either: it is **declared** in the language's README.

---

**ES:** En las tres variantes hay las mismas comparaciones y el mismo resultado; lo que se mueve es el apuntador (índice → cursor → recursión) y lo que se devuelve (misma secuencia → secuencia nueva).
**EN:** All three variants make the same comparisons and produce the same result; what moves is the pointer (index → cursor → recursion) and what is returned (same sequence → new sequence).

---

## 5. Consecuencias, leídas desde el pseudocódigo / Consequences, read from the pseudocode

**ES:** El techo $O(n^2)$ lo fija la especificación y no cambia entre variantes. Lo que cambia es **qué se gasta** para conseguirlo, y se ve en el propio pseudocódigo:

- **4.1 — memoria $O(1)$ y comparaciones a la vista.** Las variables son `i`, `j`, `min_idx`, `swapped` y `key`: un puñado de enteros y un booleano, siempre los mismos. Las comparaciones son bucles visibles, que es justo lo que el módulo quiere que se cuente.
- **4.2 — mismas comparaciones, otro coste de recorrido.** Dos cursores en vez de dos índices y ninguna variable más, así que sigue siendo $O(1)$; pero se pierde el acceso aleatorio: llegar al elemento `n` cuesta `n` pasos, y la inserción deja de desplazar y re-enlaza. La complejidad no cambia; el trabajo por paso, sí.
- **4.3 — memoria $O(n)$ por llamada.** Cada paso construye una lista nueva: la selección asigna una por elemento, la burbuja una por pasada y la inserción reconstruye la cola por elemento ($O(n^2)$ asignaciones). Las comparaciones son las mismas; lo que se gasta es memoria. El corte temprano tampoco desaparece: pasa a ser el valor que devuelve la pasada, y por eso la recursión puede parar.
- **Corte temprano, en las tres.** Es el único punto donde el tiempo depende del orden de la entrada: sobre la secuencia ya ordenada la burbuja hace **una** pasada, y sin el corte haría todas. En 4.3 eso sólo funciona si la recursión es de cola; si no lo es, la pila crece además de asignar.

**Coste de expresión medido** (líneas de la fuente del módulo por lenguaje, 2026-10-17): de **73** en `ruby` y **119** en `erlang` a **375** en `clojure`, **447** en `cobol` y **751** en `assembly`. Los tres algoritmos y sus 7 casos son los mismos en los 50.

**EN:** The $O(n^2)$ ceiling is fixed by the specification and does not change across variants; what changes is **what you spend** to get there, and it shows in the pseudocode itself. 4.1 keeps $O(1)$ state with the comparisons as visible loops; 4.2 makes the same comparisons with two cursors but loses random access (reaching element `n` costs `n` steps) and turns insertion's shift into a re-link; 4.3 allocates a new list per step — one per element for selection, one per pass for bubble, and a rebuilt tail per element for insertion ($O(n^2)$ allocations) — with the same comparisons but $O(n)$ memory per call. The early exit never disappears; in 4.3 it becomes the value the pass returns, which is what lets the recursion stop (and needs a tail call to keep the stack constant). Measured expression cost: 73 lines in Ruby to 751 in Assembly.

---

## 6. Trampas para quien llega nuevo / Traps for newcomers

- **`min`/`max` de la biblioteca no valen para el paso interno.** La especificación pide comparaciones **paso a paso**; usar el mínimo del sistema esconde justo el conteo que el módulo quiere enseñar. La regla se ancla a esa frase del enunciado, no a un criterio aparte.
- **La bandera de corte tiene tres formas legítimas**: una variable (`swapped`, en 4.1 y 4.2), una pasada que devuelve la lista y si cambió (4.3) o una pasada recursiva (4.3). Lo que no vale es una burbuja que nunca mira si la pasada intercambió algo.
- **Los 7 casos van sobre una copia del fixture cuando la función ordena in-place.** Si no, el segundo algoritmo recibe una secuencia ya ordenada y el caso no prueba nada.
- **`-1` no es una secuencia.** En este módulo el indicador representable es un valor ausente (`null`, `nil`, `undef`, `()`, `nothing`); las familias cuyo tipo no lo admite lo **declaran** en su README y no es un defecto.
- **En la variante por casos la inserción no es un bucle.** `insertar(h, insertion_sort(t))` ordena la cola y luego inserta la cabeza: no es una versión «rara», es el mismo algoritmo leído al revés.
- **El in-place no se elige**, lo permite el tipo. Si la secuencia es inmutable, la copia es la única forma y el README lo dice.
- **La representación es parte del módulo.** Array, lista, slice o `int[]` — el README del lenguaje declara cuál usa y por qué.

---

## 7. Dónde seguir / Where next

| Capa / Layer | Documento / Document |
|---|---|
| Qué se exige / What is required | [`05_Naive_Sort.md`](../core/algorithms/05_Naive_Sort.md) |
| Las familias en general / Families in general | [`PARADIGM_FAMILIES.md`](../ruleset/PARADIGM_FAMILIES.md) |
| Qué obliga tu lenguaje / What your language mandates | [`idioms/{lang}.md`](../ruleset/idioms/) |
| Qué se verificó en los 50 / What was verified across the 50 | [`05_Audited_Naive_Sort.md`](../audits/05_Audited_Naive_Sort.md) |
