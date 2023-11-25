import time                                                                                                         # Imports time module

def StartGame(Playable, Map_List, Time_Alotted):                                                                    # Function for initializing and operating the game

    startrow, startcolumn = P_Finder(Map_List)                                                                      # Finds the starting coordinates
    Time_to_Finish = int(time.time()) + Time_Alotted                                                                # Sets the time the stopwatch stops

    Points = 0                                                                                                      # Initializes pointing system
    Invert_Moves = 0                                                                                                # Initializes inverted moves
    Multiple_Possible_Moves = True                                                                                  # Initializes how many moves are possible
    recentlygotinvert = False                                                                                       # Initializes player got invert block in last move

    while Map_List[startrow][startcolumn] != '✓':                                                                  # Game continues while finish line is not reached

        if Multiple_Possible_Moves == True:                                                                         # Only calls the function when there is already multiple possible moves                                                                      
            Elapsed_Time = IngamePrinting(Playable, Map_List, Invert_Moves, Points,                                 # Calls the Function that prints the game and returns elapsed time
                                            Time_Alotted, Time_to_Finish)

            if Elapsed_Time >= Time_Alotted:                                                                        # Printing and ends the game when player ran out of time
                print('---------- YOU RAN OUT OF TIME ---------')
                return 'Defeat', 'Defeat', 'Defeat'

            Move_Input = input('Enter move: ')                                                                      # Asks the user for move input
            inputreversed = 0                                                                                       # Resets the variable which indicates that the input is reversed (and holds it for the while multiple movement condition)
            print('\n' * 100)

        if Invert_Moves > 0:                                                                                        # If the remaining inverted moves is greater than zero, calls the inverted moves function that converts the
            Move_Input, inputreversed = InvertedMoves(Move_Input, inputreversed)
        
        IsMove_Valid, nextrow, nextcolumn = Valid_Move_Checker(startrow, startcolumn,                               # Checks if the move input is a valid move
                                                    Move_Input, Map_List, Playable)

        if IsMove_Valid == True:                                                                                    # If so, continues with the modification of maplist
            Map_List, startrow, startcolumn, Points, Invert_Moves, recentlygotinvert = ValidMove(Map_List,          # Function for valid moves
                startrow, startcolumn, nextrow, nextcolumn, Points, Invert_Moves, Multiple_Possible_Moves)

        Multiple_Possible_Moves = SurroundingsCheck(Map_List, startrow, startcolumn, Playable, recentlygotinvert)   # Checks if there are multiple possible moves base on the surrounding blocks
    
    Elapsed_Time = IngamePrinting(Playable, Map_List, Invert_Moves, Points, Time_Alotted, Time_to_Finish)           # Gets the elapsed time and prints one more time when the player wins

    return 'Victory', Elapsed_Time, Points                                                                          # If got out of the loop before time, returns victory, elapsed time and points

def SurroundingsCheck(Map_List, startrow, startcolumn, Playable, recentlygotinvert):                                # Function for checking if there are multiple possible moves
    possiblemovescolumn = 0                                                                 
    possiblemovesrow = 0

    if startcolumn < (Playable - 1):                                                                                # If statements to avoid getting out of range
        if Map_List[startrow][startcolumn + 1] != 'X':                                                              # Checks if the right block is not a wall
            possiblemovescolumn += 1
    if startcolumn > 0:                                                                                             # If statements to avoid getting out of range
        if Map_List[startrow][startcolumn - 1] != 'X':                                                              # Checks if the left block is not a wall                                             
            possiblemovescolumn += 1

    if startrow < 9:                                                                                                # If statements to avoid getting out of range
        if Map_List[startrow + 1][startcolumn] != 'X':                                                              # Checks if the lower block is not a wall
            possiblemovesrow += 1
    if startrow > 0:                                                                                                # If statements to avoid getting out of range
        if Map_List[startrow - 1][startcolumn] != 'X':                                                              # Checks if the upper block is not a wall
            possiblemovesrow += 1

    if (possiblemovesrow == 1 and possiblemovescolumn == 0) or (possiblemovescolumn == 1 and                        # Indicates that the player is in the corner/end in which the input reaches
        possiblemovesrow == 0) or recentlygotinvert == True:
        return True                                                                                                
    elif possiblemovesrow < 1 or possiblemovescolumn < 1:                                                           # Indicates that there is no other possible moves other than going back or going with the same input
        return False
    else:                                                                                                           # Catches other conditions (i.e. the player is in a crossing where they can select any move, player passes an opening where they can move)
        return True

def P_Finder(Map_List):                                                                                             # Function to find where the starting coordinates are
    for i in range(0, len(Map_List)):
        for j in range(0, len(Map_List[i])):
            if Map_List[i][j] == 'P':
                return i, j

