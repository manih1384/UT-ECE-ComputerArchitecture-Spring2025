lw x8, 1000(x0)         # x8 = data[0]
add x9, x0, x0          # x9 = 0 (index pointer)
add x15, x0, x0         # x15 = 0 (max index)
Loop:
addi x9, x9, 4          # x9 += 4 (move to next 32-bit element)
slti x6, x9, 80         # t1 = (x9 < 80)
beq x6, x0, EndLoop     # branch if done
lw x18, 1000(x9)        # x18 = data[index]
slt x6, x8, x18         # t1 = (max < current)
beq x6, x0, Loop        # if not, skip update
add x8, x18, x0         # max = x18
add x15, x9, x0         # max_index = x9
jal x0, Loop            # always jump to Loop
EndLoop:
sw x8, 2000(x0)         # store max to address 2000 (first answer)
sw x15, 2004(x0)        # store max_index to address 2004 (second answer)
jal x0, End             # infinite loop/halt
End:
jal x0, End
