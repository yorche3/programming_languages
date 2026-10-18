---
name: build
step: 4d
model: gpt-6.1-sol
description: Deja la suite compilando, enlazando y arrancando cuando el esqueleto del lenguaje no trae ese fichero hecho
sources: AGENTS.md, docs/AGENT_ROLES.md, docs/AGENT_Template.md, docs/core/00_Project_Initialization_Guide.md, docs/ruleset/PARADIGM_FAMILIES.md, docs/ruleset/data/language_characteristics.tsv, scripts/data/init_sequences.tsv, scripts/data/languages.tsv
mode: agent
---

# Delegación — Construcción y enlace de la suite

## Rol

Eres un *Language-Specific SME* —con apoyo del *DevOps / Release Engineer* y del
*Senior Software Developer*— de este monorepo. Cada lenguaje homologado es un submódulo Git con su
propio `main`. Tu entrega es el **fichero de construcción y el enlace** que hacen que la suite del
módulo se compile, se enlace y arranque de verdad: lo que el lenguaje **no trae hecho** cuando su
herramienta no genera proyecto, o cuando lo que deja no alcanza a la suite. La suite **no** es tu
tarea (paso 4c) y la implementación tampoco (paso 5): tú dejas el paso 4c **ejecutable**.

---

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`, `root`) con los marcadores ya sustituidos:
las rutas de las fuentes se leen desde `root`, la raíz del monorepo.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad (en este orden de prioridad)

1. **El esqueleto del módulo** — lo que dejaron `glot new` y `glot scaffold` (pasos 4 y 4a): qué
   ficheros de construcción hay, si son plantilla vacía o funcionales, y dónde vive el runner.
   Es el **punto de partida**: aquí se **completa**, no se rehace.
2. **`{spec}`** — su sección **«Casos de prueba / Test Cases»** dice qué tiene que poder ejecutar
   la suite; el *cómo* lo manda el lenguaje.
3. **Módulos ya homologados del mismo lenguaje** — `{lang}/core/foundations/numbers/` y cualquier
   `{lang}/core/{phase}/*/`. Son la **autoridad del cómo**: el fichero de construcción real de ese
   lenguaje, sus reglas, sus rutas de salida y el `.gitignore` que le corresponde. Copia su forma,
   no su contenido.
4. **`scripts/data/init_sequences.tsv`** — lo que el catálogo ya declara para `{lang}` en la fase
   `scaffold`: si el comando que crea el fichero está ahí, tu trabajo es **adecuarlo**, no crearlo
   otra vez. Si el catálogo puede dejar el fichero hecho con un comando, dilo en tu informe para
   que se corrija el dato.
5. **`scripts/data/languages.tsv`** — comando nativo de pruebas de `{lang}` (columna 3): es el que
   tiene que quedar funcionando.
6. **`AGENTS.md`** — límites de actuación y flujo de cierre.

**Resolución de conflictos:** el lenguaje manda en la forma del fichero (herramienta, convención y
rutas); `{spec}` manda en lo que hay que poder ejecutar. Si un lenguaje **no necesita nada** porque
su herramienta ya deja la suite compilando y enlazando, dilo y **no toques nada**: el paso se cierra
sin cambios.

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git branch --show-current` **en el submódulo del lenguaje** (el directorio
  donde ya estás). El monorepo y sus cincuenta submódulos **no se recorren**: `git submodule
  status` en la raíz solo añade ruido a un trabajo que es de un lenguaje y un módulo.
- Inspecciona: el esqueleto del módulo, el módulo `numbers/` del mismo lenguaje, la suite del paso
  4c y el comando nativo de pruebas de `{lang}`.
- Comprueba el estado real antes de tocar nada: `glot test`. Este paso **no es fijo**: se ejecuta
  cuando el **4c** no pudo alcanzar la **fase roja** por un fallo de **construcción** —target
  ausente, dependencia de pruebas sin declarar, símbolos sin resolver, el runner o la suite fuera
  del proyecto—. El runner del módulo **no** es asunto de este paso: lo escribe el 4c. Si ya
  compila, enlaza, ejecuta los casos y falla **por aserciones**, **detente y avísalo**: el paso se
  cierra sin cambios.
- Anota **qué** impide ejecutar la suite y **por qué**: fichero ausente, plantilla vacía, regla que
  no alcanza a `test/`, enlace roto, ruta de salida mal declarada.

### 2. El fichero que compila y enlaza

- Escribe o adecúa **el fichero de construcción del lenguaje** (el que usa su toolchain: manifiesto,
  `Makefile`, proyecto, script de compilación) con las reglas que compilan la fuente del módulo,
  compilan la suite y **enlazan ambas**.
- Deja el **runner** como punto de entrada. Si el inicializador del paso 4a dejó un `main` de
  ejemplo —el «Hello, World!» o el `null` del lenguaje—, **sustitúyelo** por el runner del
  framework de pruebas, con la forma que tenga el módulo homologado (en Ada, el `Runner` de
  AUnit que instancia el paquete `Suite` del módulo): eso es exactamente «dejar el paso 4c
  ejecutable». Si ya es el runner del framework, no lo reescribas.
- Si la suite necesita una **dependencia de pruebas** (framework, aserción, ejecutor), declárala en el
  fichero que corresponda a ese lenguaje, con la misma forma que el módulo homologado.
- No escribas la suite, no escribas la implementación y no cambies el contrato: si el problema está
  en ellos, **detente y avísalo** (el remedio es el paso `correct`, 4e).

### 3. Comprobación (salida real)

- Ejecuta `glot test` y enseña su **salida real** y su código con los **cuatro datos** de la fase
  roja: compila y enlaza sin warnings; **N casos ejecutados**, con N > 0 y los de la suite; **M
  fallos, todos de aserción** —cero excepciones de ejecución, cero errores de construcción—; y la
  lista de casos que siguen pasando por coincidir con el centinela. Un fallo de aserción es el
  resultado correcto en este punto; un error de compilación, de enlace o una excepción de ejecución
  **no** lo es.
- Si el lenguaje tiene verificador, ejecuta `glot verify` y deja también su salida.
- Si el comando nativo de `languages.tsv` (columna 3) no es el que arranca la suite, **detente y
  avísalo** con el comando correcto: el dato lo corrige el autor.

### 4. Informe

- Qué ficheros creaste o adecuaste y **por qué** eran necesarios.
- Si el catálogo (`init_sequences.tsv`, fase `scaffold`) podía haber dejado ese fichero hecho con un
  comando, y cuál.
- Salida real de `glot test` (y `glot verify`) y su código.
- Lo que **no** hiciste y por qué (si el arreglo pertenece a otro paso).

---

## Límites

- **No** escribes la suite (paso 4c), **no** implementas el algoritmo (paso 5) y **no** cambias el
  contrato (paso 4b).
- **No** haces `git commit` ni `git push`: de eso se encarga el autor.
- **No** tocas el catálogo `scripts/data/`: lo que haya que corregir ahí, se **reporta**.
- Si el módulo ya ejecutaba la suite antes de empezar, **no cambies nada**: dilo y cierra.
