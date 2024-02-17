//AXEL O. BALITAAN
//CMSC 123 U5L
//2022-05153

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Import file
#include "isEqualAB.h"

//Checks if the stack is empty
int isEmpty(LIST *L)
{
    //Checks if the head is currently pointing to a node
    if (L -> head == NULL)
    {
        //If not, return 1 (meaning the stack is empty)
        return 1;
    }
    //Otherwise returns 0 (the stack has content)
    return 0;
}

//Creates the stack
LIST *createStack()
{
    //Mallocs the stack
    LIST *stack = (LIST*)malloc(sizeof(LIST));
    //Initializes the stack->head to point to nothing
    stack -> head == NULL;
    //returns the stack
    return stack;
}

//Creates new nodes
NODE *createNode(int i)
{
    //Mallocs the node
    NODE *new_node = (NODE*)malloc(sizeof(NODE));
    //Puts the value inside the node
    new_node -> value = i;
    //Points node->next temporarily to null
    new_node -> next = NULL;
    //returns the node created
    return new_node;
}

//Pushes nodes on the stack
void push(LIST *stack, NODE *new_node)
{
    //Points the node->next to the current head node
    new_node -> next = stack -> head;
    //Points the top of the stack to the new node
    stack -> head = new_node;
}

//Pops node of the stack
int pop(LIST *stack)
{
    //Points temporarily to the node to be deleted (top)
    NODE *del = stack -> head;
    //Stores the value inside the new node
    int del_value = stack -> head -> value;
    //Adjusts the head pointer of the stack
    stack -> head = stack -> head -> next;
    //Frees the node to be deleted
    free(del);
    //Returns the value inside the deleted node
    return del_value;
}

void printStack(LIST *L)
{
    //If the stack is empty, just prints empty and returns early
    if (L -> head == NULL)
    {
        printf("Empty\n");
        return;
    }

    //Copies the head of the stack
    NODE *temp = L -> head;

    //Prints the contents of the stack
    while(temp != NULL)
    {  
        //Converts it back to the original letters
        if (temp -> value == 1)
        {
            printf("b\n");
        }
        else
        {
            printf("a\n");
        }
        //Iterates temp
        temp = temp -> next;
    }
}

//Frees all nodes and the stack
void freeAll(LIST *stack)
{
    //Frees all nodes
    NODE *head = stack -> head;
    NODE *del_temp;

    //Iterates through the nodes
    while (head != NULL)
    {
        //Stores temp
        del_temp = head;
        //Adjusts head
        head = head -> next;
        //Frees the temp (or the previous head)
        free(del_temp); 
    }

    //Free the stack
    free(stack);
}

//Checks if 'a' and 'b' are equal
int isEqualAB(char str[])
{
    //Create stack
    LIST *stack = createStack();
    //Create new node
    NODE *new_node;

    //Loops throught the string
    for (int i = 0; i < strlen(str); i++)
    {
        //Gets the current character
        char letter = str[i];

        //Converts it to int and creates corresponding node
        if (letter == 'a')
        {
            new_node = createNode(0);
        }
        else if (letter == 'b')
        {
            new_node = createNode(1);
        }
        else
        {
            //If not 'a' or 'b', just continues the loop
            continue;
        }

        //If the stack is empty or the top is same, push the new node
        if (isEmpty(stack) || ((stack -> head -> value) == (new_node -> value)))
        {
            push(stack, new_node);
        }
        //If the top is different and stack is not empty, pops the top
        else if (!isEmpty(stack))
        {
            pop(stack);
        }
    }

    //Prints the stack (and if empty prints empty)
    printStack(stack);

    //Returns whether the stack is empty or have contents after
    int isStackEmpty = isEmpty(stack);

    //Frees all stack, and nodes
    freeAll(stack);

    //Returns whether the stack was empty
    return isStackEmpty;
}

//Main function
int main()
{
    //String sample input
    char str[100];
    printf("Enter string: ");
    scanf("%[^\n]s", str);

    //If the string is empty, early returns and doesn't proceed in the later algo
    if (strlen(str) == 0)
    {
        printf("The string is empty.\n");
        return 0;
    }

    //Printing whether equal or not
    if(isEqualAB(str))
    {
        printf("The a's are equal to b's.\n");
    }
    else
    {
        printf("The a's are NOT equal to b's.\n");  
    }

    return 0;
}