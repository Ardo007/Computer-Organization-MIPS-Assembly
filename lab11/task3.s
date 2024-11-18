.data
prompt_a:      .asciiz "Enter input a (0 or 1) or enter -1 to exit: "
prompt_b:      .asciiz "Enter input b (0 or 1) or enter -1 to exit : "
prompt_carryin:.asciiz "Enter input CarryIn (0 or 1) or enter -1 to exit: "
newline:       .asciiz "\n"
carryout_msg:  .asciiz "CarryOut: "

    .text
    .globl main

main:

    addu $s7, $0, $ra       # save the return address in a global register


    li $v0, 4                 
    la $a0, prompt_a           
    syscall

    li $v0, 5                 
    syscall
    move $t0, $v0             

    li $v0, 4
    la $a0, newline
    syscall

    # Check if a == -1 to exit
    li $t7, -1
    beq $t0, $t7, exit_program

    li $v0, 4
    la $a0, prompt_b
    syscall

    li $v0, 5
    syscall
    move $t1, $v0             

    li $v0, 4
    la $a0, newline
    syscall


    # Check if b == -1 to exit
    beq $t1, $t7, exit_program

    li $v0, 4
    la $a0, prompt_carryin
    syscall

    li $v0, 5
    syscall
    move $t2, $v0             

    li $v0, 4
    la $a0, newline
    syscall


    # Check if CarryIn == -1 to exit
    beq $t2, $t7, exit_program

    # Perform AND, OR operations according to the logic
    # CarryOut = (a AND b) OR (CarryIn AND (a OR b))

    and $t3, $t0, $t1         # $t3 = a AND b
    or  $t4, $t0, $t1         # $t4 = a OR b
    and $t5, $t2, $t4         # $t5 = CarryIn AND (a OR b)
    or  $t6, $t3, $t5         # $t6 = (a AND b) OR (CarryIn AND (a OR b))

    # Output the CarryOut
    li $v0, 4
    la $a0, carryout_msg
    syscall

    li $v0, 1                 
    move $a0, $t6             # move CarryOut to $a0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Jump back to main for new inputs
    j main

exit_program:
    addu $ra, $0, $s7        # Restore the original return address
    jr   $ra                 # Return to the caller (exit program)