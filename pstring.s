/*  Fatima Swelem */

    .globl pstrlen
    .globl swapCase
    .globl pstrijcpy
    .globl pstrcat

 .text

 # -------------------------------------------------------------------

 .globl pstrlen
 .type pstrlen, @function

pstrlen:

    pushq %rbp                    # backup RBP.
    movq %rsp, %rbp               # set RBP to run_func activation frame.

    incq %rdi

    testq %rdi, %rdi              # check if rdi = NULL (0).
    je .pstrlen_null              # jump if it is NULL.

    xorq %rax, %rax               # rax (counter) = 0.

.pstrlen_loop:

    cmpb $0, (%rdi)               # check if the first byte in rdi is '\0'
    je .pstrlen_done              # if it is then its the end of the string.
    
    incq %rdi                     # else move to the next bytes.
    incq %rax                     # increase the counter.

    jmp .pstrlen_loop             

.pstrlen_null:

    xorq %rax, %rax               # if the dtring null return rax =0

.pstrlen_done:

    movq %rbp, %rsp               # restore stack pointer.
    popq %rbp                     # restore base pointer.
    ret                           # return from function.

# -------------------------------------------------------------------

 .globl swapCase
 .type swapCase, @function

swapCase:

    pushq %rbp               # Save old base pointer
    movq %rsp, %rbp          # Set new base pointer
    pushq %rdi               # Save original pointer (Pstring)

.swap_loop:

    movb (%rdi), %al         # Load current character into AL
    cmpb $0, %al             # Check if character is null terminator
    je .swap_end_one         # If yes, jump to end

    cmpb $'a', %al           # Compare if character >= 'a'
    jb .check_upper          # If before 'a', check if uppercase
    cmpb $'z', %al           # Compare if character <= 'z'
    ja .next_char            # If after 'z', go to next character
    subb $32, %al            # Convert lowercase to uppercase
    jmp .store_char          # Go to store the modified character

.check_upper:

    cmpb $'A', %al           # Compare if character >= 'A'
    jb .next_char            # If before 'A', go to next character
    cmpb $'Z', %al           # Compare if character <= 'Z'
    ja .next_char            # If after 'Z', go to next character
    addb $32, %al            # Convert uppercase to lowercase

.store_char:

    movb %al, (%rdi)         # Store the new character back to memory

.next_char:

    incq %rdi                # Move to next character
    jmp .swap_loop           # Repeat the loop

.swap_end_one:

    movb %al, (%rdi)         # Store the null terminator (optional)

.swap_end:

    popq %rdi                # Restore original pointer to rdi
    movq %rdi, %rax          # Move pointer into rax as return value
    popq %rbp                # Restore old base pointer
    ret                      # Return

# -------------------------------------------------------------------

 .globl pstrijcpy
 .type pstrijcpy, @function

pstrijcpy:

    pushq %rbp
    movq %rsp, %rbp

    xorq %rax, %rax

    pushq %rdi         # Save pointer to first pstring
    pushq %rsi         # Save pointer to second pstring

    movq %rdi, %r9   # r9 = dst
    movq %rsi, %r10  # r10 = src

    # Get length of first pstring
    movq %rdi, %rdi      # Load address of first pstring
    call pstrlen
    movq %rax, %r12     # Save length in local variable

    # Get length of second pstring
    movq %rsi, %rdi     # Load address of second pstring
    call pstrlen
    movq %rax, %r13     # Save length in local variable

    # i < 0 ?
    cmpq $0, %rcx
    jl .invalid_massege

    # j < 0 ?
    cmpq $0, %rdx
    jl .invalid_massege

    # i >= dst.length ?
    cmpq %r12, %rcx
    jae .invalid_massege

    # i >= src.length ?
    cmpq %r13, %rcx
    jae .invalid_massege
    
    # j >= dst.length ?
    cmpq %r12, %rdx
    jae .invalid_massege

    # j >= src.length ?
    cmpq %r13, %rdx
    jae .invalid_massege

    # j < i ?
    cmpq %rcx, %rdx
    jl .invalid_massege

  #  addq   $1, %r12 # adjust dst length (+1)
   # addq   $1, %r13 # adjust src length (+1)
    
    addq $1, %r9
    addq %rcx, %r9
    addq $1, %r10
    addq %rcx, %r10


.loop_pstrijcpy:

    cmp %rdx, %rcx        # while i < j
    jg .end_pstrijcpy

    movb (%r10), %al      # load src[i]
    movb %al, (%r9)      # store it in dst[i]

    inc %rcx
    inc %r10
    inc %r9

    jmp .loop_pstrijcpy

.invalid_massege:
 
    popq %rsi                # Restore rsi
    popq %rdi                # Restore rdi
    movq $0, %rax
    movq  %rbp, %rsp
    popq %rbp
    ret

.end_pstrijcpy:

    popq %rsi                # Restore rsi
    popq %rdi                # Restore rdi

    movq %rdi, %rax

    popq %rbp
    ret
# -------------------------------------------------------------------

 .globl pstrcat
 .type pstrcat, @function

pstrcat:

    # Function prologue – set up stack frame
    pushq %rbp
    movq %rsp, %rbp

    # Save original arguments (addresses of pstrings)
    pushq %rdi         # Save pointer to first pstring
    pushq %rsi         # Save pointer to second pstring
    
    movq %rdi, %r9
    movq %rsi, %r10

    # Get length of first pstring
    movq %rdi, %rdi      # Load address of first pstring
    call pstrlen
    movq %rax, %r12     # Save length in local variable

    # Get length of second pstring
    movq %rsi, %rdi     # Load address of second pstring
    call pstrlen
    movq %rax, %r13     # Save length in local variable

    # Check total length does not exceed 255
    xorq %rbx, %rbx
    addq %r12, %rbx     # Load first length
    addq %r13, %rbx     # Add second length
    cmpq $255, %rbx
    jae .cant_error_msg      # If too long, show error but copy anyway

    # Find end of first string to start appending
    incq %r9
    addq %r12, %r9
    xorq %rax, %rax          # Clear rax for byte copy

.ready_to_copy:

    incq %r10
    xorq %rax, %rax          # Clear rax for byte copy

    movq $0, %r14           # counter = 0

.copy_loo:

    cmpq %r13, %r14     # if counter == length of second string, stop
    je .done_copying

    movb (%r10), %al
    movb %al, (%r9)
    incq %r9
    incq %r10
    incq %r14
    jmp .copy_loo

.cant_error_msg:

    popq %rsi                # Restore rsi
    popq %rdi                # Restore rdi

    xorq %rax, %rax

    popq %rbp
    ret

.done_copying:

    # Function epilogue – clean up and return
    popq %rsi                # Restore rsi
    popq %rdi                # Restore rdi

 #   movq %r12, %rax    # length of first string
 #   addq %r13, %rax    # add length of second string
 #   movb %al, (%rdi)   # store result in first byte of first Pstring

    movq %rdi, %rax          # Return pointer to first pstring
    popq %rbp
    ret
