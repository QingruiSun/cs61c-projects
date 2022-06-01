.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -36
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw ra 24(sp)
    sw a2 28(sp)
    sw a3 32(sp)
  
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    #main
    mv a1 s0
    li a2 4
    jal ra fopen
    mv s4 a0 # s4 represents file descriptor
    bge s4 x0 start1
    li a1 53
    jal ra exit2
    start1:
    mv a1 s4
    addi a2 sp 28
    li a3 2
    li a4 4
    jal ra fwrite
    li t0 2
    beq a0 t0 start2
    li a1 54
    jal ra exit2
    start2:
    mv a1 s4
    jal ra fflush
    beq a0 x0 start3
    li a1 2
    jal ra exit2
    start3:
    mv a1 s4
    mv a2 s1
    mul a3 s2 s3
    li a4 4
    jal ra fwrite
    mul t0 s2 s3
    beq a0 t0 start4
    li a1 54
    jal ra exit2
    start4:
    mv a1 s4
    jal ra fflush
    beq a0 x0 start5
    li a1 2
    jal ra exit2
    start5:
    mv a1 s4
    jal ra fclose
    beq a0 x0 start6
    li a1 55
    jal ra exit2
    start6:

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw ra 24(sp)
    addi sp sp 36

    ret
