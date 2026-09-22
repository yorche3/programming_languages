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
- Se documentó el camino de versiones de `glot` (capas L0 a L9), el reparto de
  responsabilidades entre script y agente y la política del validador automático
  con GitHub Copilot CLI (modelo económico, salida JSONL y solo lectura).
- Se documentó el ciclo de trabajo de un módulo (el «sprint») como norma del
  monorepo en `docs/WORKFLOW.md`, y la documentación de `glot` se dividió en
  `scripts/README.md` (índice) más `scripts/docs/`: roadmap por capas L0–L9,
  sprint, contrato de verbos, tripas del script, log de versiones y validación.
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

## [0.1.0] - 2026-09-11

### Added

- Foundations completada y homologada en los 49 submódulos registrados.
- Especificaciones `01_Hello_World.md` a `04_Numbers.md`.
- READMEs de Foundations y documentación de implementación por lenguaje.

[Unreleased]: https://github.com/yorche3/programming_languages/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/yorche3/programming_languages/releases/tag/v0.1.0
