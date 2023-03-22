# CSCE 611 - Lab 1 - Ethan Hang
		.data
guess:		.word	256
step:		.word	128
scale:		.word	16384
string1:	.string "Please enter a positive integer"
mask:		.word	0x3FFF
eighteen:	.word	0x3FFFF
		.text
main:
	li a7, 5		# grab user input, a0
	ecall
	
	mv t1, a0		# t1 = input
	
	blt t1, zero, negative	# if t1 < 0, go to negative
	
	lw t6, scale		# t6 = 16384 or .1 (32,14)
	
	lw t2, guess		# t2 = guess = 256
	lw t3, step		# t3 = step = 128
	
	# multiply guess and step by 2^14
	mul t2, t2, t6		# t2 = guess*16384
	mul t3, t3, t6		# t3 = step*16384
	
	lw s0, mask	# 0x3FFF
	lw s3, eighteen	# 0x3FFFF
	
	# square guess
check:
	bgt t3, zero, loop 	# step greater than zero, go to loop
	j print
loop:
	mul t5, t2, t2		# t5 = squared guess low
	mulhu t4, t2, t2	# t4 = squared guess high
	srli t5, t5, 14		# shift by 14 to right
	slli t4, t4, 18		# shift by 18 to left
	or t5, t4, t5		# OR t4 and t5
	beq t1, t5, print	# if input = guess, then print
	bgt t5, t1, substep 	# if guess^2 > input, then go to substep
	j addstep		# else, go to addstep
increment:
	srli t3, t3, 1		# increment: step/2
	j check
substep:
	sub t2, t2, t3		# substep: guess - step
	j increment
addstep:
	add t2, t2, t3		# addstep: guess + step
	j increment
# if user inputs a negative number, print a message
negative:
	li a7, 4		# print string at a0
	la a0, string1
	ecall
	j exit
print:
	li a7, 1		# print integer at a0
	mv a0, t2
	ecall
	j exit
exit:
