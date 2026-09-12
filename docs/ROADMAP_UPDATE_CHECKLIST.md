# Roadmap Update Checklist / Registro de cierre

Este archivo registra los cierres que autorizan una actualización de
`docs/ROADMAP.md`. Es parte del flujo de documentación: una delegación no está
finalizada hasta que el registro y el roadmap reflejan el mismo estado.

## Regla de cierre / Completion rule

Para cerrar un módulo, comprobar código, tests y README. Para cerrar una fase,
comprobar además todos sus módulos requeridos. Solo después se cambia el estado
en `ROADMAP.md`.

Cada entrada debe incluir la fecha, la fase, el módulo o conjunto de módulos,
los lenguajes verificados, los comandos ejecutados y el cambio de estado
realizado en el roadmap. No se deben inventar resultados.

## Plantilla de registro / Entry template

```text
Fecha / Date: YYYY-MM-DD
Fase / Phase: core.<phase>
Módulo(s) / Module(s): core.<phase>.<module>
Lenguaje(s) / Language(s): language-a, language-b
Código verificado / Code verified: yes/no
Tests y comandos / Tests and commands:
- `command` -> result
README(s) verificado(s) / README(s) verified: yes/no
Cambio en ROADMAP.md / ROADMAP.md change: old status -> new status
Observaciones / Notes:
```

## Pendientes / Pending closures

Añadir aquí una entrada cuando una delegación termina la implementación y la
generación de documentación, antes de actualizar el estado correspondiente en
`ROADMAP.md`.

## Historial / History

<!-- Las entradas cerradas se conservan debajo con su fecha y evidencia. -->
