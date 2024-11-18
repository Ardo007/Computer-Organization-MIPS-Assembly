        .data
prompt: .asciiz "Enter a number between 2 and 50: "
error:  .asciiz "Error: Please enter a valid number between 2 and 50.\n"
newline: .asciiz "\n"

        .text
        .globl main

main:
  addu	$s7, $s0, $ra		# Sava the return address


error_check:
        # Prompt user for input
        li      $v0, 4                 # syscall to print string
        la      $a0, prompt            # load address of the prompt string
        syscall

        # Read integer input
        li      $v0, 5                 # syscall to read integer
        syscall
        move    $t0, $v0               # store the input value in $t0

        # Check if input is valid (2 <= n <= 50)
        li      $t1, 2                 # $t1 = 2
        li      $t2, 50                # $t2 = 50
        blt     $t0, $t1, error_case   # if n < 2, go to error_case
        bgt     $t0, $t2, error_case   # if n > 50, go to error_case
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
        jal     fib_fp                 # jump to fib_fp function (for FP Fibonacci calculation)

        # Print floating-point result
        li      $v0, 3                 
        mov.d   $f12, $f2              # move FP result to $f12 for printing
        syscall

        # Print a new line
        li      $v0, 4                
        la      $a0, newline
        syscall

	addu	$ra, $s0, $s7		# Restore the return address
	jr		$ra			# Return to the main program
  
  
        .globl fib_fp
# Fibonacci function 
fib_fp:
        # Initialize F(0) = 0.0, F(1) = 1.0 
        li.d    $f0, 0.0               # F(0) = 0.0 (in FP register)
        li.d    $f2, 1.0               # F(1) = 1.0 (in FP register)
        li      $t3, 2                 # start index from 2 (we're already counting F(0) and F(1))

        # Handle base cases
        beq     $a0, $t1, done_fp      # If n == 2, return F(1)

        # Loop through Fibonacci sequence to calculate F(n) in FP
fib_loop_fp:
        bgt     $t3, $a0, done_fp      # If counter ($t3) > n, stop loop
        add.d   $f4, $f0, $f2          # F(n) = F(n-1) + F(n-2) 
        mov.d   $f0, $f2               # F(n-1) becomes F(n-2)
        mov.d   $f2, $f4               # F(n) becomes F(n-1)
        addi    $t3, $t3, 1            # Increment counter
        j       fib_loop_fp            # Repeat loop

done_fp:
        jr      $ra                    # return to the caller
