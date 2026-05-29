//Garage-------------------------------------
/*

#include <stdio.h> 
#include <string.h> 
#define SIZE 10 
struct car { 
    char carNumber[20]; 
    int moved; 
}; 
typedef struct { 
    int top; 
    struct car c[SIZE]; 
} stack; 
int empty_garage(stack *s) { 
    return (s->top == -1); 
} 
int full_garage(stack *s) { 
    return (s->top == SIZE - 1); 
} 
void in(stack *s, struct car c) { 
    if (full_garage(s)) 
        printf("\n**Garage is full**\n"); 
    else { 
        s->top++; 
        s->c[s->top] = c; 
    } 
} 
struct car out(stack *s) { 
    return s->c[s->top--]; 
} 
void garage_status(stack *s) { 
    if (empty_garage(s)) { 
        printf("\n** GARAGE EMPTY **\n"); 
    } else { 
        printf("\n===== CAR LIST =====\n"); 
        for (int i = 0; i <= s->top; i++) { 
            printf("Position %d : %s (Moved %d times)\n", 
                   i, s->c[i].carNumber, s->c[i].moved); 
        } 
        printf("Total Cars: %d\n", s->top + 1); 
    } 
} 
void arrive(stack *s) { 
    struct car temp; 
 
    if (full_garage(s)) { 
        printf("\nSorry, the garage is full at this moment. Try again\n"); 
        return; 
    } 
    printf("Enter Car Number: "); 
    scanf("%s", temp.carNumber); 
    temp.moved = 0; 
    s->top++; 
    s->c[s->top] = temp; 
    printf("%s has arrived at parking space number %d\n", 
           temp.carNumber, s->top); 
} 
void depart(stack *s, stack *s1) { 
    char num[20]; 
    struct car temp; 
    int found = 0; 
    if (empty_garage(s)) { 
        printf("\n**Garage is empty**\n"); 
        return; 
    } 
    printf("Enter Car Number to depart: "); 
    scanf("%s", num); 
    while (!empty_garage(s)) { 
        temp = out(s); 
        if (strcmp(num, temp.carNumber) == 0) { 
            found = 1; 
             temp.moved++; 
            printf("The car %s has departed. It was moved %d times during departure\n", 
                   temp.carNumber, temp.moved); 
            break; 
        } 
        temp.moved++; 
        in(s1, temp); 
    } 
    if (!found) { 
        printf("Sorry, that car is not on this garage\n"); 
    } 
    while (!empty_garage(s1)) { 
        in(s, out(s1)); 
    } 
} 
int main() { 
    stack s, s1; 
    s.top = -1; 
    s1.top = -1; 
    char ch; 
    while (1) { 
        printf("\n===== Parking Garage =====\n"); 
        printf("A - Arrival\n"); 
        printf("D - Departure\n"); 
        printf("S - Show Cars\n"); 
        printf("E - Exit\n"); 
        printf("Enter choice: "); 
        scanf(" %c", &ch); 
        switch (ch) { 
            case 'A': 
                arrive(&s); 
                break; 
            case 'D': 
                depart(&s, &s1); 
                break; 
            case 'S': 
                garage_status(&s); 
                break; 
            case 'E': 
                printf("Exiting program...\n"); 
                return 0; 
            default: 
                printf("Invalid choice!\n"); 
        } 
    } 
    return 0; 
}
    */

//Transaction -----------------------------------------------------------

