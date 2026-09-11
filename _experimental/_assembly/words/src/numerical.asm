section .text
    global fibonacci, factorial, gcd, lcm
    extern print_value

; Funtcion: fibonacci
; Arguments:
;   rdi - Number of fibonacci asked
fibonacci:
    push rbp
    mov rbp, rsp
    mov rax, 0

    cmp rdi, 0
    jl .return_minus_one        ; if n < 0, return -1

    cmp rdi, 0
    je .return_f0
    cmp rdi, 1
    je .return_f1

    ; while n > 2, compute acc2, acc1
    mov rcx, rdi
    mov rax, 1
    mov rbx, 0
.fib_loop:
    cmp rcx, 2
    je .done
    mov rdx, rax
    add rdx, rbx
    mov rbx, rax
    mov rax, rdx
    dec rcx
    jmp .fib_loop

.done:
    add rax, rbx
    jmp .end

.return_f0:
    mov rax, 0
    jmp .end

.return_f1:
    mov rax, 1
    jmp .end

.return_minus_one:
    mov rax, -1

.end:
    pop rbp
    ret

; Funtcion: factorial
; Arguments:
;   rdi - Number of factorial asked
factorial:
    push rbp
    mov rbp, rsp

    cmp rdi, 0
    jl .return_minus_one        ; if n < 0, return -1

    cmp rdi, 0
    je .return_base
    cmp rdi, 1
    je .return_base

    ; while n > 1, compute acc2, acc1
    mov rcx, rdi
    mov rax, 1

.fac_loop:
    cmp rcx, 1
    je .end
    imul rax, rcx
    dec rcx
    jmp .fac_loop

.return_base:
    mov rax, 1
    jmp .end

.return_minus_one:
    mov rax, -1

.end:
    pop rbp
    ret

; Funtcion: module
; Arguments:
;   rdi - First number
;   rsi - Second number
module:
    push rbx
    mov rax, rdi
    mov rbx, rsi

    cqo
    idiv rbx

    mov rax, rdx
    pop rbx
    ret
    
; Funtcion: gcd
; Arguments:
;   rdi - First number
;   rsi - Second number
gcd:
    push rbp
    mov rbp, rsp
    
.gcd_loop:
    cmp rsi, 0
    je .end
    call module
    mov rdi, rsi
    mov rsi, rax
    jmp .gcd_loop

.end:
    mov rax, rdi
    pop rbp
    ret

; Funtcion: lcm
; Arguments:
;   rdi - First number
;   rsi - Second number
lcm:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi

    call gcd
    pop rdi
    pop rsi
    mov rbx, rax

    mov rax, rdi
    xor rdx, rdx
    div rbx

    imul rax, rsi

    pop rbp
    ret