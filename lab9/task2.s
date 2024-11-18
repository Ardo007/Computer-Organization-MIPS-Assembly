    .data
    .align 2
buffer:     .space 6                   # Buffer to store 6 characters
msg_prompt: .asciiz "\nEnter characters (buffer size 6):\n"
msg_full:   .asciiz "\nBuffer is full, printing characters:\n"
msg2:       .asciiz "\nProgram terminated\n"  

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

    # Initialize buffer index to 0
    li      $t2, 0                    

readloop:

    # Wait until a character is available in the receiver
    lw      $t1, 0($t0)               
    andi    $t1, $t1, 0x0001          
    beq     $t1, $zero, readloop      

    lb      $s0, 4($t0)               

    # Store character in buffer
    sb      $s0, buffer($t2)          

    addi    $t2, $t2, 1               

    # Check if buffer is full
    li      $t3, 6                    
    beq     $t2, $t3, buffer_full     

    j       readloop                  

buffer_full:
    li      $v0, 4                    
    la      $a0, msg_full             
    syscall

    # Initialize index to 0 for printing
    li      $t2, 0                    

printloop:
    # Load character from buffer into $s0

    lb      $s0, buffer($t2)          

writeloop:
    # Wait until transmitter is ready
    lw      $t1, 8($t0)               
    andi    $t1, $t1, 0x0001          
    beq     $t1, $zero, writeloop     

    sb      $s0, 12($t0)              

    # Increment buffer index
    addi    $t2, $t2, 1

    # Check if all characters have been printed
    li      $t3, 6                    
    blt     $t2, $t3, printloop       # If not done, continue printing

    li      $s0, '\n'                 

newline_writeloop:
    # Wait until transmitter is ready
    lw      $t1, 8($t0)              
    andi    $t1, $t1, 0x0001          
    beq     $t1, $zero, newline_writeloop  

    sb      $s0, 12($t0)              

    li      $v0, 4                    
    la      $a0, msg2                 
    syscall

    addu    $ra, $0, $s7              
    jr      $ra                      
    add $0, $0, $0