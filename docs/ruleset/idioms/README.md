# 🗣️ Convenciones por lenguaje / Per-language conventions

**ES:** Esta carpeta guarda **una ficha por lenguaje** con sus convenciones idiomáticas y las **desviaciones aceptadas** de sus módulos. Es la **fuente de verdad de una desviación**: lo que no esté declarado aquí con su plantilla no está aceptado, por mucho que el código lo haga.

**EN:** This folder holds **one record per language** with its idiomatic conventions and the **accepted deviations** of its modules. It is the **source of truth of a deviation**: anything not declared here with its template is not accepted, however much the code does it.

---

## 📁 Convención de nombres / Naming convention

```text
docs/ruleset/idioms/
├── README.md      # Esta guía y el índice / This guide and the index
└── {lang}.md      # Una ficha por lenguaje / One record per language
```

- La ficha se escribe desde [`Idioms_Template.md`](../Idioms_Template.md) y vive en `docs/ruleset/idioms/{lang}.md`, con el nombre del lenguaje tal como aparece en `.gitmodules`.
- **Los datos del lenguaje no se repiten aquí**: los nombres canónicos, los 11 ejes y la traducción concepto → nombre viven en los TSV de [`data/`](../data/), y el comando de pruebas y el verificador, en el catálogo del tooling.
- El nivel de cada `(lenguaje, módulo)` **tampoco** se copia aquí: vive en `data/idiomaticity_state.tsv`. La ficha explica **por qué** está donde está.
- Una ficha se crea cuando el pase de auditoría abre ese lenguaje, o antes si el lenguaje introduce su primera desviación documentada. No se crean las 50 de golpe.

**EN:** The record is written from [`Idioms_Template.md`](../Idioms_Template.md) and lives at `docs/ruleset/idioms/{lang}.md`, named after the language as it appears in `.gitmodules`. The language facts are **not** repeated here: canonical names, the 11 axes and the concept → name translation live in the TSVs under [`data/`](../data/), and the test command and verifier live in the tooling catalogue. The level of each `(language, module)` is **not** copied either: it lives in `data/idiomaticity_state.tsv`, and the record explains **why** it sits where it sits. A record is created when the audit pass opens that language, or earlier if the language introduces its first documented deviation; the 50 are not created at once.

---

## ✍️ Qué declara una ficha / What a record declares

| Sección / Section | Qué lleva / What it holds |
|---|---|
| Convenciones / Conventions | Constructor, nombres, indicador de fallo, acceso, encapsulación: el *cómo* idiomático del lenguaje |
| Rarezas / Peculiarities | Lo que el lenguaje **obliga** y no se puede evitar (imports para comparar, ausencia de un mecanismo, límites reales de la toolchain) |
| Desviaciones / Deviations | Una entrada por desviación, con la plantilla completa: concepto, categoría, severidad, estado, desviación, motivo, impacto y evidencia |
| Notas por módulo / Per-module notes | Lo que un módulo concreto desvía, con el enlace a su registro de auditoría |

**ES:** La severidad 🟢 `informational` o 🟡 `warning` **no baja** al lenguaje del pase: se documenta y se sigue. Una 🟠 `structural` o 🔴 `blocking` **sí** dispara un `align` —o queda como deuda aceptada por el autor, por escrito—. El árbol de decisión está en [`DEVIATION_POLICY.md`](../DEVIATION_POLICY.md) y el ciclo entero, en [`AUDIT_WORKFLOW.md`](../../AUDIT_WORKFLOW.md).

**EN:** A 🟢 `informational` or 🟡 `warning` severity does **not** hold the language back in the pass: it is documented and the pass moves on. A 🟠 `structural` or 🔴 `blocking` one **does** trigger an `align` —or stays as debt accepted by the author, in writing—. The decision tree is in [`DEVIATION_POLICY.md`](../DEVIATION_POLICY.md) and the whole cycle in [`AUDIT_WORKFLOW.md`](../../AUDIT_WORKFLOW.md).

---

## 📚 Índice / Index

| Lenguaje / Language | Ficha / Record | Desviaciones activas / Active deviations |
|---|---|---|
| — | Todavía ninguna / None yet | — |

**ES:** Ninguna ficha creada todavía. La primera tanda es la de los módulos ya a `50/50` —`hello_world`, `hello_user`, `unit_test_calculator`, `numbers`, `naive_sort` y `data_structures_basics`—, que son los que va a recorrer el pase de auditoría.

**EN:** No record created yet. The first batch is the one for the modules already at `50/50` —`hello_world`, `hello_user`, `unit_test_calculator`, `numbers`, `naive_sort` and `data_structures_basics`—, which are the ones the audit pass will walk through.

---

## 🔗 Relación con otras normas / Relation to other policies

| Documento / Document | Qué manda / What it governs |
|---|---|
| [`Idioms_Template.md`](../Idioms_Template.md) | La plantilla de la ficha y sus secciones obligatorias |
| [`DEVIATION_POLICY.md`](../DEVIATION_POLICY.md) | Severidad, aceptabilidad de una desviación y dónde vive cada una |
| [`IDIOMATICITY_LEVELS.md`](../IDIOMATICITY_LEVELS.md) | La escala de 4 niveles y el cálculo por 9 ejes |
| [`AUDIT_WORKFLOW.md`](../../AUDIT_WORKFLOW.md) | El ciclo: pase, `align` y cierre, con su reparto por roles |
