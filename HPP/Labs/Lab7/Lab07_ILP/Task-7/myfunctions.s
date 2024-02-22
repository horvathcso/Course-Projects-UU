	.file	"myfunctions.c"
# GNU C17 (Ubuntu 11.3.0-1ubuntu1~22.04) version 11.3.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
	.globl	ffff
	.type	ffff, @function
ffff:
.LFB0:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)	# a, a
	movl	%esi, -28(%rbp)	# N, N
# myfunctions.c:5:   double sum = 0;
	pxor	%xmm0, %xmm0	# tmp89
	movsd	%xmm0, -8(%rbp)	# tmp89, sum
# myfunctions.c:6:   for(i = 0; i < N; i++) {
	movl	$0, -12(%rbp)	#, i
# myfunctions.c:6:   for(i = 0; i < N; i++) {
	jmp	.L2	#
.L3:
# myfunctions.c:7:     sum += 0.3*a[i];
	movl	-12(%rbp), %eax	# i, tmp90
	cltq
	leaq	0(,%rax,8), %rdx	#, _2
	movq	-24(%rbp), %rax	# a, tmp91
	addq	%rdx, %rax	# _2, _3
	movsd	(%rax), %xmm1	# *_3, _4
# myfunctions.c:7:     sum += 0.3*a[i];
	movsd	.LC1(%rip), %xmm0	#, tmp92
	mulsd	%xmm1, %xmm0	# _4, _5
# myfunctions.c:7:     sum += 0.3*a[i];
	movsd	-8(%rbp), %xmm1	# sum, tmp94
	addsd	%xmm1, %xmm0	# tmp94, tmp93
	movsd	%xmm0, -8(%rbp)	# tmp93, sum
# myfunctions.c:6:   for(i = 0; i < N; i++) {
	addl	$1, -12(%rbp)	#, i
.L2:
# myfunctions.c:6:   for(i = 0; i < N; i++) {
	movl	-12(%rbp), %eax	# i, tmp95
	cmpl	-28(%rbp), %eax	# N, tmp95
	jl	.L3	#,
# myfunctions.c:9:   return sum;
	movsd	-8(%rbp), %xmm0	# sum, _11
	movq	%xmm0, %rax	# _11, <retval>
# myfunctions.c:10: }
	movq	%rax, %xmm0	# <retval>,
	popq	%rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE0:
	.size	ffff, .-ffff
	.section	.rodata
	.align 8
.LC1:
	.long	858993459
	.long	1070805811
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
