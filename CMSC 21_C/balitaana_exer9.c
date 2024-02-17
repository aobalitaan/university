// Axel O. Balitaan
// ST-5L
// Simple ticket reservation system, with edit and delete functionalities

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_CUSTOMERS 10
#define MAX_EVENTS 10
#define MAX_TICKETS 5

typedef struct																														// Stucture for Event
{
	char id[50];
	char title[50];
	char artist[50];
	char datetime[50];
	int price;
	int stock;
} event;

typedef struct																														// Structure for customer
{
	char name[50];
	char tickets[MAX_TICKETS][50];																									// Array of ID (string)
	int no_tickets;																													// Extra variable for number of tickets bought
	int total_cost;
} customer;

void customer_check(customer *customer_arr, int customer_count, int *customer_index, int *customer_exist, char *customer_name)		// CHECKS IF THE CUSTOMER IS IN DATABASE
{
	printf("\nEnter customer name: ");																								// Gets customer name
	scanf(" %[^\n]", customer_name);

	for (int i = 0; i < customer_count; i++)
	{
		if(strcmp(customer_arr[i].name, customer_name) == 0)
		{
			(*customer_index) = i;																									// If found changes the customer index
			(*customer_exist) = 1;																									// and indicates that the customer is found
			return;																													// ends the function
		}
	}
}

void event_check(char *event_id, event *event_arr, int event_count, int *event_index, int *event_exist)								// CHECKS IF THE EVENT IS IN DATABASE
{

	printf("\nEnter event id: ");																									// Gets event id
	scanf(" %[^\n]", event_id);

	int counter = strlen(event_id) - 1;																								// Removes space after
	while (event_id[counter] == ' ')
	{
		counter--;
	}
	event_id[counter + 1] = '\0';
	

	for (int i = 0; i < event_count; i++)
	{
		if (strcmp(event_arr[i].id, event_id) == 0)
		{
			*event_index = i;																										// If found changes the event index																									
			*event_exist = 1;																										// and indicates that the event is found
			return;																													// ends the function
		}
	}
}

void menu(int *choice)																												// MAIN MENU SCREEN
{
	printf("\n==================== MENU ====================");
	printf("\n[1] Add Event Details");
	printf("\n[2] Buy Ticket");
	printf("\n[3] Edit Event Details");
	printf("\n[4] Delete Event");
	printf("\n[5] View All Events");
	printf("\n[6] View All Customers");
	printf("\n[7] Exit");

	printf("\nEnter choice: ");																										// Gets user choice
	scanf("%i", choice);
}

void add_event(event *event_arr, int *event_count)																					// FUNCTION FOR ADDING EVENTS
{
	char event_id[50];																												// Declaration of event ID from user

	int index, event_exist = 0;																										// Event set to non-existent by default
	event_check(event_id, event_arr, *event_count, &index, &event_exist);															// Calls the function that indicates if event exist and its corresponding index

	if (event_exist)																												// If event already in database
	{
		printf("\nEvent ID already exists!");																						// prints error message
	}
	else																															// If not, proceeds with getting details
	{
		strcpy(event_arr[*event_count].id, event_id);

		printf("Enter event title: ");
		scanf(" %[^\n]", event_arr[*event_count].title);

		printf("Enter artist: ");
		scanf(" %[^\n]", event_arr[*event_count].artist);

		printf("Enter date and time: ");
		scanf(" %[^\n]", event_arr[*event_count].datetime);

		printf("Enter ticket price: ");
		scanf("%i", &(event_arr[*event_count].price));

		printf("Enter stock: ");
		scanf("%i", &(event_arr[*event_count].stock));

		printf("\nSuccessfully added event!");
		(*event_count)++;
	}
}

