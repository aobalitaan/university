# Axel O. Balitaan
# CMSC 12 T15L
# A program that asks the user for text input and filters those that have spaces. It encrypts these input/s using caesar cipher then outputs its compressed form.

def MainMenu():
	print()
	print("==========================")
	print()
	print("[1] Enter List of Text/s")
	print("[2] Encrypt")
	print("[3] View Encrypted")
	print("[4] Exit")

	MMC = input("Enter Choice: ")
	return MMC

def EnterList():
	Number_Of_Texts = int(input("How many text/s to add? "))
	Combined_TextSub = ""
	List_Of_Text_Length = []

	for i in range(0, Number_Of_Texts):
		bool_holder = True
		while bool_holder == True:
			Text_Sub = input("Enter Text [" + str(i + 1) + "] ")
			Text_Sub_Length = len(Text_Sub)												# counts the length of inputted texts
			bool_holder = SpaceChecker(Text_Sub, Text_Sub_Length)						# calls the function that checks if the input has space/s
		Combined_TextSub = Combined_TextSub + Text_Sub 									# stores the inputted texts inside a single string
		List_Of_Text_Length.append(Text_Sub_Length)										# stores the length of inputted texts in a list

	return Combined_TextSub, List_Of_Text_Length				

def SpaceChecker(Text_Sub, Text_Sub_Length):
	for i in range(0, Text_Sub_Length):
		Letter_From_Text = Text_Sub[i]													# checks if the string has space
		if Letter_From_Text == " ":
			print("Uh Oh! Your input has space/s.")
			return True																	# if so, the bool_holder = True to continue the loop of input
	return False																		# if not, the bool_holder = False to continue the for i in range loop

def CaesarCipher():
	Number_Of_Shifts = int(input("Enter no. of shifts: "))
	Number_Of_Shifts = Number_Of_Shifts % 26											# number of shifts are modulo by 26 to simplify / prevent exceeding the amount of alphabet letters
	Lowercased_CombinedTextSub = Combined_TextSub.lower()								# converts all characters inside a text to lowercased
	Shifted_TextSub = ""

	for i in range(0, len(Lowercased_CombinedTextSub)):
		letter = Lowercased_CombinedTextSub[i]											# identifies the letter pertained in the string
		Number_From_Alphabet = 0
		for j in range(0, len(Alphabet)):
			if letter == Alphabet[j]:													# compares the letter in string to its alphabet number equivalent
				Number_From_Alphabet = j
		shiftednumber = (Number_From_Alphabet + Number_Of_Shifts) % 26					# shifts the letter's alphabet number equivalent (modulo 26 to prevent exceeding the amount of alphabet letters)
		shiftedletter = Alphabet[shiftednumber]											# gets the alphabet equivalent of the shifted number
		Shifted_TextSub = Shifted_TextSub + shiftedletter								# stores the shifted/ciphered character/text

	return Shifted_TextSub

def Splitter():
	start = 0																			# holder since the first instance of loop will use 0 as a start [0, x]
	end = 0
	print()
	print("View All Encrypted")
	for i in range(0, len(List_Of_Text_Length)):										# identifies the number of splitted/inputted text using the number of elements inside the list of text length
		Text_Length = int(List_Of_Text_Length[i])										# gets the length of each input
		end = start + Text_Length 														# gets the value of the end in slicing

		Splitted_Text = Combined_TextSub[start:end]										# splice the string/ unencrypted
		Splitted_EncryptedText = Ciphered_Text[start:end]								# splice the string / encrypted
		start = end 																	# if the current slicing is [a, b] then the next should start at b [b, c]

		compressed_text = Compressor(Splitted_EncryptedText)							# calls the function to compress the splitted encrypted text
		print("[" + str(i + 1) + "]", Splitted_Text, "======>", compressed_text)		# final printing


def Compressor(Splitted_EncryptedText):
	index = 1																			# function starts at index = 1 so that it will start at the second element of the string
	number_of_same_letter = 1															# this is needed because the algorithm compares the current letter to the one before it
	compressed_letter = ""
	compressed_text = ""
	current_letter = Splitted_EncryptedText[0]

	while index < len(Splitted_EncryptedText):									
		current_letter = Splitted_EncryptedText[index]
		previous_letter = Splitted_EncryptedText[index - 1]
		if current_letter == previous_letter:
			number_of_same_letter = number_of_same_letter + 1
		else:
			if number_of_same_letter != 1:
				compressed_letter = previous_letter + str(number_of_same_letter)
			else:
				compressed_letter = previous_letter
			compressed_text = compressed_text + compressed_letter
			number_of_same_letter = 1
		index = index + 1

	if number_of_same_letter != 1:														# additional function because the final character of the string will not continue as it has no next character that will use it for comparison
		compressed_letter = current_letter + str(number_of_same_letter)
	else:
		compressed_letter = current_letter
	compressed_text = compressed_text + compressed_letter

	return compressed_text
	
#Main Block

MMC = 0
Alphabet = "abcdefghijklmnopqrstuvwxyz"
MMC_Trigger = 0
Cipher_Trigger = 0

while MMC != "4":
	MMC = MainMenu()
	if MMC == "1":
		Combined_TextSub, List_Of_Text_Length = EnterList()
		MMC_Trigger = 1
	if MMC == "2":
		if MMC_Trigger == 0:
			print("Enter text/s first!")
		else:
			Ciphered_Text = CaesarCipher()
			Cipher_Trigger = 1
	if MMC == "3":
		if Cipher_Trigger == 1:
			Splitter()
			MMC_Trigger = 0
			Cipher_Trigger = 0
		else:
			print("No Ciphers yet!")
	if MMC == "4":
		print("Goodbye!")