.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    la a0 file_path
    addi sp sp -8
    mv a1 sp
    addi a2 sp 4
    jal ra read_matrix

    # Print out elements of matrix
    lw a1 0(sp)
    lw a2 4(sp)
    jal ra print_int_array


    # Terminate the program
    jal ra exit
