# {Nombre del Módulo} — {Lenguaje}

Implementación de la especificación [{ID de la especificación}]({Enlace a la especificación}) en **{Lenguaje}**, con un enfoque manual y minimalista.

---

## 📂 Archivos y estructura / Files & Structure

*Describe aquí la estructura de directorios y el propósito de cada archivo. Usa una tabla si el proyecto es sencillo, o separa en raíz + subproyecto de pruebas si aplica.*

| Archivo / Directorio | Propósito |
|----------------------|-----------|
| `src/{modulo}.ext` | Código fuente principal (o especificación). |
| `src/{modulo}_impl.ext` | Implementación (si el lenguaje separa interfaz). |
| `tests/` | Subproyecto de pruebas unitarias (opcional). |
| `{build_config}` | Configuración de construcción. |
| `{manifest}` | Manifiesto de dependencias (si aplica). |
| `.gitignore` | Archivos y carpetas ignoradas. |

**Estructura de directorios esperada:**

```text
{nombre_proyecto}/               # (se crea según el lenguaje y las convenciones)
├── src/
│   ├── {modulo}.ext
│   └── {modulo}_impl.ext
├── tests/                       # (si aplica)
│   ├── src/
│   │   ├── {modulo}_tests.ext
│   │   ├── {modulo}_suite.ext
│   │   └── tests.ext
│   ├── {test_build_config}
│   └── {test_manifest}
├── {build_config}
├── {manifest}
├── .gitignore
├── bin/                         # ejecutables (generado)
├── obj/ o lib/                  # objetos / bibliotecas (generado)
└── ...

🛠️ Enfoque y construcción / Approach & Build

ES: El proyecto se creó manualmente, sin herramientas de scaffolding, para controlar cada detalle.
EN: The project was created manually, without scaffolding tools, to control every detail.

Incluye aquí, si aplica, los pasos de inicialización (por ejemplo, para una biblioteca + tests):

    Crear la biblioteca: {comando}

    Crear subproyecto de pruebas: {comando}

    Vincular dependencia local: {comando}

    Agregar framework de testing: {comando}

📄 Archivos de configuración clave / Key Configuration Files
{build_config} – Configuración de build

ES: Este archivo define cómo compilar: fuentes, directorios de salida y opciones del compilador.
EN: This file defines how to build: sources, output directories, and compiler options.
{lenguaje}

...

.gitignore – Archivos ignorados

ES: Patrones para no versionar archivos generados (binarios, dependencias, etc.).
EN: Patterns to avoid versioning generated files (binaries, dependencies, etc.).
gitignore

...

Manifiesto de dependencias / Dependency Manifest (si aplica)
{formato}

...

🚀 Compilación y ejecución / Build & Run
Compilar / Build
bash

{comando_de_compilación}

Ejecutar programa principal / Run main program
bash

{comando_de_ejecución}

Ejecutar pruebas / Run tests (si aplica)
bash

{comando_ejecutar_pruebas}

Salida esperada / Expected output:
text

...

🧠 Algoritmos / operaciones (según el módulo)

Si el módulo incluye una tabla de operaciones o algoritmos, agrégala aquí. Ejemplo:
Función / Algoritmo	Enfoques	Descripción
sum_of_first_n	_rec, _acc, _ite	Suma de los primeros n números.
factorial	_rec, _acc, _ite	Factorial de n.
...		
📝 Notas de implementación / Implementation Notes

Esta sección está reservada para observaciones específicas del lenguaje, como comportamiento de recursión, optimizaciones, manejo de pila, etc. Completa según el módulo que estés documentando. Ejemplo para el módulo Numbers:
🔁 Sobre recursión con acumulador y Tail Call Optimization (TCO) / On recursion with accumulator and Tail Call Optimization (TCO)
ES:
Tail recursion ocurre cuando la llamada recursiva es la última acción que ejecuta una función/método; despues de la llamada no hay más instrucciones, la función devuelve el resultado de la llamada recursiva. La recursión con acumulador consigue esto pasando el estado previo como parámetro a cada llamada, sin dejar trabajo pendiente en la pila.

En este lenguaje, {sí / no} se garantiza TCO.
(completa con la información real del lenguaje que estás documentando)

(lo  siguiente solo aplica si aplica al lenguaje no soporta TCO)
La implementación con acumulador se conserva únicamente con fines educativos: sirve como puente conceptual entre la recursión directa (más cercana a la definición matemática) y la versión iterativa (más eficiente). Como en este contexto no hay un beneficio práctico de rendimiento, no se desarrollan pruebas unitarias específicas para los métodos con acumulador. La validación del comportamiento se cubre a través de las pruebas de los enfoques recursivo e iterativo, que juntos ejercitan los mismos resultados.

EN:
Tail recursion occurs when the recursive call is the last action that runs a function/method; after the call there are no more instructions, the function returns the result of the recursive call. Recursion with accumulator gets this by passing the previous state as a parameter to each call, without leaving any pending work on the stack.

This language does (not) guarantee TCO.
(complete with the real information of the language you are documenting)

(the following only applies if the language does not support TCO)
The accumulator implementation is preserved only for educational purposes: it serves as a conceptual bridge between the direct recursive (closer to mathematical definition) and the iterative version (more efficient). Since there is no practical performance benefit, no specific unit tests are developed for the recursive methods with accumulator.

Este proyecto también está implementado en otros lenguajes. Explora el repositorio principal para ver todas las versiones.

🌐 github.com/yorche3/programming_languages · GitHub Pages