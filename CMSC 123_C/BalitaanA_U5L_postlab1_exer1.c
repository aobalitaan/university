//AXEL O. BALITAAN
//CMSC 123 U5L
//2022-05153

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Import file
#include "queue.h"


//Creates Queue
LIST *createQueue()
{
	//Mallocs queue
	LIST *queue_list = (LIST*) malloc(sizeof(LIST));

	//Sets head and tail initially to NULL
	queue_list -> head = NULL;
	queue_list -> tail = NULL;

	//Returns the created queue
	return queue_list;
}

//Creates Node
NODE *createNode(int data)
{
	//Mallocs node
	NODE *new_node = (NODE*)malloc(sizeof(NODE));

	//Sets the values of the node
	new_node -> value = data;
	new_node -> next = NULL;

	//Returns the created node
	return new_node;
}

//Checks if the queue is empty
int isEmpty(LIST *queue_list)
{
	if (queue_list -> head == NULL)
	{
		//Returns 1 if queue is empty
		return 1;
	}
	//Returns 0 if not
	return 0;
}

//Adds new node the the queue
void enqueue(LIST *queue_list, NODE *new_node)
{
	//Case for currently empty queue
	if (isEmpty(queue_list))
	{
		//Queue head and tail points to new node
		queue_list -> head = new_node;
		queue_list -> tail = new_node;
		return;
	}

	//Case for non-empty queue
	//Connects new node to the queue
	queue_list -> tail -> next = new_node;
	//Adjusts tail
	queue_list -> tail = new_node;
}

//Adding Queue
void addQueue(LIST *queue_list)
{
	//Gets data from user
	int new = 0;
	printf("\nEnter value: ");
	scanf("%i", &new);

	//Creates new node
	NODE *new_node = createNode(new);

	//Add the node to the queue
	enqueue(queue_list, new_node);

	//Prompts the user with the added node
	printf("\nAdded [%i] in the queue.\n", new_node -> value);
}

//Printing Queue
void printQueue(LIST *queue_list)
{
	//Checks first if queue is empty
	if (isEmpty(queue_list))
	{
		printf("\nNo Queue to Print!");
		return;
	}

	//Loops through the queue and prints values
	NODE *temp = queue_list -> head;
	printf("\n======QUEUE======");
	while (temp != NULL)
	{
		printf("\n%i", temp -> value);
		temp = temp -> next;
	}
	printf("\n=======END=======\n");
}

//Dequeue
int dequeue(LIST *queue_list)
{
	//Points temporary pointer to the current head
	NODE *temp = queue_list -> head;
	//Adjusts head
	queue_list -> head = queue_list -> head -> next; 

	//Holds the value to be dequeued
	int dqVal = temp -> value;
	//Frees the former head node
	free(temp);

	//Prompts the user and returns the removed value
	printf("\nRemoved [%i] from the queue.", dqVal);
	return(dqVal);
}

//Resetting the whole list
void ResetQueue(LIST *queue_list)
{
	//Checks first if queue is empty
	if (isEmpty(queue_list))
	{
		printf("\nNo Queue to Reset!\n");
		return;
	}

	NODE *head = queue_list -> head;
	NODE *free_temp;

	while (head != NULL)
	{
		free_temp = head;
		head = head -> next;
		free(free_temp);
	}

	free(queue_list);
	printf("\nFreed all queue.\n");
}

//Main Function
int main()
{
	//Create initial queue
	LIST *queue_list = createQueue();

	while (1)
	{
		int choice = 99;

		printf("\n======MAIN MENU======");
		printf("\n[1] Add Queue");
		printf("\n[2] Dequeue");
		printf("\n[3] Print Queue");
		printf("\n[4] Reset Queue");
		printf("\n[0] Exit\n");

		printf("\nEnter choice: ");
		scanf("%i", &choice);

		if (choice == 0)
		{
			//Frees the list completely
			ResetQueue(queue_list);
			printf("\nGoodbye!\n");
			break;
		}

		if (choice == 1)
		{	
			//Add queue (gets input, create node, enqueue)
			addQueue(queue_list);
		}
		else if (choice == 2)
		{
			//Checks first if queue is empty
			if (isEmpty(queue_list))
			{
				printf("\nQueue is Empty!");
				continue;
			}
			//dequeue the list and returns the dqed value
			int dqVal = dequeue(queue_list);
		}
		else if (choice == 3)
		{
			//prints all in the queue
			printQueue(queue_list);
		}
		else if (choice == 4)
		{
			//Frees the list
			ResetQueue(queue_list);
			//Initializes new queue
			queue_list = createQueue();
		}
		else
		{
			//Invalid Input catch
			printf("\nInvalid Input!\n");
		}
	}
	return 0;
}