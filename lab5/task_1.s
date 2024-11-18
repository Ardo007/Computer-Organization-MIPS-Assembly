# MIPS program to read and display two integer arrays

            .data
    arrayP: .space 36  # allocate space for the arrays p and q
    arrayQ: .space 36  
    promptN: .asciiz "Enter the value of N (1-9): "
    promptValue: .asciiz "Enter value for array P: "
    outputP: .asciiz "Array P: "
    outputQ: .asciiz "Array Q: "
    space: .asciiz " "

    .text
    .globl main

    main:
        addu  $s7, $0, $ra

        # Read the value of N
        li $v0, 4
        la $a0, promptN
        syscall
        li $v0, 5
        syscall
        move $t0, $v0  # N is stored in $t0



        # Initialize the base addresses of the arrays
        la $t1, arrayP
        la $t2, arrayQ

        # Read values for array P
        li $t3, 0  # counter
        readLoop:
            li $v0, 4
            la $a0, promptValue
            syscall
            li $v0, 5
            syscall
            move $t4, $v0  # value is stored in $t4

            # Store the value in array P
            sw $t4, ($t1)
            # Store the same value in array Q
            sw $t4, ($t2)

            # Increment the counter and the base addresses
            addi $t3, $t3, 1
            addi $t1, $t1, 4
            addi $t2, $t2, 4

            # Check if we've read N values
            blt $t3, $t0, readLoop

        # Output the values of array P
        la $t1, arrayP
        li $v0, 4
        la $a0, outputP
        syscall
        li $t3, 0  # counter
        outputPLoop:
            # Load the value from array P
            lw $t4, ($t1)

            # Output the value
            li $v0, 1
            move $a0, $t4
            syscall

            # Output a space
            li $v0, 4
            la $a0, space
            syscall

            # Increment the counter and the base address
            addi $t3, $t3, 1
            addi $t1, $t1, 4

            # Check if we've output N values
            blt $t3, $t0, outputPLoop

        # Output a newline
        li $v0, 4
        la $a0, space
        syscall

        # Output the values of array Q
        la $t2, arrayQ
        li $v0, 4
        la $a0, outputQ
        syscall
        li $t3, 0  # counter
        outputQLoop:
            # Load the value from array Q
            lw $t4, ($t2)

            # Output the value
            li $v0, 1
            move $a0, $t4
            syscall

            # Output a space
            li $v0, 4
            la $a0, space
            syscall

            # Increment the counter and the base address
            addi $t3, $t3, 1
            addi $t2, $t2, 4

            # Check if we've output N values
            blt $t3, $t0, outputQLoop

           
    addu  $ra, $0, $s7      # restore the return address
    jr  $ra                 # return to the main program
    add  $0, $0, $0         # nop
        
