.globl  cariocaScript
 Sf:  .string "Output:%d\n"

 cariocaScript:
	 pushq %rbp
	 movq %rsp, %rbp

 	 movl %edi, %r10d
	 movl %esi, %r11d

 	 movl $0, %r12d
 	 cmpl $0, %r10d 
	 je L4
 	 cmpl $0, %r11d 
	 je L2
	 addl $1, %r10d 
L2:
	 jmp L5
L4:
	 addl $1, %r11d 
L5:
  	 movl $0, %r13d
L6:
  	 addl $1, %r13d 
	 addl $1, %r12d 
  	 cmpl %r10d, %r13d
 	 jne L6 

 	 movl $0, %r10d
L11:
	 cmpl $0, %r12d
	 je L12
 	 cmpl $0, %r10d 
	 je L9
	 addl $1, %r10d 
L9:
	 movl %r11d, %r10d 
	 je L11
L12:
 
 	 movq $Sf, %rdi
	 movl %r12d, %ebx
	 movl %ebx, %esi
	 call printf
	     	 movq %rbp, %rsp
	 popq %rbp
	 ret
