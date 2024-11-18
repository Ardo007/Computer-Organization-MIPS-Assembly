# start of the main program
# implements a leaf example (see textbook)
# Below main program written in C to help understand
# what we do: 
#  int leaf_example (int g, int h, int i, int j)
#  {
#    int f;
#    f = (g + h) - (i + j);
#    return f;
#  }
# assumes:
#  f is in $s0 and g, h, i and j are in registers $a0 through $a3


    .text
    .globl main
main:                       # main has to be a global label
    addu $s7, $0, $ra       # save the return address in a global register

    addi $s0, $0, -1        # initialize $s0 to -1
    addi $a0, $0, 3         # g = 3
    addi $a1, $0, -18       # h = -18
    addi $a2, $0, 12        # i = 12
    addi $a3, $0, 13        # j = 13
    jal  leaf_example       # call the function leaf_example  
    add  $s0, $0, $v0       # set f to the computed value

  # Now print out f
    .data
    .globl  message
message:  .asciiz "\nThe value of f is: " # string to print
    .text
    li   $v0, 4             # print_str (system call 4)
    la   $a0, message       # takes the address of string as an argument
    syscall

    li   $v0, 1             # print_int (system call 1)
    add  $a0, $0, $s0       # put value to print in $a0
    syscall

  # Usual stuff at the end of the main
    addu $ra, $0, $s7       # restore the return address
    jr   $ra                # return to the main program
    add  $0, $0, $0         # nop

    .globl  leaf_example    # function named "leaf_example"
leaf_example:
    sub  $sp, $sp, 12       # make space on the stack for three items
    sw   $s2, 8($sp)        # save register $s2       
    sw   $s1, 4($sp)        # save register $s1
    sw   $s0, 0($sp)        # save register $s0
    add  $s1, $a0, $a1      # register $s1 contains g + h
    add  $s2, $a2, $a3      # register $s2 contains i + j
    sub  $s0, $s1, $s2      # f = (g + h) - (i + j)
    add  $v0, $s0, $0       # returns f
    lw   $s0, 0($sp)        # restore register $s0
    lw   $s1, 4($sp)        # restore register $s1
    lw   $s2, 8($sp)        # restore register $s2
    add  $sp, $sp, 12       # adjust the stack before the return 
    jr   $ra                # return to the calling program