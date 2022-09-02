# 
.data
a:  .word 10
b:  .space 4
c:  .word -12

.text
        addi t0, zero, -5
        la   t1, b
        sw   t0, 0(t1)
        lw   t0, a
        lw   t1, b 
        add  t2, t0, t1
        la   t0, c
        sw   t2, 0(t0)
        nop