.data

buffer1:  .space 31             # Input string
buffer2:  .space 31             # Shifted string
m_string: .space 31             # Input number
m: .word 3                      # Number converted to integer after cleanup
l: .word 12                     # Length of s

.text

main:

# ask for input to get string --> s
# throw error if string is bad
# find length of string --> l
# ask for input to get string
# throw error if string is bad
# convert ascii m to number --> m
# change m --> m mod l

