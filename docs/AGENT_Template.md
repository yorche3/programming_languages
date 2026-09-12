# Guía para Agentes de IA / AI Agent Guide

Esta guía complementa las instrucciones de `AGENTS.md` y describe cómo generar
o corregir documentación en este monorepo. La plantilla de README de Nivel 3
es [`README_Template.md`](README_Template.md).

## Alcance / Scope

Los agentes ayudan principalmente con documentación, verificación y revisiones
puntuales. El autor implementa los lenguajes para practicar; generar código
nuevo requiere una petición explícita.

## Antes de escribir / Before writing

1. Ejecutar `git status --short` y `git submodule status` en la raíz.
2. Comprobar la rama del submódulo afectado.
3. Leer la especificación y `docs/ROADMAP.md`.
4. No tocar una rama `feature/*` activa sin autorización.
5. Verificar que el estado indicado en el roadmap corresponde a código, tests y
   documentación existentes.

## Niveles de documentación / Documentation levels

| Nivel / Level | Archivo / File | Base / Source |
|---|---|---|
| 1 — Lenguaje / Language | `{lenguaje}/README.md` | README del lenguaje equivalente |
| 2 — Fase / Phase | `{lenguaje}/core/README.md` o `{lenguaje}/core/{fase}/README.md` | READMEs de fases existentes |
| 3 — Módulo / Module | `{lenguaje}/core/{fase}/{modulo}/README.md` | [`README_Template.md`](README_Template.md) |

## Reglas / Rules

- Mantener el formato bilingüe español/inglés.
- Usar enlaces GitHub Pages donde lo exijan las guías de documentación.
- Copiar solo salidas reales de compilación y tests.
- Explicar las adaptaciones del lenguaje, incluido TCO y la estructura de tests.
- No marcar un módulo o fase como completado sin verificación.
- No ejecutar `git push` ni crear commits salvo instrucción explícita.
- Al finalizar código y documentación, completar
  [`ROADMAP_UPDATE_CHECKLIST.md`](ROADMAP_UPDATE_CHECKLIST.md) y actualizar
  `ROADMAP.md` en el mismo cambio.

## Evolución por fase / Phase evolution

`README_Template.md` es la plantilla única de Nivel 3. Se puede ampliar cuando
una fase introduce conceptos nuevos, pero no se crean copias por lenguaje ni
plantillas paralelas con nombres distintos.

| Fase / Phase | Concepto / Concept |
|---|---|
| 0 — Foundations | Recursión, acumulador, iteración y TCO |
| 1 — Algorithms Pure | Indicadores de fallo compatibles, sin excepciones |
| 2 — Contiguous Processing | Validación y excepciones |
| 3 — Abstraction & Persistence | Option/Result, Maybe/Either y modelado |
