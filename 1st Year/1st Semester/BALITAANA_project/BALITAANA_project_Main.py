# Axel O. Balitaan
# CMSC 12 T15L
# Maze Runner Game with collectible points, timer, power-ups/power-downs (extra feature), map configuration file, score saving, and leaderboard loading.

import BALITAANA_project_InGame                                                                                     # Imports the InGame Modules
import BALITAANA_project_SaveLoad                                                                                   # Imports the Saving and Loading modules

def MainMenu():                                                                                                     # MAIN MENU BLOCK

    while True:
        print('--------------- MAIN MENU --------------')
        
        print('[1] Play Maze Runner Game')
        print('[2] Show Leaderboards')
        print('[3] About')
        print('[0] Exit' + '\n')

        MMC = input('Enter Choice: ')
        print('----------------------------------------')

        if MMC == '1':
            Playable, Time_Alotted, Difficulty = Mode_Select()                                                      # Opens the Mode Selection/Difficulty levels and obtain total playable blocks in a row
            
            if Playable == 0:                                                                                       # If player selected Back [0] in Mode Selection, the program returns to Main Menu Selection
                continue
            else:
                print('----------------------------------------' + '\n')
                Map_List = Load_Map(Playable)                                                                       # Loads the corresponding Map based on difficulty level
                Result, Elapsed_Time, Points = BALITAANA_project_InGame.StartGame(Playable, Map_List, Time_Alotted) # Starts the Game
                
                if Result == 'Victory':                                                                             # If player finished the game within time limit, calls out the saving record function
                    You_Win(Elapsed_Time, Points, Difficulty)

        elif MMC == '2':
            BALITAANA_project_SaveLoad.RecordView()
        elif MMC == '3':
            print('\n' + (' ' * 12) + 'Maze Runner Game' + '\n')
            print((' ' * 7) + 'Project by: Axel Balitaan')
            print((' ' * 9) + 'Section: CMSC 12 T15L' + '\n')
            print('----------------------------------------')
        elif MMC == '0':
            print('Good Bye!')
            break
        else:
            print('Invalid Input')

def Mode_Select():                                                                                                  # MODE SELECTION BLOCK
    while True:
        print('-------------- MODE SELECT -------------')
        print('[1] Easy')
        print('[2] Average')
        print('[3] Difficult')
        print('[0] Back' + '\n')

        Game_Mode = input('Enter Choice: ')                                                                         # Asks the player for the game mode
        print('----------------------------------------')

        if Game_Mode not in ['0', '1', '2', '3']:                                                                   # Checks if the user inputted a valid choice          
            print('Invalid Input')
            continue                                                                                                # If not, the Game Mode Selection loops
        elif Game_Mode == '0':                                                                                      # If valid, assigns corresponding playable blocks in a row, and time alotted for the difficulty
            Playable = 0
            Time_Alotted = 0
            Difficulty = 'None'
        elif Game_Mode == '1':
            Playable = 15
            Time_Alotted = 120
            Difficulty = 'EASY'
        elif Game_Mode == '2':
            Playable = 30
            Time_Alotted = 180
            Difficulty = 'AVERAGE'
        elif Game_Mode == '3':
            Playable = 60
            Time_Alotted = 300
            Difficulty = 'DIFFICULT'

        return Playable, Time_Alotted, Difficulty                                                                   # Returns how many blocks in each row, Difficulty, and corresponding time alotted to finish

def Load_Map(Playable):                                                                                             # MAP LOADING BLOCK

    Map_List = []                                                                                                   # Dummy list for the whole map
    loadhandle = open('BALITAANA_project_MapConfig.txt', 'r')                                                       # Opens file of Map Configuration

    for line in loadhandle:                                                                                         # Loads each line in the txt file
        singleline_list = (line[:-1])                                                                               # Removes the '/n'
        blocks = [block for block in singleline_list]                                                               # Converts the string (per line) into a list

        if (len(blocks) == Playable):                                                                               # Compares if the length of the created list is same with the assigned playable blocks in row
            Map_List.append(blocks)                                                                                 # If so, it is included in the corresponding Map (for game mode)

    return Map_List                                                                                                 # Returns the Final Map for the said Game Mode

def You_Win(Elapsed_Time, Points, Difficulty):

    print('----------------------------------------')
    print('            CONGRATULATIONS!            ' + '\n')
    print('Game Mode: ' + Difficulty)
    print('Points: ' + str(Points))
    print('Time Taken: ' + str(Elapsed_Time // 60) + ' minutes, ' + str(Elapsed_Time % 60) + ' seconds')
    print('----------------------------------------')

    while True:

        Save_Record = input('[y/n] Do you want to save this record? ')
        print('----------------------------------------')
        
        if Save_Record == 'y':

            while True:
                Player_Name = input('Enter your name: ')
                print('----------------------------------------')
                if len(Player_Name) == 0:
                    print('Please input a name.')
                elif len(Player_Name) >= 15:
                    print('Name too long.')
                else:
                    print('Record Saved')
                    break
                print('----------------------------------------')
   
            print('----------------------------------------')
            BALITAANA_project_SaveLoad.RecordSave(Player_Name, Elapsed_Time, Points, Difficulty)

            break
        elif Save_Record == 'n':
            print('Record not saved.')
            print('----------------------------------------')
            break
        else:
            print('Invalid Input!')
            print('----------------------------------------')
            continue

        print('----------------------------------------')

MainMenu()                                                                                                          # Starts the program