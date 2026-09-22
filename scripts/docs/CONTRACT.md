# 📜 Contrato de `glot` / `glot` contract

**ES:** Reglas que cumplen **todos** los verbos, más el contrato del almacén de estado. Es lo que hace que `glot` se pueda encadenar: la salida de un verbo se puede capturar sin parsear texto humano.

**EN:** Rules **every** verb obeys, plus the state store contract. This is what makes `glot` scriptable: a verb's output can be captured without parsing human text.

---

## 🧱 Contrato de todos los verbos / Every-verb contract

| Regla | Detalle |
|-------|---------|
| stdout | Solo el dato (así `$(glot get lang)` es utilizable) |
| stderr | Diagnóstico, avisos y errores; `set`/`unset` confirman aquí |
| Códigos de salida | `0` correcto · `1` error de entorno o dato ausente · `2` uso incorrecto · `3` estado ilegible o no escribible |
| Flags | `-h/--help` (general y por verbo), `--version`, `-q/--quiet`; desde v0.4.0, `-n/--dry-run` en los verbos que mutan |
| Interacción | Un verbo nunca pregunta: el dato llega por argumento o por stdin |
| Idempotencia | Repetir el mismo efecto no cambia el resultado ni el código de salida |
| Testabilidad | La raíz del repo y la ruta del estado son inyectables por variable (`GLOT_ROOT`, `GLOT_STATE_DIR`/`GLOT_STATE_FILE`) |
| Bilingüismo | `help`, `doctor` y los errores van en ES/EN; los datos de salida (`Hello, Ada!`) no se traducen |

---

## 🔢 Códigos de salida / Exit codes

| Código | Significado | Cuándo |
|:------:|-------------|--------|
| `0` | Correcto | El verbo hizo lo que promete |
| `1` | Entorno o dato ausente | Falta bash 4+, git, la raíz del monorepo, un lenguaje de `.gitmodules`, la especificación, o el árbol tiene cambios sin confirmar |
| `2` | Uso incorrecto | Verbo desconocido, opción desconocida, argumentos de menos, valor inválido |
| `3` | Estado ilegible o no escribible | No se pudo leer, crear o escribir el almacén |

> **ES:** `3` no se confunde con `1`: quien llama debe poder distinguir «me falta un dato» de «no puedo guardar».
> **EN:** `3` is not confused with `1`: callers must be able to tell "I am missing a datum" from "I cannot save".

---

## 🧰 Verbos de la versión viva (v0.6.0) / Verbs in the live version

| Verbo | Comportamiento | Código |
|-------|----------------|:------:|
| `version`, `--version` | `glot 0.5.0` | 0 |
| `help`, `-h`, `--help`, `help <verbo>` | Ayuda general o de un verbo | 0 |
| `doctor` | Diagnóstico: bash, git, raíz del monorepo, directorio y fichero de estado, y número de claves | 0 / 1 |
| `greet [nombre]` | `Hello, <nombre>!` con el nombre por argumento o por stdin | 0 / 2 |
| `hello [nombre]` | Igual que `greet`; compatibilidad con v0.2.0, se retira en v1.0.0 | 0 / 2 |
| `set <clave> <valor>` | Guarda la clave; confirma por stderr; con `-n`, imprime `clave=valor` y no escribe | 0 / 2 / 3 |
| `get <clave>` | Imprime el valor en stdout | 0 / 1 / 2 |
| `unset <clave>` | Borra la clave; repetirlo no es error | 0 / 2 / 3 |
| `list` | Todas las entradas `clave=valor`, ordenadas por clave en `LC_ALL=C` | 0 / 3 |
| `path` | Ruta del fichero de estado | 0 |
| `use <lenguaje> <fase>/<módulo> [tipo]` | Sitúa el trabajo según los cuatro estados del sprint (nuevo, en curso, reanudar y cerrado): valida, activa o crea la rama desde `main`, la publica con `-u` y crea la carpeta del módulo si falta; con trabajo sin confirmar no toca nada. Guarda el estado del sprint e imprime la ruta | 0 / 1 / 2 / 3 |
| `langs` | Catálogo de lenguajes: uno por línea con su **comando nativo de pruebas** | 0 / 1 |
| `modules [fase]` | Catálogo de módulos del roadmap con su especificación resuelta (`-` si aún no existe) | 0 / 1 / 2 |
| `progress [fase]` | Estado del roadmap: sin fase, contadores globales en `clave=valor`; con fase, una línea por módulo | 0 / 1 / 2 |
| `completion [bash\|zsh]` | Imprime el guion de autocompletado en stdout; **no** lo instala | 0 / 1 / 2 |
| Verbo desconocido | Error en stderr con sugerencia de `greet`/`help`; un nombre suelto ya no vale | 2 |

