# start of the main program
# implements iterative version of N!
#
# Main program written in C to help understand
# what we do:
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
#    int result = 1;
#    while (n &gt; 1)
#    {
#      result = result * n;
#      n = n - 1;
#    }
#    return result;
#  }
# main assumes:
#  f is in $s0 and n is in $s1

    .text
    .globl  main
main:                       # main has to be a global label
    addu $s7, $0, $ra       # save the return address in a global register

  # Prompt and input the value of N
    .data
    .globl inputNmsg
inputNmsg:  .asciiz  "\nEnter N :"
    .text
    li   $v0, 4             # print_str
    la   $a0, inputNmsg     # takes the address of string as an argument
    syscall
    li   $v0, 5             # read_int
    syscall
    add  $s1, $0, $v0       # The value of N has been read into $s1

    add  $a0, $0, $s1       # set the parameter to N for fact call
    jal  fact               # Call the factorial function
    add  $s0, $0, $v0       # f = fact(N);
  
  #  Output the result
    .data
    .globl  outputMsg
outputMsg:  .asciiz  "\nN! = "
    .text
    li   $v0, 4             # print_str 
    la   $a0, outputMsg     # takes the address of string as an argument 
    syscall                 # output the label
    li   $v0, 1             # print_int
    add  $a0, $0, $s0       # takes integer
    syscall                 # output f

  # Usual stuff at the end of the main
    addu $ra, $0, $s7       # restore the return address
    jr   $ra                # return to the main program
    add  $0, $0, $0         # nop

    .globl  fact            # function named "fact"
fact:
    add  $v0, $zero, 1      # prepare return = 1
L2: 
    slt  $t0, $a0, 1        # test for n &lt; 1
    beq  $t0, $zero, L1     # if (n &gt;= 1) go to L1
    jr  $ra                 # all done, return
L1:
    mul  $v0, $a0, $v0      # yes finally we can multiply!  
    sub  $a0, $a0, 1        # when n &gt;= 1:  decrement the argument
    j  L2                   # jump to L2