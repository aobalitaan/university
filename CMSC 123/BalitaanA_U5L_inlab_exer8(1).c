// BALITAAN, AXEL O.
// 2022-05153
// CMSC 123 U5L

#include "hashtable.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

//Function that prints the data of the hash table
void printTable(HASH_TABLE_PTR H){
	if(isEmpty(H)) {
		printf("*empty\n");
		return;
	}

	for(int index=0; index<H->tableSize; index++){
		printf("Cell#%d: ", index);
		if(H->list[index]){
			printf("%s\n", H->list[index]);
		}else{
			printf("*empty*\n");
		}
	}
}

//Create your own hash functions

HASH_TABLE_PTR createHashTable(uint tableSize)
{
	if (tableSize == 0)		//Only accepts non-zero positive integer
	{
		return NULL;
	}

	HASH_TABLE_PTR H = (HASH_TABLE_PTR) malloc(sizeof(HASH_TABLE));	//Mallocs a new hashtable ptr

	//Initialize sizes
	H -> size = 0;	
	H -> tableSize = tableSize;

	H -> list = (STRING_ARRAY_PTR) malloc(sizeof(STRING) * tableSize);	//Mallocs hash table array

	for (int i = 0; i < tableSize; i++)	//Initially, sets each cell to NULL
	{
		H -> list[i] = NULL;
	} 
	return H;
}

uint isEmpty(HASH_TABLE_PTR H)
{
	if (H -> size == 0)	//Checks if hash table is empty using size counter
	{
		return 1;
	}
	return 0;
}

uint isFull(HASH_TABLE_PTR H)
{
	if (H -> size == H -> tableSize)	//Checks if hashtable is full
	{
		return 1;
	}
	return 0;
}

uint computeKey(STRING key)
{	
	//Converts key to sum of odd ascii values
	uint ascii = 0;

	for (int i = 0; i < strlen(key); i++)
	{
		if (key[i] % 2 == 1)
		{
			ascii += key[i];
		}
	}

	return ascii;
}

uint computeHash(uint colli, HASH_TABLE_PTR H, STRING key)
{
	//Computes hash value for key

	//Secondary hashing function
	uint h2_k = 37 - computeKey(key) % 26;
	uint p_i = colli * h2_k;

	//Computes hash
	uint hash = (computeKey(key) + p_i) % H -> tableSize;

	return hash;
}

void put(HASH_TABLE_PTR H, STRING key, STRING data)
{
	//Puts data to hashtable through corresponding key

	if (H == NULL)
	{
		printf("Requirements not met! Can't Insert.\n");
		return;
	}

	if (isFull(H))
	{
		printf("Hash Table is Full!\n");
		return;
	}

	//Finds corresponding key val
	uint colli = 0;
	uint startHash = computeHash(colli, H, key);	//Stores original hash position
	uint hash = startHash;

	while (1)
	{
		if (H -> list[hash] == NULL)	//If hash position already empty, breaks loop
		{
			break;
		}

		colli++;	//Iterates collision count, if corresponding hash is occupied
		hash = computeHash(colli, H, key);	//Computes corresponding hash index

		if (hash == startHash)	//If already looped and didn't find an empty spot
		{
			printf("Insertion Failed!\n");
			return;
		}
	}

	H -> list[hash] = (STRING)malloc(sizeof(char) * strlen(data));	//Allocates a string in the hashtable
	strcpy(H -> list[hash], data);	//Copy data to hashtable
	H -> size++;	//Iterates size
}

