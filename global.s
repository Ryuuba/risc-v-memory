	.file	"global.cc"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 4
	.text
	.globl	a
	.section	.sdata,"aw"
	.align	2
	.type	a, @object
	.size	a, 4
a:
	.word	10
	.globl	b
	.section	.sbss,"aw",@nobits
	.align	2
	.type	b, @object
	.size	b, 4
b:
	.zero	4
	.globl	c
	.section	.sdata
	.align	2
	.type	c, @object
	.size	c, 4
c:
	.word	-12
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-4
	.cfi_def_cfa_offset 4
	sw	s0,0(sp)
	.cfi_offset 8, -4
	addi	s0,sp,4
	.cfi_def_cfa 8, 0
	lui	a5,%hi(b)
	li	a4,-5
	sw	a4,%lo(b)(a5)
	lui	a5,%hi(a)
	lw	a4,%lo(a)(a5)
	lui	a5,%hi(b)
	lw	a5,%lo(b)(a5)
	add	a4,a4,a5
	lui	a5,%hi(c)
	sw	a4,%lo(c)(a5)
	li	a5,0
	mv	a0,a5
	lw	s0,0(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 4
	addi	sp,sp,4
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 10.1.0"
