# 🗣️ Elm — Convenciones e Idioms / Idioms and Conventions

> **ES:** Este documento es la referencia de convenciones del lenguaje `elm` en el monorepo. Es la fuente de verdad para: cómo se traduce el pseudocódigo canónico, qué desviaciones existen y por qué, y cómo se ejecuta el ciclo del sprint. Complementa [`PSEUDOCODE_CONVENTION.md`](../PSEUDOCODE_CONVENTION.md) (el contrato) y `data/language_characteristics.tsv` (los ejes clasificados).
>
> **EN:** This document is the conventions reference for the `elm` language in the monorepo. It is the source of truth for: how the canonical pseudocode is translated, which deviations exist and why, and how the sprint cycle runs. It complements [`PSEUDOCODE_CONVENTION.md`](../PSEUDOCODE_CONVENTION.md) (the contract) and `data/language_characteristics.tsv` (the classified axes).

---

## 📇 Ficha rápida / Quick reference

| Campo / Field | Valor / Value |
|---------------|---------------|
| **Nombre / Name** | Elm |
| **Código / Code** | `elm` |
| **Familia / Family** | `func-option` — funcional con ausencia explícita / functional with explicit absence |
| **Variante de pseudocódigo / Pseudocode variant** | `V2` |
| **Repositorio / Repository** | `git@github.com:yorche3/elm.git` |

**ES:** Los datos del lenguaje **no se repiten aquí**: viven en los TSV de `data/` (`language_characteristics`, `canonical_names`, `init_sequences`, `idiomaticity_state`) y en `PARADIGM_FAMILIES.md`. El nivel de cada `(lenguaje, módulo)` vive en `data/idiomaticity_state.tsv`; esta ficha explica **por qué** está donde está.

**EN:** The language facts are **not repeated here**: they live in the TSVs under `data/` (`language_characteristics`, `canonical_names`, `init_sequences`, `idiomaticity_state`) and in `PARADIGM_FAMILIES.md`. Each `(language, module)` level lives in `data/idiomaticity_state.tsv`; this record explains **why** it sits where it sits.

---

## 1. Perfil del lenguaje / Language profile

**ES:** Elm es un lenguaje **funcional puro**, con inmutabilidad total, tipado estático fuerte y recolección de basura. Su compilador traduce a JavaScript, y el resultado necesita un anfitrión que lo ejecute. Su filosofía central es la **ausencia de efectos en tiempo de ejecución** ("No runtime effects"): un programa no puede lanzar excepciones imprevistas ni leer o escribir por su cuenta. Se usa principalmente en interfaces web y en programas sin interfaz con `Platform.worker`.

**EN:** Elm is a **purely functional** language, fully immutable, with strong static typing and garbage collection. Its compiler translates to JavaScript, and the output needs a host to run. Its core philosophy is the **absence of runtime effects** ("No runtime effects"): a program cannot throw unexpected exceptions or read and write on its own. It is used mainly for web interfaces and for headless programs with `Platform.worker`.

**ES:** Creado por Evan Czaplicki en 2012, con el objetivo de eliminar los errores de tiempo de ejecución en el frontend. Referencia oficial: <https://guide.elm-lang.org/>.

**EN:** Created by Evan Czaplicki in 2012, aiming to remove runtime errors from the frontend. Official reference: <https://guide.elm-lang.org/>.

---

## 2. Convenciones de nombres / Naming conventions

| Elemento / Element | Convención / Convention | Ejemplo / Example |
|--------------------|------------------------|-------------------|
| Tipos / Types | `PascalCase` | `Node`, `LinkedList` |
| Constructores de tipo / Type constructors | `PascalCase` | `Just`, `Nothing` |
| Funciones / Functions | `camelCase` | `insertHead`, `isEmpty` |
| Variables / Variables | `camelCase` | `headNode`, `value` |
| Módulos / Modules | `PascalCase` | `HelloWorld` |
| Archivos / Files | `PascalCase.elm`, igual que el módulo / same as the module | `HelloWorld.elm` |
| Predicados / Predicates | prefijo `is` / `is` prefix | `isEmpty` |

**ES:** La traducción concepto → nombre **no se repite aquí**: es la fila de `elm` en `data/canonical_names.tsv`. El nombre del fichero **debe** coincidir con el del módulo: es una regla del compilador, no una preferencia (crit. (c) del módulo: `HelloWorld.elm`).

