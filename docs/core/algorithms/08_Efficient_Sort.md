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

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
|---------|---------|
| Crear `efficient_sort` con `quick_sort(arr)`, `merge_sort(arr)`, `heap_sort(arr)` y `red_black_tree_sort(arr)`. Cada función recibe una **secuencia indexable de enteros** y devuelve sus valores en orden ascendente, conservando todas las repeticiones. La representación y si se modifica la entrada se declaran en el README. Una entrada nula devuelve un indicador de fallo compatible con el lenguaje/API; una vacía o de un elemento conserva su contenido. Sin excepciones. | Create `efficient_sort` with `quick_sort(arr)`, `merge_sort(arr)`, `heap_sort(arr)`, and `red_black_tree_sort(arr)`. Each function receives an **indexable integer sequence** and returns its values in ascending order, preserving every duplicate. The README declares the representation and whether input is modified. Null input returns a language/API-compatible failure indicator; empty and single-element inputs retain their contents. No exceptions. |

**ES:** El árbol rojo-negro es una estructura interna para ordenar: no se pide
una API pública de búsqueda o eliminación. El árbol del módulo 07 introduce
inserción y búsqueda ABB, pero no es un rojo-negro ni preserva duplicados; no se
importa ni se asume que ya esté balanceado. El heap de `heap_sort` no es un
árbol rojo-negro: su invariante solo ordena cada padre respecto de sus hijos.

**EN:** The red-black tree is an internal structure for sorting: no public
search or deletion API is required. Module 07 introduces BST insertion and
search, but it is not a red-black tree and does not preserve duplicates; do not
import it or assume it is balanced. The heap in `heap_sort` is not a red-black
tree: its invariant orders each parent only with respect to its children.

**ES:** Implementa manualmente los cuatro algoritmos, sus comparaciones y el
árbol rojo-negro; no delegues el ordenamiento ni el árbol balanceado en
bibliotecas. Las primitivas de secuencia, asignación y enlaces del lenguaje
pueden apoyar la representación. Documenta las adaptaciones inmutables y el
coste real; una adaptación que no conserva las invariantes o cotas es un
bloqueo a consultar, no una excepción implícita.

**EN:** Implement all four algorithms, their comparisons, and the red-black
tree manually; do not delegate sorting or the balanced tree to libraries.
Language sequence, allocation and linking primitives may support representation.
Document immutable adaptations and real costs; an adaptation that cannot retain
the invariants or bounds is a blocker to discuss, not an implicit exception.

### Algoritmos esperados

| Algoritmo | Estrategia | Complejidad temporal | Memoria auxiliar |
|-----------|------------|---------------------|:----------------:|
| `quick_sort(arr)` | Partición recursiva respecto a un pivote (Hoare o Lomuto) | $O(n \log n)$ promedio, $O(n^2)$ peor | $O(\log n)$ promedio; $O(n)$ peor (pila / stack) |
| `merge_sort(arr)` | División recursiva a la mitad y fusión ordenada de sub-secuencias | $O(n \log n)$ en todos los casos | $O(n)$ (secuencia auxiliar de fusión) |
| `heap_sort(arr)` | Max-heap in-place y extracción sucesiva / Max-heap and successive extraction | $O(n \log n)$ peor / worst | $O(1)$ con `sift_down` iterativo / with iterative `sift_down` |
| `red_black_tree_sort(arr)` | Insertar en ABB rojo-negro, recorrer in-order / Insert into red-black BST, traverse in-order | $O(n \log n)$ peor / worst | $O(n)$ árbol y salida / tree and output |

**ES:** En el rojo-negro: raíz negra; hojas ausentes negras; ningún nodo rojo
tiene hijo rojo; cada camino de un nodo a una hoja ausente tiene igual número
de nodos negros. Las claves menores van a la izquierda y las mayores a la
derecha. Una implementación puede guardar un contador por clave para conservar
duplicados: el recorrido emite cada clave tantas veces como se insertó.
Insertar cuesta `O(log n)` por valor; recorrer y emitir los `n` valores cuesta
`O(n)`. El balance se restaura con recoloración y rotaciones que preservan el
orden ABB, no con `sift_down`.

