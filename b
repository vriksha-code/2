#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define WORKERS 10
#define ITEMS 1000


double uniform(double a, double b)
{
    return a + (b - a) * ((double)rand() / RAND_MAX);
}


double normal(double mean, double stddev)
{
    double u1, u2, z;

    u1 = (double)rand() / RAND_MAX;
    u2 = (double)rand() / RAND_MAX;

    z = sqrt(-2 * log(u1)) * cos(2 * M_PI * u2);

    return mean + z * stddev;
}

void simulate(int machines)
{
    double machineFree[10];
    double workerFree[WORKERS];

    double totalWaiting = 0.0;

    int i, j;

    
    for(i = 0; i < machines; i++)
        machineFree[i] = 0.0;

    for(i = 0; i < WORKERS; i++)
        workerFree[i] = 0.0;

    for(i = 0; i < ITEMS; i++)
    {
        int worker = i % WORKERS;

     
        double assemblyTime = uniform(100, 300);

        double assemblyFinish =
            workerFree[worker] + assemblyTime;


        int bestMachine = 0;

        for(j = 1; j < machines; j++)
        {
            if(machineFree[j] < machineFree[bestMachine])
                bestMachine = j;
        }

        double waiting = 0;

        if(machineFree[bestMachine] > assemblyFinish)
            waiting =
                machineFree[bestMachine] - assemblyFinish;

        totalWaiting += waiting;

        double polishingStart =
            fmax(assemblyFinish,
                 machineFree[bestMachine]);

   
        double polishingTime;

        do
        {
            polishingTime = normal(20, 7);
        }
        while(polishingTime < 5);

        double polishingFinish =
            polishingStart + polishingTime;

       
        machineFree[bestMachine] =
            polishingFinish;

        workerFree[worker] =
            polishingFinish;
    }

    printf("\nMachines = %d", machines);
    printf("\nAverage Waiting Time = %.2f seconds\n",
           totalWaiting / ITEMS);
}

int main()
{
    srand(time(NULL));

    simulate(1);
    simulate(2);
    simulate(3);

    return 0;
}
