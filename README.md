# 🌐 Lenguajes de Programación / Programming Languages (Monorepo)

Implementación de conceptos de programación basados en especificaciones generales y adaptaciones específicas para cada lenguaje de programación.

Implementation of programming concepts based on general specifications and specific adaptations for each programming language.

---

## 📖 Descripción / Description

Este monorepo tiene como objetivo proporcionar un entorno de aprendizaje y experimentación completo para varios lenguajes de programación. Contiene fundamentos de cada lenguaje hasta temas avanzados como microservicios, interfaces graficas y CI/CD enfocado en seguridad de código.

This monorepo aims to provide a comprehensive learning and experimentation environment for various programming languages. It covers fundamentals of each language up to advanced topics like microservices, GUIs and CI/CD focused on code security.

---

## 📁 Estructura / Structure

```text
programming_languages/
├── docs/ # Especificaciones, pseudocódigo y casos de prueba / Specification, pseudocode and test cases
├── programing_language_name/ # Implementaciones de cada lenguaje / Implementations of each language
...
```

Cada carpeta de lenguaje contiene su respectivo `Readme.md` con instrucciones detalladas de instalación y uso.


Each language folder contains its respective `Readme.md` with detailed installation and usage instructions.

---

## 🔗 Submódulos / Submodules

Algunos lenguajes (Ada, Java, Python, etc.) están alojados en repositorios separados para mantener el monorepo limpio y organizado. Para clonar el monorepo completamente con todos los submódulos usa el siguiente comando:

Some languages (Ada, Java, Python, etc.) are hosted in separate repositories to keep the monorepo clean and organized. To clone the entire monorepo with all submodules use the following command:

```bash
git clone --recurse-submodules https://github.com/yorche3/programming_languages.git
```

Si ya tienes el monorepo clonado, pero no los submódulos, puedes inicializarlos con el siguiente comando:

If you already have the monorepo cloned, but not the submodules, you can initialize them with the following command:

```bash
git submodule update --init --recursive
```

Para actualizar los submódulos después de clonado el monorepo:

For updating the submodules after cloning the monorepo:

```bash
git submodule update --init --recursive
```

## 🚀 Uso rápido / Quick Start

1. Elige un lenguaje (por ejemplo `python/`) / Choose a language (e.g. `python/`)
2. Lee el archivo `README.md` para instalar las dependencias / Read the `README.md` to install the dependencies
3. Ejecuta el proyecto `helloworld` / Run the `helloworld` project

No hay una instalación global requerida. Cada lenguaje se configura y ejecuta de manera independiente.

There is no global installation required. Each language is configured and run independently.

## 📖 Documentación / Documentation

La documentación completa, incluyendo el roadmap, la estructura detallada y guías está disponible en la carpeta `doc` y en el sitio web del monorepo:

The complete documentation, including the roadmap, the detailed structure and guides is available in the `doc` folder and on the monorepo website:

👉 https://yorche3.github.io/programming_languages

## 🗺️ Roadmap

Consulta el archivo [`ROADMAP.md`](docs/ROADMAP.md) para obtener información sobre los objetivos futuros y el plan de desarrollo.

Check the [`ROADMAP.md`](docs/ROADMAP.md) file for information about future objectives and the development plan.

