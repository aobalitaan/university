#Axel Balitaan (CMSC12 T15L)
#Variables, Expressions, and Sequential Statements
#logbook collector with temperature converter (Celsius, Farenheit, Kelvin, and Rankine) and logbook summary


#input data
Location=input("Input Location: ")
Date=input("Input Date: ")
Time1=input("[1] Input Time: ")
Temp1=input("[1] Input Temperature in Celsius: ")
Time2=input("[2] Input Time: ")
Temp2=input("[2] Input Temperature in Celsius: ")
Time3=input("[3] Input Time: ")
Temp3=input("[3] Input Temperature in Celsius: ")

print("You have successfully input a log!")

#Typecasting
Temp1=float(Temp1)
Temp2=float(Temp2)
Temp3=float(Temp3)

#Conversion
AveCel=(Temp1+Temp2+Temp3)/3
Faren=AveCel*1.8+32
Kel=AveCel+273.15
Rank=AveCel*1.8+32+459.67

#Log Summary
print("=========Log Entry=========")
print("Location: ", Location)
print("Date: ", Date)
print("Time Taken:", Time1, Time2, Time3)
print("Average Temperature:")
print("Celsius: ", AveCel)
print("Farenheit: ", Faren)
print("Kelvin: ", Kel)
print("Rankine", Rank)
print("=========End of Log=========")