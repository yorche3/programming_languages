section .text
global fibonacci, factorial, sum_numbers

; Recursive Fibonacci function
; int fibonacci(int n)
; Input: n in rdi
; Output: fibonacci(n) in rax
fibonacci:
    push rbp
    mov rbp, rdi
    cmp rdi, 0
    jle .base_zero   ; if n <= 0, return 0
    cmp rdi, 1
    jle .base_one   ; if n <= 1, return 1

    ; Save n for recursive calls
    push rdi

    ; Compute fibonacci(n-1)
    dec rdi
    call fibonacci
    mov rbx, rax    ; save fibonacci(n-1)

    ; Compute fibonacci(n-2)
    pop rdi         ; restore n
    dec rdi
    dec rdi         ; n-2
    call fibonacci
    mov rdx, rax    ; save fibonacci(n-2)

    ; sum results
    add rax, rbx
    jmp .done
.base_zero:
    mov rax, 0
.base_one:
    mov rax, 1
.done:
    pop rbp
    ret

; Factorial recursive
; Input: N in rdi
; Output: result in rax
factorial:
    push rbp
    mov rbp, rdi
    cmp rdi, 1
    jle .base
    dec rdi
    call factorial
    mov rbx, rax
    mov rdi, rbp
    mov rax, rdi
    imul rax, rbx
    jmp .done
.base:
    mov rax, 1
.done:
    pop rbp
    ret

; Sum first N numbers recursively
; Input: N in rdi
; Output: sum in rax
sum_numbers:
    push rbp
    mov rbp, rdi
    cmp rdi, 0
    jle .base
    dec rdi
    call sum_numbers
    mov rbx, rax
    mov rdi, rbp
    mov rax, rdi
    add rax, rbx
    jmp .done
.base:
    mov rax, 0
.done:
    pop rbp
    ret