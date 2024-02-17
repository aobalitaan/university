// Axel O. Balitaan
// ST-5L
// Simple ticket reservation system, with edit and delete functionalities, sorting, save and loading, using Linked Lists

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Used to create an instance of an event
typedef struct event_tag 
{
	char event_id[5];
	char event_title[20];
	char artist[20];
	char datetime[20];
	float ticket_price;
	int stock;
	int soldCount;
	struct event_tag  *nextEvent;
} event;

//Used to create a booking linked list for each customer. This is so that you can access the details of the specific event in the event linked list
struct bookings 
{
	event *event_booked;
	struct bookings *nextBooking;
};

//Used to create an instance of a customer
typedef struct customer_tag 
{
	char name[20];
	struct customer_tag *nextCustomer;
	struct bookings *ticketsBought;
	int total_cost;
} customer;

//Main Menu Screen and gets user choice
void menu(int *choice)	
{
	printf("\n==================== MENU ====================");
	printf("\n[1] Add Event Details");
	printf("\n[2] Buy Ticket");
	printf("\n[3] Edit Event Details");
	printf("\n[4] Delete Event");
	printf("\n[5] View All Events");
	printf("\n[6] View All Customers");
	printf("\n[7] Exit");

	printf("\nEnter choice: ");										
	scanf("%i", choice);
}

//Function that checks if event exists and if so returns a pointer to the node of the event
void eventFinder(event **current_event, char *new_eventid)
{
	while ((*current_event) != NULL)
	{
		//If event id found, stops at the current node
		if (strcmp(((*current_event) -> event_id), new_eventid) == 0)
		{
			return;
		}
		(*current_event) = (*current_event) -> nextEvent;
	}
}

//Inserts event to the linked list
void sortedInsert(event **event_head_ptr, event *new)
{
	//If head is NULL
	if ((*event_head_ptr) == NULL)
	{
		(*event_head_ptr) = new;
	}
	//Insert at head
	else if (strcmp(new -> event_title, (*event_head_ptr) -> event_title) < 0)
	{
		new -> nextEvent = (*event_head_ptr);
		(*event_head_ptr) = new;
	}
	//Insert in middle and insert at tail
	else
	{
		event *temp = (*event_head_ptr);
		while ((temp -> nextEvent != NULL) && strcmp(new -> event_title, (temp -> nextEvent -> event_title)) > 0)
		{
			temp = temp -> nextEvent;
		}

		new -> nextEvent = temp -> nextEvent;
		temp -> nextEvent = new;
	}
}

//Function that gets event and details from user
void addEvent(event **event_head_ptr)
{
	//Gets event Id from user
	event *new = (event*) malloc (sizeof(event));
	new -> nextEvent = NULL;

	printf("\nEnter event id: ");
	scanf(" %[^\n]", new -> event_id);

	event *current_event = (*event_head_ptr);
	//Calls the function that looks for the event id in database
	eventFinder(&current_event, new -> event_id);

	//If the event was found in the database
	if (current_event != NULL)
	{
		free(new);
		printf("\nEvent ID already exists!");
		return;
	}
	
	//If not found, gets more details from user
	printf("Enter event title: ");
	scanf(" %[^\n]", new -> event_title);

	printf("Enter artist: ");
	scanf(" %[^\n]", new -> artist);

	printf("Enter date and time: ");
	scanf(" %[^\n]", new -> datetime);

	printf("Enter ticket price: ");
	scanf("%f", &(new -> ticket_price));

	printf("Enter stock: ");
	scanf("%i", &(new -> stock));

	new -> soldCount = 0;

	//and inserts the new node to the linked list
	sortedInsert(event_head_ptr, new);
	printf("\nSuccessfully added event!");
}

