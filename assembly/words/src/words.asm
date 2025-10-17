section .data
    format db "%s", 10, 0             ; "%s\n"
    format_int db "%d", 10, 0         ; "%d\n"
    space_char db ' ', 0
    newline db 0xA, 0

section .bss
    lps_buffer resb 256               ; buffer for LPS array
    pattern resb 64                   ; example pattern buffer
    text resb 256                     ; example text buffer
    rdi_pattern: resq 1
    rsi_lps: resq 1
    ; Buffer for DP table: we'll allocate a 2D array as a flat buffer
    ; For simplicity, size is fixed here, e.g., max 64 characters each
    max_len equ 64
    lcs_table resb max_len * max_len
    
section .text
    global reverse_string, is_palindrome, kmp_search, lcs
    extern printf

; Function: reverse_string
; Input:
;   rdi = pointer to null-terminated string
; Output:
;   rax = 1 if palindrome, 0 if not
reverse_string:
    push rdi                ; Save rdi (pointer to string)
    push rsi                ; Save rsi
    push rbx                ; Save rbx (used as index/temp)

    ; Calculate length of string
    mov rsi, rdi            ; rsi = pointer to string
    xor rcx, rcx            ; rcx = length counter
.calc_length:
    mov al, [rsi]
    test al, al
    je .length_done
    inc rsi
    inc rcx
    jmp .calc_length
.length_done:
    ; rcx = length
    ; rsi = pointer to null terminator (end of string)
    dec rsi                 ; Point to last character (before null terminator)

    ; Initialize left and right pointers
    mov rdx, rdi            ; left pointer = start
    mov r8, rcx             ; length
    dec r8                  ; right index = length - 1

    ; Set right pointer
    mov r9, rdi
    add r9, r8             ; r9 = pointer to right character

    ; Swap loop
.swap_loop:
    cmp rdx, r9
    jge .done
    ; swap characters
    mov al, [rdx]
    mov bl, [r9]
    mov [rdx], bl
    mov [r9], al

    ; move pointers
    inc rdx
    dec r9
    jmp .swap_loop

.done:
    ; restore registers
    pop rbx
    pop rsi
    pop rdi
    ret

; Function: trim_string
; Arguments:
;   rdi - pointer to null-terminated string
; Returns:
;   rax - pointer to the same trimmed string
trim_string:
    push rsi
    push rdi

    mov rsi, rdi        ; read pointer
    mov rdi, rsi        ; write pointer starts at same position

.trim_loop:
    mov al, [rsi]
    test al, al
    jz .done            ; end of string if null terminator

    ; check if al is whitespace: ' ', '\n', '\t', '\r'
    cmp al, ' '
    je .skip_char
    cmp al, 10          ; newline '\n'
    je .skip_char
    cmp al, 13          ; carriage return '\r'
    je .skip_char
    cmp al, 9           ; tab '\t'
    je .skip_char

    ; copy non-whitespace character
    mov [rdi], al
    inc rdi
    jmp .next_char

.skip_char:
    ; skip copying character
    jmp .next_char

.next_char:
    inc rsi
    jmp .trim_loop

.done:
    ; null-terminate the trimmed string
    mov byte [rdi], 0

    ; restore registers and return pointer
    mov rax, rdi
    pop rdi
    pop rsi
    ret

; Function: is_palindrome
; Input:
;   rdi = pointer to null-terminated string
; Output:
;   rax = 1 if palindrome, 0 if not
is_palindrome:
    push rbp
    mov rbp, rsp

    call trim_string ; Remove all type of white spaces

    ; Calculate string length
    mov rsi, rdi        ; pointer to string
    xor rcx, rcx        ; length counter
.calc_length:
    mov al, [rsi]
    test al, al
    je .length_done
    inc rsi
    inc rcx
    jmp .calc_length
.length_done:
    ; rcx = length
    ; rsi points to null-terminator, move back to last character
    dec rsi             ; point to last character
    mov r8, 0          ; i = 0
    mov r9, rcx
    dec r9             ; j = length - 1

    ; Loop while i < j
