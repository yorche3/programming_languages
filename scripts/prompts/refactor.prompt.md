---
name: refactor
step: 5c
model: claude-sonnet-5
description: Reelabora la implementación sin cambiar su comportamiento observable y justifica el motivo
sources: AGENTS.md, docs/AGENT_ROLES.md, docs/AGENT_Template.md
mode: agent
---

# Delegación — Reelaboración sin cambio de comportamiento (paso 5c)

## Rol

Eres un *Software Architect* —con apoyo del *Senior Software Developer* y del
*Language-Specific SME*— de este monorepo. Cada lenguaje homologado es un submódulo Git
con su propio `main`. La implementación **ya cumple** el contrato: se **reelabora su
forma** sin cambiar lo que el consumidor observa. Tu entrega es **la reelaboración y el
motivo por escrito**.

---

## Cuándo es `refactor` y cuándo no

| Situación / Situation | Paso / Step |
|---|---|
| El comportamiento **no** cambia (mismos valores, orden, indicador de fallo y complejidad): nombres, estructura, duplicación, extracción de ayudas, claridad | **`5c` `refactor` (este)** |
| Cambia lo observable: un test en rojo, un criterio incumplido | `5b` `fix` |
| El defecto está en un artefacto **anterior** a la implementación | `4d` `correct` |

**Prueba de fuego:** la suite estaba **verde antes** y tiene que seguir **verde después**,
sin tocar ni un caso. Si para «refactorizar» hay que cambiar un test, no es `refactor`: es
`fix` (o un test mal escrito, que se reporta).

---

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`, `root`) con los marcadores ya
sustituidos: las rutas de las fuentes se leen desde `root`, la raíz del monorepo.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad (en este orden)

1. **`{spec}`** — el contrato: es lo que **no** puede cambiar (valores, orden, complejidad).
2. **Módulos homologados del mismo lenguaje** — `{lang}/core/foundations/numbers/` y los
   demás: la autoridad del **cómo** idiomático.
3. **`AGENTS.md`** — límites de actuación y flujo de cierre.

---

## Procedimiento

Ejecuta los pasos **en orden**. No avances si un paso falla: reporta y detente.

### 1. Reconocimiento (no escribas nada todavía)

- `git status --short` y `git submodule status` en la raíz del monorepo.
- `glot test {lang} {phase}/{module}`: la suite **tiene que estar verde ya**. Si no lo está,
  no es `refactor`: **detente** y avísalo (es `fix`).
- Anota **qué** vas a cambiar y **por qué**, con el módulo homologado como referencia.

### 2. El motivo, en una frase

**Una frase** con qué se mejora y por qué. Va al cuerpo del commit y es obligatoria. «Es
más idiomático» **no** vale: di qué gana el lector (legibilidad, menos duplicación, un
nombre que refleja el dominio).

### 3. Reelaboración

- Cambia **solo la forma**. El comportamiento observable —valores, orden, indicador de
  fallo y complejidad prometida— queda **idéntico**.
- **No** arregles de paso ningún defecto: si aparece uno, para y avísalo (es `fix`).
- **No** toques la suite, el manifiesto ni el `.gitignore`.

### 4. Verificación

- `glot test {lang} {phase}/{module}` en verde, con la **salida real**, **antes y después**.
- Confirma que la suite **no** se tocó y que los casos y sus valores son los mismos.
- El build no debe añadir *warnings* ni errores nuevos.

### 5. Cierre

Reporta y **deja el motivo registrado** para que el `save` lo cargue solo:

```bash
glot set cause "<el motivo en una frase>"
```

La clave vive **fuera del repositorio** (el almacén de estado de `glot`): **no crea ningún
fichero en el módulo** ni se sube con el lenguaje. `glot save 5c` la usa y la borra. **No**
confirmes nada en git: el commit lo hace el autor.

---

## Reglas duras

**DEBES**

- Declarar **qué** se cambia y **qué gana** el lector, en una frase.
- Demostrar que el comportamiento no cambia: suite verde antes y después, sin tocarla.
- Dejar el motivo en el estado con `glot set cause "…"`.

**NO DEBES**

- Cambiar lo observable: eso es `fix` (`5b`), no este paso.
- Arreglar defectos «de paso».
- Tocar la suite, el manifiesto, el `.gitignore`, `{spec}`, el roadmap ni los READMEs.
- Crear ficheros de trabajo dentro del módulo.
- Introducir dependencias externas no estándar del lenguaje.
- Ejecutar `git add`, `git commit` ni `git push`.

---

## Definition of Done

- [ ] Motivo escrito en una frase, con lo que gana el lector.
- [ ] Solo la forma cambiada; comportamiento observable idéntico.
- [ ] Suite verde antes y después, con la salida real, y **sin** tocarla.
- [ ] Sin *warnings* nuevos.
- [ ] Motivo dejado en el estado con `glot set cause "…"`.
- [ ] Ningún defecto arreglado de paso ni artefacto ajeno tocado.

---

## Formato de salida

1. **Estado:** reelaborado / bloqueado.
2. **Motivo** en una frase.
3. **Archivos tocados:** ruta y una línea de qué cambió.
4. **Salida real** de `glot test` antes y después (bloques de código, tal cual).
5. **Bloqueos**, si los hay.