void buy_ticket(event *event_arr, customer *customer_arr, int event_count, int *customer_count)										// FUNCTION FOR BUYING TICKET
{

	int customer_index = *customer_count, customer_exist = 0;																		// Customer index set to the last index in the array, and customer set to non-existent by default
	char customer_name[50];

	customer_check(customer_arr, (*customer_count), &customer_index, &customer_exist, customer_name);								// Checks if the customer is already in database and their corresponding index

	if ((!customer_exist) && (*customer_count == MAX_CUSTOMERS))																	// Checks if customer database is full
	{
		printf("\nDatabase is full and can't accommodate new customers!");
		return;
	}

	if (!customer_exist)																											// If the customer is not yet in database, adds them
	{
		strcpy(customer_arr[customer_index].name, customer_name);
		customer_arr[customer_index].no_tickets = 0;
		customer_arr[customer_index].total_cost = 0;
		(*customer_count)++;    
	}

	printf("\n-------- EVENTS AVAILABLE --------");																					// Prints available events
	for (int i = 0; i < event_count; i++)
	{
		printf("\n[%s] %s ( %s ) - %i", event_arr[i].id, event_arr[i].title, event_arr[i].artist, event_arr[i].price);
	}

	char event_id[50];																														

	int event_index, event_exist = 0;																								// Event set to non-existent by default																										
	event_check(event_id, event_arr, event_count, &event_index, &event_exist);														// Calls the function that indicates if event exist and its corresponding index

	if(!event_exist)																												// If the event id is not in database
	{
		printf("\nEvent ID not found!");																							// prints error message
		return;																														// and terminates the function
	}

	if ((event_arr[event_index].stock) <= 0)																						// If the stock of event is = 0
	{
		printf("\nEvent ticket is out of stock!");																					// prints error message
		return;																														// and terminates the function
	}
	
	// VALID TRANSACTION																											// If passed these conditions, continues
	
	if ((customer_arr[customer_index].no_tickets >= MAX_TICKETS))																	// If customer already bought maximum allowed number of tickets
	{
		printf("\nThis customer already bought the maximum allowed \nnumber of tickets. \nTransaction cancelled!\n");				// prints error message
		return;																														// and terminates the function
	}

																																	// If all conditions passed, proceed with the transaction
	int tickets_index = customer_arr[customer_index].no_tickets;																	// The ticket bought is added (append) to the last index of the tickets array
	strcpy((customer_arr[customer_index].tickets)[tickets_index], event_arr[event_index].id);

	(customer_arr[customer_index].no_tickets)++;																					// Increment the number of tickets bought
	(event_arr[event_index].stock)--;																								// Reduce the event's stock

	printf("\nSuccessfully bought ticket %s %s %s!", event_arr[event_index].id, event_arr[event_index].title, event_arr[event_index].datetime);
}

void edit_event(event *event_arr, int event_count)																					// FUNCTION FOR EDITING EVENT
{
	char event_id[50];

	int index, event_exist = 0;																										// Event set to non-existent by default
	event_check(event_id, event_arr, event_count, &index, &event_exist);															// Calls the function that indicates if event exist and its corresponding index

	if (event_exist)																												// If event ID in database
	{																																// Allows editing details
		printf("\nEnter new date and time: ");
		scanf(" %[^\n]", event_arr[index].datetime);

		printf("Enter new price: ");
		scanf("%i", &(event_arr[index].price));

		printf("Enter new stock: ");
		scanf("%i", &(event_arr[index].stock));

		printf("\nEvent Details Successfully Edited !");
	}
	else																															// If not in database
	{
		printf("\nEvent ID not found!");																							// prints error message
	}
}

void delete_event(event *event_arr, int *event_count, customer *customer_arr, int customer_count)									// FUNCTION FOR DELETING EVENT
{
	char event_id[50];

	int index, event_exist = 0;																										// Event set to non-existent by default
	event_check(event_id, event_arr, *event_count, &index, &event_exist);															// Calls the function that indicates if event exist and its corresponding index

	if(!event_exist)																												// If the event id is not in database																														
	{
		printf("\nEvent ID not found!");																							// prints error message
		return;																														// and terminates the function
	}

	int event_bought = 0;																											// Checks if the event is already bought by a customer

	for (int i = 0; i < customer_count; i++)
	{
		for (int j = 0; j < customer_arr[i].no_tickets; j++)
		{
			if (strcmp((customer_arr[i].tickets)[j], event_id) == 0)
			{
				event_bought = 1;
			}
		}
		
	}

	if (event_bought)																												// If the event ticket is already bought by a customer
	{
		printf("\nEvent tickets already bought. \nDeletion blocked!\n");															// blocks the deletion
	}
	else																															// If not bought by a customer
	{
		(*event_count)--;																											// reduces the event count

		for (int i = index; i < *event_count; i++)																					// and deletes the event
		{
			event_arr[i] = event_arr[i+1];																							// adjusts the array starting from the index of inputted event
		}

		printf("\nSuccessfully deleted event detail!");																				// Success message
	}
}

