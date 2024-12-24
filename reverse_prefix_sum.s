    .text
    .globl reverse_prefix_sum

reverse_prefix_sum:
    addiu $sp, $sp, -8       # Create stack frame
    sw    $ra, 4($sp)        # Save return address
    sw    $a0, 0($sp)        # Save array pointer

    lw    $t0, 0($a0)        # Load *arr
    li    $t1, -1            # Check for -1
    beq   $t0, $t1, reverse_prefix_sum_base

    addiu $a0, $a0, 4        # Move to next element
    jal   reverse_prefix_sum # Recursive call
    add   $v0, $v0, $t0      # Add current element to sum
    sw    $v0, -4($a0)       # Store updated value in array

reverse_prefix_sum_base:
    move  $v0, $zero         # Return 0 for base case

reverse_prefix_sum_return:
    lw    $ra, 4($sp)        # Restore return address
    lw    $a0, 0($sp)        # Restore array pointer
    addiu $sp, $sp, 8        # Restore stack
    jr    $ra                # Return
