# Ethan Hang CSCE 611

	.text
	
	csrrw   s0, 0xf00, s3

	li	s1, 429496730	# fractional
	li 	t0, 0	# t0 = output
	li 	s2, 10
	
	slli	t0, t0, 4	# shift 4 bits
	mul	t2, s0, s1	# input multiplied by fractional bits, this will give lower bits
	mulh	t1, s0, s1	# upper bits
	mulhu	t2, t2, s2	# multiply fractional bits by 10
	or 	t0, t0, t2	# or 
	
	// repeat 8 times
	slli	t0,t0,4	
	mul	t2,t1,s1
	mulh	t1,t1,s1	
	mulhu	t2,t2,s2	
	or 	t0,t0,t2	
	
	slli	t0,t0,4		
	mul	t2,t1,s1	
	mulh	t1,t1,s1	
	mulhu	t2,t2,s2	
	or 	t0,t0,t2	
	
	slli	t0,t0,4		
	mul	t2,t1,s1	
	mulh	t1,t1,s1	
	mulhu	t2,t2,s2	
	or 	t0,t0,t2	
	
	slli	t0,t0,4		
	mul	t2,t1,s1	
	mulh	t1,t1,s1	
	mulhu	t2,t2,s2
	or 	t0,t0,t2	
	
	slli	t0,t0,4		
	mul	t2,t1,s1	
	mulh	t1,t1,s1	
	mulhu	t2,t2,s2	
	or 	t0,t0,t2	
	
	slli	t0,t0,4		
	mul	t2,t1,s1	
	mulh	t1,t1,s1	
	mulhu	t2,t2,s2	
	or 	t0,t0,t2	
	
	slli	t0,t0,4	
	mul	t2,t1,s1	
	mulh	t1,t1,s1	
	mulhu	t2,t2,s2	
	or 	t0,t0,t2	

	csrrw 	s5, 0xf02, t0
