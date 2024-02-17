// Axel O. Balitaan
// ST-5L
// BMI computation and classification using loops and conditional statements

#include<stdio.h>

int main()
{

	int choice;																		//initialization of main menu choice
	float kilo, centi, pounds, feet, inches, total_height, bmi;						//initialization of values

	do
	{
		printf("\n\n1 - Measure in metric");
		printf("\n2 - Measure in standard");
		printf("\n3 - Exit");
		printf("\n\nPlease enter choice:" );
		scanf("%d", &choice);

		switch (choice)																//switch case for main menu
		{
			case 1:

				printf("\nEnter weight in kilograms: ");							//user input
				scanf("%f", &kilo);

				printf("Enter height in centimeters: ");
				scanf("%f", &centi);

				bmi = kilo/((centi/100)*(centi/100));								//bmi computation (metric)

				printf("\nYour BMI is: %.2f\n", bmi);

				if (bmi < 18.5)														//bmi classification
				{
					printf("BMI Category: Underweight");
				}
				else if (bmi < 25)
				{
					printf("BMI Category: Normal weight");
				}
				else if (bmi < 30)
				{
					printf("BMI Category: Overweight");
				}
				else
				{
					printf("BMI Category: Obesity");
				}

				break;

			case 2:																

				printf("\nEnter weight in pounds: ");								//user input
				scanf("%f", &pounds);

				printf("Enter height in feet: ");
				scanf("%f", &feet);

				printf("Enter height in inches: ");
				scanf("%f", &inches);

				total_height = ((feet*12) + inches);								//bmi computation (standard)
				bmi = (pounds/(total_height*total_height) * 703);	

				printf("\nYour BMI is: %.2f\n", bmi);

				if (bmi < 18.5)														//bmi classification 
				{
					printf("BMI Category: Underweight");
				}
				else if (bmi < 25)
				{
					printf("BMI Category: Normal weight");
				}
				else if (bmi < 30)
				{
					printf("BMI Category: Overweight");
				}
				else
				{
					printf("BMI Category: Obesity");
				}

				break;

			case 3:

				printf("Goodbye!\n");
				break;

			default:

				printf("\nInvalid Input!");
		}
	} while (choice != 3);

	return 0;
}