//Function for viewing events
void viewEvents(event *event_head)
{
	event *temp = event_head;

	while (temp != NULL)
	{
		printf("\n\nEvent ID: %s", temp -> event_id);
		printf("\nEvent Title: %s", temp -> event_title);
		printf("\nArtist: %s", temp -> artist);
		printf("\nDate and Time: %s", temp -> datetime);
		printf("\nTicket Price: %.2f", temp -> ticket_price);
		printf("\nStock: %i", temp -> stock);
		printf("\nSold: %i", temp -> soldCount);

		temp = temp -> nextEvent;
	}

}

//Function that checks if customer in database and if so returns a pointer to the node of the customer
void customerFinder(customer **current_customer, char *new_customer)
{
	while ((*current_customer) != NULL)
	{
		if (strcmp((*current_customer) -> name, new_customer) == 0)
		{
			//If customer found, stops at the current node
			return;
		}
		(*current_customer) = (*current_customer) -> nextCustomer;
	}
}

//Function for buying tickets
void buyTicket(event *event_head_ptr, customer **customer_head_ptr)
{
	//Gets customer name
	customer *new_customer = (customer*) malloc (sizeof(customer));
	new_customer -> nextCustomer = NULL;

	printf("\nEnter customer name: ");
	scanf(" %[^\n]", new_customer -> name);
	
	//prints the events
	event *temp = event_head_ptr;
	printf("\n-------- EVENTS AVAILABLE --------");
	while (temp != NULL)
	{
		printf("\n[%s] %s ( %s ) - %.2f", temp -> event_id, 
			temp -> event_title, temp -> artist, temp -> ticket_price);
		temp = temp -> nextEvent;
	}

	//Gets event id input from user
	printf("\nEnter event id to buy: ");
	char bought_event_id[5];
	scanf(" %[^\n]", bought_event_id);

	event *current_event = event_head_ptr;
	//Calls the function that looks for the event id in database
	eventFinder(&current_event, bought_event_id);

	//If event id not in database
	if (current_event == NULL)
	{
		printf("\nEvent ID not found!");
		free(new_customer);
		return;
	}
	
	//if event in database but stock is 0
	if ((current_event -> stock) <= 0)
	{
		printf("\nEvent ticket is out of stock!");
		free(new_customer);
		return;
	}

	//if event in database and event stock != 0, adds/modifies the customer

	customer *current_customer = (*customer_head_ptr);

	//Looks for the customer in database
	customerFinder(&current_customer, new_customer -> name);
	
	//If customer not in database, initializes them and adds them to the customer linked list
	if (current_customer == NULL)
	{
		new_customer -> ticketsBought = NULL;
		new_customer -> total_cost = 0;
		new_customer -> nextCustomer = NULL;

    	current_customer = new_customer;

    	if (*customer_head_ptr == NULL)
    	{
        	*customer_head_ptr = new_customer;
    	}
    	else
    	{
        	customer *temp = *customer_head_ptr;
        	while (temp -> nextCustomer != NULL)
        	{
            temp = temp -> nextCustomer;
        	}
        	temp -> nextCustomer = new_customer;
    	}
	}

	//creates a booking node that has the event data and attaches it to the database of the specific customer
	struct bookings *bought_event = (struct bookings*) malloc(sizeof(struct bookings));
	bought_event -> event_booked = current_event;
	bought_event -> nextBooking = NULL;
	current_customer -> total_cost += bought_event -> event_booked -> ticket_price;

	if (current_customer -> ticketsBought == NULL)
	{
		current_customer -> ticketsBought = bought_event;
	}
    else
    {
        struct bookings *temp_bookings = current_customer -> ticketsBought;
        while (temp_bookings -> nextBooking != NULL)
        {
        	temp_bookings = temp_bookings -> nextBooking;
        }
        temp_bookings -> nextBooking = bought_event;
    }

	//reduces event stock and increases soldCount
	(current_event -> stock)--;
	(current_event -> soldCount)++;
	printf("\nSuccessfully bought ticket %s %s %s!", current_event -> event_id, current_event -> event_title, current_event -> datetime);
}