def Timer(Time_to_Finish):                                                                                          # Function for timer
    Time_Left = int(Time_to_Finish - time.time())                                                                   # Subtracts the current time from the time the timer finishes

    if Time_Left > 0:                                                                                               # If there is still time left proceeds with printing
        print('Time left: ' + str(Time_Left // 60) + ':' + ('0' * (2 - len(str(Time_Left % 60)))) + str(Time_Left % 60))

    return Time_Left                                                                                                # Returns how much time is remaining

def IngamePrinting(Playable, Map_List, Invert_Moves, Points, Time_Alotted, Time_to_Finish):                         # Function for printing necessary assets

    Map_Printing(Playable, Map_List, Invert_Moves)                                                                  # Calls the function that prints the map
    Time_Left = Timer(Time_to_Finish)                                                                               # Calls the function that prints the timer
    print('Points:', Points)                                                                                        # Prints player points

    if Invert_Moves > 0:                                                                                            # Prints when the user still has inverted moves remaining
        print('YOUR MOVES ARE INVERTED FOR THE NEXT ' + str(Invert_Moves) + ' MOVE/S.')

    Elapsed_Time = Time_Alotted - Time_Left                                                                         # Computes for elapsed time

    return Elapsed_Time

def Map_Printing(Playable, Map_List, Invert_Moves):                                                                 # Function for printing the map

    print('==' * (Playable + 1))

    for rows in Map_List:
        print('|', end='')
        for block in rows:
            if block == 'X':
                if Invert_Moves > 0:
                    print('O', '', end = '')
                else:
                    print('X', '', end = '')
            elif block == 'I':
                print('I', '', end = '')
            elif block == 'P':
                print('P', '', end = '')
            elif block == 'W':
                print('W', '', end = '')
            elif block == '+':
                print('+', '', end = '')
            else:
                print(block, '', end='')
        print('|')

    print('==' * (Playable + 1))

def Valid_Move_Checker(startrow, startcolumn, Move_Input, Map_List, Playable):                                      # Function for checking if the player inputted a valid move

    nextrow = startrow
    nextcolumn = startcolumn

    if Move_Input == 'w':                                                                                           # Converts string input to corresponding list within a list (map coordinates) equivalent
        nextrow = startrow - 1
    elif Move_Input == 'a':
        nextcolumn = startcolumn - 1
    elif Move_Input == 's':
        nextrow = startrow + 1
    elif Move_Input == 'd':
        nextcolumn = startcolumn + 1
    else:
        print('Invalid Input!')

    if (0 <= nextrow < 10) and (0 <= nextcolumn < Playable):                                                        # If statement to avoid getting out of range

        if Map_List[nextrow][nextcolumn] != 'X' and Map_List[nextrow][nextcolumn] != 'P':                           # Checks if the future coordinate is not a wall, second statement is for when the player did not input a valid move (i.e spaces/invalid input)
            return True, nextrow, nextcolumn                                                                        # Early returns indicating move is valid and passess the future coordinates
        elif Map_List[nextrow][nextcolumn] == 'X':                                                                  # If future coordinate is wall
            print('You hit a wall!')
    else:                                                                                                           # If got out of range
        print('Going Out of Bounds!')

    return False, startrow, startcolumn                                                                             # Returns indicating move is not valid and the future coordinates is still the present coordinates                           

def ValidMove(Map_List, startrow, startcolumn, nextrow, nextcolumn, Points, Invert_Moves, Multiple_Possible_Moves): # Function when the move input is valid

    recentlygotinvert = False                                                                                       # Initializes indicating that the player did not got invert from last move (if multiple possible moves was false)

    if Invert_Moves > 0 and Multiple_Possible_Moves == True:                                                        # If the player still has inverted moves remaining and there are multiple possible moves possible
        Invert_Moves -= 1                                                                                           # Subtracts remaining inverted moves

    Map_List[startrow][startcolumn] = ' '                                                                           # Changes current coordinates to empty

    if Map_List[nextrow][nextcolumn] == 'W':                                                                        # If the future coordinate is the finish
        Map_List[nextrow][nextcolumn] = '✓'                                                                        # Changes the future coordinate to check indicating the game is finish/player won
    else:
        if Map_List[nextrow][nextcolumn] == '+':                                                                    # If the future coordinate is a plus symbol                    
            Points += 1                                                                                             # Adds 1 to total points
        elif Map_List[nextrow][nextcolumn] == 'I':                                                                  # If the future coordinate is an invert block,
            recentlygotinvert = True                                                                                # Initializes that the player recently got invert
            Invert_Moves += 2                                                                                       # and adds remaining invert moves

        Map_List[nextrow][nextcolumn] = 'P'                                                                         # Change Future coordinate to player     
        
    startrow = nextrow                                                                                              # Future coordinates become current coordinates
    startcolumn = nextcolumn

    return Map_List, startrow, startcolumn, Points, Invert_Moves, recentlygotinvert

def InvertedMoves(Move_Input, inputreversed):
    inputreversed += 1                                                                                              # Adds the 1 to the inputreversed variable

    if inputreversed == 1:                                                                                          # If inputreverse == 1 means that the input is fresh and not from the continuous movement from the multiplepossiblemoves == False
        if Move_Input == 'w':                                                                                       # Converts to the inverted moves equivalent
            Move_Input = 's'
        elif Move_Input == 's':
            Move_Input = 'w'
        elif Move_Input == 'a':
            Move_Input = 'd'
        elif Move_Input == 'd':
            Move_Input = 'a'

    return Move_Input, inputreversed