---

## 💾 Almacén de estado / State store

| Regla | Detalle |
|-------|---------|
| Ubicación | `GLOT_STATE_DIR` → `$XDG_STATE_HOME/glot` → `~/.local/state/glot`; el fichero es `<dir>/state`, salvo que `GLOT_STATE_FILE` lo sobreescriba (gana a todo; es lo que usa el harness para aislarse) |
| Formato | Texto plano, una línea `clave=valor` por entrada; clave `[A-Za-z0-9_.-]+`, valor sin `\n` ni `\r` |
| Validación | Clave y valor se validan **antes** de tocar el disco; lo que no cumple falla con `2` |
| Escritura | Atómica: temporal con `mktemp` en el mismo directorio, `chmod 600`, `mv -f`; el directorio se crea con `chmod 700` |
| Concurrencia | `flock` sobre `<fichero>.lock` rodeando el ciclo leer-modificar-escribir |
| Lectura | `list` ordena con `LC_ALL=C sort -t= -k1,1`; `get` distingue «no encontrada» (`1`) de «valor vacío» (`0` con línea vacía) |
| Errores | No poder crear o escribir devuelve `3` |
| `-n/--dry-run` | Los verbos que mutan imprimen el efecto en stdout y no escriben; validan igual que la ejecución real |

### Claves reservadas / Reserved keys

| Clave | Significado | La escribe |
|-------|-------------|:----------:|
| `lang` | Lenguaje del sprint (carpeta del submódulo) | `use` (v0.5.0) |
| `phase` | Fase bajo `{lenguaje}/core/` (`foundations`, `algorithms`, …) | `use` (v0.5.0) |
| `module` | Módulo en `snake_case` (`naive_sort`) | `use` (v0.5.0) |
| `branch` | Rama de trabajo (`feat/algorithms/naive-sort`) | `use` (v0.5.0) |
| `spec` | Ruta de la especificación (`docs/core/algorithms/05_Naive_Sort.md`) | `use` (v0.5.0) |
| `repo` | Ruta del submódulo dentro del monorepo | `use` (v0.5.0) |

**ES:** Hasta la v0.4.0 el almacén solo guardaba y devolvía texto: no interpretaba ninguna clave. Desde la v0.5.0 las escribe `use`.

**EN:** Up to v0.4.0 the store only saved and returned text: it interpreted no key. Since v0.5.0, `use` writes them.

---

## 📐 Reglas de diseño / Design rules

### Desde v0.3.0

1. **stdout solo dato, stderr solo diagnóstico**, para que la salida se pueda canalizar y capturar.
2. **Códigos de salida estables** (`0`/`1`/`2`/`3`).
3. **Nunca preguntar** en un verbo: el dato llega por argumento o stdin.
4. **Idempotencia** cuando se repite el mismo efecto.
5. **Inyectable para test**: raíz del repo y ruta del estado sobreescribibles por variable.
6. **Mensajes bilingües ES/EN**; los datos de salida no se traducen.
7. **Namespace**: funciones y variables internas con prefijo `_glot_`; públicas solo `GLOT_VERSION`, `GLOT_ROOT`, `GLOT_STATE_DIR` y `GLOT_STATE_FILE`.

### Desde v0.4.0 — el almacén

8. **Texto plano y validado antes de escribir**; lo que no cumpla falla con `2` sin tocar el disco.
9. **Escritura atómica y bloqueada**: temporal en el mismo directorio + `mv -f`, todo bajo `flock`.
10. **Permisos restrictivos**: `600` el fichero y `700` el directorio.
11. **`3` para el estado**, nunca para el uso ni para el entorno.
12. **Ensayo antes de mutar**: todo verbo que escribe admite `-n/--dry-run`.

### Desde v1.0.0 — cuando sea cargable con `source`

13. **Sin `exit`, sin tocar opciones globales del shell** (`set -e`, `IFS`) ni el directorio actual fuera de un verbo que lo pida explícitamente; todo sale con `return`. La única excepción es el subshell del almacén (`( … )` en `_glot_state_rewrite`), donde `exit` termina ese subshell y no el shell que haya cargado `glot`.
14. **Raíz del monorepo**: `GLOT_ROOT` → superproyecto → raíz git, para que funcione también desde dentro de un submódulo.
15. **Un solo archivo, dos modos**: la guarda `"${BASH_SOURCE[0]}" == "$0"` ejecuta el dispatcher solo cuando se invoca como programa; cargado con `source`, el archivo define la función y no ejecuta nada.

---

## 🧭 Catálogo (L2.5, v0.6.0) / Catalogue

