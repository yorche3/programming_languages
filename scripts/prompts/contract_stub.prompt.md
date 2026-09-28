---
name: contract_stub
step: 4b
model: gpt-5.6-terra
description: Declara el contrato del módulo (tipo nuevo, firmas e indicador natural) y los esqueletos de todas sus operaciones, para que la suite compile y enlace
sources: AGENTS.md, docs/AGENT_Template.md, docs/core/00_Project_Initialization_Guide.md, scripts/data/languages.tsv
mode: agent
---

# Delegación — Contrato y esqueletos del módulo

## Rol

Eres un ingeniero de software senior de este monorepo. Cada lenguaje
homologado es un submódulo Git con su propio `main`. Tu entrega son dos cosas que van juntas:
el **contrato del módulo** —el tipo nuevo del dominio y las firmas que expone la
especificación— y los **esqueletos** de todas esas operaciones: el cuerpo declarado que
**compila y enlaza** sin el algoritmo, para que la suite del paso `4c` pueda construirse antes
de que exista la implementación (paso 5). Es el **primer contenido** del módulo y va **antes**
de la suite, porque sin él la suite no compila. **No** escribes las pruebas unitarias (eso es
el encargo `suite`, paso 4c) y **no** implementas el algoritmo (paso 5).

---

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`, `root`) con los marcadores ya sustituidos:
las rutas de las fuentes se leen desde `root`, la raíz del monorepo.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad (en este orden de prioridad)

1. **`{spec}`** — contrato funcional del módulo: funciones expuestas, casos de prueba y
   criterios. Manda sobre **qué** se expone.
2. **Módulos ya homologados del mismo lenguaje** — `{lang}/core/foundations/numbers/` y
   cualquier `{lang}/core/{phase}/*/`. Son la **autoridad del cómo**: nombre y ubicación del
   tipo, convención de firmas, mayúsculas del identificador, si el contrato vive en un archivo
   aparte (en Ada `src/*.ads`), en una cabecera (en C `include/*.h`) o dentro del propio módulo.
3. **`docs/AGENT_Template.md`** — reglas de la adaptación: el contrato se declara con el
   **indicador natural** del lenguaje (`null`, `nil`, `None`, `#f`, `-1`, `nothing`), sin
   envoltorios de error y sin atajos de biblioteca.
4. **`scripts/data/languages.tsv`** y **`docs/core/00_Project_Initialization_Guide.md`** — para
   `{lang}`: layout, ubicación del código y comando nativo de compilación y de pruebas.
5. **`AGENTS.md`** — límites de actuación y flujo de cierre.

**Resolución de conflictos:** el *qué* (funciones, casos y valores) lo manda la especificación;
el *cómo* (tipo, nombres, ubicación) lo manda el módulo homologado del lenguaje.

---

## Punto de partida

`glot new` dejó la estructura (secuencia del dato
[`scripts/data/init_sequences.tsv`](../data/init_sequences.tsv): pasos, directorio de trabajo y
completado) y el encargo `scaffold` (paso 4a) la ajustó: el proyecto compila y su runner de
pruebas arranca, pero **todavía no hay nada del módulo**. El contrato y sus esqueletos son lo
primero que se escribe.

---

## Contrato del encargo / Deliverable

| Aspecto | Detalle |
|---|---|
| **Entrada** | El esqueleto ya ajustado, la especificación, los módulos homologados del lenguaje y las reglas de adaptación |
| **Salida** | El contrato declarado —tipo nuevo del dominio, firmas de las funciones expuestas e indicador natural de fallo— **y el esqueleto de cada operación**, con la forma y la ubicación que el lenguaje exige, de modo que el módulo **compile y enlace** sin la suite y sin la implementación |
| **Fuera de alcance** | La suite (encargo `suite`, paso 4c), el algoritmo (paso 5), el README (paso 7) y los commits (`glot save`) |
| **Evidencia** | La salida real de la compilación **y del enlace** del contrato con sus esqueletos, pegada sin editar |

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git submodule status` en la raíz del monorepo.
- `git -C {repo} status --short` para ver qué dejó `glot new` y qué ajustó `scaffold`.
- Inspecciona: la especificación, el contrato del módulo `numbers/` del mismo lenguaje y
  cualquier `{lang}/core/{phase}/*/` que exponga un tipo propio.
- Anota y di en el reporte: **dónde vive el contrato** en este lenguaje, **cómo se llama** el
  tipo nuevo, **cómo se escriben** las firmas, **cuál es** el indicador natural de fallo y
  **dónde vive el cuerpo** de las operaciones (archivo aparte, mismo archivo, etc.).

### 2. Declarar el tipo y las firmas (aquí no se inventa nada)

| Decisión | De dónde sale |
|----------|---------------|
| **Tipo nuevo del dominio** | De la especificación, con el nombre y la forma que use el lenguaje (estructura, `record`, tupla, clase, `typedef`, *struct*, tabla) |
| **Firmas de las funciones expuestas** | Una por cada función de la especificación, en el orden en que aparecen; con los tipos del lenguaje |
| **Indicador natural de fallo** | El de la casa para ese lenguaje (`null`, `nil`, `None`, `#f`, `-1`, `nothing`); **no** se introduce `Option`/`Maybe`/`Result` ni excepciones antes de su fase |
| **Ubicación** | La que use el módulo homologado: archivo de contrato aparte, cabecera o el propio módulo |

