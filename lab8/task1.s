.data
promptT:     .asciiz "Enter total execution time (T): "
promptN:     .asciiz "Enter floating-point improvement factor (N, between 0 and 20): "
promptT2:    .asciiz "Enter time spent on floating-point operations (t2): "
errorMsg:    .asciiz "Error: N must be between 0 and 20.\n"
resultMsg:   .asciiz "Calculated Speedup: "
newline:     .asciiz "\n"     

.text
.globl main

main:
    li $v0, 4                 
    la $a0, promptT           
    syscall

    li $v0, 6                 
    syscall
    mov.s $f3, $f0            # store T in $f3 

    li $v0, 4                 
    la $a0, promptN           
    syscall

    li $v0, 6                 
    syscall
    mov.s $f1, $f0            # store N in $f1 

    li.s $f2, 0.0             
    li.s $f5, 20.0            
    
    c.le.s $f2, $f1           # check if N >= 0
    bc1f error                # if false, jump to error
    c.le.s $f1, $f5           # check if N <= 20
    bc1f error                # if false, jump to error

    li $v0, 4                 
    la $a0, promptT2          
    syscall

    li $v0, 6                 
    syscall
    mov.s $f4, $f0            # store t2 in $f4

    li $v0, 2
    mov.s $f12, $f3           
    syscall


    li $v0, 4
    la $a0, newline
    syscall

    # Print t2 value to confirm correct input
    li $v0, 2
    mov.s $f12, $f4           # Move t2 ($f4) into $f12 for printing
    syscall
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Ensure that the division is properly handled for f = t2 / T
    div.s $f5, $f4, $f3       # f = t2 / T

    li $v0, 2                 # syscall to print float
    mov.s $f12, $f5           # move f to $f12
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Calculate (1 - f)
    li.s $f6, 1.0             # load 1.0 into $f6
    sub.s $f7, $f6, $f5       # (1 - f)

    li $v0, 2                 
    mov.s $f12, $f7           # move (1 - f) to $f12
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Calculate f / N
    div.s $f8, $f5, $f1       # f / N

    li $v0, 2                 
    mov.s $f12, $f8           
    syscall


    li $v0, 4
    la $a0, newline
    syscall

    # Add the two values: (1 - f) + (f / N)
    add.s $f9, $f7, $f8       # (1 - f) + (f / N)

    li $v0, 2                 
    mov.s $f12, $f9           
    syscall


    li $v0, 4
    la $a0, newline
    syscall

    # Calculate speedup: 1 / denominator
    li.s $f10, 1.0            # load 1.0 into $f10
    div.s $f11, $f10, $f9     # speedup = 1 / denominator

    li $v0, 4                 
    la $a0, resultMsg         
    syscall

    li $v0, 2                 
    mov.s $f12, $f11          
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j end                     

error:
    li $v0, 4                 
    la $a0, errorMsg          
    syscall

end:
    li $v0, 10                
    syscall
