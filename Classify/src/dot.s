.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    # Prologue


loop_start:
          li t0, 1
          blt a2, t0, error1
          blt a3, t0, error2
          blt a4, t0, error2
          add t0, x0, x0 #t0 represents sum
          add t1, x0, x0 #t1 represents index


loop_continue:
             beq t1, a2, loop_end
             mul t2, t1, a3
             slli t2, t2, 2
             add t2, a0, t2
             lw t2, 0(t2)
             mul t3, t1, a4
             slli t3, t3, 2
             add t3, a1, t3
             lw t3, 0(t3)
             mul t4, t2, t3
             add t0, t0, t4
             addi, t1, t1, 1
             j loop_continue

loop_end:
        add a0, t0, x0
        j end
        error1:
        li a3, 5
        j end
        error2:
        li a3, 6
        end:

    # Epilogue

    
    ret
