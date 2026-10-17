# Auditoría de Módulo: 04_Numbers
# Module Audit: 04_Numbers

Registro de deuda técnica del módulo `04_Numbers`. / Technical debt record for the `04_Numbers` module.

- **Especificación / Specification:** [`04_Numbers.md`](../core/foundations/04_Numbers.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Última verificación / Last verification:** — (pendiente / pending)

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** Los **cinco algoritmos** (suma de los primeros `n`, factorial, Fibonacci, MCD y MCM) en las variantes que el lenguaje permita: `_rec` **siempre**; `_acc` **solo si el lenguaje garantiza TCO**; `_ite` **solo si ofrece iteración nativa**; y el README de Nivel 3 **declarando la combinación aplicada y por qué** (33, 22 o 11 pruebas). `_rec` es recursión directa, `_acc` lleva acumulador (estilo tail-call) y `_ite` usa bucles con memoria constante. Sin delegar los cinco algoritmos en una rutina de biblioteca, separación del código respecto de las pruebas (`src/`-`test/` o la disposición idiomática equivalente) y solo biblioteca estándar. Techo: $O(n)$ en las sumatorias y el factorial y $O(\log n)$ en el MCD; `fibonacci_rec` es $O(2^n)$ **por diseño educativo** y no es una desviación.

> **ES:** Capa corregida el **2026-10-16** al abrir el pase: antes pedía «las tres variantes implementadas y probadas por separado» —contra la regla condicional de la especificación— y «trabajo sobre la secuencia indexable», que ningún algoritmo de este módulo recibe como entrada: la especificación introduce esa primitiva para los módulos posteriores. El histórico queda aquí porque los pases cerrados no se reescriben.
>
> **EN:** Layer corrected on **2026-10-16**: it used to ask for the three variants implemented and tested unconditionally, and for work over the indexable sequence, which this module's algorithms never take as input.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | ⏳ pendiente / pending |
| 2. Lectura de código | Las tres variantes, la aritmética y la recursión, y los comentarios | ⏳ pendiente / pending |
| 3. Ejecución de suites | Comando nativo del catálogo por lenguaje | ⏳ pendiente / pending |
| 4. Documentación | README del módulo y comentarios del código | ⏳ pendiente / pending |
| 5. Estado del árbol | `git status --short` en los 50 submódulos | ⏳ pendiente / pending |

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

**ES:** Orden previsto: el pase completo (5 pasos), luego un `align` por lenguaje con hallazgo 🔴 —y por 🟠 si el autor lo prioriza—, y el cierre cuando todos estén integrados. Ver [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

**EN:** Planned order: the full pass (5 steps), then one `align` per language with a 🔴 finding —and per 🟠 if the author prioritises it—, and closure once all are integrated. See [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| — | — | — | — |
