# 
.data
a:  .word 10
b:  .space 4
c:  .word -12

.text
        addi t0, zero, -5
        sw   t0, 4(gp)
        lw   t0, a
        lw   t1, b 
        add  t2, t0, t1
        sw   t2, 8(gp)
        nop