def RecordLoad():                                                                                   # Function for converting text file into dictionary
    Records_Dictionary = {}
    LoadHandle = open('BALITAANA_project_Leaderboards.txt', 'r')                                    # Opens the file
    pseudolist = []

    content = LoadHandle.readlines()                                                                # Convert each line in the file to a list
    if len(content) == 0:                                                                           # If the file is empty,
        RecordClear()                                                                               # Clears it and watermarks it with no No Record
        return Records_Dictionary                                                                   # Returns an empty dictionary
    elif content[0] == 'No Record\n':                                                               # If the file is already watermarked with No Record
        return Records_Dictionary                                                                   # Returns an empty dictionary

    Difficulty = 'EASY'                                                                             # Default key (chronological ordering)

    for line in content:
        indiv_line = line[:-1]                                                                      # Removes the \n 

        if indiv_line == 'AVERAGE':                                                                 # If the line is a difficulty
            pseudolist = []                                                                         # Resets pseudolist
            Difficulty = 'AVERAGE'                                                                  # And changes key to a new difficulty
        elif indiv_line == 'DIFFICULT':
            pseudolist = []
            Difficulty = 'DIFFICULT'

        if indiv_line not in ['EASY', 'AVERAGE', 'DIFFICULT', '', 'nothing follows']:               # Filters if the line is an actual record
            
            if indiv_line [0:4] != 'RANK':
            
                PlayerName, PlayerScore, Elapsed_Time = Value_Getter(indiv_line)                    # Calls the function that gets the values from the string (line)
                
                player_record = [PlayerName, PlayerScore, Elapsed_Time]                             # Individual player record

                pseudolist.append(player_record)                                                    # Appends individual player record
                Records_Dictionary[Difficulty] = pseudolist                                         # Appends the difficulty and records to the dictionary

    LoadHandle.close()                                                                              # Closes file
    
    return Records_Dictionary                                                                       # Returns the Dictionary of Records

def Value_Getter(filtered_indiv_line):                                                              # Function that gets the values from the string/line

    PlayerName = Space_Remover(filtered_indiv_line[15:30])                                          # Gets the Player Name
    PlayerScore = int(Space_Remover(filtered_indiv_line[30:45]))                                    # Gets the Player Score

    Time_Minute, Time_Seconds = Time_Getter(filtered_indiv_line[45:60])                             # Gets the Player Time
    Elapsed_Time = (Time_Minute * 60) + (Time_Seconds)                                              # Convert time format (min:sec) to elapsed time format (in seconds)

    return PlayerName, PlayerScore, Elapsed_Time                                                    # returns obtained values

def Time_Getter(string):                                                                            # Gets the time from the string
    count = 0
    Time_Minute = ''
    Time_Seconds = ''

    while string[count:(count + 6)] != ' min, ':                                                    # Filters the integer part/number in string (for min)

        Time_Minute = Time_Minute + string[count]
        count += 1
    
    count += 6

    while string[count:(count + 4)] != ' sec':                                                      # Filters the integer part/number in string (for sec)

        Time_Seconds = Time_Seconds + string[count]
        count += 1

    return int(Time_Minute), int(Time_Seconds)                                                      # Returns typecasted minute and second values

def Space_Remover(string):                                                                          # Function for removing excess space at the rightmost part of a string ("string    " to "string")
    count = 0
    FinalString = ''
    
    while (string[count] != ' ' and string[count + 1] != ' ') or (count != (len(string) - 1)):      # Checks consecutive elements if spaces

        FinalString = FinalString + string[count]
        count += 1
    FinalString = FinalString + string[count]

    return FinalString                                                                              # Returns the new string with no excess spaces

def RecordView():                                                                                   # Function for viewing the leaderboards/selecting which to view
    while True:
        print('---------------- RECORDS ---------------')
        print('[1] Easy')
        print('[2] Average')
        print('[3] Difficult')
        print('[4] Clear All Records')
        print('[0] Back to Main Menu' + '\n')

        RVC = input('Enter choice: ')
        print('----------------------------------------')

        if RVC == '1':
            Difficulty = 'EASY'
        elif RVC == '2':
            Difficulty = 'AVERAGE'
        elif RVC == '3':
            Difficulty = 'DIFFICULT'
        elif RVC == '4':
            while True:
                confirm = input('[y/n] Reset All Leaderboards? ')
                print('----------------------------------------')
                if confirm == 'y':
                    RecordClear()
                    print('Leaderboards has been reset.')
                    print('----------------------------------------')
                    return
                elif confirm == 'n':
                    return
                else:
                    print('Invalid Input')
                    print('----------------------------------------')
                    continue
        elif RVC == '0':
            return
        else:
            print('Invalid Input')
            continue

        RecordScreen(Difficulty)

