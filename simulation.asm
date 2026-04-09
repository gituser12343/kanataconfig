section .data
AC dw 32767
E db 0
PC dw 100
AR dw 0
IR dw 0

section .text
global _start

_start:
; -- i. INC (Increment AC) --
mov ax, [AC]
add ax, 1
mov [AC], ax

; -- ii. SPA (Skip if Positive) --
mov ax, [AC]
cmp ax, 0
jl not_positive
add word [PC], 1

not_positive:

; -- iii. SNA (Skip if Negative) --
mov ax, [AC]
cmp ax, 0
jge not_negative
add word [PC], 1

not_negative:

; -- iv. SZE (Skip if E is Zero) --
mov al, [E]
cmp al, 0
jne not_zero_e
add word [PC], 1

not_zero_e:

; Final updates
mov [AR], ax
mov word [IR], 0x7020

; Exit program
mov eax, 1
mov ebx, 0
int 0x80