**Regla de conservación:** lo que el esqueleto ya declara y encaja se respeta: el contrato se
**añade**, no se reescribe la estructura.

### 3. Declarar los esqueletos de las operaciones

El contrato no basta: en lenguajes como Ada o C, un contrato sin su cuerpo **no enlaza**, y la
suite del paso `4c` se bloquea. Por eso este paso entrega también **el cuerpo vacío de cada
operación declarada**, con la forma que el lenguaje exija:

| Lenguaje | Cómo se escribe el esqueleto |
|----------|------------------------------|
| Ada | El `.adb` de cada unidad con `is` … `begin`/`end`: cada subprograma con su `begin`/`end` y el valor de retorno puesto al **indicador natural** |
| C / C++ | La definición de cada función con su firma y el `return` del **indicador natural** (o `void` sin cuerpo útil) |
| C#, Java, Kotlin, Swift | El método con su firma y `throw new NotImplementedException()` / `fatalError(...)` **solo si el lenguaje lo idiomático**; si no, el retorno del indicador |
| Funcionales (Haskell, OCaml, F#, Elixir…) | La definición con el patrón que devuelve el **indicador natural** sin calcular nada |
| Scripting (Python, Ruby, Lua, R…) | La función con la firma y el retorno del **indicador natural** |

Reglas del esqueleto:

- **Uno por operación declarada**, en el orden de la especificación, sin funciones de más.
- Devuelve el **indicador natural** (o deja el valor por defecto del tipo): **nada** del
  algoritmo. Un esqueleto que resolviera el caso sería implementación, y el paso 5 se queda sin
  qué hacer.
- Si el lenguaje no admite un cuerpo vacío (una función que promete un valor debe devolver
  algo), el retorno del indicador **es** el esqueleto: no es una implementación.
- No se añade estado interno, campos ni ayudas que el contrato no declare.

### 4. Adaptar solo lo que el lenguaje no soporta

Una **adaptación idiomática** cambia la **forma**, nunca el resultado observable. Si el
lenguaje no puede declarar algo tal cual (nulos, índices enteros, mutación), se usa la
construcción que sí tiene, se dice en una línea y se anota para la tabla de adaptaciones del
README. Repasa las reglas de adaptación de `docs/AGENT_Template.md` antes de declarar
cualquier desviación.

### 5. Verificación

- El contrato **con sus esqueletos** debe **compilar y enlazar** sin warnings ni errores. Si el
  lenguaje necesita la implementación para enlazar, el esqueleto es lo que lo permite: si no
  enlaza, **falta un esqueleto**, no es un bloqueo esperado.
- La suite todavía no existe: es normal que el runner no tenga casos. **No** escribas la suite
  ni un ejecutable de ejemplo para «arreglarlo»: copia la salida real y sigue.
- Pega la salida real de la compilación **y del enlace**.

### 6. Cierre

Reporta en el formato de salida. **No** generes ni actualices READMEs, índices ni roadmap:
eso corresponde a otra delegación.

---

## Reglas duras

**DEBES**

- Resolver las variables antes de tocar nada.
- Declarar el **tipo nuevo** y **una firma por función** expuesta en la especificación.
- Entregar **el esqueleto de cada operación** declarada, con el retorno del indicador natural.
- Usar el **indicador natural** del lenguaje y la ubicación del módulo homologado.
- Pegar la salida real de la compilación **y del enlace**.
- Declarar en una línea cada adaptación y cada decisión de ubicación.

**NO DEBES**

- Escribir pruebas unitarias: son del encargo `suite` (paso 4c).
- Implementar el algoritmo: es el paso 5. Un esqueleto **no** resuelve ningún caso.
- Añadir `Option`/`Maybe`/`Result`, excepciones u otros envoltorios de error antes de su fase.
- Añadir funciones que la especificación no expone ni campos que nadie usa.
- Modificar la especificación, el roadmap ni `scripts/data/`.
- Generar documentación, READMEs ni índices.
- Introducir dependencias externas no estándar del lenguaje.
- Ejecutar `git add`, `git commit` ni `git push`.

---

## Definition of Done

- [ ] Variables resueltas y confirmadas con evidencia del repositorio.
- [ ] Tipo nuevo del dominio declarado, con el nombre y la ubicación del lenguaje.
- [ ] Una firma por cada función expuesta en `{spec}`, sin funciones de más.
- [ ] El esqueleto de **cada** operación declarada, con el retorno del indicador natural.
- [ ] Indicador natural de fallo declarado, sin envoltorios de error.
- [ ] El contrato con sus esqueletos **compila y enlaza**, con la salida real pegada sin editar.
- [ ] Adaptaciones y decisiones de ubicación declaradas en una línea cada una.
- [ ] Nada de la suite, del algoritmo ni de la documentación modificado.
