section .data
    output_fmt: db "Result: %d", 10, 0   ; Format string for printing integers
    result_buffer: times 20 db 0          ; buffer for integer to string conversion if needed

section .text
    global _start

    extern fibonacci
    extern factorial
    extern sum_numbers

    ; Declare external functions if in separate files (assuming C calling convention)
    ; They are defined elsewhere

    ; Include libc functions for printing (printf), if linking with libc.
    ; Alternatively, use syscall write for direct output.
    ; For simplicity, assume linking with libc and using printf.

    extern printf

_start:
    ; --- Test fibonacci ---
    mov rdi, 5          ; N = 5
    call fibonacci
    mov rsi, rax         ; Save result

    ; Print Fibonacci result
    lea rdi, [rel output_fmt]
    mov rdx, rsi
    call printf

    ; --- Test factorial ---
    mov rdi, 5           ; N = 5
    call factorial
    mov rsi, rax

    lea rdi, [rel output_fmt]
    mov rdx, rsi
    call printf

    ; --- Test sum_numbers ---
    mov rdi, 5
    call sum_numbers
    mov rsi, rax

    lea rdi, [rel output_fmt]
    mov rdx, rsi
    call printf

    ; Exit program
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; status 0
    syscall