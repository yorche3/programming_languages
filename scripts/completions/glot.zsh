# Autocompletado de glot para zsh / glot completion for zsh.
#
# Se instala con `glot install` (v1.0.0). Hasta entonces / Until then:
#   source <(./scripts/glot.sh completion zsh)     # requiere compinit cargado
#
# Los lenguajes, las fases y los módulos se completan en vivo preguntando al
# catálogo (`glot langs`, `glot modules`), así que no hay listas que mantener.
# Si `glot` no está en el PATH, exporta GLOT_CMD con la ruta del script.

_glot_zsh() {
    local glot="${GLOT_CMD:-glot}"
    local -a verbs fases modulos lenguajes encargos pasos

    verbs=(
        'version:versión instalada'
        'help:ayuda general o de un verbo'
        'doctor:diagnóstico del entorno y del repositorio'
        'langs:catálogo de lenguajes y su comando de pruebas'
        'modules:catálogo de módulos del roadmap'
        'progress:estado del roadmap'
        'completion:imprime el autocompletado'
        'use:sitúa el trabajo del sprint'
        'new:inicializa el lenguaje y crea el esqueleto'
        'save:confirma con la convención del repositorio'
        'test:ejecuta la suite del módulo asignado'
        'verify:ejecuta el verificador del lenguaje'
        'prompt:arma el encargo del sprint'
        'ask:envía el encargo al delegado'
        'set:guarda una clave del estado'
        'get:lee una clave del estado'
        'unset:borra una clave del estado'
        'list:lista el estado'
        'path:ruta del archivo de estado'
    )

    if ((CURRENT == 2)); then
        _describe 'verbo' verbs
        return 0
    fi

    case "${words[2]}" in
        modules | progress)
            fases=(${(f)"$("$glot" modules 2>/dev/null | cut -f2 | LC_ALL=C sort -u)"})
            _describe 'fase' fases
            ;;
        use | new)
            if ((CURRENT == 3)); then
                lenguajes=(${(f)"$("$glot" langs 2>/dev/null | cut -f1)"})
                _describe 'lenguaje' lenguajes
            else
                modulos=(${(f)"$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"})
                _describe 'módulo' modulos
            fi
            ;;
        save)
            if ((CURRENT == 3)); then
                pasos=(${(f)"$({ "$glot" save || true; } 2>/dev/null | cut -f1,2 | tr '\t' '\n')"})
                _describe 'paso' pasos
            elif ((CURRENT == 4)); then
                lenguajes=(${(f)"$("$glot" langs 2>/dev/null | cut -f1)"})
                _describe 'lenguaje' lenguajes
            else
                modulos=(${(f)"$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"})
                _describe 'módulo' modulos
            fi
            ;;
        test | verify)
            if ((CURRENT == 3)); then
                lenguajes=(${(f)"$("$glot" langs 2>/dev/null | cut -f1)"})
                _describe 'lenguaje' lenguajes
            else
                modulos=(${(f)"$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"})
                _describe 'módulo' modulos
            fi
            ;;
        prompt | ask)
            if ((CURRENT == 3)); then
                encargos=(${(f)"$("$glot" prompt 2>/dev/null | cut -f1)"})
                _describe 'encargo' encargos
            elif ((CURRENT == 4)); then
                lenguajes=(${(f)"$("$glot" langs 2>/dev/null | cut -f1)"})
                _describe 'lenguaje' lenguajes
            else
                modulos=(${(f)"$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"})
                _describe 'módulo' modulos
            fi
            ;;
        completion)
            _values 'shell' bash zsh
            ;;
        get | unset)
            _values 'clave' lang phase module branch spec repo
            ;;
    esac

    return 0
}

compdef _glot_zsh glot
