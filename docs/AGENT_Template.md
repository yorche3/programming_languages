# Guía para Agentes de IA / AI Agent Guide

Esta guía complementa las instrucciones de `AGENTS.md` y describe cómo generar
o corregir documentación en este monorepo. La plantilla de README de Nivel 3
es [`README_Template.md`](README_Template.md).

## Alcance / Scope

Los agentes ayudan principalmente con documentación, verificación y revisiones
puntuales. El autor implementa los lenguajes para practicar; generar código
nuevo requiere una petición explícita.

## Antes de escribir / Before writing

1. Ejecutar `git status --short` y `git submodule status` en la raíz.
2. Comprobar la rama del submódulo afectado.
3. Leer la especificación y `docs/ROADMAP.md`.
4. No tocar una rama `feature/*` activa sin autorización.
5. Verificar que el estado indicado en el roadmap corresponde a código, tests y
   documentación existentes.

## Niveles de documentación / Documentation levels

| Nivel / Level | Archivo / File | Base / Source |
|---|---|---|
| 1 — Lenguaje / Language | `{lenguaje}/README.md` | README del lenguaje equivalente |
| 2 — Fase / Phase | `{lenguaje}/core/README.md` o `{lenguaje}/core/{fase}/README.md` | READMEs de fases existentes |
| 3 — Módulo / Module | `{lenguaje}/core/{fase}/{modulo}/README.md` | [`README_Template.md`](README_Template.md) |

## Reglas / Rules

- Mantener el formato bilingüe español/inglés.
- Usar enlaces GitHub Pages donde lo exijan las guías de documentación.
- Copiar solo salidas reales de compilación y tests.
- Explicar las adaptaciones del lenguaje, incluido TCO y la estructura de tests.
- No marcar un módulo o fase como completado sin verificación.
- No ejecutar `git push` ni crear commits salvo instrucción explícita.
- Al finalizar código y documentación, completar
  [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) y actualizar
  `ROADMAP.md` en el mismo cambio.

## Evolución por fase / Phase evolution

`README_Template.md` es la plantilla única de Nivel 3. Se puede ampliar cuando
una fase introduce conceptos nuevos, pero no se crean copias por lenguaje ni
plantillas paralelas con nombres distintos.

| Fase / Phase | Concepto / Concept |
|---|---|
| 0 — Foundations | Recursión, acumulador, iteración y TCO |
| 1 — Algorithms Pure | Indicadores de fallo compatibles, sin excepciones; contrato explícito con una sola implementación |
| 2 — Contiguous Processing | Validación y excepciones |
| 3 — Algorithms on Structures | Contratos abstractos cuando un algoritmo consume estructuras intercambiables |
| 4 — Abstraction & Persistence | Option/Result, Maybe/Either y modelado |
| 5 — Math | Tipos numéricos y representación de matrices y vectores |
| 6–7 — UI y Web | Interfaces de puerto y adaptador e inyección de dependencias |

---

## 🔌 Contrato, abstracción e interfaces / Contract, abstraction and interfaces

**ES:** El **contrato** es lo que el módulo promete —operaciones, semántica, orden observable, límites y complejidad— y es **normativo y global**: no cambia de un lenguaje a otro. La **forma de declararlo** es **idiomática y local**: Ada usa la *package specification*, C un encabezado con un tipo opaco, Haskell la lista de exportación del módulo, y Java la API pública de una clase o una `interface`. Separar ambos planos es la ocultación de información de Parnas (1972) y la abstracción de datos de Liskov (1974): la especificación es independiente de la representación, y la notación elegida no altera el contrato.

**EN:** The **contract** is what the module promises —operations, semantics, observable order, limits and complexity— and it is **normative and global**: it does not change from language to language. The **way it is declared** is **idiomatic and local**: Ada uses the *package specification*, C a header with an opaque type, Haskell the module's export list, and Java a class's public API or an `interface`. Separating both planes is Parnas's information hiding (1972) and Liskov's data abstraction (1974): the specification is independent of the representation, and the chosen notation does not alter the contract.

