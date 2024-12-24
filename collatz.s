    .text
# PROLOGUE
start:
    
    addi $sp, $sp-4        # Adjust the stack pointer
    sw $ra, 0($sp)         # Save the return address

    jal collatz            # Jump to program

    lw $ra, 0($sp)         # Restore the return address
    addi $sp, $sp, 4       # Adjust the stack pointer back
    li $v0, 10             # Exit system call
    syscall                # Terminate the program

# BODY
collatz:
    beq $s1, 1, collatz_exit    # End case

    rem $t0, $s1, 2     
    beqz $t0, even

odd:
    mul $s1, $s1, 3
    addi $s1, $s1, 1
    addi $s2, $s2, 1
    j collatz
    

even:
    div $s1, $s1, 2
    addi $s2, $s2, 1
    j collatz
       
    
# EPILOGOGUE
collatz_exit:
    move $v0, $s2
    jr $ra
    
