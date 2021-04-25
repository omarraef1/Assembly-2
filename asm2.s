
.text


.globl studentMain
studentMain:
	addiu 	$sp, $sp, -24	# allocate stack space -- default of 24 here
	sw 	$fp, 0($sp) 	# save caller's frame pointer
	sw 	$ra, 4($sp) 	# save return address
	addiu 	$fp, $sp, 20 	# setup main's frame pointer
	
	
	la $s0, printInts	# s0 = &printInts
	lb $s0, 0($s0)		# s0 = printInts
	
	beq $s0, $zero, OnToWords
	
.data
newL: .asciiz "\n"
msg1: .asciiz "printInts: About to print "
msg1ext: .asciiz " elements.\n"
msg2: .asciiz "printInts: About to print an unknown number of elements.  Will stop at a zero element.\n"
	
.text

	la $s3, printInts_howToFindLen
	lh $s3, 0($s3)
	
	la $t8, intsArray
	lw $s5, 0($t8)
	
	addi $t0, $zero, 2
	
	beq $s3, $t0, OuterElseInts
	
		addi $t1, $zero, 0	#int count
		
		bne $s3, $zero, innerElseIntsOne
			
			la $s4, intsArray_len
			lw $s4, 0($s4)
			
			add $t1, $zero, $s4 	#count = intsArray_len
			
			j later
			
		innerElseIntsOne:
			#count = intsArray_END - intsArray;  // remember to divide by 4!
			
		#	la $s5, intsArray
		#	lw $s5, 0($s5)
			
			la $t2, intsArray_END 	#CHECK IF TREATED THE SAME
			lw $t2, 0($t2)
			
			sub $t3, $t2, $s5
			sra $t4, $t3, 2
			add $t1, $t4, $zero 	# count = intsArray_END - intsArray;
			
			j later
		later:
			# printf("printInts: About to print %d elements.\n", count);
			addi $v0, $zero, 4
			la $a0, msg1
			syscall
			
			addi $v0, $zero, 1
			add $a0, $zero, $t1
			syscall
			
			addi $v0, $zero, 4
			la $a0, msg1ext
			syscall
			
			
			#for loop printing, indexing arrays
			addi $t5, $zero, 0	# int i = 0
			
			LOOP:	
			slt $t6, $t5, $t1
			beq $t6, $zero, ExitLoop
			
			#add $t7, $t1, $t1
			#add $t7, $t7, $t7
			#add $t7, $t8, $t7
			#addi $t7, $t7, 4
			#add $t9, $t7, $zero
			#lw $t9, 0($t8) 		#check			TODO
			
			
			
			addi $v0, $zero, 1
			add $a0, $zero, $s5
			syscall
			
			addi $v0, $zero, 4
			la $a0, newL
			syscall
			
			#la $t8, intsArray
			lw $s5, 4($t8)
			
			#la $t8, 
			#add $t8, $zero, $s5
			
		#	addi $v0, $zero, 1
		#	add $a0, $zero, $t9
		#	syscall
			#lw $t9, 4($t8)
			
			addi $t5, $t5, 1
			j LOOP
				
					
			
			ExitLoop:
			# exit somehow
			j ExitTaskOne
			
			
	OuterElseInts:	
	
		#cur = intsArray, same as &intsArray[0]
		la $t2, intsArray
		lw $t3, 0($t2)	#cur = intsArray[0]
		
		#print
		addi $v0, $zero, 4
		la $a0, msg2
		syscall
		
		#while loop
		LOOPTwo:
		beq $t3, $zero, AFTER
		
		addi $v0, $zero, 1
		add $a0, $zero, $t3
		syscall
		
		addi $v0, $zero, 4
		la $a0, newL
		syscall
		
		add $t4, $t3, $t3
		add $t4, $t4, $t4
		add $t4, $t2, $t4
		lw $t3, 0($t4)
		
		j LOOPTwo
		
		AFTER:
		#none
	
	
	
	
	
	ExitTaskOne:
	
	OnToWords:
.data
space: .asciiz " "
msg1tsk2: .asciiz "printWords: There were "
msg1tsk2ext: .asciiz " words.\n"
newLine: .asciiz "\n"

.text
	
	la $s1, printWords	# s1 = &printWords
	lb $s1, 0($s1)		# s1 = printWords
	
	beq $s1, $zero, OnToSort
	
	la $t0, theString	#start = theString
	lw $t0, 0($t0)
	
	add $t1, $t0, $zero 	# cur = start
	
	addi $t2, $zero, 1	#count = 1
	
	LOOPTex:
	addi $t5, $zero, 0x00
	beq $t1, $t5, AfterWhile
	
	addi $t6, $zero, 0x20
	bne $t1, $t6, afterIn		#ASCII FOR SPACE
	
	
	add $t1, $zero, $t5
	addi $t2, $t2, 1
	
	j afterIn
	afterIn:
	
	#increment cur TODO					TODO
	la $t0, theString	#start = theString
	lw $t1, 4($t0)
	#lw $t4, 4($t0)		#check if correct incrementation
#	add $t1, $t4, $zero
	#addi $t1, $t1, 1 	#check #infinite loop
	j LOOPTex
	
	
	AfterWhile:
	
	addi $v0, $zero, 4
	la $a0, msg1tsk2
	syscall
	
	addi $v0, $zero, 1
	add $a0, $zero, $t2
	syscall
	
	addi $v0, $zero, 4
	la $a0, msg1tsk2ext
	syscall
	
	LOOPSec:
	slt $t3, $t1, $t0
	bne $t3, $zero, THERE
	
	#if function
	bne $t1, $t0, outThere
	
	addi $v0, $zero, 1
	add $a0, $zero, $t1
	syscall
	
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	
	#decrement cur				TODO
	lw $t1, -4($t1)
	j LOOPSec
	
	outThere:
	#next or
	#condition:
	lw $t8, -4($t1) #cur[-1]
	bne $t8, $t5, outtaThere
	addi $v0, $zero, 1
	add $a0, $zero, $t1
	syscall
	
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	
	#decrement cur				TODO
	lw $t1, -4($t1)
	j LOOPSec
	outtaThere:
	THERE:
	
	
	
	
	
	OnToSort:
	
.data
lsttskmsg: .asciiz "Swap at: "
lsttsknewL: .asciiz "\n"


.text
	
	la $s2, bubbleSort	# s2 = &bubbleSort
	lb $s2, 0($s2)		# s2 = bubbleSort
	
	beq $s2, $zero, DONE
	
	la $t2, intsArray_len
	lw $t2, 0($t2)
	
	addi $t5, $t2, -1 	#intsArray_len-1
	
	addi $t7, $zero, 0	#int j
	
	addi $t3, $zero, 0	#int i
	
	LOOPTHR:
	slt $t4, $t3, $t2
	beq $t4, $zero, AFTERTHR
	
		LOOPTHRext:
		slt $t6, $t7, $t5
		beq $t6, $zero, AfterextThr
		
		#if				TODO
		
			#print
			
		j LOOPTHRext
		
		AfterextThr:
		#zero j counter
		j LOOPTHR
	
	AFTERTHR:
	j DONE
	
	# jump to DONE
	
	
DONE: 	# Epilogue for main -- restore stack frame pointer and return
	lw 	$ra, 4($sp) 	# get return address from stack
	lw 	$fp, 0($sp)	# restore the caller's frame pointer
	addiu 	$sp, $sp, 24 	# restore the caller's stack pointer
	jr 	$ra 		# return to caller's code
