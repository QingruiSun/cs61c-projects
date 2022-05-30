.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t0 1
    blt a1, t0, error2
    blt a2, t0, error2
    blt a4, t0, error3
    blt a5, t0, error3
    bne a2, a4, error4
    j start
    error2:
    li a3 2
    ret
    error3:
    li a3 3
    ret
    error4:
    li a3 4
    ret
start: 
    # Prologue
    addi sp sp -52
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)
    sw ra 48(sp)
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4
    mv s5 a5
    mv s6 a6

    mv t4 s6 # t4 points to result matrix where we write to
    li t0 0
outer_loop_start:
                mul t1 t0 s2
                slli t1 t1 2      
                add t1 s0 t1 # start pointer to one matrix row
                li t2 0
inner_loop_start:
                bge t2 s5 inner_loop_end # t2 represents the result matrix column index
                slli t3 t2 2
                add t3 t3 s3 # start pointer to one matrix column
                mv a0 t1
                mv a1 t3
                mv a2 s2
                li a3 1
                mv a4 s5
                mv s7 t0
                mv s8 t1
                mv s9 t2
                mv s10 t3
                mv s11 t4
                jal ra dot
                mv t0 s7
                mv t1 s8
                mv t2 s9
                mv t3 s10
                mv t4 s11
                sw a0 0(t4)
                addi t4 t4 4
                addi t2 t2 1
                j inner_loop_start

inner_loop_end:
              addi t0 t0 1
              blt t0 s1 outer_loop_start

outer_loop_end:

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    lw ra 48(sp) 
    addi sp sp 48
    
    ret
