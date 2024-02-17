//Axel O. Balitaan
//CMSC 21 ST5L
//Program that gets three largest prime numbers from user-inputted range

#include<stdio.h>
#include<stdlib.h>

void getInput(int *x, int *y);																					//Function Prototypes
void swapValues(int *x, int *y);
int primeChecker(int i, int mid);
void getLargest(int *largest1, int *largest2, int *largest3, int x, int y);
void printLargest(int *largest1, int *largest2, int *largest3);

int main() 																										//Main Function	
{ 																																																	
	
	int x, y, largest1, largest2, largest3;																						
	
	getInput(&x, &y);																							//Calls Input Function
	swapValues(&x, &y);																							//Calls Swap Function

	if (y < 2)																									//Checks if the range is valid
	{
		printf("Invalid range!");
		return 0;
	}

	getLargest(&largest1, &largest2, &largest3, x, y);															//Calls the function that gets the largest prime numbers
	printLargest(&largest1, &largest2, &largest3);																//Calls the function that prints the three largest prime numbers

	return 0;
}

void getInput(int *x, int *y)																					//Gets user input for range
{
	printf("Enter x: ");
	scanf("%i", x);

	printf("Enter y: ");
	scanf("%i", y);
}

void swapValues(int *x, int *y)																					//Swaps the range(value) if not in correct order
{
	int temp;										

	if (*x > *y)																									
	{
		temp = *y;																								//Copies the inital value of y
		*y = *x;																								//Change the value of y
		*x = temp;																								//Change the value of x into y
	}
}

int primeChecker(int i, int mid)																				//Checks if number is prime
{
	if (i <= 1)																									//If number is less than or equal to one, automatically returns not prime
	{
		return 0;
	}

	for (int j = 2; j <= mid; j++)																				//Iterates from 2 to the number/2
	{																											//This is because anything more than half of the number can't be a factor without being paired with value <=2
		if (i % j == 0)																							//If one is a factor, returns not prime
		{
			return 0;
		}
	}

	return 1;																									//else, returns is a prime
}

void getLargest(int *largest1, int *largest2, int *largest3, int x, int y)										//Gets the Largest Prime Numbers
{

	*largest1 = 0;																								//Initialization so that the default value for each is 0
	*largest2 = 0;
	*largest3 = 0;


	for (int i = x; i <= y; i++)																				//Iterates over the range
	{
		int isPrime = primeChecker(i, i/2);																		//Checks if the number is prime

		if (isPrime == 1)																						//If so:
		{
			int temp1 = *largest1;																				//Temporarily stores the value of the Largest and Second Largest
			int temp2 = *largest2;

			*largest1 = i;																						//Change the Largest to the current number
			*largest2 = temp1;																					//and demotes the former largest to second
			*largest3 = temp2;																					//and second largest to third
		}
	}
}

void printLargest(int *largest1, int *largest2, int *largest3)													//Printing
{
	int count = 0;

	if (*largest1 != 0)																							//Counts how many prime numbers were obtained
	{
		count++;
	}
	if (*largest2 != 0)
	{
		count++;
	}
	if (*largest3 != 0)
	{
		count++;
	}

	switch (count)																								//Prints corresponding initial statement
	{
	case (1):
		printf("There is one prime number: ");
		break;
	case (2):
		printf("There are two prime numbers: ");
		break;
	case (3):
		printf("The three largest prime numbers are: ");
		break;
	case (0):
		printf("No prime numbers found.");
	}

	if (*largest1 != 0)																							//Prints the obtained largest numbers
	{
		printf("%i ", *largest1);

		if (*largest2 != 0)
		{
			printf("%i ", *largest2);

			if (*largest3 != 0)
			{
			printf("%i ", *largest3);
			}
		}
	}
}