
extern malloc
extern lseek

section .text
	global myfilexor
	
	
myfilexor:   
        ; Stack
        push rbp
        mov rbp,rsp
        sub rsp, 48 ; for local variable
        mov QWORD [rbp-40], rdi ; store first arg
        mov BYTE [rbp-44], sil ; store second arg
        
        
        ; open the file
        mov rax, 2
        mov    rdi,QWORD [rbp-40] ; first arg : file path
        mov    rsi, 0 ; open for reading
        syscall
        mov    QWORD [rbp-8],rax ; store file descriptor
        
        ; Get his size
        mov rdi, QWORD [rbp-8]
        mov rsi, 0
        mov rdx, 2
        call lseek wrt ..plt
                
       mov rbx, rax
        
        ; Get a buffer of the size of the file
        mov    rdi,rbx
        call malloc wrt ..plt
		mov    QWORD [rbp-16],rax ; register the malloc result
		mov		QWORD[rbp-24], rax; store a pointer to the buffer for the loop
		
			; return to the begininng of the file
         mov rdi, QWORD [rbp-8]
        mov rsi, 0
        mov rdx, 0
        call lseek wrt ..plt
        
        ; Get all the bytes from the file
        mov rdx, rbx ; size
		mov rax, 0 ; syscall read
        mov    rdi,QWORD [rbp-8] ; file descriptor
        mov rsi, QWORD [rbp-24] ; buffer
		syscall
		
		mov rdx, rbx

xor_bytes:		
        cmp    rdx,0 ; if not -1 
        je close_file
        
        mov     rbx, [rbp-24]
		mov al, BYTE [rbp-44]
        xor    BYTE[rbx] ,al ; xor the char whith the key
        
        dec rdx
        inc QWORD [rbp-24]
         jmp xor_bytes

		
        
close_file:
		; syscall close
		mov rax, 3
        mov    rdi,QWORD [rbp-8]
        syscall
        
        mov    rax,QWORD  [rbp-16]
             
return:
        ; Stack
        add rsp, 48
        mov rsp,rbp
        pop rbp

        ret
