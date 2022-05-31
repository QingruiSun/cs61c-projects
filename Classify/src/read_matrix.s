.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -64
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
    sw a0 52(sp)
    sw a1 56(sp)
    sw a2 60(sp)
   
    #main
    mv a1 a0
    li a2 0
    jal ra fopen
    bge a0 x0 start1
    li a1 50
    jal ra exit2
    start1:
    mv s0 a0 # s0 represents file descriptor
    li a0 8
    jal ra malloc
    bgt a0 x0 start2
    li a1 48
    jal ra exit2
    start2:
    mv s1 a0 # s1 points to 8 byte memory
    mv a1 s0
    mv a2 s1
    li a3 8
    jal ra fread
    li t0 8
    beq a0 t0 start3
    li a1 51
    jal ra exit2
    start3:
    lw s2 0(s1) # s2 represents row number
    lw s3 4(s1) # s3 represents column number
    mul s4 s2 s3 # s4 represents matrix size
    mv t0 s4
    li t1 4
    mul a0 t0 t1
    jal ra malloc
    bgt a0 x0 start4
    li a1 48
    jal ra exit2
    start4:
    mv s5 a0 # s5 points to memory for matrix
    mv a1 s0
    mv a2 s5
    li t0 4
    mul a3 t0 s4
    jal ra fread
    li t0 4
    mul t1 t0 s4
    beq a0 t1 start5
    li a1 51
    jal ra exit2
    start5:
    mv a1 s0
    jal ra fclose
    beq a0 x0 start6
    li a1 52
    jal ra exit2
    start6:
    mv a0 s1
    jal ra free
    mv a0 s5
    lw a1 56(sp)
    lw a2 60(sp)
    sw s2 0(a1)
    sw s3 0(a2)

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
    addi sp sp 64

    ret
