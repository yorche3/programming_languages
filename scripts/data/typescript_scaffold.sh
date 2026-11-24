#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso TypeScript inválido / invalid TypeScript usage: typescript_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
directories=(src test)
files=(package.json tsconfig.json jest.config.cjs .gitignore)

for path in "${directories[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta TypeScript no segura / unsafe TypeScript path: %s\n' "$path" >&2
        exit 1
    fi
done

for path in "${files[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo TypeScript no seguro / unsafe TypeScript file: %s\n' "$path" >&2
        exit 1
    fi
done

for template in typescript.tsconfig.json typescript.jest.config.cjs typescript.gitignore; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla TypeScript ausente o vacía / missing or empty TypeScript template: %s\n' "$template" >&2
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
    try {
        pkg = JSON.parse(fs.readFileSync(packagePath, "utf8"));
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
if (pkg.private === undefined) {
    pkg.private = true;
    changed = true;
}
if (!pkg.scripts) {
    pkg.scripts = {};
    changed = true;
}
if (!pkg.scripts.test || pkg.scripts.test === 'echo "Error: no test specified" && exit 1') {
    pkg.scripts.test = "jest --runInBand";
    changed = true;
}
if (!pkg.scripts.build) {
    pkg.scripts.build = "tsc --noEmit";
    changed = true;
}
const devDependencies = {
    "@types/jest": "^29.5.14",
    jest: "^29.7.0",
    "ts-jest": "^29.2.5",
    typescript: "^5.8.3"
};
pkg.devDependencies ??= {};
for (const [name, version] of Object.entries(devDependencies)) {
    if (!pkg.dependencies?.[name] && !pkg.devDependencies[name]) {
        pkg.devDependencies[name] = version;
        changed = true;
    }
}
if (changed) {
    fs.writeFileSync(packagePath, `${JSON.stringify(pkg, null, 2)}\n`);
}
NODE

for path in tsconfig.json jest.config.cjs .gitignore; do
    [[ -s "$path" ]] && continue
    case "$path" in
        tsconfig.json) template=typescript.tsconfig.json ;;
        jest.config.cjs) template=typescript.jest.config.cjs ;;
        .gitignore) template=typescript.gitignore ;;
    esac
    if [[ -e "$path" ]]; then
        cat -- "$data_dir/scaffold_templates/$template" >"$path" || {
            printf 'scaffold: no se pudo completar archivo TypeScript / could not complete TypeScript file: %s\n' "$path" >&2
            exit 1
        }
    else
        (set -C; cat -- "$data_dir/scaffold_templates/$template" >"$path") || {
            printf 'scaffold: no se pudo crear archivo TypeScript / could not create TypeScript file: %s\n' "$path" >&2
            exit 1
        }
    fi
done
