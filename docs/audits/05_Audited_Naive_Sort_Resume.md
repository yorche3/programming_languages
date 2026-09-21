# Auditoría de Módulo: 05_Naive_Sort
# Module Audit: 05_Naive_Sort

Documento de seguimiento de deuda técnica para mantener el estado homologado de los lenguajes en el módulo `05_Naive_Sort`.
Technical debt tracking document to maintain the homologated state of the languages in the `05_Naive_Sort` module.

## Criterios de Evaluación / Evaluation Criteria
1. **Fidelidad Algorítmica / Algorithmic Fidelity**: Implementación estricta del pseudocódigo $O(n^2)$ (o equivalente recursivo en funcionales puros).
2. **Contrato (Errores) / Contract (Errors)**: Manejo de fallos con el indicador natural del lenguaje (null/nil/nothing), sin excepciones ni wrappers (Option/Maybe).
3. **Aislamiento de Tests / Test Isolation**: Copia de arreglos mutables antes de enviarlos a las funciones de ordenamiento.
4. **Documentación / Documentation**: Alineado a `README_Template.md` y Notas Aclaratorias en caso de excepciones al paradigma.

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)
- [ ] **Clojure**: `bubble_sort` omite la bandera de salida temprana `swapped` (ejecución $O(n^2)$ forzada en el mejor caso).
- [ ] **Swift**: `insertion_sort` utiliza intercambios adyacentes repetidos (`swapAt`) en el ciclo interior en lugar de desplazar elementos e insertar, alterando la mecánica del algoritmo.
- [ ] **Tcl/Tk**: `insertion_sort` utiliza intercambios adyacentes repetidos en lugar de desplazar e insertar la clave una sola vez al final.

### 🟡 Advertencias (Opcional) / Warnings (Optional)
- [ ] **C++**: `selection_sort` realiza intercambios innecesarios incluso si el elemento ya está en su lugar (`min_idx == i`).
- [ ] **Racket**: Las operaciones `list-ref` y `list-set` sobre listas simplemente enlazadas degradan el rendimiento asintótico (efectivamente $O(n^3)$ en la implementación iterativa).
- [ ] **C#**: El test helper podría compartir arreglos mutados si no se clonan correctamente para cada test.

### 🟢 Homologados / Homologated
- [x] Ada, Assembly, Ballerina, C, COBOL, Crystal, D, Dart, Elixir, Elm, Erlang, F#, Forth, Gleam, Go, Grain, Groovy, Haskell, Haxe, Java, JavaScript, Julia, Kotlin, Lua, Nim, OCaml, PHP, Perl, Prolog, PureScript, Python, R, Raku, ReScript, REXX, Ruby, Rust, Scala, Scheme, TypeScript, V, Vala, Zig.

