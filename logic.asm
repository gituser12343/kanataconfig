section .data
    msg1 db "Enter first number (0-9): ", 0
    len1 equ $ - msg1
    msg2 db "Enter second number (0-9): ", 0
    len2 equ $ - msg2
    res_and db 10, "AND: ", 0
    res_or db 10, "OR: ", 0
    res_not db 10, "NOT (first): ", 0
    res_xor db 10, "XOR: ", 0
    res_nor db 10, "NOR: ", 0
    res_nand db 10, "NAND:", 0
    newline db 10, 0

section .bss
    num1 resb 2
    num2 resb 2
    result resb 2

section .text
    global _start

_start:
    ; --- Input Number 1 ---
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rsi, msg1
    mov rdx, len1
    syscall
    mov rax, 0 ; sys_read
    mov rdi, 0 ; stdin
    mov rsi, num1
    mov rdx, 2
    syscall
    ; --- Input Number 2 ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 2
    syscall

    ; Convert ASCII to Integer
    movzx r8, byte [num1]
    sub r8, '0'
    movzx r9, byte [num2]
    sub r9, '0'

    ; i. AND
    mov rax, r8
    and rax, r9 ; Performs bitwise AND
    call print_res_val, res_and

    ; ii. OR
    mov rax, r8
    or rax, r9 ; Performs bitwise OR
    call print_res_val, res_or

    ; iii. NOT (Applied to first number)
    mov rax, r8
    not al ; Performs bitwise NOT
    and rax, 0x0F ; Masking to keep it within 4 bits for display
    call print_res_val, res_not

    ; iv. XOR
    mov rax, r8
    xor rax, r9 ; Performs bitwise XOR
    call print_res_val, res_xor

    ; v. NOR (NOT of OR)
    mov rax, r8
    or rax, r9
    not al ; NOR is OR followed by NOT
    and rax, 0x0F
    call print_res_val, res_nor

    ; vi. NAND (NOT of AND)
    mov rax, r8
    and rax, r9
    not al ; NAND is AND followed by NOT
    and rax, 0x0F
    call print_res_val, res_nand

    ; Exit
    mov rax, 60 ; sys_exit
    xor rdi, rdi
    syscall

; Helper function to print label and single hex/dec digit result
print_res_val:
    push rax ; Save result
    mov rax, 1 ; Print Label
    mov rdi, 1
    mov rsi, rsi ; rsi passed as 2nd arg to call
    mov rdx, 15 ; Fixed length for simplicity
    syscall
    pop rax
    add rax, '0' ; Convert back to ASCII
    cmp rax, '9'
    jbe .output
    add rax, 7 ; Basic hex conversion if > 9
.output:
    mov [result], al
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall
    ret
Use code with caution
