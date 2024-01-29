# leaf_example performs the operation f = (g + h) - (i + j)
.data
                     # To store the final index

.text
.globl main
main:
    
    li $a0, 5        # Set the first argument in $a0
    li $a1, 10       # Set the second argument in $a1
    li $a2, 2
    li $a3, 3
    
    jal leaf_example # Call the function
    move $s0, $v0    # Move the result from $v0 to $s0 (or handle it as needed)

    move $a0, $v0    # Move the value from $v0 to $a0 (argument for syscall)
    li $v0, 1        # set $v0 to 1 (Syscall looks at $v0 and acts accordingly)
    syscall          # Make the system call to print the integer
    
    li $v0, 10       # Exit program
    syscall

leaf_example:

    addi $sp, $sp, -12
    sw $t0, 8($sp)
    sw $t1, 4($sp)
    sw $s0, 0($sp)

    add $t0, $a0, $a1  # Correct: $t0 = $a0 + $a1 (5 + 10)
    add $t1, $a2, $a3  # Correct: $t1 = $a2 + $a3 (2 + 3)
    sub $s0, $t0, $t1  # Correct: $s0 = $t0 - $t1 ((5 + 10) - (2 + 3))

    move $v0, $s0  # Move the result to $v0

    lw $t0, 8($sp)
    lw $t1, 4($sp)
    lw $s0, 0($sp)
    addi $sp, $sp, 12

    jr $ra
