---
layout: default
title: Auditoría 07 — Data Structures Advanced
nav_exclude: true
---

# Auditoría de Módulo: 07_Data_Structures_Advanced
# Module Audit: 07_Data_Structures_Advanced

Registro del primer barrido del módulo `07_Data_Structures_Advanced`, homologado
en el roadmap a `50/50`.
/ Record of the first sweep of module `07_Data_Structures_Advanced`, homologated
in the roadmap at `50/50`.

- **Especificación vigente / Current specification:** [`07_Data_Structures_Advanced.md`](../core/algorithms/07_Data_Structures_Advanced.md)
- **Guía de implementación / Implementation guide:** [`07_Data_Structures_Advanced.md`](../implementations/07_Data_Structures_Advanced.md)
- **Encargo de corrección / Correction request:** [`07_Data_Structures_Advanced.prompt.md`](../refactor/07_Data_Structures_Advanced.prompt.md)
- **Convención / Convention:** [`README.md`](README.md)
- **Escala / Scale:** [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Severidad / Severity:** [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md)
- **Estado / Status:** **pase ejecutado (primer barrido)**; contrato resuelto el 2026-11-22 (se mantiene el orden creciente); 9 hallazgos 🟡/🟠 con `align` planificado, 6 alineados y 41 lenguajes 🟢 (lote 1 cerrado: `java`, `csharp`, `groovy`, `haxe`, `crystal`, `ruby`) / **pass run (first sweep)**; contract settled on 2026-11-22 (ascending order stays); 9 🟡/🟠 findings with a planned `align`, 6 aligned and 41 languages 🟢 (batch 1 closed)
- **Última verificación / Last verification:** 2026-11-22

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** El pase comprueba dos capas: la especificación vigente y sus límites de
complejidad, y los nueve ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md).
La propuesta siguiente **no sustituye** la especificación: primero debe revisarse
el contrato y sus fuentes dependientes; hasta entonces no se califica una
implementación como incumplidora de la propuesta.

**EN:** The pass checks two layers: the current specification and its complexity
limits, and the nine idiomaticity axes. The proposal below does **not replace**
the specification: the contract and dependent sources must first be revised;
until then, an implementation is not classified as failing the proposal.

### Cambio propuesto / Proposed change

**ES:** El autor propone que la adyacencia represente vecinos como nodos
`GraphNode`, que los vecinos se conserven en orden de inserción y que
`get_neighbors` devuelva sus identificadores enteros en una secuencia tipo
array/lista, adaptada al lenguaje. No se ordena por valor. Una arista repetida
no mueve el vecino ni incrementa el contador. La salida no expone nodos ni
permite modificar el grafo; una salida anterior conserva su valor.

**EN:** The author proposes representing adjacency as `GraphNode` neighbours,
preserving neighbour insertion order, and returning their integer identifiers
from `get_neighbors` in an array/list-like sequence adapted to the language.
Values are not sorted. A repeated edge does not move the neighbour or increase
the count. The result does not expose nodes or allow graph mutation; a previous
result retains its value.

**ES:** El Software Architect y el Computer Scientist deben precisar la
representación para mutabilidad, ciclos y lenguajes inmutables, y actualizar
contrato, pseudocódigo, ejemplos, casos y complejidades sin presuponer que
referencias mutables sean posibles en todos los lenguajes. Si una adaptación
no preserva la intención o la cota, se consulta al autor. No se añade una
operación para listar todos los vértices sin decisión separada.

**EN:** The Software Architect and Computer Scientist must specify the
representation for mutability, cycles and immutable languages, and update the
contract, pseudocode, examples, cases and complexity without assuming mutable
references are available everywhere. If an adaptation cannot preserve the
intent or bound, consult the author. Do not add a vertex-listing operation
without a separate decision.

