.data

buffer1: .space 100
n: .word 5
m: .word 5

.text

main:
	lw $a0, n
	jal Fact
	move $a0, $v0
	
	sw $a0, m


Fact:
	addi $sp, $sp, -8           # add space to the pointer
	sw $ra, 4($sp)              # add return address to the stack
	sw $a0, 0($sp)              # add n to the stack

	slti $t0, $a0, 1            # if a0 is greater than or equal to 1, go to L1
	beq $t0, $zero, L1

	addi $v0, $zero, 1          # return 1 (set $v0 equal to 1)
	addi $sp, $sp, 8            # pop two elements
	jr $ra                      # go to after jal

L1:                                 # (if a0 is greater than or equal to 1) 
	addi $a0, $a0, -1           # Decrement $a0
	jal Fact                    # call factorial

	lw $a0, 0($sp)              # (after fact returns) restore argument $n$
	lw $ra, 4($sp)              # restore old return address
	addi $sp, $sp, 8            # pop the stack

	mul $v0, $a0, $v0           # Perform the multiplication
	jr $ra                      # Go to the last call