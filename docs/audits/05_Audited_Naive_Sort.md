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