void view_events(event *event_arr, int event_count)																					// FUNCTION FOR VIEWING EVENTS
{
	for (int i = 0; i < event_count; i++)
	{
		printf("\nEvent ID: %s", event_arr[i].id);
		printf("\nEvent Title: %s", event_arr[i].title);
		printf("\nArtist: %s", event_arr[i].artist);
		printf("\nDate and Time: %s", event_arr[i].datetime);
		printf("\nTicket Price: %i", event_arr[i].price);
		printf("\nStock: %i", event_arr[i].stock);

		printf("\n");
	}
}

void view_customers(customer *customer_arr, int customer_count, event *event_arr, int event_count)									// FUNCTION FOR VIEWING CUSTOMERS
{

	for (int i = 0; i < customer_count; i++)																						// Iterates through customer database
	{
		printf("\nCustomer Name: %s", customer_arr[i].name);
		printf("\nTickets Bought: ");

		for (int j = 0; j < customer_arr[i].no_tickets; j++)
		{
			for (int k = 0; k < event_count; k++)
			{
				if (strcmp(event_arr[k].id, (customer_arr[i].tickets)[j]) == 0)
				{
					printf("\n- %s %s %s", event_arr[k].id, event_arr[k].title, event_arr[k].datetime);
				}
			}
		}

		printf("\nTotal Cost: %i", customer_arr[i].total_cost);
		
		printf("\n");
	}
}

void calculate_total(event *event_arr, customer *customer_arr, int event_count, int customer_count)									// FUNCTION FOR CALCULATING THE TOTAL OF ALL CUSTOMERS (EACH)
{
	for (int i = 0; i < customer_count; i++)
	{
		customer_arr[i].total_cost = 0;																								// total of each initially set to 0
		for (int j = 0; j < customer_arr[i].no_tickets; j++)
		{
			for (int k = 0; k < event_count; k++)
			{
				if(strcmp((customer_arr[i].tickets)[j], event_arr[k].id) == 0)
				{
					customer_arr[i].total_cost += event_arr[k].price;																// Adds the total per ID found in their tickets bought array
				}
			}
			
		}
	}
}

int main()																															// MAIN FUNCTION
{
	event event_arr[MAX_EVENTS];																									// Declares an array of event structure
	customer customer_arr[MAX_CUSTOMERS];																							// Declares an array of customer structure
	int event_count = 0, customer_count = 0;

	int choice = 0;																													// Initializes user choice

	do
	{

		calculate_total(event_arr, customer_arr, event_count, customer_count);														// Calculate the total of each customer

		menu(&choice);																												// Calls the menu function that gets user choice

		switch(choice){																												// Switch Case for use choice
			case 1:																													// Adding Events
				if (event_count < MAX_EVENTS)																						// Checks if the database is not yet full
				{
					add_event(event_arr, &event_count);
				}
				else
				{
					printf("\nMaximum number of events reached!");
				}
				break;
			
			case 2:																													// Buying ticket
				if (event_count != 0)																								// Checks if there are events available
				{
					buy_ticket(event_arr, customer_arr, event_count, &customer_count);													
				}
				else
				{
					printf("\nThere are no events available!\n");
				}
				break;
			
			case 3:																													// Editing Event
				if (event_count != 0)																								// Checks if there are events available
				{
					edit_event(event_arr, event_count);
				}
				else
				{
					printf("\nThere are no events available!\n");
				}
				break;
			
			case 4:																													// Deleting Event
				if (event_count != 0)																								// Checks if there are events available
				{
					delete_event(event_arr, &event_count, customer_arr, customer_count);
				}
				else
				{
					printf("\nThere are no events available!\n");
				}
				break;
			
			case 5:																													// Viewing Events
				if (event_count != 0)																								// Checks if there are events available
				{
					view_events(event_arr, event_count);
				}
				else
				{
					printf("\nThere are no events available!\n");
				}
				break;
			
			case 6:																													// Viewing Customers
				if (customer_count != 0)																							// Checks if there are customers
				{
					view_customers(customer_arr, customer_count, event_arr, event_count);
				}
				else
				{
					printf("\nThere are no customers yet!\n");
				}
				break;
			
			case 7:
				printf("\nGoodbye!");
				break;
			
			default:
				printf("\nInvalid Input!");
		}
		
	} while(choice != 7);

	return 0;
}