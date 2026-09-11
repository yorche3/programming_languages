section .text
global fibonacci, factorial, sum_numbers

; ==========================
; Fibonacci functions
; ==========================

; Public Fibonacci: takes N in rdi
fibonacci:
    mov rsi, 0       ; Acc2 = 0
    mov rdx, 1       ; Acc1 = 1
    call fibonacci_iter_helper
    ret

; Helper fibonacci_iter: N in rdi, Acc2 in rsi, Acc1 in rdx
fibonacci_iter_helper:
    ; N <= 0
    cmp rdi, 0
    jle .return_acc2
    ; N <= 2
    cmp rdi, 2
    jle .return_sum
    ; else recurse: fibonacci_iter_helper(N - 1, Acc1, Acc1 + Acc2)
    dec rdi
    mov rax, rdx
    add rax, rsi        ; new Acc1 = Acc1 + Acc2 (original values)
    mov rsi, rdx        ; new Acc2 = Acc1
    mov rdx, rax
    call fibonacci_iter_helper
    pop rdx
    pop rsi
    pop rdi
    ret

.return_acc2:
    mov rax, rsi
    ret

.return_sum:
    ; return Acc1 + Acc2
    mov rax, rdx
    add rax, rsi
    ret

; ==========================
; Factorial functions
; ==========================

; Public factorial: takes N in rdi
factorial:
    mov rdx, 1             ; Acc = 1
    call factorial_iter_helper
    ret

; Helper factorial_iter: N in rdi, Acc in rsi
factorial_iter_helper:
    ; is N <= 1
    cmp rdi, 1
    jle .return_acc_factorial
    ; else recurse: factorial_iter_helper(N - 1, N * Acc)
    imul rdx, rdi
    dec rdi
    call factorial_iter_helper
    pop rdi
    ret

.return_acc_factorial:
    mov rax, rdx
    ret

; ==========================
; Sum Numbers functions
; ==========================

; Public sum_numbers: takes N in rdi
sum_numbers:
    mov rdx, 0             ; Acc = 0
    call sum_numbers_iter_helper
    ret

; Helper sum_numbers_iter: N in rdi, Acc in rsi
sum_numbers_iter_helper:
    ; is N <= 0
    cmp rdi, 0
    jle .return_acc_sum
    ; else recurse: sum_numbers_iter_helper(N - 1, N + Acc)
    add rdx, rdi
    dec rdi
    call sum_numbers_iter_helper
    pop rdi
    ret

.return_acc_sum:
    mov rax, rdx
    ret