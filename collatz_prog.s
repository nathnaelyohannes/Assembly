.data

arrow: .asciiz " -> "

.text

main:
    li      $sp,        0x7ffffffc      # initialize $sp

# PROLOGUE
    subu    $sp,        $sp,        8   # expand stack by 8 bytes
    sw      $ra,        8($sp)          # push $ra (ret addr, 4 bytes)
    sw      $fp,        4($sp)          # push $fp (4 bytes)
    addu    $fp,        $sp,        8   # set $fp to saved $ra

    subu    $sp,        $sp,        12  # save s0 and s1 on stack before using them
    sw      $s0,        12($sp)         # push $s0
    sw      $s1,        8($sp)          # push $s1
    sw      $s2,        4($sp)          # push $s2

    la      $s0,        xarr            # load address to s0

main_for:
    lw      $s1,        ($s0)           # use s1 for xarr[i] value
    li      $s2,        0               # use s2 for initial depth (steps)
    beqz    $s1,        main_end        # if xarr[i] == 0, stop.

# save args on stack rightmost one first
    subu    $sp,        $sp,        8   # save args on stack
    sw      $s2,        8($sp)          # save depth
    sw      $s1,        4($sp)          # save xarr[i]

    li      $v0,        1
    move    $a0,        $s1             # print_int(xarr[i])
    syscall 

    li      $v0,        4               # print " -> "
    la      $a0,        arrow
    syscall 

    jal     collatz                     # result = collatz(xarr[i])

    move    $a0,        $v0             # print_int(result)
    li      $v0,        1
    syscall 

    li      $a0,        10              # print_char('\n')
    li      $v0,        11
    syscall 

    addu    $s0,        $s0,        4   # make s0 point to the next element

    lw      $s2,        8($sp)          # save depth
    lw      $s1,        4($sp)          # save xarr[i]
    addu    $sp,        $sp,        8   # save args on stack
    j       main_for

main_end:
    lw      $s0,        12($sp)         # push $s0
    lw      $s1,        8($sp)          # push $s1
    lw      $s2,        4($sp)          # push $s2

# EPILOGUE
    move    $sp,        $fp             # restore $sp
    lw      $ra,        ($fp)           # restore saved $ra
    lw      $fp,        -4($sp)         # restore saved $fp
    jr      $ra                         # return to kernel
    .text
    .globl collatz

collatz:
    addiu $sp, $sp, -8       # Create stack frame
    sw $ra, 4($sp)           # Save return address
    sw $a1, 0($sp)           # Save depth (d)

    li $v0, 1                # Base case: if n == 1
    beq $a0, $v0, collatz_return

    andi $t0, $a0, 1         # Check if n is odd
    bne $t0, $zero, collatz_odd

collatz_even:
    div $a0, $a0, 2          # n = n / 2
    addiu $a1, $a1, 1        # d = d + 1
    jal collatz
    j collatz_return

collatz_odd:
    mul $t0, $a0, 3          # 3 * n
    addiu $a0, $t0, 1        # 3 * n + 1
    addiu $a1, $a1, 1        # d = d + 1
    jal collatz

collatz_return:
    lw $ra, 4($sp)           # Restore return address
    lw $a1, 0($sp)           # Restore depth (d)
    addiu $sp, $sp, 8        # Restore stack
    jr $ra                   # Return
.data

# array terminated by 0 (which is not part of the array)
xarr:
.word 2, 4, 6, 8, 10, 0
