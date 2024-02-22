	.file	"spinwait.c"
# GNU C17 (Ubuntu 11.3.0-1ubuntu1~22.04) version 11.3.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O1 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
	.globl	barrier
	.type	barrier, @function
barrier:
.LFB40:
	.cfi_startproc
	endbr64	
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
# spinwait.c:13:   pthread_mutex_lock (&lock);
	leaq	lock(%rip), %rdi	#, tmp87
	call	pthread_mutex_lock@PLT	#
# spinwait.c:14:   mystate=state;
	movl	state(%rip), %ebx	# state, mystate
# spinwait.c:15:   waiting++;
	movl	waiting(%rip), %eax	# waiting, waiting
# spinwait.c:16:   if (waiting==NUM_THREADS) {
	cmpl	$7, %eax	#, waiting
	je	.L2	#,
	leal	1(%rax), %edx	#, _2
# spinwait.c:15:   waiting++;
	movl	%edx, waiting(%rip)	# _2, waiting
.L3:
# spinwait.c:19:   pthread_mutex_unlock (&lock);
	leaq	lock(%rip), %rdi	#, tmp90
	call	pthread_mutex_unlock@PLT	#
.L4:
# spinwait.c:20:   while (mystate==state) ;
	movl	state(%rip), %eax	# state, state.2_4
	cmpl	%ebx, %eax	# mystate, state.2_4
	je	.L4	#,
# spinwait.c:21: }
	popq	%rbx	#
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret	
.L2:
	.cfi_restore_state
# spinwait.c:17:     waiting=0; state=1-mystate;
	movl	$0, waiting(%rip)	#, waiting
# spinwait.c:17:     waiting=0; state=1-mystate;
	movl	$1, %eax	#, tmp89
	subl	%ebx, %eax	# mystate, _3
# spinwait.c:17:     waiting=0; state=1-mystate;
	movl	%eax, state(%rip)	# _3, state
	jmp	.L3	#
	.cfi_endproc
.LFE40:
	.size	barrier, .-barrier
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Hello World! %ld\n"
.LC1:
	.string	"Bye Bye World! %ld\n"
	.text
	.globl	HelloWorld
	.type	HelloWorld, @function
HelloWorld:
.LFB41:
	.cfi_startproc
	endbr64	
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx	# tmp88, arg
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movq	%rdi, %rdx	# arg,
	leaq	.LC0(%rip), %rsi	#, tmp85
	movl	$1, %edi	#,
	movl	$0, %eax	#,
	call	__printf_chk@PLT	#
# spinwait.c:26:   barrier();
	movl	$0, %eax	#,
	call	barrier	#
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movq	%rbx, %rdx	# arg,
	leaq	.LC1(%rip), %rsi	#, tmp86
	movl	$1, %edi	#,
	movl	$0, %eax	#,
	call	__printf_chk@PLT	#
# spinwait.c:29: }
	movl	$0, %eax	#,
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE41:
	.size	HelloWorld, .-HelloWorld
	.globl	main
	.type	main, @function
main:
.LFB42:
	.cfi_startproc
	endbr64	
	pushq	%r13	#
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12	#
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp	#
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx	#
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$88, %rsp	#,
	.cfi_def_cfa_offset 128
# spinwait.c:31: int main(int argc, char *argv[]) {
	movq	%fs:40, %rax	# MEM[(<address-space-1> long unsigned int *)40B], tmp99
	movq	%rax, 72(%rsp)	# tmp99, D.3760
	xorl	%eax, %eax	# tmp99
# spinwait.c:35:   pthread_mutex_init(&lock,NULL);
	movl	$0, %esi	#,
	leaq	lock(%rip), %rdi	#, tmp94
	call	pthread_mutex_init@PLT	#
	movq	%rsp, %rbx	#, ivtmp.19
	movq	%rbx, %r12	# ivtmp.19, ivtmp.27
# spinwait.c:37:   for(t=0 ; t<NUM_THREADS; t++)
	movl	$0, %ebp	#, t
# spinwait.c:38:     pthread_create(&threads[t], NULL, HelloWorld, (void*)t);
	leaq	HelloWorld(%rip), %r13	#, tmp95
.L10:
# spinwait.c:38:     pthread_create(&threads[t], NULL, HelloWorld, (void*)t);
	movq	%rbp, %rcx	# t,
	movq	%r13, %rdx	# tmp95,
	movl	$0, %esi	#,
	movq	%r12, %rdi	# ivtmp.27,
	call	pthread_create@PLT	#
# spinwait.c:37:   for(t=0 ; t<NUM_THREADS; t++)
	addq	$1, %rbp	#, t
# spinwait.c:37:   for(t=0 ; t<NUM_THREADS; t++)
	addq	$8, %r12	#, ivtmp.27
	cmpq	$8, %rbp	#, t
	jne	.L10	#,
	leaq	64(%rbx), %rbp	#, _27
.L11:
# spinwait.c:41:     pthread_join(threads[t], NULL);
	movl	$0, %esi	#,
	movq	(%rbx), %rdi	# MEM[(long unsigned int *)_16],
	call	pthread_join@PLT	#
# spinwait.c:40:   for(t=0 ; t<NUM_THREADS; t++)
	addq	$8, %rbx	#, ivtmp.19
	cmpq	%rbp, %rbx	# _27, ivtmp.19
	jne	.L11	#,
# spinwait.c:43:   pthread_mutex_destroy(&lock);
	leaq	lock(%rip), %rdi	#, tmp96
	call	pthread_mutex_destroy@PLT	#
# spinwait.c:46: }
	movq	72(%rsp), %rax	# D.3760, tmp100
	subq	%fs:40, %rax	# MEM[(<address-space-1> long unsigned int *)40B], tmp100
	jne	.L16	#,
	movl	$0, %eax	#,
	addq	$88, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx	#
	.cfi_def_cfa_offset 32
	popq	%rbp	#
	.cfi_def_cfa_offset 24
	popq	%r12	#
	.cfi_def_cfa_offset 16
	popq	%r13	#
	.cfi_def_cfa_offset 8
	ret	
.L16:
	.cfi_restore_state
	call	__stack_chk_fail@PLT	#
	.cfi_endproc
.LFE42:
	.size	main, .-main
	.globl	state
	.bss
	.align 4
	.type	state, @object
	.size	state, 4
state:
	.zero	4
	.globl	waiting
	.align 4
	.type	waiting, @object
	.size	waiting, 4
waiting:
	.zero	4
	.globl	lock
	.align 32
	.type	lock, @object
	.size	lock, 40
lock:
	.zero	40
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
