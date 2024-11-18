    .data
prompt_p:       .asciiz "\nEnter a 32-bit integer value for p (0 to exit): "
prompt_n:       .asciiz "\nEnter an integer value for n: "
prompt_m:       .asciiz "\nEnter an integer value for m: "
error_message:  .asciiz "\nError: n + m must be <= 32. Program terminated."
result_signed:  .asciiz "\nExtracted signed value: "
result_unsigned:.asciiz "\nExtracted unsigned value: "
exit_message:   .asciiz "\nProgram terminated."
    .text
    .globl main

main:
    # Save return address
    addu $s7, $0, $ra

main_loop:
    # Prompt for value of p
    li $v0, 4               # syscall to print string
    la $a0, prompt_p
    syscall
    
    li $v0, 5               # syscall to read int
    syscall
    beqz $v0, exit_program  # if p == 0, terminate program
    move $a0, $v0           # move p into $a0
    
    # Prompt for value of n
    li $v0, 4               # syscall to print string
    la $a0, prompt_n
    syscall
    
    li $v0, 5               # syscall to read int
    syscall
    move $a1, $v0           # move n into $a1
    
    # Prompt for value of m
    li $v0, 4               # syscall to print string
    la $a0, prompt_m
    syscall
    
    li $v0, 5               # syscall to read int
    syscall
    move $a2, $v0           # move m into $a2
    
    # Check if n + m <= 32
    add $t0, $a1, $a2       # t0 = n + m
    li $t1, 32              # check if sum exceeds 32
    bgt $t0, $t1, error     # if n + m > 32, go to error
    
    # Call extractEx with p, n, and m
    jal extractEx           # jump to extractEx
    
    # Print signed result
    li $v0, 4               # syscall to print string
    la $a0, result_signed
    syscall
    move $a0, $v0           # signed value in $v0
    li $v0, 1               # syscall to print int
    syscall
    
    # Print unsigned result
    li $v0, 4               # syscall to print string
    la $a0, result_unsigned
    syscall
    move $a0, $v1           # unsigned value in $v1
    li $v0, 1               # syscall to print int
    syscall
    
    j main_loop             # loop back to main

error:
    # Error message
    li $v0, 4               # syscall to print string
    la $a0, error_message
    syscall
    j exit_program          

extractEx:
    # Parameters: p = $a0, n = $a1, m = $a2
    sub $sp, $sp, 8         # make space on stack
    sw $s0, 0($sp)          # save $s0
    sw $s1, 4($sp)          # save $s1
    
    # Step 1: Create mask for n bits
    li $t0, 1               # $t0 = 1
    sllv $t0, $t0, $a1      # $t0 = 1 << n
    sub $t0, $t0, 1         # $t0 = (1 << n) - 1 (mask for n bits)
    
    # Step 2: Shift mask to position m
    sllv $t0, $t0, $a2      # shift mask by m positions
    
    # Step 3: Extract bits by ANDing with p
    and $v0, $a0, $t0       # result in $v0 (signed result)
    
    # Step 4: Shift result right by m to position
    srlv $v0, $v0, $a2      # shift result to right by m positions
    
    # Step 5: Store unsigned result in $v1
    move $v1, $v0           # unsigned result in $v1
    
    lw $s0, 0($sp)          # restore $s0
    lw $s1, 4($sp)          # restore $s1
    add $sp, $sp, 8         # adjust stack
    jr $ra                  # return to caller

exit_program:
    # Exit program
    li $v0, 4               # syscall to print string
    la $a0, exit_message
    syscall
    
    li $v0, 10              # syscall to exit
    syscall
