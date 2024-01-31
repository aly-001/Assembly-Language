.data

string_prompt: .asciiz "Please enter a string: "
error_1_msg: .asciiz "String invalid. Run again."

buffer:   .space 31             # Input string
buffer1:  .space 31             # Shifted string
buffer2:  .space 31             # Intermediate for storing end
m_string: .space 31             # Input number
m: .word 3                      # Number converted to integer after cleanup
l: .word 12                     # Length of s

.text

main:

# ask for input to get string --> buffer
# throw error if string is bad
# find length of string --> l
# ask for input to get string
# throw error if string is bad
# convert ascii m to number --> m
# change m --> m mod l





# Print prompt for user input (optional, requires a prompt string in .data)
li $v0, 4                   # syscall for print string
la $a0, string_prompt              # load address of prompt string
syscall                     # print prompt

# Read string from user input
li $v0, 8                    # syscall number for reading a string
la $a0, buffer               # load address of buffer to store the input string
li $a1, 31                   # maximum number of characters to read
syscall                      # read string from console into buffer

# Check if input is just '\n'

lb $t0, buffer               # Load the first byte of buffer
li $t1, 10                   # ASCII value for newline
beq $t0, $t1, Error1         # Branch to Error1 if input is just '\n'

    li $t0, 0             # Initialize index counter to 0
    la $a0, buffer        # Load the base address of buffer into $a0 only once

FindLength:
    add $t2, $a0, $t0     # Calculate current address to check by adding index $t0 to base address $a0
    lb $t1, 0($t2)        # Load a byte from the calculated address into $t1
    beqz $t1, StoreLength # If $t1 is 0 (null terminator), go to StoreLength
    addi $t0, $t0, 1      # Increment the length counter/index
    j FindLength          # Jump back to continue through the string

StoreLength:
    la $a1, l             # Load the address of the variable l into $a1
    sw $t0, 0($a1)        # Store the length of the string in l

j Exit



Error1:
la $a0, error_1_msg
li $v0, 4
syscall
j Exit

Exit:
# PRINT STRING AND EXIT
la $a0, buffer
li $v0, 4
syscall

la $a0, l
lw $a0, 0($a0)
li $v0, 1
syscall

li $v0, 10
syscall