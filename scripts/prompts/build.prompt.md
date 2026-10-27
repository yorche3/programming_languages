---
name: build
step: 4d
model: gpt-6.1-sol
description: Repara un bloqueo de construcción no previsto después de la suite, sin regenerar la suite
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

Lee `scripts/prompts/Delegation_Policy.md` (incluida al armar el encargo):
fija las bases por prioridad y la agrupación por tema e idioma para este rol.

---

## Fuentes de verdad (en este orden de prioridad)

1. **El esqueleto del módulo** — lo que dejaron `glot new` y `glot scaffold` (pasos 4 y 4a): qué
   ficheros de construcción hay, si son plantilla vacía o funcionales, y dónde vive el runner.
   Es el **punto de partida**: aquí se **completa**, no se rehace.
2. **`{spec}`** — su sección **«Casos de prueba / Test Cases»** dice qué tiene que poder ejecutar
   la suite; el *cómo* lo manda el lenguaje.
3. **Bases homologadas del mismo lenguaje**, en el orden de la política compartida.
   Orientan el fichero de construcción, sus reglas, rutas de salida y `.gitignore`.
   Enlaza todos los grupos reales del módulo; no copies el contenido de las bases.
4. **`scripts/data/init_sequences.tsv`** — lo que el catálogo ya declara para `{lang}` en la fase
   `scaffold`: si el comando que crea el fichero está ahí, tu trabajo es **adecuarlo**, no crearlo
   otra vez. Si el catálogo puede dejar el fichero hecho con un comando, dilo en tu informe para
   que se corrija el dato.
5. **`scripts/data/languages.tsv`** — comando nativo de pruebas de `{lang}` (columna 3): es el que
   tiene que quedar funcionando.
6. **`AGENTS.md`** — límites de actuación y flujo de cierre.

**Resolución de conflictos:** el lenguaje manda en la forma del fichero (herramienta, convención y
rutas); `{spec}` manda en lo que hay que poder ejecutar. Si el comando nativo ya compila, enlaza y ejecuta los casos, dilo explícitamente como
**«paso 4d no necesario»** y **no toques nada**. Una carencia conocida del esqueleto (por
ejemplo, un `Makefile` que los módulos homologados ya usan) pertenece a 4a y debe quedar
resuelta por `glot scaffold`, no aplazarse a este paso.

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git branch --show-current` **en el submódulo del lenguaje** (el directorio
  donde ya estás). El monorepo y sus cincuenta submódulos **no se recorren**: `git submodule
  status` en la raíz solo añade ruido a un trabajo que es de un lenguaje y un módulo.
- Inspecciona el esqueleto, las dos bases en el orden compartido, los grupos y el runner
  del paso 4c y el comando nativo de pruebas de `{lang}`.
- Comprueba el estado real antes de tocar nada: `glot test`. Este paso **no es fijo**: solo se
  usa cuando el **4c** encontró un fallo de construcción no previsto. Los artefactos de suite
  que 4c ya escribió se conservan; este paso no pide repetir la delegación `suite`.
- Si `glot test` compila y enlaza, ejecuta los casos y falla **por aserciones**, informa
  **«paso 4d no necesario»** y cierra sin cambios.
- Anota **qué** impide ejecutar la suite y **por qué**: fichero ausente, plantilla vacía, regla que
  no alcanza a `test/`, enlace roto, ruta de salida mal declarada.

### 2. El fichero que compila y enlaza

- Escribe o adecúa **el fichero de construcción del lenguaje** (el que usa su toolchain: manifiesto,
  `Makefile`, proyecto, script de compilación) con las reglas que compilan la fuente del módulo,
  compilan la suite y **enlazan ambas**.
- Enlaza el runner preparado en 4a y conectado a los grupos por 4c, sin reescribirlo. Si
  el runner falta o no agrega los grupos, reporta el defecto del paso responsable; no lo
  sustituyas desde 4d. Si la construcción genera el runner, ajusta solo su configuración.
- Si la suite necesita una **dependencia de pruebas** (framework, aserción, ejecutor), declárala en el
  fichero que corresponda a ese lenguaje, con la misma forma que el módulo homologado.
- No escribas la suite, no escribas la implementación y no cambies el contrato: si el problema está
  en ellos, **detente y avísalo** (el remedio es el paso `correct`, 4e).

### 3. Comprobación (salida real)

- Ejecuta `glot test` sobre la suite ya escrita y enseña su **salida real** y su código con los
  **cuatro datos** de la fase roja: compila y enlaza sin warnings; **N casos ejecutados**, con N > 0 y los de la suite; **M
  fallos, todos de aserción** —cero excepciones de ejecución, cero errores de construcción—; y la
  lista de casos que siguen pasando por coincidir con el centinela. Un fallo de aserción es el
  resultado correcto en este punto; un error de compilación, de enlace o una excepción de ejecución
  **no** lo es.
- Si el lenguaje tiene verificador, ejecuta `glot verify` y deja también su salida.
- Si el comando nativo de `languages.tsv` (columna 3) no es el que arranca la suite, **detente y
  avísalo** con el comando correcto: el dato lo corrige el autor.

### 4. Informe

- Qué ficheros creaste o adecuaste y **por qué** eran necesarios.
- Salida real de `glot test` (y `glot verify`) y su código.
- Si la suite ya estaba en fase roja, confirma **«paso 4d no necesario»** y que no hubo cambios.
- Lo que **no** hiciste y por qué (si el arreglo pertenece a otro paso).

---

## Límites

- **No** escribes la suite (paso 4c), **no** implementas el algoritmo (paso 5) y **no** cambias el
  contrato (paso 4b).
- **No** haces `git commit` ni `git push`: de eso se encarga el autor.
- **No** tocas el catálogo `scripts/data/`: lo que haya que corregir ahí, se **reporta**.
- Tras corregir construcción, vuelve a ejecutar `glot test` con los mismos archivos de suite.
  No vuelvas a generar la suite ni reviertas sus cambios.