**EN:** The concept → name translation is **not repeated here**: it is the `elm` row in `data/canonical_names.tsv`. The file name **must** match the module name: that is a compiler rule, not a preference (module criterion (c): `HelloWorld.elm`).

---

## 3. Construcción / Construction

**Forma idiomática / Idiomatic form:**

```elm
n = Node 10 Nothing

l = LinkedList
```

**Notas / Notes:**

- **ES:** El constructor del tipo (`Node 10 Nothing`) **es** la fábrica: Elm no tiene `init` como método ni clases. El registro con campos opcionales se actualiza con `{ n | next = Just x }`.
- **EN:** The type constructor (`Node 10 Nothing`) **is** the factory: Elm has no `init` method and no classes. A record with optional fields is updated with `{ n | next = Just x }`.

**Anti-patrones / Anti-patterns:**

- **ES:** ❌ Definir `init : Int -> Node` cuando el constructor ya construye. ❌ Usar `Maybe` solo por costumbre en un campo que el módulo exige siempre.
- **EN:** ❌ Defining `init : Int -> Node` when the constructor already builds. ❌ Using `Maybe` out of habit on a field the module always requires.

---

## 4. Fallo / Failure

| Operación / Operation | Retorno / Return |
|-----------------------|------------------|
| `head`, `pop`, `peek`, `dequeue` | `Maybe a` → `Just x` / `Nothing` |

**ES:** "No hay valor" se representa con `Nothing` y se consume con `case`. No hay excepciones ni centinelas (`-1`, `null`): el tipo obliga a tratar la ausencia.

**EN:** "No value" is represented with `Nothing` and consumed with `case`. There are no exceptions and no sentinels (`-1`, `null`): the type forces absence to be handled.

---

## 5. Acceso / Access

| Operación / Operation | Forma / Form |
|-----------------------|--------------|
| Leer un campo / Read a field | `n.value` |
| Encadenar campos / Chain fields | `n.next` (`Maybe Node`) |

**ES:** Los campos de un registro se leen con `.` y no hay getters: el nombre del campo **es** la API de acceso.

**EN:** Record fields are read with `.` and there are no getters: the field name **is** the access API.

---

## 6. Encapsulación / Encapsulation

**ES:** El módulo de Elm expone lo que declara en `module … exposing (…)`. La convención del monorepo es exponer el **tipo** con su constructor y las funciones que operan sobre él (`LinkedList.isEmpty l`, `LinkedList.insertHead v l`), y no exponer constructores internos que permitan saltarse los invariantes.

**EN:** An Elm module exposes what it declares in `module … exposing (…)`. The monorepo convention is to expose the **type** with its constructor and the functions that operate on it (`LinkedList.isEmpty l`, `LinkedList.insertHead v l`), and not to expose internal constructors that would allow skipping invariants.

---

## 7. Palabras reservadas y conflictos / Reserved words and conflicts

`type`, `alias`, `module`, `where`, `exposing`, `import`, `as`, `port`, `let`, `in`, `case`, `of`, `if`, `then`, `else`. La columna `reserved_conflicts` de `data/canonical_names.tsv` está vacía para `elm`: **ninguno** de los nombres canónicos choca con una palabra reservada.

`type`, `alias`, `module`, `where`, `exposing`, `import`, `as`, `port`, `let`, `in`, `case`, `of`, `if`, `then`, `else`. The `reserved_conflicts` column in `data/canonical_names.tsv` is empty for `elm`: **none** of the canonical names clashes with a reserved word.

---

## 8. Complejidad / Complexity

**ES:** `N/A` en este lenguaje para los módulos de Fase 1 con coste nulo: `hello_world` no tiene complejidad que declarar. El README del módulo cumple igualmente el criterio de declarar la ausencia de coste algorítmico.

**EN:** `N/A` for this language on Phase-1 modules with no cost: `hello_world` has no complexity to declare. The module README still meets the criterion of declaring the absence of algorithmic cost.

---

## 🧩 Rarezas / Peculiarities

**ES:** Lo que el lenguaje **obliga** y no se puede evitar:

**EN:** What the language **forces** and cannot be avoided:

