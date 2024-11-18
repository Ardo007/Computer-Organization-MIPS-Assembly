# The main program is to perform calculation as per formula: __??
# Note: A formula is a mathematical expression with variables. For this exercise, you need to declare some variables based on the calculation task.
# Variable and expression are standard and common terms in programming context. It's assumed you have understood them from learning Programming Fundamentals.
# places variables  a, b, c, d, e, f, g  in registers $s1, $s2, $s3, $s4, $t0, $t1, $s0
#                        |                           |
#             list of variables          list of registers
#
#
  .data
  .globl  message  
message:  .asciiz "The value of f is: "   # a string tp print
extra:    .asciiz "\nHave a nice day :)"  # a string to print
thankyou: .asciiz "\n\n\n ... Thank you :)"
  .align 2                  # align directive will be explained later

  .text
  .globl main
main:                       # main has to be a global label
  addu  $s7, $0, $ra        # save return address in a global register

        # CALCULATING
		# For calculation tasks, add comments with a focus on algorithmic steps involved in the calculation.
		# Understand the concept of modeling and implementation in program context.
		
  addi  $s1, $0, 12         # a = 12 + 0 = 12
  addi  $s2, $0, -2         # b = 0 + - 2 = - 2
  addi  $s3, $0, 13         # c = 0 + 13 = 13
  addi  $s4, $0, 3          # d = 0 + 3 = 3
  add   $t0, $s1, $s2       # e = a + b = 12 + -2 = 10
  sub   $t1, $s3, $s4       # f = c - d = 13 - 3 = 10
  sub   $s0, $t0, $t1       # g = e - f = 10 - 10 = 10
      # ^
      # |
      # (a + b) - (c - d + e)



  
        # PRINTING
        
        # print __??
  li    $v0, 4              # ERROR
  la    $a0, message        # loads the string message into register $a0 to be displayed in the console 
  syscall
  
        # print __??
  li    $v0, 1              # put operator 1 into register $v0 in order to print out an integer
  add   $a0, $0, $s0        # we are adding the values in registers $0 (always 0) and $s0 and saving it to register $a0 to then display in the console. this is 
  syscall                   # essentially moving our variable in register $s0 into register $a0
  
        # print __??
  li    $v0, 4              # ERROR
  la    $a0, extra          # loads the string extra into register $a0 to be displayed in the console 
  syscall

  li    $v0, 4              
  la    $a0, thankyou          
  syscall
  
        # Usual stuff at the end of the main

  addu  $ra, $0, $s7        # restore the return address
  jr    $ra                 # return to the main program
  add   $0, $0, $0          # nop (no operation)