/* 214612285 Fatima Swelem */

    .extern pstrlen
    .extern swapCase
    .extern pstrijcpy
    .extern pstrcat
    .extern printf
    .extern scanf

.section .rodata

 scan_sec:        .string  "%d"
 scan_it:          .string  "%d "
 scan_str:         .string  "%255s"
 first_choice_1:   .string  "first pstring length: %d, "
 first_choice_2:   .string  "second pstring length: %d\n"
 print_two_ints:   .string "i = %d, j = %d\n"
 other_choices_1:  .string  "length: %d, "
 other_choices_2:  .string  "string: %s\n"
 error_msg:        .string  "invalid option!\n"
 invalid_msg:      .string  "invalid input!\n"
 errormassege:    .string  "cannot concatenate strings!\n"

.text

    .globl run_func
    .type run_func, @function

run_func:               # choice in edi, first string in rsi, second string in rdx

    pushq %rbp                   # backup RBP.
    movq %rsp, %rbp              # set RBP to run_func activation frame.
    pushq %rsi                   # first string -8(%rbp)
    pushq %rdx                   # first string -16(%rbp)
    subq $48, %rsp               # allocate space for the length of each string.

    movl %edi, %eax              # move the choice number to eax.
    cmp $31, %eax                # if choice smaller than 31.
    jl invalid                   # print invalid choice.
    cmp $37, %eax                # same if choice bigger than 37.
    jg invalid

    subl $31, %eax               # choice = choice - 31 (31 -> 0 , 32 -> 1 , ... , 37 -> 6 (to jump table)).
    movslq %eax, %rax            # sign-extend the 32-bit value in %eax into the 64-bit register %rax.

    movq $jump_table, %r8
    movq (%r8,%rax,8), %rax
    jmp *%rax

jump_table:

    .quad option_31
    .quad invalid
    .quad option_33
    .quad option_34
    .quad invalid
    .quad invalid
    .quad option_37

#---------------------------------------

option_31:                            # pstrlen
    
    movq -8(%rbp), %rdi       # load address of first pstring
    call pstrlen              # rax = length of first pstring
    movq %rax, -24(%rbp)      # save first length at 24(%rbp)

    movq $first_choice_1, %rdi
    movq -24(%rbp), %rsi
    xorq %rax, %rax
    call printf

    movq -16(%rbp), %rdi      # load address of second pstring
    call pstrlen              # rax = length of second pstring
    movq %rax, -32(%rbp)      # save second length at 32(%rbp)

    movq $first_choice_2, %rdi
    movq -32(%rbp), %rsi
    xorq %rax, %rax
    call printf

    jmp end_func

#---------------------------------------

option_33:                            # swapCase

    movq -8(%rbp), %rdi            # load address of first pstring
    call swapCase
    movq %rax, -8(%rbp)

    movq -16(%rbp), %rdi            # load address of second pstring
    call swapCase
    movq %rax, -16(%rbp)

    jmp print_pstrings

#---------------------------------------

option_34:
    
    subq $16, %rsp          # לפנות מקום לשני int על ה-stack    

    movq $0, (%rsp)
    movq $0, 8(%rsp)

    movq   $scan_it, %rdi
    leaq   (%rsp), %rsi
    movq   $0, %rax
    call   scanf

    #scanf second input
    movq   $scan_sec, %rdi
    leaq   8(%rsp), %rsi
    xorq   %rax, %rax
    call   scanf

   # leaq (%rsp), %rsi       # כתובת i
  #  leaq 8(%rsp), %rdx      # כתובת j

    #movq $scan_both, %rdi
#  xor %rax, %rax
 #   call scanf

# לקרוא את הערכים מ-%rsp ו־8(%rsp) ולשים איפה שצריך:
    movq (%rsp), %rcx       # i לתוך %esi
    movq 8(%rsp), %rdx      # j לתוך %edi

    movq -8(%rbp), %rdi        
    movq -16(%rbp), %rsi 

    addq $16, %rsp

   # movq -8(%rbp), %rax

    call pstrijcpy
    
    cmpq $0, %rax
    jne .print_the_strings

.invalid_massege:
    
    movq $invalid_msg , %rdi
    xorq %rax, %rax
    call printf 
  #  movq %rax, -8(%rbp)

.print_the_strings:

    jmp print_pstrings    

#---------------------------------------

option_37:                            # pstrcat

    movq -8(%rbp), %rdi             # load address of first pstring
    movq -16(%rbp), %rsi            # load address of second pstring

    call pstrcat

 #   movq %rax, -8(%rbp)

    cmpq $0, %rax

    jne .print_str

.cant_error_msg:

    # Print error message but continue copying anyway
    movq $errormassege, %rdi
    xorq %rax, %rax
    call printf

.print_str:

    jmp print_pstrings

#---------------------------------------

print_pstrings:

    movq -8(%rbp), %rdi            # load address of first pstring
    call pstrlen                   # get length of first string.

    movl %eax, -24(%rbp)

    movq -16(%rbp), %rdi            # load address of second pstring
    call pstrlen                    # get length of second string.

    movl %eax, -32(%rbp)

    # Print first Pstring
    movl -24(%rbp), %esi          # load length
    movq $other_choices_1, %rdi
    xorq %rax, %rax
    call printf

    movq -8(%rbp), %rsi             # load address of first pstring
    incq %rsi
    movq $other_choices_2, %rdi
    xorq %rax, %rax
    call printf

    # Print second Pstring
    movl -32(%rbp), %esi
    movq $other_choices_1, %rdi
    xorq %rax, %rax
    call printf

    movq -16(%rbp), %rsi            # load address of second pstring
    incq %rsi
    movq $other_choices_2, %rdi
    xorq %rax, %rax
    call printf

    jmp end_func

invalid:

    movq $error_msg, %rdi
    xorq %rax, %rax
    call printf

    jmp end_func

end_func:

    addq $48, %rsp
    movq %rbp, %rsp          # restore stack pointer.
    popq %rbp                # restore base pointer.
    ret                      # return from function.
