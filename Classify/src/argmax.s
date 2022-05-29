.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue

loop_start:
          add t0, x0, x0
          li t1, 0 # represents the max value in vector
          li t2, -1 # represents the index of max value in vector


loop_continue:
             beq t0, a1, loop_end
             slli t2, t0, 2
             add t3, a0, t2
             lw t4, 0(t3)
             blt t1, t4, else
             then:
             j end
             else:
             add t1, t4, x0
             add t2, t0, x0
             end:
             addi t0, t0, 1
             j loop_continue


loop_end:
        li t5, 1
        blt a1, t5, else1
        add a0, t2, x0
        j end1
        else1:
        li a3, 7
        end1:
       
    # Epilogue


    ret
