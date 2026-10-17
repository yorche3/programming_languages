# 04 — Numbers: cómo se implementa en cada familia
# 04 — Numbers: how it is implemented in each family

> **ES:** Guía de implementación del módulo. Explica **cómo** y **por qué** el pseudocódigo de la especificación se escribe de forma distinta en cada familia de lenguajes. **No añade requisitos**: los criterios están en [`04_Numbers.md`](../core/foundations/04_Numbers.md) y, si esta guía y la especificación discrepan, manda la especificación.
>
> **EN:** Implementation guide for the module. It explains **how** and **why** the specification's pseudocode is written differently in each language family. It **adds no requirements**: the criteria live in [`04_Numbers.md`](../core/foundations/04_Numbers.md) and, should this guide and the specification disagree, the specification wins.

---

## 1. La solución canónica, en llano / The canonical solution, in plain words

**ES:** El módulo pide **cinco algoritmos** —suma de los primeros `n`, factorial, Fibonacci, MCD y MCM— resueltos **tres veces**, con el mismo resultado y distinto reparto del trabajo:

- **`_rec` (recursión directa)** es la definición matemática escrita tal cual: `sum(n) = n + sum(n - 1)`. Al volver de la llamada **queda trabajo pendiente** (esa suma que se hace al final), y por eso cada llamada ocupa un marco de pila hasta que la recursión termina.
- **`_acc` (recursión con acumulador)** mueve ese trabajo pendiente a un **parámetro**: `sum(n, acc) = sum(n - 1, acc + n)`. Ya no hay nada que hacer al volver, así que la llamada puede ser la **última instrucción**. Eso es *tail-call*: si el lenguaje lo garantiza, la pila no crece y la recursión es un bucle disfrazado.
- **`_ite` (iterativo)** hace lo mismo que `_acc` pero con un bucle: **memoria constante** por construcción, sin depender de ninguna optimización.

**Lo que la especificación fija de verdad:** los cinco algoritmos, los 11 casos por variante, la separación código/pruebas, solo biblioteca estándar y el techo de complejidad. **Lo que es solo forma:** cuántas de las tres variantes puede probar tu lenguaje. Eso lo decide el lenguaje, no el módulo.

**EN:** The module asks for **five algorithms** —sum of the first `n`, factorial, Fibonacci, GCD and LCM— solved **three times**, with the same result and a different distribution of work: `_rec` is the mathematical definition as is (work is left **after** the call, so each call holds a stack frame), `_acc` moves that work into a **parameter** (nothing left to do on return, so the call is the last instruction — a tail call), and `_ite` does the same with a loop (constant memory by construction, with no optimisation needed).

**What the specification actually fixes:** the five algorithms, the 11 cases per variant, the source/test split, standard library only and the complexity ceiling. **What is just form:** how many of the three variants your language can test. The language decides that, not the module.

---

## 2. Los ejes que cambian en este módulo / The axes that change here

| Eje / Axis | Pregunta / Question | Si sí / If yes | Si no / If no |
|---|---|---|---|
| **Recursión de cola (TCO)** | ¿El runtime garantiza que una auto-llamada de cola no crece la pila? | `_acc` es un bucle real y lleva **su suite** (11 casos más) | `_acc` se queda como puente didáctico hacia `_ite`, **sin suite propia** |
| **Iteración nativa** | ¿Hay bucles `for`/`while` (o combinadores usados de forma iterativa)? | `_ite` lleva **su suite** | La suite iterativa se omite |
| **Memoria y llamadas** | ¿Quién paga la recursión? | Pila + GC, o TCO con pila constante, o bucle sin recursión | — |

**ES:** Los dos primeros ejes son **independientes**: de ahí salen las combinaciones de 33 (`rec`+`acc`+`ite`), 22 (`rec`+`acc` o `rec`+`ite`) y 11 (`rec` sola) pruebas. Cada README del módulo declara la suya y por qué.
**EN:** The first two axes are **independent**, which is where the 33 / 22 / 11 test combinations come from. Each module README declares which one applies and why.

---

## 3. Las variantes, familia a familia / The variants, family by family

**ES:** El mismo caso —`sum_of_first_n(3) = 6`— escrito en el código real del repo:
**EN:** The same case —`sum_of_first_n(3) = 6`— written in the repo's real code:

