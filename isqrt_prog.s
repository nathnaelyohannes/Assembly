   .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 12
   .word 225
   .word 169
   .word 16
   .word 25
   .word 100
   .word 81
   .word 99
   .word 121
   .word 144
   .word 0 

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", isqrt(*j))
#     j++
#
main:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, xarr          # use s0 for j. init to xarr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # if *j == 0 go to main_end
   move $a0, $s1           # result (in v0) = isqrt(*j)
   jal  isqrt              # 
   move $a0, $v0           # print_int(result)
   li   $v0, 1
   syscall
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   addu $s0, $s0, 4        # j++
   b    main_while
main_end:
   lw   $s0, -8($fp)       # restore s0
   lw   $s1, -12($fp)      # restore s1

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
# end main #################################################
    .text
    .globl isqrt

isqrt:
    addiu $sp, $sp, -8       # Create stack frame
    sw $ra, 4($sp)           # Save return address
    sw $a0, 0($sp)           # Save n

    li $v0, 2                # if (n < 2)
    bge $a0, $v0, isqrt_recursive

    move $v0, $a0            # Return n if n < 2
    j isqrt_return

isqrt_recursive:
    srl $a0, $a0, 2          # n >> 2
    jal isqrt                # Recursive call
    sll $t0, $v0, 1          # small = isqrt(n >> 2) << 1
    addiu $t1, $t0, 1        # large = small + 1
    mul $t2, $t1, $t1        # large * large
    bgt $t2, $a0, isqrt_small

    move $v0, $t1            # Return large
    j isqrt_return

isqrt_small:
    move $v0, $t0            # Return small

isqrt_return:
    lw $ra, 4($sp)           # Restore return address
    lw $a0, 0($sp)           # Restore n
    addiu $sp, $sp, 8        # Restore stack
    jr $ra                   # Return
