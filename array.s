.data
array: .word -5, -13, 5, 13, 0

# s1 <-> accum, s2 <-> i
.text
        addi s1, zero, 0
        addi s2, zero, 0
        j    F1
L1:     add  t0, gp, zero
        slli t1, s2, 2
        add  t0, t0, t1
        lw   t0, 0(t0)
        add  s1, s1, t0
        addi s2, s2, 1
F1:     addi t0, zero, 5
        blt  s2, t0, L1
        nop
