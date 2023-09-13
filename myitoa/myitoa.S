global myitoa

section .text



myitoa:   
		; ini value
		xor rax,rax               
		movzx rcx,byte [rdi] 
		cmp rcx,'-'			; is neg ?
		jne	get_next_char			
		dec	rdx ;set neg flag
		inc rdi ;rdi = address of next character
		

get_next_char:
		movzx rcx,byte [rdi]      ;rcx = next character
		sub rcx,'0'               ;rcx = value of next digit
		jb get_result                 ; test if decimal
		cmp rcx,9                 
		ja get_result                  

		lea rax,[rax*4+rax]       ;rax = result*5
		lea rax,[rax*2+rcx]       ;rax = result*5*2 + digit = result*10 + digit
		inc rdi                   ;rdi = address of next character
		jmp get_next_char

get_result:
		cmp rdx, 0
		jns return			; jump if sign flag clear
		neg	rax			; make result negative
	
return:	
		ret
