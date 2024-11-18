.data
newline:     .asciiz "\n"     
S:           .float 5.0       # The speedup factor for the floating-point unit (S = 5)
speedupMsg:  .asciiz "Speedup = "
fpPropMsg:   .asciiz "(FP proportion: "

.text
.globl main

main:
    # Initialize constants
    li.s $f0, 0.0        # Starting proportion of fp-time (0%)
    li.s $f1, 0.1        # Interval (10% steps)
    li.s $f2, 1.1        # Set limit to 1.1 to ensure we include 1.0
    lwc1 $f3, S          # Speedup factor (S = 5.0)

loop:
    # Check if the current proportion exceeds 1.0 (100%)
    c.le.s $f0, $f2
    bc1f done   # If fp-time >= 1.1, break the loop

    # Calculate Speedup = 1 / ((1 - f) + f / S)
    li.s $f4, 1.0        # Load 1.0 into $f4
    sub.s $f5, $f4, $f0  # (1 - f)
    div.s $f6, $f0, $f3  # f / S
    add.s $f7, $f5, $f6  # (1 - f) + (f / S)
    div.s $f8, $f4, $f7  # 1 / ((1 - f) + (f / S)) => Speedup

    li $v0, 4            
    la $a0, speedupMsg   
    syscall

    li $v0, 2            
    mov.s $f12, $f8      # Move the calculated Speedup to $f12
    syscall

    li $v0, 4            
    la $a0, fpPropMsg    
    syscall

    li $v0, 2            
    mov.s $f12, $f0      # Move the current proportion of fp-time (f) to $f12
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Increment the fraction of fp-time by 0.1
    add.s $f0, $f0, $f1  # f = f + 0.1
    j loop               

done:
    li $v0, 10           
    syscall
