#Axel Balitaan
#CMSC 12 T15L
#GWA Calculator with Honor Categorization and Basic Input Validation

#INPUT
#First Subject Input
s1=float(input("Enter grade: "))
if s1<1 or s1>5 or 3<s1<5 or s1%0.25!=0:
	print("Invalid Input")
s1u=float(input("Enter number of units: "))
if s1u<1 or s1u>5 or 3<s1u<5 or s1u%1!=0:
	print("Invalid Input")

#Second Subject Input
s2=float(input("Enter grade: "))
if s2<1 or s2>5 or 3<s2<5 or s2%0.25!=0:
	print("Invalid Input")
s2u=float(input("Enter number of units: "))
if s2u<1 or s2u>5 or 3<s2u<5 or s2u%1!=0:
	print("Invalid Input")

#Third Subject Input
s3=float(input("Enter grade: "))
if s3<1 or s3>5 or 3<s3<5 or s3%0.25!=0:
	print("Invalid Input")
s3u=float(input("Enter number of units: "))
if s3u<1 or s3u>5 or 3<s3u<5 or s3u%1!=0:
	print("Invalid Input")

#Fourth Subject Input
s4=float(input("Enter grade: "))
if s4<1 or s4>5 or 3<s4<5 or s4%0.25!=0:
	print("Invalid Input")
s4u=float(input("Enter number of units: "))
if s4u<1 or s4u>5 or 3<s4u<5 or s4u%1!=0:
	print("Invalid Input")

#Fifth Subject Input
s5=float(input("Enter grade: "))
if s5<1 or s5>5 or 3<s5<5 or s5%0.25!=0:
	print("Invalid Input")
s5u=float(input("Enter number of units: "))
if s5u<1 or s5u>5 or 3<s5u<5 or s5u%1!=0:
	print("Invalid Input")

#GWA Computation
s1w=s1*s1u
s2w=s2*s2u
s3w=s3*s3u
s4w=s4*s4u
s5w=s5*s5u
subsum=(s1w+s2w+s3w+s4w+s5w)
unitsum=s1u+s2u+s3u+s4u+s5u
GWA=subsum/unitsum


#OUTPUT
print("Your GWA is", GWA)
if s1>=5 or s2>=5 or s3>=5 or s4>=5 or s5>=5:
	print("You have a grade of 5 which disqualifies you from getting latin honors.")
elif GWA>=1.00 and GWA<=1.20:
	print("If you can maintain your GWA you can graduate summa cum laude.")
elif GWA>1.20 and GWA<=1.45:
	print("If you can maintain your GWA you can graduate magna cum laude.")
elif GWA>1.45 and GWA<=1.75:
	print("If you can maintain your GWA you can graduate cum laude.")
else:
	print("Sorry your grade doesn't qualify for honors.")