---
layout: default
title: 08 — Efficient Sort
description: Ordenamientos por comparación y estructuras de heap y árbol rojo-negro / Comparison sorting with heap and red-black tree structures
nav_order: 4
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 08 — Efficient Sort

> [← Volver a 07_Data_Structures_Advanced](07_Data_Structures_Advanced.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Ordenar secuencias numéricas con **Quick Sort**, **Merge Sort**, **Heap Sort** y un ordenamiento mediante **árbol rojo-negro**, comparando partición, fusión, heap y búsqueda balanceada. | Sort numeric sequences with **Quick Sort**, **Merge Sort**, **Heap Sort**, and **red-black tree sorting**, comparing partitioning, merging, heaps, and balanced search. |

---

## 🧭 Cómo leer este módulo / How to read this module

> **ES:** Esta página fija **qué** se exige (fundamento teórico, contrato, pseudocódigo, invariantes, casos y criterios). Para el **cómo** y el **porqué** en cada familia de lenguajes (heap plano y almacenamiento persistente, Lomuto, merge bottom-up, LLRB persistente, Okasaki, rojo-negro convencional y Prolog), consulta la guía del módulo: [`implementations/08_Efficient_Sort.md`](../../implementations/08_Efficient_Sort.md). El registro de auditoría (`08_Audited_Efficient_Sort.md`) se añadirá al cerrar los 50 lenguajes.
>
> **EN:** This page fixes **what** is required (theoretical foundation, contract, pseudocode, invariants, cases, and criteria). For the **how** and the **why** across each language family (flat heap and persistent storage, Lomuto, bottom-up merge, persistent LLRB, Okasaki, conventional red-black, and Prolog), see the module guide: [`implementations/08_Efficient_Sort.md`](../../implementations/08_Efficient_Sort.md). The audit record (`08_Audited_Efficient_Sort.md`) will be added once all 50 languages close.

---

## 🧠 Fundamento teórico / Theoretical foundation

### De colocar uno a organizar el problema / From placing one item to organizing the problem

**ES:** Ordenar no es solo producir una lista que «parece correcta». Para una
entrada `A` y una salida `B` exigimos dos propiedades: `B[i] <= B[i + 1]` en
cada par adyacente y la misma cantidad de apariciones de cada entero en ambas.
La segunda impide «ordenar» perdiendo duplicados o inventando valores. El
vacío y el singleton ya cumplen la primera propiedad. Los negativos no
necesitan otro algoritmo: el orden usual de los enteros también compara
`-5 < -2 < 0 < 3`. Ausencia no es un entero ni una secuencia vacía.

**EN:** Sorting does not merely produce a list that “looks right.” For input
`A` and output `B`, we require two properties: `B[i] <= B[i + 1]` for each
adjacent pair, and equal occurrence counts for every integer in both.
The latter forbids “sorting” by dropping duplicates or inventing values.
Empty and singleton sequences already satisfy the former. Negative values
need no different algorithm: ordinary integer ordering also compares
`-5 < -2 < 0 < 3`. Absence is neither an integer nor an empty sequence.

**ES:** Los algoritmos de 05 organizan el trabajo con una frontera: selección
elige el mínimo pendiente; inserción amplía un prefijo ordenado; burbuja
lleva un máximo al sufijo. No todos usan un pivote. Pueden volver a comparar
gran parte de lo pendiente para colocar cada elemento, acumulando
`(n - 1) + (n - 2) + ... + 1 = n(n - 1)/2` pasos en el peor caso.
Aquí buscamos otra organización: dividir el trabajo, combinar partes ya
ordenadas o conservar una estructura que haga barato encontrar el siguiente
elemento. Una **invariante** es una afirmación que empieza siendo cierta,
se conserva con cada paso y, al terminar, permite justificar el resultado.

**EN:** Module 05 organizes work around a frontier: selection chooses the
remaining minimum, insertion grows a sorted prefix, and bubble moves a
maximum into the suffix. Not every sort uses a pivot. Reexamining much of
the remainder to place each item can accumulate
`(n - 1) + (n - 2) + ... + 1 = n(n - 1)/2` worst-case steps.
Here we seek different organization: split the work, combine sorted pieces,
or retain a structure that makes the next element cheap to find.
An **invariant** starts true, survives each step, and helps justify the
result when the process terminates.

### Quick Sort: separar antes de ordenar / Separate before sorting

**ES:** El pivote no «sabe» la posición de cada elemento; solo permite separar
valores menores y mayores. Hoare mantiene una región izquierda con valores
`<= pivot`, otra derecha con valores `>= pivot` y una región aún pendiente.
Los dos recorridos encuentran elementos que no pertenecen a su lado y los
intercambian. Tras el intercambio ambos índices avanzan, incluso en igualdad:
por eso los duplicados no detienen el proceso. Cuando los índices se cruzan,
no queda región pendiente.

**EN:** The pivot does not “know” every item's position; it only separates
smaller and larger values. Hoare maintains a left region containing values
`<= pivot`, a right region containing values `>= pivot`, and an unprocessed
region. The scans find items on the wrong side and swap them. Both indices
advance after a swap, even for equal values, so duplicates cannot stall the
process. When the indices cross, no unprocessed region remains.

**ES:** Por ejemplo, `[2, 3, 1]` toma `3` como pivote central y queda
`[2, 1 | 3]`. La frontera es el índice `1`, cuyo valor no es el pivote.
Todavía hay que ordenar `[2, 1]`, pero al terminar ambas partes no se necesita
fusión: todo lo izquierdo es `<=` todo lo derecho. Los subproblemas son
estrictamente menores, así que llegan al caso de cero o un elemento.
Una partición cuesta `O(n)`; divisiones de tamaños comparables dan unos
`log₂ n` niveles y `O(n log n)` trabajo. Si repetidamente queda una parte
de tamaño `n - 1`, el trabajo suma `O(n²)`. Elegir el índice medio no implica
elegir la mediana de los valores. Recurrir sobre la parte menor limita la
pila, pero no corrige por sí solo particiones temporalmente costosas.

**EN:** For example, `[2, 3, 1]` chooses `3` at the middle index and becomes
`[2, 1 | 3]`. The boundary is index `1`, whose value is not the pivot.
`[2, 1]` still needs sorting, but after both parts are sorted no merge is
needed: everything on the left is `<=` everything on the right. Strictly
smaller subproblems reach the zero/singleton base case. Partitioning costs
`O(n)`; comparable splits yield about `log₂ n` levels and `O(n log n)` work.
Repeatedly leaving a part of size `n - 1` accumulates `O(n²)` work.
A middle index does not imply the median value. Recursing on the smaller
part bounds stack space but does not by itself fix expensive partitions.

### Merge Sort: ordenar antes de unir / Sort before joining

**ES:** Merge no necesita adivinar un pivote. Divide por tamaño hasta obtener
partes trivialmente ordenadas y resuelve el problema de **unir dos secuencias
ya ordenadas**. Entre sus dos cabezas, la menor también es el menor valor
pendiente global: cada cabeza es el mínimo de su propia parte.
La invariante de fusión dice que la salida escrita está ordenada y contiene
exactamente los elementos consumidos. Tomar la menor cabeza conserva ambas
propiedades; agotar las dos partes prueba orden y multiplicidad.

**EN:** Merge needs no guessed pivot. It divides by size until pieces are
trivially sorted, then solves **joining two already sorted sequences**.
The smaller of their heads is the global remaining minimum, since each head
is its own part's minimum. The merge invariant says that written output is
ordered and contains exactly the consumed items. Choosing the smaller head
preserves both properties; exhausting both parts proves order and multiplicity.

**ES:** `[4, 1, 3, 2]` se divide en `[4, 1]` y `[3, 2]`, que se convierten en
`[1, 4]` y `[2, 3]`; la fusión elige `1`, `2`, `3` y finalmente `4`.
Preferir la cabeza izquierda cuando son iguales conserva el orden relativo
de apariciones iguales: eso es estabilidad, aunque con enteros idénticos no
se vea en la salida. Cada nivel consume `O(n)` valores y la división por
mitades da `O(log n)` niveles, independientemente del orden inicial.
La salida auxiliar evita desplazar repetidamente elementos pendientes; a
cambio requiere memoria lineal. Top-down divide primero; bottom-up comienza
con bloques de uno y fusiona bloques cada vez mayores. La justificación de
la fusión es la misma.

**EN:** `[4, 1, 3, 2]` splits into `[4, 1]` and `[3, 2]`, becoming `[1, 4]`
and `[2, 3]`; merging chooses `1`, `2`, `3`, then `4`.
Choosing the left head on equality preserves equal occurrences' relative
order: stability, even though identical integers hide it in output.
Each level consumes `O(n)` values and halving gives `O(log n)` levels
regardless of initial order. Auxiliary output avoids repeatedly shifting
pending items at the cost of linear memory. Top-down splits first; bottom-up
starts with singleton blocks and merges increasingly large blocks.
The merge argument is unchanged.

### Heap Sort: conservar solo el orden necesario / Retain only the needed order

**ES:** Una cola FIFO atiende por llegada; una cola de prioridad atiende por
prioridad. El heap ofrece la base de esta segunda idea: no ordena todos los
valores entre sí, solo garantiza que un padre sea `>=` sus hijos en un
max-heap. Por transitividad, la raíz es un máximo de todo el árbol.
Los hermanos no tienen orden obligatorio. Además, el árbol es **completo**:
todos los niveles están llenos salvo quizá el último, que se ocupa de
izquierda a derecha. Esa forma permite guardar los nodos implícitamente
en un array, sin objetos Node, con hijos `2i + 1` y `2i + 2`.

**EN:** A FIFO queue serves by arrival; a priority queue serves by priority.
A heap underpins the second idea: it does not order all values against
one another, only ensures each max-heap parent is `>=` its children.
Transitivity makes the root a global maximum. Siblings need no particular
order. The tree is also **complete**: all levels are full except possibly
the last, filled left to right. This shape permits implicit nodes in an
array, without Node objects, at child indices `2i + 1` and `2i + 2`.

**ES:** `sift_down` recibe subárboles hijos que ya son heaps. Si el padre es
demasiado pequeño, intercambiarlo con el **mayor** hijo arregla ese nivel y
deja un posible defecto únicamente más abajo. Elegir el menor hijo no
garantizaría arreglar el nivel. Cada paso desciende y termina en una hoja o
un padre suficientemente grande. Para construir el heap, se empieza en los
últimos padres: así sus hijos están preparados cuando se los necesita.
No cuesta `n log n`: cerca de la mitad de los nodos son hojas, cerca de
un cuarto solo pueden bajar un nivel, etc. La suma de costes por altura
queda acotada por `n · Σ(h/2^(h+1)) = O(n)`.

**EN:** `sift_down` receives child subtrees that are already heaps.
If the parent is too small, swapping with the **larger** child repairs that
level and leaves any defect only below it. Choosing the smaller child would
not guarantee that repair. Each step descends, stopping at a leaf or a
sufficiently large parent. Building starts at the last parents so their
children are ready when needed. It does not cost `n log n`: roughly half
the nodes are leaves, roughly a quarter can descend only one level, etc.
The height-weighted cost is bounded by
`n · Σ(h/2^(h+1)) = O(n)`.

**ES:** Al ordenar, intercambiamos la raíz máxima con el último elemento
activo y reducimos el heap. La invariante es «prefijo heap, sufijo ordenado,
todo valor del prefijo `<=` todo valor del sufijo». Por ejemplo,
`[2, 1, 3]` pasa a heap `[3, 1, 2]`, después a `[2, 1 | 3]` y finalmente
`[1 | 2, 3]`. Cada extracción cuesta `O(log n)` y hay `O(n)` extracciones.
No se usa in-order: el heap `[3, 1, 2]` daría `1, 3, 2`, que no está ordenado.

**EN:** Sorting swaps the maximum root with the last active item and shrinks
the heap. The invariant is “heap prefix, sorted suffix, every prefix value
`<=` every suffix value.” For example, `[2, 1, 3]` becomes heap `[3, 1, 2]`,
then `[2, 1 | 3]`, finally `[1 | 2, 3]`. Each extraction costs `O(log n)`
and there are `O(n)` extractions. In-order is not used: heap `[3, 1, 2]`
would yield `1, 3, 2`, which is not sorted.

### Rojo-negro y LLRB: ordenar enlaces sin formar una cadena / Order links without forming a chain

**ES:** Un ABB sí impone orden entre subárboles: todas las claves izquierdas
son menores y todas las derechas mayores. Insertar una secuencia creciente
en un ABB sin balance puede formar una cadena y costar `O(n²)` en total.
Un rojo-negro añade reglas que acotan la altura. Los caminos tienen la misma
altura negra y no pueden encadenar dos rojos: un camino tiene como máximo
el doble de pasos que su altura negra. Con `d` claves distintas, la altura
es `O(log(d + 1))`, no porque cada inserción divida exactamente por mitades,
sino porque las reglas impiden un desequilibrio arbitrario.

**EN:** A BST orders subtrees: every left key is smaller and every right key
larger. Increasing input can turn an unbalanced BST into a chain, costing
`O(n²)` overall. Red-black rules bound height. Paths have equal black
height and cannot contain consecutive red nodes: a path has at most twice
its black height in steps. With `d` distinct keys, height is
`O(log(d + 1))`, not because insertion splits exactly in half, but because
the rules prevent arbitrary imbalance.

**ES:** LLRB 2-3 interpreta un enlace rojo izquierdo como la unión de dos
nodos binarios en un nodo lógico con dos claves, como en un árbol 2-3.
Los enlaces negros separan esos nodos lógicos. Insertar rojo conserva la
altura negra, aunque temporalmente cree un enlace derecho rojo o dos rojos
seguidos. Rotar izquierda normaliza el enlace derecho; rotar derecha
reorganiza dos rojos izquierdos consecutivos; cambiar colores divide un
nodo lógico temporal con tres claves y propaga la reparación hacia arriba.
Al cerrar la operación se pinta negra la raíz. No se exige construir otro
ADT 2-3: es la explicación del balance binario.

**EN:** LLRB 2-3 treats a red left link as joining two binary nodes into a
logical two-key node, as in a 2-3 tree. Black links separate these logical
nodes. Inserting red preserves black height, though it may temporarily
create a red right link or consecutive reds. Left rotation normalizes a
red right link; right rotation reorganizes consecutive left reds; color
flipping splits a temporary three-key logical node and propagates repair
upward. Completion blackens the root. No separate 2-3 ADT is required:
it explains binary balancing.

**ES:** Una rotación preserva el orden porque las claves siguen apareciendo
en la misma secuencia in-order, aunque cambien sus padres. Por ejemplo,
insertar `1`, `2` produce raíz `2` negra con hijo `1` rojo izquierdo;
insertar `3` termina con raíz `2` y dos hijos negros. Reinsertar `2` aumenta
su contador, no crea otro nodo. In-order emite izquierda, clave repetida
según contador y derecha: por inducción sobre los subárboles, la salida
queda ordenada y conserva todas las apariciones. Construir cuesta
`O(n log(d + 1))`; emitir cuesta `Θ(n)`, **no `O(log n)`**.
LLRB, el convencional y Okasaki comparten ese argumento global, pero no
las mismas reparaciones locales.

**EN:** Rotation preserves order because keys retain the same in-order
sequence even when parents change. Inserting `1`, then `2`, yields black
root `2` with red left child `1`; inserting `3` ends with root `2` and
two black children. Reinserting `2` increments its count rather than making
another node. In-order emits left subtree, key repeated by count, then right
subtree: induction over subtrees proves sorted output and multiplicity.
Construction costs `O(n log(d + 1))`; emission costs `Θ(n)`, **not `O(log n)`**.
LLRB, conventional red-black, and Okasaki share that global argument but
not the same local repairs.

### Qué significa «eficiente» aquí / What “efficient” means here

**ES:** En el modelo basado solo en comparaciones, `n` valores distintos
pueden llegar en `n!` órdenes. Una decisión binaria por comparación requiere
en el peor caso al menos `log₂(n!) = Ω(n log n)` comparaciones para
distinguirlos. Merge, heap y árbol balanceado alcanzan ese orden asintótico;
quick lo alcanza en promedio, no en todo caso. No afirma que todas las
entradas con duplicados cuesten eso ni que un algoritmo siempre gane en
tiempo real. Acceso, copias y asignaciones importan. El módulo 09 estudiará
otras hipótesis, como aprovechar dígitos o rangos, no una contradicción
de este límite.

**EN:** In comparison-only sorting, `n` distinct values can arrive in `n!`
orders. Binary comparison decisions require at least
`log₂(n!) = Ω(n log n)` worst-case comparisons to distinguish them.
Merge, heap, and balanced-tree sorting attain this asymptotic order;
quick attains it on average, not always. This neither forces that cost
on every duplicate-heavy input nor makes one algorithm always fastest.
Access, copying, and allocation matter. Module 09 studies other assumptions,
such as exploiting digits or ranges, not a contradiction of this bound.

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
|---------|---------|
| Crear `efficient_sort` con `quick_sort(arr)`, `merge_sort(arr)`, `heap_sort(arr)` y `red_black_tree_sort(arr)`. Cada función recibe una **secuencia de enteros**, incluidos negativos y cero, y devuelve sus valores en orden ascendente, conservando todas las repeticiones. Una entrada ausente devuelve `absent`, nunca un código numérico de éxito/fallo. Una vacía devuelve una secuencia vacía presente. El README declara representación, mutación y propiedad de la salida. Sin excepciones para validar las entradas. | Create `efficient_sort` with `quick_sort(arr)`, `merge_sort(arr)`, `heap_sort(arr)`, and `red_black_tree_sort(arr)`. Each function receives an **integer sequence**, including negatives and zero, and returns its values in ascending order, preserving every duplicate. Absent input returns `absent`, never a numeric success/failure code. Empty input returns a present empty sequence. The README declares representation, mutation, and output ownership. No exceptions for input validation. |

**ES:** El árbol rojo-negro es una estructura interna para ordenar: no se pide
una API pública de búsqueda o eliminación. Se permiten helpers públicos de
inspección y construcción como extras educativos, con pruebas separadas.
El árbol del módulo 07 introduce
inserción y búsqueda ABB, pero no es un rojo-negro ni preserva duplicados; no se
importa ni se asume que ya esté balanceado. El heap de `heap_sort` no es un
árbol rojo-negro: su invariante solo ordena cada padre respecto de sus hijos.

**EN:** The red-black tree is an internal structure for sorting: no public
search or deletion API is required. Public inspection and construction helpers
are allowed as educational extras, with separate tests. Module 07 introduces BST insertion and
search, but it is not a red-black tree and does not preserve duplicates; do not
import it or assume it is balanced. The heap in `heap_sort` is not a red-black
tree: its invariant orders each parent only with respect to its children.

**ES:** Implementa manualmente los cuatro algoritmos, sus comparaciones y el
árbol rojo-negro y sus nodos propios; no delegues el ordenamiento ni el árbol balanceado en
bibliotecas. Arrays, listas y colecciones optimizadas de biblioteca pueden
servir de almacenamiento, sin importar los módulos anteriores. También se
permiten estructuras auxiliares aún no estudiadas, como listas doblemente
enlazadas o ArrayLists de tamaño variable, si no sustituyen el algoritmo ni
introducen una estructura más compleja que el tema actual. Explica su función
y sus costes en el README.

**EN:** Implement all four algorithms, their comparisons, and the red-black
tree and its own nodes manually; do not delegate sorting or the balanced tree to libraries.
Arrays, lists, and optimized library collections may provide storage without
importing previous modules. Auxiliary structures not yet studied, such as
doubly linked lists or resizable ArrayLists, are also allowed if they neither
replace the algorithm nor introduce a structure more complex than the current
topic. Explain their role and costs in the README.

### Representación, ausencia y propiedad / Representation, absence, and ownership

**ES:**

- La referencia de quick y heap usa un **heap plano** / secuencia plana mutable con acceso e
  intercambio `O(1)`, ordena **in-place** y devuelve la misma secuencia.
  Ser indexable no demuestra acceso `O(1)`.
- En **heap**, respeta la definición teórica del montículo binario y **prefiere un
  heap plano** donde el acceso y las actualizaciones se optimicen según las
  características reales del lenguaje (array/buffer mutable `O(1)` en V1, o el
  almacenamiento plano persistente / buffer local de mejor coste verificable en
  V2/V4).
- Merge y rojo-negro devuelven una secuencia nueva sin modificar la entrada,
  incluso para cero o un elemento. Una copia del contenedor basta: los valores
  son enteros, no objetos que deban clonarse.
- En V2/V4, o con acceso indexado costoso, elige la representación idiomática
  de mejor coste verificable para acceso y reconstrucción. Puede usarse un
  buffer mutable local si el lenguaje y su variante lo permiten. Declara las
  conversiones, copias, estructura persistente y coste real, incluida cualquier
  diferencia respecto de las cotas de referencia; no simules escrituras `O(1)`
  ni degrades el heap a una lista enlazada indexada por recorrido (`O(n² log n)`).
  Compartir valores realmente inmutables, incluido el vacío, es seguro: no se
  exige identidad física distinta donde no sea observable. Documenta el
  almacenamiento compartido; no fuerces una copia profunda innecesaria.
- `absent` es ausencia conceptual, según
  [`PSEUDOCODE_CONVENTION.md`](../../ruleset/PSEUDOCODE_CONVENTION.md), no la cadena
  `"absent"` ni `-1`. Éxito devuelve la colección, no `1/0/true/false`.
  Aunque en Fase 1 no se introducen `Option`/`Maybe`/`Result` por preferencia ni
  estilo (quedan reservados para la Fase 4), **cuando un lenguaje no puede
  comparar ni distinguir `absent` de una entrada/salida válida (como `[]`) por
  restricción propia del lenguaje**, sí se autoriza usar `Option`/`Maybe` o una
  representación etiquetada que distinga `absent` de `present([])`, declarándolo
  en _Adaptaciones idiomáticas_ e _Indicadores de fallo_. Un falso nativo puede
  representar ausencia, pero no un estado booleano de éxito.
- Valida ausencia antes de leer tamaño o contenido. Los enteros representables
  por el tipo son el dominio; no se pide validación exhaustiva de objetos de
  otros tipos. Usa `<`, `>` e igualdad, no resta de claves que pueda desbordar.
  No uses truthiness para distinguir ausencia, vacío, cero y valores negativos.

**EN:**

- Reference quick and heap use a **flat heap** / flat mutable storage with `O(1)` access and
  swapping, sort **in-place**, and return that same sequence.
  Indexability alone does not prove `O(1)` access.
- For **heap**, retain the theoretical binary-heap definition and **prefer a
  flat heap** where access and updates are optimized according to each language's
  real characteristics (`O(1)` mutable array/buffer in V1, or the best-cost
  verified persistent flat storage / local buffer in V2/V4).
- Merge and red-black sorting return new sequences without modifying input,
  including zero or one element. Copying the container suffices: values are
  integers, not objects requiring cloning.
- For V2/V4 or costly indexed access, choose the idiomatic representation with
  the best verified access and reconstruction costs. A local mutable buffer is
  allowed if the language and its variant permit it. Declare conversions,
  copies, persistence, and actual costs, including differences from reference
  bounds; do not pretend updates cost `O(1)` or degrade the heap to a
  traversal-indexed linked list (`O(n² log n)`).
  Sharing truly immutable values, including empty values, is safe: distinct
  physical identity is not required where unobservable. Document shared storage
  rather than forcing unnecessary deep copies.
- `absent` is conceptual absence, following the convention linked above, not
  the string `"absent"` or `-1`. Success returns the collection, not
  `1/0/true/false`. Although Phase 1 does not introduce `Option`/`Maybe`/`Result`
  by preference or style (reserved for Phase 4), **when a language cannot
  otherwise compare or distinguish `absent` from valid/empty values (such as
  `[]`) due to a language restriction**, using `Option`/`Maybe` or a tagged
  representation distinguishing `absent` from `present([])` is explicitly allowed
  and must be declared under _Idiomatic adaptations_ and _Failure indicators_.
  Native false may encode absence, but not a boolean success status.
- Check absence before reading size or contents. Integers representable by the
  type are the domain; exhaustive validation of other object types is not
  required. Use `<`, `>`, and equality, not potentially overflowing key
  subtraction. Do not use truthiness to distinguish absence, empty, zero,
  and negative values.

### Algoritmos esperados / Expected algorithms

| Algoritmo / Algorithm | Estrategia / Strategy | Complejidad temporal / Time | Memoria auxiliar / Auxiliary space | Mutación y propiedad / Mutation & ownership | Fallo / Failure |
|-----------|------------|---------------------|:----------------:|---|---|
| `quick_sort(arr)` | Hoare, pivote central; recursión sobre partición menor / Hoare, middle pivot; recurse on smaller partition | $O(n \log n)$ promedio / average, $O(n^2)$ peor / worst | $O(\log n)$ peor (pila) / worst (stack) | In-place (V1); nueva secuencia en V2/V4 / In-place (V1); new sequence in V2/V4 | `absent` (o `Option`/`Maybe` por restricción) / `absent` (or `Option`/`Maybe` by restriction) |
| `merge_sort(arr)` | División recursiva a la mitad y fusión ordenada de sub-secuencias / Recursive halving and ordered merge of sub-sequences | $O(n \log n)$ en todos los casos / in all cases | $O(n)$ (secuencia auxiliar de fusión / merge buffer) | Nueva secuencia, preserva entrada / New sequence, preserves input | `absent` (o `Option`/`Maybe` por restricción) / `absent` (or `Option`/`Maybe` by restriction) |
| `heap_sort(arr)` | Max-heap plano con `sift_down` y extracción sucesiva / Flat max-heap with `sift_down` and successive extraction | $O(n \log n)$ peor / worst | $O(1)$ con `sift_down` iterativo en array mutable / with iterative `sift_down` on mutable array | In-place (V1); nueva secuencia en V2/V4 / In-place (V1); new sequence in V2/V4 | `absent` (o `Option`/`Maybe` por restricción) / `absent` (or `Option`/`Maybe` by restriction) |
| `red_black_tree_sort(arr)` | Insertar en LLRB con contador, recorrer in-order / Insert into counted LLRB, traverse in-order | $O(n \log n)$ peor / worst | $O(n)$ árbol y salida / tree and output | Nueva secuencia, preserva entrada / New sequence, preserves input | `absent` (o `Option`/`Maybe` por restricción) / `absent` (or `Option`/`Maybe` by restriction) |

**ES:** Las cotas son de referencia, con comparaciones y operaciones de
almacenamiento de coste constante. Cuenta la memoria máxima viva, pila y
copias de entrada/salida; distingue memoria auxiliar, salida y asignación
acumulada. Copiar para quick/heap añade `O(n)` memoria. Merge es estable al
preferir la izquierda en igualdad; quick y heap no garantizan estabilidad.
El promedio de quick supone una distribución de entradas apropiada, no una
garantía para cada entrada: el pivote central determinista aún admite `O(n²)`.
Construir el heap de abajo arriba cuesta `O(n)`.

**EN:** Bounds are references assuming constant-cost comparisons and storage
operations. Account for peak live memory, stack, and input/output copies;
distinguish auxiliary memory, output, and cumulative allocation. Copying for
quick/heap adds `O(n)` memory. Merge is stable when ties prefer the left;
quick and heap do not guarantee stability. Quick's average assumes a suitable
input distribution, not a guarantee for each input: a deterministic middle
pivot still admits `O(n²)`. Bottom-up heap construction costs `O(n)`.

**ES:** En el rojo-negro: raíz negra; hojas ausentes negras; ningún nodo rojo
tiene hijo rojo; cada camino de un nodo a una hoja ausente tiene igual número
de nodos negros. Las claves menores van a la izquierda y las mayores a la
derecha en **todo el subárbol**. La referencia LLRB (versión 2-3) añade:
ningún enlace rojo se inclina a la derecha una vez terminada la inserción.
Guarda un contador positivo por clave: el recorrido emite cada clave tantas
veces como se insertó. Con `d` claves distintas y `n` valores, hay `O(d)` nodos,
cada inserción cuesta `O(log(d + 1))` y emitir cuesta `O(n)`.
El balance se restaura con recoloración y rotaciones que preservan el orden
ABB, no con `sift_down`.

**EN:** In the red-black tree: the root is black; absent leaves are black; red
nodes have no red children; every path from a node to an absent leaf has the
same number of black nodes. Smaller keys go left and larger keys right. A
positive per-key count preserves duplicates: traversal emits each key as many
times as it was inserted. Ordering holds over the **entire subtree**.
Reference LLRB (2-3 version) additionally forbids right-leaning red links once
insertion completes. With `d` distinct keys and `n` values there are `O(d)`
nodes, each insertion costs `O(log(d + 1))`, and emission costs `O(n)`.
Recolouring and rotations restore balance while preserving BST order,
not `sift_down`.

### Variantes de implementación / Implementation variants

**ES:** La [guía por familias](../../implementations/08_Efficient_Sort.md)
desarrolla los nodos y las alternativas con pseudocódigo: listas inmutables,
Lomuto, merge bottom-up, LLRB persistente, rojo-negro convencional y Okasaki.
No basta mencionar una variante en el README sin explicar cómo conserva
el contrato y qué costes cambian.

**EN:** The [family guide](../../implementations/08_Efficient_Sort.md)
develops nodes and alternatives with pseudocode: immutable lists, Lomuto,
bottom-up merge, persistent LLRB, conventional red-black, and Okasaki.
Naming a variant in the README is insufficient without explaining how it
retains the contract and which costs change.

**ES:** Se requiere una implementación por algoritmo, no todas las variantes;
pueden añadirse otras como extras separados.
La referencia usa V1; V2 reconstruye valores y V4 expresa relaciones, según la
convención de pseudocódigo. El README justifica la adaptación:

- **Quick:** Hoare con pivote en el índice central, cuyo valor no cambia durante
  una partición; se selecciona de nuevo en cada subproblema. Mediana de tres o
  pivote aleatorio son alternativas para el lector, no garantías de peor caso.
  Lomuto también es admisible: su pivote queda en posición final y la recursión
  debe excluirlo, no copiar los límites de Hoare. Para mantener la cota de pila,
  recurre solo sobre la partición menor e itera sobre la mayor.
- **Merge:** top-down como referencia; bottom-up es admisible conservando
  fusión manual, multiplicidad y estabilidad.
- **Rojo-negro:** LLRB como base. Okasaki es una alternativa funcional, y el
  rojo-negro convencional también es admisible si resulta más conveniente.
  Cada variante mantiene sus propias reglas: no exijas inclinación izquierda
  a Okasaki o al convencional, ni mezcles sus reparaciones o rotaciones.
  Todas mantienen orden ABB, balance rojo-negro y contador de duplicados.

**EN:** One implementation per algorithm is required, not every variant;
others may be added as separate extras.
The reference uses V1; V2 rebuilds values and V4 expresses relations according
to the pseudocode convention. The README justifies adaptations:

- **Quick:** Hoare with the middle-index element as pivot, fixed in value
  during a partition and selected anew for each subproblem. Median-of-three or
  random pivots are reader alternatives, not worst-case guarantees.
  Lomuto is also allowed: its pivot reaches its final position and recursion
  must exclude it rather than copy Hoare's bounds. To retain the stack bound,
  recurse only on the smaller partition and iterate over the larger.
- **Merge:** top-down reference; bottom-up is allowed with manual merging,
  multiplicity preservation, and stability.
- **Red-black:** LLRB baseline. Okasaki is a functional alternative, and
  conventional red-black insertion is also allowed when more suitable.
  Keep each variant's rules separate: do not require left leaning of Okasaki
  or conventional trees or mix their repair and rotation procedures.
  All retain BST ordering, red-black balance, and duplicate counts.

### Pseudocódigo / Pseudocode

**ES:** Índices desde cero. Quick usa `[low, high]` inclusivo; Hoare devuelve
`p` con `low <= p < high`, una frontera, no la posición final del pivote.
`slice(arr, begin, end)` usa extremo final **exclusivo**; el heap activo es
`[0, n)`. `div` es división entera hacia abajo. `and` cortocircuita antes de
acceder al siguiente operando. Los contenedores del esquema V1 se pasan por
referencia; `copy_sequence` crea un contenedor nuevo. Protege límites antes de
indexar, restar uno a un tamaño o calcular hijos; no traduzcas índices
conceptuales a aritmética sin signo que desborde.
Si expones helpers indexados, valida antes de mutar: para partición,
`0 <= low < high < size(arr)`; para `sift_down`,
`0 <= root < n <= size(arr)`. Una llamada pública inválida devuelve `absent`.

**EN:** Zero-based indices. Quick uses inclusive `[low, high]`; Hoare returns
`p` with `low <= p < high`, a boundary, not the pivot's final position.
`slice(arr, begin, end)` excludes **end**; the active heap is `[0, n)`.
`div` is floor integer division. `and` short-circuits before accessing its next
operand. V1 containers are passed by reference; `copy_sequence` creates a new
container. Guard bounds before indexing, subtracting one from a size, or
computing children; do not translate conceptual indices into overflowing
unsigned arithmetic.
If exposing indexed helpers, validate before mutation: partition requires
`0 <= low < high < size(arr)`; `sift_down` requires
`0 <= root < n <= size(arr)`. Invalid public calls return `absent`.

```pseudocode
container efficient_sort
    .- quick_sort(arr)
        if arr is absent return absent
        if size(arr) <= 1 return arr
        quick_sort_help(arr, 0, size(arr) - 1)
        return arr

    .- quick_sort_help(arr, low, high)
        while low < high
            p = partition(arr, low, high)
            if p - low < high - p - 1
                quick_sort_help(arr, low, p)
                low = p + 1
            else
                quick_sort_help(arr, p + 1, high)
                high = p

    .- partition(arr, low, high)
        pivot = arr[low + div(high - low, 2)]
        i = low
        j = high
        while true
            while i < high and arr[i] < pivot: i = i + 1
            while j > low and arr[j] > pivot: j = j - 1
            if i >= j return j
            swap(arr, i, j)
            i = i + 1
            j = j - 1

    .- merge_sort(arr)
        if arr is absent return absent
        if size(arr) <= 1 return copy_sequence(arr)
        mid = div(size(arr), 2)
        left = merge_sort(slice(arr, 0, mid))
        right = merge_sort(slice(arr, mid, size(arr)))
        return merge(left, right)

    .- merge(left, right)
        result = sequence(size(left) + size(right), 0)
        i = 0, j = 0, k = 0
        while i < size(left) and j < size(right)
            if left[i] <= right[j]
                result[k] = left[i]; i = i + 1
            else
                result[k] = right[j]; j = j + 1
            k = k + 1
        while i < size(left)
            result[k] = left[i]; i = i + 1; k = k + 1
        while j < size(right)
            result[k] = right[j]; j = j + 1; k = k + 1
        return result

    .- heap_sort(arr)
        if arr is absent return absent
        n = size(arr)
        if n <= 1 return arr
        i = div(n, 2)
        while i > 0
            i = i - 1
            sift_down(arr, n, i)
        i = n - 1
        while i > 0
            swap(arr, 0, i)
            sift_down(arr, i, 0)
            i = i - 1
        return arr

    .- sift_down(arr, n, root)
        while root < div(n, 2)
            largest = root
            left = 2 * root + 1
            if arr[left] > arr[largest] largest = left
            if left < n - 1 and arr[left + 1] > arr[largest] largest = left + 1
            if largest == root return
            swap(arr, root, largest)
            root = largest
end container
```

### Árbol rojo-negro para ordenar / Red-black tree for sorting

#### Nodo propio del módulo / The module's own node

**ES:** Define y construye manualmente un **Node especializado para este árbol**.
No hay un nodo de biblioteca que se asuma existente ni se importa Node de 06/07.
Se puede llamar `Node`, `RedBlackNode` o un nombre idiomático equivalente.
La clase/registro/término es propio; la asignación de memoria y los tipos
opcionales sí pueden ser primitivas del lenguaje.

**EN:** Define and manually construct a **Node specialized for this tree**.
No library node is assumed to exist, and Node is not imported from 06/07.
It may be named `Node`, `RedBlackNode`, or an idiomatic equivalent.
The class/record/term is own code; allocation and optional types may use
language primitives.

| Campo / Field | Significado / Meaning |
|---|---|
| `key` | Entero almacenado, también llamado valor / Stored integer, also called value |
| `count` | Multiplicidad positiva de la clave; no tamaño del subárbol / Positive key multiplicity, not subtree size |
| `color` | `RED` o `BLACK`; en LLRB describe el enlace entrante / `RED` or `BLACK`; incoming link in LLRB |
| `left`, `right` | Hijos propios o `NIL` / Own children or `NIL` |
| `parent` (alternativa / alternative) | Solo si la variante convencional usa enlaces hacia arriba / Only when a conventional variant uses upward links |

```pseudocode
type Node
    key, count, color, left, right

    init(value)
        key = value
        count = 1
        color = RED
        left = NIL
        right = NIL
        return this
```

**ES:** Cada clave distinta crea un nodo; un duplicado solo cambia `count`.
En V2 se construye `Node(color, key, count, left, right)` como valor inmutable;
en V4 es un término equivalente. LLRB no necesita `parent`, `next`, vecinos
ni una jerarquía de herencia obligatoria. Si se comparte una base local de
valor por forma, no debe perderse esta información. El heap usa nodos
**implícitos** en la secuencia, no este Node con enlaces.

**EN:** Each distinct key creates a node; duplicates only change `count`.
V2 constructs `Node(color, key, count, left, right)` as an immutable value;
V4 uses an equivalent term. LLRB needs no `parent`, `next`, neighbors, or
mandatory inheritance hierarchy. A local value base may be shared for form
without losing this information. Heap nodes are **implicit** in the sequence,
not this linked Node.

#### Inserción LLRB de referencia / Reference LLRB insertion

**ES:** La referencia es LLRB 2-3, con inserción recursiva y sin punteros al
padre. El color de un nodo representa el enlace que lo une a su padre.
`NIL` es una hoja conceptual negra, no un entero ni un resultado de fallo.
`is_red(NIL)` es falso y nunca se leen campos de `NIL`. Las rotaciones LLRB
transfieren el color del enlace y devuelven la nueva raíz del subárbol.
Una inserción completa incluye pintar de negro la raíz devuelta por
`llrb_insert`; ese helper por sí solo puede devolver una raíz roja.

**EN:** Reference LLRB is the 2-3 version, with recursive insertion and no parent
pointers. A node's color represents its incoming parent link.
`NIL` is a conceptual black leaf, not an integer or a failure result.
`is_red(NIL)` is false and no fields of `NIL` are read. LLRB rotations
transfer link colors and return the new subtree root.
A completed insertion includes blackening the root returned by `llrb_insert`;
that helper alone may return a red root.

```pseudocode
red_black_tree_sort(arr)
    if arr is absent return absent
    root = NIL
    for value in arr
        root = llrb_insert(root, value)
        root.color = BLACK
    result = empty sequence
    append_in_order(root, result)
    return result

append_in_order(node, result)
    if node == NIL return
    append_in_order(node.left, result)
    repeat node.count times: append node.key to result
    append_in_order(node.right, result)

is_red(node)
    if node == NIL return false
    return node.color == RED

llrb_insert(node, value)
    if node == NIL
        return Node.init(value)
    if value < node.key
        node.left = llrb_insert(node.left, value)
    else if value > node.key
        node.right = llrb_insert(node.right, value)
    else
        node.count = node.count + 1
    if is_red(node.right) and not is_red(node.left)
        node = llrb_rotate_left(node)
    if is_red(node.left) and is_red(node.left.left)
        node = llrb_rotate_right(node)
    if is_red(node.left) and is_red(node.right)
        llrb_flip_colors(node)
    return node

llrb_rotate_left(node)
    child = node.right
    node.right = child.left
    child.left = node
    child.color = node.color
    node.color = RED
    return child

llrb_rotate_right(node)
    child = node.left
    node.left = child.right
    child.right = node
    child.color = node.color
    node.color = RED
    return child

llrb_flip_colors(node)
    node.color = opposite(node.color)
    node.left.color = opposite(node.left.color)
    node.right.color = opposite(node.right.color)
```

**ES:** Las rotaciones presuponen nodo presente y el hijo correspondiente rojo;
el cambio de colores presupone ambos hijos presentes y rojos. Las llamadas de
inserción garantizan estas precondiciones. Si se exponen directamente como
extras, valida las precondiciones antes de mutar y devuelve `absent` ante una
llamada inválida, sin ocultarla como éxito. En persistencia se reconstruye el
camino y se devuelve la nueva raíz. Emitir debe costar `O(n)`: `append`
amortizado `O(1)`, salida preasignada o construcción lineal equivalente, no
concatenar repetidamente listas completas.

**EN:** Rotations require a present node and a red corresponding child;
color flipping requires both children present and red. Insertion calls satisfy
these preconditions. If exposed directly as extras, check preconditions before
mutation and return `absent` for an invalid call rather than hiding it as
success. Persistent versions rebuild the path and return the new root.
Emission must cost `O(n)`: amortized `O(1)` append, preallocated output, or an
equivalent linear construction, not repeated whole-list concatenation.

### Casos de prueba / Test Cases

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|------|---------|----------------|
| Secuencia desordenada<br>Unordered sequence | `[12, 11, 13, 5, 6, 7]` | `[5, 6, 7, 11, 12, 13]` |
| Secuencia con duplicados<br>Sequence with duplicates | `[4, 10, 3, 5, 1, 4]` | `[1, 3, 4, 4, 5, 10]` |
| Todos iguales / All equal | `[5, 5, 5]` | `[5, 5, 5]` |
| Ascendente / Ascending | `[1, 2, 3, 4, 5]` | `[1, 2, 3, 4, 5]` |
| Secuencia ordenada inversamente<br>Reverse-ordered sequence | `[9, 8, 7, 6, 5, 4]` | `[4, 5, 6, 7, 8, 9]` |
| Secuencia de tamaño impar y par<br>Odd and even sized sequences | `[3, 1, 2]` y `[4, 2, 1, 3]` | `[1, 2, 3]` y `[1, 2, 3, 4]` |
| Secuencia con negativos<br>Sequence with negatives | `[0, -5, 7, -2, 3]` | `[-5, -2, 0, 3, 7]` |
| Dos elementos / Two elements | `[2, 1]`, `[1, 2]` y `[1, 1]` | `[1, 2]`, `[1, 2]` y `[1, 1]` |
| Negativos repetidos / Repeated negatives | `[-1, 0, -1]` | `[-1, -1, 0]` |
| Un solo elemento y vacía<br>Single element and empty | `[1]` y `[]` | `[1]` y `[]` |
| Entrada ausente, si es representable / Absent input, if representable | `absent` | `absent`, distinto de vacío presente / distinct from present empty |

**ES:** Agrupa las pruebas sin ampliar las cuatro operaciones obligatorias:

- **Ordenamiento y propiedad:** cada caso para los cuatro algoritmos, con
  entradas aisladas; verifica orden, longitud y frecuencias. Quick/heap
  mutables conservan identidad y contienen la salida; merge/rojo-negro no
  alteran la entrada y devuelven otro contenedor si es mutable, incluso
  vacío/singleton.
  En adaptaciones inmutables verifica contenido de entrada y salida, y revisa
  las copias y el almacenamiento compartido en código: igualdad de valores
  no demuestra independencia de contenedores mutables.
  Prueba ausencia separadamente de `[]`, `[0]` y `[-1]`; si la entrada ausente
  no es representable, decláralo, sin inventar centinelas.
- **Heap:** verifica la propiedad padre >= hijos tras construir y tras cada
  extracción, junto con sufijo ordenado y valores del prefijo <= sufijo.
  Usa tamaños pares e impares para cubrir un nodo con solo hijo izquierdo.
- **Árbol:** tras **cada inserción completa**, verifica orden ABB con límites
  de ancestros, raíz negra, ausencia de rojo-rojo, igual altura negra y
  contadores positivos cuya suma coincide con las inserciones. Para LLRB
  añade ausencia de enlaces rojos derechos. Casos pequeños de referencia:
  `[1, 2]` (rotación izquierda), `[3, 2, 1]` (derecha y colores),
  `[3, 1, 2]` (rotaciones combinadas), `[1, 2, 3, 4, 5, 6, 7]`
  (propagación), su inversa y `[2, 2, 1, 3, 2]` (contadores).
  Estas asociaciones describen LLRB, no el recorrido exacto de otras variantes.
- **Inspección / extras:** se permiten helpers públicos para insertar, recorrer,
  obtener raíz/estructura o verificar invariantes, o un iterador que exponga
  estructura y colores. Un in-order de enteros solo prueba orden, no balance.
  No es obligatoria una API general de árbol ni una forma exacta del resultado
  de inspección. Documenta los extras y sus precondiciones; si expones rotaciones,
  prueba llamadas inválidas y ausencia de mutación antes de devolver `absent`.
  No exijas todas las invariantes durante los pasos intermedios de reparación.

**EN:** Group tests without expanding the four required operations:

- **Sorting and ownership:** run all cases for all four algorithms with
  isolated inputs; check order, length, and frequencies. Mutable quick/heap
  retain identity and contain the output; merge/red-black preserve input and
  return a different container if mutable, including empty/singleton cases.
  For immutable adaptations check input/output contents and inspect copying
  and sharing in code: value equality does not prove mutable-container
  independence. Test absence separately from `[]`,
  `[0]`, and `[-1]`; declare unrepresentable absent input without inventing
  sentinels.
- **Heap:** check parent >= children after building and each extraction, plus
  sorted suffix and prefix values <= suffix values. Include even and odd sizes
  to exercise a node with only a left child.
- **Tree:** after **each completed insertion**, check BST order against ancestor
  bounds, black root, no red-red links, equal black height, and positive counts
  summing to insertion count. LLRB additionally forbids red right links.
  Reference small cases: `[1, 2]` (left rotation), `[3, 2, 1]` (right and colors),
  `[3, 1, 2]` (combined rotations), `[1, 2, 3, 4, 5, 6, 7]` (propagation),
  its reverse, and `[2, 2, 1, 3, 2]` (counts). These associations describe LLRB,
  not other variants' exact traces.
- **Inspection / extras:** public insertion, traversal, root/structure access,
  or invariant-checking helpers are allowed, as is an iterator exposing
  structure and colors. Integer in-order alone checks ordering, not balance.
  A general tree API or exact inspection output shape is not required.
  Document extras and preconditions; if exposing rotations, test invalid calls
  and no mutation before returning `absent`. Do not require every invariant
  during intermediate repair steps.

**ES:** El borrado balanceado y las operaciones de cola de prioridad son
referencias para ejercicios futuros, no implementaciones ni pruebas exigidas
en 08. `sift_down` es una base de esa cola, no una API completa: insertar
requerirá también restaurar el heap hacia arriba.

**EN:** Balanced deletion and priority-queue operations are references for
future exercises, not required implementations or tests in 08. `sift_down`
is a building block, not a complete queue API: insertion also needs upward
heap restoration.

### Referencias teóricas / Theoretical references

- Sedgewick & Wayne, *Algorithms, 4th edition*:
  [Quicksort](https://algs4.cs.princeton.edu/23quicksort/),
  [Mergesort](https://algs4.cs.princeton.edu/22mergesort/),
  [Heaps](https://algs4.cs.princeton.edu/24pq/) y / and
  [LLRB 2-3](https://algs4.cs.princeton.edu/33balanced/).
- Okasaki, *Red-black trees in a functional setting*:
  [alternativa persistente / persistent alternative](https://www.cs.tufts.edu/comp/150FP/archive/chris-okasaki/redblack99.pdf).
- Sanders & Vadapalli:
  [rojo-negro convencional / conventional red-black trees](https://courses.ms.wits.ac.za/~steve/aaa/book/large/RedBlack.html).

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los cuatro algoritmos manualmente, sin ordenar ni delegar el árbol balanceado a bibliotecas; se conservan todos los duplicados.
      **EN:** All four algorithms are implemented manually, without delegating sorting or the balanced tree to libraries; all duplicates are preserved.
- [ ] **ES:** Se define el Node propio con clave, contador, color e hijos; el README explica su representación y no supone nodos de biblioteca.
      **EN:** An own Node defines key, count, color, and children; the README explains its representation without assuming library nodes.
- [ ] **ES:** `heap_sort` implementa el montículo binario siguiendo su definición teórica y **prefiriendo un heap plano** con acceso optimizado según las características del lenguaje y procedimiento explícito de `sift_down` (base de la cola de prioridad de Dijkstra), evitando degradaciones `O(n² log n)`.
      **EN:** `heap_sort` implements the binary heap following its theoretical definition and **preferring a flat heap** with access optimized for the language's characteristics and an explicit `sift_down` procedure (basis for Dijkstra's priority queue), avoiding `O(n² log n)` degradations.
- [ ] **ES:** `red_black_tree_sort` usa LLRB como referencia o una alternativa documentada sin mezclar reglas, conserva contadores y emite por in-order; los helpers públicos o internos de inspección son extras permitidos.
      **EN:** `red_black_tree_sort` uses reference LLRB or a documented alternative without mixing rules, preserves counts, and emits in-order; public or internal inspection helpers are allowed extras.
- [ ] **ES:** Se verifican resultados, multiplicidad e invariantes con la suite, y la complejidad real con revisión de código.
      **EN:** The suite checks results, multiplicity and invariants; code review checks real complexity.
- [ ] **ES:** La entrada ausente devuelve `absent` sin excepciones de validación, distinguible de una salida vacía presente; no hay códigos numéricos ni booleanos de éxito. Si el lenguaje lo exige por restricción propia para comparar `absent`, se permite `Option`/`Maybe` o representación etiquetada declarándolo en el README.
      **EN:** Absent input returns `absent` without validation exceptions, distinguishable from present empty output; no numeric or boolean success codes. Where language restrictions require it to compare `absent`, `Option`/`Maybe` or a tagged representation is allowed and declared in the README.
- [ ] **ES:** Quick/heap prefieren in-place; merge/rojo-negro preservan la entrada. Se verifican propiedad, copias y adaptaciones, y se documentan costes reales de acceso, reconstrucción, memoria y salida.
      **EN:** Quick/heap prefer in-place; merge/red-black preserve input. Ownership, copying, and adaptations are verified, and actual access, reconstruction, memory, and output costs are documented.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).
- [ ] **ES:** El README de Nivel 3 sigue [`README_Template.md`](../../README_Template.md) (incluidos fundamento teórico por algoritmo y ejemplo razonado) y coincide con el acta de evidencia en `docs/evidence/algorithms/efficient_sort/{language}.md`.
      **EN:** The Level 3 README follows [`README_Template.md`](../../README_Template.md) (including per-algorithm theoretical explanation and worked example) and matches the evidence record under `docs/evidence/algorithms/efficient_sort/{language}.md`.

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── algorithms/
            └── efficient_sort/
                ├── src/
                │   └── efficient_sort.ext
                └── test/
                    ├── efficient_sort_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`09_Distributed_Sort.md`](09_Distributed_Sort.md) — Ordenamiento no comparativo y variantes avanzadas (Counting, Radix, Bucket, Shell).  
👉 Continue with [`09_Distributed_Sort.md`](09_Distributed_Sort.md) — Non-comparative sorting and advanced variants (Counting, Radix, Bucket, Shell).

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
