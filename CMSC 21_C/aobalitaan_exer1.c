// Axel O. Balitaan
// CMSC 21 ST-5L
// Simple GWA Calculator (5 inputs) using introduction to C language

#include<stdio.h>

int main(){
	//declaration(initialization of variables)
	int U1, U2, U3, U4, U5, total_units;
	float G1, G2, G3, G4, G5;
	float WG1, WG2, WG3, WG4, WG5, final_grade;

	//user input for G1 and U1
	printf("Enter units: ");
	scanf("%i", &U1);
	printf("Enter grade: ");
	scanf("%f", &G1);

	//user input for G2 and U2
	printf("Enter units: ");
	scanf("%i", &U2);
	printf("Enter grade: ");
	scanf("%f", &G2);

	//user input for G3 and U3
	printf("Enter units: ");
	scanf("%i", &U3);
	printf("Enter grade: ");
	scanf("%f", &G3);

	//user input for G4 and U4
	printf("Enter units: ");
	scanf("%i", &U4);
	printf("Enter grade: ");
	scanf("%f", &G4);

	//user input for G5 and U5
	printf("Enter units: ");
	scanf("%i", &U5);
	printf("Enter grade: ");
	scanf("%f", &G5);

	//computation for weighted grades
	WG1 = G1 * U1;
	WG2 = G2 * U2;
	WG3 = G3 * U3;
	WG4 = G4 * U4;
	WG5 = G5 * U5;

	//computation for total units obtained
	total_units = U1 + U2 + U3 + U4 + U5;

	//computation for GWA
	final_grade = (WG1 + WG2 + WG3 + WG4 + WG5)/total_units;

	//printing (program final output)
	printf("\nGWA: %.2f\n", final_grade);
	printf("Total units: %i\n", total_units);

	return 0;
}