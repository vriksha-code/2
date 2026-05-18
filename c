#include <stdio.h>
#include<math.h>
#include<stdlib.h>

int board[20], count = 1;
int isSafe(int row, int col)
{
    for(int i = 1; i < col; i++)
    {
        if(board[i] == row ||
           (abs(board[i] - row) == abs(i - col)))
        {
            return 0;
        }
    }
    return 1;
}

void printBoard(int n)
{
    printf("\n\nSolution %d:\n\n", count++);

    for(int i = 1; i <= n; i++)
    {
        for(int j = 1; j <= n; j++)
        {
            if(board[i] == j)
                printf("Q%d ", i);
            else
                printf(".  ");
        }
        printf("\n\n");
    }
}

void solveNQueen(int col, int n)
{
    for(int row = 1; row <= n; row++)
    {
        if(isSafe(row, col))
        {
            board[col] = row;

            if(col == n)
            {
                printBoard(n);
            }
            else
            {
                solveNQueen(col + 1, n);
            }
        }
    }
}

int main()
{
    int n;

    printf("Enter no. of queens: ");
    scanf("%d", &n);

    solveNQueen(1, n);

    return 0;
}

//2.........

#include <stdio.h>
#define MAX 10
int graph[MAX][MAX];
int color[MAX];
int n;
int m = 3;  

int isSafe(int node, int c)
{
    for(int i = 0; i < n; i++)
    {
        if(graph[node][i] == 1 && color[i] == c)
        {
            return 0;
        }
    }
    return 1;
}

int graphColoringUtil(int node)
{
    
    if(node == n)
    {
        return 1;
    }
    for(int c = 1; c <= m; c++)
    {
        if(isSafe(node, c))
        {
            color[node] = c;
            if(graphColoringUtil(node + 1))
            {
                return 1;
            }
            color[node] = 0;
        }
    }

    return 0;
}

void printSolution()
{
    printf("\n\n\tGRAPH COLORING SOLUTION\n");

    printf("\t--------------------------\n");

    for(int i = 0; i < n; i++)
    {
        printf("\t Node %d -> color %d\n", i + 1, color[i]);
     
    }
}

int main()
{
    printf("Enter number of vertices: ");
    scanf("%d", &n);

    printf("\nEnter adjacency matrix:\n\n");

    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < n; j++)
        {
            scanf("%d", &graph[i][j]);
        }
    }

    for(int i = 0; i < n; i++)
    {
        color[i] = 0;
    }
    if(graphColoringUtil(0))
    {
        printSolution();
    }
    else
    {
        printf("\nSolution does not exist.\n");
    }

    return 0;
}