```text
programming_languages/
├── doc/                              # Especificaciones, pseudocódigo y casos de prueba
│   ├── core/
│   │   ├── foundations/
│   │   │   ├── hello_world/
│   │   │   ├── hello_user/
│   │   │   ├── unit_test/           # sum_of_first_n, fibonacci, factorial, mcd (recursivo/con acumulador)
│   │   │   └── numbers/             # sum_of_first_n, fibonacci, factorial, mcd, mcm (iterativos)
│   │   ├── algorithms/
│   │   │   ├── sorting/             # bubble_sort, insertion_sort, selection_sort, quick_sort, merge_sort, heap_sort, radix_sort, bucket_sort, shell_sort, counting_sort
│   │   │   ├── data_structures/     # stack, queue, linked_list, tree, graph, hash_table, heap, set
│   │   │   └── searching/           # linear_search, binary_search, jump_search, interpolation_search
│   │   ├── data/
│   │   │   ├── modeling/            # user, product, order...
│   │   │   ├── input_output/        # files (read, write, append) con excepciones y validaciones
│   │   │   └── data_base/
│   │   │       ├── raw_queries/     # connect, query, insert, update, delete, transaction
│   │   │       ├── orm/             # modelos, migraciones, operaciones
│   │   │       └── connection_pool/
│   │   ├── math/
│   │   │   ├── statistics/          # mean, median, mode, variance, standard_deviation, percentiles
│   │   │   └── linear_algebra/      # matrix, vector, linear_equation, linear_system, complex_numbers
│   │   └── text/
│   │       ├── transformations/     # reverse, remove_blank_chars
│   │       ├── patterns/            # palindrome, anagram, substring, longest_proper_prefix, knuth_morris_pratt_search, longest_common_subsequence, longest_common_prefix, boyer_moore, z_algorithm
│   │       ├── regex/               # patrones (email, teléfono, etc.)
│   │       └── parsing/
│   │           ├── csv_parser/
│   │           ├── json_parser/
│   │           └── arithmetic_parser/
│   ├── util/                        # biblioteca reusable (especificación de la interfaz común)
│   ├── ui/
│   │   ├── cliapp/
│   │   │   ├── hello_world/         # CLI mínimo
│   │   │   ├── hello_user/          # Interacción con usuario + unit tests
│   │   │   ├── algorithms_menu/     # Menú interactivo para ejecutar algoritmos
│   │   │   └── crud/                # Operaciones CRUD demostrativas
│   │   ├── tuiapp/                  # misma subestructura que cliapp
│   │   └── guiapp/                  # misma subestructura que cliapp
│   ├── web/
│   │   ├── mvcapp/                  # subestructura análoga: hello_world, hello_user, etc.
│   │   └── api/
│   │       ├── restapi/
│   │       ├── soapapi/
│   │       ├── graphqlapi/
│   │       ├── grpcapi/
│   │       └── websocketapi/
│   ├── async/
│   │   ├── futures_and_promises/
│   │   ├── async_await/
│   │   ├── actor_model/
│   │   ├── channels/
│   │   └── parallel/
│   ├── interop/
│   │   ├── c_binding/
│   │   ├── system_calls/
│   │   └── other_lang_bridge/
│   ├── tools/                       # Configuraciones de linter, formatter, SAST, coverage, build
│   │   ├── linter/
│   │   ├── formatter/
│   │   ├── static_analysis/
│   │   ├── coverage/
│   │   └── build/
│   ├── Jenkinsfile                  # Pipeline global del monorepo
│   ├── Dockerfile                   # Entorno de construcción y pruebas global
│   └── README.md
│
├── python/                          # Ejemplo de lenguaje concreto
│   ├── core/                        # Implementación espejo de doc/core/
│   ├── util/                        # Código reutilizable para ui y web
│   ├── ui/
│   │   ├── cliapp/
│   │   ├── tuiapp/
│   │   └── guiapp/
│   ├── web/
│   │   ├── mvcapp/
│   │   └── api/
│   ├── async/
│   ├── interop/
│   ├── tools/
│   ├── Jenkinsfile                  # Pipeline específico de Python
│   ├── Dockerfile                   # Entorno específico de Python
│   └── README.md
│
├── java/                            # Misma estructura que python/
│   └── ...
├── ada/                             # Misma estructura que python/
│   └── ...
└── ... (resto de lenguajes)
```

## Roadmap (TBD)

```text
core.foundations.helloworld
core.foundations.hellouser
core.foundations.unit_test
core.foundations.numbers
core.text.transformations
core.text.patterns
core.text.regex
core.text.parsing
core.algorithms.sorting
core.algorithms.data_structures
core.algorithms.searching
core.data.input_output
core.data.modeling
core.data.data_base
core.math.statistics
core.math.linear_algebra
util
ui.cliapp
ui.tuiapp
ui.guiapp
web.mvcapp
web.api
async.futures_and_promises
async.async_await
async.actor_model
async.channels
async.parallel
interop.c_binding
interop.system_calls
interop.other_lang_bridge
tools
```

### 01 — Hello World

Como todo primer paso para aprender cualquier lenguaje de programación, se escribirá un programa simple que muestre "Hello, World!" en la consola/terminal. Este es un proyecto básico pero fundamental para entender cómo funcionan los programas, cómo se configura el entorno de desarrollo y cómo se ejecuta el código.

### 02 — Hello User

Una vez que ya hayamos escrito nuestro primer programa, es el momento de dar paso a los elementos que permiten a los programas manejar los datos, estas son las variables. En este proyecto aprenderemos a declarar y usar variables,así como interactuar con el usuario a nivel básico por medio de las funciones/métodos que provee la biblioteca estándar del lenguaje.

### 03 — Unit Testing

Cambiamos de dirección y pasamos de usar la sintaxis que te ofrece el lenguaje a la implementación propia por medio de un lenguaje que se asemeje en este caso las `matemáticas`. Se hara implementación de tus primeros algoritmos recursivos que se asemejan a la forma más natural en que los estudias matemáticamente, además te permitirá explorar la forma atómica para verificar la correctitud de tu código por medio de pruebas unitarias, creando una estructura base tipo lib para tus siguientes desarrollos más complejos.

### 04 — Numbers

Después de entender cómo manejar variables, escribir funciones que vienen de un lenguaje como las matemáticas y realizar pruebas unitarias, es el momento de explorar las bases de mejora en la eficiencia del código. Para esto nos enfocaremos en pasar los algoritmos recursivos y recursivos con acumulador a iterativos para mejorar su eficiencia en cuanto a llamado a funciones y uso de memoria.