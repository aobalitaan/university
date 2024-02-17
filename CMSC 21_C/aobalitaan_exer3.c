// Axel O. Balitaan
// ST-5L
// Maze Bank ATM using functions and local variables

#include<stdio.h>

void opening_screen(), main_screen(), pin_input(int);                                                       //function prototype for other functions

void check_balance(char account_name[], int);                                                               //function prototype for main functions
int deposit(int), withdraw(int), change_pin(int); 

int main()
{
    int choice, pin = 1234, balance = 0;                                                                    //local variables/initial values initializations
    char account_name[] = "savings";
    

    opening_screen();                                                                                       //first opening_screen run with "Hello!"
    printf("\nHello!\n");
    pin_input(pin);                                                                                         //asks for pin (main will not continue unless this function (which has loop) ends

    do
    {
        opening_screen();                                                                                   //second opening_screen run without "Hello!"                                 
        main_screen();                                                                                      //main menu screen

        printf("\n\nUser choice: ");                                                                        //asks for user's choice for menu
        scanf("%i", &choice);

        if ((choice > 0) && (choice < 6))                                                                   //asks PIN for valid choice
        {
            pin_input(pin);
        }

        switch (choice)
        {
            case 1:                                                                                         //user selects balance check
                check_balance(account_name, balance);                                                       //calls check balance function
                break;

            case 2:                                                                                         //user chose to deposit
                balance = deposit(balance);                                                                 //calls the deposit function and modifies the balance
                break;

            case 3:                                                                                         //user chose to withdraw
                balance = withdraw(balance);                                                                //calls the withdraw function and modifies the balance
                break;

            case 4:                                                                                         //user chose to change pin
                pin = change_pin(pin);                                                                      //calls change pin function and modifies user's pin
                break;

            case 5:                                                                                         //user chose to change account name
                printf("\nEnter New Account Name: " );
                scanf(" %s", account_name);                                                                 //modifies account name

                printf("Your account name was changed to %s.", account_name);

                break;

            case 6:                                                                                         //user ends the program
                printf("\nGoodbye!");
                break;

            default:                                                                                        //invalid input case
                printf("\nInvalid Input!");
        }

    } while (choice != 6); 
    return 0;                                                                                               //repeats the program unless terminated (option 6 was chosen)
}

int change_pin(int current_pin)                                                                             //FUNCTION FOR CHANGING PIN
{
    int new_pin1, new_pin2;

    printf("\nEnter New 4-Digit PIN: " );                                                                   //asks for new pin
    scanf("%i", &new_pin1);

    if (new_pin1 >= 0 && new_pin1 <= 9999)                                                                  //checks if the new pin is at most 4 digits
    {                                                                                                       //note: due to limitation with integers can't detect those that starts with 0s
        printf("\nEnter Again New 4-Digit PIN: " );                                                         //verifies new pin
        scanf("%i", &new_pin2);

        if (new_pin1 == new_pin2)                                                                           //evaluates if PINs match                                     
        {
            printf("\nPIN changed successfully.");                                                          //modifies the PIN                                                              
            return new_pin1;
        }
        else
        {
            printf("\nPINs did not match. \nYour PIN was not changed.");                                    //don't modify pin if verification fails
            return current_pin;
        }
    }
    else
    {
        printf("\nUh-Oh! There's a problem with your input. \nYour PIN was not changed.");                  //if new pin is more than 4 digits, doesn't change pin
        return current_pin;
    }
}

int withdraw(int balance)                                                                                   //FUNCTION FOR WITHDRAWING 
{
    int withdraw_amount;

    printf("\nWithdraw Amount: ");                                                                          //asks for withdrawal amount
    scanf("%i", &withdraw_amount);

    if (balance >= withdraw_amount)                                                                         //checks if the balance is enough for withdrawal
    {
        printf("\nYou have successfully withdrawn %i.", withdraw_amount);
        return (balance - withdraw_amount);                                                                 //if so, deducts it to balance
    }
    else
    {
        printf("\nYou don't have enough balance.");
        return balance;                                                                                     //else, doesn't allow the withdrawal
    }
}

int deposit(int balance)                                                                                    //FUNCTION FOR DEPOSITING
{
    int deposit_amount;

    printf("\nDeposit Amount: ");                                                                           //asks for deposit amount
    scanf("%i", &deposit_amount);                                                       

    return (balance + deposit_amount);                                                                      //adds to balance and returns value                             
}

void check_balance(char account_name[], int balance)                                                        //FUNCTION FOR CHECKING BALANCE
{
    printf("\nAccount Name: %s", account_name);                                               
    printf("\nBalance: %i", balance);
}

void pin_input(int current_pin)                                                                             //FUNCTION FOR CHECKING/GETTING USER PIN
{
    int user_input;

    printf("\nPlease Enter your 4 Digit PIN");

    while (user_input != current_pin)                                                                       //continuously asks for pin if not match                                                                         
    {
        printf("\n(user) ");                                                            
        scanf("%i", &user_input);

        if (user_input != current_pin)
        {
            printf("\nYou entered an incorrect PIN. Please Try Again");
        }
    }
}

void main_screen()                                                                                          //MAIN SCREEN PRINTING FUNCTION
{
    printf("\n[1] Check Balance");
    printf("\n[2] Deposit");
    printf("\n[3] Withdraw");
    printf("\n[4] Change PIN");
    printf("\n[5] Set Account Name");
    printf("\n[6] End Transaction");
}

void opening_screen()                                                                                       //OPENING SCREEN FUNCTION                                                                                              
{
    printf("\n\n****************************");
    printf("\n*  Welcome to Maze Bank!   *");
    printf("\n****************************\n");
}