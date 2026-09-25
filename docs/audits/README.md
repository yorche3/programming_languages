# 🧪 Auditorías de módulo / Module audits

**ES:** Esta carpeta guarda la **deuda técnica** de los módulos ya homologados y el plan para devolver cada lenguaje al estado homologado. Una auditoría **no** corrige nada: verifica contra la especificación y el contrato, deja la evidencia y planifica el arreglo, que se hace en una rama del lenguaje.

**EN:** This folder holds the **technical debt** of already standardised modules and the plan to bring every language back to a standardised state. An audit **does not** fix anything: it verifies against the specification and the contract, records the evidence and plans the fix, which happens on a language branch.

---

## 📁 Convención de nombres / Naming convention

```text
docs/audits/
├── README.md                  # Esta guía y el índice / This guide and the index
└── {NN}_Audited_{Modulo}.md   # Un registro por módulo / One record per module
```

- **El nombre del registro no repite el de la especificación**: `05_Naive_Sort.md` es la especificación y `05_Audited_Naive_Sort.md` su registro. Así se distinguen por el nombre y no solo por la carpeta.
- Un registro por módulo, no por lenguaje: los lenguajes son filas del estado.
- Cuando el módulo cierra del todo (todos los lenguajes en 🟢) el registro se conserva como histórico; el cierre se anota en [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md).
- El ciclo con el que se corrige cada lenguaje es el de [`WORKFLOW.md`](../WORKFLOW.md).
- **Una auditoría se abre cuando el roadmap marca el módulo homologado en los 50 lenguajes** (`50/50`): antes de eso no hay deuda técnica que registrar, y los hallazgos sobre una especificación sin implementar se resuelven revisándola.

---

## 🚦 Estados / States

| Estado | Significado | Qué implica |
|:------:|-------------|-------------|
| 🔴 | **Fallo**: incumple un criterio y hay que refactorizar el código | Bloquea el estado homologado del lenguaje en ese módulo |
| 🟡 | **Advertencia**: cumple el contrato pero se desvía de la fidelidad algorítmica, del aislamiento de tests o del rendimiento prometido | Se corrige; no bloquea el cierre si el autor lo acepta por escrito |
| 🔵 | **Arreglado sin integrar**: el código ya cumple, pero el cambio está en el árbol de trabajo y **no** commiteado en el submódulo | No cuenta como 🟢 hasta commitearlo e integrarlo en el `main` del submódulo |
| 🟢 | **Homologado**: cumple los cuatro criterios con evidencia | — |

> **ES:** Un lenguaje solo vuelve a 🟢 cuando el arreglo está aplicado **y** la suite nativa se ha ejecutado con salida real.
> **EN:** A language only returns to 🟢 once the fix is applied **and** the native suite has been run with real output.

---

## 📋 Criterios de evaluación / Evaluation criteria

1. **Fidelidad algorítmica e idiomática.** La implementación refleja el pseudocódigo imperativo paso a paso (comparaciones e intercambios *in-place*). Solo un lenguaje **sin mutabilidad nativa razonable** puede sustituirlo por recursión, orden superior o copias, con el mismo principio temporal $O(n^2)$. **Prohibido** invocar cualquier rutina de ordenamiento o de **selección** de la biblioteca estándar (`sort`, `sorted`, `Arrays.sort`, `std::sort`, `qsort`, `lsort`, `lists:sort`, `min`, `max` para el paso de selección…).
2. **Contrato de errores.** Entrada nula o inválida → indicador de fallo básico del lenguaje (`null`, `nil`, `#f`, `-1`, `None`). **Prohibido** `Option`/`Optional`/`Maybe`/`Result` y **prohibido** lanzar excepciones en esta fase. Si el tipo no admite `null`, se documenta la representación equivalente.
3. **Aislamiento de tests.** Framework nativo/idiomático; un subconjunto de los 8 casos de la especificación (estándar, ordenado, inverso, idénticos, negativos, un elemento, vacío y nulo/inválido); **cada caso opera sobre una copia** del fixture cuando la función ordena *in-place*.
4. **Documentación.** Comentarios simples de función (entrada y salida), sin generadores formales (JSDoc, Doxygen…). README del módulo basado en [`README_Template.md`](../README_Template.md): se exigen sus secciones obligatorias y, si hubo desviación del pseudocódigo o de la ubicación esperada, la **nota aclaratoria** que la justifique.

---

## 🔬 Método reproducible / Reproducible method

**ES:** El barrido usa **solo archivos rastreados por git** de cada submódulo, que es lo que descarta los artefactos de build (`target/`, `bin/`, `elm-stuff/`, `.cpcache/`, `vendor/`…). El paso 3 es obligatorio antes de declarar un 🟢.

**EN:** The scan uses **only git-tracked files** of each submodule, which is what filters out build artifacts. Step 3 is mandatory before declaring a 🟢.

```bash
# 1. Barrido léxico: ordenamiento de biblioteca y monadas/excepciones en fuentes
for l in */; do
  d="${l%/}/core/algorithms/naive_sort"
  [ -d "$d" ] || continue
  git -C "${l%/}" ls-files "core/algorithms/${MODULO}" |
    grep -E '\.(c|h|cpp|cs|java|kt|scala|swift|go|rs|rb|py|js|ts|res|ex|erl|hs|purs|ml|rkt|scm|clj|lisp|lua|pl|r|jl|nim|zig|v|vala|d|dart|gleam|gr|groovy|rakumod|tcl|adb|ads|forth|fs|bal|rexx|cbl|asm|hx)$' |
    grep -vE '(/test/|/tests/|/spec/|_test|_tests|_spec|\.test\.|Tests?\.)' |
    while read -r f; do grep -nH -E 'PATRONES' "${l%/}/$f"; done
done
```

2. **Lectura del código** de todo lo que el barrido señale, más las funciones de inserción (¿desplazan e insertan o intercambian?) y el guardia de selección (`min_idx != i`).
3. **Ejecución**: comando nativo de la suite del lenguaje, copiado sin editar, y un experimento dirigido cuando haya duda (por ejemplo, un caso con duplicados).
4. **Autoría de la prueba**: si el hallazgo es de aislamiento de tests, se comprueba también si la implementación muta la entrada, porque el defecto es la **combinación** de ambas cosas.

---

## 📄 Plantilla del registro / Record template

```markdown
# Auditoría de Módulo: {NN}_{Modulo}
# Module Audit: {NN}_{Modulo}

## Criterios de Evaluación / Evaluation Criteria
## Alcance y método de esta verificación / Scope and method
## Estado por Lenguaje / Status by Language
### 🔴 Requieren Refactorización / Require Refactoring
### 🟡 Advertencias / Warnings
### 🟢 Homologados / Homologated
## Deuda por lenguaje / Debt per language   (una sub-tarea por lenguaje y hallazgo)
## Plan de cierre / Closure plan
## Registro de verificaciones / Verification log   (fecha · alcance · comando · resultado)
```

---

## 📚 Índice / Index

| Módulo | Estado global | Registro |
|--------|---------------|----------|
| `core.algorithms.naive_sort` | 🟢 50 · 🟡 0 · 🔴 0 | [`05_Audited_Naive_Sort.md`](05_Audited_Naive_Sort.md) |