//Function for viewing customers
void viewCustomers(customer *customer_head)
{
	customer *current_customer = customer_head;

	while (current_customer != NULL)
	{

		printf("\n\nCustomer Name: %s", current_customer -> name);
		printf("\nTickets Bought: ");

		struct bookings *current_customer_ticket = current_customer -> ticketsBought;

		while (current_customer_ticket != NULL)
		{
			event *current_event = current_customer_ticket -> event_booked;
			printf("\n- %s %s %s", current_event -> event_id, current_event -> event_title, current_event -> datetime);
			current_customer_ticket = current_customer_ticket -> nextBooking;
		}

		printf("\nTotal Cost: %d", current_customer -> total_cost); 

		current_customer = current_customer -> nextCustomer;

	}
}

//Function for editing events
void editEvent(event **event_head_ptr)
{
	//Gets event id from user
	char event_id[5]; 

	printf("\nEnter event id: ");
	scanf(" %[^\n]", event_id);

	event *current_event = (*event_head_ptr);
	//Calls the function that gets the node of the event id
	eventFinder(&current_event, event_id);

	//If event id not in database
	if (current_event == NULL)
	{
		printf("\nEvent ID not found!");
		return;
	}

	//If event in database
	printf("Enter new date and time: ");
	scanf(" %[^\n]", current_event -> datetime);

	printf("Enter new price: ");
	scanf("%f", &(current_event -> ticket_price));

	printf("Enter new stock: ");
	scanf("%i", &(current_event -> stock));

	printf("\nEvent Details Successfully Edited!");
}

//Function for deleting events
void deleteEvent(event **event_head_ptr)
{
	//Gets event id from user
	char event_id[5]; 

	printf("\nEnter event id: ");
	scanf(" %[^\n]", event_id);

	event *todel_event = (*event_head_ptr);
	//Calls the function that gets the node of the event to be deleted
	eventFinder(&todel_event, event_id);

	//If the event not in database
	if (todel_event == NULL)
	{
		printf("\nEvent ID not found!");
	}
	//If the event already sold ticket/s
	else if (todel_event -> soldCount != 0)
	{
		printf("\nCannot delete an event with sold ticket!");
	}
	//If the event is in the head
	else if (todel_event == (*event_head_ptr))
	{
		(*event_head_ptr) = (*event_head_ptr) -> nextEvent;
		printf("\nEvent %s deleted.", todel_event -> event_title);
		free(todel_event);
	}
	else
	{
		event *temp = (*event_head_ptr);
		//Gets the node before the event to be deleted
		while (temp -> nextEvent != todel_event)
		{
			temp = temp -> nextEvent;
		}
		temp -> nextEvent = todel_event -> nextEvent;
		printf("\nEvent %s deleted.", todel_event -> event_title);
		free(todel_event);
	}
}

//SAVING FUNCTIONS

void saveEvents(event *event_head)
{
	FILE *fp_events;
	fp_events = fopen("events.txt", "w");

	//Counts how many events to save
	event *temp = event_head;
	int count = 0;
	while (temp != NULL)
	{
		count++;
		temp = temp -> nextEvent;
	}
	//Prints event count 
	fprintf(fp_events, "%i\n", count);

	//Prints each event
	while (event_head != NULL)
	{
		fprintf(fp_events, "%s##%s##%s##%s##%f##%i##%i\n", 
			event_head -> event_id, event_head -> event_title, event_head -> artist, 
			event_head -> datetime, event_head -> ticket_price, event_head -> stock, 
			event_head -> soldCount);
		event_head = event_head -> nextEvent;
	}

	fclose(fp_events);
	
	printf("\nEvent database successfully saved.");
}

