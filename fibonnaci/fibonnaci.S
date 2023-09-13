global fibonnaci

section .text

fibonnaci:   
		; Stack
        push rbp
        mov rbp, rsp
        push rbx
        sub rsp, 24
        
        mov QWORD [rbp-24], rdi ; get first arg
        cmp QWORD [rbp-24], 0 ; if arg < 0 return -1
        jns fibo_pos
        mov rax, -1
        jmp fibo_return

fibo_pos:
		cmp QWORD [rbp-24], 0 ; if arg == 0
		je fibo_zero_or_one
		
		cmp QWORD [rbp-24], 1 ; if arg == 1
		jne fibo_more_than_one
		
fibo_zero_or_one:
		mov rax, QWORD [rbp-24] ; return 0 or 1
		jmp fibo_return
		
fibo_more_than_one:
		mov rax, QWORD [rbp-24] ; rax = 1st arg
		sub rax, 1 ; fibo n-1
		mov rdi, rax
		call fibonnaci
		
		mov rbx, rax
		mov rax, QWORD [rbp-24]
		sub rax, 2 ;fibo n-2
		mov rdi, rax
		call fibonnaci
		
		add rax,rbx ; add res 
		
fibo_return:
		mov rbx, QWORD [rbp-8]
        mov rsp, rbp ; Stack
        pop rbp
        ret
