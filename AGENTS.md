# AGENTS.md - Instrucciones para agentes de IA

Este monorepo se usa para practicar lenguajes de programación. Los agentes
ayudan principalmente con documentación, verificación y correcciones puntuales.
La implementación de código nuevo requiere una petición explícita del autor.

## Contexto y fuentes de verdad

- `main` es la rama principal del monorepo.
- Cada lenguaje homologado es un submódulo Git con su propio repositorio.
- `docs/ROADMAP.md` es la fuente de verdad del estado de módulos y fases.
- La documentación real de cada módulo vive en
  `{lenguaje}/core/{fase}/{modulo}/README.md`.
- Las especificaciones generales viven en `docs/core/`.
- `docs/README_Template.md` es la plantilla para READMEs de Nivel 3.
- `docs/AGENT_Template.md` es la guía detallada para agentes.

## Antes de trabajar

1. Ejecutar `git status --short` y `git submodule status` en la raíz.
2. Comprobar la rama del submódulo afectado.
3. Leer la especificación correspondiente y el estado de `docs/ROADMAP.md`.
4. Verificar que el módulo no está en una rama de trabajo activa, salvo petición
   explícita.
5. No interpretar un estado `✅` como válido si faltan código, tests o README.

## Límites de actuación

- Generar o corregir documentación usando la plantilla vigente.
- Revisar código, tests y documentación ya existentes.
- Refactorizar o implementar código solo cuando el autor lo solicite.
- No ejecutar `git push` ni crear commits salvo instrucción explícita.
- No modificar `docs/ROADMAP.md` durante una implementación parcial.

## Convenciones de ramas

- Usar ramas cortas con formato `tipo/fase/modulo`, en minúsculas y `kebab-case`.
- Ejemplos: `feat/algorithms/naive-sort`, `docs/foundations/readme-template`,
  `fix/foundations/numbers` y `chore/repo/submodule-pointer`.
- En un submódulo, integrar primero el cambio en su propio `main`.
- Actualizar el puntero del submódulo en el monorepo solo después de esa
  integración y antes de integrar la rama del monorepo.
- No apuntar el monorepo a una rama de trabajo no integrada del submódulo.

## Flujo de cierre de módulo o fase

La delegación de documentación solo puede marcarse como finalizada cuando:

1. El código y sus tests existen y se han ejecutado con resultado verificable.
2. El README del módulo se ha generado desde `README_Template.md`.
3. Se comprueba la documentación de fase y, cuando corresponda, del lenguaje.
4. Se registra el cierre en `docs/ROADMAP_UPDATE_CHECKLIST.md`.
5. En el mismo cambio se actualiza `docs/ROADMAP.md` con el estado real.
6. Se ejecuta `git diff --check` y se revisan los cambios antes de entregarlos.

Un módulo no se marca como completo por tener README solamente. Una fase no se
marca como completa hasta que sus módulos requeridos cumplen todos los puntos.

## Convenciones de documentación

- Mantener el formato bilingüe español/inglés del repositorio.
- Usar nombres de archivos en inglés y `PascalCase` para plantillas descriptivas:
  `README_Template.md`, `AGENT_Template.md`.
- Usar enlaces relativos dentro de `docs/` y enlaces GitHub Pages donde las
  guías del repositorio los exijan.
- Copiar únicamente salidas reales de compilación y tests.
- Conservar las adaptaciones idiomáticas, incluyendo TCO y la estructura de
  tests, sin inventar capacidades del lenguaje.

## Definition of Done

- [ ] Código y tests verificados, si forman parte de la tarea.
- [ ] README generado o actualizado con `README_Template.md`.
- [ ] Estado del roadmap comprobado y actualizado solo al cerrar el trabajo.
- [ ] Registro correspondiente añadido en `ROADMAP_UPDATE_CHECKLIST.md`.
- [ ] `git diff --check` sin errores.
- [ ] Sin push ni commit no solicitados.
