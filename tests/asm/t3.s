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

	 cmpl $0,-8(%rbp) 
	 je L4
  	 movl $0,%r13d
L2:
  	 addl $1,%r13d 
 	 cmpl $0,-8(%rbp) 
	 je L1
	 subl $1, -8(%rbp) 
L1:
	 addl $1, -24(%rbp) 
  	 cmpl %r13d,-16(%rbp)
 	 jne L2 

	 jmp L5
L4:
	 addl $1, -8(%rbp) 
L5:
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
