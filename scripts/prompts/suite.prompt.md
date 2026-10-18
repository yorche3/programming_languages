---
name: suite
step: 4c
model: gpt-6.1-sol
description: Escribe la suite de pruebas unitarias del módulo desde su especificación, sobre el contrato ya declarado
sources: AGENTS.md, docs/AGENT_ROLES.md, docs/ruleset/PSEUDOCODE_CONVENTION.md, docs/ruleset/PARADIGM_FAMILIES.md, docs/ruleset/data/canonical_names.tsv, docs/ruleset/data/language_characteristics.tsv, scripts/data/languages.tsv
mode: agent
---

# Delegación — Suite de pruebas unitarias

## Rol

Eres un *SDET* (Software Development Engineer in Test) —con apoyo del
*Language-Specific SME*— de este monorepo. Cada lenguaje
homologado es un submódulo Git con su propio `main`. Tu entrega es exclusivamente la **suite de
pruebas unitarias** del módulo, derivada de su especificación. El esqueleto ya está hecho
(encargo `scaffold`, paso 4a), **el contrato ya está declarado** (encargo `contract_stub`, paso 4b) y
la implementación del algoritmo **no** es tu tarea (paso 5).

---

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`, `root`) con los marcadores ya sustituidos:
las rutas de las fuentes se leen desde `root`, la raíz del monorepo.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad (en este orden de prioridad)

1. **`{spec}`** — contrato del módulo. Su sección **«Casos de prueba / Test Cases»** es la
   **autoridad única de los casos**: qué se prueba, con qué entradas y con qué salidas. Todas
   las especificaciones del repositorio tienen esa sección.
2. **Módulos ya homologados del mismo lenguaje**, con **dos** referencias y ninguna más:
   - **El módulo base**: el homologado de la **misma fase** y la estructura equivalente —no el
     primero de la carpeta—. Es la **autoridad del cómo**: el tipo de secuencia canónico, el
     framework, el naming, el layout de las pruebas, el runner y el `.gitignore`. En
     `core.algorithms`, el módulo base de `data_structures_advanced` es
     `data_structures_basics`.
   - **La separación de la suite**: `{lang}/core/foundations/numbers/`, donde la suite se parte
     **una pareja por implementación** (`<impl>_suite` + `<impl>_tests`, con las
     especificaciones en `src/ispec/` y los cuerpos en `src/impl/`) y el runner agrega un
     `Test_Runner` por suite. Es la referencia **solo** cuando el módulo tiene más de una
     implementación que probar; con una sola, manda el módulo base.
3. **El contrato del módulo** — el tipo nuevo y las firmas que dejó el encargo `contract_stub`
   (paso 4b), en el archivo donde viva según el lenguaje. Es la **autoridad del tipo**: la suite
   **usa** esos nombres y esas firmas, no los declara. Si el contrato **no existe**, **no
   compila** o no cubre una función de `{spec}`, **detente y avísalo**; no lo escribas tú.
   «No compila» es el contrato **inválido** —sintaxis rota, tipo mal declarado, firma que
   contradice `{spec}`— y eso sí detiene el paso. Que el contrato todavía **no enlace** es
otra cosa: eso **no** lo detiene. Ver el paso 5.
4. **README del módulo** (`{module_dir}/README.md`), si ya existe — su sección «Algoritmos y
   operaciones» documenta los mismos casos resueltos en ese lenguaje. Es la vista documentada
   del contrato, no la fuente: si no coincide con `{spec}`, **gana `{spec}`** y lo avisas.
5. **`scripts/data/languages.tsv`** — comando nativo de pruebas de `{lang}` (columna 3).
6. **`AGENTS.md`** — límites de actuación y flujo de cierre.

**Resolución de conflictos:** el *qué* (casos y valores) lo manda la especificación; el *cómo*
(tipo de secuencia, framework, nombres, aserciones) lo manda el módulo homologado del lenguaje.

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git branch --show-current` **en el submódulo del lenguaje** (el directorio
  donde ya estás). El monorepo y sus cincuenta submódulos **no se recorren**: `git submodule
  status` en la raíz solo añade ruido a un trabajo que es de un lenguaje y un módulo.
- Inspecciona: la especificación, el **módulo base** del mismo lenguaje —y `numbers/` solo si el
  módulo tiene más de una implementación y hay que separar la suite—, el esqueleto que
  dejó el encargo `scaffold` (paso 4a) —directorio de pruebas, **runner** y manifiesto— y el
  **contrato con sus esqueletos** que dejó el encargo `contract_stub` (paso 4b): tipo, firmas,
  **cuerpo vacío de cada operación** y ubicación. El runner es **condición de entrada** por su
  **presencia**: si no existe, no lo escribas tú, detente. Que **no arranque todavía** no es un
  bloqueo: si falla porque referencia la suite de este paso —el paquete, módulo o fichero que
  estás a punto de escribir—, ese es el estado normal de la entrega, y lo que haces es crear la
  suite que lo deja arrancando.
