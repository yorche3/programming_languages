# Changelog

Todos los cambios relevantes del monorepo se registran en este archivo.
El formato sigue [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
y el versionado sigue [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- Nueva carpeta `scripts/` para las herramientas del monorepo, con `glot`: un CLI
  que crece por versiones siguiendo las especificaciones de los lenguajes
  (v0.1.0 `Hello World`, v0.2.0 equivalente a `hellouser`, v0.3.0 contrato y
  dispatcher de verbos y v0.4.0 almacén de estado clave/valor en XDG), con
  harness de pruebas propio y snapshots en `scripts/versions/`.
- `glot` v0.5.0: verbo `use`, que sitúa el trabajo del sprint y reconoce cuatro
  estados (nuevo, en curso, reanudar y cerrado): activa o crea la rama
  `{tipo}/{fase}/{módulo}` desde `main`, la publica con upstream y crea la
  carpeta si falta, y no crea ni cambia nada cuando hay trabajo sin confirmar;
  guarda el estado del sprint e imprime la ruta, con ensayo `-n/--dry-run` y
  158 comprobaciones en el harness.
- Se documentó el camino de versiones de `glot` (capas L0 a L9), el reparto de
  responsabilidades entre script y agente y la política del validador automático
  con GitHub Copilot CLI (modelo económico, salida JSONL y solo lectura).
- Se documentó el ciclo de trabajo de un módulo (el «sprint») como norma del
  monorepo en `docs/WORKFLOW.md`, y la documentación de `glot` se dividió en
  `scripts/README.md` (índice) más `scripts/docs/`: roadmap por capas L0–L9,
  sprint, contrato de verbos, tripas del script, log de versiones y validación.
- Se cerraron las decisiones abiertas de `glot` para la v0.6.0 y se unificó el
  vocabulario: **registrado** es la pertenencia técnica a `.gitmodules` (el
  denominador, 50) y **homologado** el estado «finalizado|concluido» de un
  módulo en un lenguaje (el numerador).
- `glot` v0.6.0: **catálogo** (L2.5) con `langs`, `modules`, `progress` y
  `completion`, más el conversor que proyecta el id canónico de un módulo
  (`data_structures`) a su nombre legible, su documento, su rama, su commit y su
  carpeta; los comandos nativos por lenguaje viven en
  `scripts/data/languages.tsv`, con test de deriva contra la guía de
  inicialización, y el autocompletado de bash y zsh (dinámico) se imprime con
  `glot completion`, con 227 comprobaciones en el harness.
- Se documentó el alcance real de `.github/prompts/` (plantillas locales que
  `.gitignore` no versiona y que se normalizarán en la L4) en
  `scripts/docs/ROADMAP.md`, `scripts/docs/SPRINT.md` y `docs/WORKFLOW.md`.
- Se auditó el módulo `05_Naive_Sort` en los 50 lenguajes y se abrió
  `docs/audits/` para registrar la deuda técnica por módulo, con criterios,
  estados, método reproducible y plan de cierre.
- Se abrió la fase `Algorithms Pure` como siguiente fase del roadmap.
- Se estableció el flujo de cierre documental y actualización del roadmap.

### Changed

- El roadmap reconoce los **50** submódulos registrados en `.gitmodules`: `php`
  entra en el contador y Foundations y `core.algorithms.naive_sort` pasan a
  `50/50`.
- Las plantillas de documentación usan nombres en inglés terminados en
  `_Template`.

### Fixed

- `glot use` no resolvía los módulos cuyo nombre de carpeta o de documento no
  sigue el id del roadmap: `foundations/helloworld` y `foundations/unit_test`
  devolvían `1` (especificación ausente) por un heurístico sobre el nombre del
  archivo. Ahora el catálogo resuelve el id canónico y sondea la carpeta.
- Los contadores `X/49` que quedaban en la documentación pasan a `X/50`
  (Foundations, fase de texto y guía de inicialización, que además incorpora la
  fila y la estructura de `php`).

## [0.1.0] - 2026-09-11

### Added

- Foundations completada y homologada en los 49 submódulos registrados.
- Especificaciones `01_Hello_World.md` a `04_Numbers.md`.
- READMEs de Foundations y documentación de implementación por lenguaje.

[Unreleased]: https://github.com/yorche3/programming_languages/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/yorche3/programming_languages/releases/tag/v0.1.0
