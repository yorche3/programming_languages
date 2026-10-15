# 🗣️ Grain — Convenciones e Idioms / Idioms and Conventions

> **ES:** Este documento es la referencia de convenciones del lenguaje `grain` en el monorepo, con sus desviaciones aceptadas. Complementa [`PSEUDOCODE_CONVENTION.md`](../PSEUDOCODE_CONVENTION.md) y los TSV de `data/`.
>
> **EN:** This document is the conventions reference for the `grain` language in the monorepo, with its accepted deviations. It complements [`PSEUDOCODE_CONVENTION.md`](../PSEUDOCODE_CONVENTION.md) and the TSVs under `data/`.

---

## 📇 Ficha rápida / Quick reference

| Campo / Field | Valor / Value |
|---------------|---------------|
| **Nombre / Name** | Grain |
| **Código / Code** | `grain` |
| **Repositorio / Repository** | `git@github.com:yorche3/grain.git` |

**ES:** Los datos del lenguaje no se repiten aquí: viven en los TSV de `data/`. El nivel de cada `(lenguaje, módulo)` vive en `data/idiomaticity_state.tsv`.

**EN:** The language facts are not repeated here: they live in the TSVs under `data/`. Each `(language, module)` level lives in `data/idiomaticity_state.tsv`.

---

## 🧩 Rarezas / Peculiarities

**ES:** Lo que el lenguaje **obliga** y no se puede evitar:

**EN:** What the language **forces** and cannot be avoided:

1. **Sin lectura de entrada estándar.** Grain se compila a WebAssembly y **no ofrece stdin**, así que un programa interactivo (leer un nombre y responder) no se puede escribir con la biblioteca estándar: no hay `readLine` ni equivalente y el runtime no expone la entrada estándar.
   / **No standard input.** Grain compiles to WebAssembly and **offers no stdin**, so an interactive program (read a name, answer it) cannot be written with the standard library: there is no `readLine` or equivalent and the runtime does not expose standard input.
2. **El módulo interactivo no existe.** Por lo anterior, `core/foundations/hello_user` no está implementado en `grain` —solo `helloworld`, `numbers` y `unit_test`—, y así queda **aceptado por el autor** en el registro de auditoría de `hello_user`.
   / **The interactive module does not exist.** For that reason `core/foundations/hello_user` is not implemented in `grain` —only `helloworld`, `numbers` and `unit_test`— and it stays **accepted by the author** in the `hello_user` audit record.

---

## ⚠️ Desviaciones del pseudocódigo canónico / Deviations from the canonical pseudocode

**ES:** Ninguna: no hay código que se aparte del pseudocódigo, porque el módulo interactivo no se puede implementar en este lenguaje. Es una limitación **del lenguaje**, no del módulo, y queda declarada aquí y aceptada en el registro.

**EN:** None: there is no code deviating from the pseudocode, because the interactive module cannot be implemented in this language. It is a **language** limitation, not a module one, and it is declared here and accepted in the record.

---

## 📝 Notas por módulo / Per-module notes

| Módulo / Module | Nivel / Level | Nota / Note |
|-----------------|---------------|-------------|
| `hello_world` | `idiomatic` | **ES:** Conforme: mensaje exacto, fichero `hello_world.gr` y ejecución con `grain hello_world.gr`; su README quedó corregido (documentaba `grain run`, que no ejecuta el programa). **EN:** Conforming: exact message, `hello_world.gr` file and `grain hello_world.gr`; its README was fixed (it documented `grain run`, which does not run the program). |
| `hello_user` | `not-started` | **ES:** Módulo **no implementado**: el lenguaje no tiene stdin. Aceptado por el autor. Registro: [`02_Audited_Hello_User.md`](../../audits/02_Audited_Hello_User.md). **EN:** Module **not implemented**: the language has no stdin. Accepted by the author. Record: [`02_Audited_Hello_User.md`](../../audits/02_Audited_Hello_User.md). |

---

## 🔗 Referencias / References

| Documento / Document | Qué aporta / What it provides |
|----------------------|-------------------------------|
| [`IDIOMATICITY_LEVELS.md`](../IDIOMATICITY_LEVELS.md) | La escala de 4 niveles / The 4-level scale |
| [`DEVIATION_POLICY.md`](../DEVIATION_POLICY.md) | Severidad y dónde vive cada desviación / Severity and where each deviation lives |
| [`AUDIT_WORKFLOW.md`](../../AUDIT_WORKFLOW.md) | El ciclo: pase, `align` y cierre / The cycle: pass, `align` and closure |
