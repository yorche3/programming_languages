# 🧾 Log de versiones / Version log

**ES:** Historial de versiones cerradas y de la versión viva. Las versiones **futuras** y la capa que cubre cada una están en [`ROADMAP.md`](ROADMAP.md).

**EN:** History of closed versions and of the live version. **Future** versions and the layer each one covers are in [`ROADMAP.md`](ROADMAP.md).

| Versión | Fecha | Archivo | Añade | Estado |
|---------|-------|---------|-------|:------:|
| 0.1.0 | 2026-09-20 | [`versions/glot_0.1.0.sh`](../versions/glot_0.1.0.sh) | Hello World en Bash (`echo "Hello World! from Bash!"`) | ✅ cerrada |
| 0.2.0 | 2026-09-20 | [`versions/glot_0.2.0.sh`](../versions/glot_0.2.0.sh) | Nombre por argumento o por entrada estándar y saludo `Hello, <nombre>!` (equivalente a `hellouser`) | ✅ cerrada |
| 0.3.0 | 2026-09-20 | [`versions/glot_0.3.0.sh`](../versions/glot_0.3.0.sh) | **Contrato y dispatcher** (L0): `version`, `help`, `doctor`, `greet`, `hello`, sin rutas del usuario, más harness de pruebas propio | ✅ cerrada |
| 0.4.0 | 2026-09-21 | [`versions/glot_0.4.0.sh`](../versions/glot_0.4.0.sh) | **Almacén clave/valor** (L1): `set`, `get`, `unset`, `list`, `path`, en XDG, atómico bajo `flock` y con `-n/--dry-run` | ✅ cerrada |
| 0.5.0 | 2026-09-21 | [`glot.sh`](../glot.sh) | **Asignación** (L2): `use <lenguaje> <fase>/<módulo> [tipo]`, que valida, crea el directorio del módulo, prepara y publica la rama, guarda el estado del sprint e imprime la ruta | 🔄 viva |

---

## 0.1.0 — 2026-09-20 (cerrada)

- **Añade:** `echo "Hello World! from Bash!"`, el equivalente del `helloworld` de los lenguajes aplicado al tooling del repositorio.
- **Cómo se usaba:** `./scripts/glot.sh`.
- **Snapshot:** [`versions/glot_0.1.0.sh`](../versions/glot_0.1.0.sh), archivado al abrir la v0.2.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real → `Hello World! from Bash!`, código de salida `0`.

## 0.2.0 — 2026-09-20 (cerrada)

- **Añade:** el nombre llega como argumento (`./scripts/glot.sh Ada`) o por la entrada estándar; si no llega por ninguna de las dos vías, el script pregunta `Enter your name: ` y lee con `read -r`.
- **Equivalencia:** es el `hellouser` del tooling (especificación `02_Hello_User`): pide el nombre, lo guarda en una variable y saluda.
- **Snapshot:** [`versions/glot_0.2.0.sh`](../versions/glot_0.2.0.sh), archivado al abrir la v0.3.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real de las tres vías → `Hello, Ada!` (`rc=0`), `Enter your name: Hello, Ada!` (`rc=0`) y `Hello, Grace Hopper!` con entrada `printf 'Grace Hopper\r\n'`.
- **Notas:** `read -r` evita que se interpreten las barras invertidas; `${name%$'\r'}` descarta el terminador CRLF, igual que los módulos `hellouser` de los lenguajes; con entrada vacía (EOF) imprime `Enter your name: Hello, !` y devuelve `0`, sin abortar pese a `set -e`.

## 0.3.0 — 2026-09-20 (cerrada)

- **Añade:** el contrato L0 y el dispatcher de verbos: `version`, `help [verbo]`, `doctor` y `greet [nombre]`, con `stdout` = datos, `stderr` = diagnóstico y códigos `0/1/2`; y el harness [`tests/glot_test.sh`](../tests/glot_test.sh) (39 comprobaciones, sin dependencias).
- **Sin rutas del usuario:** el script se localiza con `BASH_SOURCE` y resuelve la raíz con `GLOT_ROOT` → superproyecto → raíz git; la documentación usa variables en lugar de rutas fijas.
- **Cambios respecto a v0.2.0:** se retira el prompt interactivo (los verbos nunca preguntan: el dato llega por argumento o stdin) y un primer argumento que no es verbo ya no se interpreta como nombre: devuelve `2` con la sugerencia `glot greet <nombre>`. El saludo de v0.2.0 se conserva como verbo `hello`, que se retira en v1.0.0.
- **Verificación:** `bash -n` limpio en `glot.sh`, el harness y el snapshot; `./scripts/tests/glot_test.sh` → `glot tests: 39 passed, 0 failed` (rc `0`); `doctor` dentro del monorepo rc `0` y fuera rc `1` con `root: (no detectado / not detected)`.
- **Documentación:** recorrido interno del script, con la lectura de argumentos, la tabla de despacho, qué lee y decide cada verbo y los detalles no evidentes (`-t 0`, `read -r`, CRLF, resolución de la raíz).
- **Snapshot:** [`versions/glot_0.3.0.sh`](../versions/glot_0.3.0.sh), archivado al abrir la v0.4.0.
- **Notas:** al pasar a v0.4.0 se ajustó un detalle del contrato: las confirmaciones de `set`/`unset` van a `stderr` (antes se mezclaban con el dato en stdout de los verbos de estado) y se estrenó el código `3` para el estado ilegible.

