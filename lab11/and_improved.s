                  .data
    message1:     .asciiz "\n\nInput 0 or 1 for a: "          
    message2:     .asciiz "Input 0 or 1 for b: "            
    message3:     .asciiz "           a AND b: "            
    message4:     .asciiz "\n---------------------"        
    invalid_msg:  .asciiz "Invalid input. Please enter 0 or 1: "  

    .text
    .globl main

main:
    addu $s7, $0, $ra       # save the return address in a global register

    # ------------------------------------ Getting input for 'a'
input_a:
    li   $v0, 4              
    la   $a0, message1       
    syscall

    li   $v0, 5              
    syscall
    add  $s3, $0, $v0        # $s3 = input for 'a'

validate_a:
    # Check if input 'a' is 0
    beq  $s3, $zero, a_valid

    # Check if input 'a' is 1
    li   $t1, 1
    beq  $s3, $t1, a_valid

    # If input is neither 0 nor 1, prompt again
    li   $v0, 4              
    la   $a0, invalid_msg    
    syscall

    # Read integer input again for 'a'
    li   $v0, 5              # syscall code for read_int
    syscall
    add  $s3, $0, $v0        # $s3 = new input for 'a'

    j validate_a              # Repeat validation

a_valid:
    # ------------------------------------ Getting input for 'b'
input_b:
    li   $v0, 4              
    la   $a0, message2       
    syscall

    li   $v0, 5              
    syscall
    add  $s4, $0, $v0        # $s4 = input for 'b'

validate_b:
    # Check if input 'b' is 0
    beq  $s4, $zero, b_valid

    # Check if input 'b' is 1
    li   $t1, 1
    beq  $s4, $t1, b_valid

    # If input is neither 0 nor 1, prompt again
    li   $v0, 4              # syscall code for print_string
    la   $a0, invalid_msg    # load address of invalid_msg
    syscall

    li   $v0, 5              
    syscall
    add  $s4, $0, $v0        # $s4 = new input for 'b'

    j validate_b              # Repeat validation

b_valid:
    # ------------------------------------ Calculating (a AND b)
    and  $t0, $s3, $s4       # $t0 = a AND b

    # ------------------------------------ Printing (a AND b) on the console
    li   $v0, 4              
    la   $a0, message3       
    syscall

    # Print the result of a AND b
    li   $v0, 1              
    add  $a0, $0, $t0        # $a0 = $t0 (result of a AND b)
    syscall  

    li   $v0, 4              
    la   $a0, message4       
    syscall

    # Loop back to main to allow new inputs
    j  main                  # Jump back to main

    # ------------------------------------ Usual stuff at the end of main
    addu $ra, $0, $s7        # Restore the original return address
    jr   $ra                 # Return to the caller (exit program)