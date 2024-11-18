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
    li $v0, 4                   
    la $a0, prompt_p             
    syscall                      
    
    li $v0, 5                   
    syscall                      
    move $a2, $v0                

    beq $a2, $zero, exit         

get_n_m:
    li $v0, 4
    la $a0, prompt_n
    syscall

    li $v0, 5                   
    syscall
    move $a0, $v0 
    sw $v0, n      


    li $v0, 4
    la $a0, prompt_m
    syscall

    li $v0, 5                   
    syscall
    move $a1, $v0                

    addu $t3, $a0, $a1           
    li $t4, 32
    bge $t3, $t4, call_extract   

    li $v0, 4
    la $a0, error_msg
    syscall
    j main                       

call_extract:

    jal extractExt  
    move $s0, $v0             

    li $v0, 4
    la $a0, unsigned_msg
    syscall

    move $a0, $s0                
    li $v0, 1                   
    syscall

    li $v0, 4
    la $a0, newline
    syscall



    li $v0, 4
    la $a0, signed_msg
    syscall

    li $s3, 32
    lw $a0, n
    sub  $s3, $s3, $a0
    sll $s0,  $s0, $s3 
    sra $a0, $s0, $s3  
               
    li $v0, 1                   
    syscall


    li $v0, 4
    la $a0, newline
    syscall

    j main                       

exit:
    li $v0, 10                   
    syscall


extractExt:

    li $t0, 0xFFFFFFFF                   
    sub $t4, $t1, $a0       # t1 = 32 - n       
    srl $t0, $t0, $t4            
    sll $t0, $t0, $a1           

    and $t2, $a2, $t0             
    sra $t2, $t2, $a1            

    move  $v0, $t2                

    jr $ra

