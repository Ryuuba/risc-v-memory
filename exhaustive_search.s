.data
array: .word 0, 4, -3, 2, -1, -5

.text
# s1 <-> i
        addi s1, zero, 0
        j    W1
L3:     add  t0, gp, zero
        slli t1, s1, 2
        add  t0, t0, t1
        lw   t0, 0(t0)
        addi t1, zero, -5
        bne  t0, t1, L1
        j    L2
L1:     addi s1, s1, 1
W1:     addi t0, zero, 6
        blt  s1, t0, L3
L2:     nop