**ES:** El catálogo **no adivina nombres: los convierte**. Cada módulo tiene un **id canónico** —el del roadmap— y todas sus formas se derivan de él. Las divergencias legacy se resuelven con excepciones mínimas y sondeo del disco, nunca con una tabla completa que haya que mantener a mano.

**EN:** The catalogue **does not guess names: it converts them**. Every module has a **canonical id** —the roadmap's— and all its forms derive from it. Legacy divergences are solved with minimal exceptions and probing the disk, never with a full table to maintain by hand.

### De un id a todas sus formas / From one id to all its forms

| Forma / Form | `data_structures` | Cómo se obtiene / How |
|--------------|-------------------|------------------------|
| `name` (legible) | `Data Structures` | palabras capitalizadas, separadas por espacio |
| `project_name` (id) | `data_structures` | el id canónico del roadmap; no se deriva, se declara |
| `branch` | `data-structures` | `_glot_kebab`: `_` → `-` |
| documento | `NN_Data_Structures.md` | stem en `Title_Case` con `_`; el prefijo `NN` se **lee** de `docs/core/{fase}/` |
| commit | `data structures` | minúsculas y espacios |

**ES:** Excepciones declaradas (todo lo demás sigue la convención): `unit_test` → documento `03_Unit_Test_Calculator.md`; carpetas `helloworld`/`hellouser` (49 lenguajes; Ada usa el id tal cual) y `unit_test/calculator`, que el sondeo resuelve prefiriendo la forma más específica. La comparación del nombre del documento no distingue mayúsculas, así que `etl_basico` encuentra `14_ETL_Basico.md`.

**EN:** Declared exceptions (everything else follows the convention): `unit_test` → document `03_Unit_Test_Calculator.md`; folders `helloworld`/`hellouser` (49 languages; Ada uses the id as is) and `unit_test/calculator`, which the probe resolves preferring the most specific form. Document name matching is case-insensitive, so `etl_basico` finds `14_ETL_Basico.md`.

### Fuentes de datos / Data sources

| Dato / Datum | Fuente / Source |
|--------------|-----------------|
| Lenguajes registrados | `.gitmodules` (el denominador, 50) |
| Módulos y su estado | el bloque de contadores de `docs/ROADMAP.md` (fuente de verdad) |
| Especificación de cada módulo | `docs/core/{fase}/{NN}_{Nombre}.md`, con el prefijo leído del disco |
| Comandos nativos por lenguaje | [`data/languages.tsv`](../data/languages.tsv), con cabecera documentada en [`data/README.md`](../data/README.md) |
| Texto del autocompletado | [`completions/glot.bash`](../completions/glot.bash) y [`completions/glot.zsh`](../completions/glot.zsh) |

### Formatos de salida / Output formats

| Verbo | stdout |
|-------|--------|
| `langs` | `lenguaje<TAB>prueba nativa`, uno por línea, ordenado en `LC_ALL=C` |
| `modules [fase]` | `id<TAB>fase<TAB>módulo<TAB>especificación` (`-` si el documento aún no existe) |
| `progress` | `registrados=` · `homologados=` · `modulos=` · `pares_hechos=` · `pares_total=`, uno por línea |
| `progress <fase>` | `modulo<TAB>estado<TAB>hechos<TAB>total` |

**ES:** El **estado** se traduce de la marca del roadmap a una palabra en ASCII (`done`, `in_progress`, `planned`, `pending`) para que la salida sea parseable y no dependa de un emoji que un editor pueda corromper. El parser reconoce las marcas **por bytes**; una línea de `core.*` que no entienda es un error `1`, nunca un recuento inventado. Además, `progress` avisa si el contador `X/N` contradice la lista de lenguajes que el propio roadmap escribe entre paréntesis, o si su denominador no coincide con los lenguajes registrados.

**EN:** The **status** is translated from the roadmap mark into an ASCII word (`done`, `in_progress`, `planned`, `pending`) so the output is parseable and does not depend on an emoji an editor could corrupt. The parser recognises marks **by bytes**; a `core.*` line it does not understand is a `1` error, never an invented count. `progress` also warns when the `X/N` counter contradicts the language list the roadmap writes in parentheses, or when its denominator differs from the registered languages.

**ES:** **Definición / Definition:** `registrados` = lenguajes de `.gitmodules`; `homologados` = módulos con su contador completo; `pares_*` = suma de `X` y de `módulos × registrados`.

---

## 🧾 Especificación de `use` (v0.5.0, implementado) / `use` specification

```bash
glot use <lenguaje> <fase>/<módulo> [tipo]     # tipo por defecto: feat
glot use <fase>/<módulo> [tipo]                # dentro del submódulo, deduce el lenguaje
```

