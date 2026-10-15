# Auditoría de Módulo: 02_Hello_User
# Module Audit: 02_Hello_User

Registro de deuda técnica del módulo `02_Hello_User`. / Technical debt record for the `02_Hello_User` module.

- **Especificación / Specification:** [`02_Hello_User.md`](../core/foundations/02_Hello_User.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Última verificación / Last verification:** 2026-10-14

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
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | **20** ficheros fuera de la convención `hello_user.ext`/`HelloUser.ext` (16 con `hellouser.ext`, más `hello-user.fsx`, `Program.cs`, `Main.purs` y `src/hellouser.gleam`); **0** fuentes con `What is your name` o `Please enter your name` |
| 2. Lectura de código | Entrada/salida y cómo se guarda lo ingresado, construcción y comentarios | **5** mecanismos que rompían el contrato o el idioma: `pull` en `rexx` (sube a mayúsculas), `System.console()` en `groovy` (falla sin terminal), `Js.log2/3` en `rescript` (espacios y sin signo final), `hellouser/0` en `prolog` (nombre de regla) y el signo final ausente en `assembly`, `erlang`, `forth`, `haxe` y `elixir` |
| 3. Ejecución | El comando documentado en cada README, con la entrada del módulo (`John`; `Ada` en `rexx`), en copias de `/tmp` | **49/50 con código 0**; `grain` no tiene módulo; `groovy` daba rc=1 antes de su arreglo (`NullPointerException`), corregido después |
| 4. Documentación | README del módulo contra [`README_Template.md`](../README_Template.md) y las citas del código | Citas corregidas en los lenguajes tocados: prompt, nombre del fichero, `parse pull`, `main/0` y el fichero compilado de `typescript` |
| 5. Estado del árbol | `git -C {lang} status --short` en los 50 submódulos | **50/50 limpios**: todas las ejecuciones se hicieron sobre copias fuera del repositorio |

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- — **ninguno**: los **11** hallazgos de prompt/saludo (`ada`, `assembly`, `cobol`, `elixir`, `erlang`, `forth`, `haxe`, `javascript`, `raku`, `rexx`, `tcl-tk`) y los **20** de nombre de fichero estaban corregidos, integrados en `main` y empujados al cerrar este registro (ver la deuda). El snapshot de lo encontrado queda en la tabla de método.

### 🟡 Advertencias / Warnings

- — **ninguna**: el aviso **CS8600** de `csharp` (el análisis de nulabilidad sobre `Console.ReadLine()` con `<Nullable>enable</Nullable>`) se corrigió con `?? string.Empty`.

### 🔵 Aceptados por el autor / Accepted by the author

| Lenguaje / Language | Desviación aceptada / Accepted deviation | Evidencia / Evidence |
|---|---|---|
| `grain` | El lenguaje **no tiene stdin**, así que el módulo interactivo no se puede implementar: se acepta que no exista (`core/foundations/` solo tiene `helloworld`, `numbers` y `unit_test`) | Ficha [`idioms/grain.md`](../ruleset/idioms/grain.md); nivel `not-started` en el estado |

### 🟢 Homologados / Homologated

`ada`, `assembly`, `ballerina`, `c`, `clojure`, `cobol`, `common-lisp`, `cpp`, `crystal`, `csharp`, `d`, `dart`, `elixir`, `elm`, `erlang`, `forth`, `fsharp`, `gleam`, `go`, `groovy`, `haskell`, `haxe`, `java`, `javascript`, `julia`, `kotlin`, `lua`, `nim`, `ocaml`, `perl`, `php`, `prolog`, `purescript`, `python`, `r`, `racket`, `raku`, `rescript`, `rexx`, `ruby`, `rust`, `scala`, `scheme`, `swift`, `tcl-tk`, `typescript`, `v`, `vala`, `zig` — **49 lenguajes**: prompt `Enter your name: ` y saludo con el nombre ingresado, fichero según la convención y sin desviación de eje. `elm` usa `Platform.worker` con su `run.js`, como en `hello_world`.

## Deuda por lenguaje / Debt per language

| # | Alcance / Scope | Acción / Action | Lenguajes / Languages | Estado / State |
|:-:|-----------------|-----------------|-----------------------|:--------------:|
| 1 | Prompt y saludo | Pedir con `Enter your name: ` y responder `Hello, {nombre}!` con lo ingresado | 11: `ada`, `assembly`, `cobol`, `elixir`, `erlang`, `forth`, `haxe`, `javascript`, `raku`, `rexx`, `tcl-tk` | ✅ corregida e integrada |
| 2 | Nombre del fichero | `git mv` a `hello_user.ext`/`HelloUser.ext` y actualizar lo que lo cite | 20: los 16 con `hellouser.ext` más `fsharp`, `csharp`, `purescript` y `gleam` | ✅ corregida e integrada |
| 3 | Otros ejes | `parse pull` en `rexx` (conserva el caso), `System.in` en `groovy`, `Js.log` en `rescript`, `main/0` en `prolog`, el signo final en `assembly` y `?? string.Empty` en `csharp` | 6 | ✅ corregida e integrada |
| 4 | Módulo ausente | `grain` no tiene stdin: el módulo no existe y se acepta así | 1 | 🔵 aceptada |

## Plan de cierre / Closure plan

**ES:** Orden seguido: el pase completo (5 pasos), el `align` por tipo de hallazgo —nombres primero, prompt/saludo después, y los casos de implementación— y el cierre cuando todos estuvieron integrados y empujados. **32 submódulos** con commits, todos en su `main` y sin ramas de trabajo vivas. Ver [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

**EN:** Order followed: the full pass (5 steps), the `align` batched by finding —names first, prompt/greeting after, then the implementation cases— and closure once all were integrated and pushed. **32 submodules** with commits, all on their `main` and with no live work branches. See [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| 2026-10-14 | Barrido léxico de los 50 | `git -C {lang} ls-tree -r --name-only main -- core/foundations/hellou*` + `grep` del prompt y de la lectura por lenguaje | 20 nombres fuera de convención; 11 lenguajes con el prompt/saludo del contrato incumplido; 5 casos de lectura distintos |
| 2026-10-14 | Ejecución con la entrada del módulo | El comando documentado en cada README, con `John` (`Ada` en `rexx`), sobre copias en `/tmp` | 49/50 rc=0; `grain` sin módulo; `groovy` rc=1 antes de su arreglo |
| 2026-10-14 | Correcciones | 20 `git mv` (+ `spago run` y `gleam run` para verificar `purescript` y `gleam`), `sed` en los 11 de prompt/saludo y arreglos en `rexx`, `rescript`, `prolog`, `groovy`, `assembly` y `csharp` | 34 commits en 32 submódulos, todos integrados en su `main` y empujados |
| 2026-10-14 | Cierre y sincronización | `git -C {lang} rev-parse --short=7 main` por lenguaje + `git submodule status` | 50 filas de `hello_user` en el estado con el commit verificado; 32 punteros del monorepo listos para sincronizar |

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| — | — | — | — |
