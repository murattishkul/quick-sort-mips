# DONE BY MURAT TISHKUL ID20162035 	
	.data
data:	.word 8,5,14,10,12,3,9,6,1,15,7,4,13,2,11
size:	.word 15
#use below sample if above example is too large to debug
# data:	.word 4,2,5,3,1
# size:	.word 5
# data:	.word 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1
# size:	.word 15
# data:	.word 8,9,10,11,12,13,14,15,1,2,3,4,5,6,7
# size:	.word 15
# data:	.word 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
# size:	.word 15
# data:	.word 8
# size:	.word 1
# data:	.word 100,1
# size:	.word 2
# data:	.word 1,10
# size:	.word 2
# data:	.word 100,1,-234,5,1,23,-32,34,34,-34
# size:	.word 10
	.text

partition: # partition(data, start, end);
	subu $sp,$sp,32 # Stack frame is 32 bytes long
	sw $ra,16($sp) # Save return address
	sw $a0,28($sp) # Save argument data
	sw $a1,24($sp) # Save argument start
	sw $a2,20($sp) # Save argument end

	# body
	lw $t0, 24($sp) # t0 left
	lw $t1, 20($sp) # t1 right
	lw $s5, 24($sp) # s5 start
	lw $s6, 20($sp) # s6 end
	# Load data[start]
	sll $t2, $t0, 2 # t2 = start*4
	add $t2, $t2, $a0  # t2= address of data[start*4]
	lw $t2, 0($t2) # t2=pivot = data[start]

    Loop:
        bge $t0, $t1, EXIT # while (left < right)
		# branch to EXIT if register t0 is greater than or equal to t1.
	    # Loop 1:
	    Loop1:
			# Load data[right] to $t3
			sll $t3, $t1, 2 # t3 = right*4
			add $t3, $a0, $t3  # t3 = address of data[right*4]
			lw $t3, 0($t3) # t3 = data[right]
			bge $t2, $t3, EXIT1 # while (data[right] > pivot) 
			# Conditionally branch to EXIT1 if register pivot is greater than or equal to data[right]. 
			addi $t1, $t1, -1
			j Loop1

		EXIT1:		
	    # Loop 2:
		Loop2:
			#Load data[left] to $t4
			sll $t4, $t0, 2 # t4 = left*4
			add $t4, $a0, $t4  # t4 = address of data[left*4]
			lw $t4, 0($t4) # t4 = data[left]
			sgt $t5, $t1, $t0 # Set register t5 to 1 if register t1 is greater than t0, and to 0 otherwise.
			# data[left] <= pivot)
			sle $t6, $t4, $t2 # Set register t6 to 1 if register t4 is less than or equal to t3, and to 0 
			and $t5, $t5, $t6 
			beqz $t5, EXIT2 # Conditionally branch to EXIT2 if t5 equals 0.
			# while ((left < right) && (data[left] <= pivot))
			# Conditionally branch to EXIT2 if register pivot is greater than or equal to data[right]. 
			addi $t0, $t0, 1
			j Loop2

		EXIT2:
 
	    # If statement
		# if (left < right)
		sgt $t5, $t1, $t0 # Set register t5 to 1 if register t1 is greater than t0, and to 0 otherwise.
		beqz $t5, MURAT# branch to MURAT if t5 equals 0.

		# Load data[right] to $t3
		sll $t3, $t1, 2 # t3 = right*4
		add $t3, $a0, $t3  # t3 = address of data[right*4]
		lw $t5, 0($t3) # t5 = data[right]

		#Load data[left] to $t3 
		sll $t4, $t0, 2 # t4 = left*4
		add $t4, $a0, $t4  # t4 = address of data[left*4]
		lw $t6, 0($t4) # t6 = data[end]

		sw $t5, 0($t4)
		sw $t6, 0($t3)
        
		MURAT:

        j Loop
	   
	EXIT:

	# load data[start] address to 
	sll $t7, $s5, 2 # t7 = start*4
	add $t7, $a0, $t7  # t7 = address of data[start*4]
	# Load data[right] to $t3
	sll $t3, $t1, 2 # t3 = right*4
	add $t3, $a0, $t3  # t3 = address of data[right*4]
	lw $t8, 0($t3) # t3 = data[right]
	# store data[right] value to data[start] address
	sw $t8, 0($t7)
	# store pivot value to data[right] address
	sw $t2, 0($t3)

	# returning to quick sort
	# we should store return value to v0
	move $v0, $t1
	lw	$ra, 16($sp) # Restore $ra
	addi	$sp, $sp, 32 # Pop stack
	# addi	$sp, $sp, -4 
	# sw $t1, 0($sp)
	jr 	$ra






quick_sort: # signature is (int *data, int start, int end)
	subu $sp,$sp,32 # Stack frame is 32 bytes long
	sw $ra,16($sp) # Save return address
	sw $a0,28($sp) # Save argument data
	sw $a1,24($sp) # Save argument start
	sw $a2,20($sp) # Save argument end

	# comparing
	bge $a1, $a2, L1 #  if (start < end) branch to L1 if register a1 is greater than or equal to a2.
	# preparing regs to call partition:
	addi $sp, $sp, -4 # substruct 4 from current stack pointer
	sw	$ra, 0($sp) # store return address to the ra register

	# call partition:
	jal partition # partition(data, start, end);

	lw	$ra, 0($sp) # load return address back to register
	addi	$sp, $sp, 4 # popping stack

	# preparing regs to call qs 1st time:
	lw $a0,28($sp) # load argument data
	lw $a1,24($sp) # load argument start
	move $a2, $v0 # move partition result, pivot, to $a2
	addi $a2, $a2, -1 # pivot = pivot - 1
	sw $v0, 12($sp)

	addi $sp, $sp, -4 # substruct 4 from current stack pointer
	sw	$ra, 0($sp) # store return address to the address

	# call qs1:
	jal quick_sort # quick_sort(data, start, pivot_position - 1);

	lw	$ra, 0($sp) # load return address back to register
	addi	$sp, $sp, 4 # popping stack

	# preparing regs to call qs 2nd time:
	lw $a0,28($sp) # load argument data
	lw $a1,12($sp) # load argument start
	lw $a2,20($sp) # load argument end
	addi $a1, $a1, 1 # pivot = pivot + 2

	addi $sp, $sp, -4 # substruct 4 from current stack pointer
	sw	$ra, 0($sp) # store return address to the address

	# call qs 2:
	jal quick_sort # quick_sort(data, pivot_position + 1, end);

	lw	$ra, 0($sp) # load return address back to register
	addi	$sp, $sp, 4 # popping stack


	L1:
	# prepare to return to main
	lw	$ra, 16($sp) # Restore $ra
	addi	$sp, $sp, 32 # Pop stack
	jr 	$ra




main:
	la 	$a0, data				#load address of "data"."la" is pseudo instruction, see Appendix A-66 of text book.
	addi 	$a1, $zero, 0
	lw 	$a2, size				#load data "size"
	addi	$a2, $a2, -1

	addi 	$sp, $sp, -4
	sw	$ra, 0($sp) # store address of main in ra

	jal 	quick_sort			#quick_sort(data,0,size-1)

	lw	$ra, 0($sp) # load return address back to register
	addi	$sp, $sp, 4 # popping stack

	jr 	$ra # return from main to return address
