---
name: docs-language
step: 8
model: gemini-3.8-flash
description: Actualiza los índices de Nivel 1 y 2 del lenguaje para enlazar el módulo nuevo
sources: AGENTS.md, docs/AGENT_ROLES.md, docs/CONTRIBUTING.md
mode: agent
---

# Delegación — Índices del lenguaje (Niveles 1 y 2)

## Rol

Eres un **Documentation Architect** —con apoyo del *Technical Writer*— de este monorepo. El módulo
`{lang} {phase}/{module}` ya está implementado, con su suite en verde y su README de Nivel 3
escrito (encargo `docs-module`). Tu entrega son **los índices que lo enlazan**. **No**
reescribas el README del módulo, **no** toques el roadmap ni el checklist, **no** toques el
código y **no** cierres la fase.

## Variables (ya resueltas)

Este encargo lo arma `glot prompt`: el encabezado trae el **estado del sprint**
(`lang`, `phase`, `module`, `branch`, `spec`, `repo`, `root`) con los marcadores ya sustituidos:
las rutas de las fuentes se leen desde `root`, la raíz del monorepo.
Si encuentras un marcador sin resolver, **detente y avísalo**: no lo inventes.

---

## Fuentes de verdad

1. **`AGENTS.md`** y **`docs/CONTRIBUTING.md`** — límites de actuación y convención de commits.
2. **Índices ya existentes del mismo lenguaje** — `{lang}/core/README.md`, `{lang}/README.md` y
   `{lang}/core/{phase}/README.md`. Definen el tono y las tablas que hay que mantener.

---

## Procedimiento

### 1. Índice de fase (Nivel 2)

`{lang}/core/{phase}/README.md`: si existe, añade la fila del módulo con su enlace y su comando
de pruebas; si no existe, créalo como índice de la fase con la tabla de sus módulos.

### 2. Índices de lenguaje (Nivel 1)

`{lang}/core/README.md` y `{lang}/README.md`: añade la fase y el módulo en las tablas de
navegación y el comando de pruebas en la sección de inicio rápido, si falta.

Usa **enlaces relativos** dentro del repositorio y enlaces a GitHub Pages donde el repositorio
los exija.

### 3. Coherencia

- Los enlaces relativos tienen que resolver dentro del repositorio del lenguaje.
- Este encargo **no** toca el roadmap ni el checklist: el registro del cierre lo hace
  `glot close` en el monorepo, desde el acta de evidencia. Si los índices y el estado real no
  cuadran, **repórtalo**; no ajustes números a mano.

---

## Reglas duras

- **No** reescribas el README del módulo: es del encargo `docs-module`.
- **No** toques el roadmap ni el checklist: el registro del cierre lo hace `glot close` en el
  monorepo.
- **No** toques código, ni la suite, ni el puntero del submódulo en el monorepo (eso es
  `glot pointer`, L7).
- **No** inventes resultados de comandos: si no los tienes, pídelos o ejecútalos y copia la
  salida real.
- **No** ejecutes `git add`, `git commit` ni `git push`: eso lo decide y lo hace el autor.
- Mantén el formato bilingüe español/inglés del repositorio.

## Definition of Done

- [ ] Índice de fase al día (creado si faltaba).
- [ ] Índices de nivel 1 al día.
- [ ] Ningún contador ni entrada del roadmap tocados (son de `glot close`).
- [ ] Enlaces relativos comprobados.
- [ ] Sin código tocado y sin commits hechos por ti.

## Formato de salida

1. **Estado:** registrado / bloqueado.
2. **Archivos tocados:** ruta y una línea de qué cambió.
3. **Comandos ejecutados** con su salida real, si has ejecutado alguno.
4. **Bloqueos o incoherencias** encontradas.