## 0.4.0 — 2026-09-21 (cerrada)

- **Añade:** el **almacén de estado** (L1) con `set`, `get`, `unset`, `list` y `path`; escritura atómica (`mktemp` + `mv -f`) bajo `flock`, permisos `600` del fichero y `700` del directorio, `-n/--dry-run` en los verbos que mutan, y `doctor` ampliado con `state_dir`, `state_file` y `state_file_ok`.
- **Contrato:** se estrena el código `3` (estado ilegible o no escribible) y se documenta el formato `clave=valor` con clave `[A-Za-z0-9_.-]` y valor sin saltos de línea.
- **Sin rutas del usuario:** el estado se resuelve con `GLOT_STATE_DIR` → `XDG_STATE_HOME` → `~/.local/state/glot`, y `GLOT_STATE_FILE` gana a todo; el harness se aísla con esa variable.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 71 passed, 0 failed` (rc `0`); `get` de clave ausente → `1`; clave inválida y valor con salto de línea → `2`; `unset` repetido → `0`; `-n set lang lua` imprime `lang=lua` y no escribe; `stat -c '%a'` → `600` el fichero y `700` el directorio.
- **Snapshot:** [`versions/glot_0.4.0.sh`](../versions/glot_0.4.0.sh), archivado al abrir la v0.5.0.

## 0.5.0 — 2026-09-21 (viva)

- **Añade:** la **asignación** (L2) con `use <lenguaje> <fase>/<módulo> [tipo]`, que **sitúa el trabajo**: valida lenguaje, fase, módulo, tipo y árbol **sin tocar nada**, resuelve la especificación `docs/core/{fase}/{NN}_{Nombre}.md` y después **lee el estado y nunca lo fuerza**. Reconoce cuatro estados: **nuevo** (no existe la carpeta) → crea la rama desde `main`, la publica con `push -u origin` y crea la carpeta vacía; **en curso y limpio** (la rama ya existe) → la activa y la publica; **reanudar** (trabajo sin confirmar dentro del módulo) → no crea ni cambia nada y solo informa, republicando si ya estás en la rama; **cerrado** (limpio sobre `main` y sin rama) → con `tipo` explícito abre la rama de mantenimiento desde `main`; sin él avisa y sugiere. En todos los casos escribe las seis claves del sprint (`lang`, `phase`, `module`, `branch`, `spec`, `repo`) e imprime la ruta absoluta del módulo en stdout.
- **Contrato:** `2` para uso incorrecto (argumentos, tipo no permitido, opción desconocida), `1` para entorno o dato ausente (lenguaje fuera de `.gitmodules`, especificación ausente, submódulo sin inicializar, cambios sin confirmar **fuera** del directorio del módulo, rama no creable o no publicable) y `3` si el estado no se puede escribir (avisando de que el módulo y la rama ya quedaron preparados). No hace commits, ni `git add`, ni esqueleto, ni toca el monorepo.
- **Estados del sprint:** el directorio del módulo **no** cuenta como suciedad ajena; dentro de él, un árbol sucio es el estado normal de un sprint a medias (fin de jornada, corte de luz, implementación incompleta). Por eso **con trabajo sin confirmar `use` nunca crea ni cambia de rama**: reanudar es su caso principal, no un error. Reanudar sobre la rama del módulo republica con `-u` lo que quedó local (el `push` no toca el árbol de trabajo).
- **`tipo`:** por defecto `feat`, que es el de la rama propia del módulo. Por eso, con el módulo **ya cerrado**, hay que indicarlo: así no se resucita una rama `feat` fantasma. Con el módulo **nuevo** el valor por defecto se aplica sin preguntar.
- **`-n/--dry-run`:** imprime el plan completo sin tocar el repositorio ni el estado: la rama desde `main`, el `push -u` y la creación de la carpeta para un módulo nuevo; la activación y el `push -u` para un módulo en curso; nada para un reanudar; y la rama de mantenimiento para un módulo cerrado con `tipo`.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 158 passed, 0 failed` (rc `0`), con un sandbox de git propio (monorepo falso con `.gitmodules`, especificación y un submódulo `php` con remoto desnudo) para que `use` cree la rama desde `main`, la publique con upstream y genere la carpeta en un módulo nuevo, active una rama existente, abra una de mantenimiento en un módulo cerrado y respete el trabajo sin confirmar, sin salir del directorio temporal ni tocar la red. Ensayo real sobre el monorepo: `./scripts/glot.sh -n use php algorithms/naive_sort` → aviso de módulo existente, activación de `feat/algorithms/naive-sort` y estado intacto; `./scripts/glot.sh -n use php algorithms/naive_sort test` → plan de la rama de mantenimiento `test/algorithms/naive-sort` desde `main`.
- **Snapshot:** se archivará en `versions/glot_0.5.0.sh` al cerrar la versión.

