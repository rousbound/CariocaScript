.globl  cariocaScript
 Si:  .string "Meu Brother: "

 Sii:  .string "%d"

 Nl:  .string "\n"

 Sf:  .string "Meu Parcerasso:%d\n"

 cariocaScript:
	 pushq %rbp
	 movq %rsp,%rbp
	 subq $16, %rsp

	 movq $Si, %rdi
	 call printf
	 movq $Sii, %rdi
	 leaq -8(%rbp), %rsi
	 call scanf

	 movq $Sii, %rdi
	 leaq -16(%rbp), %rsi
	 call scanf

	 movq $Nl, %rdi
	 call printf

	   	 movl $0,%r13d
L1:
  	 addl $1,%r13d 
	 addl $1, -16(%rbp) 
  	 cmpl %r13d,-8(%rbp)
 	 jne L1 

 	 movq $Sf, %rdi
	 movl -16(%rbp), %esi
	 call printf

     	 movq %rbp, %rsp
	 popq %rbp
	 ret
