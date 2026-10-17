# Auditoría de Módulo: 05_Naive_Sort
# Module Audit: 05_Naive_Sort

Registro de deuda técnica del módulo `05_Naive_Sort`. / Technical debt record for the `05_Naive_Sort` module.

- **Especificación / Specification:** [`05_Naive_Sort.md`](../core/algorithms/05_Naive_Sort.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Última verificación / Last verification:** — (pendiente / pending)

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** Los tres algoritmos (`selection_sort`, `bubble_sort`, `insertion_sort`) paso a paso sobre el pseudocódigo, **sin** invocar ordenamiento ni **selección** de la biblioteca estándar (`sort`, `sorted`, `Arrays.sort`, `std::sort`, `qsort`, `lsort`, `lists:sort`, `min`/`max` para el paso interno), con la salida temprana de la burbuja (bandera `swapped`), el indicador de fallo del lenguaje ante entrada nula o inválida —**sin** excepciones ni `Option`/`Maybe`/`Result` en esta fase—, cada caso sobre una **copia** del fixture cuando la función ordena *in-place*, separación `src/`-`test/` y README de Nivel 3. Techo: $O(n^2)$ estricto; solo un lenguaje **sin mutabilidad nativa razonable** puede usar recursión, orden superior o copias, con el mismo principio temporal.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

> **ES:** La prohibición de `min`/`max` para el paso interno se ancla al **enunciado** de la especificación («utilizando comparaciones e intercambios **paso a paso**», «sin estructuras auxiliares complejas») y no a un criterio de aceptación propio: por eso se audita como parte de la fidelidad al algoritmo (decisión del autor, 2026-10-17). El indicador de fallo sigue la regla de fase: `-1`, `null` o centinela, **sin** excepciones ni `Option`/`Maybe`/`Result`, que llegan en la Fase 4 (criterio de la especificación corregido el 2026-10-17). La tabla de implementaciones esperadas marca **las dos formas de mutación** —in-place o copia ordenada— con la misma marca `✅`, porque las dos son válidas y lo único exigible es que el README declare cuál se usa (columna corregida el 2026-10-17).
>
> **EN:** The ban on `min`/`max` for the internal step is anchored on the specification's **statement** ("using step-by-step comparisons and swaps", "no complex auxiliary structures"), not on its own acceptance criterion, so it is audited as part of the algorithm's fidelity (author's decision, 2026-10-17). The failure indicator follows the phase rule: `-1`, `null` or a sentinel, **without** exceptions or `Option`/`Maybe`/`Result`, which arrive in Phase 4 (specification criterion corrected on 2026-10-17). The expected-implementations table marks **both mutation forms** —in-place or sorted copy— with the same `✅`, because both are valid and the only requirement is that the README declares which one is used (column corrected on 2026-10-17).

## Comprobaciones por lenguaje / Per-language checks

**ES:** Con los criterios ya fijados, el paso 2 se reduce a seis comprobaciones por lenguaje. Las tres primeras son de fidelidad al módulo; la cuarta y la quinta, de forma; la sexta, de documentación.

**EN:** With the criteria settled, step 2 boils down to six checks per language: the first three cover module fidelity, the fourth and fifth cover form, and the sixth covers documentation.

| # | Comprobación / Check | Cómo se verifica / How it is verified |
|---|---|---|
| 1 | La burbuja corta de verdad cuando una pasada no cambia nada / Bubble really stops when a pass changes nothing | Bandera, valor devuelto por la pasada o pasada recursiva; lo que no vale es no mirar si hubo cambios / A flag, a value returned by the pass, or a recursive pass; not looking at whether anything changed does not count |
| 2 | Indicador de fallo sin excepciones ni `Option`/`Result` / Failure indicator without exceptions or `Option`/`Result` | Devuelto o **declarado** en el README cuando el tipo no admite ausencia / Returned, or **declared** in the README when the type admits no absence |
| 3 | Sin ordenamiento ni selección de biblioteca / No library sort or selection | `sort`, `sorted`, `qsort`, `lsort`, `lists:sort`, `Arrays.sort`, `std::sort`, `min`/`max` para el paso interno / library calls, including `min`/`max` for the internal step |
| 4 | Los 7 casos, sobre copia del fixture si ordena in-place / The 7 cases, on a copy of the fixture when sorting in-place | Conteo de aserciones por algoritmo y presencia del fixture reutilizado en cada caso / Assertions per algorithm and a fresh fixture per case |
| 5 | Separación código/pruebas / Source-test split | `src`/`test` o la disposición equivalente del lenguaje, declarada en el README / `src`/`test` or the language's equivalent layout, declared in the README |
| 6 | README de Nivel 3 / Level 3 README | Las cuatro secciones de la plantilla / The template's four sections |

**ES:** El comando de suite de cada lenguaje sale del catálogo [`scripts/data/languages.tsv`](../../scripts/data/languages.tsv) (columna `test`); los que figuran como `manual` se ejecutan con el comando que declare su README.

**EN:** Each language's suite command comes from the [`scripts/data/languages.tsv`](../../scripts/data/languages.tsv) catalog (`test` column); entries marked `manual` run with the command their README declares.

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | ⏳ pendiente / pending |
| 2. Lectura de código | Los tres algoritmos, los intercambios y el aislamiento de cada caso | ⏳ pendiente / pending |
| 3. Ejecución de suites | Comando nativo del catálogo por lenguaje | ⏳ pendiente / pending |
| 4. Documentación | README del módulo y comentarios del código | ⏳ pendiente / pending |
| 5. Estado del árbol | `git status --short` en los 50 submódulos | ⏳ pendiente / pending |

**ES:** El barrido usa **solo archivos rastreados por git**, que es lo que descarta los artefactos de build (`target/`, `bin/`, `elm-stuff/`, `.cpcache/`, `vendor/`…). El paso 3 es obligatorio antes de declarar un 🟢.

**EN:** The scan uses **only git-tracked files**, which filters out build artifacts. Step 3 is mandatory before declaring a 🟢.

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- ⏳ pendiente / pending

### 🟡 Advertencias / Warnings

- ⏳ pendiente / pending

### 🔵 Aceptados por el autor / Accepted by the author

- — (todavía ninguno / none yet)

### 🟢 Homologados / Homologated

- ⏳ pendiente / pending

## Deuda por lenguaje / Debt per language

⏳ pendiente / pending

## Plan de cierre / Closure plan

**ES:** Orden previsto: el pase completo (5 pasos), luego un `align` por lenguaje con hallazgo 🔴 —y por 🟠 si el autor lo prioriza—, y el cierre cuando todos estén integrados. El bloque de 50 filas de `data/idiomaticity_state.tsv` se abre con este pase. Ver [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

**EN:** Planned order: the full pass (5 steps), then one `align` per language with a 🔴 finding —and per 🟠 if the author prioritises it—, and closure once all are integrated. The 50-row block in `data/idiomaticity_state.tsv` opens with this pass. See [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| — | — | — | — |
