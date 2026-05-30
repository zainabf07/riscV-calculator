# ============================================================
#  RISC-V Calculator
#  File   : calculator.s
#  ISA    : RV32IM
#  Tools  : MARS 4.5 / RARS / Spike (with pk)
# ============================================================

.data
# ---------- UI STRINGS ----------
title:      .asciz "********************************\n      RISC-V CALCULATOR\n********************************\n"
menu:       .asciz "\nSelect Operation:\n[1] Add       [2] Subtract\n[3] Multiply  [4] Divide\n[5] Modulus   [6] Exit\n--------------------------------\nChoice: "
input1:     .asciz "Enter first number: "
input2:     .asciz "Enter second number: "
resultMsg:  .asciz "Result: "
reuseMsg:   .asciz "Use previous result? (1=Yes, 0=No): "
errorMsg:   .asciz "Invalid choice!\n"
zeroErr:    .asciz "Division by zero!\n"
newline:    .asciz "\n"

.text
.globl main
main:
    li s0, 0          # store previous result

    # print title once
    li a7, 4
    la a0, title
    ecall

# ---------- MAIN LOOP ----------
loop:
    li a7, 4
    la a0, menu
    ecall

    li a7, 5
    ecall
    mv t0, a0

    li t1, 1
    beq t0, t1, add
    li t1, 2
    beq t0, t1, sub
    li t1, 3
    beq t0, t1, mul
    li t1, 4
    beq t0, t1, div
    li t1, 5
    beq t0, t1, mod
    li t1, 6
    beq t0, t1, exit

    # invalid input
    li a7, 4
    la a0, errorMsg
    ecall
    j loop

# ---------- INPUT FUNCTION ----------
get_inputs:
    # ask reuse
    li a7, 4
    la a0, reuseMsg
    ecall
    li a7, 5
    ecall
    mv t4, a0

    li t5, 1
    beq t4, t5, use_previous

    # normal input
    li a7, 4
    la a0, input1
    ecall
    li a7, 5
    ecall
    mv t1, a0

    li a7, 4
    la a0, input2
    ecall
    li a7, 5
    ecall
    mv t2, a0
    jr ra

use_previous:
    mv t1, s0
    li a7, 4
    la a0, input2
    ecall
    li a7, 5
    ecall
    mv t2, a0
    jr ra

# ---------- OPERATIONS ----------
add:
    jal ra, get_inputs
    add t3, t1, t2
    j print_result

sub:
    jal ra, get_inputs
    sub t3, t1, t2
    j print_result

mul:
    jal ra, get_inputs
    mul t3, t1, t2
    j print_result

div:
    jal ra, get_inputs
    beq t2, zero, div_error
    div t3, t1, t2
    j print_result

mod:
    jal ra, get_inputs
    beq t2, zero, div_error
    rem t3, t1, t2
    j print_result

# ---------- ERROR ----------
div_error:
    li a7, 4
    la a0, zeroErr
    ecall
    j loop

# ---------- PRINT RESULT ----------
print_result:
    li a7, 4
    la a0, resultMsg
    ecall

    mv a0, t3
    li a7, 1
    ecall

    mv s0, t3   # save result

    li a7, 4
    la a0, newline
    ecall
    j loop

# ---------- EXIT ----------
exit:
    li a7, 10
    ecall
