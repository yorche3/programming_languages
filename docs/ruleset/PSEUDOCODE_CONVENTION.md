# 🧭 Convención de Pseudocódigo / Pseudocode Convention

> **ES:** Este documento define el **contrato canónico** del monorepo: cómo se escribe el pseudocódigo de cada módulo y cómo se traduce a cada lenguaje. El pseudocódigo **no es un lenguaje**, es la **especificación del comportamiento esperado**, expresada en el paradigma dominante de la familia del lenguaje. Los nombres que aparecen en él son **conceptuales**; cada lenguaje los traduce idiomáticamente. Este documento es la pieza bloqueante de la auditoría: sin él no se puede verificar si una implementación es correcta.
>
> **EN:** This document defines the monorepo's **canonical contract**: how the pseudocode of each module is written and how it translates to each language. The pseudocode **is not a language**, it is the **specification of expected behavior**, expressed in the dominant paradigm of the language family. The names in it are **conceptual**; each language translates them idiomatically. This document is the blocking piece of the audit: without it, an implementation cannot be verified as correct.

---

## 🎯 Principio / Principle

**ES:** El pseudocódigo describe el **qué** (contrato observable, complejidad, invariantes), no el **cómo** (sintaxis, nombres, librerías). Es **agnóstico al lenguaje pero consciente del paradigma**: no se escribe igual una pila en Haskell que en C#.

**EN:** The pseudocode describes the **what** (observable contract, complexity, invariants), not the **how** (syntax, names, libraries). It is **language-agnostic but paradigm-aware**: a stack in Haskell and a stack in C# are not written the same way.

**ES:** Un mismo módulo puede tener **una o más variantes de pseudocódigo**. Cada variante corresponde a una **familia de paradigma**, no a un lenguaje concreto. La especificación del módulo (`{module}.md`) declara **cuál variante** aplica a cada lenguaje.

**EN:** A single module may have **one or more pseudocode variants**. Each variant corresponds to a **paradigm family**, not a specific language. The module spec (`{module}.md`) declares **which variant** applies to each language.

---

## 🧬 Variantes de pseudocódigo / Pseudocode variants

**ES:** Hay **cuatro variantes canónicas**. Un módulo debe declarar en su especificación cuál(es) usa.

**EN:** There are **four canonical variants**. A module must declare in its spec which one(s) it uses.

### V1 — Mutable / Imperativo / OO

**ES:** Para lenguajes con mutación in-place y estado mutable. El constructor crea la instancia, los métodos operan sobre `this`, las operaciones devuelven `void` o el valor, y la ausencia se representa con el mecanismo nativo (`null`, `nil`, `None`, sentinel documentado).

**EN:** For languages with in-place mutation and mutable state. The constructor creates the instance, methods operate on `this`, operations return `void` or the value, and absence uses the language's native mechanism (`null`, `nil`, `None`, documented sentinel).

```pseudocode
type Node
    value
    next

    init(value)
        this.value = value
        this.next  = absent
        return this

    get_value() = return this.value
    get_next()  = return this.next
    set_next(n)
        this.next = n
        return this
```
Aplica a / Applies to: ada, assembly, ballerina, c, cobol, cpp, crystal, csharp, d, dart, forth, go, groovy, haxe, java, javascript, julia, kotlin, lua, nim, perl, php, python, r, raku, rexx, ruby, rust, scala, swift, tcl-tk, typescript, v, vala, zig.
V2 — Inmutable / Funcional

ES: Para lenguajes donde los valores no se mutan: cada operación devuelve un valor nuevo. La ausencia se representa con Option/Maybe o el tipo suma del lenguaje. La operación "set" se reemplaza por with_* (copia modificada).

EN: For languages where values are not mutated: every operation returns a new value. Absence uses Option/Maybe or the language's sum type. The "set" operation becomes with_* (modified copy).
pseudocode

type Node
    value
    next  -- Maybe<Node>

    init(value) = return Node(value, absent)
    get_value(node) = return node.value
    get_next(node)  = return node.next
    with_next(node, n) = return Node(node.value, present(n))

