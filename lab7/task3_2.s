    .data
prompt_p:    .asciiz "Enter value of p (0 to exit): "
prompt_n:    .asciiz "Enter value of n: "
prompt_m:    .asciiz "Enter value of m: "
error_msg:   .asciiz "Error: Sum of n and m cannot exceed 32. Program terminating.\n"
result_unsigned: .asciiz "Unsigned result: "
result_signed:   .asciiz "Signed result: "

    .text
    .globl main

main:
    # Main program loop to read p, n, m
main_loop:
    li $v0, 4               # Print prompt for p
    la $a0, prompt_p
    syscall

    li $v0, 5               # Read integer input for p
    syscall
    move $a2, $v0           # Store p in $a2

    beq $a2, $zero, end_program   # If p is 0, terminate

    li $v0, 4               # Print prompt for n
    la $a0, prompt_n
    syscall

    li $v0, 5               # Read integer input for n
    syscall
    move $a0, $v0           # Store n in $a0

    li $v0, 4               # Print prompt for m
    la $a0, prompt_m
    syscall

    li $v0, 5               # Read integer input for m
    syscall
    move $a1, $v0           # Store m in $a1

    # Check if n + m exceeds 32
    add $t0, $a0, $a1       # t0 = n + m
    li $t1, 32
    blt $t0, $t1, error     # If n + m > 32, go to error

    # Call extractExt procedure
    jal extractExt

    # Print unsigned result
    li $v0, 4               # Print unsigned result message
    la $a0, result_unsigned
    syscall

    li $v0, 1               # Print unsigned value of $v1 (the extracted field)
    move $a0, $v1
    syscall

    # Print signed result
    li $v0, 4               # Print signed result message
    la $a0, result_signed
    syscall

    li $v0, 1               # Print signed value of $v1 (the extracted field, but signed)
    move $a0, $v1
    syscall

    j main_loop             # Loop back to read new inputs

error:
    li $v0, 4               # Print error message
    la $a0, error_msg
    syscall
    j end_program

end_program:
    li $v0, 10              # Exit syscall
    syscall

# Procedure to extract the n-bit field from p starting at bit m
extractExt:
    # Parameters:
    # p -> $a2
    # n -> $a0
    # m -> $a1

    # Step 1: Build the mask
    li $t0, -1              # Load -1 into $t0, which is 1111...1111 (all 1s)
    sub $t1, $t1, $a0       # t1 = 32 - n
    srlv $t0, $t0, $t1      # Shift $t0 right by (32 - n), mask is ready (n-bit mask)
    sllv $t0, $t0, $a1      # Shift the mask left by m, mask is now aligned properly

    # Step 2: Extract the n-bit field
    and $t2, $a2, $t0       # Perform AND operation between p and mask
    srlv $v1, $t2, $a1      # Shift the result right by m to align the extracted field in $v1

    # Step 3: Check if the extracted value should be treated as a signed number
    # Check if the most significant bit of the extracted n-bit field is 1 (which means negative if signed)
    li $t3, 1               # Load 1 into $t3
    sub $t4, $a0, 1         # t4 = n - 1 (to get the position of the MSB)
    sllv $t3, $t3, $t4      # t3 = 1 << (n-1) (get the mask for the MSB)
    and $t3, $v1, $t3       # Check if MSB is 1

    beqz $t3, return_unsigned # If MSB is 0, no sign extension is needed, return unsigned result

    # Step 4: Perform sign extension
    li $t4, -1              # Load -1 (all 1s) into $t4
    sllv $t4, $t4, $a0      # Shift the -1 left by n bits to prepare for sign extension
    or $v1, $v1, $t4        # Perform sign extension on the extracted n-bit field

return_unsigned:
    jr $ra                  # Return to the main program