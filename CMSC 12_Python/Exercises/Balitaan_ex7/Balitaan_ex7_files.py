# Axel O. Balitaan
# CMSC 12 T15L
# import function for loading and saving simple inventory system

#block for saving inventory
def saveInventory(save_inventory):
	readHandle = open("inventory.dat", "w")

	for productID, value in save_inventory.items():																	#gets the key from dictionary
		productName = value[0]																						#gets the corresponding values from dictionary
		productDescription = value[1]
		productQuantity = str(value[2])
		readHandle.write(productID + "," + productName + "," + productDescription + "," + productQuantity + "\n")	#writes the collected data to the file
	print("inventory.dat succesfully saved!")

	readHandle.close()


#block for loading inventory
def loadInventory(load_inventory):
	loadHandle = open("inventory.dat", "r")

	dictionary = {}

	longlist = []

	for line in loadHandle:										#creates a long list from the file
		substring = line[:-1]
		for i in range(0, 4):
			longlist.append(substring.split(",")[i])			

	sublist = []

	for j in range(0, len(longlist)):							#puts the collected data from the list to a dictionary and returns it to the program
		if j % 4 == 0:
			key = longlist[j]
		else:
			sublist.append(longlist[j])
			if j % 4 == 3:
				dictionary[key] = [sublist[0], sublist[1], int(sublist[2])]
				sublist.clear()

	print("inventory.dat succesfully loaded!")
	return dictionary