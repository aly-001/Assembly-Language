# Recursively calculates Factorial(n) in linear time

.data

.text

.globl main

main:
    li $a0, 5        # Set the first argument in $a0
    
    jal fact
    
    add $a0, $v0, $zero
    li $v0, 1
    syscall
    
    li $v0, 10       # Exit program
    syscall
    
fact:
    addi $sp, $sp, -8   # Allocate stack space
    sw $ra, 4($sp)      # Save return address
    sw $a0, 0($sp)      # Save argument n

    slti $t0, $a0, 1    # Check if n < 1
    beq $t0, $zero, L1  # If not, go to recursive case

    # Base case
    li $v0, 1           # Return 1
    addi $sp, $sp, 8    # Restore stack space
    jr $ra              # Return

L1:
    # Recursive case
    addi $a0, $a0, -1   # Decrement n
    jal fact            # Recursive call
    lw $a0, 0($sp)      # Restore n
    lw $ra, 4($sp)      # Restore return address
    addi $sp, $sp, 8    # Restore stack space

    mul $v0, $v0, $a0   # Calculate n * factorial(n-1)
    jr $ra              # Return
