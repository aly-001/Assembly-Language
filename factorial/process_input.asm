# In order to properly interface with 'factorial.asm' we need to
# be able to ask for input, and store that input as an integer into n,
# using sw $a0, n

.data
string_prompt: .asciiz "Please input an integer value greater than or equal to 0: "
error_string: .asciiz  "The value you entered is less than zero. This program only works with values greater than or equal to zero."
question_string: .asciiz "Would you like to run again?"
your_input: .asciiz "Your input: "
the_factorial_is: .asciiz "The factorial is: "
continue: .asciiz "Would you like to continue (Y/N)? "

yes_string_buffer: .asciiz "Y\n"

m: .word 5
n: .word 5

.text
main:
    # print the prompt:
    la $a0, string_prompt
    li $v0, 4
    syscall

    # read and store an integer:
    li $v0, 5
    syscall
    sw $v0, m
    
    # validate:
    lw $t0, m
    slti $t1, $t0, 0
    bne $t1, $zero, Error
    
    # Call factorial function on m and store result in m
    lw $t0, m
    addi $t0, $t0, 1
    sw $t0, n
    
    # your input (m)
    la $a0, your_input
    li $v0, 4
    syscall
    lw $t0, m
    move $a0, $t0
    li $v0, 1
    syscall
    
    # newline
    li $a0, 10
    li $v0, 11
    syscall
    
    # the factoriall is (n)
    la $a0, the_factorial_is
    li $v0, 4
    syscall
    lw $t0, n
    move $a0, $t0
    li $v0, 1
    syscall
    
    # newline
    li $a0, 10
    li $v0, 11
    syscall
    
    # print the prompt
    la $a0, continue
    li $v0, 4
    syscall

    # Read a string (up to 2 characters to account for "Y\n")
    la $a0, yes_string_buffer  # Address of buffer to store input
    li $a1, 3       # Maximum number of characters to read (including '\n' and null terminator)
    li $v0, 8
    syscall
    
    la $a0, yes_string_buffer
    lb $t0, 0($a0)
    li $t1, 'Y'
    beq $t0, $t1, Yes
    
    j Exit
    
Yes:
    j main
    
Error:
    la $a0, error_string
    li $v0, 4
    syscall
    j Exit

Exit:
    li $v0, 10
    syscall