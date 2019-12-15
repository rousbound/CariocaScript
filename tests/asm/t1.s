.globl  cariocaScript
 Si:  .string "Meu Brother: "

 Sii:  .string "%d"

 Nl:  .string "\n"

 Sf:  .string "Meu Parcerasso:%d\n"

 cariocaScript:
	 pushq %rbp
	 movq %rsp,%rbp
	 subq $32, %rsp

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

	 movq $Nl, %rdi
	 call printf

	 	 movl -8(%rbp), %r12d 
	 movl %r12d, -24(%rbp) 
  	 movl $0,%r13d
L2:
  	 addl $1,%r13d 
	 movl -16(%rbp), %r12d 
	 addl %r12d, -24(%rbp) 
  	 cmpl %r13d,-8(%rbp)
 	 jne L2 

 	 movq $Sf, %rdi
	 movl -8(%rbp), %esi
	 call printf

  	 movq $Sf, %rdi
	 movl -16(%rbp), %esi
	 call printf

  	 movq $Sf, %rdi
	 movl -24(%rbp), %esi
	 call printf

     	 movq %rbp, %rsp
	 popq %rbp
	 ret
