        .data
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
        move    $t0, $v0               # store the input value in $t0

        # Check if input is valid (2 <= n <= 45)
        li      $t1, 2                 # $t1 = 2
        li      $t2, 45                # $t2 = 45
        blt     $t0, $t1, error_case   # if n < 2, go to error_case
        bgt     $t0, $t2, error_case   # if n > 45, go to error_case
        j end
    
error_case:
        # Print error message if input is invalid
        li      $v0, 4                 
        la      $a0, error             
        syscall
        j error_check

end:
        # Call fib function with the input value
        move    $a0, $t0               # pass the input (n) to fib function in $a0
        jal     fib                    # jump to fib function

        # Store the Fibonacci result in $t3
        move    $t3, $v0               # move result of fib from $v0 to $t3 (so $v0 isn't overwritten)

        # Print result 
        li      $v0, 4                 
        la      $a0, part1            
        syscall

        # Print the input number n
        li      $v0, 1                 
        move    $a0, $t0               
        syscall


        li      $v0, 4                 
        la      $a0, part2             
        syscall

        # Print the Fibonacci result
        li      $v0, 1                 
        move    $a0, $t3              
        syscall

        # Print a new line
        li      $v0, 4                 # syscall to print newline
        la      $a0, newline
        syscall

	addu	$ra, $s0, $s7		# Restore the return address
	jr		$ra			# Return to the main program
  

        .globl fib
# Fibonacci function
fib:
        li      $t1, 0                 # F(0) = 0
        li      $t2, 1                 # F(1) = 1
        li      $t3, 2                 # start index from 2 (we're already counting F(0) and F(1))

        # Handle base cases
        li      $v0, 0                 # Assume n = 0 result is 0
        beq     $a0, $t1, done         # If n == 0, return 0
        li      $v0, 1                 # Assume n = 1 result is 1
        beq     $a0, $t2, done         # If n == 1, return 1

        # Loop through Fibonacci sequence to calculate F(n)
fib_loop:
        bgt     $t3, $a0, done         # If counter ($t3) > n, stop loop (we want n iterations)
        add     $t4, $t1, $t2          # F(n) = F(n-1) + F(n-2)
        move    $t1, $t2               # F(n-1) becomes F(n-2)
        move    $t2, $t4               # F(n) becomes F(n-1)
        addi    $t3, $t3, 1            # Increment counter
        j       fib_loop               # Repeat loop

done:
        move    $v0, $t2               # return F(n) in $v0
        jr      $ra                    # return to the caller






