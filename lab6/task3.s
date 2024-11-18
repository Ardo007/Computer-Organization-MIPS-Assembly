        .data
n: .word 0
result:  .word 0
prompt: .asciiz "Enter a number between 2 and 45: "
error:  .asciiz "Error: Please enter a valid number between 2 and 45.\n"
part1:  .asciiz "Element ["
part2:  .asciiz "] of Fibonacci string is: "
newline: .asciiz "\n"

        .text
        .globl main

main:
  addu	$s7, $s0, $ra		# Sava the return address

error_check:
        # Prompt user for input
        li      $v0, 4                 
        la      $a0, prompt           
        syscall

        # Read integer input
        li      $v0, 5                 
        syscall
        sw      $v0, n                 


        # Check if input is valid (2 <= n <= 45)
        li      $t1, 2                 # $t1 = 2
        li      $t2, 45                # $t2 = 45
        blt     $v0, $t1, error_case   # if n < 2, go to error_case
        bgt     $v0, $t2, error_case   # if n > 45, go to error_case
        j end
    
error_case:
        # Print error message if input is invalid
        li      $v0, 4                 
        la      $a0, error             
        syscall
        j error_check

end:
    lw    $a0, n
    li    $a1, 0
    li    $a2, 1
    jal	 fib
	sw $v0, result



    # Print result 
    li      $v0, 4                 
    la      $a0, part1            
    syscall

    # Print the input number n
    li      $v0, 1                 
    lw    $a0, n              
    syscall


    li      $v0, 4                 
    la      $a0, part2             
    syscall

    # Print the Fibonacci result
    li      $v0, 1                 
    lw      $a0, result            
    syscall

    # Print a new line
    li      $v0, 4                 # syscall to print newline
    la      $a0, newline
    syscall

	addu	$ra, $s0, $s7		# Restore the return address
	jr		$ra			# Return to the main program


	
   .globl fib

# Fibonacci function (recursive)
fib:
    li $t4, 2   # base case check for recursion

    beq $a0, $t4, done    # if n = 2 then done

fib_recursive:
    add $t3, $a1, $a2   # element[n] = element[n-1] + element[n-2]

    move $a1, $a2      # shift values for next iteration
    move $a2, $t3      # move $t3 to $a2 new fibonacci number


    addi $sp, $sp, -12  # allocate space on the stack
    sw $ra, 0($sp)       # save the return address on stack
    sw $a1, 4($sp)       # save $a1 on stack
    sw $a2, 8($sp)       # save $a2 on stack

    addi    $a0, $a0, -1           # n-1
    lw  $a1, 4($sp)                # load $a1 back from stack
    lw  $a2, 8($sp)                # load $a2 back from stack
    jal     fib                    # recursive call to fib function fib(n-1)

    lw      $ra, 0($sp)            # Restore return address
    addi    $sp, $sp, 12           # Deallocate space on stack
    jr      $ra                    # Return to caller

done:
    add     $v0, $a1, $a2
    jr      $ra                    # Return to caller


