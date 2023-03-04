n = int(input("Enter a number: "))
a = n
b = n
num_dig = 0
sum = 0

while a > 0:
    a = a//10
    num_dig = num_dig + 1
while b > 0:
    y = b % 10
    sum = sum + y**num_dig
    b = b // 10
if sum == n:
    print("narcissistic")
else:
    print("No")
