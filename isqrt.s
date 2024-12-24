    .text
    .globl isqrt

isqrt:
    addiu $sp, $sp, -8       # Create stack frame
    sw    $ra, 4($sp)        # Save return address
    sw    $a0, 0($sp)        # Save n

    li    $v0, 2             # Check if n < 2
    bge   $a0, $v0, isqrt_recursive

    move  $v0, $a0           # Return n if n < 2
    j     isqrt_return

isqrt_recursive:
    srl   $a0, $a0, 2        # n >> 2
    jal   isqrt              # Recursive call
    sll   $t0, $v0, 1        # small = isqrt(n >> 2) << 1
    addiu $t1, $t0, 1        # large = small + 1
    mul   $t2, $t1, $t1      # large * large
    ble   $t2, $a0, isqrt_large # If (large * large) <= n, return large

    move  $v0, $t0           # Return small
    j     isqrt_return

isqrt_large:
    move  $v0, $t1           # Return large

isqrt_return:
    lw    $ra, 4($sp)        # Restore return address
    lw    $a0, 0($sp)        # Restore n
    addiu $sp, $sp, 8        # Restore stack
    jr    $ra                # Return
