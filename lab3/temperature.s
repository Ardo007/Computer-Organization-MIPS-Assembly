# this programs asks for temperature in Fahrenheit
# and converts it to Celsius

  .text    
         .globl main  
main:                 # main has to be a global label
  addu  $s7, $0, $ra  # save return address in a global register
  
  
      # GETTING INPUT VALUE
  
  la $a0,input        # print message "input" on the console
  li $v0,4
  syscall

# __?? insert here the code to get an integer number entered from the keyboard
# __?? hint: use appropriate syscalls

  li $v0, 5
  syscall
  
      # CALCULATING  
  
  addi $t0,$v0,-32    # adding -32 to the number we get from user and saving it in $t0
  mul  $t0,$t0,5      # multiplying 5 with number in $t0 and saving it in $t0
  div  $t0,$t0,9      # quotient of dividing value in $t0 with 9 and saving result in $t0

      # PRINTING

  la $a0,result       # loads the string result into register $a0 to be displayed in the console?
  li $v0,4            # put operator 4 into $v0 to print out a string
  syscall             # prints data taken from memory address found in register $a0

  move $a0,$t0        # copy data from $t0 into $a0
  li $v0,1            # load operator 1 into $v0 to print out an int 
  syscall             # prints data taken from memory address found in register $a0

  .data
input:  .asciiz "\n\nEnter temperature in Fahrenheit: "
result:  .asciiz "The temperature in Celsius is: "
  
  .text
  addu  $ra, $0, $s7 # restore the return address
  jr  $ra            # return to the main program
  add  $0, $0, $0    # nop (no operation)