---
layout: default
title: 07 — Structures Apps
description: Séptima especificación / Seventh specification — Aplicaciones elementales de estructuras (Stack, Queue, LinkedList, Tree)
nav_order: 3
parent: Algoritmos Puros / Algorithms Pure
grand_parent: Core
---

# 🚀 07 — Structures Apps

> [← Volver a 06_Data_Structures](06_Data_Structures.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Aplicar las estructuras de datos implementadas en la especificación anterior (`data_structures`) en problemas clásicos de baja complejidad ($O(n)$): verificación de delimitadores balanceados, evaluación de expresiones en notación postfija (RPN), operaciones sobre listas (inversión y detección de ciclo) y recorridos elementales de árbol (DFS e BFS por niveles). | Apply the data structures implemented in the previous specification (`data_structures`) to classic low-complexity problems ($O(n)$): balanced delimiter verification, postfix expression evaluation (RPN), list operations (reversal and cycle detection), and elementary tree traversals (DFS and level-order BFS). |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto `structures_apps` con un módulo que resuelva los cuatro problemas aplicando directamente las estructuras de la especificación `06_Data_Structures`. Errores de sintaxis o expresiones no computables devuelven el valor centinela `-1`. Sin excepciones. | Create a `structures_apps` project with a module solving the four problems by directly applying the structures from `06_Data_Structures`. Syntax errors or non-computable expressions return the sentinel value `-1`. No exceptions. |

### Aplicaciones y Algoritmos esperados

| Problema | Estructura base | Algoritmo / Enfoque | Valor centinela |
|----------|-----------------|---------------------|:---------------:|
| `is_balanced_delimiters(str)` | `Stack` | Apila aperturas `(`, `[`, `{`; desapila y compara en cierres `)`, `]`, `}` | Devuelve `false` si hay desbalance o no coinciden |
| `evaluate_rpn(tokens)` | `Stack` | Apila operandos; ante operador extrae 2, opera y apila resultado | División por cero o token inválido devuelve `-1` |
| `reverse_linked_list(list)` | `LinkedList` | Invierte punteros `next` iterativamente | Lista vacía devuelve `-1` |
| `has_cycle(list)` | `LinkedList` | Punteros lento y rápido de Floyd (tortuga y liebre) | Devuelve `true` si hay ciclo, `false` si no |
| `tree_traversals(tree)` | `Tree` / `Queue` | Pre-order, In-order, Post-order (recursivo/pila) y Level-order (BFS con Queue) | Árbol vacío devuelve arrays vacíos |

### Pseudocódigo / Pseudocode

```pseudocode
container structures_apps
    .- is_balanced_delimiters(str)
        stack = ArrayStack(length(str))
        for each char in str
            if char in ['(', '[', '{']
                stack.push(char)
            else if char in [')', ']', '}']
                if stack.is_empty()
                    return false
                top = stack.pop()
                if not matches(top, char)
                    return false
        return stack.is_empty()

    .- evaluate_rpn(tokens)
        stack = ArrayStack(length(tokens))
        for each token in tokens
            if is_number(token)
                stack.push(to_int(token))
            else if is_operator(token)
                if stack.size() < 2
                    return -1                      # centinela
                b = stack.pop()
                a = stack.pop()
                if token == '+' result = a + b
                else if token == '-' result = a - b
                else if token == '*' result = a * b
                else if token == '/'
                    if b == 0 return -1            # div por cero
                    result = div(a, b)
                stack.push(result)
        return stack.pop()

    .- has_cycle(list)
        slow = list.head
        fast = list.head
        while fast != -1 and list.next[fast] != -1
            slow = list.next[slow]
            fast = list.next[list.next[fast]]
            if slow == fast
                return true
        return false

    .- level_order_traversal(tree)
        if tree.is_empty()
            return []
        queue = ArrayQueue(tree.capacity)
        result = []
        queue.enqueue(tree.root)
        while not queue.is_empty()
            node = queue.dequeue()
            result.append(node.val)
            if node.left != -1 queue.enqueue(node.left)
            if node.right != -1 queue.enqueue(node.right)
        return result
end container
```

### Casos de prueba / Test Cases

| Problema | Entrada | Salida esperada |
|----------|---------|----------------|
| `is_balanced_delimiters` | `"{[()]}"` | `true` |
| `is_balanced_delimiters` | `"{[(])}"` | `false` |
| `is_balanced_delimiters` | `"((("` o `")"` | `false` |
| `evaluate_rpn` | `["2", "1", "+", "3", "*"]` | `9` (equivale a $(2+1) \times 3$) |
| `evaluate_rpn` | `["4", "13", "5", "/", "+"]` | `6` (equivale a $4 + (13 / 5)$) |
| `evaluate_rpn` | `["10", "0", "/"]` | `-1` (división por cero) |
| `has_cycle` | Lista lineal $1 \to 2 \to 3 \to \text{null}$ | `false` |
| `has_cycle` | Lista con ciclo $1 \to 2 \to 3 \to 2$ | `true` |
| `level_order_traversal` | Árbol con raíz 1, hijos 2 y 3, nietos 4 y 5 | `[1, 2, 3, 4, 5]` |

---

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** Se resuelven los problemas utilizando las estructuras modeladas con arrays de la especificación `06_Data_Structures`.  
      **EN:** Problems are solved using the array-modeled structures from specification `06_Data_Structures`.
- [ ] **ES:** Casos no válidos (desbalance, división por cero, RPN malformada) retornan valores centinela (`false` o `-1`), sin excepciones.  
      **EN:** Invalid cases (unbalance, division by zero, malformed RPN) return sentinel values (`false` or `-1`), no exceptions.
- [ ] **ES:** La detección de ciclo en lista enlazada utiliza el algoritmo de punteros lento y rápido con memoria auxiliar $O(1)$.  
      **EN:** Linked list cycle detection uses the slow/fast pointer algorithm with $O(1)$ auxiliary memory.
- [ ] **ES:** El recorrido por niveles de árbol binario se implementa mediante la cola circular (`Queue`) de la especificación previa.  
      **EN:** Binary tree level-order traversal is implemented using the circular `Queue` from the previous specification.

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── algorithms/
            └── structures_apps/
                ├── src/
                │   └── structures_apps.ext
                └── test/
                    ├── structures_apps_test.ext
                    └── run_tests.ext
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`08_Efficient_Sort.md`](08_Efficient_Sort.md) — Algoritmos de ordenamiento optimizados $O(n \log n)$ (Quick, Merge, Heap).  
👉 Continue with [`08_Efficient_Sort.md`](08_Efficient_Sort.md) — Optimized $O(n \log n)$ sorting algorithms (Quick, Merge, Heap).

---

*[← Volver a Algoritmos Puros](README.md) | [↑ Inicio](../../index.md)*
