global mymul

section .text

mymul:   
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
        
        
		mov rax, QWORD [rbp-8] ; Set to the first arg
		
		mul QWORD [rbp-16] ; do the mul 
		mov rcx, rax ; store the low mul result in rcx
		
		mov rax, QWORD [rbp-24] ; Get struct pointer
		mov QWORD [rax], rdx  ; Set pointer to the high result
		mov QWORD [rax+8], rcx ; Set pointer to the low result
		mov eax, 1

return:
	mov rsp, rbp
	pop rbp
	ret
