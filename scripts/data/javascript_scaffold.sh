#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso JavaScript inválido / invalid JavaScript usage: javascript_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
directories=(src test)
files=(package.json jest.config.js .gitignore)

for path in "${directories[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta JavaScript no segura / unsafe JavaScript path: %s\n' "$path" >&2
        exit 1
    fi
done

for path in "${files[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo JavaScript no seguro / unsafe JavaScript file: %s\n' "$path" >&2
        exit 1
    fi
done

for template in javascript.jest.config.js javascript.jest.config.module.js javascript.gitignore; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla JavaScript ausente o vacía / missing or empty JavaScript template: %s\n' "$template" >&2
        exit 1
    fi
done

mkdir -p -- "${directories[@]}"
node - "$module" <<'NODE'
const fs = require("node:fs");
const moduleName = process.argv[2];
const packagePath = "package.json";
let pkg;

if (fs.existsSync(packagePath)) {
    let contents;
    try {
        contents = fs.readFileSync(packagePath, "utf8");
        pkg = JSON.parse(contents);
    } catch (error) {
        console.error(`scaffold: package.json ilegible / unreadable package.json: ${error.message}`);
        process.exit(1);
    }
    if (pkg === null || typeof pkg !== "object" || Array.isArray(pkg)) {
        console.error("scaffold: package.json inválido / invalid package.json object");
        process.exit(1);
    }
} else {
    pkg = { name: moduleName, version: "1.0.0" };
}

for (const key of ["scripts", "dependencies", "devDependencies"]) {
    if (pkg[key] !== undefined && (pkg[key] === null || typeof pkg[key] !== "object" || Array.isArray(pkg[key]))) {
        console.error(`scaffold: package.json tiene ${key} inválido / invalid package.json ${key}`);
        process.exit(1);
    }
}

let changed = false;
if (!pkg.name) {
    pkg.name = moduleName;
    changed = true;
}
if (!pkg.main || pkg.main === "index.js") {
    pkg.main = `src/${moduleName}.js`;
    changed = true;
}
if (!pkg.scripts) {
    pkg.scripts = {};
    changed = true;
}
if (!pkg.scripts.test || pkg.scripts.test === 'echo "Error: no test specified" && exit 1') {
    pkg.scripts.test = "jest";
    changed = true;
}
if (!pkg.dependencies?.jest && !pkg.devDependencies?.jest) {
    pkg.devDependencies ??= {};
    pkg.devDependencies.jest = "^30.0.5";
    changed = true;
}
if (changed) {
    fs.writeFileSync(packagePath, `${JSON.stringify(pkg, null, 2)}\n`);
}
NODE

if [[ ! -s jest.config.js ]]; then
    if node -e 'process.exit(require("./package.json").type === "module" ? 0 : 1)'; then
        template=javascript.jest.config.module.js
    else
        template=javascript.jest.config.js
    fi
    if [[ -e jest.config.js ]]; then
        cat -- "$data_dir/scaffold_templates/$template" >jest.config.js || {
            printf 'scaffold: no se pudo completar jest.config.js / could not complete jest.config.js\n' >&2
            exit 1
        }
    else
        (set -C; cat -- "$data_dir/scaffold_templates/$template" >jest.config.js) || {
            printf 'scaffold: no se pudo crear jest.config.js / could not create jest.config.js\n' >&2
            exit 1
        }
    fi
fi

if [[ ! -s .gitignore ]]; then
    if [[ -e .gitignore ]]; then
        cat -- "$data_dir/scaffold_templates/javascript.gitignore" >.gitignore || {
            printf 'scaffold: no se pudo completar .gitignore / could not complete .gitignore\n' >&2
            exit 1
        }
    else
        (set -C; cat -- "$data_dir/scaffold_templates/javascript.gitignore" >.gitignore) || {
            printf 'scaffold: no se pudo crear .gitignore / could not create .gitignore\n' >&2
            exit 1
        }
    fi
fi
