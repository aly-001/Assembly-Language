.data
    buffer1: .space 100  # 100 bytes of space; 100 ascii characters
    buffer2: .space 100
    first_name: .asciiz "First name: "
    last_name: .asciiz "Last name: "
    you_entered: .asciiz "You entered: "
    newline: .asciiz "\n"
    space: .asciiz " "
    comma: .asciiz ","

.text
.globl main

main:

la $a0, first_name
jal Puts

la $a0, buffer1        # Set buffer1 (empty space) as the first argument
li $a1, 20             # Set a limit of 20 characters as the second argument
jal Gets               # Get user input for first name

la $a0, buffer1
jal Puts

la $a0, newline
jal Puts

la $a0, last_name
jal Puts

la $a0, buffer2        # Set buffer1 (empty space) as the first argument
li $a1, 20             # Set a limit of 20 characters as the second argument
jal Gets               # Get user input for last name

la $a0, buffer2
jal Puts

la $a0, newline
jal Puts

la $a0, you_entered
jal Puts

la $a0, buffer2
jal Puts

la $a0, comma
jal Puts

la $a0, space
jal Puts

la $a0, buffer1
jal Puts

li $v0, 10              # Exit the program
syscall

Gets:
    addi $sp, $sp, -4   # Decrement stack pointer to make space
    sw $ra, 0($sp)      # Save $ra at the new top of the stack

    li $s0, 0                         # Initialize counter
    Loop:
        beq $s0, $a1, ExitLoop1       # Exit if limit reached
        jal GETCHAR                   # Get a character; stored in $v0
        li $s3, 10
        beq $v0, $s3, ExitLoop1       # Exit if the character is a newline
        move $s1, $a0                 # Extract the address given when called
        add $s1, $s1, $s0             # Calculate where to save character in Buffer
        sb $v0, 0($s1)                # Save the character to the right place
        addi $s0, $s0, 1              # Increment loop counter
        j Loop                        # Loop
    ExitLoop1:
        move $s1, $a0                 # Go to start of buffer
        add $s1, $s1, $s0             # Go to the end of buffer
        sb $zero, 0($s1)              # Add a terminator to the end

    lw $ra, 0($sp)       # Restore $ra
    addi $sp, $sp, 4     # Increment stack pointer to remove the saved $ra

    jr $ra               # Return to caller

Puts:
    addi $sp, $sp, -4    # Decrement the stack pointer
    sw $ra, 0($sp)       # Push return address onto stack

    move $s4, $a0        # Salvage the argument to the function

    li $s0, 0                         # Initialize the counter
    Loop2:                            
        move $s1, $s4                 # Get base index for buffer
        add $s1, $s1, $s0             # Add counter amount
        lb $a0, 0($s1)                # Load correct index onto argument for PUTCHAR
        beq $a0, $zero, ExitLoop2     # Exit if you see a null
        jal PUTCHAR                   # Output the character
        addi $s0, $s0, 1              # Increment the counter
        j Loop2                       # Loop
    ExitLoop2:

    lw $ra, 0($sp)                    # Pop the stack
    addi $sp, $sp, 4                  
    jr $ra                            # Jump to return address

GETCHAR:
    lui $a3, 0xFFFF      # Load upper half of MMIO base address into $a3
CkReady:
    lw $t1, 0($a3)       # Read from receiver control register (status register)
    andi $t1, $t1, 0x1   # Extract ready bit (LSB)
    beqz $t1, CkReady    # If ready bit is 0, loop until it's 1
    lw $v0, 4($a3)       # Load character from keyboard data register into $v0
    jr $ra               # Return to caller

PUTCHAR:
    lui $a3, 0xFFFF      # Load upper half of MMIO base address into $a3
XReady:
    lw $t1, 8($a3)       # Read from transmitter control register
    andi $t1, $t1, 0x1   # Extract ready bit
    beqz $t1, XReady     # If not ready, loop until ready
    sw $a0, 12($a3)      # Send character to display
    jr $ra               # Return to caller
