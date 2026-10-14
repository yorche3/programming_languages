# Auditoría de Módulo: 06_Data_Structures_Basics
# Module Audit: 06_Data_Structures_Basics

Registro de deuda técnica del módulo `06_Data_Structures_Basics`. / Technical debt record for the `06_Data_Structures_Basics` module.

- **Especificación / Specification:** [`06_Data_Structures_Basics.md`](../core/algorithms/06_Data_Structures_Basics.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Estado parcial / Partial state:** [`data/idiomaticity_state.tsv`](../ruleset/data/idiomaticity_state.tsv)
- **Última verificación / Last verification:** — (pase en curso / pass in progress)

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación y de la política de resultados de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria and result policy; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** `Node`, `LinkedList`, `Stack` y `Queue` construidos desde cero —sin colección de biblioteca que haga su trabajo—, la **política de resultados** por operación (el indicador de fallo del lenguaje, declarado en el README: `null`, `nil`, `#f`, `-1`, ausencia…), la suite de casos de la especificación y el README de Nivel 3. Techo: $O(1)$ por operación.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | 🔄 en curso / in progress |
| 2. Lectura de código | Constructor, enlaces, indicador de fallo y comentarios | 🔄 en curso / in progress |
| 3. Ejecución de suites | Comando nativo del catálogo por lenguaje | ⏳ pendiente / pending |
| 4. Documentación | README del módulo y comentarios del código | ⏳ pendiente / pending |
| 5. Estado del árbol | `git status --short` en los 50 submódulos | ⏳ pendiente / pending |

**ES:** El estado ya tiene sus **50 filas** (una por lenguaje): 16 `transitional`, 15 `workaround`, 9 `not-started`, 8 `not-audited` y 2 `mostly-idiomatic`; **ninguna** en `idiomatic` todavía. Los ejes bloqueantes que más se repiten son `construction` (21), `failure` (7), `naming` (4) y `unsafe` (1).

**EN:** The state already holds its **50 rows** (one per language): 16 `transitional`, 15 `workaround`, 9 `not-started`, 8 `not-audited` and 2 `mostly-idiomatic`; **none** in `idiomatic` yet. The most frequent blocking axes are `construction` (21), `failure` (7), `naming` (4) and `unsafe` (1).

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- 🔄 en curso / in progress: `workaround` (15) y `transitional` (16) según `module_fidelity`

### 🟡 Advertencias / Warnings

- 🔄 en curso / in progress: las desviaciones de nombre y de acceso sin documentar

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