def RecordScreen(Difficulty):                                                                       # Actual Leaderboards Screen                                                                          
    Records_Dictionary = RecordLoad()                                                               # Gets the dictionary
    count = 1                                                                                       # placeholder for ranking iteration later

    if Difficulty not in Records_Dictionary:
        print('No Records For This Mode Yet')
        print('----------------------------------------')
        return
    else:
        Sub_Record = Records_Dictionary[Difficulty]                                                 # Get records per difficulty

        print(('-' * 23) + ' LEADERBOARDS ' + ('-' * 23))
        print((' ' * (int((60 - len(Difficulty)) / 2))) + Difficulty + "\n")
        print('RANK           PLAYER         POINTS         TIME TAKEN     ')

        for records in Sub_Record:
            Rank = str(count) + (' ' * (15-len(str(count))))
            count += 1                                                                              # For ranking iteration

            Player_name = str(records[0]) + (' ' * (15-len(str(records[0]))))
            Player_score = str(records[1]) + (' ' * (15-len(str(records[1]))))
            Player_Time = str(records[2] // 60) + ' min, ' + str(records[2] % 60) + ' sec'

            print(Rank + Player_name + Player_score + Player_Time)

        print('\n'+('-' * 60))

def RecordSave(Player_Name, Elapsed_Time, Points, Difficulty):                                      # Function for saving the records
    Records_Dictionary = RecordLoad()                                                               # Loads current dictionary and modifies it
    time_list = []
    point_list = []

    time_sorted_list = []
    Final_Sorted_List = []

    if Difficulty in Records_Dictionary:                                                            # If there already exist records in the difficulty
        Sub_Leaderboard = Records_Dictionary[Difficulty]                                            # Gets the current record list
    else:
        Sub_Leaderboard = []                                                                        # else makes an empty record list

    Sub_Leaderboard.append([Player_Name, Points, Elapsed_Time])                                     # Appends current records to the record list

    for records in Sub_Leaderboard:
        point_list.append(records[1])                                                               # Appends the points to a list, for sorting
        time_list.append(records[2])                                                                # Appends the elapsed times to a list, for sorting
    point_list.sort()                                                                               # Sort points list (from lowest to highest)
    point_list.reverse()                                                                            # Reverses points list (from highest to lowes)
    time_list.sort()                                                                                # Sort elapsed time list (from lowest to highest)
    
    for time in time_list:                                                                          # Sorts player records based on elapsed time   
        count = 0
        for records in Sub_Leaderboard:                                                             # Checks if each elapsed time in sorted elapse time list is matched with the times of each player
            if records[2] == time:
                time_sorted_list.append(records)                                                    # Appends to a new record list sorted based from time 
                Sub_Leaderboard.pop(count)                                                          # Pops current record to avoid duplication
            count += 1                                                                              # Iterates index
        
    for point in point_list:                                                                        # Sorts player records based on points 
        count = 0
        for records in time_sorted_list:                                                            # Checks if each points in sorted point list is matched with the points of each player
            if records[1] == point:
                Final_Sorted_List.append(records)                                                   # Appends to a new record list sorted based from points
                time_sorted_list.pop(count)                                                         # Pops current record to avoid duplication
            count += 1                                                                              # Iterates index

    Records_Dictionary[Difficulty] = Final_Sorted_List                                              # Appends the sorted record to the dictionary with corresponding difficulty key
    RecordWriting(Records_Dictionary)                                                               # Calls the function that writes the dictionary to the text file

def RecordWriting(Records_Dictionary):                                                              # Function that writes dictionary to the text file
    SaveHandle = open('BALITAANA_project_Leaderboards.txt', 'w')                                    # Opens the file
    
    for key, value in Records_Dictionary.items():

        SaveHandle.write(key + '\n')
        SaveHandle.write('\n')
        SaveHandle.write('RANK           PLAYER         POINTS         TIME TAKEN     ' + '\n')

        count = 1

        for records in value:
            Rank = str(count) + (' ' * (15 - len(str(count))))                                      # len is used to maintain consistent spacing/length per record
            count += 1

            Player_Name = str(records[0]) + (' ' * (15 - len(str(records[0]))))

            Player_Score = str(records[1]) + (' ' * (15 - len(str(records[1]))))

            Time_String = str(records[2] // 60) + ' min, ' + str(records[2] % 60) + ' sec'
            Time_String = Time_String + (' ' * (15 - len(Time_String)))

            Final_String = Rank + Player_Name + Player_Score + Time_String

            SaveHandle.write(Final_String + '\n')                                                   # Actual writing
        
        SaveHandle.write('\n' * 3)
 
    SaveHandle.write('\n' + 'nothing follows' + '\n')

    SaveHandle.close()

def RecordClear():                                                                                  # Clears and Watermarks the file
    openHandle = open('BALITAANA_project_Leaderboards.txt', 'w')

    openHandle.write('No Record' + '\n')

    openHandle.close()