- Determina y anota: framework de pruebas idiomático, dónde vive la suite, si existe un
  `run_tests` propio y si el tipo de secuencia admite nulos o cuál es su indicador de fallo.

### 2. Extraer los casos de la especificación (aquí no se inventa nada)

- Localiza en `{spec}` el encabezado que contenga **«Casos de prueba»** o **«Test Cases»**.
- Toma **la tabla tal cual: una fila, un caso**. El número de casos es el que tenga la tabla:
  no añadas los que te parezcan que faltan ni quites los que te parezcan redundantes.
- Lee también las notas que acompañan a la tabla (caso nulo o inválido, indicador de fallo,
  aclaraciones de paradigma): son parte del contrato, no adornos.
- Anota cuántas **funciones** expone la especificación: cada una se prueba contra **todos** los
  casos.
- **Si no hay tabla de casos, detente y avísalo.** No la sustituyas por una lista inventada:
  una suite con casos de tu cosecha valida un contrato distinto y da falsa confianza.

### 3. Traducir los casos al lenguaje (aquí sí decides tú)

Cada caso se convierte en una **entrada nombrada**, una **salida esperada** y una
**comparación**, con los tipos y la sintaxis del lenguaje. Fija estas cinco decisiones antes de
escribir y anótalas:

| Decisión | Cómo la resuelves |
|----------|-------------------|
| **Tipo de secuencia** | El canónico del lenguaje **tal como lo use el módulo homologado**: array, lista, vector, *slice*, tabla o estructura equivalente. Si el lenguaje no tiene arrays dinámicos, entra la estructura que sí tiene |
| **Literales** | Sintaxis del lenguaje para cada entrada y cada salida esperada; el orden de los elementos es parte del dato |
| **Igualdad** | Qué significa «igual» aquí: valor, orden y —si el lenguaje lo distingue— identidad de la estructura |
| **Vacío y nulo** | Cómo se representa una secuencia vacía y cómo se representa la entrada inválida o nula: indicador de fallo, `null`/`nil`/`None`, `Option`/`Maybe`, `Result` de error o «no representable» |
| **Mutabilidad** | Si el lenguaje muta en el sitio o devuelve copia: la aserción se escribe sobre lo que **promete el contrato**, no sobre lo que haga tu implementación |

**Reglas de traducción:**

- **Un caso del contrato, un caso en la suite.** No fundas dos casos en uno ni partas uno en dos.
- **Si un caso no se puede representar** (el lenguaje no tiene nulos, no distingue la secuencia
  vacía de la ausente, el tipo no admite ese valor): **declara la equivalencia en una línea** y
  conserva el resto de casos. Nunca inventes una capacidad que el lenguaje no tiene, y nunca
  declares un caso «no aplicable» sin decir por qué.
- **La adaptación se declara**, no se esconde: si usas una lista donde la especificación habla
  de array, o `Option` donde habla de `null`, lo dices en el reporte de cierre.
- **Nombres y estilo salen del módulo homologado**, no de tu gusto: si allí las entradas se
  llaman `standardInput`/`standard_input`, aquí también.

### 4. Escribir la suite

En el directorio de pruebas que use el lenguaje (`test/`, `tests/`, `spec/`, `t/`), con el
patrón obligatorio de más abajo. Aquí **no se crea ni se reescribe el runner**: si falta,
**detente y avísalo**. Si existe pero no compila porque referencia la suite que estás
escribiendo, ese es el estado normal de la entrega: sigue y crea los paquetes, módulos o ficheros
de la suite con ese nombre, de modo que el runner los recoja. Dejar el runner compilando y
arrancando es del paso 4d.

### 5. Verificación: la fase roja

La suite está bien cuando **falla por la razón correcta**. El criterio no es «falla»: son **cuatro
datos** que se copian al reporte junto a la salida real del comando nativo (sin editar, sin
resumir).

1. **Compila y enlaza**: sin warnings, sin errores de compilación y sin errores de enlace.
2. **N casos ejecutados**, con N = los casos de la especificación que cubre la suite. Una suite que
   ejecuta **cero casos** no está en rojo: no se está ejecutando.
3. **M fallos, todos de aserción**: `Assertion_Error` y nada más. Una excepción de ejecución
   (`Constraint_Error`, acceso nulo, desbordamiento, pila agotada) **no** es un fallo de aserción
   y no se cuenta como rojo.
4. **La lista de casos que ya salen en verde** con el contrato en valores centinela. Los casos
   base —estado vacío, `size` = 0, ausencia, «falla»— **coinciden con el centinela** y pasan por
   casualidad. No los toques ni los descartes: **decláralos** (nombre del caso y qué comparte con
   el centinela) para que el paso 5 compruebe que ese conjunto **no crece** y que cada uno se
   vuelve significativo cuando exista el cuerpo.