/*
#include <stdio.h>

int main()
{
    int n;

    printf("Enter the number of users: ");
    scanf("%d", &n);

    int userId[n];
    int startTime[n];
    int numTransactions[n];

    int durations[n][100];

    for(int i = 0; i < n; i++)
    {
        printf("\nEnter data for User %d\n", i + 1);

        printf("Enter user ID: ");
        scanf("%d", &userId[i]);

        printf("Enter starting time: ");
        scanf("%d", &startTime[i]);

        printf("Enter the number of transactions: ");
        scanf("%d", &numTransactions[i]);

        printf("Enter the durations of the transactions: ");

        for(int j = 0; j < numTransactions[i]; j++)
        {
            scanf("%d", &durations[i][j]);
        }
    }

    int currentTime = 0;
    int totalWaitingTime = 0;
    int totalTransactions = 0;

    for(int i = 0; i < n; i++)
    {
        int requestTime = startTime[i];

        for(int j = 0; j < numTransactions[i]; j++)
        {
            if(currentTime < requestTime)
            {
                currentTime = requestTime;
            }
            int waitingTime = currentTime - requestTime;
            int transactionStart = currentTime;
            int transactionEnd = transactionStart + durations[i][j];

            printf("\nUser %d Transaction %d\n", userId[i], j + 1);
            printf("Start time: %d\n", transactionStart);
            printf("End time: %d\n", transactionEnd);
            printf("Waiting time: %d - %d = %d seconds\n",
                   transactionStart, requestTime, waitingTime);

            totalWaitingTime += waitingTime;
            totalTransactions++;

            currentTime = transactionEnd;
            requestTime = transactionEnd;
        }
    }

    float averageWaitingTime = (float)totalWaitingTime / totalTransactions;

    printf("\nAverage waiting time: %.2f seconds\n", averageWaitingTime);

    return 0;
}
    */



/*
//Polisher------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define N_PI 3.1415
#define NUM_WORKERS 10

double uniform_random(double min, double max) {
    return min + ((double)rand() / RAND_MAX) * (max - min);
}

double normal_random(double mean, double stddev) {
    double u1 = ((double)rand() + 1.0) / ((double)RAND_MAX + 1.0);
    double u2 = ((double)rand() + 1.0) / ((double)RAND_MAX + 1.0);
    double z  = sqrt(-2.0 * log(u1)) * cos(2.0 * N_PI * u2);
    return mean + stddev * z;
}

double gen_polish_time() {
    double t;
    do {
        t = normal_random(20.0, 7.0);
    } while (t < 5.0);
    return t;
}

typedef struct {
    double time;
    int    type;    
    int    worker;
} Event;


Event* events = NULL;      
int    event_count = 0;

void schedule_event(double time, int type, int worker) {
    events[event_count].time   = time;
    events[event_count].type   = type;
    events[event_count].worker = worker;
    event_count++;
}

void simulate(int M, int total_items_to_sim) {
    double current_time = 0.0;

    int* machine_busy = (int*)calloc(M, sizeof(int));
    int* machine_worker = (int*)malloc(M * sizeof(int));
   
    int    queue[NUM_WORKERS + 1];            
    int    q_front = 0, q_rear = 0;  

    double wait_start[NUM_WORKERS];      
    double item_polish_time[NUM_WORKERS];

    double total_wait_time = 0.0;
    int    total_items = 0;

    event_count = 0;
   
 
    events = (Event*)malloc(NUM_WORKERS * 2 * sizeof(Event));

    for (int i = 0; i < NUM_WORKERS; i++) {
        double assembly_time = uniform_random(100.0, 300.0);
        schedule_event(assembly_time, 0, i);
    }

    while (total_items < total_items_to_sim) {
        int min_idx = 0;
        for (int i = 1; i < event_count; i++) {
            if (events[i].time < events[min_idx].time)
                min_idx = i;
        }

        double ev_time   = events[min_idx].time;
        int    ev_type   = events[min_idx].type;
        int    ev_worker = events[min_idx].worker;

        events[min_idx] = events[event_count - 1];
        event_count--;

        current_time = ev_time;

        if (ev_type == 0) {  
            double pt = gen_polish_time();
            item_polish_time[ev_worker] = pt;

            int idle = -1;
            for (int m = 0; m < M; m++) {
                if (machine_busy[m] == 0) {
                    idle = m;
                    break;
                }
            }

            if (idle != -1) {
                machine_busy[idle] = 1;
                machine_worker[idle] = ev_worker;
                schedule_event(current_time + pt, 1, ev_worker);
            } else {
                queue[q_rear] = ev_worker;
                q_rear = (q_rear + 1) % (NUM_WORKERS + 1);
                wait_start[ev_worker] = current_time;
            }
        } else {              
            int m;
            for (m = 0; m < M; m++) {
                if (machine_busy[m] && machine_worker[m] == ev_worker)
                    break;
            }
       
            machine_busy[m] = 0;
            total_items++;
            double assembly_time = uniform_random(100.0, 300.0);
            schedule_event(current_time + assembly_time, 0, ev_worker);

            if (q_front != q_rear) {
                int w = queue[q_front];
                q_front = (q_front + 1) % (NUM_WORKERS + 1);

                double wait = current_time - wait_start[w];
                total_wait_time += wait;

                machine_busy[m] = 1;
                machine_worker[m] = w;

                schedule_event(current_time + item_polish_time[w], 1, w);
            }
        }
    }

    double avg_wait = total_wait_time / total_items;
    printf("\n--- Simulation Results ---\n");
    printf("Average waiting time per item with %d polishing machine(s): %.2f seconds\n",
           M, avg_wait);

    free(machine_busy);
    free(machine_worker);
    free(events);
}

int main() {
    int num_machines;
    int num_items;

    srand((unsigned)time(NULL));
   
    printf("Enter the number of Items to Simulate: ");
    if (scanf("%d", &num_items) != 1) return 1;

    printf("Enter the number of Machines to Simulate: ");
    if (scanf("%d", &num_machines) != 1) return 1;
   
    simulate(num_machines, num_items);
   
    return 0;
}
*/

