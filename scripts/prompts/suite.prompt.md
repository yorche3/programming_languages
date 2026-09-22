---
name: suite
step: 4b
description: Escribe la suite de pruebas unitarias del módulo desde su especificación
mode: agent
---

# Delegación — Suite de pruebas unitarias

## Rol

Eres un ingeniero de software senior del monorepo `yorche3/programming_languages`. Cada lenguaje
homologado es un submódulo Git con su propio `main`. Tu entrega es exclusivamente la **suite de
pruebas unitarias** del módulo, derivada de su especificación. El esqueleto ya está hecho
(encargo `scaffold`, paso 4a) y la implementación del algoritmo **no** es tu tarea (paso 5).

---

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`) con los marcadores ya sustituidos.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad (en este orden de prioridad)

1. **`{spec}`** — contrato del módulo: funciones expuestas, casos de prueba
   obligatorios y criterios de aceptación. Es la fuente autoritativa de los casos.
2. **Módulos ya homologados del mismo lenguaje** — `{lang}/core/foundations/numbers/` y
   cualquier `{lang}/core/{phase}/*/`. Definen la convención real: framework de pruebas,
   naming (`snake_case`, `camelCase`, `PascalCase`), layout de `test/`, runner y `.gitignore`.
3. **`scripts/data/languages.tsv`** — comando nativo de pruebas de `{lang}` (columna 4).
4. **`AGENTS.md`** — límites de actuación y flujo de cierre.

**Resolución de conflictos:** si la especificación y un módulo existente difieren en estilo,
gana el módulo existente; si difieren en casos de prueba, gana la especificación.

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git submodule status` en la raíz del monorepo.
- Inspecciona: la especificación, el módulo `numbers/` del mismo lenguaje y el esqueleto que
  dejó el encargo `scaffold` (paso 4a): directorio de pruebas, runner y manifiesto.
- Determina y anota: framework de pruebas idiomático, dónde vive la suite, si existe un
  `run_tests` propio y si el tipo de array admite nulos.

### 2. Pruebas unitarias

Implementa el contrato de pruebas descrito más abajo, en el directorio que use el lenguaje
(`test/`, `tests/`, `spec/`, `t/`). Si el framework no incluye runner propio, añade el archivo
de ejecución que pida la especificación.

### 3. Verificación

Ejecuta el comando nativo de pruebas y **copia la salida real** (sin editar, sin resumir).
El build no debe producir warnings ni errores.

### 4. Contra-verificación (obligatoria)

Rompe a propósito **una** comparación del algoritmo o de un helper y confirma que la suite
falla señalando el test correcto. Después **revierte** el cambio y vuelve a verificar que todo
pasa. Sin este paso no puedes declarar la tarea terminada.

### 5. Cierre

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

- Resolver las variables antes de tocar nada.
- Ejecutar los tests con el comando nativo y pegar la salida real.
- Hacer la contra-verificación.
- Aislar los casos cuando el algoritmo ordene *in-place*.

**NO DEBES**

- Tocar el esqueleto ni el `.gitignore`: son del encargo `scaffold` (paso 4a).
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
- [ ] Todos los casos de la especificación cubiertos por cada función.
- [ ] Caso nulo incluido (si el tipo lo admite) o justificado en una línea.
- [ ] Constantes nombradas, helper compartido y aislamiento verificado (in-place).
- [ ] Comando nativo de pruebas ejecutado con salida real y sin warnings.
- [ ] Contra-verificación hecha y revertida.
- [ ] Sin cambios en el esqueleto, el `.gitignore`, `src/`, la especificación, el roadmap ni los READMEs.

---

## Formato de salida

- **Si todo pasa:** máximo 4 líneas — archivos creados, comando ejecutado, resultado.
- **Si hay un bloqueo:** indica el archivo y la línea, la causa concreta y la mitigación
  propuesta, y **detente**. No apliques la mitigación sin autorización.
- Prohibido: resúmenes extensos, notas explicativas, documentación, tablas de «antes y
  después» y justificaciones de diseño.
