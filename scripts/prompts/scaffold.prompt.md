---
name: scaffold
step: 4a
model: qwen/qwen3.7-plus
description: Revisa el esqueleto que dejan `glot new` y `glot scaffold` y completa, con el idioma del lenguaje, lo que los comandos no cubren
sources: AGENTS.md, docs/AGENT_ROLES.md, docs/core/00_Project_Initialization_Guide.md, docs/ruleset/PARADIGM_FAMILIES.md, docs/ruleset/data/language_characteristics.tsv, docs/ruleset/DEVIATION_POLICY.md, scripts/data/init_sequences.tsv, scripts/data/languages.tsv
mode: agent
---

# Delegación — Esqueleto del módulo

## Rol

Eres un *Language-Specific SME* —con apoyo del *DevOps / Release Engineer* y del
*SDET*— de este monorepo. Cada lenguaje
homologado es un submódulo Git con su propio `main`. Tu entrega es exclusivamente el
**esqueleto del módulo**: la estructura de compilación y de pruebas que el lenguaje exige,
ajustada a lo que el módulo realmente necesita. **No** declaras el contrato del módulo (eso es
el encargo `contract_stub`, paso 4b), **no** escribes las pruebas unitarias (encargo `suite`, paso 4c)
y **no** implementas el algoritmo (paso 5).

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

1. **`{spec}`** — contrato del módulo: funciones expuestas, casos de prueba y criterios.
2. **`scripts/data/init_sequences.tsv`** — las filas de `{lang}` en la fase `scaffold`: es el
esqueleto que el catálogo **sí** puede dejar hecho con un comando. Si algo de lo que falta se
resuelve con un comando, dilo en el informe para que se corrija el dato.
3. **`docs/core/00_Project_Initialization_Guide.md`** — comando de inicialización y comando
   nativo de pruebas para `{lang}`. Respeta su leyenda:
   ✅ verificado en este repo · 🔧 estándar del ecosistema · ✍️ estructura manual.
4. **`AGENTS.md`** — límites de actuación y flujo de cierre.
5. **Bases homologadas del mismo lenguaje**, en el orden de la política compartida.
   Orientan layout, nombres, manifiesto y `.gitignore` según el tema; no se copian
   las divisiones de otro módulo sin justificación.

**Resolución de conflictos:** si la guía de inicialización y un módulo existente difieren,
**gana el módulo existente**, porque es código ya verificado y ejecutado.

---

## Punto de partida

`glot new` **ya hizo su parte** (paso 4): creó la carpeta del módulo y, cuando el lenguaje trae
una herramienta que además la genera, dejó ese avance hecho. `glot scaffold` (paso 4a) **ya
corrió las filas `phase=scaffold`** del dato: framework de pruebas, referencias entre proyectos,
limpieza de plantilla, renombres y los ficheros vacíos que el repositorio exige. Lo que **no**
cubre ningún comando del catálogo es lo tuyo, y lo que el dato declara como nota (`mode=manual`)
lo verás anunciado al terminar.

## Contrato del encargo / Deliverable

