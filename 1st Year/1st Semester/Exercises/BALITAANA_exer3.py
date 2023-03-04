#Axel Balitaan
#CMSC 12 T1-5L
#Program that gets the product of digits of a number and loops it until it becomes single digit

#User input
N=int(input("Enter a positive number: "))
if N>0:
	while N > 9: 				#condition for N to be considered single digit
		total=1 				#total (holder) resets if N is not yet single digit
		while N > 0:			#block for computation of total (the product of digits)
			x = N % 10
			total = total * x
			N = (N - x) / 10
		N=total					#once the computation loop ends, the total is stored in N
	print(N)
else:
	print("You entered an invalid number")