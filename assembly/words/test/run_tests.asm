section .text
    global _start
    extern numerical_suite, words_suite

_start:
    call numerical_suite
    call words_suite

    ; Exit program
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; status 0
    syscall