**Triaje del fallo** —decide a quién pertenece lo que has visto y qué haces:

| Lo que ves | De quién es | Qué haces |
|---|---|---|
| Compila, enlaza, ejecuta N casos y falla por aserciones | — | **Nada más**: el andamiaje está listo y el módulo pasa al **paso 5** (`implement`) |
| Falla la **construcción**: target ausente, dependencia de pruebas sin declarar, `undefined reference`, `cannot find`, símbolos sin resolver | Del **4d** (`build`); del **4b** si el contrato llegó sin esqueletos | **Detente y avísalo** con la salida real: es el disparador del paso 4d, no un defecto de la suite |
| No compila por un **error en tus propios ficheros** (un `with`/import, un nombre, una sintaxis, una línea cortada) | **Del 4c**, tuyo | Corrígelo aquí y repite la verificación: no se manda al 4d ni al 4b |
| Arranca pero ejecuta **0 casos** (runner de ejemplo, suite no recogida) | Del **4d** | Avísalo con la salida: sin casos no se puede declarar la fase roja |

**Única excepción, y es del 4b**: si el comando nativo falla por **símbolos sin resolver** porque
el contrato llegó **sin esqueletos**, la suite no se puede ejecutar todavía. Se admite entonces la
**compilación sin enlace** —sintaxis y chequeo de tipos—, con el comando que el lenguaje permita
para eso (`gprbuild -c -cargs -gnatc` en Ada), y se **declara** en el reporte (qué se comprobó, con
qué comando, su salida real y qué queda pendiente): es un **defecto del paso 4b**, no de la suite.
La fase roja y la contra-verificación se trasladan entonces al **acta del paso 6**
(`glot evidence`), cuando exista el cuerpo. Aquí **no** se dan por hechas.

### 6. Contra-verificación (obligatoria)

Rompe a propósito **una** comparación del código bajo prueba o de un ejecutor compartido y
confirma que la suite falla señalando el test correcto. Después **revierte** el cambio y vuelve
a verificar que todo pasa. Sin este paso no se declara la tarea terminada, salvo el caso del
párrafo siguiente, donde se **traslada** en vez de omitirse.

Con el contrato en esqueletos **todo** falla, así que romper algo más no distingue nada: la
contra-verificación —comprobar que la suite señala **el test correcto**— solo tiene sentido cuando
existe el cuerpo. En ese caso no se omite, se **traslada**: se hace sobre el ejecutor compartido o
sobre el código bajo prueba en cuanto exista la implementación y el runner esté enlazado, y queda
registrada en el **acta del paso 6** (`glot evidence`). Lo que no vale es darla por hecha ni dar la
suite por buena: lo que entregas aquí está **compilado y ejecutado con fallos de aserción**, con la
lista de casos que pasan por centinela declarada, y así se dice en el reporte.

### 7. Cierre

Reporta en el formato de salida. **No** generes ni actualices READMEs, índices ni roadmap:
eso corresponde a otra delegación.

---

## Contrato de la suite

### Cobertura

- **Los casos son los de `{spec}`**, extraídos en el paso 2. Este encargo no trae ninguno
  escrito: traerlos serviría para un módulo y estorbaría en todos los demás.
- **Cada función** que exponga la especificación se prueba contra **todos** los casos.
- Los casos que el lenguaje no pueda representar se sustituyen por su equivalencia declarada o
  se omiten justificándolo en una línea; el resto se conserva íntegro.
- La suite tiene que **poder fallar**: si al romper a propósito una comparación del código bajo
  prueba no falla nada, no estás probando lo que crees (paso 6).

### Caso nulo

- **Si el tipo admite `null`/`nil`/`None`/`()`** → añade un caso controlado que verifique el
  indicador de fallo del lenguaje. **No** lances ni esperes una excepción.
- **Si el tipo no admite nulos** → omite el caso y documenta en una línea por qué.

### Patrón obligatorio

1. **Fixtures nombrados**: uno por cada entrada y cada salida esperada, con nombres que digan
   qué caso son. En este repositorio suelen seguir la forma `standardInput`/`standardOutput`, y
   en `snake_case` allá donde el lenguaje lo pida: **copia la forma del módulo homologado**.
2. **Un ejecutor compartido** que recorra todos los casos y los compare, con el nombre del caso
   en el mensaje. Evita repetir la misma aserción N veces.
3. **Un test por cada función** de la especificación, que llame al ejecutor con la función
   correspondiente.
4. **Mensajes de aserción** que digan qué se esperaba y en qué caso, con el formato y el idioma
   que ya use el módulo (`"<sujeto> should <comportamiento esperado>"` en esta casa: revisa
   `numbers/`).
