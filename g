#include <stdio.h>
#include <string.h>

#define MAX 10

struct Car {
    char license[20];
    int moves;
};

struct Car garage[MAX];

int top = -1;


void arrival(char num[]) {

    if(top == MAX - 1) {

        printf("Garage Full! Car %s cannot enter.\n", num);
        return;
    }

    top++;

    strcpy(garage[top].license, num);

    garage[top].moves = 0;

    printf("Car %s arrived.\n", num);
}


void departure(char num[]) {

    if(top == -1) {

        printf("Garage is empty.\n");
        return;
    }

    struct Car temp[MAX];

    int tempTop = -1;

    int found = 0;

    while(top != -1) {

      
        if(strcmp(garage[top].license, num) == 0) {

            printf("Car %s departed. Moved %d times.\n",
                   garage[top].license,
                   garage[top].moves);

            top--;

            found = 1;

            break;
        }

        garage[top].moves++;

        tempTop++;

        temp[tempTop] = garage[top];

        top--;
    }


    if(found == 0) {

        printf("Car not found.\n");
    }

 
    while(tempTop != -1) {

        top++;

        garage[top] = temp[tempTop];

        tempTop--;
    }
}


void display() {

    if(top == -1) {

        printf("Garage Empty.\n");
        return;
    }

    printf("\nGarage Status:\n");

    for(int i = top; i >= 0; i--) {

        printf("%s  Moves:%d\n",
               garage[i].license,
               garage[i].moves);
    }
}


int main() {

    char type;

    char number[20];

    while(1) {

        printf("\nA -> Arrival\n");
        printf("D -> Departure\n");
        printf("E -> Exit\n");

        printf("Enter Choice: ");

        scanf(" %c", &type);

  
        if(type == 'E' || type == 'e') {

            printf("Program Ended.\n");

            break;
        }

        printf("Enter License Number: ");

        scanf("%s", number);


        if(type == 'A' || type == 'a') {

            arrival(number);
        }

        
        else if(type == 'D' || type == 'd') {

            departure(number);
        }

        else {

            printf("Invalid Choice.\n");
        }

        display();
    }

    return 0;
}


-----------------------------------

#include <stdio.h>

#define MAX_USERS 100
#define MAX_TRANS 100


struct User
{
    int id;
    int startTime;
    int numTransactions;
    int duration[MAX_TRANS];
};

int main()
{
    struct User users[MAX_USERS];

    int n;

    printf("Enter number of users: ");
    scanf("%d", &n);


    for(int i = 0; i < n; i++)
    {
        printf("\nEnter data for User %d\n", i + 1);

        printf("Enter User ID: ");
        scanf("%d", &users[i].id);

        printf("Enter Starting Time: ");
        scanf("%d", &users[i].startTime);

        printf("Enter Number of Transactions: ");
        scanf("%d", &users[i].numTransactions);

        printf("Enter Transaction Durations: ");

        for(int j = 0; j < users[i].numTransactions; j++)
        {
            scanf("%d", &users[i].duration[j]);
        }
    }

    int currentTime = 0;

    float totalWaitingTime = 0;

    int totalTransactions = 0;

    printf("\n----- Simulation Output -----\n");

    
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < users[i].numTransactions; j++)
        {
            int startTime;

         
            if(currentTime < users[i].startTime)
            {
                startTime = users[i].startTime;
            }
            else
            {
                startTime = currentTime;
            }

  
            int waitingTime =
                startTime - users[i].startTime;

         
            int endTime =
                startTime + users[i].duration[j];

     
            printf("\nUser %d Transaction %d\n",
                   users[i].id,
                   j + 1);

            printf("Start Time   : %d\n",
                   startTime);

            printf("End Time     : %d\n",
                   endTime);

            printf("Waiting Time : %d seconds\n",
                   waitingTime);

           
            totalWaitingTime += waitingTime;

            totalTransactions++;


            currentTime = endTime;
        }
    }


    float average =
        totalWaitingTime / totalTransactions;

    printf("\nAverage Waiting Time = %.2f seconds\n",
           average);

    return 0;
}

-------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define WORKERS 10
#define ITEMS 1000


double uniform_random(double min, double max)
{
    return min +
           ((double)rand() / RAND_MAX) *
           (max - min);
}


double normal_random(double mean, double stddev)
{
    double u1, u2, z;

    u1 = ((double)rand() + 1.0) /
         ((double)RAND_MAX + 1.0);

    u2 = ((double)rand() + 1.0) /
         ((double)RAND_MAX + 1.0);

    z = sqrt(-2.0 * log(u1)) *
        cos(2.0 * M_PI * u2);

    return mean + stddev * z;
}


void simulate(int machines)
{
  
    double machineFree[machines];

  
    double workerFree[WORKERS];


    for(int i = 0; i < machines; i++)
    {
        machineFree[i] = 0;
    }


    for(int i = 0; i < WORKERS; i++)
    {
        workerFree[i] = 0;
    }

    double totalWaiting = 0;


    for(int item = 0; item < ITEMS; item++)
    {
        
        int worker = item % WORKERS;

     
        double assemblyTime =
            uniform_random(100, 300);

     
        double assemblyFinish =
            workerFree[worker] + assemblyTime;

      
        double polishingTime;

        do
        {
            polishingTime =
                normal_random(20, 7);

        } while(polishingTime < 5);


        int selectedMachine = 0;

        for(int i = 1; i < machines; i++)
        {
            if(machineFree[i] <
               machineFree[selectedMachine])
            {
                selectedMachine = i;
            }
        }

      
        double polishingStart;

        if(machineFree[selectedMachine] >
           assemblyFinish)
        {
            polishingStart =
                machineFree[selectedMachine];
        }
        else
        {
            polishingStart =
                assemblyFinish;
        }

     
        double waiting =
            polishingStart - assemblyFinish;

        totalWaiting += waiting;

      
        double polishingEnd =
            polishingStart + polishingTime;

       
        machineFree[selectedMachine] =
            polishingEnd;

  
        workerFree[worker] =
            polishingEnd;
    }


    double average =
        totalWaiting / ITEMS;

    printf("\nMachines : %d\n", machines);

    printf("Average Waiting Time : %.2lf seconds\n",
           average);
}

int main()
{
   
    srand(time(NULL));

    printf("Factory Simulation\n");

    
    simulate(1);

  
    simulate(2);

    
    simulate(3);

    return 0;
}
