section .rodata
    message db "Scaffold: no tests configured", 10
    message_length equ $ - message

section .text
    global _start

_start:
    mov eax, 1
    mov edi, 1
    lea rsi, [rel message]
    mov edx, message_length
    syscall
    mov eax, 60
    xor edi, edi
    syscall

section .note.GNU-stack noalloc noexec nowrite progbits
