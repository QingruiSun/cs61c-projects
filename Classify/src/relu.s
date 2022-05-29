.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    


loop_start:
          add t0, x0, x0
               
loop_continue:
             beq t0, a1, loop_end
             slli t1, t0, 2
             add t2, a0, t1
             lw t3, 0(t2)
             blt t3, x0, else
             then:
             j end
             else:
             add t3, x0, x0
             j end
             end:
             sw t3, 0(t2)
             addi t0, t0, 1
             j loop_continue
             

loop_end:
        li, t0, 1
        blt a1, t0, else1
        then1:
        addi a0, x0, 0
        j end1
        else1:
        addi a0, x0, 8
    # Epilogue

        end1:
	ret
