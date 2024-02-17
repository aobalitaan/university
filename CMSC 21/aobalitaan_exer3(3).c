// Axel O. Balitaan
// ST-5L
// Maze Bank ATM using functions and local variables

#include<stdio.h>

void greetings(), main_screen(), pin_input(int);                                                            //function prototype for other functions
int deposit(int), withdraw(int), change_pin(int);                                                           //function prototype for main functions

int main()
{
    int choice, pin = 1234, balance = 0;                                                                    //local variables/initial values initializations
    char account_name[] = "savings";
    

    greetings();                                                                                            //first greetings run with "Hello!"
    printf("\nHello!\n");
    pin_input(pin);                                                                                         //asks for pin (main will not continue unless this function (which has loop) ends)

    do
    {
        greetings();                                                                                        //second greetings run without "Hello!"                                 
        main_screen();                                                                                      //main menu screen

        printf("\n\nUser choice: ");                                                                        //asks for user's choice for menu
        scanf("%i", &choice);

        switch (choice)
        {
            case 1:                                                                                         //user selects balance check
                pin_input(pin);

                printf("\nAccount Name: %s", account_name);                                                 //this was also not put inside a function to avoid using (char *) which I think is not tackled
                printf("\nBalance: %i", balance);

                break;

            case 2:                                                                                         //user chose to deposit
                pin_input(pin);
                balance = deposit(balance);                                                                 //calls the deposit function and modifies the balance
                break;

            case 3:                                                                                         //user chose to withdraw
                pin_input(pin);
                balance = withdraw(balance);                                                                //calls the withdraw function and modifies the balance
                break;

            case 4:                                                                                         //user chose to change pin
                pin_input(pin);
                pin = change_pin(pin);                                                                      //calls change pin function and modifies user's pin
                break;

            case 5:                                                                                         //user chose to change account name
                pin_input(pin);

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

    } while (choice != 6);                                                                                  //repeats the program unless terminated (option 6 was chosen)
}

int change_pin(int current_pin)                                                                             //FUNCTION FOR CHANGING PIN
{
    int new_pin;

    printf("Enter New 4-Digit PIN: " );                                                                     //asks for new pin
    scanf("%i", &new_pin);

    if (new_pin >= 0 && new_pin <= 9999)                                                                    //checks if the new pin is at most 4 digits
    {
        printf("\nPIN changed successfully.");                                                              //note: due to limitation with integers can't detect those that starts with 0s
        return new_pin;
    }
    else
    {
        printf("\nInvalid Input! \nYour pin was not changed.");                                             //if new pin was more than 4 digits, doesn't change pin
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

void greetings()                                                                                            //GREETINGS SCREEN FUNCTION                                                                                              
{
    printf("\n\n****************************");
    printf("\n*  Welcome to Maze Bank!   *");
    printf("\n****************************\n");
}