.loop:
    cmp r8, r9
    jge .done
    ; compare word[i] and word[j]
    mov al, [rdi + r8]
    mov bl, [rdi + r9]
    cmp al, bl
    jne .not_palindrome

    ; i++, j--
    inc r8
    dec r9
    jmp .loop

.not_palindrome:
    mov rax, 0
    jmp .end

.done:
    mov rax, 1

.end:
    pop rbp
    ret

; get_length:
; Input:
;   rdi - pointer to null-terminated string
; Output:
;   rcx - length of the string (excluding null terminator)
get_length:
    push rdi
    xor rcx, rcx          ; length counter

.count_loop:
    mov al, [rdi]
    test al, al
    jz .done
    inc rdi
    inc rcx
    jmp .count_loop

.done:
    mov rax, rcx
    pop rdi
    ret

; compute_lps_array:
; Input:
;   rdi - pointer to pattern string (null-terminated)
;   rsi - pointer to buffer for lps array (bytes)
; Output:
;   rax - pointer to lps array (same as rsi)
compute_lps_array:
    push rbx
    push rdi
    push rsi
    push rdx
    push rcx
    push r8

    ; Save pattern pointer
    mov rdi, rdi            ; pattern pointer is in rdi already, but to be safe, save in a register
    mov rdx, rsi            ; buffer for lps array
    mov rsi, rdx            ; buffer address

    ; Compute pattern length
    mov rdi, rdi            ; pattern pointer (already in rdi)
    lea rsi, [rsi]          ; buffer for lps array
    call get_length
    mov r9, rax             ; pattern length

    ; Initialize lps[0] = 0
    mov byte [rsi], 0
    mov r10, 1              ; i = 1
    mov r11, 0              ; prefix length

.lps_loop:
    cmp r10, r9
    jge .lps_done

    ; compare pattern[r10] and pattern[r11]
    mov al, [rdi + r10]
    mov bl, [rdi + r11]
    cmp al, bl
    je .match_char

    ; mismatch
    cmp r11, 0
    jne .fallback
    ; r11 == 0
    mov byte [rsi + r10], 0
    inc r10
    jmp .lps_loop

.fallback:
    ; reduce prefix length
    mov al, [rsi + r11 - 1]
    movzx r11, al
    jmp .lps_loop

.match_char:
    inc r11
    mov byte [rsi + r10], r11b
    inc r10
    jmp .lps_loop

.lps_done:
    mov rax, rsi
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbx
    ret
    
; Function: KMP Search
; Input:
;   rdi = pointer to null-terminated sub string
;   rsi = pointer to null-terminated string    
; Output:
;   rax = 1 if is substring, 0 if not
kmp_search:
    push rbp
    mov rbp, rsp

    ; Save pattern and text pointers into data labels
    ; Store pattern pointer
    mov [rdi_pattern], rdi
    ; Store text pointer
    mov [rsi_lps], rsi

    ; --- Compute pattern length ---
    ; Load pattern pointer from data label
    mov rdi, [rdi_pattern]
    ; Call get_length to get pattern length
    call get_length
    mov r8, rax            ; pattern length in r8

    ; --- Compute LPS array ---
    ; Load pattern pointer again
    mov rdi, [rdi_pattern]
    ; Load buffer address for LPS array
    mov rsi, [rsi_lps]
    call compute_lps_array
    ; After this, LPS array is in [rsi_lps]

    ; --- Compute text length ---
    ; Load text pointer
    mov rsi, [rsi_lps]
    ; Save text pointer for later
    mov rdi, rsi
    call get_length
    mov r10, rax          ; text length in r10

    ; --- Initialize indices ---
    xor r11, r11          ; pattern index j = 0
    xor r12, r12          ; text index i = 0

.search_loop:
    cmp r12, r10
    jge .not_found

    ; Load text[i]
    mov al, [rsi + r12]
    ; Load pattern[j]
    mov bl, [rsi_lps + r11]
    cmp al, bl
    je .match_char

    ; Mismatch handling
    cmp r11, 0
    jne .update_j
    inc r12
    jmp .search_loop

.update_j:
    ; Get lps[j-1], load from [rsi_lps + r11 - 1]
    movzx r13, byte [rsi_lps + r11 - 1]
    mov r11, r13
    jmp .search_loop

