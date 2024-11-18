        .data
prompt_p:    .asciiz "Enter the value of p (0 to terminate): "
prompt_n:    .asciiz "Enter the value of n: "
prompt_m:    .asciiz "Enter the value of m: "
error_msg:   .asciiz "Error: n + m must not exceed 32.\n"
signed_msg:  .asciiz "Signed value of extracted field: "
unsigned_msg:.asciiz "Unsigned value of extracted field: "
newline:     .asciiz "\n"

p: .word 0
n: .word 0
m: .word 0
max: .word 32

    .text
    .globl main

main: 
    addu  $s7, $0, $ra

    li $v0, 4                   
    la $a0, prompt_p             
    syscall                      
    
    li $v0, 5                   
    syscall                      
    move p, $v0                

    beq $a2, $zero, exit

    li $v0, 4
    la $a0, prompt_n
    syscall

    li $v0, 5                   
    syscall
    move n, $v0    

    li $v0, 4
    la $a0, prompt_m
    syscall

    li $v0, 5                   
    syscall
    move m, $v0                

    addu $t3, $a0, $a1           
    li $t4, 32
    bge $t3, $t4, call_extract    

    li $v0, 4
    la $a0, error_msg
    syscall
    j main

call_extract:
    jal extractExt 




extractExt:
    sub $sp, $sp, 16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)

    move  $s0, $a0
    move  $s1, $a1
    move  $s2, $a2

    lw $t0, max
    
    jal createM

    move $t0, $v0

    lw $ra,  12($sp)
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16


createM:
    sub $sp,  $sp, 4
    sw $s0, 0($sp)

    move $s0, 1
    sll $s0, $s0, $a0
    addu $s0, $s0, -1
    sll $v0, $s0, $a1

    lw $s0,  0($sp)
    addi $sp, $sp, 4
    jr $ra