**EN:** In the red-black tree: the root is black; absent leaves are black; red
nodes have no red children; every path from a node to an absent leaf has the
same number of black nodes. Smaller keys go left and larger keys right. A
per-key count may preserve duplicates: traversal emits each key as many times
as it was inserted. Each insertion costs `O(log n)`; traversal and emission of
the `n` values cost `O(n)`. Recolouring and rotations restore balance while
preserving BST order, not `sift_down`.

### Pseudocódigo / Pseudocode

```pseudocode
container efficient_sort
    .- quick_sort(arr)
        if arr is null return -1
        quick_sort_help(arr, 0, size(arr) - 1)
        return arr

    .- quick_sort_help(arr, low, high)
        if low < high
            p = partition(arr, low, high)
            quick_sort_help(arr, low, p)
            quick_sort_help(arr, p + 1, high)

    .- partition(arr, low, high)
        pivot = arr[low + div(high - low, 2)]
        i = low - 1
        j = high + 1
        while true
            repeat i = i + 1 until arr[i] >= pivot
            repeat j = j - 1 until arr[j] <= pivot
            if i >= j return j
            swap(arr, i, j)

    .- merge_sort(arr)
        if arr is null return -1
        if size(arr) <= 1 return arr
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
        if arr is null return -1
        n = size(arr)
        # Construir max-heap
        for i = div(n, 2) - 1 down to 0
            sift_down(arr, n, i)
        # Extraer elementos del heap
        for i = n - 1 down to 1
            swap(arr, 0, i)
            sift_down(arr, i, 0)
        return arr

    .- sift_down(arr, n, root)
        while true
            largest = root
            left = 2 * root + 1
            right = 2 * root + 2
            if left < n and arr[left] > arr[largest] largest = left
            if right < n and arr[right] > arr[largest] largest = right
            if largest == root return
            swap(arr, root, largest)
            root = largest
end container
```

### Árbol rojo-negro para ordenar / Red-black tree for sorting

**ES:** El siguiente esquema fija el algoritmo sin exigir una API de árbol
pública. `NIL` representa una hoja negra ausente; sus hijos también se tratan
como negros. Las rotaciones actualizan padres, hijos y raíz del árbol. El
contador evita imponer una regla de posición arbitraria para claves iguales.

**EN:** The following sketch fixes the algorithm without requiring a public
tree API. `NIL` represents a black absent leaf; its children are also treated
as black. Rotations update parents, children and the tree root. Counts avoid an
arbitrary positional rule for equal keys.

```pseudocode
red_black_tree_sort(arr)
    if arr is null return failure
    root = NIL
    for value in arr
        parent = NIL
        current = root
        while current != NIL and current.key != value
            parent = current
            if value < current.key then current = current.left
            else current = current.right
        if current != NIL
            current.count = current.count + 1
        else
            node = new red node(key=value, count=1, left=NIL, right=NIL, parent=parent)
            if parent == NIL then root = node
            else if value < parent.key then parent.left = node
            else parent.right = node
            root = repair_after_insert(root, node)
    result = empty sequence
    append_in_order(root, result)
    return result

append_in_order(node, result)
    if node == NIL return
    append_in_order(node.left, result)
    repeat node.count times: append node.key to result
    append_in_order(node.right, result)

repair_after_insert(root, node)
    while node.parent.color == RED
        parent = node.parent
        grandparent = parent.parent
        if parent == grandparent.left
            uncle = grandparent.right
            if uncle.color == RED
                parent.color = BLACK
                uncle.color = BLACK
                grandparent.color = RED
                node = grandparent
            else
                if node == parent.right
                    node = parent
                    root = rotate_left(root, node)
                node.parent.color = BLACK
                node.parent.parent.color = RED
                root = rotate_right(root, node.parent.parent)
        else
            uncle = grandparent.left
            if uncle.color == RED
                parent.color = BLACK
                uncle.color = BLACK
                grandparent.color = RED
                node = grandparent
            else
                if node == parent.left
                    node = parent
                    root = rotate_right(root, node)
                node.parent.color = BLACK
                node.parent.parent.color = RED
                root = rotate_left(root, node.parent.parent)
    root.color = BLACK
    return root

rotate_left(root, node)
    child = node.right
    node.right = child.left
    if child.left != NIL then child.left.parent = node
    child.parent = node.parent
    if node.parent == NIL then root = child
    else if node == node.parent.left then node.parent.left = child
    else node.parent.right = child
    child.left = node
    node.parent = child
    return root

rotate_right(root, node)
    child = node.left
    node.left = child.right
    if child.right != NIL then child.right.parent = node
    child.parent = node.parent
    if node.parent == NIL then root = child
    else if node == node.parent.right then node.parent.right = child
    else node.parent.left = child
    child.right = node
    node.parent = child
    return root
```

