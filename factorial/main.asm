.data
string_prompt:     .asciiz  "Please input an integer value greater than or equal to 0: "
error_string:      .asciiz  "The value you entered is less than zero. This program only works with values greater than or equal to zero."
question_string:   .asciiz  "Would you like to run again?"
your_input:        .asciiz  "Your input: "
the_factorial_is:  .asciiz  "The factorial is: "
continue:          .asciiz  "Would you like to continue (Y/N)? "

yes_string_buffer: .asciiz  "Y\n"

m: .word 5
n: .word 5

.text
main:
        la $a0, string_prompt          # print the prompt
        li $v0, 4             
        syscall

        
        li $v0, 5                      # read and store an integer:
        syscall
        sw $v0, m
        
        lw $t0, m                      # validate
        slti $t1, $t0, 0               # check less than 0
        bne $t1, $zero, Error          # print error
        
        lw $a0, m                      
        jal Fact                       # call factorial
        move $a0, $v0
        sw $a0, n                      # save n -> fact(m)
        
        la $a0, your_input             # print "your input (m)"
        li $v0, 4
        syscall
        lw $t0, m
        move $a0, $t0
        li $v0, 1
        syscall
        
        li $a0, 10                     # newline
        li $v0, 11
        syscall
        
        la $a0, the_factorial_is       # prints "the factorial is (n)"
        li $v0, 4
        syscall
        lw $t0, n
        move $a0, $t0
        li $v0, 1
        syscall
        
        li $a0, 10                     # newline
        li $v0, 11
        syscall
        
        la $a0, continue               # print the prompt to continue
        li $v0, 4
        syscall

        la $a0, yes_string_buffer      # address of buffer to store input
        li $a1, 3                        
        li $v0, 8                      # read the (Y/N) answer
        syscall
        
        la $a0, yes_string_buffer      
        lb $t0, 0($a0)                 # get first character
        li $t1, 'Y'                    # check if "Y"
        beq $t0, $t1, Yes              # jump to main if continue
        
        j Exit                         # exit the program
        
Yes:
        j main                         # jump to the top
    
Error:
        la $a0, error_string
        li $v0, 4
        syscall                        # print bad input error
        j Exit                         # jump to exit

Exit:
        li $v0, 10                     # goodbye
        syscall

Fact:
        addi $sp, $sp, -8              # add space to the pointer
        sw $ra, 4($sp)                 # add return address to the stack
        sw $a0, 0($sp)                 # add n to the stack
        
        slti $t0, $a0, 1               # if a0 is greater than or equal to 1, go to L1
        beq $t0, $zero, L1       
        
        addi $v0, $zero, 1             # return 1 (set $v0 equal to 1)
        addi $sp, $sp, 8               # pop two elements
        jr $ra                         # go to after jal
       
L1:                                    # (if a0 is greater than or equal to 1) 
        addi $a0, $a0, -1              # Decrement $a0
        jal Fact                       # call factorial
        
        lw $a0, 0($sp)                 # (after fact returns) restore argument $n$
        lw $ra, 4($sp)                 # restore old return address
        addi $sp, $sp, 8               # pop the stack
            
        mul $v0, $a0, $v0              # Perform the multiplication
        jr $ra                         # Go to the last call
