# Auditoría de Módulo: 02_Hello_User
# Module Audit: 02_Hello_User

Registro de deuda técnica del módulo `02_Hello_User`. / Technical debt record for the `02_Hello_User` module.

- **Especificación / Specification:** [`02_Hello_User.md`](../core/foundations/02_Hello_User.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Última verificación / Last verification:** — (pendiente / pending)

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** (a) El programa pide el nombre por consola y su salida **contiene** el prompt `Enter your name: ` y **responde con el nombre ingresado** en el saludo (`Hello, John!` para la entrada `John`); los saltos de línea que introduzcan la lectura o la impresión del lenguaje son suyos y no se penalizan, y **no** se normaliza la entrada (nada de `trim`); (b) usa **solo** la biblioteca estándar; (c) el fichero fuente sigue la convención `hello_user.ext` o `HelloUser.ext`. Sin coste algorítmico: no hay complejidad que auditar. La suite —cuando exista— y el README se evalúan en los ejes `tests` y `documentation`, y cualquier otra desviación de eje se anota para corregirla en el `align`.

> **📝 Nota histórica / Historical note — 2026-10-14:** el criterio citaba `What is your name?`; el prompt correcto del módulo es **`Enter your name: `** y la especificación [02_Hello_User.md](../core/foundations/02_Hello_User.md) quedó corregida con esa nota. Los hallazgos de la primera pasada que se apoyaban en el texto viejo quedan sustituidos por esta versión.
>
> **EN:** The criterion cited `What is your name?`; the module's correct prompt is **`Enter your name: `** and the specification was fixed with that note. Findings from the first pass that relied on the old text are superseded by this version.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | ⏳ pendiente / pending |
| 2. Lectura de código | Entrada/salida y cómo se guarda lo ingresado, construcción y comentarios | ⏳ pendiente / pending |
| 3. Ejecución | El comando documentado en cada README, con la entrada del módulo (`John`), y el nativo del catálogo cuando el README no lo traiga | ⏳ pendiente / pending |
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
