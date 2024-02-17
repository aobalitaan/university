// Axel O. Balitaan
// ST-5L
// Wordle Game through arrays, multidimensional arrays

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_TRIES 6																					// Editable game settings
#define WORDLE "APPLE"

																									// DEALLOCATE MEMORY
void set_arrayfree(char ***guess_array, char ***hint_array, int tries)
{
	for (int i = 0; i < tries; i++)
	{
		free(guess_array[i]);
		free(hint_array[i]);
	}
	free(guess_array);
	free(hint_array);
}

																									// DISPLAYS MESSAGE ACCORDING TO GAME RESULT
void message(int flag, int tries)
{
	char letter[][15] = {"zero", "one", "two", "three", "four", "five", 
		"six", "seven", "eight", "nine", "ten", "eleven", "twelve", 
		"thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"};

	switch(flag)
	{
		case 0:
			printf("Sorry, you didn't guess the WORDLE after %s attempts. Try again next time.\n", letter[tries]);
			break;
		case 1:
			printf("WOW! Hole in one, you got the WORDLE in just one shot!\n");
			break;
		default:
			if (flag == tries)
			{
				printf("Whew! That was tough, you got the WORDLE in your last guess!\n");
			}
			else
			{
			printf("Great! You got the WORDLE after %i attempts.\n", flag);
			}
			break;
	}
}

																									// PRINTING OF 2D ARRAY
void multi_print(char **array, int tries)
{
	for (int i = 0; i < tries; i++)
	{
		for (int j = 0; j < strlen (array[0]); j++)
		{
			printf("%c ", array[i][j]);
		}
		printf("\n");
	}
}

																									// DISPLAYS GUESSES AND HINTS
void output(char **guess_array, char **hint_array, int tries)
{
	printf("GUESSES:\n");
	multi_print(guess_array, tries);
	printf("\n");

	printf("HINTS:\n");
	multi_print(hint_array, tries);
	printf("\n");
}

																									// CHECKS THE USER'S GUESS AND THE WORDLE, EDITS THE CORRESPONDING HINT LINE
void check(char *guess, char *wordle, char *hint_array, int wordle_size)
{

	for (int i = 0; i < wordle_size; i++)															// Iterates through the guess
	{
		if (guess[i] == wordle[i])																	// Finds green (correct placements)
		{
			hint_array[i] = guess[i];
		}
		else
		{
			for (int j = 0; j < wordle_size; j++)													// Finds yellow (correct letters)
			{																						// Iterates through wordle
				if (guess[i] == wordle[j])									
				{
					hint_array[i] = '?';
				} 
			}
		}
	}
}

																									// CONVERTS TO UPPERCASE
void capitalize(char *guess)
{
	for (int i = 0; i < strlen(guess); i++)
	{
		guess[i] = toupper(guess[i]);
	}
}

																									// GETTING THE GUESS (INPUT) OF USER
void guess_input(char *guess, int wordle_size)
{
	char letter[][15] = {"zero", "one", "two", "three", "four", "five", 
		"six", "seven", "eight", "nine", "ten", "eleven", "twelve", 
		"thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"};
	
	while (1)																						// Loops while string length is incorrect
	{
		printf("\nEnter Guess: ");
		scanf("%s", guess);

		if (strlen(guess) != wordle_size)
		{
			printf("Error! Must enter a %s-letter word.\n", letter[wordle_size]);
		}
		else
		{
			capitalize(guess);																		// Calls the function that capitalizes the guess
			break;
		}
	}
}

																									// INITIALIZED THE 2D ARRAYS
void multi_setup(char ***guess_array, char ***hint_array, int tries, int wordle_size)
{
	(*guess_array) = (char**) malloc(sizeof(char*) * tries);										// Initializes the 2d Array from the playWordle function
	(*hint_array) = (char**) malloc(sizeof(char*) * tries);											// It uses pointers to pass by reference

	for (int i = 0; i < tries; i++)
	{
		(*guess_array)[i] = (char*) malloc(sizeof(char) * wordle_size);
		(*hint_array)[i] = (char*) malloc(sizeof(char) * wordle_size);
	}

	for (int i = 0; i < tries; i++)																	//Initializes the content to array of strings of blanks
	{
		for (int j = 0; j < wordle_size; j++)
		{
			(*guess_array)[i][j] = '_';
			(*hint_array)[i][j] = '_';
		}
		(*guess_array)[i][wordle_size] = '\0';
		(*hint_array)[i][wordle_size] = '\0';
	}
}

																									// MAIN GAME LOGIC
void playWordle(char *wordle)
{
	int tries = MAX_TRIES; 																			// Determine rows
	int wordle_size = strlen(wordle);																// Determine columns

	char **guess_array, **hint_array;																// Initializes 2d Arrays based on size
	multi_setup(&guess_array, &hint_array, tries, wordle_size);

	int counter = 0;																				// Counter for tries
	int flag = 0;																					// Flag for winning the game

	while (counter < tries)																			// Game continues while there are still tries
	{
		char *guess;
		guess = (char*) malloc(sizeof(char) * (wordle_size + 1));									// Allocate an array for a string input equal to the wordle length + 1 (to check if input is longer)
		guess_input(guess, wordle_size);															// Calls the function that asks the user for their guess
		
		strcpy(guess_array[counter], guess);														// Copies the user's guess to the array of guesses

		check(guess, wordle, hint_array[counter], wordle_size);										// Checks the guess for possible hints

		output(guess_array, hint_array, tries);														// Shows the user their progress
		counter++;																					// Iterate tries counter

		if (strcmp(guess, wordle) == 0)																// If the guess is the same as the wordle
		{
			flag = counter;																				// flag is set equal to the tries counter
			free(guess);																				// the guess array (string) is freed
			break;																						// the loop is broken
		}

		free(guess);																				// Else, just free the guess and loops

	}
	
	message(flag, tries);																			// Calls the function for printing the end of the game

	set_arrayfree(&guess_array, &hint_array, tries);												// Calls the function that frees the Allocated 2d Arrays
}

int main()
{
	char wordle[] = WORDLE;

	playWordle(wordle);																				// Pass the wordle to the game

	return 0;
} 