### Notación idiomática del contrato / Idiomatic notation of the contract

**ES:** La tabla agrupa por **familia de notación**, no por lenguaje: el contrato se declara siempre en la forma que ese lenguaje usa para separar «qué hace» de «cómo lo hace». La tercera columna indica si el lenguaje tiene una construcción dedicada para un contrato **aparte**; usarla con una sola implementación es abstracción prematura.

**EN:** The table groups by **notation family**, not by language: the contract is always declared in the shape that language uses to separate "what it does" from "how it does it". The third column states whether the language has a dedicated construct for a **separate** contract; using it with a single implementation is premature abstraction.

| Familia / Family | Declaración del contrato / Contract declaration | Contrato aparte / Separate contract |
|---|---|---|
| Ada | *package specification* (público) y *package body* (oculto) | No hace falta: la propia especificación ya es el contrato |
| C, Assembly, COBOL, Forth | Encabezado o sección de declaraciones; tipo opaco o puntero incompleto | No existe; el contrato es el encabezado |
| C++ | Encabezado con `class`/`struct`; `private` oculta la representación | Clase abstracta o método virtual puro cuando hay más de una implementación |
| Java, C#, Kotlin, Scala, Dart | Miembros públicos de la clase | `interface` o `abstract class` cuando hay más de una implementación |
| Rust | Módulo con `pub` | `trait` cuando hay más de una implementación |
| Swift, Objective-C | Miembros públicos | `protocol` |
| Go | Nombres exportados del paquete | `interface` implícita; se declara cuando se consume polimórficamente |
| Haskell, OCaml, F# | Lista de exportación del módulo o firma `.mli` | Clase de tipos o firma de módulo cuando hay más de una implementación |
| Elm, Erlang, Elixir, Gleam, Clojure, Common Lisp, Scheme, Prolog | Exportación del módulo y sus funciones | `behaviour`, protocolo o multimétodo cuando hay más de una implementación |
| Python, Ruby, Perl, Raku, Lua, Tcl/Tk | API documentada y convenida | `Protocol`/`ABC`/rol o módulo de contrato cuando hay más de una implementación |

### Momento de adopción por fase / Adoption moment per phase

| Fase / Phase | Qué se exige / What is required | Por qué / Why |
|---|---|---|
| 0 — Foundations | El contrato se declara en la notación natural del lenguaje; sin contratos aparte | El programa es una función y no hay nada que abstraer |
| 1 — Algorithms Pure | Igual: contrato normativo y representación libre. **No** se exige `interface`/`trait`/`protocol` | Hay **una** implementación por estructura; abstraer antes de tener lo concreto es prematuro (HtDP: *abstract after concrete*) |
| 3 — Algorithms on Structures | **Primer uso con sentido**: cuando un algoritmo debe consumir estructuras intercambiables (cola de prioridad de Dijkstra; pila y cola de BFS, DFS y backtracking) | Es el caso de las operaciones genéricas de SICP §2.4–2.5: la abstracción se justifica cuando existen **varias** representaciones de la misma interfaz |
| 4 — Abstraction & Persistence | Contratos formales con varias implementaciones reales (consultas crudas frente a ORM, *parsers* intercambiables) y tipos de retorno `Option`/`Result` | Meyer (1988): el contrato se especifica con precondiciones, postcondiciones e invariantes; sustituibilidad de Liskov |
| 6–7 — UI y Web | Interfaces de puerto y adaptador, inyección de dependencias y dobles de prueba | La capa de aplicación depende de abstracciones y no de implementaciones |

