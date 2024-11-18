    .data
prompt: .asciiz "Enter a number (0 to exit): "
signed_msg: .asciiz "\nSigned value: "
unsigned_msg: .asciiz "\nUnsigned value: "

    .text
    .globl main

main:
    # Loop to keep asking for input
loop:
    # Prompt the user for input
    li $v0, 4              # Syscall code for print_string
    la $a0, prompt          # Load address of the prompt
    syscall

    li $v0, 5              # Syscall code for read_int
    syscall                 # Get the integer input from the user
    move $t0, $v0           # Store the input in $t0 (this is p)

    # Check if the input is 0, if yes, terminate the program
    beq $t0, $zero, exit    # If p == 0, jump to exit

    # Call the extract procedure
    jal extract

    # Display the unsigned value
    li $v0, 4              # Syscall code for print_string
    la $a0, unsigned_msg    # Load the unsigned message
    syscall

    move $a0, $v1           # Move the unsigned result (stored in $v1) to $a0
    li $v0, 1               # Syscall code for print_int
    syscall

    # Check if the extracted value should be interpreted as negative (signed)
    bge $v1, 16, adjust_signed  # If value >= 16 (bit 4 is 1), adjust to negative

    # Print the signed value (if it's positive, print as is)
    li $v0, 4              # Syscall code for print_string
    la $a0, signed_msg      # Load the signed message
    syscall

    move $a0, $v1           # Move the positive signed result to $a0
    li $v0, 1               # Syscall code for print_int (signed)
    syscall

    # Loop back to prompt for next input
    j loop

# Adjust signed value if it's negative
adjust_signed:
    li $t1, 32             # Load 32 into $t1
    subu $v1, $v1, $t1     # Subtract 32 from $v1 to get the signed value

    # Print the signed value (if it's negative)
    li $v0, 4              # Syscall code for print_string
    la $a0, signed_msg      # Load the signed message
    syscall

    move $a0, $v1           # Move the negative signed result to $a0
    li $v0, 1               # Syscall code for print_int (signed)
    syscall

    # Loop back to prompt for next input
    j loop

# Extract procedure: Extract 5 bits from bit position 3
extract:
    # Assume the input is in $t0 (the value of p)
    # We need to extract the 5-bit field starting from bit 3 (bit positions 3 to 7)

    srl $t1, $t0, 3         # Shift right by 3 bits to move the target bits to the rightmost position
    andi $v1, $t1, 0x1F     # Mask to keep only the lowest 5 bits (11111 in binary)

    jr $ra                  # Return to the caller

exit:
    li $v0, 10              # Syscall code for exit
    syscall                 # Exit the program
