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

Fecha / Date: 2026-09-11
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): ada
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `alr -C test run` en `ada/core/algorithms/naive_sort` -> 3 tests ejecutados, 3 exitosos, 0 aserciones fallidas, 0 errores inesperados
README(s) verificado(s) / README(s) verified: yes (`ada/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 📋 -> 🔄 (1/49)
Observaciones / Notes: Primera implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. En Ada no existe representación de array nulo, por lo que el escenario inválido de la especificación queda documentado como no representable.

Fecha / Date: 2026-09-12
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): assembly
Código verificado / Code verified: yes (bugs corregidos: sintaxis GAS en vez de NASM, `rsi`/`esi` reutilizado para la bandera `swapped` en bubble_sort, límite fuera de uno en el bucle interno de bubble_sort, `rbx` sin preservar, `rax` sin fijar en los casos vacío/un elemento)
Tests y comandos / Tests and commands:
- `make run` en `assembly/core/algorithms/naive_sort` -> 24 tests ejecutados, 24 exitosos, 0 fallidos
README(s) verificado(s) / README(s) verified: yes (`assembly/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 1/49 (Ada) -> 2/49 (Ada, Assembly)
Observaciones / Notes: Segunda implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. A diferencia de Ada, en Assembly el array es un puntero crudo, por lo que `null` sí es representable; se añadió un octavo caso de prueba (puntero nulo) además de los 7 del enunciado.

Fecha / Date: 2026-09-12
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): ballerina
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `bal test` en `ballerina/core/algorithms/naive_sort` -> 3 tests ejecutados, 3 exitosos, 0 fallidos (24 aserciones)
- Prueba negativa: con `insertionSort` invertido -> 2 passing, 1 failing, confirmando que la suite detecta fallos
README(s) verificado(s) / README(s) verified: yes (`ballerina/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 2/49 (Ada, Assembly) -> 3/49 (Ada, Assembly, Ballerina)
Observaciones / Notes: Tercera implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Ballerina no admite `int[]` nulo, pero sí el tipo nillable `int[]?`, que se usa como indicador de fallo; se añadió el octavo caso (`()`). El clonado es responsabilidad de la implementación, por lo que los fixtures compartidos se pasan como entradas de solo lectura sin clonar en el test.
