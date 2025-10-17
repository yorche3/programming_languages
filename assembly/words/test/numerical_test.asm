section .data
    msg_fibonacci_ok     db "Fibonacci [OK]", 10, 0
    msg_fibonacci_failed db "Fibonacci [FAIL]", 10, 0
    msg_factorial_ok     db "Factorial [OK]", 10, 0
    msg_factorial_failed db "Factorial [FAILED]", 10, 0
    msg_gcd_ok           db "GCD [OK]", 10, 0
    msg_gcd_failed       db "GCD [FAILED]", 10, 0
    msg_lcm_ok           db "LCM [OK]", 10, 0
    msg_lcm_failed       db "LCM [FAILED]", 10, 0

section .bss
    success resb 1  ; 1 byte success flag (1 = success, 0 = failure)

section .text
    global numerical_suite, test_fibonacci, test_factorial, test_gcd, test_lcm
    extern assert, print_string, fibonacci, factorial, gcd, lcm, print_value

;-----------------------------------------
; test_fibonacci
test_fibonacci:
    push rbp
    mov rbp, rsp

    ; Initialize success flag to 1 (true)
    mov byte [success], 1

    ; 1) assert(fibonacci(-3), -1)
    mov rdi, -3
    call fibonacci
    mov rdi, rax
    mov rsi, -1
    call assert
    cmp rax, 1
    jne .fail

    ; 2) assert(fibonacci(10), 55)
    mov rdi, 10
    call fibonacci
    mov rdi, rax
    mov rsi, 55
    call assert
    cmp rax, 1
    jne .fail

    ; 3) assert(fibonacci(15), 610)
    mov rdi, 15
    call fibonacci
    mov rdi, rax
    mov rsi, 610
    call assert
    cmp rax, 1
    jne .fail

    ; success remains 1
    jne .print_failed
    ; If all tests passed
    mov rdi, msg_fibonacci_ok
    call print_string

    pop rbp
    ret

.fail:
    mov byte [success], 0

.print_failed:
    ; Print failure message
    mov rdi, msg_fibonacci_failed
    call print_string
    
    pop rbp
    ret

;-----------------------------------------
; test_factorial
test_factorial:
    push rbp
    mov rbp, rsp

    ; Initialize success flag to 1 (true)
    mov byte [success], 1

    ; 1) assert(factorial(-3), -1)
    mov rdi, -3
    call factorial
    mov rdi, rax
    mov rsi, -1
    call assert
    cmp rax, 1
    jne .fail

    ; 2) assert(factorial(5), 120)
    mov rdi, 5
    call factorial
    mov rdi, rax
    mov rsi, 120
    call assert
    cmp rax, 1
    jne .fail

    ; 3) assert(factorial(10), 3628800)
    mov rdi, 10
    call factorial
    mov rdi, rax
    mov rsi, 3628800
    call assert
    cmp rax, 1
    jne .fail

    ; success remains 1
    jne .print_failed
    ; If all tests passed
    mov rdi, msg_factorial_ok
    call print_string

    pop rbp
    ret

.fail:
    mov byte [success], 0

.print_failed:
    ; Print failure message
    mov rdi, msg_factorial_failed
    call print_string
    
    pop rbp
    ret

;-----------------------------------------
; test_gcd
test_gcd:
    push rbp
    mov rbp, rsp

    ; Initialize success flag to 1 (true)
    mov byte [success], 1

    ; 1) assert(GCD(48, 18), 6)
    mov rdi, 48
    mov rsi, 18
    call gcd
    mov rdi, rax
    mov rsi, 6
    call assert
    cmp rax, 1
    jne .fail

    ; 2) assert(GCD(100, 25), 25)
    mov rdi, 100
    mov rsi, 25
    call gcd
    mov rdi, rax
    mov rsi, 25
    call assert
    cmp rax, 1
    jne .fail

    ; 3) assert(GCD(17, 13), 1)
    mov rdi, 17
    mov rsi, 13
    call gcd
    mov rdi, rax
    mov rsi, 1
    call assert
    cmp rax, 1
    jne .fail

    ; success remains 1
    jne .print_failed
    ; If all tests passed
    mov rdi, msg_gcd_ok
    call print_string

    pop rbp
    ret

.fail:
    mov byte [success], 0

.print_failed:
    ; Print failure message
    mov rdi, msg_gcd_failed
    call print_string
    
    pop rbp
    ret

;-----------------------------------------
; test_lcm
test_lcm:
    push rbp
    mov rbp, rsp

    ; Initialize success flag to 1 (true)
    mov byte [success], 1

    ; 1) assert(LCM(4, 6), 12)
    mov rdi, 4
    mov rsi, 6
    call lcm
    mov rdi, rax
    mov rsi, 12
    call assert
    cmp rax, 1
    jne .fail

    ; 2) assert(LCM(21, 6), 42)
    mov rdi, 21
    mov rsi, 6
    call lcm
    mov rdi, rax
    mov rsi, 42
    call assert
    cmp rax, 1
    jne .fail

    ; 3) assert(LCM(7, 3), 21)
    mov rdi, 7
    mov rsi, 3
    call lcm
    mov rdi, rax
    mov rsi, 21
    call assert
    cmp rax, 1
    jne .fail

    ; success remains 1
    jne .print_failed
    ; If all tests passed
    mov rdi, msg_lcm_ok
    call print_string

    pop rbp
    ret

.fail:
    mov byte [success], 0
    
.print_failed:
    ; Print failure message
    mov rdi, msg_lcm_failed
    call print_string
    
    pop rbp
    ret

numerical_suite:
    push rbp
    mov rbp, rsp

    call test_fibonacci
    call test_factorial
    call test_gcd
    call test_lcm

    pop rbp
    ret