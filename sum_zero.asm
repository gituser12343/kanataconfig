section .data
prompt db "Enter numbers (0 to stop): ", 0
prompt_len equ $ - prompt
msg_sum db "The total sum is: ", 0
msg_len equ $ - msg_sum
newline db 10, 0

section .bss
buffer resb 16
out_buf resb 32
sum resq 1

section .text
global _start

_start:
mov qword [sum], 0      ; Initialize sum to 0

input_loop:
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
mov rdx, 16
syscall

; Convert to integer
mov rsi, buffer
call str_to_int

; Check if input is 0
cmp rax, 0
je print_result

; Add to sum
add qword [sum], rax
jmp input_loop

print_result:
; Print result message
mov rax, 1
mov rdi, 1
mov rsi, msg_sum
mov rdx, msg_len
syscall

; Convert sum to string
mov rax, qword [sum]
mov rdi, out_buf
call int_to_str

; Print the sum
mov rdx, rax        ; length
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
mov rbx, 10

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

; Move to beginning of buffer
mov rdi, out_buf
mov rdx, rcx

copy_loop:
mov al, [rsi]
mov [rdi], al
inc rsi
inc rdi
dec rcx
jnz copy_loop

mov rax, rdx        ; Return length
ret