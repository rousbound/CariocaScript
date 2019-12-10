.globl  cariocaScript
 Si:  .string "Meu Brother: "

 Sii:  .string "%d"

 Nl:  .string "\n"

 Sf:  .string "Meu Parcerasso:%d\n"

 cariocaScript:
	 pushq %rbp
	 movq %rsp,%rbp
	 subq $48, %rsp

	 movq $Si, %rdi
	 call printf
	 movq $Sii, %rdi
	 leaq -8(%rbp), %rsi
	 call scanf

	 movq $Sii, %rdi
	 leaq -16(%rbp), %rsi
	 call scanf

	 movq $Sii, %rdi
	 leaq -24(%rbp), %rsi
	 call scanf

	 movq $Sii, %rdi
	 leaq -32(%rbp), %rsi
	 call scanf

	 movq $Sii, %rdi
	 leaq -40(%rbp), %rsi
	 call scanf

	 movq $Nl, %rdi
	 call printf

	 cmpl $0,-8(%rbp) 
	 je L3
 	 cmpl $0,-16(%rbp) 
	 je L1
	 addl $1, -8(%rbp) 
L1:
	 jmp L4
L3:
	 addl $1, -16(%rbp) 
L4:
  	 movl $0,%r12d
L5:
  	 addl $1,%r12d 
	 addl $1, -24(%rbp) 
  	 cmpl %r12d,-8(%rbp)
 	 jne L5 

L7:
	 cmpl $0, -24(%rbp)
	 je L8
 	 cmpl $0,-8(%rbp) 
	 je L6
	 addl $1, -8(%rbp) 
L6:
	 subl $1, -24(%rbp) 
	 jmp L7
L8:

 	 movq $Sf, %rdi
	 movl -8(%rbp), %esi
	 call printf

  	 movq $Sf, %rdi
	 movl -16(%rbp), %esi
	 call printf

  	 movq $Sf, %rdi
	 movl -24(%rbp), %esi
	 call printf

  	 movq $Sf, %rdi
	 movl -32(%rbp), %esi
	 call printf

 	 addl $1, -40(%rbp) 
 	 movq $Sf, %rdi
	 movl -40(%rbp), %esi
	 call printf

     	 movq %rbp, %rsp
	 popq %rbp
	 ret