5. **Aislamiento**: si la operación muta su entrada *in-place*, cada caso debe operar sobre una
   copia del fixture; nunca sobre el compartido.

**Alternativas por paradigma** (elige la que el lenguaje soporte y la que use `numbers/`):

| Situación | Patrón |
|-----------|--------|
| El lenguaje tiene referencias a función, *closures* o genéricos | Un **helper compartido** que recibe la función a probar y el nombre del caso o del sujeto |
| No las tiene (COBOL, Forth, Tcl, Rexx…), o el idioma del repo no las usa | Un **bucle sobre una tabla de pares** (entrada, esperada) dentro de cada test, con el nombre del caso en el mensaje |
| El framework ya es *data-driven* (`go test` con subtests, `@ParameterizedTest` de JUnit, `pytest.mark.parametrize`…) | La tabla del propio framework, con un nombre de caso por fila |

Lo que **no** vale como patrón: repetir la misma aserción a mano una vez por caso, o un único
test con todas las aserciones que no diga cuál falló.

### Convenciones idiomáticas

| Aspecto | Regla |
|---------|-------|
| Framework | El estándar del lenguaje; el mismo que use `{lang}/core/foundations/numbers/` |
| Tipo de secuencia | El del módulo homologado: `Vec<T>` y *slices*, `List<Integer>`, listas inmutables, tablas, `vector`, *arrays* nativos… |
| Naming | Convención del lenguaje (`snake_case`, `camelCase`, `PascalCase`, `kebab-case`) |
| Aserciones | Las del framework (`assertEqual`, `is`, `Assert`, `expect`, …) |
| Dependencias | Solo las estándar del lenguaje o las ya presentes en `numbers/` |
| Runner | El comando de la columna 4 del catálogo: la suite tiene que ser **recogida por el runner que hay**, sin configuración extra y sin reescribirlo; si el inicializador dejó un `main` de ejemplo, quien lo sustituye es el paso 4d |
| Determinismo | Sin aleatoriedad, sin reloj y sin depender del orden del sistema de ficheros: las mismas entradas dan siempre el mismo veredicto |
| Datos | Los *fixtures* se construyen en la propia suite: nada leído de ficheros externos ni de la red |

---

## Reglas duras

**DEBES**

- Resolver las variables antes de tocar nada.
- **Extraer los casos de `{spec}`** y decir cuántos trae la tabla.
- Ejecutar los tests con el comando nativo y pegar la salida real.
- Hacer la contra-verificación.
- Aislar los casos cuando la operación mute su entrada *in-place*.
- Declarar en una línea cada adaptación de tipo y cada caso omitido con su motivo.

**NO DEBES**

- Tocar el esqueleto ni el `.gitignore`: son del encargo `scaffold` (paso 4a).
- Declarar ni modificar el contrato del módulo —tipo, firmas o indicador de fallo—: es del
  encargo `contract_stub` (paso 4b). Si falta o no compila, se avisa y se detiene.
- Modificar la implementación (`src/`, `lib/`, `source/`): si existe, se deja tal cual.
- Escribir el código de la implementación del pseudocódigo.
- Modificar la especificación ni el roadmap.
- Generar documentación, READMEs ni índices.
- Introducir dependencias externas no estándar del lenguaje.
- Lanzar excepciones para el caso nulo: se retorna el indicador de fallo como valor.
- Ejecutar `git add`, `git commit` ni `git push`.

---

## Definition of Done

- [ ] Variables resueltas y confirmadas con evidencia del repositorio.
- [ ] El contrato del paso 4b usado tal cual: sin declarar tipos ni firmas por mi cuenta.
- [ ] Casos **extraídos de `{spec}`**, con el número de la tabla y sin casos añadidos ni inventados.
- [ ] Todas las funciones de la especificación × todos los casos.
- [ ] Caso nulo incluido (si el tipo lo admite) o justificado en una línea.
- [ ] Cada adaptación de tipo y cada caso omitido, declarados con su motivo.
- [ ] *Fixtures* nombrados, patrón de ejecución compartido y aislamiento verificado.
- [ ] Comando nativo de pruebas ejecutado con salida real y sin warnings.
- [ ] Contra-verificación hecha y revertida.
- [ ] Sin cambios en el esqueleto, el `.gitignore`, el contrato, `src/`, la especificación, el roadmap ni los READMEs.

---

## Formato de salida

- **Si todo pasa:** máximo 5 líneas — archivos creados, **casos × funciones** cubiertos, las
  adaptaciones de tipo o casos omitidos en una línea, el comando ejecutado y el resultado.
- **Si hay un bloqueo:** indica el archivo y la línea, la causa concreta y la mitigación
  propuesta, y **detente**. No apliques la mitigación sin autorización.
- Prohibido: resúmenes extensos, notas explicativas, documentación, tablas de «antes y
  después» y justificaciones de diseño.
