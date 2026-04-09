section .data
fmt db "Register States (Decimal):", 10, "AC: %d", 10, "E: %d", 10, "PC: %d", 10, "AR: %d", 10, "IR: %d", 10, 0

section .text
global main
extern printf

main:
    push rbp
    mov rbp, rsp

    ; --- Initialization ---
    mov ax, 32769
    stc
    mov r12, 100
    mov r13, 200
    mov r14, 0x7080

    ; --- CIR (Circulate Right) ---
    rcr ax, 1

    ; Get new E (Carry Flag)
    mov r8, 0
    pushf
    pop rbx
    shr rbx, 8
    and rbx, 1
    mov r8, rbx

    ; --- Display Results ---
    movzx rsi, ax        ; AC
    mov rdx, r8          ; E
    mov rcx, r12         ; PC
    mov r8, r13          ; AR
    mov r9, r14          ; IR

    mov rdi, fmt
    xor rax, rax
    call printf

    pop rbp
    ret