**ES:** Mientras la propuesta no se integre, este barrido clasifica contra la
especificación **vigente** —vecinos en orden creciente y búsqueda, detección de
duplicados e inserción ordenada escritas a mano—, que es lo que declara la capa
del módulo en [`README.md`](README.md#-alcance-por-módulo--scope-per-module).

**EN:** Until the proposal is integrated, this sweep classifies against the
**current** specification —ascending neighbours and hand-written search,
duplicate detection and ordered insertion—, which is what the module layer in
[`README.md`](README.md#-alcance-por-módulo--scope-per-module) declares.

### Comprobaciones / Checks

| # | Comprobación / Check | Evidencia / Evidence |
|---|---|---|
| 1 | `TreeNode` y ABB / `TreeNode` and BST | Operaciones del contrato, duplicados idempotentes y descenso `O(h)` en los 50 / Contract operations, idempotent duplicates and `O(h)` descent in all 50 |
| 2 | Registro y adyacencia / Registry and adjacency | Registro enlazado propio y búsqueda por etiqueta recorrida; representación de vecinos declarada en cada README / Own linked registry with traversed label lookup; neighbour representation declared in each README |
| 3 | Orden y duplicados / Order and duplicates | Con el contrato vigente, `70, 30, 50` repetido `30` → `[30, 50, 70]` y 3 aristas; con la propuesta, `[70, 30, 50]` y 3 aristas. La suite de los 50 verifica hoy la primera forma / Under the current contract, `70, 30, 50` with `30` repeated → `[30, 50, 70]` and 3 edges; under the proposal, `[70, 30, 50]` and 3 edges. All 50 suites verify the first form today |
| 4 | Semántica del grafo / Graph semantics | Aislados, dirección, bucles, extremos inexistentes, contadores y fallo sin mutación / Isolated vertices, direction, loops, missing endpoints, counts and non-mutating failure |
| 5 | Salida y aislamiento / Output and isolation | Secuencia de enteros, vacío distinto de fallo, copia o valor inmutable estable / Integer sequence, empty distinct from failure, stable copy or immutable value |
| 6 | Complejidad / Complexity | Código y README frente a `O(h)` y `O(V + d(u))` / Code and README against `O(h)` and `O(V + d(u))` |
| 7 | Idiomaticidad, suite y README | Nueve ejes aplicables, suite nativa en verde y README N3 en los 50 / Nine applicable axes, native suite green and N3 README in all 50 |

**ES:** Las comprobaciones 2, 3 y 5 siguen sujetas a la revisión del contrato
propuesto; no autorizan contradecir la especificación vigente.

**EN:** Checks 2, 3 and 5 remain subject to the proposed contract's review; they
do not override the current specification.

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|---|---|---|
| 1. Barrido léxico / Lexical scan | Fuentes rastreadas del módulo en los 50 submódulos, sin suites ni artefactos / Tracked module sources in the 50 submodules, excluding suites and artifacts | ✅ 50/50 auditados; 28 coincidencias reales en 15 lenguajes / 50/50 scanned; 28 real hits in 15 languages |
| 2. Lectura / Code review | Las coincidencias del paso 1 más constructor, nombres, indicador de fallo, acceso, encapsulamiento y complejidad / Step 1's hits plus constructor, names, failure indicator, access, encapsulation and complexity | ✅ 15 lenguajes leídos en su camino de adyacencia / 15 languages read in their adjacency path |
| 3. Suites / Test suites | `glot test {lang} algorithms/data_structures_advanced` en los 50 / in all 50 | ✅ 50/50 en verde / 50/50 green |
| 4. Documentación / Documentation | README N3 del módulo en cada submódulo / N3 module README in each submodule | ✅ 50/50 con README presente / 50/50 have a README |
| 5. Árboles / Worktrees | `git -C {lang} status --short` en los 50 / in all 50 | ✅ 50/50 limpios / 50/50 clean |

**ES:** El barrido usó **solo archivos rastreados por `git ls-files`**, lo que
descarta `target/`, `node_modules/`, `.build/`, `zig-out/`, `dist/` y el resto de
artefactos. Ninguna salida de este registro se ha inventado: el detalle por
comando está en el registro de verificaciones.

**EN:** The sweep used **only files tracked by `git ls-files`**, which filters
out `target/`, `node_modules/`, `.build/`, `zig-out/`, `dist/` and the remaining
artifacts. No output in this record is invented: the per-command detail is in the
verification log.

## Puerta de contrato / Contract gate

**ES:** **Resuelta el 2026-11-22.** El autor confirma el **contrato vigente**:
los vecinos siguen en **orden creciente** porque la especificación y la guía ya
lo fijan, así que este barrido no necesita `correct` ni `fix`: los quince
hallazgos se cierran con **`align`**, que no toca especificación ni suite. La
propuesta de vecinos como nodos en orden de inserción **queda descartada** para
este pase.

**EN:** **Resolved on 2026-11-22.** The author confirms the **current contract**:
neighbours stay in **ascending order** because the specification and the guide
already fix it, so this sweep needs neither `correct` nor `fix`: the fifteen
findings close with an **`align`** that touches neither specification nor suite.
The node-neighbour proposal in insertion order is **discarded** for this pass.

**ES:** Criterios acordados con el autor para el `align` de los 15:

1. **Nada de `sort` de biblioteca.** El orden creciente se consigue con
   **inserción ordenada escrita a mano**; si algún lenguaje no estableciera el
   orden en su documentación, se dejaría el orden de agregado —aquí sí está
   establecido, así que se mantiene ascendente.
2. **Estructura de vecinos libre** según el lenguaje: array, lista o cola, la
   que mejor se ajuste, siempre que recorrido, detección de duplicado e
   inserción ordenada sean manuales. Se pueden reutilizar funciones, métodos o
   helpers de estructuras ya construidas en módulos anteriores; el **recorrido
de búsqueda es manual**.
3. **Listas inmutables o enlazadas** pueden **anteponer** internamente; la
   salida observable sigue siendo ascendente y la adaptación se documenta.
4. **Prolog**: predicado recursivo propio; `member/2` es hallazgo.
5. **Documentación dentro de la rama `align`**: comentarios del código y README
   N3 cuando cambie la estructura o la complejidad.
6. **Un commit por paso y sin push**: suite (solo si cambia), código, README,
   acta; más el commit del puntero en el monorepo. El push lo decide el autor.

**EN:** Criteria agreed with the author for the fifteen aligns: no library
`sort` (ascending order via hand-written ordered insertion; insertion order only
where the language's documentation does not fix the order — here it does); free
neighbour storage per language (array, list or queue) as long as traversal,
duplicate detection and ordered insertion are manual, reusing helpers from
structures built in earlier modules but with a **manual search traversal**;
immutable or linked lists may **prepend** internally while the observable output
stays ascending, documented as an adaptation; Prolog uses its own recursive
predicate; documentation lives inside the `align` branch; and one commit per
step with no push.

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- — Ninguno: las 50 suites nativas están en verde y ningún hallazgo cambia el
  comportamiento observable / None: all 50 native suites are green and no finding
  changes observable behaviour.

### 🟡 Advertencias / Warnings

**ES:** La detección del vecino repetido, que la especificación vigente exige
escrita a mano, se delega en una operación de pertenencia de la biblioteca
(`contains`, `includes`, `indexOf`, `member`, `List.mem`, `elem`, `include?`…).
La inserción ya es manual y ordenada y el resultado observable coincide con el
contrato; la desviación es de **fidelidad al módulo**, no de salida.

**EN:** Duplicate-neighbour detection, which the current specification requires
hand-written, is delegated to a library membership operation (`contains`,
`includes`, `indexOf`, `member`, `List.mem`, `elem`, `include?`…). Insertion is
already manual and sorted and the observable result matches the contract; the
deviation is in **module fidelity**, not in output.

| Lenguaje / Language | Evidencia / Evidence | Severidad / Severity |
|---|---|---|
| `elm` | `DataStructuresAdvanced.elm:300,324` — `List.member` | 🟡 |
| `erlang` | `data_structures_advanced.erl:167,187` — `lists:member` | 🟡 |
| `fsharp` | `DataStructuresAdvanced.fs:141,156` — `List.contains` | 🟡 |
| `gleam` | `data_structures_advanced.gleam:227,248` — `list.contains` | 🟡 |
| `haskell` | `DataStructuresAdvanced.hs:139,154` — `` v `elem` neighbours `` | 🟡 |
| `ocaml` | `graph.ml:134,144` — `List.mem v u_vertex.neighbors` | 🟡 |
| `prolog` | `data_structures_advanced.pl:124,149` — `member(To, Neighbors)` | 🟡 |
| `rust` | `graph.rs:78` — `u_vertex.neighbors().contains(&v)` | 🟡 |
| `javascript` | `Graph.js:57,75` — `neighbors.includes(v)`; `Graph.js:87` — `[...].sort((a, b) => a - b)` | 🟠 |

**ES:** `javascript` lleva además una **ordenación de biblioteca** en el camino
de salida de `getNeighbors`, que es una decisión de diseño delegada y por eso se
registra 🟠 (estructural). Los otros catorce son 🟡: el paso delegado es idéntico
en coste asintótico y en resultado.

**EN:** `javascript` also carries a **library sort** in `getNeighbors`' output
path, a delegated design decision, hence 🟠 (structural). The other fourteen are
🟡: the delegated step is identical in asymptotic cost and result.

### 🔵 Aceptados por el autor / Accepted by the author

- — Ninguno: no hay desviaciones aceptadas por escrito todavía; las 15
  advertencias de arriba esperan a la puerta de contrato y su ruta (`align` o
  `correct`+`fix`) / None: no deviations accepted in writing yet; the 15
  warnings above wait for the contract gate and its route (`align` or
  `correct`+`fix`).

### 🟢 Homologados / Homologated

- **41 lenguajes**: `ada`, `assembly`, `ballerina`, `c`, `clojure`, `cobol`,
  `common-lisp`, `cpp`, `crystal`, `csharp`, `d`, `dart`, `elixir`, `forth`, `go`,
  `grain`, `groovy`, `haxe`, `java`, `julia`, `kotlin`, `lua`, `nim`, `perl`,
  `php`, `purescript`, `python`, `r`, `racket`, `raku`, `rescript`, `rexx`,
  `ruby`, `scala`, `scheme`, `swift`, `tcl-tk`, `typescript`, `v`, `vala`, `zig`

**ES:** 🟢 significa que el barrido léxico no encontró ninguna búsqueda ni
ordenación de biblioteca en el camino de adyacencia, la suite nativa está en
verde y el README N3 existe. `lua`, `r` y `v` registran recorridos manuales con
`ipairs`/`for … in`; `scala`, `swift`, `typescript`, `vala`, `zig`, `tcl-tk`,
`scheme` y `raku` tienen la búsqueda y la inserción escritas a mano, como
declaran sus cabeceras.

**EN:** 🟢 means the lexical scan found no library search or sort in the
adjacency path, the native suite is green and the N3 README exists. `lua`, `r`
and `v` show manual walks with `ipairs`/`for … in`; `scala`, `swift`,
`typescript`, `vala`, `zig`, `tcl-tk`, `scheme` and `raku` have search and
insertion written by hand, as their headers declare.

## Deuda por lenguaje / Debt per language

**ES:** El contrato está resuelto: los quince hallazgos se cierran con `align`
(búsqueda manual, sin tocar especificación, suite ni salida observable). El
eje bloqueante se deja en `-` porque ninguno de los nueve ejes baja —la cota y
la salida no cambian—: la desviación es de la **capa del módulo** («se desvía de
la fidelidad algorítmica», 🟡) y así se anota en el estado.

**EN:** The contract is settled: all fifteen findings close with `align`
(hand-written search, touching neither specification, suite nor observable
output). The blocking axis is left as `-` because none of the nine axes drops —
bound and output do not change — the deviation belongs to the **module layer**
(“deviates from algorithmic fidelity”, 🟡) and is recorded as such in the state.

| Lenguaje / Language | Hallazgo / Finding | Ruta / Route |
|---|---|---|
| `csharp` | `List.Contains` en `HasEdge` | ✅ cerrado en `00de948`: `HasNeighbor` recorre la lista / closed: `HasNeighbor` scans the list |
| `crystal` | `includes?` en `has_edge` | ✅ cerrado en `e3913de`: `has_neighbor` recorre el array / closed: `has_neighbor` scans the array |
| `elm` | `List.member` en alta y consulta | `align` — recursión propia sobre la lista / own recursion |
| `erlang` | `lists:member` en alta y consulta | `align` — recursión propia / own recursion |
| `fsharp` | `List.contains` en alta y consulta | `align` — recursión propia / own recursion |
| `gleam` | `list.contains` en alta y consulta | `align` — recursión propia / own recursion |
| `groovy` | `contains` en alta y consulta | ✅ cerrado en `b400ed7`: `hasNeighbor` recorre la lista / closed: `hasNeighbor` scans the list |
| `haskell` | `` `elem` `` en alta y consulta | `align` — función propia sobre la lista / own list function |
| `haxe` | `indexOf` en alta y consulta | ✅ cerrado en `cfa2ee9`: `hasNeighbor` recorre el array / closed: `hasNeighbor` scans the array |
| `java` | `contains` en alta y consulta | ✅ cerrado en `715ef35`: `hasNeighbor` recorre la adyacencia / closed: `hasNeighbor` scans the adjacency |
| `javascript` | `includes` en alta y consulta; `sort` en la salida | `align` — bucle propio e inserción ordenada manual / own loop and manual sorted insertion |
| `ocaml` | `List.mem` en alta y consulta | `align` — recursión propia / own recursion |
| `prolog` | `member/2` en alta y consulta | `align` — recorrido propio / own traversal, si el contrato lo permite |
| `ruby` | `include?` en alta y consulta | ✅ cerrado en `351a260`: `has_neighbor?` recorre el array / closed: `has_neighbor?` scans the array |
| `rust` | `slice::contains` en `has_edge` | `align` — recorrido propio / own traversal |

**ES:** Los quince hallazgos son de la **capa del módulo** y anteriores a la
propuesta de contrato: si el autor integra el cambio propuesto (orden de
inserción, sin ordenar), la mitad de ellos cambia de criterio y la corrección
ya no es un `align` sino `correct` + `fix` sobre el contrato nuevo. Por eso el
plan los deja **abiertos** hasta que el contrato se resuelva.

**EN:** The fifteen findings belong to the **module layer** and predate the
contract proposal: if the author integrates the proposed change (insertion order,
no sorting), half of them change criteria and the fix is no longer an `align` but
`correct` + `fix` against the new contract. That is why the plan leaves them
**open** until the contract is resolved.

## Plan de cierre / Closure plan

**ES:** Cinco fases, un commit por paso y **sin push** (el push lo decide el
autor). Detalle en el plan de trabajo de la sección siguiente.

1. **Reconocimiento por lenguaje / Per-language reconnaissance:** en la raíz,
   `git status --short` y `git submodule status`; en `{lang}`, rama, `HEAD` y
   suite inicial con su resultado real; se registra antes de tocar nada / in the
   root, `git status --short` and `git submodule status`; in `{lang}`, branch,
   `HEAD` and the initial suite with its real result, recorded before touching
   anything.
2. **Rama / Branch:** `git -C {lang} switch -c
   align/algorithms/data-structures-advanced main` / from the submodule's `main`.
3. **Adecuación / Fix:** búsqueda manual del vecino repetido y orden creciente
   por inserción manual, sin `sort` ni pertenencia de biblioteca; estructura de
   vecinos la que mejor encaje (array, lista o cola); anteponer solo si se
   documenta y la salida sigue ascendente; Prolog con predicado propio /
   hand-written duplicate lookup and ordered insertion, no `sort` or library
   membership; neighbour storage as best fits; prepending only when documented
   and the output stays ascending; Prolog with its own predicate.
4. **Verificación / Verification:** `glot test {lang}` y `glot verify {lang}` en
   verde; `glot evidence {lang} algorithms/data_structures_advanced` regenerada /
   green, evidence record regenerated.
5. **README y estado / README and state:** README N3 al día **si cambió la
   estructura o la complejidad**; al integrar, la fila del TSV sube con el
   commit del submódulo / N3 README updated **if structure or complexity
   changed**; on integration the TSV row moves up with the submodule commit.
6. **Integración / Integration:** merge en el `main` del submódulo y, en el
   monorepo, `glot pointer` + `glot save 9` en la rama `audit/...` / merge into
   the submodule's `main`, then `glot pointer` + `glot save 9` on the
   `audit/...` branch.
7. **Cierre / Closure:** el pase cierra cuando los 50 están 🟢 o con desviación
   aceptada por escrito en `ruleset/idioms/{lang}.md`; lo decide el autor /
   the pass closes when all 50 are 🟢 or have a written accepted deviation in
   `ruleset/idioms/{lang}.md`; the author decides.

## Plan de trabajo del `align` / Align work plan

**ES:** Los quince lenguajes se agrupan por familia para revisarlos en lotes
homogéneos y mantener los `align` **sincronizados** —misma secuencia de pasos y
misma lista de comprobación—, no necesariamente simultáneos.

**EN:** The fifteen languages are grouped by family so they can be reviewed in
homogeneous batches and kept **synchronised** — same step sequence and same
checklist — rather than simultaneous.

| Lote / Batch | Lenguajes / Languages | Familia / Family |
|---|---|---|
| 1 | `java`, `csharp`, `groovy`, `haxe`, `crystal`, `ruby` | F1/F2/F8: OO y scripting dinámico con colección mutable |
| 2 | `haskell`, `elm`, `ocaml`, `fsharp`, `gleam`, `rust` | F4/F5: sistemas y ML, con opción nativa y listas inmutables |
| 3 | `erlang`, `prolog` | F7/F9: BEAM y lógico |
| 4 | `javascript` | F2 con `sort` de biblioteca en la salida |

**ES:** Lista de comprobación idéntica en cada lenguaje (es la que decide si el
`align` está terminado):

| # | Comprobación / Check |
|---|---|
| 1 | `grep` del camino de adyacencia sin `sort`, `sorted`, `contains`, `includes`, `indexOf`, `member`, `elem`, `List.mem`, `List.contains`, `list.contains`, `includes?`, `include?` |
| 2 | Orden creciente por inserción manual; el caso `70, 30, 50` repetido `30` devuelve `[30, 50, 70]` y tres aristas |
| 3 | Estructura de vecinos declarada en el README del módulo, con la adaptación si se antepone |
| 4 | Duplicados idempotentes, aristas dirigidas, bucles, extremos inexistentes, contadores y aislamiento de la salida |
| 5 | `glot test` y `glot verify` en verde, acta regenerada, un commit por paso, sin push |

**ES:** Orden de commits por lenguaje en la rama `align`, sin push:

1. `fix(algorithms): align data_structures_advanced with the audit` (código y
   comentarios) — **un commit por paso**;
2. `docs(algorithms): update data_structures_advanced README after the align`
   (solo si cambia estructura o complejidad);
3. `chore(algorithms): refresh data_structures_advanced evidence` (acta);
4. en el monorepo, el puntero del submódulo en la rama `audit/...`.

**EN:** Commit order per language on the `align` branch, no push: `fix(algorithms):
align data_structures_advanced with the audit` (code and comments), then
`docs(algorithms): update data_structures_advanced README after the align` only
when structure or complexity changes, then
`chore(algorithms): refresh data_structures_advanced evidence`, and finally the
submodule pointer commit on the monorepo's `audit/...` branch.

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando o fuente / Command or source | Resultado / Result |
|---|---|---|---|
| 2026-11-22 | Requisito de apertura / Opening requirement | `grep` de `docs/ROADMAP.md` | `core.algorithms.data_structures_advanced ✅ 50/50` con los 50 lenguajes listados / with all 50 languages listed |
| 2026-11-22 | Inventario por lenguaje / Per-language inventory | `git -C {lang} ls-files core/algorithms/data_structures_advanced`, `test -f …/README.md`, `git -C {lang} status --short` | 50/50 con README N3 y árbol limpio; entre 4 y 18 archivos rastreados por lenguaje / 50/50 with N3 README and clean tree; 4–18 tracked files per language |
| 2026-11-22 | Barrido léxico de búsqueda y orden / Search and sort lexical scan | `grep -nE` de `contains|includes|indexOf|member|elem|List.mem|in_array|sort|sorted` sobre fuentes rastreadas, excluyendo suites y artefactos / over tracked sources, excluding suites and artifacts | 28 coincidencias reales en 15 lenguajes; 35 lenguajes sin coincidencias / 28 real hits in 15 languages; 35 languages with no hits |
| 2026-11-22 | Lectura del camino de adyacencia / Adjacency path reading | Lectura de `addEdge`/`hasEdge`/`neighbors` en los 15 lenguajes señalados / reading of the three operations in the 15 flagged languages | Inserción ordenada manual en los 15; la búsqueda del duplicado delegada; `javascript` además ordena con `sort` / manual sorted insertion in all 15; duplicate lookup delegated; `javascript` also sorts with `sort` |
| 2026-11-22 | Suites nativas / Native suites | `glot test {lang} algorithms/data_structures_advanced` (50 ejecuciones) | **50/50 en verde**: p. ej. `ada` 0 fallos, `assembly` 23, `c` 153, `clojure` 19 tests/159 aserciones, `elixir` 24, `erlang` 24, `fsharp` 24, `forth` 180, `grain` 102, `julia` 137, `php` 23, `python` 23, `racket` 158, `ruby` 23 / **50/50 green** |
| 2026-11-22 | Documentación / Documentation | `test -f {lang}/core/algorithms/data_structures_advanced/README.md` | 50/50 presentes / 50/50 present |
| 2026-11-22 | Estado del árbol / Worktree state | `git -C {lang} status --short` | 50/50 sin cambios locales / 50/50 with no local changes |
| 2026-11-22 | `align` de `java` / `java` align | `mvn test` + `glot evidence java algorithms/data_structures_advanced` | Rama `align/algorithms/data-structures-advanced`: `c65e7f8` (código), `7eed001` (README), merge `715ef35`; 23 tests, 0 fallos; verificador `-` (no declarado) / branch, code commit, README commit, merge; 23 tests, 0 failures; verifier `-` (not declared) |

| 2026-11-22 | `align` de `csharp` / `csharp` align | `dotnet test` + `glot evidence csharp algorithms/data_structures_advanced` | Rama `align/algorithms/data-structures-advanced`: un commit de código y merge `00de948`; suite en verde; README sin cambios / one code commit and merge; suite green; README unchanged |
**ES:** El pase **no cierra** con este barrido: quedan 15 hallazgos por resolver
| 2026-11-22 | `align` de `groovy` / `groovy` align | `./gradlew test` + `glot evidence groovy algorithms/data_structures_advanced` | Rama `align/algorithms/data-structures-advanced`: un commit de código y merge `b400ed7`; suite en verde; README sin cambios / one code commit and merge; suite green; README unchanged |
o aceptar, y la propuesta de contrato del autor puede cambiar su criterio.
| 2026-11-22 | `align` de `haxe` / `haxe` align | `haxe build.hxml` + `glot evidence haxe …` | Rama `align/…`: un commit de código y merge `cfa2ee9`; suite en verde / one code commit and merge; suite green |
| 2026-11-22 | `align` de `crystal` / `crystal` align | `crystal spec` + `glot evidence crystal …` | Rama `align/…`: un commit de código y merge `e3913de`; 23 ejemplos, 0 fallos / one code commit and merge; 23 examples, 0 failures |
| 2026-11-22 | `align` de `ruby` / `ruby` align | `bundle exec rspec` + `glot evidence ruby …` | Rama `align/…`: un commit de código y merge `351a260`; 23 ejemplos, 0 fallos / one code commit and merge; 23 examples, 0 failures |
**EN:** The pass **does not close** with this sweep: 15 findings remain to be
fixed or accepted, and the author's contract proposal may change their criteria.