**ES:** `NIL.color` es negro también cuando `node` es la raíz. Una
representación persistente puede reconstruir el camino en vez de mutar
punteros, siempre que mantenga los mismos resultados, invariantes y cotas.
`append` debe ser amortizado `O(1)` o equivalente para evitar `O(n²)`.
**EN:** `NIL.color` is black even when `node` is the root. A persistent
representation may rebuild the path instead of mutating pointers if it retains
the results, invariants and bounds. `append` must be amortized `O(1)` or
equivalent to avoid `O(n²)`.

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
| Un solo elemento y vacía<br>Single element and empty | `[1]` y `[]` | `[1]` y `[]` |
| Entrada ausente, si es representable / Absent input, if representable | `null` | indicador de fallo documentado / documented failure indicator |

**ES:** Ejecuta cada caso para los cuatro algoritmos con entradas aisladas. Para
el rojo-negro, verifica además las invariantes tras cada inserción en secuencias
ascendentes, descendentes, zigzag, con duplicados y de recoloración; una salida
ordenada no demuestra balance. Si el lenguaje no representa una entrada ausente,
decláralo; no se inventa un centinela que colisione con resultados válidos.
**EN:** Run each case for all four algorithms with isolated inputs. For the
red-black tree also check the invariants after every insertion in ascending,
descending, zigzag, duplicate and recolouring sequences; sorted output alone
does not prove balance. If absent input is not representable, declare it; do not
invent a sentinel that collides with valid results.

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se implementan los cuatro algoritmos manualmente, sin ordenar ni delegar el árbol balanceado a bibliotecas; se conservan todos los duplicados.
      **EN:** All four algorithms are implemented manually, without delegating sorting or the balanced tree to libraries; all duplicates are preserved.
- [ ] **ES:** `heap_sort` implementa el montículo binario mediante una **secuencia indexable plana** con procedimiento explícito de `sift_down` (este procedimiento es la base de la cola de prioridad de Dijkstra).
      **EN:** `heap_sort` implements the binary heap through a **flat indexable sequence** with an explicit `sift_down` procedure (this procedure is the basis for Dijkstra's priority queue).
- [ ] **ES:** `red_black_tree_sort` construye un ABB rojo-negro, repara sus invariantes por recoloración y rotaciones y emite una secuencia por recorrido in-order; el árbol no es una API pública obligatoria.
      **EN:** `red_black_tree_sort` builds a red-black BST, repairs its invariants through recolouring and rotations, and emits a sequence through in-order traversal; a public tree API is not required.
- [ ] **ES:** Se verifican resultados, multiplicidad e invariantes con la suite, y la complejidad real con revisión de código.
      **EN:** The suite checks results, multiplicity and invariants; code review checks real complexity.
- [ ] **ES:** El caso nulo retorna el indicador de fallo compatible con el lenguaje/API (por ejemplo, `-1` cuando el tipo lo permite), sin excepciones.
    **EN:** Null input returns a language/API-compatible failure indicator (for example, `-1` when the type permits it), without exceptions.
- [ ] **ES:** El proyecto separa el código fuente (`src/`) de las pruebas (`test/`).  
      **EN:** The project separates source code (`src/`) from tests (`test/`).

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
