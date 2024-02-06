#########
#       #
#   1   #   ---  Ask for input to get string
#       #
#########

#########
#       #
#   2   #   ---  Throw error if string is bad
#       #
#########

#########
#       #
#   3   #   ---  Find length of number string, store it in l
#       #
#########

#########
#       #
#   4   #   ---  Ask for input to get number string
#       #
#########

#########
#       #
#   5   #   ---  Throw error if number string is bad
#       #
#########

#########
#       #
#   6   #   ---  Convert ascii string to number, store it in m
#       #
#########

#########
#       #
#   7   #   ---  Change m to m = l mod m
#       #
#########

#########
#       #
#   8   #   ---  Copy string from m to 1, store in buffer1
#       #
#########

#########
#       #
#   9   #   ---  Copy string from 0 to m, store in buffer2
#       #
#########

#########
#       #
#   10  #   ---  Concatinate buffer1 and buffer 2, store in buffer1
#       #
#########

.data

string_prompt: .asciiz   "Please enter a string: "
m_string_prompt: .asciiz "Please enter a number: "
error_1_msg: .asciiz     "String invalid. Run again."
error_2_msg: .asciiz     "Number, or number mod string length invalid. Run again."


buffer:   .space 31             # Input string
buffer1:  .space 31             # Shifted string
buffer2:  .space 31             # Intermediate for storing end
m_string: .space 31             # Input number
m: .word 3                      # Number converted to integer after cleanup
l: .word 12                     # Length of s

.text

main:

#########
#       #
#   1   #   ---  Ask for input to get string
#       #
#########

# Print prompt for user input
li $v0, 4                   # Syscall for print string
la $a0, string_prompt       # Load address of prompt string
syscall                     # Print prompt

# Read string from user input
li $v0, 8                   # Syscall number for reading a string
la $a0, buffer              # Load address of buffer to store the input string
li $a1, 31                  # Maximum number of characters to read
syscall                     # Read string from console into buffer

#########
#       #
#   2   #   ---  Throw error if string is bad
#       #
#########

lb $t0, buffer               # Load the first byte of buffer
li $t1, 10                   # ASCII value for newline
beq $t0, $t1, Error1         # Branch to Error1 if input is just '\n'

#########
#       #
#   3   #   ---  Find length of number string, store it in l
#       #
#########

li $t0, 0                 # Initialize index counter to 0
la $a0, buffer            # Load the base address of buffer into $a0 only once

FindLength:
    add $t2, $a0, $t0     # Calculate current address to check by adding index $t0 to base address $a0
    lb $t1, 0($t2)        # Load a byte from the calculated address into $t1
    beqz $t1, StoreLength # If $t1 is 0 (null terminator), go to StoreLength
    addi $t0, $t0, 1      # Increment the length counter/index
    j FindLength          # Jump back to continue through the string

StoreLength:
    subi $t0, $t0, 1
    la $a1, l             # Load the address of the variable l into $a1
    sw $t0, 0($a1)        # Store the length of the string in l
    
#########
#       #
#   4   #   ---  Ask for input to get number string
#       #
#########

# Print prompt for user input
li $v0, 4                   # Syscall for print string
la $a0, m_string_prompt     # Load address of prompt string
syscall                     # Print prompt

# Read string from user input
li $v0, 8                    # Syscall number for reading a string
la $a0, m_string             # Load address of buffer to store the input string
li $a1, 31                   # Maximum number of characters to read
syscall                      # Read string from console into buffer

#########
#       #
#   5   #   ---  Throw error if number string is bad
#       #
#########

lb $t0, m_string             # Load the first byte of buffer
li $t1, 10                   # ASCII value for newline
beq $t0, $t1, Error2         # Branch to Error1 if input is just '\n'

#########
#       #
#   6   #   ---  Convert ascii string to number, store it in m
#       #
#########

la $a0, m_string      # Load the address of the string
li $t1, 0             # Initialize total to 0
li $t2, 0             # Counter for the position of each digit in the string

StringLengthLoop:
    lb $t0, 0($a0)          # Load the next byte (character) from the string
    li $t7, 10
    beq $t0, $t7, Check_finished # skip the number check if you're a '/n'
    
    Check: # Check if character is not between '0' and '9'
    li $t8, 48              # ASCII value for '0'
    blt $t0, $t8, Error2    # If character is less than '0', exit
    li $t9, 57              # ASCII value for '9'
    bgt $t0, $t9, Error2    # If character is greater than '9', exit
    
    Check_finished:
    li $t7, 10              # Load ASCII value for newline ('\n') into $t7
    beq $t0, $t7, Convert   # If we hit the newline character, start conversion
    addi $a0, $a0, 1        # Move to the next character in the string
    addi $t2, $t2, 1        # Increment the counter
    j StringLengthLoop      # Loop back

Convert:
    la $a0, m_string      # Reset $a0 to point to the start of the string again
    li $t3, 0             # Reset counter for conversion loop