---

## 🔖 Convención de archivado / Archiving convention

- **SemVer** `MAJOR.MINOR.PATCH`; el número vive en el encabezado de [`glot.sh`](../glot.sh) y en la tabla de este documento (desde v0.3.0 también en `glot version`).
- **Cierre de versión:** copiar `glot.sh` a `versions/glot_<versión>.sh`, marcar la fila del log como `✅` y empezar la versión siguiente en `glot.sh`.
- Los snapshots de `versions/` **no se editan**: son la foto de cómo estaba el script en esa versión y permiten ver la progresión.
- `versions/` contiene [`glot_0.1.0.sh`](../versions/glot_0.1.0.sh), [`glot_0.2.0.sh`](../versions/glot_0.2.0.sh) y [`glot_0.3.0.sh`](../versions/glot_0.3.0.sh).
- Cada versión se cierra en su propia rama `chore/repo/glot-v0.X` antes de fusionarla en `main` (ver [`README.md`](../README.md)).

---

## ✅ Definition of Done de una versión / Per-version Definition of Done

- [ ] `bash -n scripts/glot.sh scripts/tests/glot_test.sh` sin salida.
- [ ] Harness en verde (`glot tests: N passed, 0 failed`, rc `0`).
- [ ] Salidas reales capturadas y documentadas (sin editar).
- [ ] `scripts/README.md` y los documentos de `scripts/docs/` al día.
- [ ] Snapshot copiado a `versions/glot_<versión>.sh` y fila del log marcada `✅`.
- [ ] Rama `chore/repo/glot-v0.X` fusionada en `main`.
- [ ] `git diff --check` sin errores y sin `push` ni `commit` hechos por el agente.

---

## ✅ Requisitos / Requirements

| Herramienta | Uso | Verificación |
|-------------|-----|--------------|
| Bash 5.2 | Ejecutar `glot.sh` y, desde v1.0.0, cargarlo con `source` | `bash --version` |
| Git 2.43 | Desde v0.3.0: `doctor` resuelve la raíz con `git rev-parse --show-superproject-working-tree`; desde v0.5.0, `use` prepara y publica ramas | `git --version` |
| coreutils y util-linux | Desde v0.4.0: el almacén usa `mktemp`, `mv`, `chmod` y `flock` | `mktemp --version`, `flock --version` |
| GNU coreutils (`stat -c`) | Solo para el harness: comprueba los permisos `600`/`700` | `stat --version` |
| GitHub Copilot CLI 1.0.86 (opcional) | Validador automático de `validate` (v0.10.0) | `copilot --version` |

---

## 🧪 Cómo verificar / How to verify

```bash
bash -n scripts/glot.sh              # sintaxis
./scripts/tests/glot_test.sh        # contrato, verbos, estado, use y códigos (158 comprobaciones)
./scripts/glot.sh doctor            # diagnóstico del entorno
./scripts/glot.sh -n use php algorithms/naive_sort   # ensayo de `use`: plan sin tocar nada

# Estado en un directorio propio, sin tocar el del usuario / state in its own dir
export GLOT_STATE_DIR=$(mktemp -d)
./scripts/glot.sh set lang php      # set: lang (stderr)
./scripts/glot.sh get lang          # php
./scripts/glot.sh list              # lang=php
```

`shellcheck` no está instalado en este entorno; conviene añadirlo a la verificación cuando exista CI.
