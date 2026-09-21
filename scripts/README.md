# 🛠️ glot — CLI del monorepo / monorepo CLI

`glot` es el script de práctica del propio repositorio: igual que los lenguajes del roadmap empiezan por un `helloworld`, `glot` empieza por su «hello world» en Bash (v0.1.0) y crece versión a versión. Es **tooling del monorepo**: no es un módulo del roadmap, no altera `.gitmodules` ni los contadores `X/49` de [`docs/ROADMAP.md`](../docs/ROADMAP.md).

Versión viva / Live version: **v0.1.0** en [`glot.sh`](glot.sh).

---

## 📁 Estructura / Structure

```text
scripts/
├── README.md                 # Este archivo / This file
├── glot.sh                   # Versión viva / live version (v0.1.0)
└── versions/                 # Snapshots de versiones cerradas (se crea al cerrar la v0.1.0)
    └── glot_0.1.0.sh
```

| Archivo | Propósito |
|---------|-----------|
| [`glot.sh`](glot.sh) | Versión en desarrollo del CLI. Hoy: `echo "Hello World! from Bash!"`. |
| `versions/glot_<versión>.sh` | Foto inmutable de una versión cerrada. Todavía no existe ninguna. |

---

## 🚀 Funcionamiento actual / Current behaviour (v0.1.0)

**ES:** Hoy el script solo imprime el saludo inicial. No se carga con `source` ni necesita `.bashrc`: se ejecuta.

**EN:** Today the script only prints the greeting. It is not sourced and does not need `.bashrc`: it is executed.

```bash
cd /home/yorche3/programming_languages
./scripts/glot.sh        # equivalente: bash scripts/glot.sh
```

**Salida real / Actual output:**

```text
$ ./scripts/glot.sh
Hello World! from Bash!
$ echo $?
0
```

---

## ⚙️ Seteo en `.bashrc` / Shell setup

**v0.1.0:** no hace falta cargarlo, se ejecuta directamente.

**Desde v0.2.0:** `glot` pasará a ser una función y se cargará al arrancar el shell:

```bash
# ~/.bashrc
source /home/yorche3/programming_languages/scripts/glot.sh
```

Comprobar que quedó cargado:

```bash
type glot
```

> **ES:** Lo que esté en `glot.sh` es lo que cargará cada shell nuevo, así que la rama `main` debe quedar siempre en un estado cargable (ver «Rama y flujo»).
> **EN:** Whatever `glot.sh` contains is what every new shell will load, so the `main` branch must always stay in a loadable state (see "Branch & flow").

---

## 🧾 Log de versiones / Version log

| Versión | Fecha | Archivo | Añade | Estado |
|---------|-------|---------|-------|:------:|
| 0.1.0 | 2026-09-20 | `glot.sh` | Hello World en Bash (script ejecutable) | 🔄 viva |
| 0.2.0 | — | `glot.sh` | Función `glot` cargable con `source`, con `hello`, `version` y `help`, y resolución de la raíz del monorepo | ⏳ ideas |
| 0.3.0 | — | `glot.sh` | `glot set {lenguaje} {modulo}`: `cd` al submódulo, rama `tipo/fase/modulo`, `git push -u origin` y comando de inicialización del lenguaje | ⏳ ideas |
| 0.4.0 | — | `glot.sh` | `glot test`: ejecuta el comando nativo de pruebas del lenguaje y módulo asignados | ⏳ ideas |
| 0.5.0 | — | `glot.sh` | Estado persistente de la asignación (`status`, `unset`) y autocompletado | ⏳ ideas |

### 0.1.0 — 2026-09-20

- **Añade:** `echo "Hello World! from Bash!"`, el equivalente del `helloworld` de los lenguajes aplicado al tooling del repositorio.
- **Cómo se usa:** `./scripts/glot.sh`.
- **Snapshot:** aún sin archivar; se copiará a `versions/glot_0.1.0.sh` al cerrar la versión siguiente.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real → `Hello World! from Bash!`, código de salida `0`.

---

## 🔖 Convención de versiones y archivado / Versioning & archiving

- **SemVer** `MAJOR.MINOR.PATCH`; el número vive en el encabezado de `glot.sh` y en la tabla de este README (desde v0.2.0 también en `glot version`).
- **Cierre de versión:** copiar `glot.sh` a `versions/glot_<versión>.sh`, marcar la fila del log como `✅` y empezar la versión siguiente en `glot.sh`.
- Los snapshots de `versions/` **no se editan**: son la foto de cómo estaba el script en esa versión y permiten ver la progresión.
- `versions/` se crea al cerrar la primera versión (Git no versiona carpetas vacías).

---

## ✅ Requisitos / Requirements

| Herramienta | Uso | Verificación |
|-------------|-----|--------------|
| Bash 5.2 | Ejecutar `glot.sh` y, desde v0.2.0, cargarlo con `source` | `bash --version` |
| Git 2.43 | Desde v0.2.0: resolver el monorepo con `git rev-parse --show-superproject-working-tree` | `git --version` |

---

## 🧪 Cómo verificar / How to verify

```bash
bash -n scripts/glot.sh     # sintaxis
./scripts/glot.sh           # comportamiento
```

`shellcheck` no está instalado en este entorno; conviene añadirlo a la verificación cuando exista CI.

---

## 🧱 Reglas de diseño (desde v0.2.0) / Design rules

Se fijan aquí para no tener que rehacerlas cuando `glot` pase a ser una función:

1. **Cargable con `source`**: nunca `exit`, sin cambiar opciones globales del shell (`set -e`, `IFS`) ni el directorio actual; todo sale con `return`.
2. **Namespace**: funciones y variables internas con prefijo `_glot_`; públicas solo `GLOT_VERSION` y `GLOT_ROOT`.
3. **Salidas bilingües ES/EN** y códigos de salida: `0` correcto, `1` error de entorno, `2` uso incorrecto.
4. **Raíz del monorepo**: `GLOT_ROOT` → superproyecto → raíz git, para que funcione también desde dentro de un submódulo.

---

## 🧭 Gobernanza / Governance

- **ES:** `scripts/` vive en el repositorio raíz (no en ningún submódulo) y no entra en los contadores del roadmap. Pendiente: añadir la fila en [`README.md`](../README.md) (Estructura), la nota de cambios solo-monorepo en [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md) y el límite correspondiente en [`AGENTS.md`](../AGENTS.md).
- **EN:** `scripts/` lives in the root repository (not in any submodule) and is not part of the roadmap counters. Pending: add the row in [`README.md`](../README.md) (Structure), the monorepo-only change note in [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md), and the matching boundary in [`AGENTS.md`](../AGENTS.md).

---

## 🌿 Rama y flujo / Branch & flow

**ES:** Al ser un cambio solo-monorepo, sigue la regla de [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md): rama corta desde `main` con formato `chore/repo/<módulo>`, por ejemplo `chore/repo/glot`. Recomendado: una rama por versión y fusionar en `main` al cerrarla (cuando el snapshot ya está en `versions/`), para que `main` nunca quede con un `glot.sh` a medias que rompa los shells nuevos.

**EN:** As a monorepo-only change, follow [`docs/CONTRIBUTING.md`](../docs/CONTRIBUTING.md): a short branch from `main` named `chore/repo/<module>`, for example `chore/repo/glot`. Recommended: one branch per version, merged into `main` when the version closes (once the snapshot is in `versions/`), so `main` never keeps a half-finished `glot.sh` that breaks new shells.

