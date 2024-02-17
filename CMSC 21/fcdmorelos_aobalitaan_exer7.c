//FRANZ CHRISTIAN D. MORELOS
//AXEL O. BALITAAN 
//CMSC 21 ST-5L 
//a program prompts the user to enter words, checks if they are palindromes, and stores the palindromes in a list until the user enters "EXIT"

#include <stdio.h>
#include <ctype.h>                                                                  // to use the toupper() function
#include <string.h>                                                                 // to use the strcmp() function

int isPalindrome(char *word){                                                       // function that checks if palindrome 
    int word_index = strlen(word) - 1;                                              // index of the last character
    for (int i = 0; i<= (strlen(word)/2); i++){                                     // loop that check initial charcters until half
        if (word[i] != word[word_index]){                                           // checks if the first and last and soon on are equal
            return 0;
        } else{
            word_index --;                                                          // update the last index to second to the last and so on
        }
    }
    return 1;
}

void toupperStr(char *word){                                                        // function that converts each char to upper case
    for (int i = 0; i < strlen(word); i++){                                         // loop through all char in string
        word[i] = toupper(word[i]);                                                 // convert char to uppercase
    } 
}

int main(){
    char word[20], exit[] = "EXIT", palindromes[20][20];         // variable declaration
    int counter = 0;
    do {
        printf("Enter word to check: ");
        scanf(" %s", word);
        toupperStr(word);                                                           // convert string to uppercase
        if (strcmp(word,exit) != 0){                                                // checks if the word is exit
            if (isPalindrome(word)){                                                // checks if palindrome
                printf("The word '%s' is a palindrome\n\n", word);
                strcpy(palindromes[counter], word);                                 //copies the word to the corresponding array in the multidimentional array
                counter ++;                                                         //increment counter
            } else {
                printf("The word '%s' is NOT palindrome\n\n", word);
            }
        } else {
            for (int i = 0; i < counter; i++){
                printf("[%d] %s\n", i+1, palindromes[i]);                           //prints the multidimensional array
            }
            printf("Goodbye!");                                                     // if input word is exit
            break;
        }       
    } while (strcmp(word,exit) != 0);                                               // terminate if input word is exit else loop
    return 0;
}