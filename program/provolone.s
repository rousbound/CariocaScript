.globl  provolone
Sf:  .string "Output:%d\n"

provolone:
	 pushq %rbp
	 movq %rsp, %rbp 

 	 movl %edi, %r10d
	 movl %esi, %r11d

 	 movl $0, %r12d
  	 movl $0, %r13d
L2:
  	 addl $1, %r13d 
	 addl %r11d, %r12d 
  	 cmpl %r10d, %r13d
 	 jne L2 

 	 movq $Sf, %rdi
	 movl %r12d, %esi
	 call printf
 	 movq %rbp, %rsp
	 popq %rbp
	 ret
