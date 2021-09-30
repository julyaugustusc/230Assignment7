###########################################################
# Assignment #: 7
# Name: Augustus Crosby 
# ASU email: ancrosby@asu.edu
# Course: CSE230, MW 3:05pm
# Description: Asks for integer, calls the function1, and 
#		prints the returned value from the 
#		function1. Demonstration of recursive function.
###########################################################

#data declarations: declare variable names used in program, storage allocated in RAM
		.data
line1:		.asciiz "Enter an integer:\n"
line2:		.asciiz "The solution is: "

#program code is contained below under .text

		.text 
		.globl main	# define a global function main

main:
	li $v0, 4		# load 4 for string
	la $a0, line1		# load string address
	syscall			# print_string

	li $v0, 5		# load 5 to read int
	syscall			# read_int
	move $a0, $v0		# move the result to $a0

	li $t0, 5		# load 5 for n <= 5
	li $t1, 2		# load 2 for multiplication

	addi $sp, $sp, -4	# move sp
	sw $ra, 0($sp)		# store return address to end

	jal function1		
	
	lw $ra, 0($sp)		# load the return address to end
	addi $sp, $sp, 4	# move sp

	li $v0, 4		# load 4 for string
	la $a0, line2		# load string address
	syscall			# print_string

	li $v0, 1		# load 1 for int
	move $a0, $s0		# move the value into $a0 for call
	syscall			# print_int
	jr $ra			# end

############################################################################
# Procedure/Function function1
# Description: the function to decide if/else
# parameters: $a0 = n, $t0 = 5 (to determine if/else)
# return value: $s0 = the return of the function
# registers to be used: $a0, $t0, $t1, $s0, $ra
############################################################################

function1:
	
	bgt $a0, $t0, recursive	# branch if n > 5

	#base case
	li $t1, 2		# load 2 for multiplication
	mult $a0, $t1		# n * 2
	mflo $s0		# pull answer to $v0
	addi $s0, $s0, 9	# $v1 = n*2 +9
	
	jr $ra 			#return for the base case

############################################################################
# Procedure/Function recursive
# Description: the "else" statement that is a recursive function
# parameters: $a0 = n, $s0 = old return value, $ra = return address
# return value: $s0 = the return of the current function
# registers to be used: $a0, $t0, $t1, $s0, $s1, $s2, $s3, $ra
############################################################################

recursive:

	addi $sp, $sp, -4	# move sp
	sw $ra, 0($sp)		# store return address
	addi $sp, $sp, -4	# move sp
	sw $a0, 0($sp)		# store n
	addi $sp, $sp, -4	# move sp
	sw $s0, 0($sp)		# store return value

	addi $a0,$a0, -2	# n = n-2 to plug into function1

	jal function1

	move $s1, $s0		# move the return to $s1

	lw $s0, 0($sp)		# load $s0
	addi $sp, $sp, 4	# move sp
	lw $a0, 0($sp)		# load n
	addi $sp, $sp, 4	# move sp
	lw $ra, 0($sp)		# load return address
	addi $sp, $sp, 4	# move sp
	
	addi $sp, $sp, -4	# move sp
	sw $ra, 0($sp)		# store return address
	addi $sp, $sp, -4	# move sp
	sw $a0, 0($sp)		# store n
	addi $sp, $sp, -4	# move sp
	sw $s0, 0($sp)		# store return value

	addi $a0, $a0, -3	# n = n-3

	jal function1

	move $s2, $s0		# move the return to $s2

	lw $s0, 0($sp)		# load $s0
	addi $sp, $sp, 4	# move sp
	lw $a0, 0($sp)		# load n
	addi $sp, $sp, 4	# move sp
	lw $ra, 0($sp)		# load return address
	addi $sp, $sp, 4	# move sp
	
	mult $a0, $s2		# n * function(n-3)
	mflo $s2		# $s2 = n * function(n-3)	
	
	mult $a0, $t1		# n * 2
	mflo $s3		# $s3 = n * 2

	
	add $s0, $s1, $s2	# $s0 = $s1 + $s2 - $s3
	sub $s0, $s0, $s3	# $s0 = $s1 + $s2 - $s3

	jr $ra			# return