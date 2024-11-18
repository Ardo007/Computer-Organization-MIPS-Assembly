    .data
    .align 2
buffer:         .space 6                      # Buffer to store 6 characters
msg_prompt:     .asciiz "\nEnter characters (buffer size is 6, terminate with 'A'):\n"
msg_buffer_full:.asciiz "\nBuffer is full, printing characters:\n"
msg_terminated: .asciiz "\nTerminating character received. Printing leftover characters:\n"
msg_total_count:.asciiz "\nTotal characters entered: "
term_char:      .asciiz "A"                   # terminating character 'A'

    .text
    .globl main
main:
    addu    $s7, $0, $ra              

    li      $v0, 4                    
    la      $a0, msg_prompt           
    syscall

    # Initialize memory-mapped I/O base address in $t0
    li      $t0, 0xffff               
    sll     $t0, $t0, 16              

    li      $t2, 0                   

    li      $t4, 0                    

    # Load terminating character into $s1
    la      $a0, term_char            
    lb      $s1, 0($a0)               

readloop:
    # Wait until a character is available in the receiver
    lw      $t1, 0($t0)               
    andi    $t1, $t1, 0x0001          
    beq     $t1, $zero, readloop      

    lb      $s0, 4($t0)               

    # Check if terminating character
    beq     $s0, $s1, terminate       

    sb      $s0, buffer($t2)          

    addi    $t4, $t4, 1

    addi    $t2, $t2, 1    

    li      $t3, 6                    
    bne     $t2, $t3, readloop        


    li      $v0, 4                    
    la      $a0, msg_buffer_full      
    syscall

    li      $t5, 0                    

printloop:
    lb      $s0, buffer($t5)          

writeloop:
    # Wait until transmitter is ready
    lw      $t1, 8($t0)               
    andi    $t1, $t1, 0x0001          
    beq     $t1, $zero, writeloop     

    sb      $s0, 12($t0)              

    addi    $t5, $t5, 1

    li      $t3, 6                    
    blt     $t5, $t3, printloop       

    li      $t2, 0

    j       readloop

terminate:
    li      $v0, 4                    
    la      $a0, msg_terminated       
    syscall

    # If buffer has leftover characters, print them
    # $t2 holds current buffer index (could be zero)

    bgtz    $t2, print_leftover       

    # Else, no leftover, proceed to report total count
    j       report_total_count

print_leftover:
    li      $t5, 0                    

print_leftover_loop:
    lb      $s0, buffer($t5)          

writeloop_leftover:
    lw      $t1, 8($t0)               
    andi    $t1, $t1, 0x0001          
    beq     $t1, $zero, writeloop_leftover    

    sb      $s0, 12($t0)              

    addi    $t5, $t5, 1

    bne     $t5, $t2, print_leftover_loop   

    j       report_total_count

report_total_count:
    li      $s0, '\n'                 

newline_writeloop:
    lw      $t1, 8($t0)               
    andi    $t1, $t1, 0x0001          
    beq     $t1, $zero, newline_writeloop  

    sb      $s0, 12($t0)              

    li      $v0, 4                    
    la      $a0, msg_total_count      
    syscall

    li      $v0, 1                    
    move    $a0, $t4                  
    syscall

    li      $v0, 11                   
    li      $a0, '\n'
    syscall

    addu    $ra, $0, $s7              
    jr      $ra                      
    add $0, $0, $0