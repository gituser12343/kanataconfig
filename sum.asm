section .data
prompt db "Enter a number (negative to stop): ", 0
prompt_len equ $ - prompt
result_msg db "The total sum is: ", 0
result_len equ $ - result_msg
newline db 10

section .bss
buffer resb 32
out_buf resb 32

section .text
global _start

_start:
xor r12, r12        ; Sum = 0

read_loop:
; Print prompt
mov rax, 1
mov rdi, 1
mov rsi, prompt
mov rdx, prompt_len
syscall

; Read input
mov rax, 0
mov rdi, 0
mov rsi, buffer
mov rdx, 32
syscall

; Convert to number
mov rsi, buffer
call str_to_int

; Check if negative (if number < 0)
cmp rax, 0
jl print_result

; Add to sum
add r12, rax
jmp read_loop

print_result:
; Print result message
mov rax, 1
mov rdi, 1
mov rsi, result_msg
mov rdx, result_len
syscall

; Convert sum to string
mov rax, r12
mov rdi, out_buf
call int_to_str

; Print sum
mov rdx, rax
mov rax, 1
mov rdi, 1
mov rsi, out_buf
syscall

; Print newline
mov rax, 1
mov rdi, 1
mov rsi, newline
mov rdx, 1
syscall

; Exit
mov rax, 60
xor rdi, rdi
syscall

; ===== String to Integer =====
str_to_int:
xor rax, rax
xor rcx, rcx
mov rbx, 10
mov r8, 0            ; Flag for negative (0 = positive)

; Check for minus sign
cmp byte [rsi], '-'
jne convert_loop
mov r8, 1            ; Set negative flag
inc rsi              ; Skip minus sign

convert_loop:
movzx rdx, byte [rsi]
cmp rdx, 10          ; newline?
je convert_done
cmp rdx, '0'
jl convert_done
cmp rdx, '9'
jg convert_done
sub rdx, '0'
imul rax, rbx
add rax, rdx
inc rsi
jmp convert_loop

convert_done:
cmp r8, 1
jne convert_exit
neg rax              ; Make negative

convert_exit:
ret

; ===== Integer to String =====
int_to_str:
mov rbx, 10
mov rsi, rdi
add rsi, 31
mov byte [rsi], 0
mov rcx, 0

convert_loop2:
xor rdx, rdx
div rbx
add dl, '0'
dec rsi
mov [rsi], dl
inc rcx
test rax, rax
jnz convert_loop2

; Move to beginning
mov rdi, out_buf
mov rdx, rcx

copy_loop:
mov al, [rsi]
mov [rdi], al
inc rsi
inc rdi
dec rcx
jnz copy_loop

mov rax, rdx
ret