void saveCustomers(customer *customer_head)
{
	FILE *fp_customers;
	fp_customers = fopen("customers.txt", "w");

	//Counts how many customers to save
	customer *temp = customer_head;
	int count = 0;
	while (temp != NULL)
	{
		count++;
		temp = temp -> nextCustomer;
	} 
	fprintf(fp_customers, "%i\n", count);

	//Prints each customer's information
	while (customer_head != NULL)
	{
		//Counts how many tickets a customer bought
		int no_tickets = 0;
		struct bookings *temp = customer_head -> ticketsBought;
		while (temp != NULL)
		{
			no_tickets++;
			temp = temp -> nextBooking;
		}

		//Printing
		fprintf(fp_customers, "%s##%i##%i\n", customer_head -> name, customer_head -> total_cost, no_tickets);
		for (int i = 0; i < no_tickets; i++)
		{
			fprintf(fp_customers, "%s\n", customer_head -> ticketsBought -> event_booked -> event_id);
			customer_head -> ticketsBought = customer_head -> ticketsBought -> nextBooking;
		}
		fprintf(fp_customers, "\n");

		customer_head = customer_head -> nextCustomer;
	}

	fclose(fp_customers);

	printf("\nCustomer database successfully saved.");
}

//LOADING FUNCTIONS

void loadEvents(event **event_head)
{
	FILE *fp_events;
	fp_events = fopen("events.txt", "r");

	//If file doesn't exist ends the function
	if (fp_events == NULL)
	{
		printf("\nEvent database doesn't exist!");
		return;
	}

	//Gets the number of events in the file
	int event_count = 0;
	fscanf(fp_events, "%i\n", &event_count);

	//If there are no events
	if (event_count == 0)
	{
		printf("\nNo events yet in database!");
		fclose(fp_events);
		return;
	}

	//Obtain each event information
	event *new = (event*) malloc (sizeof(event));
	for (int i = 0; i < event_count; i++)
	{
		
		fscanf(fp_events, "%[^#]##%[^#]##%[^#]##%[^#]##%f##%i##%i\n", 
			new -> event_id, new -> event_title, new -> artist, new -> datetime, 
			&(new -> ticket_price), &(new -> stock), &(new -> soldCount));

		//If first run of loop, attaches the event head to the first node
		if (i == 0)
		{
			(*event_head) = new;
		}

		//If last instance of loop, makes the final (-> next) NULL
		if (i == event_count - 1)
		{
			new -> nextEvent = NULL;
		}
		//else, mallocs a new next node
		else
		{
			new -> nextEvent = (event*) malloc (sizeof(event));
			new = new -> nextEvent;
		}
	}

	printf("\nSuccessfully loaded event database.");
	//closes events pointer
	fclose(fp_events);
}

void loadCustomers(customer **customer_head, event *event_head)
{
	FILE *fp_customers;
	fp_customers = fopen("customers.txt", "r");

	//If file doesn't exist ends function
	if (fp_customers == NULL)
	{
		printf("\nCustomer database doesn't exist!");
		return;
	}

	//Gets the number of customers in the file
	int customer_count = 0;
	fscanf(fp_customers, "%i\n", &customer_count);

	//If there are no customers
	if (customer_count == 0)
	{
		printf("\nNo customers yet in database!");
		fclose(fp_customers);
		return;
	}

	//Obtain each customer's information
	customer *new = (customer*) malloc (sizeof(customer));
	for (int i = 0; i < customer_count; i++)
	{
		//Gets each information
		int no_tickets = 0;	//How many tickets the customer bought
		fscanf(fp_customers, "%[^#]##%i##%i\n", new -> name, &(new -> total_cost), &no_tickets);

		//Obtains each event information based on saved event ID
		struct bookings *temp = (struct bookings*) malloc (sizeof(struct bookings));
		for (int j = 0; j < no_tickets; j++)
		{
			char event_id[5];
			fscanf(fp_customers, "%s\n", event_id);

			//Gets corresponding event information from database
			event *current_event = event_head;
			eventFinder(&current_event, event_id);

			temp -> event_booked = current_event;

			//If first run of the loop attaches ticketBought to the firsts node
			if (j == 0)
			{
				new -> ticketsBought = temp;
			}

			//If final instance of the loop, converts the temp->nextBooking to NULL
			if (j == no_tickets - 1)
			{
				temp -> nextBooking = NULL;
			}
			//else, mallocs a new booking node
			else
			{
				temp -> nextBooking = (struct bookings*) malloc (sizeof(struct bookings));
				temp = temp -> nextBooking;
			}
		}

		//If the first customer, attaches the customer head to the first node
		if (i == 0)
		{
			(*customer_head) = new;
		}

		//If last customer, turns nextCustomer to NULL
		if (i == customer_count - 1)
		{
			new -> nextCustomer = NULL;
		}
		//else, mallocs a new customer node
		else
		{
			new -> nextCustomer = (customer*) malloc (sizeof(customer));
			new = new -> nextCustomer;
		}

	}

	printf("\nSuccessfully loaded customer database.");
	//closes customer pointer
	fclose(fp_customers);
}

