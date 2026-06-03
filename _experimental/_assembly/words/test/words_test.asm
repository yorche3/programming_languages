section .data
    ;------------------------------------------------------
    ; Data for Reverse
    ; Parameters
    str_hello       db "hello", 0
    str_a           db "a", 0
    str_empty       db "", 0
    ; Expected
    str_olleh       db "olleh", 0
    str_a_rev       db "a", 0
    str_empty_rev   db "", 0
    ; Result messages
    msg_reverse_ok          db "Reverse String [OK]", 10, 0
    msg_reverse_failed      db "Reverse String [FAILED]", 10, 0
    ;----------------------------------------------------
    ; Data for is_palindrome
    ; Parameters
    str_race_car    db "race car", 0   
    str_level       db "level", 0
    str_hello2      db "hello", 0
    ; Result messages
    msg_palindrome_pass     db "Is Palindrome [OK]", 10, 0
    msg_palindrome_fail     db "Is Palindrome [FAILED]", 10, 0
    ;-----------------------------------------------------
    ; Data for is_substring
    ; Parameters sub
    sub_test        db "test", 0
    sub_not         db "not", 0
    sub_empty       db "", 0
    sub_abc         db "abc", 0
    ; Parameters string
    str_test        db "this is a test", 0
    str_any         db "any string", 0
    str_abc         db "abc", 0
    str_ab          db "ab", 0
    ; Result messages
    msg_substring_pass      db "Is Substring [OK]", 10, 0
    msg_substring_fail      db "Is Substring [FAILED]", 10, 0
    ;-----------------------------------------------------
    ; Data for longest common subsequence
    ; Parameters lcs
    str_pattern1    db "AGGTAB", 0
    str_pattern2    db "ABC", 0
    ; Parameters string
    str_text1       db "GXTXAYB", 0
    str_text2       db "ABC", 0
    str_text3       db "DEF", 0
    ; Result messages
    msg_lcs_pass    db "Longest Common Subsequence [OK]", 10, 0
    msg_lcs_fail    db "Longest Common Subsequence [FAILED]", 10, 0

section .bss
    success resb 1  ; 1 byte success flag (1 = success, 0 = failure)

section .text
    global test_reverse_string, test_is_palindrome, test_is_substring, test_lcs, words_suite
    extern assert_strings, print_string, reverse_string, is_palindrome, kmp_search, lcs, print_value

test_reverse_string:
    push rbp
    mov rbp, rsp

    mov byte [success], 1

    ; 1) test reverse of "hello" -> "olleh"
    lea rdi, [rel str_hello]
    call reverse_string
    ; Now check if the string is "olleh"
    lea rdi, [rel str_hello]
    lea rsi, [rel str_olleh]
    call assert_strings
    cmp rax, 1
    jne .fail

    ; 2) test "a" -> "a"
    lea rdi, [rel str_a]
    call reverse_string
    lea rdi, [rel str_a]
    lea rsi, [rel str_a_rev]
    call assert_strings
    cmp rax, 1
    jne .fail

    ; 3) test "" -> ""
    lea rdi, [rel str_empty]
    call reverse_string
    lea rdi, [rel str_empty]
    lea rsi, [rel str_empty_rev]
    call assert_strings
    cmp rax, 1
    jne .fail

    jne .print_failed
    ; All tests passed
    mov rdi, msg_reverse_ok
    call print_string
    
    pop rbp
    ret

.fail:
    mov byte [success], 0

.print_failed:
    ; Print failure message
    mov rdi, msg_reverse_failed
    call print_string
    
    pop rbp
    ret

test_is_palindrome:
    push rbp
    mov rbp, rsp

    ; Test 1: "race car" -> True
    lea rdi, [rel str_race_car]
    call is_palindrome
    cmp rax, 1
    jne .fail

    ; Test 2: "level" -> True
    lea rdi, [rel str_level]
    call is_palindrome
    cmp rax, 1
    jne .fail

    ; Test 3: "hello" -> False
    lea rdi, [rel str_hello]
    call is_palindrome
    cmp rax, 0
    jne .fail

    ; Test 4: "a" -> True
    lea rdi, [rel str_a]
    call is_palindrome
    cmp rax, 1
    jne .fail

    ; Test 5: "" -> True
    lea rdi, [rel str_empty]
    call is_palindrome
    cmp rax, 1
    jne .fail

    jne .print_failed
    ; All tests passed
    mov rdi, msg_palindrome_pass
    call print_string
    
    pop rbp
    ret
.fail:
    mov byte [success], 0

.print_failed:
    ; Print failure message
    mov rdi, msg_palindrome_fail
    call print_string
    
    pop rbp
    ret

test_is_substring:
    push rbp
    mov rbp, rsp

    mov byte [success], 1

    ; 1) "test" in "this is a test" -> should be found (1)
    lea rdi, [rel sub_test]
    lea rsi, [rel str_test]
    call kmp_search
    mov rdi, rax
    cmp rax, 1
    jne .fail

    ; 2) "not" in "this is a test" -> not found (0)
    lea rdi, [rel sub_not]
    lea rsi, [rel str_test]
    call kmp_search
    cmp rax, 0
    jne .fail

    ; 3) "" in "any string" -> always true (1)
    lea rdi, [rel sub_empty]
    lea rsi, [rel str_any]
    call kmp_search
    cmp rax, 1
    jne .fail

    ; 4) "abc" in "abc" -> found (1)
    lea rdi, [rel sub_abc]
    lea rsi, [rel str_abc]
    call kmp_search
    cmp rax, 1
    jne .fail

    ; 5) "abc" in "ab" -> not found (0)
    lea rdi, [rel sub_abc]
    lea rsi, [rel str_ab]
    call kmp_search
    cmp rax, 0
    jne .fail

    jne .print_failed
    ; All tests passed
    mov rdi, msg_substring_pass
    call print_string
    
    pop rbp
    ret
.fail:
    mov byte [success], 0

.print_failed:
    ; Print failure message
    mov rdi, msg_substring_fail
    call print_string
    
    pop rbp
    ret

test_lcs:
    push rbp
    mov rbp, rsp

    mov byte [success], 1

    ; 1) "test" in "this is a test" -> should be found (1)
    lea rdi, [rel str_pattern1]
    lea rsi, [rel str_text1]
    call lcs
    cmp rax, 4
    jne .fail

    ; 2) "abc" in "abc" -> 3
    lea rdi, [rel str_pattern2]
    lea rsi, [rel str_text2]
    call lcs
    cmp rax, 3
    jne .fail

    ; 3) "abc" in "def" -> 0
    lea rdi, [rel str_pattern2]
    lea rsi, [rel str_text3]
    call lcs
    cmp rax, 1
    jne .fail

    ; 4) "" in "abc" -> 0
    lea rdi, [rel sub_empty]
    lea rsi, [rel str_pattern2]
    call lcs
    cmp rax, 0
    jne .fail

    ; 5) "abc" in "" -> 0
    lea rdi, [rel str_pattern2]
    lea rsi, [rel str_empty]
    call lcs
    cmp rax, 0
    jne .fail

    jne .print_failed
    ; All tests passed
    mov rdi, msg_lcs_pass
    call print_string
    
    pop rbp
    ret
.fail:
    mov byte [success], 0

.print_failed:
    ; Print failure message
    mov rdi, msg_lcs_fail
    call print_string
    
    pop rbp
    ret

words_suite:
    push rbp
    mov rbp, rsp

    call test_reverse_string
    call test_is_palindrome
    call test_is_substring
    call test_lcs

    pop rbp
    ret