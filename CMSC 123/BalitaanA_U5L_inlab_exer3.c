// AXEL O. BALITAAN
// 2022-05153
// BST ADT with insert and search function

#include "BST.h"
#include <stdio.h>
#include <stdlib.h>

//Creates a new BST Node
BST_NODE* createBSTNode(int key, BST_NODE* L, BST_NODE* R, BST_NODE* P)
{
	//Mallocs new node
	BST_NODE *newNode = (BST_NODE*)malloc(sizeof(BST_NODE));

	//Initializes BST nodes attributes
	newNode -> left = L;
	newNode -> right = R;
	newNode -> parent = P;
	newNode -> key = key;
	newNode -> height = 0;
	
	//Returns the created node
	return newNode;
}

//Creates a BST
BST* createBST(int max)
{
	//Mallocs a new BST
	BST *B = (BST*) malloc (sizeof(BST));

	//Initializes BST attributes
	B -> root = NULL;
	B -> maxSize = max;
	B -> size = 0;
	
	//Returns initialized tree
	return B;
}

//Checks if BST is empty
int isEmpty(BST* B)
{
	if (B -> root == NULL)
	{
		return 1;
	}
	return 0;
}

//Checks if BST is Full
int isFull(BST* B)
{
	if ((B -> size) >= (B -> maxSize))
	{
		return 1;
	}
	return 0;
}

//Checks max height from left and right tree
int max(int leftH, int rightH)
{
	if (leftH >= rightH)
	{
		return leftH;
	}
	return rightH;
}

//Inserts BST node to the BST
void insert(BST* B, BST_NODE* node)
{

	//Initializes pointers
	BST_NODE** temp = &(B -> root);
	BST_NODE *prevNode;
	BST_NODE *currNodePtr = (*temp);

	while (1)
	{
		//Stores a copy of previous node (for parents)
		prevNode = currNodePtr;
		//Iterates pointer
		currNodePtr = (*temp);

		//If the current pointer is already NULL, stops
		if (currNodePtr == NULL)
		{
			break;
		}

		//If key is less than curr node, goes to the left
		if ((node -> key) <= (currNodePtr -> key))
		{
			temp = &(currNodePtr -> left);
		}
		//else, goes to the right
		else if ((node -> key) >= (currNodePtr -> key))
		{
			temp = &(currNodePtr -> right);
		}
	}

	//Initializes the node's parent
	node -> parent = prevNode;
	//Attaches the node
	(*temp) = node;
	//Iterates BST size
	B->size++;

	//Updates affected heights
	int leftH;
	int rightH;

	while (1)
	{
		//If node is null, reached root
		if (node == NULL)
		{
			//ends loop
			break;
		}

		//Height of left and right initially set as -1
		leftH = -1;
		rightH = -1;

		//If there is a left child, gets its height
		if (node -> left != NULL)
		{
			leftH = node -> left -> height;
		}
		//If there is a right child, gets its height
		if (node -> right != NULL)
		{
			rightH = node -> right -> height;
		}
		
		//Gets max of left and right chilren height and adds 1 for the height of current node
		node -> height = max(leftH, rightH) + 1;

		//Iterates to the parent/above of the node in tree
		node = node -> parent;	
	}
}

//Search function
BST_NODE* search(BST* B, int key)
{
	//Initialization for return value
	BST_NODE* keyNode = NULL;

	//Points to the root of the tree
	BST_NODE* temp = B -> root;

	while (1)
	{
		//If already reached the end, breaks
		if (temp == NULL)
		{
			break;
		}

		//If key found break
		if (temp -> key == key)
		{
			keyNode = temp;
			break;
		}
		//if key less than curr node key, goes to the left
		else if (key < (temp -> key))
		{
			temp = temp -> left;
		}
		//else, goes to the right
		else if (key > (temp -> key))
		{
			temp = temp -> right;
		}
	}

	//return keyNode
	return keyNode;
}

// a recursive subroutine to display the BST in tree mode
void showTreeHelper(BST_NODE* node, int tabs){

	if(!node) return; // node is null, do nothing
	showTreeHelper(node->right, tabs + 1);
	for(int i=0; i<tabs; i++) printf("\t");
	printf("%d(%d)\n", node->key, node->height);
	showTreeHelper(node->left, tabs + 1);

}


void showTree(BST* B){
	showTreeHelper(B->root, 0);
}


int main(){

	char command;
	int key, result;
	
	BST *B = createBST(100);
	BST_NODE* node;
	while(1){
		scanf(" %c", &command);

		switch(command){
			case '+':
				scanf("%d", &key);
				printf("Inserting key: %d\n", key);
				insert(B, createBSTNode(key, NULL, NULL, NULL));
				break;
			case '?':
				scanf("%d", &key);
				printf("Searching node with key: %d. Location: %p\n", key, search(B, key));
				// (nil) means NULL pointer
				break;
			case 'p':
				printf("Tree (rotated +90 degrees): \n");
				showTree(B);
				printf("\n");
				break;
			case 'E':
				printf("BST %s empty.\n", isEmpty(B)?"is":"is not");
				break;
			case 'F':
				printf("BST %s full.\n", isFull(B)?"is":"is not");
				break;
			/* for the postlab, uncomment this
			case '<':
				printf("Pre-order Traversal: ");
				preorderWalk(B);
				printf("\n");
				break;
			case '>':
				printf("Post-order Traversal: ");
				postorderWalk(B);
				printf("\n");
				break;
			case '/':
				printf("In-order Traversal: ");
				inorderWalk(B);
				printf("\n");
				break;
			*/
			case 'Q':
				return 0;
			default:
				printf("Unknown command: %c\n", command);
		}
	}

	return 0;
}