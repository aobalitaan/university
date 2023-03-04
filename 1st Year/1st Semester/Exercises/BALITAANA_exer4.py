# Axel Balitaan
# CMSC 12 T1-5L
# Application of Functions and Parameters through a Cash Register Program

#ITEM PRICE BLOCK
Apple = 10
Orange = 15
Grape = 20

#holder
d = 0
subtotal = 0

#FUNCTION BLOCK
#Main Menu
def MainMenu():
	print("-- Main Menu --")
	print()
	print("[1] New Transaction")
	print("[2] Enter Discount coupon code")
	print("[3] Calculate total and print receipt")
	print("[0] Exit")

	MMC = input("Select an option: ")
	return MMC

#New Transaction (button 1)
def NewTransaction():
	print("-- Item Shop --")
	print()
	print("1. Apple @", end="")
	print(Apple)
	print("2. Orange @", end="")
	print(Orange)
	print("3. Grape @", end="")
	print(Grape)

	subtotal = 0
	while True:
		NTC = str(input("Select an item: "))
		if NTC == "1":
			subtotal = subtotal + Apple
			print("Added Apple @", end="")
			print(Apple)
		elif NTC == "2":
			subtotal = subtotal + Orange
			print("Added Orange @", end="")
			print(Orange)
		elif NTC == "3":
			subtotal = subtotal + Grape
			print("Added Grape @", end="")
			print(Grape)
		elif NTC == "0":
			break
		else:
			print("Invalid Input")
			continue
	return subtotal

#Discount (button 2)
def Discount():
	DC = input("Enter coupon code: ")
	if DC == "FRUIT10":
		d = 10
	elif DC == "PRUTAS20":
		d = 20
	else:
		print("You have an invalid code.")
		d = 0
	return d

#Receipt Printing Block
def TotalAndReceipt():
	print("=================================")
	print()
	print("Cashier Name: ", Name)
	print()
	print("Amount Due: ", AmountDue)
	print("Cash: ", Cash)
	print("Change: ", Cash - AmountDue)
	print("Discount", d, "%")
	print()
	print("=================================")

#MAIN BLOCK
#input
Name = str(input("Enter cashier name: "))

while True:
	MMC = str(MainMenu())
	if MMC == "1":
		subtotal = float(NewTransaction())
		print("Your current amount due is", subtotal)
	elif MMC == "2":
		if d == 0 and subtotal != 0:
			d = Discount()
			print("Your discount amount is: ", d, "%")
		elif d != 0:
			print("You have already applied a discount code.")
		elif subtotal == 0:
			print("You don't have a transaction yet.")
	elif MMC == "3":
		AmountDue = float(subtotal * (1-d/100))
		if subtotal != 0:
			while True:
				Cash = float(input("Enter cash: "))
				if Cash < subtotal:
					print("You don't have enough cash")
				else:
					TotalAndReceipt()
					d = 0
					AmountDue = 0
					subtotal = 0
					break
		else:
			print("You don't have a transaction yet")
	elif MMC == "0":
		print("Good Bye!")
		break
	else: 
		print("Invalid Input")
		continue