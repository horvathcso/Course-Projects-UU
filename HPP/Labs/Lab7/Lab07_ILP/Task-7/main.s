	.file	"main.c"
# GNU C17 (Ubuntu 11.3.0-1ubuntu1~22.04) version 11.3.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
	.section	.rodata
.LC2:
	.string	"result = %f\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$48, %rsp	#,
	movl	%edi, -36(%rbp)	# argc, argc
	movq	%rsi, -48(%rbp)	# args, args
# main.c:9:   const int N1 = 10000;
	movl	$10000, -24(%rbp)	#, N1
# main.c:10:   double* a  = (double*)malloc(N1*sizeof(double));
	movl	-24(%rbp), %eax	# N1, tmp93
	cltq
	salq	$3, %rax	#, _2
	movq	%rax, %rdi	# _2,
	call	malloc@PLT	#
	movq	%rax, -8(%rbp)	# tmp94, a
# main.c:12:   for(i = 0; i < N1; i++)
	movl	$0, -32(%rbp)	#, i
# main.c:12:   for(i = 0; i < N1; i++)
	jmp	.L2	#
.L3:
# main.c:13:     a[i] = (rand() % 1000) * 0.001;
	call	rand@PLT	#
# main.c:13:     a[i] = (rand() % 1000) * 0.001;
	movslq	%eax, %rdx	# _3, tmp95
	imulq	$274877907, %rdx, %rdx	#, tmp95, tmp96
	shrq	$32, %rdx	#, tmp97
	sarl	$6, %edx	#, tmp98
	movl	%eax, %ecx	# _3, tmp99
	sarl	$31, %ecx	#, tmp99
	subl	%ecx, %edx	# tmp99, _4
	imull	$1000, %edx, %ecx	#, _4, tmp100
	subl	%ecx, %eax	# tmp100, _3
	movl	%eax, %edx	# _3, _4
# main.c:13:     a[i] = (rand() % 1000) * 0.001;
	pxor	%xmm1, %xmm1	# _5
	cvtsi2sdl	%edx, %xmm1	# _4, _5
# main.c:13:     a[i] = (rand() % 1000) * 0.001;
	movl	-32(%rbp), %eax	# i, tmp101
	cltq
	leaq	0(,%rax,8), %rdx	#, _7
	movq	-8(%rbp), %rax	# a, tmp102
	addq	%rdx, %rax	# _7, _8
# main.c:13:     a[i] = (rand() % 1000) * 0.001;
	movsd	.LC0(%rip), %xmm0	#, tmp103
	mulsd	%xmm1, %xmm0	# _5, _9
# main.c:13:     a[i] = (rand() % 1000) * 0.001;
	movsd	%xmm0, (%rax)	# _9, *_8
# main.c:12:   for(i = 0; i < N1; i++)
	addl	$1, -32(%rbp)	#, i
.L2:
# main.c:12:   for(i = 0; i < N1; i++)
	movl	-32(%rbp), %eax	# i, tmp104
	cmpl	-24(%rbp), %eax	# N1, tmp104
	jl	.L3	#,
# main.c:15:   int N2 = 5000;
	movl	$5000, -20(%rbp)	#, N2
# main.c:17:   double result = 0;
	pxor	%xmm0, %xmm0	# tmp105
	movsd	%xmm0, -16(%rbp)	# tmp105, result
# main.c:19:   for(j = 0; j < N2; j++)
	movl	$0, -28(%rbp)	#, j
# main.c:19:   for(j = 0; j < N2; j++)
	jmp	.L4	#
.L5:
# main.c:20:     result = ffff(a, N1);
	movl	-24(%rbp), %edx	# N1, tmp106
	movq	-8(%rbp), %rax	# a, tmp107
	movl	%edx, %esi	# tmp106,
	movq	%rax, %rdi	# tmp107,
	call	ffff@PLT	#
	movq	%xmm0, %rax	#, tmp108
	movq	%rax, -16(%rbp)	# tmp108, result
# main.c:19:   for(j = 0; j < N2; j++)
	addl	$1, -28(%rbp)	#, j
.L4:
# main.c:19:   for(j = 0; j < N2; j++)
	movl	-28(%rbp), %eax	# j, tmp109
	cmpl	-20(%rbp), %eax	# N2, tmp109
	jl	.L5	#,
# main.c:22:   printf("result = %f\n", result);
	movq	-16(%rbp), %rax	# result, tmp110
	movq	%rax, %xmm0	# tmp110,
	leaq	.LC2(%rip), %rax	#, tmp111
	movq	%rax, %rdi	# tmp111,
	movl	$1, %eax	#,
	call	printf@PLT	#
# main.c:24:   free(a);
	movq	-8(%rbp), %rax	# a, tmp112
	movq	%rax, %rdi	# tmp112,
	call	free@PLT	#
# main.c:26:   return 0;
	movl	$0, %eax	#, _25
# main.c:27: }
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:
	.long	-755914244
	.long	1062232653
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
