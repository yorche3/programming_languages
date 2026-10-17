# Auditoría de Módulo: 06_Data_Structures_Basics
# Module Audit: 06_Data_Structures_Basics

Registro de deuda técnica del módulo `06_Data_Structures_Basics`. / Technical debt record for the `06_Data_Structures_Basics` module.

- **Especificación / Specification:** [`06_Data_Structures_Basics.md`](../core/algorithms/06_Data_Structures_Basics.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Estado parcial / Partial state:** [`data/idiomaticity_state.tsv`](../ruleset/data/idiomaticity_state.tsv)
- **Última verificación / Last verification:** — (preparación del pase / pass preparation)

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación y de la política de resultados de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria and result policy; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** `Node`, `LinkedList`, `Stack` y `Queue` construidos desde cero —sin colección de biblioteca que haga su trabajo—, la **política de resultados** por operación (el indicador de fallo del lenguaje, declarado en el README: `null`, `nil`, `#f`, `-1`, ausencia…), la suite de casos de la especificación y el README de Nivel 3. Techo: $O(1)$ por operación.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

> **ES:** Precisiones fijadas al abrir la auditoría 06 (2026-10-17): el techo es **$O(1)$ en todas las operaciones salvo `delete`, que es $O(n)$** por especificación (antes este registro decía «$O(1)$ por operación»); los extremos finales (`insert_tail`, `enqueue`) son $O(1)$ **solo con celda mutable**, y donde la celda es inmutable la reconstrucción del camino los deja en $O(n)$, cota que cuenta como conforme si el README la declara; el **tipo opcional nativo** se admite únicamente en el enlace (`next`) y nunca como resultado de operación, que usa el centinela o el booleano declarados. Las 50 filas del estado se reescriben con el resultado real de este pase.
>
> **EN:** Precisions settled when audit 06 opened (2026-10-17): the ceiling is **$O(1)$ for every operation except `delete`, which is $O(n)$** by specification (this record used to say "$O(1)$ per operation"); end operations (`insert_tail`, `enqueue`) are $O(1)$ **only with a mutable cell**, and where the cell is immutable rebuilding the path leaves them at $O(n)$, a bound that counts as conforming when the README declares it; the **native optional type** is allowed only on the link (`next`) and never as an operation result, which uses the declared sentinel or boolean. The 50 state rows are rewritten with the real result of this pass.

## Comprobaciones por lenguaje / Per-language checks

**ES:** Con los criterios fijados, el paso 2 se reduce a siete comprobaciones por lenguaje.

**EN:** With the criteria settled, step 2 boils down to seven checks per language.

| # | Comprobación / Check | Cómo se verifica / How it is verified |
|---|---|---|
| 1 | Un solo `Node` compartido / One shared `Node` | Un único tipo de celda en la fuente; `LinkedList`, `Stack` y `Queue` con punteros propios (`head`/`tail`, `top`, `front`/`rear`) y su contador / A single cell type in the source; each structure with its own pointers and counter |
| 2 | Sin delegación / No delegation | `push`, `enqueue`, `pop` y `dequeue` no llaman a operaciones de la lista ni a colecciones de la biblioteca / they do not call list operations or library collections |
| 3 | `init` obligatorio / Mandatory `init` | La instancia se declara y `init` (`Make` o constructor) la inicializa antes de `is_empty`; contador a cero / declared, then initialized before `is_empty`; counter at zero |
| 4 | Indicador por tipo de retorno / Indicator per return type | Centinela numérico en las extracciones y booleano en éxito/fallo, declarados en el README / numeric sentinel for extraction, boolean for success/failure, declared in the README |
| 5 | Complejidad / Complexity | $O(1)$ salvo `delete` ($O(n)$); extremos $O(n)$ solo con celda inmutable y declarado / $O(1)$ except `delete`; ends $O(n)$ only for an immutable cell, declared |
| 6 | Casos como pasos sucesivos / Cases as successive steps | `Node` 2, `LinkedList` 5, `Stack` 4, `Queue` 4, sobre la misma instancia / on the same instance |
| 7 | README y aislamiento / README and isolation | Nivel 3, adaptaciones declaradas y sin imports de otros módulos del roadmap / Level 3, adaptations declared, no imports from other roadmap modules |

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | ⏳ pendiente / pending |
| 2. Lectura de código | Constructor, enlaces, indicador de fallo y comentarios | ⏳ pendiente / pending |
| 3. Ejecución de suites | Comando nativo del catálogo por lenguaje | ⏳ pendiente / pending |
| 4. Documentación | README del módulo y comentarios del código | ⏳ pendiente / pending |
| 5. Estado del árbol | `git status --short` en los 50 submódulos | ⏳ pendiente / pending |

**ES:** Las **50 filas** que ya existen en el estado son **heredadas del flujo antiguo** (16 `transitional`, 15 `workaround`, 9 `not-started`, 8 `not-audited` y 2 `mostly-idiomatic`; ninguna en `idiomatic`) y se **reescriben** con el resultado real de este pase, incluido el commit de cada submódulo.

**EN:** The **50 rows** already present in the state are **legacy from the old workflow** (16 `transitional`, 15 `workaround`, 9 `not-started`, 8 `not-audited` and 2 `mostly-idiomatic`; none in `idiomatic`) and are **rewritten** with the real result of this pass, including each submodule's commit.

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- ⏳ pendiente del barrido / pending the sweep

### 🟡 Advertencias / Warnings

- ⏳ pendiente del barrido / pending the sweep

### 🔵 Aceptados por el autor / Accepted by the author

- ⏳ pendiente de la decisión del autor / pending the author's decision

### 🟢 Homologados / Homologated

- ⏳ pendiente / pending

## Deuda por lenguaje / Debt per language

**ES:** Se detalla por lenguaje en el estado (`blocking_axis` y `notes`) y se irá bajando con cada `align`. La deuda de documentación —la que no exige tocar código— se resuelve escribiendo la ficha del lenguaje en [`docs/ruleset/idioms/`](../ruleset/idioms/).

**EN:** Detailed per language in the state (`blocking_axis` and `notes`) and paid down with each `align`. Documentation debt —the kind that does not require touching code— is settled by writing the language's record under [`docs/ruleset/idioms/`](../ruleset/idioms/).

## Plan de cierre / Closure plan

**ES:** Terminar los pasos 1 y 2 sobre los 50, ejecutar las 50 suites, cerrar el registro y abrir `align` solo donde haya 🔴. El módulo queda homogéneo cuando todos los `align` estén integrados y el estado no tenga 🔴.

**EN:** Finish steps 1 and 2 over the 50, run the 50 suites, close the record and open `align` only where there is a 🔴. The module is homogeneous once every `align` is integrated and the state holds no 🔴.

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| — | — | — | — |
