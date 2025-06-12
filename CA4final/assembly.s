    lw   x10, 0(x0)       # x10 = max value (first element)
    ori  x11, x0, 0       # x11 = max index = 0
    ori  x12, x0, 1       # x12 = current index = 1
    ori  x13, x0, 20      # x13 = array size = 20

loop:
    beq  x12, x13, done   # if index == 20, exit
    
    # Calculate index * 4 using additions
    add  x14, x12, x12    # x14 = index * 2
    add  x14, x14, x14    # x14 = index * 4
    
    add  x15, x0, x14     # x15 = address of array[index]
    lw   x16, 0(x15)      # x16 = array[index]
    
    slt  x17, x10, x16    # x17 = 1 if max < array[index]
    beq  x17, x0, skip    # if not greater, skip update
    
    add  x10, x16, x0     # update max value
    add  x11, x12, x0     # update max index

skip:
    addi x12, x12, 1      # index++
    jal  x0, loop         # jump back to loop
    
done:
    sw   x10, 80(x0)      # store max value at address 80
    sw   x11, 84(x0)      # store max index at address 84