.match_char:
    ; Match: advance both
    inc r12
    inc r11
    cmp r11, r8
    jne .continue
    ; Pattern found
    mov rax, 1
    jmp .done

.continue:
    jmp .search_loop

.not_found:
    mov rax, 0

.done:
    pop rbp
    ret

; Function: Longest Common Subsequence
; Input:
;   rdi = pointer to null-terminated patter string
;   rsi = pointer to null-terminated text string    
; Output:
;   rax = Number of longest sequence
lcs:
    ; ... (same start)
    ; check string lengths
    mov rdi, rbx
    call get_length
    mov r8, rax
    mov rdi, rcx
    call get_length
    mov r9, rax

    ; Check length bounds
    cmp r8, max_len
    jg .error_length
    cmp r9, max_len
    jg .error_length

    ; Zero initialize table
    mov rdi, lcs_table
    mov rcx, max_len * max_len
    xor rax, rax
    rep stosb

    ; Fill table
    mov r10, 1
.fill_rows:
    cmp r10, r8
    jg .done_fill_rows
    mov r11, 1
.fill_cols:
    cmp r11, r9
    jg .next_row

    ; --- Debug print indices ---
    ; (add code here to print r10 and r11)

    ; Load characters
    mov rdi, rbx
    mov rsi, r10
    dec rsi
    mov al, [rdi + rsi]

    mov rdi, rcx
    mov rsi, r11
    dec rsi
    mov bl, [rdi + rsi]

    ; --- Debug print characters ---
    ; (add code to print characters)

    ; Compare
    cmp al, bl
    jne .mismatch
    ; match
    ; get table[i-1][j-1]
    mov rdi, r10
    dec rdi
    mov rsi, r11
    dec rsi
    mov rdx, max_len
    imul rdi, rdx
    add rdi, rsi
    mov al, [lcs_table + rdi]
    inc al
    ; store
    mov rdi, r10
    dec rdi
    mov rsi, r11
    dec rsi
    mov rdx, max_len
    imul rdi, rdx
    add rdi, rsi
    mov [lcs_table + rdi], al
    jmp .next_col

.mismatch:
    ; max of table[i-1][j] and table[i][j-1]
    ; load table[i-1][j]
    mov rdi, r10
    dec rdi
    mov rsi, r11
    mov rdx, max_len
    imul rdi, rdx
    add rdi, rsi
    mov al, [lcs_table + rdi]
    ; load table[i][j-1]
    mov rdi, r10
    mov rsi, r11
    dec rsi
    imul rdi, rdx
    add rdi, rsi
    mov bl, [lcs_table + rdi]
    cmp al, bl
    jge .store_max
    mov al, bl
.store_max:
    mov rdi, r10
    dec rdi
    mov rsi, r11
    mov rdx, max_len
    imul rdi, rdx
    add rdi, rsi
    mov [lcs_table + rdi], al

.next_col:
    inc r11
    jmp .fill_cols

.next_row:
    inc r10
    jmp .fill_rows

.done_fill_rows:
    ; result
    mov rdi, r8
    mov rsi, r9
    mov rdx, max_len
    imul rdi, rdx
    add rdi, rsi
    mov al, [lcs_table + rdi]
    mov rax, r8
    ; return length
    pop rbp
    ret

.error_length:
    ; handle error
    mov rax, -1
    pop rbp
    ret

; -------------------------------------------
; print_lps_array: print array of bytes
; rdi = pointer to array, rsi = length
print_lps_array:
    push rbx
    push rdi
    push rsi
    mov rcx, rsi
    mov rdi, rdi     ; pointer to array
.print_loop:
    cmp rcx, 0
    jle .done
    mov al, [rdi]
    movzx rdi, al
    call print_int
    ; print space
    mov rdi, space_char
    call print_string
    inc rdi
    dec rcx
    jmp .print_loop
.done:
    ; print newline
    mov rdi, newline
    call print_string
    pop rsi
    pop rdi
    pop rbx
    ret


; -------------------------------------------
; print_int: prints integer in rdi
print_int:
    ; Implementation similar to previous, or use printf directly
    ; For simplicity, we'll call printf here
    mov rsi, rdi
    mov rdi, format_int
    xor rax, rax
    call printf
    ret

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