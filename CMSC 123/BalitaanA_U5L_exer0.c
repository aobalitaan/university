//BALITAAN AXEL O.
//2022-05153
//CMSC 123 U5L

#include<stdio.h>
#include<stdlib.h>

typedef struct node_tag
{
	int value;
	struct node_tag* next;
}NODE;

/*
** createNode()
** requirements: an integer data
** results:
	creates an empty node with value `data`
	initializes fields of the structure
	returns the created node
*/
NODE* createNode(int data)
{
	//Mallocs new node
	NODE *new_node = (NODE*)malloc(sizeof(NODE));

	//Puts the value on the nodes
	new_node -> value = data;
	new_node -> next = NULL;

	//Returns the new node
	return new_node;
}

/*
** isEmpty()
** results:
	returns 1 if the list is empty
	otherwise return 0
*/
int isEmpty(NODE* head)
{
	//Checks if the head is pointing to NULL (if list is empty)
	if (head == NULL)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
** insert()
** requirements: the address of the head pointer and the value to be inserted
** results:
	inserts the newly created `node` at the `head` of the list
*/
void insert(NODE **head, int value)
{
	//Creates Node using the createNode function
    NODE* new_node = createNode(value);

	//Points the next of the new node to the current head node
	new_node -> next = *head;
	//Points the head to the new node
	*head = new_node;
}


/*
** delete()
** requirements: the address of the head pointer
** results:
	deletes the `head` node of the list
	returns the value of the deleted node
*/
int delete(NODE **head)
{
	//Points a temporary pointer to the current head node
	NODE *temp = *head;

	//Points the head to the node next to head node (2nd)
	*head = (*head) -> next;

	//Gets the value of the node to be deleted
	int del_value = temp->value;

	//Frees the node to be deleted
	free(temp);

	//Prompt for the deleted node
	printf("\nDeleted [%d] from the list\n", del_value);

	//Returns the deleted value
	return del_value;
}

void deleteAll(NODE **head)
{
	//Loops all through
	while (*head != NULL)
	{
		//Temporary pointer pointing to the current head node
		NODE *temp = *head;
		//Adjusts the head pointer to next node
		*head = (*head) -> next;
		//Frees the temporary pointer
		free(temp);
	}
	printf("\nDeleted all values\n");
}

/*
** printList()
** requirements: head pointer
** results:
	prints the contents of the lists in a line
*/
void printList(NODE *head)
{
	printf("\n=====Data=====\n");
	//Loops to all nodes
	while (head != NULL)
	{
		//Print Node value
		printf("%d\n", head->value);
		//Iterates to next node
		head = head -> next;
	}
}

int main()
{
	NODE *head = NULL;
	
	//Main Menu Choice
	int choice = 10;
	
	while (choice != 0)
	{
		printf("\n[1] Insert Node\n");
		printf("[2] Delete Node\n");
		printf("[3] Print Nodes\n");
		printf("[0] Exit\n");

		//User Input
		printf("\nEnter Choice: ");
		scanf("%i", &choice);

		switch(choice)
		{
			//Insert New Data
			case 1:
				int value;
				printf("\nEnter Value: ");
				scanf("%d", &value);

				insert(&head, value);
				break;
				
			//Delete The Head Node
			case 2:
				//Checks if linked list is empty
				if (isEmpty(head) == 0)
				{
					delete(&head);
				}
				else
				{
					printf("List is Empty!\n");
				}
				break;

			//Print All The Values
			case 3:
				//Checks if linked list is empty
				if (isEmpty(head) == 0)
				{
					printList(head);
				}
				else
				{
					printf("List is Empty!\n");
				}
				break;

			//Exit The Program
			case 0:
				//Free all nodes
				deleteAll(&head);	
				printf("\nGoodbye!\n");
				break;

			default:
				printf("\nInvalid Input!\n");
				break;
		}
	}

    return 0;
}