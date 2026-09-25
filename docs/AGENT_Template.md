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
| 1 — Algorithms Pure | Indicadores de fallo compatibles, sin excepciones |
| 2 — Contiguous Processing | Validación y excepciones |
| 3 — Abstraction & Persistence | Option/Result, Maybe/Either y modelado |

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
