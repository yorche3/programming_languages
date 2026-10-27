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

Lee `scripts/prompts/Delegation_Policy.md` (incluida al armar el encargo):
fija las bases por prioridad y la agrupación por tema e idioma para este rol.

---

## Fuentes de verdad (en este orden de prioridad)

1. **`{spec}`** — contrato del módulo. Su sección **«Casos de prueba / Test Cases»** es la
   **autoridad única de los casos**: qué se prueba, con qué entradas y con qué salidas. Todas
   las especificaciones del repositorio tienen esa sección.
2. **Las dos bases homologadas del mismo lenguaje**, en el orden persistente de la
   política compartida. Orientan framework, naming, layout y runner. Elige la
   agrupación por unidades, variantes y casos del módulo actual, no por el número
   de archivos de una base ni por estar en la misma fase.
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
- Inspecciona: la especificación, las dos bases en el orden compartido, el esqueleto que
  dejó el encargo `scaffold` (paso 4a) —directorio de pruebas, **runner** y manifiesto— y el
  **contrato con sus esqueletos** que dejó el encargo `contract_stub` (paso 4b): tipo, firmas,
  **cuerpo vacío de cada operación** y ubicación.
- Confirma que el runner mínimo del paso 4a existe y arranca sin casos. En este paso solo
  conectas los grupos de la suite al runner ya preparado; si falta, está roto o sigue siendo
  un ejemplo, informa el defecto del 4a y no reescribas la infraestructura.
- Determina y anota: framework de pruebas idiomático, dónde vive la suite, si existe un
  `run_tests` propio y si el tipo de secuencia admite nulos o cuál es su indicador de fallo.

### 2. Extraer los casos de la especificación (aquí no se inventa nada)

- Localiza en `{spec}` el encabezado que contenga **«Casos de prueba»** o **«Test Cases»**.
- Toma **la tabla tal cual: una fila, un caso**. El número de casos es el que tenga la tabla:
  no añadas los que te parezcan que faltan ni quites los que te parezcan redundantes.
- Lee también las notas que acompañan a la tabla (caso nulo o inválido, indicador de fallo,
  aclaraciones de paradigma): son parte del contrato, no adornos.
- Mapea cada caso o escenario a su **operación y contrato**, y a las variantes
  aplicables. Solo implementaciones alternativas del mismo contrato comparten
  todos sus casos; no cruces casos de árbol con operaciones de grafo, por ejemplo.
- Declara `unidad/variante → casos aplicables → grupo lógico → archivo/suite →
  runner`, con referencia y motivo. Conserva los pasos de cada escenario y permite
  varios grupos en una suite o suites separadas según el framework.
- **Si no hay tabla de casos, detente y avísalo.** No la sustituyas por una lista inventada:
  una suite con casos de tu cosecha valida un contrato distinto y da falsa confianza.

### 3. Traducir los casos al lenguaje (aquí sí decides tú)

Cada caso se convierte en una **entrada nombrada**, una **salida esperada** y una
**comparación**, con los tipos y la sintaxis del lenguaje. Fija estas cinco decisiones antes de
escribir y anótalas:

| Decisión | Cómo la resuelves |
|----------|-------------------|
| **Tipos y representación** | Los del contrato actual: estructura, escalar, array, lista, vector, *slice* o tabla. Las bases orientan la forma idiomática, no sustituyen el tipo del dominio |
| **Literales** | Sintaxis del lenguaje para cada entrada y cada salida esperada; el orden de los elementos es parte del dato |
| **Igualdad** | Qué significa «igual» aquí: valor, orden y —si el lenguaje lo distingue— identidad de la estructura |
| **Vacío e inválido** | Estado vacío, ausencia o entrada inválida según cada operación y el indicador admitido por el lenguaje, la fase y el contrato |
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
patrón obligatorio de más abajo. El runner mínimo pertenece al paso 4a. Aquí se agregan los
grupos reales al runner existente; no se crea ni reemplaza la infraestructura de pruebas.

| Lo que hay en el esqueleto | Qué haces |
|---|---|
| El comando nativo **recoge por convención** (`pytest` con `test_*.py`, `cargo test` con `#[test]`, `go test`, `dotnet test`, `rspec` con `spec/`, `mix test`…) | Nada: coloca la suite donde la convención la espera |
| Hay un **runner mínimo vacío** dejado en 4a | Conecta a él todos los grupos reales sin alterar su contrato de ejecución |
| Hay un **runner de ejemplo** o no existe el runner requerido | Detente y reporta el defecto del paso 4a con archivo, comando y salida real; no escribas casos ni sustituyas infraestructura |
| El fichero del runner lo **genera la construcción** | Reporta la dependencia de construcción; el 4d puede ajustar su generación sin pedir que se vuelva a escribir la suite |

Un fallo de construcción no deshace ni invalida los archivos de suite ya escritos. Repórtalo con
el comando, el código de salida y la salida real; se corrige en 4d y luego se vuelve a ejecutar
`glot test` sobre esta misma suite. No se repite la delegación `suite`.

### 5. Verificación: la fase roja

La suite está bien cuando **falla por la razón correcta**. El criterio no es «falla»: son **cuatro
datos** que se copian al reporte junto a la salida real del comando nativo (sin editar, sin
resumir).