ConvertLoop:
    beq $t3, $t2, StoreResult # If we've processed all characters, store the result
    lb $t0, 0($a0)            # Load the next byte (character) from the string
    addi $t0, $t0, -48        # Convert from ASCII to integer ('0' -> 0, '1' -> 1, ...)
    li $t4, 10
    sub $t5, $t2, $t3         # Calculate the power of 10 needed
    subi $t5, $t5, 1          # Adjust for zero-based index
    li $t6, 1

PowerLoop:                    # Calculate 10^$t5
    beqz $t5, Multiply
    mul $t6, $t6, $t4
    addi $t5, $t5, -1
    j PowerLoop

Multiply:
    mul $t0, $t0, $t6          # Multiply digit by its positional value
    add $t1, $t1, $t0          # Add to total
    addi $a0, $a0, 1           # Move to the next character in the string
    addi $t3, $t3, 1           # Increment conversion counter
    j ConvertLoop              # Continue conversion loop

StoreResult:
    
    sw $t1, m                  # Store the final result in 'total'
    
#########
#       #
#   7   #   ---  Change m to m = l mod m
#       #
#########

# m becomes l mod m

lw $t0, m         # Load value of m into $t0
lw $t1, l         # Load value of l into $t1
 
div $t0, $t1      # Divide $t0 by $t1; quotient goes to LO, remainder to HI
mfhi $t2          # Move the remainder (HI) to $t2

beqz $t2, Error2  # Error if it's 0
sw $t2, m         # Store the result back in m

#########
#       #
#   8   #   ---  Copy string from m to 1, store in buffer1
#       #
#########

lw $s1, l        # Load the length of the string into $t0
li $t0, 0        # Initialize loop counter (i) to 0
lb $s2, m        # Store m in $s2

Loop: # copy from m to l
    beq $s2, $s1, ExitLoop # Exit the loop if i == l

    la $a0, buffer         # Load address of the string into $a0    # $a0 = buffer
    add $t1, $s2, $a0      # Calculate address of s[i]              # $t1 = $a0 + $s2 ($t1 = s + (i + m))
    lb $t1, 0($t1)         # Load byte from s[i] into $t1           # $t1 = s[s + (i+m)]

    la $a0, buffer1        # Load address of buffer1 into $a0       
    add $t2, $t0, $a0      # Calculate address of buffer1[i]        # buffer_adderss = i + b
    sb $t1, 0($t2)         # Store byte at buffer1[i]               # $t1 -> buffer[i + b]

    addi $t0, $t0, 1       # Increment loop counter (i)             # i = i + 1
    addi $s2, $s2, 1       # Increment shifted counter (i + m)      # m = m + 1
    j Loop   
        
ExitLoop:

#########
#       #
#   9   #   ---  Copy string from 0 to m, store in buffer2
#       #
#########


    lw $s1, l        # Load the length of the string into $t0        # $s1 -> l
    lw $s2, m        # Load the shift amount into $s2                # $s2 -> m 
    li $t0, 0        # Initialize loop counter (i) to 0              # $t0 -> i

Loop2: # copy from 0 to m
    beq $t0, $s2, ExitLoop2 # Exit the loop if i == m

    la $a0, buffer          # Load address of the string into $a0
    add $t1, $t0, $a0       # Calculate address of s[i]
    lb $t1, 0($t1)          # Load byte from s[i] into $t1
    

    la $a0, buffer2         # b
    add $a0, $a0, $t0       # b + i
    
    sb $t1, 0($a0)          # put $t1 into address b + l + i - m
    addi $t0, $t0, 1        # Increment loop counter (i)
    j Loop2
        
ExitLoop2:

#########
#       #
#   10  #   ---  Concatinate buffer1 and buffer 2, store in buffer1
#       #
#########

li $t0, 0    # $t0 -> i 
lw $s1, m    # $s1 -> m
lw $s2, l    # $s2 -> l

Loop3:

    sub $s3, $s1, 0
    beq $t0, $s3, ExitLoop3 # branch if i = m - 1

    la $a0, buffer2
    add $a0, $t0, $a0       # Find index of retrieval
    lb $t1, 0($a0)          # Load buffer2[i + buffer2]

    la $a1, buffer1         # buffer2
    add $a1, $a1, $s2       # buffer2 + l
    sub $a1, $a1, $s1       # buffer2 + l - m
    add $a1, $a1, $t0       # buffer2 + l - m + i
    sb $t1, 0($a1)          # Store at correct address

    addi, $t0, $t0, 1       # Increment i

    j Loop3

ExitLoop3:

j Exit


Error1:
la $a0, error_1_msg
li $v0, 4
syscall
j Quit

Error2:
la $a0, error_2_msg
li $v0, 4
syscall
j Quit


Exit:

li $a0, '['
li $v0, 11
syscall

# Final string
la $a0, buffer1
li $v0, 4
syscall

li $a0, ']'
li $v0, 11
syscall

Quit:
# EXIT PROGRAM
li $v0, 10
syscall