**ES:** Consecuencia para las especificaciones: la de Fase 1 fija **comportamiento** (resultado de éxito, resultado de fallo, límites, orden y complejidad) y deja libre la **forma**; no puede exigir una construcción que solo tiene sentido cuando aparece un segundo consumidor o una segunda implementación. Una especificación que obligue a `interface` donde hay una sola implementación es un hallazgo, igual que una que deje sin definir qué devuelve una operación.

**EN:** Consequence for specifications: a Phase 1 specification fixes **behaviour** (success result, failure result, limits, order and complexity) and leaves the **form** free; it cannot require a construct that only makes sense once a second consumer or a second implementation appears. A specification that mandates an `interface` where there is a single implementation is a finding, as is one that leaves undefined what an operation returns.

**ES:** Referencias que sostienen este calendario: Parnas, *On the Criteria To Be Used in Decomposing Systems into Modules* (1972); Liskov y Guttag, *Abstraction and Specification in Program Development* (1986); Abelson y Sussman, *SICP* §2.1 (barrera de abstracción) frente a §2.4–2.5 (operaciones genéricas); Felleisen et al., *How to Design Programs* (la abstracción llega después de lo concreto); Meyer, *Object-Oriented Software Construction* (1988); Cormen et al., *CLRS* (el ADT «cola de prioridad» se especifica aparte del heap que lo implementa).

**EN:** References supporting this calendar: Parnas, *On the Criteria To Be Used in Decomposing Systems into Modules* (1972); Liskov and Guttag, *Abstraction and Specification in Program Development* (1986); Abelson and Sussman, *SICP* §2.1 (abstraction barrier) versus §2.4–2.5 (generic operations); Felleisen et al., *How to Design Programs* (abstraction comes after the concrete); Meyer, *Object-Oriented Software Construction* (1988); Cormen et al., *CLRS* (the "priority queue" ADT is specified apart from the heap implementing it).

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

**ES:** Una **adaptación idiomática** es la desviación **declarada y justificada** del pseudocódigo o de la ubicación esperada cuando el lenguaje no puede hacer lo que el pseudocódigo hace. No es estilo: es lo que el lenguaje **no soporta** (mutación, índices enteros, `null`, bucles). Desarrolla la regla «explicar las adaptaciones del lenguaje» de arriba y se escribe en la tabla _Adaptaciones idiomáticas_ de [`README_Template.md`](README_Template.md); una desviación sin fila es un hallazgo.

**EN:** An **idiomatic adaptation** is the **declared and justified** deviation from the pseudocode or the expected location when the language cannot do what the pseudocode does. It is not style: it is what the language **does not support** (mutation, integer indices, `null`, loops). It develops the "explain the language's adaptations" rule above and goes in the _Idiomatic adaptations_ table of [`README_Template.md`](README_Template.md); a deviation with no row is a finding.

> **ES:** Esta guía fija las **reglas**, que no cambian de un módulo a otro. El **indicador de fallo de cada lenguaje** (qué devuelve C, qué caso omite Haskell) es **estado del módulo**: vive en la tabla _Indicadores de fallo_ de su README y se escribe al implementarlo, no aquí.
> **EN:** This guide states the **rules**, which do not change from module to module. Each **language's failure indicator** is **module state**: it lives in its README's _Failure indicators_ table and is written when implementing, not here.

### Reglas de una adaptación / Rules for an adaptation

1. **El contrato manda.** La adaptación cambia la **forma**, nunca el resultado observable: mismos casos, mismo orden, misma complejidad prometida. Si cambia el resultado, es un defecto y se reporta.
2. **Sin atajos de biblioteca.** En Fase 1 están prohibidas las rutinas de ordenamiento, búsqueda o **selección** (`sort`, `min`, `max`…) de la biblioteca estándar para el paso interno del algoritmo.
3. **Sin envoltorios de error.** El contrato se declara con el indicador **natural** del lenguaje (`null`, `nil`, `None`, `#f`, `-1`, `nothing`); `Option`/`Maybe`/`Result` y las excepciones llegan en fases posteriores, según la tabla de evolución por fase.
4. **Una fila por desviación**, con qué dice la especificación, qué hace el código y por qué.
5. **Los tests también se adaptan y se declaran.** Si un caso no es representable, se **omite** y se dice en _Cobertura de pruebas_; no se sustituye por otro caso ni se inventa un centinela imposible.
6. **Nunca se silencia.** Una línea del pseudocódigo que no se puede seguir se cita en la justificación, tal cual; no se esconde en un comentario del código.

