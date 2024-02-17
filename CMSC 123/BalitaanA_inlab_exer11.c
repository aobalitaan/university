// BALITAAN, AXEL O.
// 2022 - 05153

#include <stdio.h>
#include <stdlib.h>
//#include <list.h>	
#include "graph.h"

#define INF 99999

//Implement your functions here

GRAPH *createGraph(int vertices)
{
	GRAPH *G = (GRAPH*) malloc (sizeof(GRAPH));	// Mallocs a graph

	G -> num_vertices = vertices;

	//Initializes adjacency matrix
	G -> matrix = (int**) malloc (sizeof(int*) * vertices);

	for (int i = 0; i < vertices; i++)
	{
		G -> matrix [i] = (int*) malloc (sizeof(int) * vertices);
		for (int j = 0; j < vertices; j++)
		{
			G -> matrix [i][j] = 0;
		}
	}

	return G;
}

void insertEdge(GRAPH *G, int u, int v, int w)
{
	//Checks if vertices are in bounds
	if ((u + 1 > (G -> num_vertices)) || (v + 1 > (G -> num_vertices)))
	{
		printf("Invalid Vertices!\n");
		return;
	}

	//Appends value if valid, adds corresponding weight to the matrix
	G -> matrix [u][v] = w;

	printf("Successfully inserted edge %d %d\n", u+1, v+1);
}

int *createVisited(GRAPH *G)
{
	int *visited = (int*) malloc (sizeof(int) * G -> num_vertices);	//Allocates visited array
	
	for (int i = 0; i < (G -> num_vertices); i++)
	{
		visited[i] = 0;	//Initializes visited to zero/false
	}

	return visited;
}

int *createDistance(GRAPH *G)
{
	int *distance = (int*) malloc (sizeof(int) * G -> num_vertices);	//Allocates distance array
	
	for (int i = 0; i < (G -> num_vertices); i++)
	{
		distance[i] = INF;	//Initializes distance to INF (infinity/99999)
	}

	return distance;
}

int *createParent(GRAPH *G)
{
	int *parent = (int*) malloc (sizeof(int) * G -> num_vertices);	//Allocates parent array
	
	for (int i = 0; i < (G -> num_vertices); i++)
	{
		parent[i] = -1;	//Initializes parent to -1
	}

	return parent;
}

void printMatrix(GRAPH *G)
{
	for (int i = 0; i < (G -> num_vertices); i++)
	{
		for (int j = 0; j < (G -> num_vertices); j++)
		{
			printf("%i\t", G -> matrix[i][j]);
		}
		printf("\n");
	}
}

int findMinDist(int *visited, int *distance, int vertices)	// Function that finds the index of the unvisited vertex with shortest distance
{
	int minDis = INF;	// minDis initialized to INF
	int minDisIndex = -1;

	for (int i = 0; i < vertices; i++)
	{
		if (!visited[i] && (distance[i] <= minDis))	// If an unvisited vertex has a lower distance than the current minDis
		{
			minDis = distance[i];	// stores its index and its distance for next iteration
			minDisIndex = i;
		}
	}

	return minDisIndex;	// Returns the final index with shortest distance
}

void updateValues(int *distance, int *visited, int *parent, int minDisIndex, GRAPH *G)	// Function for updating the values of the arrays
{
	for (int i = 0; i < G->num_vertices; ++i)
	{
		if (!visited[i] && G->matrix[minDisIndex][i] != 0)	// Updates the values only if it is connected to current vertex parent and is not visited
		{
			distance[i] = (((G->matrix[minDisIndex][i] + distance[minDisIndex]) < distance[i]) ? 
							(G->matrix[minDisIndex][i] + distance[minDisIndex]) : distance[i]);
			parent[i] = minDisIndex;
		}
	}
}

void printPath(int *distance, int *parent, int source, int target, GRAPH *G)	// Function for printing the results
{
	if (distance[target] == INF)	// If impossible
	{
		printf("PATH FROM %d to %d: IMPOSSIBLE\nDISTANCE FROM %d to %d: -1\n", 
				source + 1, target + 1, source + 1, target + 1);

		return;
	}

	int *path = createParent(G);	// Initializes a path array
	int temp = target;

	for (int i = (G -> num_vertices - 1); i >= 0; i--)	// Appends at tail starting from the target to source
	{
		path[i] = temp;

		if (temp == source)
		{
			break;
		}

		temp = parent[temp];
	}

	printf("PATH FROM %d to %d: ", source + 1, target + 1);	// Prints path starting from index 0
	for (int i = 0; i < G->num_vertices; i++)
	{
		if (path[i] != -1) printf("%d ", path[i] + 1);
	}
	printf("\nDISTANCE FROM %d to %d: %d\n", source + 1, target + 1, distance[target]);	// Prints distance

	free(path);	// Frees allocated path array
}

void dijkstra(GRAPH *G, int source, int target)	// Dijkstra's algorithm
{
	if (G == NULL || G -> num_vertices == 0)
	{
		return;
	}

	int *distance = createDistance(G);	// Initialize arrays
	int	*visited = createVisited(G);
	int *parent = createParent(G);

	distance[source] = 0;	// Sets initial distance of source

	int minDisIndex = source;
	int minDis = 0;

	for (int i = 0; i < G -> num_vertices; i++)	
	{	
		minDisIndex = findMinDist(visited, distance, G -> num_vertices);	// Finds the lowest distance in unvisited vertices
		visited[minDisIndex] = 1;	// Marks it visited

		if ((minDis == INF) && (minDisIndex == -1))	// Stopping condition for impossible
		{
			break;
		}

		
		updateValues(distance, visited, parent, minDisIndex, G);	// Updates values of the arrays

		if (minDisIndex == target)	// Stopping condition for if already reached target
		{
			break;
		}
	}

	printPath(distance, parent, source, target, G);	// Print results

	free(distance);	// Frees the arrays
	free(visited);
	free(parent);
}

void freeMatrix(GRAPH *G)
{
	//If adjacency matrix is empty doesn't free it
	if (G -> matrix == NULL)
	{
		return;
	}

	//Frees adjacency matrix
	for (int i = 0; i < G ->num_vertices; i ++)
	{
		free(G -> matrix[i]);
	}

	free (G -> matrix);
	G -> matrix = NULL;

	printf("Freed matrix\n");
}

int main() {
	char command;
	int vertices, lines, u, v, w, source, target;

	scanf("%d", &vertices);
	GRAPH *G = createGraph(vertices);

	while(1) {
		scanf(" %c", &command);

		switch(command) {
			case '+':
				scanf(" %d %d %d", &u, &v, &w);
				insertEdge(G, u-1, v-1, w); //there's a -1 since we use 0-indexing in the arrays
				//printf("Successfully inserted edge %d %d\n", u, v);
				break;
			case '#':
				scanf(" %d %d", &source, &target);
				dijkstra(G, source-1, target-1);
				printf("\n");
				break;
			case 'p':
				printf("\nADJACENCY MATRIX: \n");
				printMatrix(G);
				break;
			case 'f':
				freeMatrix(G);
				break;
			case 'Q':
				freeMatrix(G);
				free(G);
				return 0;
			default:
				printf("Unknown command: %c\n", command);
		}
	}
}