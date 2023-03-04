# Axel O. Balitaan
# CMSC 12 T15L
# Simple Inventory System with quantity monitoring using Dictionaries

def mainMenu():
	#Main Menu Block
	inventory = {}

	while True:
		print("--------------------MENU---------------------")
		print("[1] Add New Product")
		print("[2] View All Products")
		print("[3] Delete a Product")
		print("[4] Delete All Products")
		print("[5] Restock a Product")
		print("[6] Consume a Product")
		print("[0] Exit")

		MMC = input("Enter choice:	")

		if MMC == "1":
			addProduct(inventory)
		elif MMC == "2":
			viewProducts(inventory)
		elif MMC == "3":
			deleteProduct(inventory)
		elif MMC == "4":
			deleteAllProducts(inventory)
		elif MMC == "5":
			restockProduct(inventory)
		elif MMC == "6":
			consumeProduct(inventory)
		elif MMC == "0":
			print("Good Bye!")
			break
		else:
			print("Invalid Input")
			continue

def addProduct(add_inv):
	print("-----------------ADD PRODUCT-----------------")	
	productID = input("Enter product ID:	")
	if productID in add_inv:														# checks if the product already exists in the dictionary
		print("The product already exists.")
		return
	productName = input("Enter product name:	")
	productDescription = input("Enter product description:	")
	bool_holder = True																# block that repeats asking for input while not valid

	while bool_holder == True:
		productQuantity = input("Enter product quantity:	")
		bool_holder = NumCheck(productQuantity)										# calls the function that checks if the characters are all numerical
	productQuantity = int(productQuantity)											# if all was numerical, the function returns False and the input loop breaks and gets typecasted

	add_inv[productID] = [productName, productDescription, productQuantity]			# adds the input into the dictionary
	print("---------------------------------------------")

def NumCheck(productQuantity):														# function that checks if a string is only composed of numbers
	num = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}						# dictionary of numerical characters
	for i in range(0, len(productQuantity)):
		charac = str(productQuantity[i])
		if charac in num:
			continue
		else:																		# if the string is not a key of the num dictionary, the function returns True and the input loop continues
			print("Invalid Input")
			return True
	return False																	# if all was numerical, the function returns False and the input loop breaks and gets typecasted

def viewProducts(view_inv):															# function to view all products
	print("----------------VIEW PRODUCTS---------------")
	for k, v in view_inv.items():
		print()
		print(k)
		print("Name:	",v[0])														# access the elements of the list (which is the value in the dictionary)
		print("Description:	", v[1])
		print("Quantity: ", v[2])
	print()
	print("---------------------------------------------")

def deleteProduct(del_inv):															# function to delete individual products
	key = input("Enter product ID:	")
	print("----------------DELETE PRODUCT---------------")	

	if key in del_inv:																# checks if the key is in the dictionary
		deleted = del_inv.pop(key)
		print("Deleted", deleted[0], "with", deleted[2], "stock/s from the inventory.")
	else:
		print("This product does not exist.")

	print("---------------------------------------------")
	
def deleteAllProducts(clear_inv):													# function to delete all products
	clear_inv.clear()
	print("All products deleted.")
	print("---------------------------------------------")

def restockProduct(restock_inv):													# function to restock products
	key = input("Enter product ID:	")
	bool_holder = True
	print("----------------RESTOCK PRODUCT--------------")
	if key in restock_inv:															# checks if the key is in the dictionary
		while bool_holder == True:													# block to check/validate input
			amount_restock = input("Enter amount to restock: ")
			bool_holder = NumCheck(amount_restock)
		amount_restock = int(amount_restock)

		restock_inv[key][2] = restock_inv[key][2] + amount_restock					# adds (amount_restock) amounts to the (restock_inv[key][2]) or (amount)

	else:
		print("The product ID doesn't have any match.")
	print("---------------------------------------------")

def consumeProduct(consume_inv):													# function to consume individual products
	key = input("Enter product ID:	")
	print("----------------CONSUME PRODUCT--------------")
	if key in consume_inv:
		bool_holder = True															# input validation block
		while bool_holder == True:
			amount_consume = input("Enter amount to consume: ")
			bool_holder = NumCheck(amount_consume)
		amount_consume = int(amount_consume)

		if amount_consume > consume_inv[key][2]:									# checks if the amount to be consumed is more than or less than the amounts of stock
			print("Insufficient stock.")
		else:
			consume_inv[key][2] = consume_inv[key][2] - amount_consume
			print("Consumed", amount_consume, "of", consume_inv[key][0])
	else:
		print("The product ID doesn't have any match.")
	print("---------------------------------------------")

mainMenu()