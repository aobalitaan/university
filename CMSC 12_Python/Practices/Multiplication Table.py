x = int(input("Enter size: "))
highnum = x ^ 2                             # highest number in the table
highnum_dig = 0                             # holder
while highnum > 0:                          # block for counting the number of digits of highest number
    highnum = highnum // 10
    highnum_dig = highnum_dig + 1
highspace = highnum_dig + 1                 # +1 para di magzero spacing (walang space) mamaya

for h in range (1, x + 1):
    for i in range (1, x + 1):
        if h*i == 1:
            print(" ", end="")
        else:
            print(h*i, end="")
        hi = h*i                            # pangstore lang nung value
        hi_dig = 0                          # holder
        while hi > 0:                       # block for counting the number of digits of the value (h*i)
            hi = hi // 10
            hi_dig = hi_dig + 1
        space = highspace - hi_dig          # bilang nung spaces na ipiprint (kaya nag +1 kanina para di magzero dito)
        for i in range(0, space + 1):
            print(" ", end="")
    print()                                 # print pang break/next line