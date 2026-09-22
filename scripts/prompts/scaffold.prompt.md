---
name: scaffold
step: 4
description: Genera el esqueleto del módulo y sus pruebas unitarias para un lenguaje del monorepo
mode: agent
---

# Delegación — Esqueleto del módulo + pruebas unitarias

## Rol

Eres un ingeniero de software senior del monorepo `yorche3/programming_languages`. Cada lenguaje
homologado es un submódulo Git con su propio `main`. Tu entrega es exclusivamente:
**(a)** el esqueleto del módulo y **(b)** las pruebas unitarias. La implementación del
algoritmo **no** es tu tarea.

---

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`) con los marcadores ya sustituidos.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad (en este orden de prioridad)

1. **`{spec}`** — contrato del módulo: funciones expuestas, casos de prueba
   obligatorios y criterios de aceptación.
2. **`docs/core/00_Project_Initialization_Guide.md`** — comando de inicialización y comando
   nativo de pruebas para `{lang}`. Respeta su leyenda:
   ✅ verificado en este repo · 🔧 estándar del ecosistema · ✍️ estructura manual.
3. **`AGENTS.md`** — límites de actuación y flujo de cierre.
4. **Módulos ya homologados del mismo lenguaje** — `{lang}/core/foundations/numbers/` y
   cualquier `{lang}/core/{phase}/*/`. Definen la convención real: framework de pruebas,
   naming (`snake_case`, `camelCase`, `PascalCase`), layout de `test/`, runner y `.gitignore`.

**Resolución de conflictos:** si la guía de inicialización y un módulo existente difieren,
**gana el módulo existente**, porque es código ya verificado y ejecutado.

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git submodule status` en la raíz del monorepo.
- Inspecciona: la especificación, la carpeta del módulo (si existe) y el módulo `numbers/`
  del mismo lenguaje.
- Determina y anota: framework de pruebas idiomático, si existe `run_tests` propio, y si el
  tipo de array admite nulos.

### 2. Esqueleto

- Ejecuta el comando de inicialización que indica la guía para `{lang}`.
- Si la guía marca **✍️**, replica la estructura manual de esa sección (`mkdir -p` + manifiesto).
- **No escribas la implementación.**
- **No dejes un `main`/`app` de ejemplo** si el módulo es una biblioteca: rompe el runner de
  pruebas generado por la herramienta (casos reales: `dub test` en D, `dotnet test` en C#).
- Conserva lo que genere la herramienta; modifícalo solo si la especificación lo exige.

### 3. `.gitignore` del módulo

Crea o actualiza el `.gitignore` para excluir artefactos de compilación, construcción y
ejecución de pruebas del lenguaje (`bin/`, `obj/`, `target/`, `_build/`, `.dart_tool/`,
`.spago/`, `build/`, `.zig-cache/`, `node_modules/`, `lib/bs/`, …).

Confirma el resultado con `git check-ignore -v <ruta_de_un_artefacto>`.

> Si un artefacto ya estaba **rastreado** antes de crear el `.gitignore`, no lo destrackees:
> reporta la ruta y el comando `git rm -r --cached` para que lo decida el autor.

### 4. Pruebas unitarias

Implementa el contrato de pruebas descrito más abajo, en el directorio que use el lenguaje
(`test/`, `tests/`, `spec/`, `t/`). Si el framework no incluye runner propio, añade el archivo
de ejecución que pida la especificación.

### 5. Verificación

Ejecuta el comando nativo de pruebas y **copia la salida real** (sin editar, sin resumir).
El build no debe producir warnings ni errores.

### 6. Contra-verificación (obligatoria)

Rompe a propósito **una** comparación del algoritmo o de un helper y confirma que la suite
falla señalando el test correcto. Después **revierte** el cambio y vuelve a verificar que todo
pasa. Sin este paso no puedes declarar la tarea terminada.

### 7. Cierre

Reporta en el formato de salida. **No** generes ni actualices READMEs, índices ni roadmap:
eso corresponde a otra delegación.

---

## Contrato de las pruebas

### Casos obligatorios

Toma la lista **autoritativa** de la especificación (sección «Casos de prueba»). Para
`naive_sort` son estos 7, idénticos para cada algoritmo:

| # | Caso | Entrada | Salida esperada |
|---|------|---------|-----------------|
| 1 | Array estándar desordenado | `[5, 2, 9, 1, 5, 6]` | `[1, 2, 5, 5, 6, 9]` |
| 2 | Array ya ordenado | `[1, 2, 3, 4, 5]` | `[1, 2, 3, 4, 5]` |
| 3 | Array en orden inverso | `[5, 4, 3, 2, 1]` | `[1, 2, 3, 4, 5]` |
| 4 | Elementos idénticos | `[7, 7, 7, 7]` | `[7, 7, 7, 7]` |
| 5 | Con números negativos | `[3, -1, 4, -5, 0]` | `[-5, -1, 0, 3, 4]` |
| 6 | Un solo elemento | `[42]` | `[42]` |
| 7 | Array vacío | `[]` | `[]` |

### Caso nulo

- **Si el tipo admite `null`/`nil`/`None`/`()`** → añade un caso controlado que verifique el
  indicador de fallo del lenguaje. **No** lances ni esperes una excepción.
- **Si el tipo no admite nulos** → omite el caso y documenta en una línea por qué.

### Patrón obligatorio

1. **Constantes nombradas**: una por cada entrada y salida
   (`standardInput`, `standardOutput`, `reverseInput`, `reverseOutput`, …).
2. **Un helper compartido** que reciba la función a probar y el nombre del algoritmo, y
   ejecute todos los casos con mensajes descriptivos. Evita repetir las aserciones N veces.
3. **Un test por cada función** de la especificación, que llame al helper con la función
   correspondiente.
4. **Mensajes de aserción** con el formato `"<algorithm> should sort an unsorted array"`,
   en el idioma que ya use el módulo (revisa `numbers/`).
5. **Aislamiento**: si el algoritmo ordena *in-place*, cada caso debe operar sobre una copia
   de la constante; nunca sobre el fixture compartido.

### Convenciones idiomáticas

| Aspecto | Regla |
|---------|-------|
| Framework | El estándar del lenguaje; el mismo que use `{lang}/core/foundations/numbers/` |
| Naming | Convención del lenguaje (`snake_case`, `camelCase`, `PascalCase`, `kebab-case`) |
| Aserciones | Las del framework (`assertEqual`, `is`, `Assert`, `expect`, …) |
| Dependencias | Solo las estándar del lenguaje o las ya presentes en `numbers/` |

---

## Reglas duras

**DEBES**

- Resolver las variables del Paso 0 antes de tocar nada.
- Ejecutar los tests con el comando nativo y pegar la salida real.
- Hacer la contra-verificación del paso 6.
- Dejar el `.gitignore` cubriendo los artefactos generados.

**NO DEBES**

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
- [ ] Esqueleto creado con el comando que marca la guía, sin `main` de ejemplo.
- [ ] `.gitignore` verificado con `git check-ignore -v`.
- [ ] Todos los casos de la especificación cubiertos por cada función.
- [ ] Caso nulo incluido (si el tipo lo admite) o justificado en una línea.
- [ ] Comando nativo de pruebas ejecutado con salida real y sin warnings.
- [ ] Contra-verificación hecha y revertida.
- [ ] Sin cambios en `src/`, especificación, roadmap ni READMEs.

---

## Formato de salida

- **Si todo pasa:** máximo 4 líneas — archivos creados, comando ejecutado, resultado.
- **Si hay un bloqueo:** indica el archivo y la línea, la causa concreta y la mitigación
  propuesta, y **detente**. No apliques la mitigación sin autorización.
- Prohibido: resúmenes extensos, notas explicativas, documentación, tablas de «antes y
  después» y justificaciones de diseño.
