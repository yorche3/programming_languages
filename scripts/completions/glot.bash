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
    local keys="lang phase module branch spec repo target cause antigravity-model"
    local verbs="version help doctor greet langs modules models delegates progress completion use new save test verify evidence close validate prompt ask status pointer finish clean install uninstall set get unset list path"
    local i=""
    local positional=0

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
        test | verify | evidence | close | validate | finish)
            if ((COMP_CWORD == 2)); then
                words="$("$glot" langs 2>/dev/null | cut -f1)"
            else
                words="$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"
            fi
            ;;
        delegates)
            words="agy"
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
        prompt)
            if ((COMP_CWORD == 2)); then
                words="$("$glot" prompt 2>/dev/null | cut -f1 | grep -v -e '^$')"
            elif ((COMP_CWORD == 3)); then
                words="$("$glot" langs 2>/dev/null | cut -f1)"
            else
                words="$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')"
            fi
            ;;
        ask)
            # `ask` añade el delegado (v1.4.2): la opción y sus dos valores se completan, y el
            # posicional se cuenta **saltando** el valor de `--delegate`, para que el encargo
            # siga completándose aunque la opción vaya delante.
            if [[ "$cur" == --delegate=* ]]; then
                COMPREPLY=($(compgen -W "--delegate=copilot --delegate=antigravity" -- "$cur"))
                return 0
            fi
            if [[ "${COMP_WORDS[COMP_CWORD - 1]}" == "--delegate" ]]; then
                COMPREPLY=($(compgen -W "copilot antigravity" -- "$cur"))
                return 0
            fi
            for ((i = 2; i < COMP_CWORD; i++)); do
                if [[ "${COMP_WORDS[i]}" != -* && "${COMP_WORDS[i - 1]}" != "--delegate" ]]; then
                    positional=$((positional + 1))
                fi
            done
            case "$positional" in
                0) words="$("$glot" prompt 2>/dev/null | cut -f1 | grep -v -e '^$') --delegate" ;;
                1) words="$("$glot" langs 2>/dev/null | cut -f1)" ;;
                *) words="$("$glot" modules 2>/dev/null | cut -f2,3 | tr '\t' '/')" ;;
            esac
            ;;
        completion)
            words="bash zsh"
            ;;
        set)
            if ((COMP_CWORD == 2)); then
                words="$keys"
            elif [[ "${COMP_WORDS[COMP_CWORD - 1]}" == "antigravity-model" ]]; then
                # La clave de modelo toma un **alias** de `glot delegates` (en vivo),
                # como los lenguajes salen de `langs`.
                words="$("$glot" delegates agy 2>/dev/null | cut -f2)"
            fi
            ;;
        get | unset)
            words="$keys"
            ;;
    esac

    COMPREPLY=($(compgen -W "$words" -- "$cur"))
    return 0
}

complete -F _glot_complete glot