/*
// Soldiers-------------------------------------------------------------------------


#include <stdio.h>
#include <string.h>

int main()
{
    int n;
    char soldiers[100][50];

    printf("Enter value of n: ");
    scanf("%d", &n);

    int total;

    printf("Enter number of soldiers: ");
    scanf("%d", &total);

    printf("Enter soldier names:\n");

    for(int i = 0; i < total; i++)
    {
        scanf("%s", soldiers[i]);
    }

    int alive[100];

    for(int i = 0; i < total; i++)
    {
        alive[i] = 1;
    }

    int remaining = total;
    int index = 0;

    printf("\nElimination Order:\n");

    while(remaining > 1)
    {
        int step = 0;

        while(step < n)
        {
            if(alive[index] == 1)
            {
                step++;
            }

            if(step == n)
            {
                break;
            }

            index = (index + 1) % total;
        }

        printf("%s\n", soldiers[index]);

        alive[index] = 0;
        remaining--;

        while(alive[index] == 0)
        {
            index = (index + 1) % total;
        }
    }

    printf("\nSoldier who escapes:\n");

    for(int i = 0; i < total; i++)
    {
        if(alive[i] == 1)
        {
            printf("%s\n", soldiers[i]);
        }
    }

    return 0;
}
*/
/*
// Last person------------------------------------------------------------


#include <stdio.h>

int main()
{
    int n;

    printf("Enter number of people: ");
    scanf("%d", &n);

    char name[100][50];
    int value[100];

    printf("Enter name and chosen integer:\n");

    for(int i = 0; i < n; i++)
    {
        scanf("%s%d", name[i], &value[i]);
    }

    int count;

    printf("Enter initial count: ");
    scanf("%d", &count);

    int alive[100];

    for(int i = 0; i < n; i++)
    {
        alive[i] = 1;
    }

    int remaining = n;
    int index = 0;

    printf("\nElimination Order:\n");

    while(remaining > 1)
    {
        int step = 0;

        while(step < count)
        {
            if(alive[index] == 1)
            {
                step++;
            }

            if(step == count)
            {
                break;
            }

            index = (index + 1) % n;
        }

        printf("%s\n", name[index]);

        count = value[index];
        alive[index] = 0;
        remaining--;

        while(alive[index] == 0)
        {
            index = (index + 1) % n;
        }
    }

    printf("\nLast person remaining:\n");

    for(int i = 0; i < n; i++)
    {
        if(alive[i] == 1)
        {
            printf("%s\n", name[i]);
        }
    }

    return 0;
}

*/

