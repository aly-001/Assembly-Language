.data
A:  .word 3, 4, 5, 3, 2, 1, 8, 3, 3  # Array A
k:  .word 7                            # Value of k
index: .word 0                         # To store the final index

.text
.globl main
main:
    li $t0, 0         # $t0 will be used for 'i', initialize it to 0
    la $s3, A         # Base of the array A is in $s3
    lw $s5, k         # Load the value of k into $s5

Loop:
    add $t1, $t0, $s3
    lw $t1, 0($t1)
    slt $t2, $t1, $s5 # t2 = 1 if A[i] < k
    bne $t2, 1, PrintIndex
    addi $t0, $t0, 4
    j Loop

PrintIndex:
    srl $t2, $t0, 2   # Divide $t0 by 4 to get the array index
    sw $t2, index     # Store the index in 'index'

    # Print the index
    li $v0, 1         # System call code for printing integer
    move $a0, $t2     # Move the index to $a0
    syscall           # Make the system call to print the integer

    # Exit the program
    li $v0, 10        # System call code for exit
    syscall           # Exit

    # Rest of your program...
