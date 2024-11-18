# implements a recursive version of N!
# 
# Main program in C:
#  void main()
#  {  int N, f;
#    printf("Enter N: ");
#    scanf("%d", N); 
#    f = fact(N);
#    printf("\nN! = %d", f);
#    return;
#  }
#
#  int fact(int n)
#  {
#    if (n &lt; 1)
#    return 1;
#    else return (n * fact(n-1));
#  }
# main assumes:
#  f is in $s0 and n is in $s1

    .text
    .globl  main
main:                       # main has to be a global label
    addu  $s7, $0, $ra      # save return address in global register

  # PROMPT AND INPUT THE VALUE OF N
    .data
    .globl  input
input:    .asciiz  "\nEnter N: "
    .text
    li   $v0, 4             # print_str
    la   $a0, input         # takes address of string as argument
    syscall                 #
    li   $v0, 5             # read_int
    syscall                 #
    add  $s1, $0, $v0       # The value of N has been read into $s1
    add  $a0, $0, $s1       # set the parameter to N for fact call
    jal  fact               # Call the factorial function
    add  $s0, $0, $v0       # f = fact(N);

  # OUTPUT THE RESULT
    .data
    .globl  output
output:  .asciiz  "N! = "
newline: .asciiz  "\n"
    .text
    li   $v0, 4             # print_str
    la   $a0, output        # takes address of string as an argument 
    syscall                 # output the label
    li   $v0, 1             # print_int
    add  $a0, $0, $s0       # takes integer
    syscall                 # output f
    li   $v0, 4             # print_str
    la   $a0, newline       #  
    syscall                 # new line
    

  # USUAL STAFF AT THE END OF THE MAIN
    addu $ra, $0, $s7       # restore the return address
    jr   $ra                # return to the main program
    add  $0, $0, $0         # nop (no operation)

    .globl   fact 
fact:
    sub  $sp, $sp, 8        # make space on the stack for two items
    sw   $ra, 4($sp)        # save the return address on the stack 
    sw   $a0, 0($sp)        # save the argument n on the stack 
    slt  $t0, $a0, 1        # test for n &lt; 1
    beq  $t0, $zero, L1     # if (n &gt;= 1) go to L1
    add  $v0, $zero, 1      # otherwise return 1
    add  $sp, $sp, 8        # pop the saved items off stack, no call
    jr   $ra                # and return
L1:
    sub  $a0, $a0, 1        # when n &gt;= 1:  decrement the argument
    jal  fact               # call fact(n-1)
    lw   $a0, 0($sp)        # restore the value of argument n
    lw   $ra, 4($sp)        # restore the return address
    add  $sp, $sp, 8        # release the save area on the stack
    mul  $v0, $a0, $v0      # yes it's a multiply!  (n*fact(n-1))
    jr   $ra                # return