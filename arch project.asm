.text
#loads

lb x1,0(x0)
lh x2,2(x0)
lw x3,0(x0)

#R type

add x4,x1,x2
sub x5,x3,x2
and x6,x1,x2
or x7,x3,x0
xor x8,x1,x0
sll x9,x2,x1
slt x10,x1,x4
sltu x11,x4,x2
srl  x12,x2,x1
sra  x13,x2,x1

#I type

addi x14,x1,2
andi x15,x1,-1
ori x16,x3,-1
xori x17,x1,-1
slli x18,x2,1
slti x19,x1,0
sltiu x20,x4,-1
srli  x21,x2,2
srai  x22,x2,3

#store

sb x23,4(x0)
sh x24,5(x0)
sw x25,6(x0)

#jal(R)

jal x26,loop
nop
jalr x27,x0,120 
nop
nop

#lui

lui x28,255
auipc x29,4

#branches

beq x0,x0,loop
bne x0,x1,loop
blt x16,x0,loop
bge x2,x0,loop
bltu x0,x16,loop
bgeu x16,x0,loop
nop
nop
loop: