.data
    buffer1: .space 100           # 100 bytes of space; 100 ascii characters
    buffer2: .space 100
    first_name: .asciiz "First name: "
    last_name: .asciiz "Last name: "
    you_entered: .asciiz "You entered: "
    newline: .asciiz "\n"
    space: .asciiz " "
    comma: .asciiz ","
    period: .asciiz "."

.text
.globl main

main:

la $a0, first_name                # Display first name prompt
jal Puts

la $a0, buffer1                   # Set buffer1 (empty space) as the first argument
li $a1, 20                        # Set a limit of 20 characters as the second argument
jal Gets                          # Get user input for first name

la $a0, buffer1                   # Display first name
jal Puts

la $a0, newline                   # Move one line down
jal Puts

la $a0, last_name                 # Display last name prompt
jal Puts

la $a0, buffer2                   # Set buffer1 (empty space) as the first argument
li $a1, 20                        # Set a limit of 20 characters as the second argument
jal Gets                          # Get user input for last name

la $a0, buffer2                   # Display last name
jal Puts

la $a0, newline                   # Move one line down
jal Puts

la $a0, you_entered               # Display "you entered: " prompt
jal Puts

la $a0, buffer2                   # Display last name
jal Puts

la $a0, comma                     # Format
jal Puts

la $a0, space                     # More format
jal Puts

la $a0, buffer1                   # Display last name prompt
jal Puts

la $a0, period                    # Final format
jal Puts

li $v0, 10                        # Exit the program
syscall

Gets:
    addi $sp, $sp, -24            # Decrement stack pointer
    sw $ra, 20($sp)               # Save $ra
    sw $s0, 16($sp)               # Save $s0
    sw $s1, 12($sp)               # Save $s1
    sw $s3, 8($sp)                # Save $s3
    sw $a0, 4($sp)                # Save $a0
    sw $a1, 0($sp)                # Save $a1

    li $s0, 0                     # Initialize counter
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

    lw $ra, 20($sp)               # Restore $ra
    lw $s0, 16($sp)               # Restore $s0
    lw $s1, 12($sp)               # Restore $s1
    lw $s3, 8($sp)                # Restore $s3
    addi $sp, $sp, 24             # Increment stack pointer

    jr $ra                        # Return to caller

Puts:
    addi $sp, $sp, -20            # Decrement the stack pointer
    sw $ra, 16($sp)               # Push return address onto stack
    sw $s0, 12($sp)               # Save $s0
    sw $s1, 8($sp)                # Save $s1
    sw $s4, 4($sp)                # Save $s4
    sw $a0, 0($sp)                # Save $a0
    move $s4, $a0                 # Salvage the argument to the function
    li $s0, 0                     # Initialize the counter
Loop2:                            
    move $s1, $s4                 # Get base index for buffer
    add $s1, $s1, $s0             # Add counter amount
    lb $a0, 0($s1)                # Load correct index onto argument for PUTCHAR
    beq $a0, $zero, ExitLoop2     # Exit if you see a null
    jal PUTCHAR                   # Output the character
    addi $s0, $s0, 1              # Increment the counter
    j Loop2                       # Loop
ExitLoop2:
    lw $ra, 16($sp)               # Restore $ra
    lw $s0, 12($sp)               # Restore $s0
    lw $s1, 8($sp)                # Restore $s1
    lw $s4, 4($sp)                # Restore $s4
    addi $sp, $sp, 20         
    jr $ra                        # Jump to return address

    

GETCHAR:
    lui $a3, 0xFFFF               # Load upper half of MMIO base address into $a3
CkReady:
    lw $t1, 0($a3)                # Read from receiver control register (status register)
    andi $t1, $t1, 0x1            # Extract ready bit (LSB)
    beqz $t1, CkReady             # If ready bit is 0, loop until it's 1
    lw $v0, 4($a3)                # Load character from keyboard data register into $v0
    jr $ra                        # Return to caller

PUTCHAR:
    lui $a3, 0xFFFF               # Load upper half of MMIO base address into $a3
XReady:         
    lw $t1, 8($a3)                # Read from transmitter control register
    andi $t1, $t1, 0x1            # Extract ready bit
    beqz $t1, XReady              # If not ready, loop until ready
    sw $a0, 12($a3)               # Send character to display
    jr $ra                        # Return to caller
