    .data
    .align 2
Z:  .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
X:  .word 0 


    .text
    .globl main

main: 
    addu $s7, $0, $ra

    #load base address of Z into $s3
    la $s3, Z       

    #load base address of X into $s4
    la $s4, X

    #calculating  X = Z[3] - Z[5]
    lw $t0,  12($s3)    # load Z[3] into $t0

    lw $t1,  20($s3)    #load Z[5] into $t0

    sub $t2, $t0, $t1       # Calculate X = Z[3] - Z[5]
    sw $t2, 0($s4)      # Store X in memory

    .data
    .globl message
message:  .asciiz "the result of X = Z[3] - Z[5] is: "
    .text

    #print string message to console
    li $v0, 4
    la $a0, message
    syscall

    # print the result to console 
    li $v0, 1
    add $a0, $0,  $t2
    syscall


    addu $ra, $0, $s7
    jr $ra