1. **Sin salida por consola en la biblioteca estándar.** Elm no tiene `print`: la única forma que da la stdlib de escribir en la consola desde un `Platform.worker` es `Debug.log`, que es una utilidad de **depuración** y antepone el tipo del valor. El mensaje del módulo sale como `Hello, World! from Elm!: ()`. La alternativa (un paquete de terceros como `elm-console`) queda descartada por el criterio del módulo "solo biblioteca estándar".
   / **No console output in the standard library.** Elm has no `print`: the only way the stdlib gives to write to the console from a `Platform.worker` is `Debug.log`, a **debug** facility that prefixes the value's type. The module's message prints as `Hello, World! from Elm!: ()`. The alternative (a third-party package such as `elm-console`) is discarded by the module criterion "standard library only".
2. **El resultado compilado necesita un anfitrión.** `elm make` produce JavaScript que hay que cargar desde Node: el módulo incluye un `run.js` que hace esa carga y arranca el programa.
   / **The compiled output needs a host.** `elm make` produces JavaScript that has to be loaded from Node: the module ships a `run.js` that performs that load and starts the program.
3. **Sin efectos en tiempo de ejecución.** Para Elm la impresión es una herramienta de depuración, no una API de E/S: por eso la rareza se documenta y se acepta, en vez de corregirse.
   / **No runtime effects.** For Elm, printing is a debugging tool, not an I/O API: that is why the peculiarity is documented and accepted instead of fixed.

---

## ⚠️ Desviaciones del pseudocódigo canónico / Deviations from the canonical pseudocode

**ES:** Ninguna. El módulo `hello_world` no se aparta del pseudocódigo canónico: el mensaje es el exacto, el fichero sigue la convención (`HelloWorld.elm`) y no hay mecanismos peligrosos. La salida por `Debug.log` es una **rareza del lenguaje** (sección anterior), con severidad 🟡 `warning` y estado `active`: baja el nivel a `mostly-idiomatic` y queda **aceptada por el autor**, por escrito, en el registro de auditoría del módulo.

**EN:** None. The `hello_world` module does not deviate from the canonical pseudocode: the message is exact, the file follows the convention (`HelloWorld.elm`) and no dangerous mechanisms are used. Printing through `Debug.log` is a **language peculiarity** (previous section), with severity 🟡 `warning` and state `active`: it lowers the level to `mostly-idiomatic` and is **accepted by the author**, in writing, in the module's audit record.

---

## 📝 Notas por módulo / Per-module notes

| Módulo / Module | Nivel / Level | Nota / Note |
|-----------------|---------------|-------------|
| `hello_world` | `mostly-idiomatic` | **ES:** Nivel 2 por la rareza 1: mensaje exacto y fichero `HelloWorld.elm`, pero la salida la escribe `Debug.log` y añade `: ()`. Registro: [`01_Audited_Hello_World.md`](../../audits/01_Audited_Hello_World.md). **EN:** Level 2 due to peculiarity 1: exact message and `HelloWorld.elm` file, but the output is written by `Debug.log` and gets `: ()` appended. Record: [`01_Audited_Hello_World.md`](../../audits/01_Audited_Hello_World.md). |

---

## 🧪 Tests / Tests

**ES:** El módulo `hello_world` no trae suite: su verificación es la ejecución y la comparación de la salida real con el mensaje del criterio (a). El comando de pruebas y el verificador del lenguaje viven en el catálogo del tooling, no aquí.

**EN:** The `hello_world` module ships no suite: its verification is running it and comparing the real output with criterion (a)'s message. The language's test command and verifier live in the tooling catalogue, not here.

---

## 🔗 Referencias / References

| Documento / Document | Qué aporta / What it provides |
|----------------------|-------------------------------|
| [`PSEUDOCODE_CONVENTION.md`](../PSEUDOCODE_CONVENTION.md) | El contrato que se traduce / The contract being translated |
| [`IDIOMATICITY_LEVELS.md`](../IDIOMATICITY_LEVELS.md) | La escala de 4 niveles y su cálculo / The 4-level scale and its computation |
| [`DEVIATION_POLICY.md`](../DEVIATION_POLICY.md) | Severidad y dónde vive cada desviación / Severity and where each deviation lives |
| [`AUDIT_WORKFLOW.md`](../../AUDIT_WORKFLOW.md) | El ciclo: pase, `align` y cierre / The cycle: pass, `align` and closure |
| [`elm.md` de `data/`](../data/idiomaticity_state.tsv) | El nivel y el commit verificados / The verified level and commit |