Aplica a / Applies to: clojure, common-lisp, elixir, elm, erlang, fsharp, gleam, grain, haskell, ocaml, purescript, racket, rescript, scheme.
V3 — Mixto / Multi-paradigma

ES: Para lenguajes que permiten ambos estilos y donde el módulo elige una variante concreta (normalmente V1 si el objetivo es pedagogía imperativa, V2 si es demostrar el paradigma funcional del lenguaje). La decisión se documenta en el README del lenguaje.

EN: For languages allowing both styles and where the module chooses a concrete variant (usually V1 if the goal is imperative pedagogy, V2 if it is to showcase the language's functional paradigm). The decision is documented in the language README.

Aplica a / Applies to: rust, scala, swift, cpp, nim (clase transversal: cada uno implementa **V1**; no se exploran variantes).
V4 — Lógico / Declarativo

ES: Para lenguajes basados en unificación y backtracking. No hay constructores ni métodos: hay hechos y reglas. La operación "init" se expresa como un hecho; "get" como una regla que unifica el campo.

EN: For languages based on unification and backtracking. There are no constructors or methods: there are facts and rules. "init" is a fact; "get" is a rule that unifies the field.
pseudocode

node(Value, Next).
node_init(Value, node(Value, absent)).
node_value(node(V, _), V).
node_next(node(_, N), N).
node_with_next(node(V, _), N, node(V, present(N))).

Aplica a / Applies to: prolog.

### 📊 Cobertura de los 50 lenguajes / Coverage of the 50 languages

> **ES:** Alcance **técnico**: este documento define cómo se escribe el pseudocódigo y cómo se traduce a cada lenguaje para que la implementación sea idiomática. Lo firma **Software Architect** (apoyo: *Language-Specific SME*). Los documentos de proceso, pedagogía o contenido visual quedan fuera de su alcance (ver [`AGENT_ROLES.md`](../AGENT_ROLES.md)).
>
> **EN:** **Technical** scope: this document defines how the pseudocode is written and how it translates to each language so the implementation is idiomatic. Signed by **Software Architect** (support: *Language-Specific SME*). Process, pedagogy, or visual-content documents are out of scope (see [`AGENT_ROLES.md`](../AGENT_ROLES.md)).

**ES:** Verificado contra los 50 submódulos (`.gitmodules`): **cada lenguaje implementa una sola variante**, sin explorar alternativas. El reparto por variante implementada es **35 V1 + 14 V2 + 1 V4 = 50**. V3 es una **clase transversal** (lenguajes multi-paradigma: rust, scala, swift, cpp, nim), que en este monorepo resuelven a **V1** y lo documentan en el README del lenguaje.

**EN:** Verified against the 50 submodules (`.gitmodules`): **each language implements a single variant**, with no alternatives explored. The distribution by implemented variant is **35 V1 + 14 V2 + 1 V4 = 50**. V3 is a **cross-cutting class** (multi-paradigm languages: rust, scala, swift, cpp, nim), which in this monorepo resolve to **V1** and document it in the language README.

| Variante / Variant | Nº | Lenguajes / Languages |
|---|:--:|---|
| V1 Mutable / Imperativo / OO | 35 | ada, assembly, ballerina, c, cobol, cpp, crystal, csharp, d, dart, forth, go, groovy, haxe, java, javascript, julia, kotlin, lua, nim, perl, php, python, r, raku, rexx, ruby, rust, scala, swift, tcl-tk, typescript, v, vala, zig |
| V2 Inmutable / Funcional | 14 | clojure, common-lisp, elixir, elm, erlang, fsharp, gleam, grain, haskell, ocaml, purescript, racket, rescript, scheme |
| V3 Mixto (clase transversal) | 5 | rust, scala, swift, cpp, nim — cada uno implementa **V1** |
| V4 Lógico / Declarativo | 1 | prolog |

### 🧩 Indicador de fallo: qué queda fuera / Failure indicator: what stays out

**ES:** Esta tabla es **de familia, no de lenguaje**: la decisión concreta vive en el README del lenguaje, que es donde se declara el indicador natural. Un lenguaje aparece **una sola vez**.

**EN:** This table is **per family, not per language**: the concrete decision lives in the language README, where the natural indicator is declared. Each language appears **exactly once**.
🔤 Nombres canónicos / Canonical names

ES: Los nombres del pseudocódigo son conceptuales. Cada lenguaje los traduce según sus convenciones. La siguiente tabla es la fuente de verdad.

EN: Pseudocode names are conceptual. Each language translates them according to its conventions. The following table is the source of truth.
Conceptos base / Base concepts
Concepto / Concept	Pseudocódigo / Pseudocode	Significado / Meaning
Constructor	init	Crea e inicializa una instancia / Creates and initializes an instance
Acceso lectura	get_X	Observa el valor del campo X sin mutarlo / Observes field X without mutating
Acceso escritura	set_X	Reemplaza el valor del campo X (V1) / Replaces field X (V1)
Acceso copia	with_X	Devuelve una copia con X reemplazado (V2) / Returns a copy with X replaced (V2)
Ausencia	absent	Representación de "no hay valor" / Representation of "no value"
Presencia	present(v)	Envuelve v como valor presente (V2) / Wraps v as a present value (V2)
Predicado vacío	is_empty	Verdadero si la estructura no tiene elementos / True if the structure has no elements
Tamaño	size	Número de elementos / Number of elements
Eliminar	delete	Elimina la primera aparición por valor / Removes the first occurrence by value
Insertar en cabeza	insert_head	Inserta al inicio / Inserts at the head
Insertar en cola	insert_tail	Inserta al final / Inserts at the tail
Apilar	push	Añade al tope (LIFO) / Adds on top (LIFO)
Desapilar	pop	Extrae el tope / Removes the top
Observar tope	peek	Observa el tope sin extraer / Observes top without removing
Encolar	enqueue	Añade al final de la cola (FIFO) / Adds to the rear (FIFO)
Desencolar	dequeue	Extrae del frente de la cola / Removes from the front
🗣️ Traducción por lenguaje / Translation per language

ES: La siguiente tabla muestra cómo se traduce cada concepto a cada uno de los 50 lenguajes. Esta tabla es la referencia para la auditoría: si una implementación no sigue su columna, es un hallazgo.

EN: The following table shows how each concept translates to each of the 50 languages. This table is the reference for the audit: if an implementation does not follow its column, it is a finding.

    Nota / Note: la columna size incluye el nombre alternativo cuando el lenguaje prefiere otro (ej. len en Rust, length en Haskell). La columna delete incluye el nombre alternativo cuando hay conflicto con keyword o con la BCL.

Lenguaje	constructor	acceder valor	mutar next	ausencia	predicado vacío	tamaño	eliminar
ada	Make / Create	función Value	Set_Next	null (access)	Is_Empty	Size	Delete
assembly	rutina Init	carga desde offset	store en offset	0 / registro nulo	comparación == 0	contador	búsqueda + store
ballerina	new / init	self.value	self.next = n	() (nil)	self.isEmpty()	self.size()	self.delete(v)
c	node_new(v)	node->value	node->next = n	NULL	list_is_empty(l)	list_size(l)	list_delete(l, v)
clojure	(->Node v nil) / make-node	(:value node)	(assoc node :next n)	nil	(empty? l)	(count l)	(remove ...)
cobol	INITIALIZE / MOVE	NODE-VALUE	MOVE n TO NODE-NEXT	NULL / espacios	IF COUNT = 0	NODE-COUNT	DELETE-NODE
common-lisp	(make-node :value v)	(node-value n)	(setf (node-next n) x)	nil	(node-empty-p l)	(node-size l)	(node-delete l v)
cpp	Node(v) / new Node(v)	node.value / node->value	node.next = n	nullptr / NULL	list.empty()	list.size()	list.delete(v)
crystal	Node.new(v)	node.value	node.next = n	nil	list.empty?	list.size	list.delete(v)
csharp	new Node(v)	node.Value	node.Next = n	null / int?	list.IsEmpty	list.Size / list.Count	list.Delete(v) / Remove
d	Node(v) / new Node(v)	node.value	node.next = n	null	list.isEmpty	list.size	list.remove(v) (keyword)
dart	Node(v)	node.value	node.next = n	null	list.isEmpty	list.size	list.delete(v)
elixir	Node.new(v)	Node.value(n)	Node.with_next(n, x)	nil / :error	LinkedList.empty?(l)	LinkedList.size(l)	LinkedList.delete(l, v)
elm	Node v Nothing	n.value	{ n | next = Just x }	Nothing	LinkedList.isEmpty l	LinkedList.size l	LinkedList.delete v l
erlang	node_new(V)	node_value(N)	node_with_next(N, X)	undefined	list_is_empty(L)	list_size(L)	list_delete(L, V)
forth	NODE-INIT	NODE-VALUE @	NODE-NEXT !	0 / NIL	IS-EMPTY?	SIZE @	DELETE-NODE
fsharp	Node.create v	n.Value	Node.withNext n x	None	LinkedList.isEmpty l	LinkedList.size l	LinkedList.delete v l
gleam	node_new(v)	node.value	Node(_, Some(x))	None	linked_list_is_empty(l)	linked_list_size(l)	linked_list_delete(l, v)
go	NewNode(v)	node.Value	node.Next = n	nil / (int, bool)	list.IsEmpty()	list.Len()	list.Remove(v)
grain	nodeInit(v)	node.value	{ ...n, next: Some(x) }	None	linkedListIsEmpty(l)	linkedListSize(l)	linkedListDelete(l, v)
groovy	new Node(v)	node.value	node.next = n	null	list.isEmpty()	list.size	list.delete(v)
haskell	newNode v	value n	n { next = Just x }	Nothing	linkedListIsEmpty l	linkedListSize l	linkedListDelete v l
haxe	new Node(v)	node.value	node.next = n	null / Null<T>	list.isEmpty	list.size	list.delete(v)
java	new Node(v)	node.getValue()	node.setNext(n)	null / Optional	list.isEmpty()	list.size()	list.remove(v)
javascript	new Node(v)	node.value	node.next = n	null / undefined	list.isEmpty	list.size	list.delete(v)
julia	Node(v)	n.value	n.next = x	nothing / Union{Nothing,T}	isempty(l)	length(l)	delete!(l, v)
kotlin	Node(v)	node.value	node.next = n	null	list.isEmpty	list.size	list.delete(v)
lua	Node.new(v)	node.value	node.next = n	nil	list:is_empty()	list:size()	list:delete(v)
nim	newNode(v)	node.value	node.next = x	nil / Option[T]	isEmpty(l)	size(l)	delete(l, v)
ocaml	Node.create v	Node.value n	Node.with_next n x	None	LinkedList.is_empty l	LinkedList.length l	LinkedList.delete l v
perl	Node->new($v)	$node->value	$node->set_next($n)	undef	$list->is_empty	$list->size	$list->delete($v)
php	new Node($v)	$node->value	$node->setNext($n)	null	$list->isEmpty()	$list->size()	$list->delete($v)
prolog	node_init(V, N)	node_value(N, V)	node_with_next(N, X, N1)	absent	is_empty(L)	size(L, N)	delete(L, V, L1)
purescript	newNode v	n.value	n { next = Just x }	Nothing	isEmpty l	size l	delete v l
python	Node(v)	node.value	node.next = n	None	list.is_empty()	list.size()	list.delete(v)
r	new_node(v)	n$value	n$next <- x	NULL / NA	is_empty(l)	size(l)	delete(l, v)
racket	(make-node v #f)	(node-value n)	(set-node-next! n x)	#f	(empty? l)	(size l)	(delete! l v)
raku	Node.new(v)	$node.value	$node.next = $x	Nil / Any:_	$list.is-empty	$list.size	$list.delete($v)
rescript	Node.make(v)	n.value	{ ...n, next: Some(x) }	None	isEmpty(l)	size(l)	delete(l, v)
rexx	.Node~new(v)	node~get_value	node~set_next(n)	.Nil	list~is_empty	list~size	list~delete(v)
ruby	Node.new(v)	node.value	node.next = n	nil	list.empty?	list.size	list.delete(v)
rust	Node::new(v)	n.value()	n.set_next(x)	None / Option<T>	list.is_empty()	list.size() / list.len()	list.delete(v)
scala	Node(v)	node.value	node.next = Some(x)	None / Option[T]	list.isEmpty	list.size	list.delete(v)
scheme	(make-node v '())	(node-value n)	(node-with-next n x)	#f / '()	(linked-list-empty? l)	(linked-list-size l)	(linked-list-delete l v)
swift	Node(v)	node.value	node.next = n	nil / Optional<T>	list.isEmpty	list.size	list.delete(v)
tcl-tk	Node new $v	$node get_value	$node set_next $n	{}	$list is_empty	$list size	$list delete $v
typescript	new Node(v)	node.value	node.next = n	null / undefined	list.isEmpty	list.size	list.delete(v)
v	new_node(v)	node.value()	node.set_next(x)	none / ?T	list.is_empty()	list.size()	list.delete(v)
vala	new Node(v)	node.value	node.next = n	null / int?	list.is_empty	list.size	list.delete(v)
zig	Node.init(v)	node.value	node.next = x	null / ?*T	list.isEmpty()	list.len()	list.remove(v)

    ES: Esta tabla se mantiene en docs/ruleset/data/canonical_names.tsv en formato máquina-legible. Cualquier discrepancia entre este documento y ese archivo es un bug del tooling.

    EN: This table is maintained in docs/ruleset/data/canonical_names.tsv in machine-readable form. Any discrepancy between this document and that file is a tooling bug.

⚠️ Conflictos por palabra reservada / Reserved word conflicts

ES: Los siguientes nombres no pueden usarse directamente en ciertos lenguajes porque colisionan con keywords del lenguaje, con la BCL, o con propiedades integradas. Cada uno tiene una traducción forzosa.

EN: The following names cannot be used directly in certain languages because they collide with language keywords, the standard library, or built-in properties. Each has a forced translation.
Concepto	Lenguaje	Conflicto	Traducción forzosa
delete	D	keyword delete (liberar memoria)	remove
delete	JS, TS, Ruby	builtin delete obj.prop (JS)	delete(v) como método es aceptable; en Ruby es delete de String/Hash
delete	Zig	delete es keyword	remove
init	D	propiedad integrada .init	constructor this(...)
init	ooRexx	constructor con contrato especial	init (pero no return valor)
init	Zig, V	init es función de módulo, no constructor	Node.init(v) en Zig es válido; en V es new_node
next	Perl	keyword next	método set_next
next	Rust	método de Iterator	next() sobre &Node es distinto por firma
value	Go	keyword value en contextos de switch	Value (exportado)
Node	Elixir	módulo Elixir.Node (distribuidos)	Cell
Queue	C#, Java, Dart, Kotlin, Scala, Go	BCL Queue<T>	DataStructuresBasics.Queue (namespace)
Stack	C#, Java, Dart, Kotlin, Scala, Go	BCL Stack<T>	DataStructuresBasics.Stack (namespace)
LinkedList	C#, Java, Dart, Kotlin, Scala, Go	BCL LinkedList<T>	DataStructuresBasics.LinkedList (namespace)
size	Rust, OCaml, Haskell, Nim	convención len / length	len / length
empty	Ruby, Scheme	sufijo ?	empty? / linked-list-empty?
null	Haskell, Elm, F#, OCaml, ReScript, Rust, Scala, Swift, Kotlin, Nim, Gleam, Grain, V, Zig	no existe null	Nothing / None / nil (nativo del lenguaje)
nil	Lua, Ruby, Perl, Tcl	nativo, pero no universal	específico del lenguaje
undef	Perl	nativo	específico
{}	Tcl	cadena vacía, ausencia universal	específico
Nil	Raku	singleton de ausencia	específico
#f	Scheme	falso + ausente	específico

ES: Estos conflictos están consolidados en docs/ruleset/data/canonical_names.tsv y son la base de los hallazgos de auditoría. Si un lenguaje usa delete cuando debería usar remove, es un hallazgo.

EN: These conflicts are consolidated in docs/ruleset/data/canonical_names.tsv and are the basis of audit findings. If a language uses delete when it should use remove, it is a finding.
🧪 Indicador de fallo por familia / Failure indicator per family

ES: El pseudocódigo declara absent para "sin valor" y, en operaciones fallibles, el lenguaje decide cómo representarlo. La siguiente tabla consolida la decisión por familia de paradigma (no por lenguaje concreto — eso vive en el README del lenguaje).

EN: Pseudocode declares absent for "no value" and, in fallible operations, the language decides how to represent it. The table below consolidates the decision per paradigm family (not per concrete language — that lives in the language README).
Familia / Family	Miembros / Members	Indicador de fallo / Failure indicator
OO con null	csharp, dart, groovy, haxe, java, javascript, kotlin, php, typescript, vala	null / nil (nativo)
OO con Option	scala, swift	Option / Optional
Funcional con Option	elm, fsharp, gleam, grain, haskell, ocaml, purescript, rescript, scheme, racket, clojure, common-lisp	Maybe / Option / nil (Lisp)
Funcional con Result	elixir, erlang	{:ok, _} / {:error, _} / undefined
Sistemas con punteros	ada, c, cobol, cpp, forth	NULL / null / 0
Sistemas con Option	rust, zig, v	Option<T> / ?T
Sistemas con tupla	go	(T, bool)
Sistemas con sentinel	d, assembly	-1 / null documentado
Dinámicos con null	lua, perl, python, r, raku, ruby, tcl-tk	nil / undef / None / NULL / {}
Lógico	prolog	fallo de unificación
Multi-paradigma	ballerina, crystal, julia, nim, rexx	el que declare el README del lenguaje
📐 Complejidad declarada / Declared complexity

ES: La complejidad no es opcional: forma parte del contrato. Cada lenguaje declara la complejidad real de su implementación, incluso si difiere de la especificación. Las desviaciones se documentan.

EN: Complexity is not optional: it is part of the contract. Each language declares the real complexity of its implementation, even if it differs from the spec. Deviations are documented.

Caso conocido / Known case: insertTail y enqueue en lenguajes inmutables son O(n) por la imposibilidad de extender una cadena de Box/Option/List sin reconstruirla. La spec pide O(1). Todos los lenguajes funcionales documentan la desviación.
Familia	Complejidad de insertTail/enqueue
Mutable (V1)	O(1) con tail/rear pointer
Inmutable (V2)	O(n) — desviación documentada
Mixta (V3)	La que el lenguaje declare
Lógica (V4)	Depende del modelo — documentar
📝 Reglas de desviación / Deviation rules

ES: Una desviación es cualquier diferencia entre el pseudocódigo canónico y la implementación real. Toda desviación debe:

EN: A deviation is any difference between canonical pseudocode and the real implementation. Every deviation must:

    Preservar la semántica — el comportamiento observable debe ser el mismo.

    Preservar la complejidad — o declarar explícitamente por qué cambia.

    Documentarse en el README del lenguaje — en la sección Deviations from the canonical pseudocode.

    No romper el contrato — encapsulación, inmutabilidad/mutabilidad declaradas, invariantes.

    Preserve semantics — observable behavior must be the same.

    Preserve complexity — or explicitly declare why it changes.

    Be documented in the language README — in the Deviations from the canonical pseudocode section.

    Not break the contract — encapsulation, declared mutability/immutability, invariants.

Desviaciones permitidas / Allowed deviations:

    Cambiar el nombre del constructor según el idioma (new, T.new, make-T, T(v)).

    Cambiar el nombre del indicador de fallo según el modelo idiomático (Option, nil, {}).

    Cambiar la complejidad de insertTail/enqueue cuando el lenguaje es inmutable, con justificación.

    Añadir deinit/free/dispose cuando el lenguaje lo requiera (Zig, C, C++).

    Cambiar el sufijo de predicados (isEmpty, empty?, is_empty).

Desviaciones NO permitidas / Not allowed deviations:

    Usar -1 como sentinel en un lenguaje con Option/Maybe.

    Usar null en un lenguaje que no lo tiene.

    Devolver undefined/nil desde un constructor.

    Romper la encapsulación con campos pub cuando la spec dice "representación oculta".

    Cambiar la complejidad sin documentarla.

    Silenciar warnings con #[allow], @Suppress o equivalentes sin justificación en el README.

🔗 Referencias / References

    IDIOMATICITY_LEVELS.md — Los 4 niveles y sus criterios.

    LANGUAGE_CHARACTERISTICS.md — Los 11 ejes por lenguaje.

    DEVIATION_POLICY.md — Cómo documentar cada desviación.

    PARADIGM_FAMILIES.md — Las 9 familias prácticas y el pseudocódigo ajustado por familia.

    docs/ruleset/data/canonical_names.tsv — La tabla de traducción en formato máquina-legible.

    docs/ruleset/data/language_characteristics.tsv — Los 11 ejes en formato máquina-legible.

## 🧪 Casos medidos en la homologación / Cases measured during homologation

**ES:** Hallazgos reales de los módulos ya implementados en los 50 lenguajes (`core.foundations.numbers`, `core.algorithms.naive_sort`, `core.algorithms.data_structures_basics`). No son hipótesis: cada fila se observó al compilar o ejecutar. Son la lista de comprobación previa para los módulos que quedan y la fuente de las filas ya escritas en la tabla de traducción y en las reglas de desviación.

**EN:** Real findings from the modules already implemented across the 50 languages (`core.foundations.numbers`, `core.algorithms.naive_sort`, `core.algorithms.data_structures_basics`). They are not hypotheses: each row was observed while compiling or running. They are the pre-flight checklist for the remaining modules and the source of the rows already written in the translation table and the deviation rules.

| # | Caso / Case | Lenguajes medidos / Measured languages | Regla derivada / Derived rule |
|:--:|---|---|---|
| 1 | Ausencia de enlace sin `null` en el lenguaje | clojure, common-lisp, elixir, elm, erlang, fsharp, gleam, grain, haskell, ocaml, purescript, racket, rescript, scheme | Se usa el átomo o tipo suma nativo (`None`, `Nothing`, `nil`, `'()`, `#f`); `null` solo para enlaces y nodos |
| 2 | `-1` donde el lenguaje ya tiene `Option`/`Maybe` | regla de familia (csharp, kotlin, dart, swift, scala, fsharp, rust, zig tienen tipo de ausencia) | Desviación **no permitida**; el indicador natural del lenguaje se declara en el README del módulo |
| 3 | Sentinel nativo del lenguaje | ada (`Failure_Value = -1`), assembly (`FAILURE = -1`), cobol, forth (`0`) | Sentinel documentado en el README; sin tipo de ausencia, la regla 2 no aplica |
| 4 | Constructor que no puede fallar de forma idiomática | rexx (`init` devolvía `.Nil`), swift (`fatalError` dentro de `init`) | Nivel `workaround`: se registra la desviación, no se silencia |
| 5 | Memoria manual y punteros | zig (`destroy`, `?*Node`, `std.testing.allocator`), v (`@[heap]`, `?&Node`), c, cpp, cobol (`ALLOCATE` / `BASED`), assembly (allocator propio sobre `brk`, sin libc) | `deinit` / `free` / `ALLOCATE` son desviación permitida; la suite comprueba ausencia de fugas |
| 6 | Puntero crudo donde existía alternativa con propiedad | rust (`*mut Node` en vez de `Option<Box<Node>>`) | Nivel `workaround`; `Rc<RefCell>` se evaluó y se rechazó por coste pedagógico |
| 7 | Complejidad real de `insert_tail` / `enqueue` | clojure, elm, erlang, fsharp, gleam, grain, haskell, ocaml, purescript, rescript, scheme, racket, common-lisp, elixir, rust, prolog | O(n) en V2/V4 por reconstrucción o ausencia de cola mutable; se declara en el README |
| 8 | Conflicto de palabra reservada o de BCL en `delete` / `next` / `init` | d (`delete` keyword), javascript y typescript (`delete`), perl (`next`), ruby (`delete` de `Array`), tcl-tk (`delete` de lista), csharp (`LinkedList` / `Queue` / `Stack`) | El nombre canónico se ajusta al idioma (`remove`, `unlink`) y se registra en la tabla por lenguaje |
| 9 | Predicado vacío y tamaño idiomáticos | go (`IsEmpty` exportado), rust (`is_empty`, `len`), haskell (`length`, `null`), ruby (`empty?`), scheme (`null?`), v (`is_empty`) | El README del lenguaje fija el nombre y la tabla canónica lo refleja |
| 10 | Runner de tests sin mensaje de aserción | vala (`GLib.Test` → `Test.message` + `assert_not_reached`), zig (ayudas `check_*` que imprimen el contrato antes de fallar), v (`assert cond, 'msg'`), lenguajes con `assert`/`expect` sin parámetro de mensaje | La suite imprime el mensaje del contrato antes de fallar; el andamiaje con mensaje se conserva |
| 11 | Aislamiento de casos según la semántica de copia | zig (slices, `@memcpy`), vala (arrays por referencia), php (copy-on-write), v (arrays por valor) | La suite no depende de mutaciones compartidas entre casos |
| 12 | TCO no garantizada y recursión idiomática | zig, go (iteración nativa), scheme, racket, common-lisp, haskell, elixir, erlang (recursión con acumulador) | Se conserva la adaptación idiomática y se documenta la forma elegida |
| 13 | Mecanismo no disponible en el runtime | scheme/guile (`let-values` no disponible en módulos) | Se usa la alternativa disponible; no se simula el mecanismo ausente |
| 14 | Andamiaje del lenguaje frente a la idiomaticidad | v (`v init --lib` crea `tests/` y deja la fuente en la raíz, mientras el verificador declarado es `v fmt -verify src`), ocaml (`dune init proj`), racket (`raco new library`), perl (`lib/`), r (`R/` + `tests/testthat/`), csharp (`dotnet new`) | El andamiaje se conserva cuando ya es idiomático y se normaliza solo lo que rompe el verificador; la desviación se declara |
| 15 | Ausencia y nombres exigidos por el runtime | v (`?&Node`), zig (`?*Node`), swift (`mutating` dentro de `#expect`, celdas de referencia compartidas), tcl-tk (TclOO exige `::Ns::Node new` dentro de los métodos; `{}` como ausencia; `lassign`) | Se usa el mecanismo nativo de ausencia y el nombre cualificado cuando el runtime lo exige |
| 16 | Verificación estática estricta | typescript (`noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `moduleNameMapper` en Jest), vala (campos no usados → constructores explícitos) | Se ajusta el código a los flags estrictos, no se rebajan los flags |
| 17 | Tipo privado sin ausencia representable | ada (`Make` / `Create` con parámetros `out`; `tests/` como subproyecto) | Constructor idiomático del lenguaje con la encapsulación conservada |
| 18 | Sin espacios de nombres ni framework de tests | assembly (`brk`, cabecera `.inc` con el contrato, runner propio), cobol (sin framework externo, runner propio), forth (`NIL` / `0`) | El contrato se declara en el fichero de cabecera o en el README y el runner se escribe a mano |

---

Última actualización / Last update: 2026-10-12
---