| Familia (ejemplos) / Family | Se escribe así / It is written like this | Por qué / Why | Qué gana y qué pierde / Gains and loses |
|---|---|---|---|
| **F1** OO con null (`java`, `csharp`, `kotlin`, `scala`…) | `int result = 0;`<br>`for (int i = 1; i <= n; i++) {`<br>`    result += i;`<br>`}`<br>`return result;` | el objeto agrupa el estado y el bucle es explícito | legible y sin sorpresas; el recorrido es manual y verboso |
| **F2** Scripting dinámico (`python`, `ruby`, `javascript`…) | `result = 0`<br>`for i in range(1, n + 1):`<br>`    result += i`<br>`return result` | misma forma que F1, sin tipos declarados | lo más corto de escribir; sin TCO, así que `_acc` no lleva suite |
| **F3** C-lineage (`c`, `ada`, `cobol`, `forth`, `assembly`) | `int sum = 0;`<br>`for (int i = 1; i <= n; i++) {`<br>`    sum += i;`<br>`}`<br>`return sum;` | control total y memoria manual | control y cero GC; mucha ceremonia (`ada` 196 líneas, `cobol` 440) |
| **F5** Funcional ML/Haskell (`haskell`, `ocaml`, `elm`, `fsharp`…) | `sumFirstNRec n`<br>`  \| n <= 0    = 0`<br>`  \| otherwise = n + sumFirstNRec (n - 1)` | no hay mutación: la recursión **es** el recorrido, y el acumulador se pasa como parámetro | una expresión por caso; el coste es que la pila depende de TCO |
| **F7** BEAM (`erlang`, `elixir`, `gleam`) | `sum_first_n_rec(0) -> 0;`<br>`sum_first_n_rec(N) -> N + sum_first_n_rec(N - 1).` | TCO garantizada: la recursión es el bucle, pero sin crecer la pila | pila constante e idiomático; no hay bucles, así que no hay `_ite` |

**ES:** En F5 y F7 la variante `_acc` **sí importa**: es la diferencia entre crecer la pila y no crecerla. En F1–F3 la misma `_acc` no aporta nada medible sin TCO, y el módulo lo dice en voz alta: se queda como puente didáctico, sin suite.
**EN:** In F5 and F7 the `_acc` variant **matters**: it is the difference between growing the stack and not. In F1–F3 the same `_acc` buys nothing measurable without TCO, and the module says so out loud: it stays as a didactic bridge, with no suite.

---

## 4. Consecuencias: coste, pila y memoria / Consequences: cost, stack and memory

**ES:** La complejidad algorítmica ya la fija la especificación ($O(n)$ en las sumatorias y el factorial, $O(\log n)$ en el MCD) y `fibonacci_rec` es $O(2^n)$ **por diseño educativo**. Lo que distingue a los tres enfoques no es el tiempo, es **la memoria**:

- **`_rec`** deja trabajo pendiente al volver, así que la pila crece con `n` (un marco por llamada). Con los 11 casos del módulo no hay problema; con un `n` grande, sí.
- **`_acc`** deja la pila constante **solo si el runtime garantiza TCO**. Si no lo garantiza, es exactamente `_rec` con otra forma. Esa es la razón de la regla condicional de las suites, no una comodidad.
- **`_ite`** gasta memoria constante en **todos** los lenguajes: es el criterio «memoria constante $O(1)$» de la especificación.

**Coste de expresión medido** (líneas de la fuente del módulo por lenguaje, 2026-10-16): de **43** en `elixir` y **46** en `erlang` a **196** en `ada`, **358** en `assembly` y **440** en `cobol`. La diferencia es la forma del lenguaje, no el algoritmo: los cinco algoritmos y sus 11 casos son los mismos en los 50.

**EN:** Algorithmic complexity is fixed by the specification and `fibonacci_rec` is $O(2^n)$ **on purpose**. What distinguishes the three approaches is not time but **memory**: `_rec` grows the stack with `n`, `_acc` keeps it constant **only when TCO is guaranteed** (that is why the suite rule is conditional, not a convenience) and `_ite` spends constant memory in **every** language, which is the specification's $O(1)$ criterion. Measured expression cost ranges from 43 lines in Elixir to 440 in COBOL, and that is the language's shape, not the algorithm's.

---

## 5. Trampas para quien llega nuevo / Traps for newcomers

- **`_acc` sin TCO no compra nada.** Si tu lenguaje no garantiza la optimización, la variante con acumulador no es «la rápida»: es un puente hacia `_ite`. No le escribas suite; la especificación lo pide así.
- **En Haskell el `_ite` no es un bucle.** `foldl'` y `until` son la forma idiomática de recorrer de forma iterativa; el módulo acepta combinadores usados explícitamente como iteración.
- **En Elixir no hay una versión iterativa explícita**, y no es un defecto: la forma idiomática de iterar es la recursión con acumulador.
- **`fibonacci_rec` es exponencial a propósito.** Es el coste que el módulo quiere que se vea; no lo «optimices».
- **El tamaño del entero importa menos de lo que parece:** `int` de 32 bits alcanza para los 11 casos en todos los lenguajes, aunque Python, Haskell o Raku trabajen con precisión arbitraria.
- **La combinación de suites la declara tu README**, no esta guía. Si dudas de si tu lenguaje tiene TCO, la respuesta está en la especificación del lenguaje, no en el compilador que tengas instalado.

---

## 6. Dónde seguir / Where next

| Capa / Layer | Documento / Document |
|---|---|
| Qué se exige / What is required | [`04_Numbers.md`](../core/foundations/04_Numbers.md) |
| Las familias en general / Families in general | [`PARADIGM_FAMILIES.md`](../ruleset/PARADIGM_FAMILIES.md) |
| Qué obliga tu lenguaje / What your language mandates | [`idioms/{lang}.md`](../ruleset/idioms/) |
| Qué se verificó en los 50 / What was verified across the 50 | [`04_Audited_Numbers.md`](../audits/04_Audited_Numbers.md) |
