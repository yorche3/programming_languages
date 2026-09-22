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

## 🧰 Verbos de la versión viva (v0.5.0) / Verbs in the live version

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
| `use <lenguaje> <fase>/<módulo> [tipo]` | Sitúa el trabajo: valida, crea el directorio del módulo, prepara y publica la rama, guarda el estado del sprint; imprime la ruta del módulo | 0 / 1 / 2 / 3 |
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

13. **Sin `exit`, sin tocar opciones globales del shell** (`set -e`, `IFS`) ni el directorio actual fuera de un verbo que lo pida explícitamente; todo sale con `return`.
14. **Raíz del monorepo**: `GLOT_ROOT` → superproyecto → raíz git, para que funcione también desde dentro de un submódulo.
15. **Un solo archivo, dos modos**: la guarda `"${BASH_SOURCE[0]}" == "$0"` ejecuta el dispatcher solo cuando se invoca como programa; cargado con `source`, el archivo define la función y no ejecuta nada.

---

## 🧾 Especificación de `use` (v0.5.0, implementado) / `use` specification

```bash
glot use <lenguaje> <fase>/<módulo> [tipo]     # tipo por defecto: feat
glot use <fase>/<módulo> [tipo]                # dentro del submódulo, deduce el lenguaje
```

**ES:** `use` **sitúa el trabajo**: dice dónde vas a trabajar y lo deja preparado. No implementa, no genera esqueleto y no toca el monorepo.

**EN:** `use` **locates the work**: it tells you where you will be working and gets it ready. It does not implement, does not scaffold and does not touch the monorepo.

| Paso | Efecto |
|:----:|--------|
| 1 | Valida lenguaje, fase, módulo, `tipo` y estado del árbol **sin tocar nada** |
| 2 | Resuelve la especificación `docs/core/{fase}/{NN}_{Nombre}.md` |
| 3 | Crea `{lenguaje}/core/{fase}/{módulo}` si no existe (**vacío**: sin `src/` ni `test/`) |
| 4 | `checkout` de `{tipo}/{fase}/{módulo}` o `checkout -b` si no existe; idempotente si ya estás en ella |
| 5 | Publica la rama: `git push -u origin {rama}` |
| 6 | Escribe el estado (`lang`, `phase`, `module`, `branch`, `spec`, `repo`) |
| 7 | Imprime la **ruta absoluta** del módulo en stdout |

| Comprobación | Falla con |
|--------------|:---------:|
| Faltan argumentos, `tipo` fuera de `feat\|fix\|docs\|chore\|refactor\|test`, opción desconocida | `2` |
| Lenguaje fuera de `.gitmodules` · especificación ausente · submódulo sin inicializar · árbol con cambios sin confirmar | `1` |
| Estado no escribible (la rama ya estaría preparada: se avisa por stderr) | `3` |

**ES:** **No hace:** commits, `git add`, correr el inicializador, generar esqueleto, tocar la rama del monorepo ni el puntero del submódulo. **El `cd` real no llega hasta la v1.0.0** (capa cargable): hasta entonces, `cd "$(glot use …)"`.

**EN:** **It does not:** commit, `git add`, run the initializer, scaffold, touch the monorepo branch or the submodule pointer. **The real `cd` arrives in v1.0.0** (loadable layer): until then, `cd "$(glot use …)"`.