### Familias de limitación / Limitation families

**ES:** Los desafíos no se enumeran por lenguaje (50 filas dirían lo mismo 50 veces) sino por **familia**. Un lenguaje puede estar en varias filas.

**EN:** Challenges are not listed per language (50 rows would repeat themselves) but by **limitation family**. A language may appear in several rows.

| Familia / Family | Lenguajes típicos / Typical languages | Adaptación declarada / Declared adaptation |
|---|---|---|
| Sin mutación razonable | Haskell, Elm, Erlang, Gleam, PureScript, Scheme, Clojure, Common Lisp, Prolog, F# | Devolver una colección **nueva** o recurrir sobre listas, con la misma complejidad prometida |
| Sin índices enteros ni bucles | Prolog, Haskell, Erlang, Scheme, Common Lisp, Forth | Recursión sobre lista (con acumulador cuando no haya TCO) y cabeza/cola |
| Sin `null`/`nil` en un tipo de valor | Haskell, Elm, Erlang, Gleam, Rust, Swift, V, Vala, Zig, C++, OCaml, PureScript, Tcl/Tk… | **No representable**: el caso se omite con nota; no se introduce `Option`/`Maybe` antes de su fase |
| Opcional nativo disponible | C#, F#, Ballerina, Kotlin, Nim, Crystal, TypeScript | Usar el opcional del lenguaje como indicador, sin envoltorios añadidos |
| Capacidad fija y overflow | C, Ada, Assembly, COBOL, Forth | Presupuesto de memoria declarado; el overflow es un caso probado, no un accidente |
| Centinela `-1` y tipos de índice | lenguajes con índices sin signo o basados en 1 | El indicador nativo del lenguaje y su fila en la tabla de adaptaciones |
| Suite y runner | Prolog (plunit), Tcl/Tk, Forth, COBOL, Ada, Rust | La ubicación que el framework espera (`tests/`, `src/`, `t/`) se declara como desviación |

### Formato de la fila / Row format

| Columna / Column | Qué va / What goes in | Reglas / Rules |
|---|---|---|
| Especificación / Specification | La línea o sección que no se puede seguir tal cual | Cita el texto, no lo parafrasees |
| Adaptación / Adaptation | Qué hace el código en su lugar | Nombra la construcción del lenguaje (`int[]?`, recursión sobre listas, vector interno) |
| Justificación / Justification | La limitación y qué se conserva | Di qué se mantiene del contrato y qué caso se omite si aplica |

**ES:** Ejemplos genéricos: el caso nulo **no representable** se omite y se declara; un lenguaje sin bucles ni mutación resuelve con recursión sobre listas; un layout con `tests/` del framework en lugar de `test/run_tests.ext` se declara como desviación de la ubicación esperada.

**EN:** Generic examples: a **not representable** null case is omitted and declared; a language with no loops or mutation solves it by recursion over lists; a layout with the framework's `tests/` instead of `test/run_tests.ext` is declared as a deviation from the expected location.

### Qué NO es una adaptación / What is NOT an adaptation

- Usar la colección optimizada del lenguaje para **construir** una estructura que el módulo existe para construir, salvo que el propio módulo lo declare.
- Cambiar un caso de prueba porque «en este lenguaje es más natural así».
- Saltarse el aislamiento de tests: si la función muta la entrada, cada caso copia su fixture.
- Añadir dependencias que la guía de inicialización no declara.
- Silenciar una desviación en un comentario del código en vez de en el README.
