from random import randint


x=randint(0,10)

while True:
    y=int(input("Guess a number from 0 to 10: "))
    if y>x:
        print("Your number is greater than my number. Try again.")
    elif y<x:
        print("Your number is less than my number. Try again.")
    else:
        print("My number is", x,"and your number is", y,". Congratulations!")