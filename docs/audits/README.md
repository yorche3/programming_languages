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
- El ciclo con el que se audita el módulo y se corrige cada lenguaje es el de [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md) —ramas `audit/{fase}/{módulo}` y `align/{fase}/{módulo}`—; el ciclo del sprint sigue siendo [`WORKFLOW.md`](../WORKFLOW.md).
- **El encargo del pase está versionado en [`audit.prompt.md`](audit.prompt.md)**: es **genérico** —vale para cualquier módulo a `50/50`— y se lanza **a mano**, porque la auditoría no es un encargo de `glot` y no vive en su catálogo de plantillas.
- **Una auditoría se abre cuando el roadmap marca el módulo homologado en los 50 lenguajes** (`50/50`): antes de eso no hay deuda técnica que registrar, y los hallazgos sobre una especificación sin implementar se resuelven revisándola.

---

## 🚦 Estados / States

| Estado | Significado | Qué implica |
|:------:|-------------|-------------|
| 🔴 | **Fallo**: incumple un criterio y hay que refactorizar el código | Bloquea el estado homologado del lenguaje en ese módulo **mientras no se arregle o el autor no lo acepte** (🔵) |
| 🟡 | **Advertencia**: cumple el contrato pero se desvía de la fidelidad algorítmica, del aislamiento de tests o del rendimiento prometido | Se corrige; si el autor la acepta, pasa a 🔵 |
| 🔵 | **Aceptado**: la desviación queda **como está por decisión del autor**, declarada con su plantilla en la ficha del lenguaje | Cierra el hallazgo **sin tocar código**; no es 🟢 ni un pendiente |
| 🟢 | **Homologado**: cumple las **dos capas** con evidencia | — |

> **ES:** Un lenguaje solo vuelve a 🟢 cuando el arreglo está aplicado **y** la suite nativa se ha ejecutado con salida real.
> **EN:** A language only returns to 🟢 once the fix is applied **and** the native suite has been run with real output.

**ES:** **El «arreglado sin integrar» no es un estado de esta carpeta** (se retiró el 2026-10-13). Mientras un arreglo no esté **integrado** en el `main` de su submódulo, el lenguaje sigue en el estado que le corresponde y el `align` sigue abierto: el árbol de trabajo lo lleva git, no este registro. Por eso no hay barridos de integración —el registro solo dice **qué se verificó** y con qué fecha— y por eso el nivel solo sube cuando el cambio está integrado.

**EN:** **"Fixed but not integrated" is not a state of this folder** (retired on 2026-10-13). While a fix is not **integrated** into its submodule's `main`, the language stays in the state it has and the `align` stays open: the working tree is git's business, not this record's. That is why there are no integration sweeps —the record only says **what was verified**, and when— and why the level only moves up once the change is integrated.

**ES:** 🔵 **Aceptado** lo decide el autor (Tech Lead) y se declara **por escrito** en la ficha del lenguaje, `docs/ruleset/idioms/{lang}.md`, con la plantilla de la desviación y su severidad. Aceptar **no** es homologar: el lenguaje no pasa a 🟢, pero el hallazgo queda **cerrado** y no se vuelve a discutir en el pase siguiente. Es la vía para lo que el lenguaje **obliga** y para lo que el autor decide mantener tal cual.

**EN:** 🔵 **Accepted** is decided by the author (Tech Lead) and declared **in writing** in the language's record, `docs/ruleset/idioms/{lang}.md`, with the deviation's template and its severity. Accepting is **not** homologating: the language does not become 🟢, but the finding is **closed** and is not discussed again in the next pass. It is the route for what the language **mandates** and for what the author decides to keep as is.

---

## 📋 Criterios de evaluación / Evaluation criteria

**ES:** Los criterios son **los mismos para todos los módulos** y tienen dos capas:

- **Capa del módulo:** los criterios de aceptación de su especificación y el techo de complejidad del módulo. Cambia con cada módulo y está declarada, módulo a módulo, en la tabla **Alcance por módulo** de este documento; el detalle de cada pase vive en su registro.
- **Capa del lenguaje:** los **9 ejes** de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md) —`construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`—, con el nivel derivado del **mínimo de los ejes aplicables** y la severidad de cada desviación fijada por [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md). Es común a todos.

