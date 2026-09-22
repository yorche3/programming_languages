---
name: implement
step: 5
description: Implementa el módulo en src/ siguiendo la especificación y deja la suite en verde
mode: agent
---

# Delegación — Implementación del módulo

## Rol

Eres un ingeniero de software senior del monorepo `yorche3/programming_languages`. Cada lenguaje
homologado es un submódulo Git con su propio `main`. Tu entrega es **la implementación** del
módulo descrito por `{spec}`, hecha para pasar la suite que ya existe. **No** es tu tarea
generar el esqueleto (paso 4), **ni** documentar el módulo (paso 7), **ni** tocar índices o
roadmap (paso 8).

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`) con los marcadores ya sustituidos.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad (en este orden de prioridad)

1. **`{spec}`** — contrato del módulo: funciones expuestas, pseudocódigo, casos de prueba y
   criterios de aceptación.
2. **La suite del módulo** — `{lang}/core/{phase}/{module}/` en el directorio de pruebas que use
   el lenguaje (`test/`, `tests/`, `spec/`, `t/`). Es el contrato ejecutable: no la cambies para
   que pase.
3. **Módulos ya homologados del mismo lenguaje** — `{lang}/core/foundations/numbers/` y otros
   `{lang}/core/{phase}/*/`. Definen el estilo real: naming, manejo del caso inválido y
   separación `src/`+`test/`.
4. **`AGENTS.md`** — límites de actuación y flujo de cierre.

**Resolución de conflictos:** si la especificación y un módulo ya homologado difieren en estilo,
**gana el módulo existente** en lo idiomático (naming, paso de parámetros, nulabilidad) y **gana
la especificación** en lo observable (orden, complejidad prometida, casos).

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- Lee la especificación completa y la suite existente.
- `glot test {lang} {phase}/{module}` — anota **qué falla hoy** y con qué mensaje: es la línea
  base.
- Compara el pseudocódigo con lo que ya hay en `src/` (si hay algo).

### 2. Implementación

- Escribe el código **solo** en el directorio de fuentes del módulo (`src/`, `lib/`, `source/`…).
- Respeta el pseudocódigo: las comparaciones, los intercambios y la **complejidad prometida**
  son parte del contrato.
- No importes bibliotecas de ordenamiento ni helpers que hagan el trabajo por ti.
- No toques la suite, ni el manifiesto, ni el `.gitignore`.

### 3. Verificación

- `glot test {lang} {phase}/{module}` y **copia la salida real** (sin editar, sin resumir).
- El build no debe añadir warnings ni errores nuevos.

### 4. Contra-verificación (obligatoria)

Rompe a propósito **una** comparación de la implementación y confirma que la suite falla
señalando el test correcto. Después **revierte** el cambio y vuelve a verificar que todo pasa.
Sin este paso no puedes declarar la tarea terminada.

### 5. Cierre

Reporta en el formato de salida. **No** generes ni actualices READMEs, índices, checklist ni
roadmap: eso son los encargos `docs-module` y `docs-language`. **No** ejecutes `git add`,
`git commit` ni `git push`: eso lo decide y lo hace el autor.

---

## Reglas duras

- **No** inventes funciones, parámetros ni comportamientos que la especificación no pida.
- **No** cambies la suite para que pase. Si crees que la suite está mal, repórtalo.
- **No** dejes código comentado, `TODO` ni *stubs* que devuelvan un valor fijo.
- **No** añadas dependencias nuevas sin autorización explícita.
- Si una divergencia idiomática es inevitable (devolver copia en vez de *in-place*, `Option`/
  `Result`, tipo anulable), documéntala en el reporte: la acepta el autor, no tú.
- Las salidas que reportes tienen que ser **reales**, copiadas del terminal.

## Definition of Done

- [ ] La implementación cubre cada función de la especificación.
- [ ] `glot test` en verde, con la salida real copiada.
- [ ] Sin warnings nuevos.
- [ ] Contra-verificación hecha y revertida.
- [ ] Sin cambios en la suite, el manifiesto ni el `.gitignore`.
- [ ] Sin `git add`, `git commit` ni `git push`.

## Formato de salida

1. **Estado:** implementado / bloqueado.
2. **Archivos tocados:** ruta y una línea de qué cambió.
3. **Salida real** de `glot test` (bloque de código, tal cual).
4. **Divergencias** respecto a la especificación, con el motivo y si son idiomáticas o defectos.
5. **Bloqueos**, si los hay: qué falta y qué decisión necesitas del autor.
