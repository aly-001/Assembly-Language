# Print out the letter "a" and then newline

li $a0, 'a'        # Load the ASCII value of newline ('\n') into $a0
li $v0, 11         # Set $v0 to 11, the syscall for printing a character
syscall            # Execute the syscall to print

li $a0, 10         # Load the ASCII value of newline ('\n') into $a0
li $v0, 11         # Set $v0 to 11, the syscall for printing a character
syscall            # Execute the syscall to print