**EN:** The criteria are **the same for every module** and have two layers: the **module layer** (the specification's acceptance criteria and the module's complexity ceiling, declared per module in the **Scope per module** table, with each pass's detail in its own record) and the **language layer** (the **9 axes** of [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md), with the level derived from the **minimum over applicable axes** and each deviation's severity set by [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md)).

**ES:** Nada se audita contra reglas que no estén en una de las dos capas: lo que no esté en la especificación no se le puede exigir, y lo que la especificación exija de más se corrige en ella y se avisa en el registro del pase.

**EN:** Nothing is audited against rules outside those two layers: what is not in the specification cannot be demanded of a module, and anything the specification demands beyond it is fixed in the specification and noted in the pass's record.

> **ES:** Los registros anteriores a este marco se **regeneran** en vez de adaptarse: un módulo auditado con criterios propios se pasa de nuevo con los de arriba, y su registro viejo se retira del árbol (queda en git). El histórico de cada regeneración se anota al final de este documento.
> **EN:** Records predating this frame are **regenerated** rather than adapted: a module audited with its own criteria is passed again with the ones above, and its old record is removed from the tree (it stays in git). Each regeneration's history is noted at the end of this document.

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
### 🔵 Aceptados por el autor / Accepted by the author
### 🟢 Homologados / Homologated
## Deuda por lenguaje / Debt per language   (una sub-tarea por lenguaje y hallazgo)
## Plan de cierre / Closure plan
## Registro de verificaciones / Verification log   (fecha · alcance · comando · resultado)
```

---

## 📚 Índice / Index

| Módulo | Estado global | Registro |
|--------|---------------|----------|
| `core.foundations.hello_world` | 🔴 0 · 🟡 0 · 🔵 1 (`elm`, desviación aceptada en `docs/ruleset/idioms/elm.md`) · 🟢 49 — **cerrado**: 40 commits de `align` + 27 de corrección, integrados y empujados | [`01_Audited_Hello_World.md`](01_Audited_Hello_World.md) |
| `core.foundations.hello_user` | 🔴 0 · 🟡 0 · 🔵 1 (`grain`, sin stdin: [`idioms/grain.md`](../ruleset/idioms/grain.md)) · 🟢 49 — **cerrado**: 34 commits en 32 submódulos, integrados y empujados | [`02_Audited_Hello_User.md`](02_Audited_Hello_User.md) |
| `core.foundations.unit_test_calculator` | 🔴 0 · 🟡 0 · 🔵 0 · 🟢 50 — **cerrado**: las 50 suites ejecutadas y los 15 hallazgos corregidos en 15 commits de `align` (uno por submódulo), integrados y empujados el 2026-10-16 | [`03_Audited_Unit_Test_Calculator.md`](03_Audited_Unit_Test_Calculator.md) |
| `core.foundations.numbers` | 🔴 1 (`ocaml`: el `bin/dune` que la 03 ya arregló en `unit_test/calculator`) · 🟡 7 · 🔵 0 · 🟢 42 — **pase verificado**: las 50 suites ejecutadas y los 11 casos por variante comprobados; pendiente el `align` de los 8 hallazgos | [`04_Audited_Numbers.md`](04_Audited_Numbers.md) |
| `core.algorithms.naive_sort` | ⏳ pendiente | [`05_Audited_Naive_Sort.md`](05_Audited_Naive_Sort.md) |
| `core.algorithms.data_structures_basics` | 🔄 en curso | [`06_Audited_Data_Structures_Basics.md`](06_Audited_Data_Structures_Basics.md) |

---

## 🎯 Alcance por módulo / Scope per module

**ES:** El alcance de un pase son **dos capas**: la **fidelidad al módulo** —lo que exige la especificación, con sus criterios de aceptación y el techo de complejidad del módulo— y la **idiomaticidad del lenguaje** —los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md), con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md)—. La capa del lenguaje es común a los seis; la del módulo cambia con cada especificación.

**EN:** A pass's scope has **two layers**: **module fidelity** —what the specification demands, with its acceptance criteria and the module's complexity ceiling— and **language idiomaticity** —the 9 axes of [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md), with the severity of [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md)—. The language layer is shared by all six; the module layer changes with each specification.

| Módulo / Module | Capa del módulo: qué se audita / Module layer: what is audited | Techo de complejidad / Complexity ceiling |
|---|---|---|
| `01 hello_world` | Mensaje exacto `Hello, World! from {Lenguaje}!`, solo biblioteca estándar, fichero `hello_world.ext`/`HelloWorld.ext`, ejecución sin errores, README N3 | Sin coste algorítmico |
| `02 hello_user` | La salida **contiene** el prompt `Enter your name: ` y **responde con el nombre ingresado** en el saludo (`Hello, John!` para la entrada `John`); solo biblioteca estándar; fichero `hello_user.ext`/`HelloUser.ext`; README N3. *(Criterio corregido el 2026-10-14: antes citaba `What is your name?`; el cambio queda anotado en la especificación.)* | Sin coste algorítmico |
| `03 unit_test_calculator` | Las cinco operaciones (`addition`, `subtraction`, `multiplication`, `division`, `modulus`); `multiplication` como suma repetitiva, `division` como resta repetitiva y `modulus` construido con ambas (**sin** `*`, `/` ni `%`); suite propia del módulo, separación del código respecto de las pruebas (`src/`-`test/` o la disposición idiomática equivalente), solo biblioteca estándar y README. *(Criterio corregido el 2026-10-16: antes citaba «las cuatro operaciones» con nombres `add`/`subtract`/`multiply`/`divide` y un techo de $O(1)$ por operación. La división por cero queda **fuera** de la capa del módulo: la especificación no la declara, así que el eje `failure` se marca `N/A` salvo que el lenguaje ya la maneje. El detalle del pase está en su registro, `docs/audits/03_Audited_Unit_Test_Calculator.md`.)* | $O(1)$ en `addition`/`subtraction`; $O(b)$ y $O(a/b)$ en las educativas |
| `04 numbers` | Los cinco algoritmos en las variantes que el lenguaje permita —`_rec` siempre; `_acc` solo con TCO garantizado; `_ite` solo con iteración nativa—, sin delegarlos en una rutina de biblioteca, el README declarando la combinación aplicada y su porqué, separación código/pruebas y solo biblioteca estándar. *(Capa corregida el 2026-10-16: antes pedía las tres variantes siempre y el trabajo sobre la secuencia indexable, que este módulo no usa.)* | $O(n)$ en sumatorias y factorial; $O(\log n)$ en el MCD |
| `05 naive_sort` | Los tres algoritmos sin biblioteca de ordenamiento **ni de selección**, salida temprana de la burbuja, indicador de fallo, aislamiento de tests | $O(n^2)$ estricto |
| `06 data_structures_basics` | `Node`, `LinkedList`, `Stack` y `Queue` desde cero, política de resultados por operación, sin colección de biblioteca, suite | $O(1)$ por operación |

**ES:** Un módulo se audita **solo** contra su capa declarada aquí más los 9 ejes: lo que no esté en la especificación no se le puede exigir, y lo que la especificación exija de más se corrige en ella y se avisa en el registro del pase.

**EN:** A module is audited **only** against the layer declared here plus the 9 axes: what is not in the specification cannot be demanded of it, and anything the specification demands beyond it is fixed in the specification and noted in the pass's record.

---

## 📜 Histórico de regeneraciones / Regeneration history

**ES:** Registros retirados del árbol al pasar su módulo a este marco. El contenido viejo **no se pierde**: queda en el commit que se cita y vuelve a leerse con `git show {commit}:{ruta}`.

**EN:** Records removed from the tree when their module moved to this frame. The old content is **not lost**: it stays in the cited commit and is read back with `git show {commit}:{path}`.

| Fecha / Date | Módulo / Module | Qué se retiró / What was removed | Dónde está / Where it is |
|---|---|---|---|
| 2026-10-13 | `core.algorithms.naive_sort` | La pasada del 2026-09-21, con sus propios cuatro criterios; sus hallazgos (8 arreglos de comentarios y 4 de fidelidad o de aislamiento) siguen integrados en el `main` de sus submódulos | `git show f800c7b:docs/audits/05_Audited_Naive_Sort.md` |

**EN:** A module is audited **only** against the layer declared here plus the 9 axes: what is not in the specification cannot be demanded of it, and anything the specification demands beyond it is fixed in the specification and noted in the pass's record.
