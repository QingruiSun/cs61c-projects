.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    addi sp sp -76
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
    
    mv s0 a0 # s0 represents argc
    mv s1 a1 # s1 represents argv
    mv s2 a2
    
    li t0 5
    bne s0 t0 arg_error

    # =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw s3 4(s1) # s3 represents path to m0
    mv a0 s3
    addi a1 sp 52
    addi a2 sp 56
    jal ra read_matrix
    mv s3 a0 # s3 represents pointer to m0

    # Load pretrained m1
    lw s4 8(s1) # s4 represents path to m1
    mv a0 s4
    addi a1 sp 60
    addi a2 sp 64
    jal ra read_matrix
    mv s4 a0 # s4 represents pointer to m0

    # Load input matrix
    lw s5 12(s1) # s5 represents path to input matrix
    mv a0 s5
    addi a1 sp 68
    addi a2 sp 72
    jal ra read_matrix
    mv s5 a0 # s5 represents pointer to input matrix


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0 52(sp)
    lw t1 72(sp)
    mul s6 t0 t1 # s6 represents m0 * input size
    mv a0 s6  
    slli a0 a0 2
    jal ra malloc
    mv s7 a0 # s7 represents m0 * input
    mv a0 s3
    lw a1 52(sp)
    lw a2 56(sp)
    mv a3 s5
    lw a4 68(sp)
    lw a5 72(sp)
    mv a6 s7
    jal ra matmul 
     
    mv a0 s7
    mv a1 s6
    jal ra relu
    
    lw t0 60(sp)
    lw t1 72(sp)
    mul a0 t0 t1
    slli a0 a0 2
    jal ra malloc
    mv s8 a0 # reprents matrix pointer to m1 * ReLU(m0 * input)
    mv a0 s4
    lw a1 60(sp)
    lw a2 64(sp)
    mv a3 s7
    lw a4 52(sp)
    lw a5 72(sp)
    mv a6 s8
    jal ra matmul
    
    mv a0 s3
    jal ra free
    mv a0 s4
    jal ra free
    mv a0 s5
    jal ra free
    mv a0 s7
    jal ra free   

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s1)
    mv a1 s8
    lw a2 60(sp)
    lw a3 72(sp)
    jal ra write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s8
    lw t0 60(sp)
    lw t1 72(sp)
    mul a2 t0 t1
    jal ra argmax
    mv s9 a0 # s9 represents class index
    mv a0 s8
    jal ra free
    
    bne s2 x0 end
    # Print classification
    mv a1 s9
    jal ra print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra print_char
    
    end:
    mv a0 s9
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
    addi sp sp 76
    ret

    arg_error:
    li a1 49
    jal ra exit2