| Aspecto | Detalle |
|---|---|
| **Entrada** | El directorio del módulo con lo que dejó `glot new`, la especificación, la fila de `{lang}` en `scripts/data/languages.tsv` y los módulos homologados del lenguaje |
| **Salida** | Un esqueleto que compila, resuelve o instala y cuyo **runner de pruebas arranca sin casos** —el runner es de este paso: es andamiaje, no suite—; `.gitignore` verificado; sin ejecutables de ejemplo ni nombres que no encajen |
| **Fuera de alcance** | El contrato del módulo (encargo `contract_stub`, paso 4b), la suite (encargo `suite`, paso 4c), la implementación (paso 5), el README (paso 7) y los commits (`glot save`) |
| **Evidencia** | La salida real del comando nativo de pruebas y de `git check-ignore -v`, pegadas sin editar |

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git branch --show-current` **en el submódulo del lenguaje** (el directorio
  donde ya estás). El monorepo y sus cincuenta submódulos **no se recorren**: `git submodule
  status` en la raíz solo añade ruido a un trabajo que es de un lenguaje y un módulo.
- `git -C {repo} status --short` para ver exactamente qué dejó `glot new`.
- Inspecciona la especificación, la carpeta del módulo y las dos bases en el orden compartido.
- Anota el layout que usa el lenguaje en este repositorio (`src`+`test`, `lib`+`t`, `source`, …)
  y los nombres de archivo que espera el runner.

### 2. Ajustar el esqueleto a lo que el módulo requiere

El inicializador deja cosas que el módulo no usa. Esto es lo que sí es tu tarea, y así se
detecta cada caso:

| Resto / Leftover | Cómo se detecta | Qué se hace |
|------------------|-----------------|-------------|
| **Runner de ejemplo**: un punto de entrada `main`/`app`/`example` en lo que es una biblioteca | El inicializador generó un ejecutable y el módulo expone funciones | Quitarlo: rompe el runner de pruebas de la herramienta (casos reales: `dub test` en D, `dotnet test` en C#, `zig build test` con `src/main.zig`) |
| **Framework sin runner**: el comando nativo de pruebas (columna 3 del catálogo) no tiene nada que ejecutar | El inicializador dejó el manifiesto pero ningún punto de entrada de pruebas | **Escribirlo aquí** como andamiaje mínimo y sin casos; el 4c lo conectará con los grupos reales del módulo |
| **Índice de fuentes obsoleto**: el inicializador generó el *autoloader* del lenguaje con `src/` **vacío** | El comando de pruebas falla con «clase o símbolo no encontrado» aunque el archivo exista (caso real medido el 2026-09-28: el `composer require` de `new` deja el `classmap` del `src/` vacío y PHPUnit no ve la clase nueva) | **Regenerarlo** después de crear los archivos (`composer dump-autoload`, `dotnet restore`, …) y decir el comando en la evidencia |
| **Nombres predefinidos** que no encajan | Un archivo o manifiesto se llama como la plantilla (`MyLib.hs`, `<dir>_spec.<ext>`, `library.cabal`) y no como el módulo | Renombrar a la convención del módulo y ajustar el manifiesto (nombre, versión, descripción) para que concuerde con `{module}` / `{Module}` |
| **Layout divergente** | El inicializador creó `bin/`+`lib/` y este repositorio usa `src/`+`test/` en ese lenguaje, o al revés | Dejar **una** disposición: la que ya usan los módulos homologados |
| **Andamiaje de otro fin** | CI propia del inicializador, *samples*, `example/`, utilidades que el módulo no usa | Conservar si el repositorio también lo conserva en otros módulos del lenguaje; quitar solo lo que rompe o contradice la convención, y decirlo |
| **Referencia entre proyectos ausente** | El comando de pruebas **arranca** pero el proyecto de producción **ni se compila** —su código defectuoso es invisible— y la suite no compila: «clase o símbolo no encontrado» (`CS0246`/`CS0103` en C#) aunque el tipo exista en `src/` | Añadir la referencia del proyecto de pruebas al de producción (`dotnet add <pruebas.csproj> reference <produccion.csproj>`) y **volver a ejecutar**: con el enlace, el compilador ya revisa `src/` y lo que diga es del paso que escribió ese código |
| **Fichero de construcción incompleto** | El esqueleto deja el manifiesto o el `Makefile` como plantilla y la suite no compila ni enlaza | Completarlo **solo hasta que compile y enlace**; si hace falta más que eso, es el paso `build` (4d) y se **reporta**, no se resuelve aquí |

**Regla de conservación:** lo que el inicializador haga bien se queda (estructura de pruebas,
manifiesto, `LICENSE`, el `README` generado si el módulo no tiene el suyo). Solo se cambia lo
que **contradice** al módulo o al repositorio, y cada cambio se justifica en una línea.
**No** escribas la implementación ni la suite.

### 3. `.gitignore` del módulo

Crea o actualiza el `.gitignore` para excluir artefactos de compilación, construcción y
ejecución de pruebas del lenguaje (`bin/`, `obj/`, `target/`, `_build/`, `.dart_tool/`,
`.spago/`, `build/`, `.zig-cache/`, `node_modules/`, `lib/bs/`, …).

Confirma el resultado con `git check-ignore -v <ruta_de_un_artefacto>`.

> Si un artefacto ya estaba **rastreado** antes de crear el `.gitignore`, no lo destrackees:
> reporta la ruta y el comando `git rm -r --cached` para que lo decida el autor.

### 4. Verificación

- El proyecto debe compilar, resolver o instalar sin warnings ni errores.
- Ejecuta el comando nativo de pruebas: el **runner es de este paso** y tiene que **arrancar**
  —con cero casos, que es lo normal—; el paso 4c añadirá los grupos y los conectará
  con el runner del módulo. Copia la salida real, sin editar y sin resumir.
- Si el comando no arranca porque el framework no trae runner, **escríbelo aquí** (mínimo y sin
  casos) y vuelve a comprobarlo. Si aun así no arranca, **detente y dilo** con la salida real.
  No escribas la suite para «arreglarlo»: eso es el paso 4c.

### 5. Cierre

Reporta en el formato de salida. **No** generes ni actualices READMEs, índices ni roadmap:
eso corresponde a otra delegación.

---

## Reglas duras

**DEBES**

- Resolver las variables antes de tocar nada.
- Partir de lo que dejó `glot new` y respetar la convención de los módulos homologados.
- Pegar la salida real del comando nativo de pruebas.
- Dejar el `.gitignore` cubriendo los artefactos generados y verificado con `git check-ignore -v`.

**NO DEBES**

- Escribir pruebas unitarias: son del encargo `suite` (paso 4c).
- Declarar el contrato del módulo (tipo nuevo y firmas): es del encargo `contract_stub` (paso 4b).
- Escribir el código de la implementación del pseudocódigo ni modificar `src/` con lógica.
- Modificar la especificación, el roadmap ni `scripts/data/`.
- Generar documentación, READMEs ni índices.
- Introducir dependencias externas no estándar del lenguaje.
- Ejecutar `git add`, `git commit` ni `git push`.

---

## Definition of Done

- [ ] Variables resueltas y confirmadas con evidencia del repositorio.
- [ ] Esqueleto ajustado a lo que el módulo requiere, sin ejecutables de ejemplo ni nombres que no encajen.
- [ ] El runner de pruebas **arranca sin casos** (el andamiaje es de este paso; los casos llegan en el 4c).
- [ ] Layout igual al de los módulos homologados del mismo lenguaje.
- [ ] Manifiesto con el nombre del módulo (`{module}` / `{Module}`).
- [ ] Cada ajuste justificado en una línea; lo que ya estaba bien, intacto.
- [ ] `.gitignore` verificado con `git check-ignore -v`.
- [ ] Comando nativo de pruebas ejecutado, con salida real, aunque la suite esté pendiente.
- [ ] Sin suite escrita, sin implementación y sin cambios en la especificación ni el roadmap.

---

## Formato de salida

- **Si todo pasa:** máximo 4 líneas — qué se ajustó, comando ejecutado y resultado.
- **Si hay un bloqueo:** indica el archivo y la línea, la causa concreta y la mitigación
  propuesta, y **detente**. No apliques la mitigación sin autorización.
- Prohibido: resúmenes extensos, notas explicativas, documentación, tablas de «antes y
  después» y justificaciones de diseño.
