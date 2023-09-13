global mydiv

section .text

mydiv:   
		; Stack
        push rbp
        mov rbp, rsp
        
        mov QWORD [rbp-8], rdi
        mov QWORD [rbp-16], rsi
        mov QWORD [rbp-24], rdx
        
        ; set struct to 0
        mov rax, QWORD [rbp-24] ; Get struct pointer
        mov QWORD [rax], 0 ; Set pointer to the first arg at 0
        mov QWORD [rax+8], 0 ; Set pointer to the second arg at 0
        cmp QWORD [rbp-16], 0 ; if div == 0
        jne div_pos
        mov eax, 0 ;return char 0
        jmp return
        
div_pos:
		mov rax, QWORD [rbp-8] ; Set dividend
		mov rcx, QWORD[rbp-16] ; Set divisor
		xor rdx , rdx ; Clear dividend
		div QWORD [rbp-16] ; do the div 
		mov rcx, rax ; store the div result in rcx
		
		mov rax, QWORD [rbp-24] ; Get struct pointer
		mov QWORD [rax], rcx  ; Set pointer to the first arg at div result
		mov QWORD [rax+8], rdx ; Set pointer to the second arg at modulo result
		mov eax, 1

return:
	mov rsp, rbp
	pop rbp
	ret