//Deallocates memory after exit
void deallocation(event **event_head_ptr, customer **customer_head_ptr)
{

	//Frees event linked list
	while ((*event_head_ptr) != NULL)
	{
		//Creates a temporary pointer
		event *temp_event = (*event_head_ptr);
		//Moves main pointer to next
		(*event_head_ptr) = (*event_head_ptr) -> nextEvent;
		//frees the temporary pointer
		free(temp_event);
	}

	//Frees customer linked list
	while ((*customer_head_ptr) != NULL)
	{
		//Creates a temporary pointer for customer
		customer *temp_customer = (*customer_head_ptr);

		//Creates a pointer for customer's bookings
		struct bookings *customer_bookings = (temp_customer -> ticketsBought);
		while (customer_bookings != NULL)
		{
			//Creates a temporary pointer to customer's bookings
			struct bookings *temp_bookings = (customer_bookings);
			//Moves main bookings pointer to next
			customer_bookings = customer_bookings -> nextBooking;
			//frees the temporary pointer to bookings (previous)
			free(temp_bookings);
		}

		//Moves main customer pointer to next
		(*customer_head_ptr) = (*customer_head_ptr) -> nextCustomer;
		//Frees the temporary pointer to customer (previous)
		free(temp_customer);
	}
	
}

//Main Function
int main()
{
	//Initializes event and customer head pointers
	event *event_head = NULL;
	customer *customer_head = NULL;

	//Loads Files
	loadEvents(&event_head);
	loadCustomers(&customer_head, event_head);

	int choice = 0;

	do
	{
		menu(&choice);

		switch(choice)
		{
			case 1:
				addEvent(&event_head);
				break;
			case 2:
				//buying ticket, can't proceed if no events yet
				if (event_head == NULL)
				{
					printf("\nThere are no events available!");
				}
				else
				{
					buyTicket(event_head, &customer_head);
				}
				break;
			case 3:
				//editing events, can't proceed if no events yet
				if (event_head == NULL)
				{
					printf("\nThere are no events available!");
				}
				else
				{
					editEvent(&event_head);
				}
				break;
			case 4:
				//deleting events, can't proceed if no events yet
				if (event_head == NULL)
				{
					printf("\nThere are no events available!");
				}
				else
				{
					deleteEvent(&event_head);
				}
				break;
			case 5:
				//viewing events, can't proceed if no events yet
				if (event_head == NULL)
				{
					printf("\nThere are no events available!");
				}
				else
				{
					viewEvents(event_head);
				}
				break;
			case 6:
				//viewing customers, can't proceed if no customers yet
				if (customer_head == NULL)
				{
					printf("\nThere are no customers yet!");
				}
				else
				{
					viewCustomers(customer_head);
				}
				break;
			case 7:
				//Saves Files
				saveEvents(event_head);
				saveCustomers(customer_head);
				deallocation(&event_head, &customer_head);

				printf("\nGoodbye!");
				break;
			default:
				printf("\nInvalid Input!");
		}

	} while (choice != 7);
	
    return 0;
}