STRING *modifiedFind(HASH_TABLE_PTR H, STRING key, STRING data) // ADDITIONAL FUNCTION
{
	//Modified version of find function that instead returns a pointer to H->list[i], for easier (/reusable code) erase function

	if ((H == NULL) || (isEmpty(H)) || key == NULL || key[0] == '\0' || data == NULL || data[0] == '\0')
	{
		printf("Requirements not met! Can't perform this operation.\n");
		return NULL;
	}

	//Similar to hash finding in put, with some modifications in condition
	uint colli = 0;
	uint startHash = computeHash(colli, H, key);
	uint hash = startHash;

	while (1)
	{
		//Checks if string in hashtable is same to the data instead
		//Doesn't stop even if found a NULL:
		//If for example, we have a table (linear) like [1][2][3], and 2 was deleted = [1][NULL][3],
		//If 3 will be deleted, probing should still continue even after passing the now NULL
		if ((H -> list[hash] != NULL) && (strcmp(H -> list[hash], data) == 0))
		{
			break;
		}

		colli++;
		hash = computeHash(colli, H, key);

		if (hash == startHash)	//If already looped and didn't find the corresponding data
		{
			return NULL;
		}
	}

	return &(H -> list[hash]); //Returns a pointer to H->list[hash]
}

STRING find(HASH_TABLE_PTR H, STRING key, STRING data)
{
	//Regular find function

	STRING *node = modifiedFind(H, key, data);	//Gets corresponding &(H->list[hash]), contains requirements such as isEmpty checker

	if (node == NULL)	//If not found
	{
		return NULL;
	}

	return (*node);	//If found, dereferences the node pointer to get address of the string
}

STRING erase(HASH_TABLE_PTR H, STRING key, STRING data)
{
	if (isEmpty(H))
	{
		printf("Hash Table is Empty!\n");
		return NULL;
	}

	STRING *toDel = modifiedFind(H, key, data);	//Gets corresponding &(H->list[hash]) 

	if (toDel == NULL) //If not found
	{
		return NULL;
	}

	//Copies what was to be deleted
	STRING delCopy = (STRING) malloc (sizeof(char) * strlen(*toDel));
	strcpy(delCopy, *toDel);
	
	free(*toDel);	//frees (H -> list [hash])
	*toDel = NULL;	//Sets H -> list [hash] to NULL
	H -> size --;	//Decrements size
	return delCopy;	//Return copied del value
}

void destroy(HASH_TABLE_PTR H)
{
	if (H == NULL)
	{
		return;
	}

	for (int i = 0; i < H -> tableSize; i++)
	{
		if (H -> list[i] != NULL)	//If cell not empty, empties it
		{
			free(H -> list[i]);	//Frees string
			H -> list[i] = NULL;	//Set pointer to NULL
			H -> size--;	//Decrements size
		}	
	}
}

//Insert the implementations of the functions found in the header file

int main(){

	char command;
	STRING key;
	STRING data;
	STRING result;

	uint tsize;
	HASH_TABLE_PTR H;
	
	// get table size then maxsize
	scanf("%d\n", &tsize); 
	H = createHashTable(tsize);

	// assume max key size is 20
	key = (STRING)malloc(sizeof(char)*20);
	key[0] = '\0';
	// assume max data size is 100
	data = (STRING)malloc(sizeof(char)*100);
	data[0] = '\0';

	while(1){
		scanf(" %c", &command);

		switch(command){
			case '+':
				scanf(" k:%s d:%s", key, data);
				printf("Inserting data %s with key %s\n", data, key);
				put(H, key, data);
				break;
			case '-':
				scanf(" k:%s d:%s", key, data);
				printf("Deleting data with key %s\n", key);
				result = erase(H, key, data); 
				printf("Deleted %s\n", result);
				// result is unused. print if u want
				break;
			case '?':
				scanf(" k:%s d:%s", key, data);
				printf("Searching data with key: %s. Location: %p\n", key, find(H, key, data));
				// (nil) means NULL pointer
				break;
			case 'p':
				printf("Hash Table: \n");
				printTable(H);
				printf("\n");
				break;
			case 'E':
				printf("Hash table %s empty.\n", isEmpty(H)?"is":"is not");
				break;
			case 'F':
				printf("Hash table %s full.\n", isFull(H)?"is":"is not");
				break;
			case 'C':
				printf("Deleting all contents.\n");
				destroy(H);
				break;
			case 'Q':
				free(key); free(data);
				destroy(H); // ensure deletion
				free(H->list);
				free(H);
				return 0;
			default:
				printf("Unknown command: %c\n", command);
		}
	}
	
	return 0;
}
