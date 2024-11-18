# float loop.s
# Simple routine to calculate (X to power N)/2
# where: X is decimal fraction number
# and N is integer &gt;0. Both X and N are entered from the keyboard
# Note use of floating point and non-floating point instructions.
# Author: Derek Bem

  .data
k:     .float 2.0
msg1:  .asciiz	"\nThis simple program calculates (X to power N)/2.\nIt does not check for overflow (out of range) condition or incorrect input.\n\nEnter decimal fraction number X: "
msg2:  .asciiz "Enter integer N&gt;0: "
msg3:  .asciiz	"\n(X to power N)/2 = "
lf:    .asciiz	"\n"

   .text
   .globl main
main:
   addu $s7,$0,$ra      # save the return address in a global register
   li $v0,4             # output msg1
   la $a0, msg1
   syscall
   li $v0,6             # input decimal fraction number and save
   syscall
   mov.s $f12,$f0
   mov.s $f13,$f0

   li $v0,4             # output msg2
   la $a0,msg2
   syscall
   li $v0,5             # input integer N and save
   syscall

   move $t0,$v0
   li $t1,1             # initialize counter i

loop:
   beq $t0, $t1,exit    # if i &lt; N, execute the loop
   mul.s $f12,$f12,$f13 # N = N*N
   addi $t1,$t1,1       # i = i + 1	
   j loop

exit:
   l.s $f14,k           # $f14 gets 2.0
   div.s $f12,$f12,$f14 # (X to power N)/2
   li $v0,4             # output msg3
   la	$a0,msg3
   syscall

   li$v0,2              # output result
   syscall

   li $v0,4             # output lf
   la $a0,lf
   syscall

                        #usual stuff at the end of the main
   addu $ra,$0,$s7      # restore the return address
   jr $ra               # return to the main program