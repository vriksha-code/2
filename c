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
