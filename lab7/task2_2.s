    .data
prompt: .asciiz "Enter a number (0 to exit): "
signed_msg: .asciiz "\nSigned value: "
unsigned_msg: .asciiz "\nUnsigned value: "

    .text
    .globl main

main:
loop:

    li $v0, 4              
    la $a0, prompt         
    syscall

    li $v0, 5            
    syscall                
    move $t0, $v0           

    beq $t0, $zero, exit    

    jal extract_signed_adjust

    li $v0, 4              
    la $a0, unsigned_msg    
    syscall

    move $a0, $v1           
    li $v0, 1               
    syscall

    li $v0, 4              
    la $a0, signed_msg      
    syscall

    move $a0, $v1           
    li $v0, 1               
    syscall

    j loop

extract_signed_adjust:


    srl $t1, $t0, 3         
    andi $v1, $t1, 0x1F    

  
    bge $v1, 16, adjust_signed  

    jr $ra                  

adjust_signed:
    li $t1, 32              
    subu $v1, $v1, $t1      

    jr $ra                  

exit:
    li $v0, 10              
    syscall                 
