
   .text
start:
   # PROLOGUE
   addi $sp, $sp-4        # Adjust the stack pointer
   sw $ra, 0($sp)         # Save the return address

   # BODY
   jal is_palindrome      # jumps to is_palindrome
   
   # EPILOGOGUE
   lw $ra, 0($sp)         # Restore the return address
   addi $sp, $sp, 4       # Adjust the stack pointer back
   li $v0, 10             # Exit system call
   syscall                # Terminate the program

is_palindrome:
   # PROLOGUE
   addi $sp, $sp-4        # Adjust the stack pointer
   sw $ra, 0($sp)         # Save the return address

   # BODY
   jal strlen             # jumps to strlen
   sub $s1, $s1, $v0
   move $t0, $v0          # t0 is the string length

   
   ble $t0, 1, end_loop   # true if len <= 1

   move $t1, $s1          # t1 is pointer to start
   add $t2, $t1, $t0      # t2 is pointer to end
   addi $t2, $t2, -1
   

palindrome_loop:
   beq $t1, $t2, end_loop
   bgt $t1, $t2, end_loop

   lb $t3, 0($t1)           # $t3 = character at start
   lb $t4, 0($t2)           # $t4 = character at end

   bne $t3, $t4, not_palindrome # checks not equal

   addi $t1, $t1, 1         # incriments pointers
   addi $t2, $t2, -1
   j palindrome_loop        # loops

end_loop:                   # returns true
   li $v0, 1
   j palindrome_exit
   
not_palindrome:             # returns false
   li $v0, 0
   j palindrome_exit

palindrome_exit:
   # EPILOGOGUE
   lw $ra, 0($sp)         # Restore the return address
   addi $sp, $sp, 4       # Adjust the stack pointer back
   jr $ra
  

strlen:
   # PROLOGUE
   addi $sp, $sp-4        # Adjust the stack pointer
   sw $ra, 0($sp)         # Save the return address
   li $v0, 0


strlen_loop:
   # BODY
   lb $t0, 0($s1)         #pointer to start of string
   beqz $t0, strlen_end   #checks for end of string
   addi $v0, $v0, 1       #incriments pointers
   addi $s1, $s1, 1
   j strlen_loop          #loops

strlen_end:
   # EPILOGOGUE
   lw $ra, 0($sp)         # Restore the return address
   addi $sp, $sp, 4       # Adjust the stack pointer back
   jr $ra                 # Return to the caller

   
