.globl  cariocaScript
 Sip:  .string "Input: "
 Sii:  .string "%d"
 Nl:  .string "\n"

 Sf:  .string "Output: %d\n"

cariocaScript:
	 pushq %rbp
	 movq %rsp, %rbp
	 subq $16, %rsp

 	 movq $Sip, %rdi
	 call printf

	 movq $Sii, %rdi
	 leaq -8(%rbp), %rsi
	 call scanf


 	 movq $Sf, %rdi
	 movq -8(%rbp), %rsi
	 call printf

	 movq %rbp, %rsp
	 popq %rbp
	 ret
