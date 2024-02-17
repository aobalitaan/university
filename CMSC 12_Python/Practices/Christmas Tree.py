n = int(input("Enter number of stacks:"))
maxupperwidth = 1 + 2*(n-1)
maxheight_stack = 3 + (n-1)
maxwidth = maxupperwidth + 2*(maxheight_stack-1)
no_of_characters_merrychristmas = 15

if maxwidth < no_of_characters_merrychristmas:
    more_adder = int((no_of_characters_merrychristmas - maxwidth)/2)
else:
    more_adder = 0
final_maxwidth = maxwidth + more_adder
greetings_space = int((final_maxwidth - no_of_characters_merrychristmas) / 2)

for d in range(0,n):
    height_stack = 3 + d
    space = height_stack - 1
    upperwidth_stack = 1 + 2*d
    lowerwidth_stack = upperwidth_stack + 2*(height_stack - 1)
    addedspace = int((maxwidth - lowerwidth_stack)/2)
    total_space = space + addedspace + more_adder
    for a in range(0, height_stack):
        print(total_space*" ", end="")
        print(upperwidth_stack*"X", end="")
        print()
        upperwidth_stack = upperwidth_stack + 2
        total_space = total_space - 1
print(greetings_space*" ", end="")
print("Merry Christmas!")