**ES:** `use` **sitúa el trabajo**: dice dónde vas a trabajar y lo deja preparado. Lee el estado, nunca lo fuerza: **con trabajo sin confirmar no crea ni cambia ramas**. No implementa, no genera esqueleto (solo crea la carpeta vacía del módulo) y no toca el monorepo.

**EN:** `use` **locates the work**: it tells you where you will be working and gets it ready. It reads the state, never forces it: **with uncommitted work it creates and switches nothing**. It does not implement, does not scaffold (it only creates the empty module folder) and does not touch the monorepo.

| Paso | Efecto |
|:----:|--------|
| 1 | Valida lenguaje, fase, módulo, `tipo` y estado del árbol **sin tocar nada** |
| 2 | Resuelve la especificación `docs/core/{fase}/{NN}_{Nombre}.md` |
| 3 | Clasifica el estado: ¿existe la carpeta del módulo? ¿existe la rama `{tipo}/{fase}/{módulo}`? ¿hay trabajo sin confirmar? |
| 4 | **Árbol limpio**: activa la rama si ya existe, o la crea **desde `main`** si no, y la publica con `push -u origin {rama}`. Crea `{lenguaje}/core/{fase}/{módulo}` (**vacía**: sin `src/` ni `test/`) solo si falta |
| 5 | **Trabajo sin confirmar** (estado normal de reanudar): no crea ni cambia ramas. Si ya estás en la rama objetivo, la republica; si no, informa de dónde estás y de la rama que falta |
| 6 | Escribe el estado (`lang`, `phase`, `module`, `branch`, `spec`, `repo`) |
| 7 | Imprime la **ruta absoluta** del módulo en stdout |

### Estados del sprint / Sprint states

**ES:** Los cuatro estados que `use` reconoce. El directorio del módulo **no** cuenta como suciedad ajena: dentro de él, un árbol sucio es el estado normal de un sprint a medias (fin de jornada, corte de luz, implementación incompleta), no una anomalía.

**EN:** The four states `use` recognises. The module directory does **not** count as foreign dirt: inside it, a dirty tree is the normal state of an unfinished sprint (end of the day, power cut, incomplete implementation), not an anomaly.

| Estado | Árbol | Rama `{tipo}/{fase}/{módulo}` | Qué hace `use` |
|--------|-------|-------------------------------|----------------|
| **Nuevo** | — | no existe | crea la rama desde `main`, la publica, crea la carpeta vacía y guarda el estado |
| **En curso, limpio** | limpio | existe | la activa (aunque estés en `main`), la publica y guarda el estado |
| **Reanudar** | con trabajo sin confirmar | exista o no | **no crea ni cambia nada**: republica si ya estás en la rama; si no, informa de dónde estás |
| **Cerrado** | limpio sobre `main` | no existe | con `tipo` explícito abre la rama de mantenimiento (`test`, `fix`, `refactor`…) desde `main` y la publica; sin `tipo`, avisa y sugiere uno |

**ES:** El `tipo` por defecto (`feat`) es el de la rama propia del módulo: por eso, con el módulo **ya cerrado**, `use` exige indicarlo para no resucitar una rama `feat` fantasma. Con el módulo **nuevo** el valor por defecto se aplica sin preguntar.

**EN:** The default `tipo` (`feat`) is the module's own branch type: that is why, with an **already closed** module, `use` requires it to be given so a phantom `feat` branch is not resurrected. With a **new** module the default applies without asking.

| Comprobación | Falla con |
|--------------|:---------:|
| Faltan argumentos, `tipo` fuera de `feat\|fix\|docs\|chore\|refactor\|test`, opción desconocida | `2` |
| Lenguaje fuera de `.gitmodules` · especificación ausente · submódulo sin inicializar · cambios sin confirmar **fuera** del directorio del módulo · la ruta del módulo existe y no es un directorio · rama no creable o no publicable | `1` |
| Estado no escribible (el módulo y la rama ya estarían preparados: se avisa por stderr) | `3` |

**ES:** **No hace:** commits, `git add`, correr el inicializador, generar esqueleto (`src/`, `test/` y el contrato de pruebas son de `new`, v0.9.0), tocar la rama del monorepo ni el puntero del submódulo. **Con trabajo sin confirmar nunca crea ni cambia de rama**: reanudar es su caso principal, no un error. **El `cd` real no llega hasta la v1.0.0** (capa cargable): hasta entonces, `cd "$(glot use …)"`.

**EN:** **It does not:** commit, `git add`, run the initializer, scaffold (`src/`, `test/` and the test contract belong to `new`, v0.9.0), touch the monorepo branch or the submodule pointer. **With uncommitted work it never creates or switches branches**: resuming is its main case, not an error. **The real `cd` arrives in v1.0.0** (loadable layer): until then, `cd "$(glot use …)"`.
