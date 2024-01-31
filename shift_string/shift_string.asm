.data

# m = shift_amount (say 2)
# s = asciiz string ("Hello there!")
# l = length of the string (12)

goodbyeMsg: .asciiz "Goodbye!"

buffer: .asciiz "Hello there!\n"    # string
l: .word 12                  # Length of word
m: .word 3                   # Shift amount
buffer1: .space 31
buffer2: .space 31
buffer3: .space 31
end_loop_msg: .asciiz "Ended first loop!\n"

.text

main:


# Loop1: (working) # COPY FROM m TO l

    lw $s1, l        # Load the length of the string into $t0
    li $t0, 0        # Initialize loop counter (i) to 0
    lb $s2, m

Loop: # copy from m to l
    beq $s2, $s1, ExitLoop # Exit the loop if i == l

    la $a0, buffer          # Load address of the string into $a0    # $a0 = buffer
    add $t1, $s2, $a0  # Calculate address of s[i]              # $t1 = $a0 + $s2 ($t1 = s + (i + m))
    lb $t1, 0($t1)     # Load byte from s[i] into $t1           # $t1 = s[s + (i+m)]

    la $a0, buffer1    # Load address of buffer1 into $a0       
    add $t2, $t0, $a0  # Calculate address of buffer1[i]        # buffer_adderss = i + b
    sb $t1, 0($t2)     # Store byte at buffer1[i]               # $t1 -> buffer[i + b]

    addi $t0, $t0, 1   # Increment loop counter (i)             # i = i + 1
    addi $s2, $s2, 1   # Increment shifted counter (i + m)      # m = m + 1
    j Loop   
    
    # Notes: 
    	# $s1 -> l
        # $t0 -> i
        # $s2 -> shifted i: i + m
        # $t1 -> i + s, then s[i + s]
        # $t2 -> i + b
        
ExitLoop:

# COPY FROM 0 TO m

    lw $s1, l        # Load the length of the string into $t0        # $s1 -> l
    lw $s2, m                                                        # $s2 -> m (= 2)
    li $t0, 0        # Initialize loop counter (i) to 0              # $t0 -> (i) = 0

Loop2: # copy from 0 to m
    beq $t0, $s2, ExitLoop2 # Exit the loop if i == m

    la $a0, buffer          # Load address of the string into $a0
    add $t1, $t0, $a0  # Calculate address of s[i]
    lb $t1, 0($t1)     # Load byte from s[i] into $t1
    
    # PRINT t1
        # move $a0, $t1
        # li $v0, 11
        # syscall
        
    # WE NEED TO PUT $t1 INTO buffer[l - m + i], that is into address b + l - m + i
    # la $a0, buffer1    # Load address of buffer1 into $a0
    la $a0, buffer2     # b
    add $a0, $a0, $t0   # b + i
    
    sb $t1, 0($a0)     # put $t1 into address b + l + i - m
    addi $t0, $t0, 1   # Increment loop counter (i)
    j Loop2
    
    # Notes: 
    	# $s1 -> l
        # $t0 -> i
        # $s2 -> shifted i: i + m
        # $t1 -> i + s, then s[i + s]
        # $t2 -> i + b
        
ExitLoop2:

#############################################################
#                                                           #
#     buffer1 : "llo there!"                                #
#     buffer2 : "He"                                        #
#                                                           #
#############################################################

li $t0, 0 # $t0 -> i 
lw $s1, m # $s1 -> m
lw $s2, l # $s2 -> l

Loop3: # concatinate buffer1 into buffer2 + buffer1

sub $s3, $s1, 0
beq $t0, $s3, ExitLoop3 # branch if i = m - 1

# $a0 -> index of retrieval: i + buffer2
la $a0, buffer2
add $a0, $t0, $a0 # $a0 -> i + buffer2
lb $t1, 0($a0) # $t1 contains buffer2[i + buffer2] ("H")

# $a1 -> index of placement: 
la $a1, buffer1
add $a1, $a1, $s2 # $a1 -> buffer2 + l
sub $a1, $a1, $s1 # $a1 -> buffer2 + l - m
add $a1, $a1, $t0
sb $t1, 0($a1)

addi, $t0, $t0, 1

j Loop3

ExitLoop3:

#############################################################
#                                                           #
#     buffer1 : "llo there!He"                              #
#                                                           #
#############################################################


# Exit the program
li $v0, 10
syscall