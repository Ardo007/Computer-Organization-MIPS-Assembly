    # we need Z[12] = Z[k] + Z[k+m]
    
    
    .data
    .align 2
Z:  .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    .space 120

k:  .word 0
m:  .word 0 
f:  .word 0

    .text
    .globl main
main: 
    addu  $s7, $0, $ra

    la $s0, Z

    .data
    .globl message1
message1:  .asciiz "Enter the value of k: "
    .text

# getting k
    li $v0, 4
    la $a0, message1
    syscall
    li $v0, 5
    syscall
    add $s3, $0, $v0
    sw $s3, k

# getting m
    .data
    .globl message2
message2:   .asciiz "Enter the value of m: "
    .text

    li $v0, 4
    la $a0, message2
    syscall
    li $v0, 5
    syscall
    add $s4, $0, $v0
    sw $s4, m

# calculte k + m and save it to $t0
    add $t0,  $s3, $s4


# doing Z[12] = Z[k] + Z[k+m]
    sll $t1, $s3, 2         #multiply k by 4 to adjust for index
    add $t1, $s0, $t1       #calculate the address of Z[k]

    sll $t0, $t0, 2         # multiply k+m by 4
    add $t2, $s0, $t0      #calculate adrress of Z[k+m]

    lw $s5,  0($t1)         #load Z[k]
    lw $s6,  0($t2)         #load Z[k+m]

    add $s1,  $s5, $s6        #add Z[k] and Z[k+m]
    sw $s1,  48($s0)         #store result in Z[12]


    .data
    .globl message3
message3:    .asciiz "Z[k] + Z[k+m] is: "
    .text

    li  $v0, 4
    la $a0, message3
    syscall

    li $v0, 1
    move $a0, $s1
    syscall


    addu $ra, $0, $s7
    jr $ra




