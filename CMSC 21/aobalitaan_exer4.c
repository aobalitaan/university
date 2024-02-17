// Axel O. Balitaan
// ST-5L
// Population growth calculator using recursive functions

#include <stdio.h>

float growth_computation(float n, int x, int y)																			//recursive function
{
	if (x == 0)																											//if recursion completed (years exhausted) returns the final value of n
	{
		return n;
	}
	else
	{
		return growth_computation(n + (n * (float)y/100), x-1, y);														//updates population valie and subtracts 1 from number of years
	}
}


int main()
{
	float n;																											//initialization
	int x, y;

	printf("Population (n): \n");																						//user input
	scanf("%f", &n);

	printf("Growth Rate (y%): \n");
	scanf("%i", &y);

	printf("Years (x): \n");
	scanf("%i", &x);

	printf("\nResult:");
	printf("\nAfter %i years at %i%% growth rate, the population will be %.6f", x, y, growth_computation(n, x, y));		//printing statement and function call

	return 0;
}