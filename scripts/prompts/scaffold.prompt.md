---
name: scaffold
step: 4a
description: Ajusta el esqueleto del módulo a lo que exige el lenguaje y el módulo, sin escribir la suite
mode: agent
---

# Delegación — Esqueleto del módulo

## Rol

Eres un ingeniero de software senior del monorepo `yorche3/programming_languages`. Cada lenguaje
homologado es un submódulo Git con su propio `main`. Tu entrega es exclusivamente el
**esqueleto del módulo**: la estructura de compilación y de pruebas que el lenguaje exige,
ajustada a lo que el módulo realmente necesita. **No** escribes las pruebas unitarias (eso es
el encargo `suite`, paso 4b) y **no** implementas el algoritmo (paso 5).

---

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`) con los marcadores ya sustituidos.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad (en este orden de prioridad)

1. **`{spec}`** — contrato del módulo: funciones expuestas, casos de prueba y criterios.
2. **`scripts/data/languages.tsv`** — para `{lang}`: tipo de inicialización (`tool`, `manual`,
   `deferred`), comando de inicialización y normalización ya aplicada por `glot new`.
3. **`docs/core/00_Project_Initialization_Guide.md`** — comando de inicialización y comando
   nativo de pruebas para `{lang}`. Respeta su leyenda:
   ✅ verificado en este repo · 🔧 estándar del ecosistema · ✍️ estructura manual.
4. **`AGENTS.md`** — límites de actuación y flujo de cierre.
5. **Módulos ya homologados del mismo lenguaje** — `{lang}/core/foundations/numbers/` y
   cualquier `{lang}/core/{phase}/*/`. Definen la convención real: layout, nombres de archivo,
   manifiesto y `.gitignore`.

**Resolución de conflictos:** si la guía de inicialización y un módulo existente difieren,
**gana el módulo existente**, porque es código ya verificado y ejecutado.

---

## Punto de partida

`glot new` **ya hizo la parte mecánica**: con `tool` ejecutó el inicializador y normalizó el
resultado (aplanó el nido, quitó el `.git` anidado, descartó el vendoring que el repositorio
rechaza); con `manual` creó las carpetas del esqueleto. Los lenguajes marcados `deferred` no
tienen inicializador validado: ahí el esqueleto lo construyes tú.

## Contrato del encargo / Deliverable

| Aspecto | Detalle |
|---|---|
| **Entrada** | El directorio del módulo con lo que dejó `glot new`, la especificación, la fila de `{lang}` en `scripts/data/languages.tsv` y los módulos homologados del lenguaje |
| **Salida** | Un esqueleto que compila, resuelve o instala, y cuyo runner de pruebas **arranca**; `.gitignore` verificado; sin runners de ejemplo ni nombres que no encajen |
| **Fuera de alcance** | La suite (encargo `suite`, paso 4b), la implementación (paso 5), el README (paso 7) y los commits (`glot save`) |
| **Evidencia** | La salida real del comando nativo de pruebas y de `git check-ignore -v`, pegadas sin editar |

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git submodule status` en la raíz del monorepo.
- `git -C {repo} status --short` para ver exactamente qué dejó `glot new`.
- Inspecciona: la especificación, la carpeta del módulo y el módulo `numbers/` del mismo lenguaje.
- Anota el layout que usa el lenguaje en este repositorio (`src`+`test`, `lib`+`t`, `source`, …)
  y los nombres de archivo que espera el runner.

### 2. Ajustar el esqueleto a lo que el módulo requiere

El inicializador deja cosas que el módulo no usa. Esto es lo que sí es tu tarea, y así se
detecta cada caso:

| Resto / Leftover | Cómo se detecta | Qué se hace |
|------------------|-----------------|-------------|
| **Runner de ejemplo**: un punto de entrada `main`/`app`/`example` en lo que es una biblioteca | El inicializador generó un ejecutable y el módulo expone funciones | Quitarlo: rompe el runner de pruebas de la herramienta (casos reales: `dub test` en D, `dotnet test` en C#, `zig build test` con `src/main.zig`) |
| **Nombres predefinidos** que no encajan | Un archivo o manifiesto se llama como la plantilla (`MyLib.hs`, `<dir>_spec.<ext>`, `library.cabal`) y no como el módulo | Renombrar a la convención del módulo y ajustar el manifiesto (nombre, versión, descripción) para que concuerde con `{module}` / `{Module}` |
| **Layout divergente** | El inicializador creó `bin/`+`lib/` y este repositorio usa `src/`+`test/` en ese lenguaje, o al revés | Dejar **una** disposición: la que ya usan los módulos homologados |
| **Andamiaje de otro fin** | CI propia del inicializador, *samples*, `example/`, utilidades que el módulo no usa | Conservar si el repositorio también lo conserva en otros módulos del lenguaje; quitar solo lo que rompe o contradice la convención, y decirlo |
| **Lenguaje `deferred`** | La columna 6 del catálogo dice `deferred` y `glot new` imprimió `skipped` | Construir el esqueleto completo (`mkdir -p` + manifiesto) según la guía y los módulos existentes |

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
- Ejecuta el comando nativo de pruebas: debe poder **arrancar** aunque todavía no haya casos
  (la suite llega en el paso 4b). Copia la salida real, sin editar y sin resumir.
- Si el runner no arranca por falta de la suite, dilo con la salida real y sigue: no escribas
  la suite para «arreglarlo».

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

- Escribir pruebas unitarias: son del encargo `suite` (paso 4b).
- Escribir el código de la implementación del pseudocódigo ni modificar `src/` con lógica.
- Modificar la especificación, el roadmap ni `scripts/data/`.
- Generar documentación, READMEs ni índices.
- Introducir dependencias externas no estándar del lenguaje.
- Ejecutar `git add`, `git commit` ni `git push`.

---

## Definition of Done

- [ ] Variables resueltas y confirmadas con evidencia del repositorio.
- [ ] Esqueleto ajustado a lo que el módulo requiere, sin runners de ejemplo ni nombres que no encajen.
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
