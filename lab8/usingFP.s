# The following code demonstrates FP calculation using FP registers, FP variables, and FP constants.
# The code follows the conventions for registers usage with respect to function calling (where applies):
#	caller saved: $t0 - $t9 (temporary registers)
#	callee saved: $s0 - $s7 (saved registers)
#	$a0-$a3 for parameters 
#	$v0-$v1 returned values

    .data
	.align 2
    .globl inputNmsg
inputNmsg:  .asciiz  "\nEnter an integer N: "
	.globl inputXmsg
inputXmsg: .asciiz "\nEnter an FP number X: "
	.globl outputMsg
outputMsg: .asciiz "\nResult for 15+N+X = "

int_N: .word 0		# declare int var
fp_X: .double 0.0	# declare fp var. "fp_X: .double 0" isn't working.
fp_Y: .double 15.0	# declare fp var. "fp_Y: .double 15" isn't working.
fp_Z: .double 0.0	# declare fp var. "fp_Z: .double 0" isn't working.

    .text
    .globl  main
main:                       # main has to be a global label
    addu $s7, $0, $ra       # save the return address in a global register

# Prompt and input the value of int_N
    li   $v0, 4             # print_str
    la   $a0, inputNmsg     # takes the address of string as argument
    syscall

    li   $v0, 5             # read_int
    syscall
    sw $v0, int_N      		# Read kbd for int_N

# Prompt and input the value of fp_X
    li   $v0, 4             # print_str
    la   $a0, inputXmsg     # takes the address of string as argument
    syscall

    li   $v0, 7             # read_fp_double
    syscall
    s.d $f0, fp_X      		# Read kbd for fp_X
	
	lw $a0, int_N
	la $a1, fp_X
	la $a2, fp_Y
	la $a3, fp_Z
	jal add_int_fp

#  Output the result
    li $v0, 4             	# print_str 
    la $a0, outputMsg    	# takes the address of string as an argument 
    syscall                 # output the label
	
	# Print out the Result for 15+N+X
    li $v0, 3             	# print_double
	l.d $f12,fp_Z 			# takes double
    syscall                 # output F

  	# Usual stuff at the end of the main
    addu $ra, $0, $s7       # restore the return address
    jr   $ra                # return to the main program
    add  $0, $0, $0         # nop

#########################################################	
    .globl add_int_fp	  	# function named "add_int_fp"
add_int_fp: 
	li.d $f0, 0.0			# "li.d $f0, 0" isn't working
	sub  $sp, $sp, 12		# Not necessary to use stack here; this is for demonstration only. If subi is not working, use sub
	sw $a0, 0($sp)
	s.d $f0, 4($sp)
	
	mtc1.d $a0, $f2			# move from plain reg to fp double reg (pattern transfer)
	cvt.d.w $f2, $f2  		# value_convert To: s, d, w; From: s, d, w (type conversion). If vcvt.d.w is not working, use cvt.d.w

	l.d $f4, 0($a1)
	l.d $f6, 0($a2)
	
	add.d $f0, $f2, $f4
	add.d $f0, $f0, $f6
	
	s.d $f0, 0($a3)
	
	l.d $f0, 4($sp)	
	lw $a0, 0($sp)
	add $sp, $sp, 12		

	jr $ra					# return to main
