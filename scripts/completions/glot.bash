# Autocompletado de glot para bash / glot completion for bash.
#
# Se instala con `glot install` (v1.0.0). Hasta entonces / Until then:
#   source <(./scripts/glot.sh completion bash)
#
# Los lenguajes, las fases y los módulos se completan en vivo preguntando al
# catálogo (`glot langs`, `glot modules`), así que no hay listas que mantener.
# Si `glot` no está en el PATH, exporta GLOT_CMD con la ruta del script.

_glot_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local cmd="${COMP_WORDS[1]}"
    local glot="${GLOT_CMD:-glot}"
    local words=""
    local keys="lang phase module branch spec repo"
    local verbs="version help doctor greet langs modules progress completion use new save test verify evidence close validate prompt ask set get unset list path"

    if ((COMP_CWORD == 1)); then
        COMPREPLY=($(compgen -W "$verbs -q --quiet -n --dry-run -h --help --version" -- "$cur"))
        return 0
    fi

    case "$cmd" in
        help)
            words="$verbs"
            ;;
        use | new)
            if ((COMP_CWORD == 2)); then
                words="$("$glot" langs 2>/dev/null | cut -f1)"
            else
                words="$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"
            fi
            ;;
        modules | progress)
            words="$("$glot" modules 2>/dev/null | cut -f2 | LC_ALL=C sort -u)"
            ;;
        test | verify | evidence | close | validate)
            if ((COMP_CWORD == 2)); then
                words="$("$glot" langs 2>/dev/null | cut -f1)"
            else
                words="$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"
            fi
            ;;
        save)
            if ((COMP_CWORD == 2)); then
                words="$({ "$glot" save || true; } 2>/dev/null | cut -f1,2 | tr '\t' '\n')"
            elif ((COMP_CWORD == 3)); then
                words="$("$glot" langs 2>/dev/null | cut -f1)"
            else
                words="$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"
            fi
            ;;
        prompt | ask)
            if ((COMP_CWORD == 2)); then
                words="$("$glot" prompt 2>/dev/null | cut -f1 | grep -v -e '^$')"
            elif ((COMP_CWORD == 3)); then
                words="$("$glot" langs 2>/dev/null | cut -f1)"
            else
                words="$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"
            fi
            ;;
        completion)
            words="bash zsh"
            ;;
        get | unset)
            words="$keys"
            ;;
    esac

    COMPREPLY=($(compgen -W "$words" -- "$cur"))
    return 0
}

complete -F _glot_complete glot