1. **Compila y enlaza**: sin warnings, sin errores de compilación y sin errores de enlace.
2. **N casos o escenarios cubiertos y K tests ejecutados**, con el mapa de cobertura por
   operación/variante. El framework puede contar tests, filas o aserciones de forma distinta:
   explica la correspondencia sin inventar igualdad de contadores. Ejecutar **cero tests**
   no es fase roja.
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
| Arranca pero ejecuta **0 casos** | **Del 4c**, tuyo | Conecta los grupos de la suite al runner existente y repite; si falta el runner mínimo, reporta el defecto de 4a |

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
- Cada caso se prueba contra su operación y las variantes del mismo contrato que
  correspondan. El mapa de cobertura conserva todos los casos y pasos aplicables.
- Los casos que el lenguaje no pueda representar se sustituyen por su equivalencia declarada o
  se omiten justificándolo en una línea; el resto se conserva íntegro.
- La suite tiene que **poder fallar**: si al romper a propósito una comparación del código bajo
  prueba no falla nada, no estás probando lo que crees (paso 6).

### Caso nulo

- **Si la especificación exige un caso nulo y el tipo lo admite** → verifica el
  indicador de fallo del contrato. No añadas el caso por costumbre ni introduzcas
  excepciones o envoltorios que la fase no permita.
- **Si el tipo no admite nulos** → omite el caso y documenta en una línea por qué.

### Patrón obligatorio

1. **Fixtures nombrados**: uno por cada entrada y cada salida esperada, con nombres que digan
   qué caso son. En este repositorio suelen seguir la forma `standardInput`/`standardOutput`, y
   en `snake_case` allá donde el lenguaje lo pida: **copia la forma del módulo homologado**.
2. **Ejecución compartida cuando los casos tengan la misma forma**, con el nombre
   del caso en el mensaje. Para escenarios de estado, conserva su secuencia de
   operaciones y aserciones; no fuerces un helper de secuencias sobre ADT distintos.
3. **Grupos identificables por contrato, operación o escenario**, con las variantes
   pertinentes. Un grupo lógico no exige un archivo o una suite aparte.
4. **Mensajes de aserción** que digan qué se esperaba y en qué caso, con el formato y el idioma
   que ya use el módulo (`"<sujeto> should <comportamiento esperado>"` en esta casa: revisa
   las bases en el orden compartido).
5. **Aislamiento**: si la operación muta su entrada *in-place*, cada caso debe operar sobre una
   copia del fixture; nunca sobre el compartido.

**Alternativas por paradigma** (elige según el lenguaje, las bases y el tema):

| Situación | Patrón |
|-----------|--------|
| El lenguaje tiene referencias a función, *closures* o genéricos | Un **helper compartido** que recibe la función a probar y el nombre del caso o del sujeto |
| No las tiene (COBOL, Forth, Tcl, Rexx…), o el idioma del repo no las usa | Un **bucle sobre una tabla de pares** (entrada, esperada) dentro de cada test, con el nombre del caso en el mensaje |
| El framework ya es *data-driven* (`go test` con subtests, `@ParameterizedTest` de JUnit, `pytest.mark.parametrize`…) | La tabla del propio framework, con un nombre de caso por fila |
| El caso describe operaciones sucesivas sobre un ADT | Un test de escenario con estado propio y aserciones identificables por paso, en el grupo o suite pertinente |

Lo que **no** vale como patrón: duplicar mecánicamente casos equivalentes sin aprovechar
el framework, o un test agregado que no permita identificar qué caso o paso falló.

### Convenciones idiomáticas

| Aspecto | Regla |
|---------|-------|
| Framework | El homologado del lenguaje según las bases en el orden compartido |
| Tipo de secuencia | El del módulo homologado: `Vec<T>` y *slices*, `List<Integer>`, listas inmutables, tablas, `vector`, *arrays* nativos… |
| Naming | Convención del lenguaje (`snake_case`, `camelCase`, `PascalCase`, `kebab-case`) |
| Aserciones | Las del framework (`assertEqual`, `is`, `Assert`, `expect`, …) |
| Dependencias | Las estándar o ya autorizadas para el módulo según las bases y la guía de inicialización; una base no autoriza dependencias nuevas por sí sola |
| Runner | El comando de la columna 3 del catálogo debe recoger todos los grupos y propagar fallos. El 4a deja el runner mínimo; este paso lo conecta a los grupos sin crear ni sustituir infraestructura |
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
- [ ] Mapa de casos por operación/contrato y variantes aplicables, con agrupación y runner justificados.
- [ ] Caso nulo exigido por la especificación incluido, o imposibilidad de representarlo justificada.
- [ ] Cada adaptación de tipo y cada caso omitido, declarados con su motivo.
- [ ] *Fixtures* nombrados, patrón de ejecución compartido y aislamiento verificado.
- [ ] Comando nativo de pruebas ejecutado con salida real y sin warnings.
- [ ] Contra-verificación hecha y revertida, o trasladada explícitamente al paso 6 por faltar implementación.
- [ ] Sin cambios en el esqueleto, el `.gitignore`, el contrato, `src/`, la especificación, el roadmap ni los READMEs.

---

## Formato de salida

- **Si se alcanza la fase roja:** archivos creados; mapa breve de agrupación con
  referencias; casos/escenarios cubiertos y tests ejecutados; adaptaciones u
  omisiones justificadas; comando y salida real con los cuatro datos del paso 5.
  La contra-verificación pendiente se declara, no se da por hecha.
- **Si hay un bloqueo:** indica el archivo y la línea, la causa concreta y la mitigación
  propuesta, y **detente**. No apliques la mitigación sin autorización.
- Prohibido: ensayos, documentación nueva y rediseños fuera del alcance; la
  justificación breve del agrupamiento y la evidencia sí son obligatorias.
