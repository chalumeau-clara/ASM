section .text
	global orderlist
	global itoa
	
	

section .text


itoa:

; rdi : number to convert
; rsi : buffer that store the result
; rdx : size of the list
; rcx : how many element we have print
; return the number of bytes of the char *
	mov rax, rdi 
	; store value
	push rbx 
	push rdx
	push rcx
	
	; div by 10 as we want decimal
	mov rbx, 10
	
	; set variable at 0
	xor rcx, rcx
	xor r9, r9
	
loop:
	xor     rdx, rdx ; clear dividend
    div     rbx
    
    ;convert int to char
    add     rdx, 48 
    ; push it
    push    rdx
    inc     rcx
    
    ; while it still has characters
    cmp     rax, 0
    jnz     loop

writeChar:
; depile character
	 pop     rdx
	 ; store it in the buffer
	mov     byte[rsi + r9], dl
    dec     rcx
    inc     r9
    
    ; while it still has characters
    cmp     rcx, 0
    jnz     writeChar

ajout:	
; add , or \n for list print
	pop rcx
	pop rdx
	
	dec edx
	cmp ecx, edx
	je backslash
	mov     byte[rsi + r9], ','
    inc     r9
    mov     byte[rsi + r9], ' '
    inc     r9
    jmp return_itoa
	
backslash:
	mov     byte[rsi + r9], 10
    inc     r9
    jmp return_itoa
	
return_itoa :	
; return the number of bytes
	mov rax, r9
    mov     byte[rsi + r9], 0
    pop     rbx 
    ret


    
	
orderlist:   
; rdi : list
; rsi : size of the list
		push   rbp
		mov    rbp,rsp
		push rdx
		sub    rsp,0x34 ; local variable space
		mov    QWORD [rbp-0x28],rdi
		mov    DWORD  [rbp-0x2c],esi
		mov    QWORD  [rbp-0x10],0x0 ; int min = 0;
		mov    DWORD [rbp-0x18],0x0 ; int i = 0;
		
		; buffer for mmap
		mov rax, 9
		mov rsi, 2048
		mov rdi, 0
		mov rdx, 3
		mov r10, 0x22
		mov  r9, 0
		mov r8, -1
		syscall
		mov r10, rax
		
		; r9 = counter
		xor r9, r9
		mov r9d, DWORD  [rbp-0x2c]
		mov QWORD[rbp-0x34], 0 ; int max = 0
	
		
get_max :
		dec r9
		cmp r9, 0
		je for_loop
		
		mov    rax,r9
		lea    rdx,[rax*8] ; list[r9]
		mov    rax,QWORD  [rbp-0x28]; rax = list
		add    rax,rdx ; rax = list[r9]
		mov    rax,QWORD  [rax] ; get value of the list
		
		cmp rax, QWORD[rbp-0x34] ; list[i] > max
		jle get_max
		mov QWORD[rbp-0x34], rax ; max = list[i]
		jmp get_max
		
	
i_loop:
		mov rax, QWORD[rbp-0x32]
		mov    QWORD [rbp-0x8], rax; cur = max
		mov    DWORD  [rbp-0x14],0x0 ; int j = 0;
		jmp j_loop
	
condition2:
		mov    eax,DWORD  [rbp-0x14]
		lea    rdx,[rax*8+0x0] ; list[0]
		mov    rax,QWORD  [rbp-0x28]
		add    rax,rdx
		mov    rax,QWORD  [rax]
		cmp    QWORD  [rbp-0x10],rax ; list[j] > min
		jge 	continue_loop
		 
condition:
		mov    eax,DWORD  [rbp-0x14]
		lea    rdx,[rax*8+0x0]
		mov    rax,QWORD  [rbp-0x28]
		add    rax,rdx
		mov    rax,QWORD  [rax]
		cmp    QWORD  [rbp-0x8],rax ; list[j] < cur
		jle  	continue_loop
		mov    eax,DWORD  [rbp-0x14] ; eax = j
		lea    rdx,[rax*8+0x0]
		mov    rax,QWORD [rbp-0x28]
		add    rax,rdx
		mov    rax,QWORD  [rax]
		mov    QWORD  [rbp-0x8],rax ; cur = list[j]
		
	
continue_loop:
		add    DWORD [rbp-0x14],0x1 ; j++

j_loop:
; loop to get the value to print
		mov    eax,DWORD [rbp-0x14]
		cmp    eax,DWORD [rbp-0x2c] ; while j < size
		jl condition2

print:	
; print the value
		mov  	rax,QWORD [rbp-0x8]
		mov    QWORD [rbp-0x10],rax ; min = cur
		
		; itoa call
		mov rdi, rax
		mov rsi, r10
		mov edx, DWORD [rbp-0x2c] ; edx = size
		mov ecx, DWORD [rbp-0x18] ; ecx = i
		call itoa
		
		; syscall write
		mov rax, 1
		mov rdi, 1
		mov    rsi, r10
		mov rdx, r9
		syscall
		
		add    DWORD [rbp-0x18],0x1 ; i++
		
for_loop:
; loop that print and set min value
		mov    eax,DWORD [rbp-0x18]
		cmp    eax,DWORD [rbp-0x2c]	 ; while i < size
		jl i_loop
		
return :
		add    rsp,0x34
		pop rdx
		mov    rsp,rbp
		pop   rbp
		ret

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