/*
// Tournament -----------------------------------------------------------


#include <stdio.h>

int max(int a, int b)
{
    if(a > b)
        return a;
    else
        return b;
}

void buildTournament(int tree[], int arr[], int n)
{
    int i;

    for(i = 0; i < n; i++)
    {
        tree[n + i] = arr[i];
    }
    for(i = n - 1; i >= 1; i--)
    {
        tree[i] = max(tree[2 * i], tree[2 * i + 1]);
    }
}

void pqinsert(int tree[], int *n, int elt)
{
    (*n)++;
    tree[*n + *n - 1] = elt;

    int i = *n + *n - 1;

    while(i > 1)
    {
        i = i / 2;
        tree[i] = max(tree[2 * i], tree[2 * i + 1]);
    }
}

int pqmaxdelete(int tree[], int n)
{
    int maximum = tree[1];
    int i;

    for(i = n; i < 2 * n; i++)
    {
        if(tree[i] == maximum)
        {
            tree[i] = -1;
            break;
        }
    }

    i = i / 2;

    while(i >= 1)
    {
        tree[i] = max(tree[2 * i], tree[2 * i + 1]);
        i = i / 2;
    }

    return maximum;
}

void tournamentSort(int arr[], int n)
{
    int tree[200];

    buildTournament(tree, arr, n);

    int sorted[100];

    for(int i = n - 1; i >= 0; i--)
    {
        sorted[i] = pqmaxdelete(tree, n);
    }

    printf("\nSorted Array:\n");

    for(int i = 0; i < n; i++)
    {
        printf("%d ", sorted[i]);
    }
}

int main()
{
    int n;

    printf("Enter number of elements: ");
    scanf("%d", &n);

    int arr[100];

    printf("Enter elements:\n");

    for(int i = 0; i < n; i++)
    {
        scanf("%d", &arr[i]);
    }

    tournamentSort(arr, n);

    return 0;
}
*/
/*
// Havaldars------------------------------------------------------------


#include <stdio.h>
#include <math.h>

int main()
{
    int h1, h2;

    printf("Enter height of MP1: ");
    scanf("%d", &h1);

    printf("Enter height of MP2: ");
    scanf("%d", &h2);

    int levels1 = h1 / 30 + 1;
    int levels2 = h2 / 30 + 1;

    int camps1 = 0, camps2 = 0;
    int base1 = 0, base2 = 0;

    printf("\nMP1 Camp Details\n");

    for(int i = 0; i < levels1; i++)
    {
        int camps = (int)pow(2, i);

        camps1 += camps;

        printf("Level %d : Camps = %d Havildars = %d Subedars = %d Captains = %d Majors = 1\n",
               i + 1, camps, camps * 2, camps, camps);

        if(i == levels1 - 1)
            base1 = camps;
    }

    printf("\nMP2 Camp Details\n");

    for(int i = 0; i < levels2; i++)
    {
        int camps = (int)pow(2, i);

        camps2 += camps;

        printf("Level %d : Camps = %d Havildars = %d Subedars = %d Captains = %d Majors = 1\n",
               i + 1, camps, camps * 2, camps, camps);

        if(i == levels2 - 1)
            base2 = camps;
    }

    int hav1 = camps1 * 2;
    int sub1 = camps1;
    int cap1 = camps1;
    int maj1 = levels1;

    int hav2 = camps2 * 2;
    int sub2 = camps2;
    int cap2 = camps2;
    int maj2 = levels2;

    int personnel1 = hav1 + sub1 + cap1 + maj1;
    int personnel2 = hav2 + sub2 + cap2 + maj2;

    printf("\nReport\n");

    printf("Total Camps in MP1 = %d\n", camps1);
    printf("Total Camps in MP2 = %d\n", camps2);

    printf("Total Personnel in MP1 = %d\n", personnel1);
    printf("Total Personnel in MP2 = %d\n", personnel2);

    printf("\nMP1 Officer Count\n");
    printf("Havildars = %d\n", hav1);
    printf("Subedars = %d\n", sub1);
    printf("Captains/Lieutenants = %d\n", cap1);
    printf("Majors = %d\n", maj1);

    printf("\nMP2 Officer Count\n");
    printf("Havildars = %d\n", hav2);
    printf("Subedars = %d\n", sub2);
    printf("Captains/Lieutenants = %d\n", cap2);
    printf("Majors = %d\n", maj2);

    printf("\nFood and Beverage Camps\n");
    printf("MP1 Base Camps = %d\n", base1);
    printf("MP2 Base Camps = %d\n", base2);

    if(camps1 < camps2)
        printf("\nMP1 is a subset of MP2\n");
    else if(camps2 < camps1)
        printf("\nMP2 is a subset of MP1\n");
    else
        printf("\nMP1 and MP2 are identical\n");

    return 0;
}
*/
