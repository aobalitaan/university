// Axel O. Balitaan
// ST-5L
// Maze Bank ATM using functions and local variables

#include<stdio.h>

void mainscreen()
{
	printf("\n[1] Check Balance");
	printf("\n[2] Deposit");
	printf("\n[3] Withdraw");
	printf("\n[4] Change PIN");
	printf("\n[5] Set Account Name");
	printf("\n[6] End Transaction");
}

int main()
{
	int choice;
	char account_name[] = "savings";
	int pin = 1234, input_pin, balance = 0;

	do
	{
		printf("\n****************************")
		printf("\n*  Welcome to Maze Bank!   *")
		printf("\n****************************")

		printf("")
		mainscreen_printing();



	} while(choice != 6);

	return 0;
}