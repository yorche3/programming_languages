# 🗂️ Catálogo de datos / Data catalogue

**ES:** `languages.tsv` es la fuente **máquina** de los comandos nativos por
lenguaje que consume `glot`: `langs` hoy y `test` en la v0.7.0. Una fila por
lenguaje, **separada por tabuladores**, sin cabecera, ordenada por el nombre del
submódulo.

**EN:** `languages.tsv` is the **machine** source of the per-language native
commands that `glot` consumes: `langs` today and `test` in v0.7.0. One row per
language, **tab-separated**, no header, sorted by submodule name.

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Lenguaje, tal como aparece en `.gitmodules` | `php` |
| 2 | Comando de inicialización del ecosistema | `mkdir -p src test + composer require --dev phpunit/phpunit` |
| 3 | Manifiestos y archivos clave | `composer.json, phpunit.xml, .gitignore` |
| 4 | Comando nativo de pruebas | `composer test` |

**ES:** El contenido sale de la tabla maestra de
[`docs/core/00_Project_Initialization_Guide.md`](../../docs/core/00_Project_Initialization_Guide.md),
que sigue siendo el documento humano: aquí solo está lo que el tooling necesita.
El harness comprueba que **los dos no se separan** (mismos lenguajes y mismos
comandos de pruebas), así que si actualizas la guía hay que actualizar el TSV, y
al revés. El número de filas tiene que ser igual a los lenguajes de `.gitmodules`;
`glot doctor` lo informa como `native_commands`.

**EN:** The content comes from the master table in
[`docs/core/00_Project_Initialization_Guide.md`](../../docs/core/00_Project_Initialization_Guide.md),
which remains the human document: only what the tooling needs lives here. The
harness checks that **the two do not drift apart** (same languages and same test
commands), so updating the guide means updating the TSV, and vice versa. The row
count must equal the languages in `.gitmodules`; `glot doctor` reports it as
`native_commands`.

## 🔁 Regeneración / Regeneration

**ES:** La guía manda. Este comando rehace el TSV desde su tabla maestra,
quitando las marcas de estado y los backticks:

**EN:** The guide is the source of truth. This command rebuilds the TSV from its
master table, stripping the status marks and the backticks:

```bash
clean() {
    LC_ALL=C sed 's/\xef\xb8\x8f//g; s/\xe2\x9c\x85//g; s/\xf0\x9f\x94\xa7//g;
                   s/\xe2\x9c\x8d//g; s/`//g; s/  */ /g; s/^ //; s/ $//'
}

awk -F'|' '/^\| \*\*[a-z]/ {print $2 "\t" $3 "\t" $4 "\t" $5}' \
    docs/core/00_Project_Initialization_Guide.md |
while IFS=$'\t' read -r a b c d; do
    printf '%s\t%s\t%s\t%s\n' \
        "$(printf '%s' "$a" | clean | tr -d '*')" \
        "$(printf '%s' "$b" | clean)" \
        "$(printf '%s' "$c" | clean)" \
        "$(printf '%s' "$d" | clean)"
done >scripts/data/languages.tsv
```

**ES:** Después, verifica con el harness: incluye la comprobación de deriva entre
la guía y este catálogo.

**EN:** Then verify with the harness: it includes the drift check between the
guide and this catalogue.
