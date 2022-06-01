.globl classify

.data
m0: .word 0 0
m1: .word 0 0
input: .word 0 0

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
    
    li t0 5
    bne a0 t0 arg_error

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
    
    mv s0 a0 # s0 represents argc
    mv s1 a1 # s1 represents argv
    mv s2 a2

    # =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw s3 4(s1) # s3 represents path to m0
    mv a0 s3
    la t0 m0
    addi a1 t0 0
    addi a2 t0 4
    jal ra read_matrix
    mv s3 a0 # s3 represents pointer to m0

    # Load pretrained m1
    lw s4 8(s1) # s4 represents path to m1
    mv a0 s4
    la t0 m1
    addi a1 t0 0
    addi a2 t0 4
    jal ra read_matrix
    mv s4 a0 # s4 represents pointer to m0

    # Load input matrix
    lw s5 12(s1) # s5 represents path to input matrix
    mv a0 s5
    la t0 input
    addi a1 t0 0
    addi a2 t0 4
    jal ra read_matrix
    mv s5 a0 # s5 represents pointer to input matrix
    
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    la t0 m0
    lw t0 0(t0)
    la t1 input
    lw t1 4(t1)
    mul s6 t0 t1 # s6 represents m0 * input size
    mv a0 s6  
    slli a0 a0 2
    jal ra malloc
    mv s7 a0 # s7 represents m0 * input
    mv a0 s3
    la t0 m0
    lw a1 0(t0)
    lw a2 4(t0)
    mv a3 s5
    la t0 input
    lw a4 0(t0)
    lw a5 4(t0)
    mv a6 s7
    jal ra matmul 
     
    mv a0 s7
    mv a1 s6
    jal ra relu
    
    la t0 m1
    lw t0 0(t0)
    la t1 input
    lw t1 4(t1)
    mul a0 t0 t1
    slli a0 a0 2
    jal ra malloc
    mv s8 a0 # reprents matrix pointer to m1 * ReLU(m0 * input)
    mv a0 s4
    la t0 m1
    lw a1 0(t0)
    lw a2 4(t0)
    mv a3 s7
    la t0 m0
    la t1 input
    lw a4 0(t0)
    lw a5 4(t1)
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
    la t0 m1
    la t1 input
    lw a2 0(t0)
    lw a3 4(t1)
    jal ra write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s8
    la t0 m1
    lw t0 0(t0)
    la t1 input
    lw t1 4(t1)
    mul a1 t0 t1
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
    addi sp sp 52
    ret

 arg_error:
    li a1 49
    ret
