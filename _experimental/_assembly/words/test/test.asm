section .data
    format db "%s", 10, 0    ; format string: "%s\n"
    format_int db "%d", 10, 0  ; "%d\n" with newline
    hex_chars db "0123456789ABCDEF"

section .text
    global print_string, assert, print_value, assert_strings
    extern printf

; Function: print_string
; Arguments:
;   rdi - pointer to null-terminated string to print
print_string:
    push rdi                ; preserve rdi
    lea rsi, [rdi]          ; load the string pointer into rsi
    mov rdi, format         ; first argument: format string
    xor rax, rax            ; clear rax for variadic functions
    call printf
    pop rdi                 ; restore rdi
    ret

; Function: assert
; Arguments
;   rdi - Integer result from function
;   rsi - Integer value expected
; Returns rax 1 if equal, 0 otherwise
assert:
    push rbx
    mov rax, rdi     ; result
    mov rbx, rsi     ; expected
    cmp rax, rbx
    sete al
    movzx rax, al
    pop rbx
    ret

print_value:
    mov rsi, rdi        ; move the integer value into rsi (second argument)
    mov rdi, format_int ; format string as first argument
    xor rax, rax        ; clear rax for variadic functions
    call printf
    ret

; Function: assert_strings
; Arguments:
;   rdi - pointer to first string
;   rsi - pointer to second string
; Returns:
;   rax 1 if strings are equal, 0 otherwise
assert_strings:
    push rbx

    ; Loop:
.compare_loop:
    mov al, [rdi]       ; load byte from first string
    mov bl, [rsi]       ; load byte from second string

    cmp al, bl
    jne .not_equal      ; if bytes differ, strings are not equal
    cmp al, 0           ; check for null terminator
    je .equal           ; if null terminator and previous bytes matched, strings are equal

    ; move to next character
    inc rdi
    inc rsi
    jmp .compare_loop

.equal:
    mov rax, 1
    jmp .done

.not_equal:
    mov rax, 0

.done:
    pop rbx
    ret

; ----------------------------------------------
; Helper: print_char
; Input: rsi = character to print
; ----------------------------------------------
print_char:
    mov rax, 1       ; sys_write
    mov rdi, 1       ; stdout
    mov rdx, 1       ; 1 byte
    mov rsi, rsi     ; character in rsi
    syscall
    ret