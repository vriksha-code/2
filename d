#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

#define NUM_WORKERS 10
#define N_ITEMS     100000      

// Uniform distribution [min, max]
double uniform_random(double min, double max) {
    return min + ((double)rand() / RAND_MAX) * (max - min);
}

// Normal distribution (mean, stddev) – Box‑Muller method
double normal_random(double mean, double stddev) {
    double u1 = ((double)rand() + 1.0) / ((double)RAND_MAX + 1.0);
    double u2 = ((double)rand() + 1.0) / ((double)RAND_MAX + 1.0);
    double z  = sqrt(-2.0 * log(u1)) * cos(2.0 * M_PI * u2);
    return mean + stddev * z;
}

// Polishing time: normal(20,7) truncated below 5
double gen_polish_time() {
    double t;
    do {
        t = normal_random(20.0, 7.0);
    } while (t < 5.0);
    return t;
}

// Event structure for the simulation
typedef struct {
    double time;
    int    type;   // 0 = assembly finished, 1 = polishing finished
    int    worker;
} Event;

Event events[50];          // enough for 10 workers + max 3 machines
int   event_count = 0;

void schedule_event(double time, int type, int worker) {
    events[event_count].time   = time;
    events[event_count].type   = type;
    events[event_count].worker = worker;
    event_count++;
}

// Run simulation for a given number of polishing machines M (1,2 or 3)
void simulate(int M) {
    double current_time = 0.0;

    // Machines state: 0 = idle, 1 = busy
    int    machine_busy[3] = {0};
    int    machine_worker[3];

    // Queue of workers waiting for a polishing machine
    int    queue[11];            // size = NUM_WORKERS+1 for circular buffer
    int    q_front = 0, q_rear = 0;   // empty when q_front == q_rear

    double wait_start[NUM_WORKERS];      // time when worker started waiting
    double item_polish_time[NUM_WORKERS];// polishing time of current item

    double total_wait_time = 0.0;
    int    total_items = 0;

    event_count = 0;

    // All workers start assembling immediately
    for (int i = 0; i < NUM_WORKERS; i++) {
        double assembly_time = uniform_random(100.0, 300.0);
        schedule_event(assembly_time, 0, i);
    }

    while (total_items < N_ITEMS) {
        // Find the next event (smallest time)
        int min_idx = 0;
        for (int i = 1; i < event_count; i++) {
            if (events[i].time < events[min_idx].time)
                min_idx = i;
        }

        double ev_time   = events[min_idx].time;
        int    ev_type   = events[min_idx].type;
        int    ev_worker = events[min_idx].worker;

        // Remove this event
        events[min_idx] = events[event_count - 1];
        event_count--;

        current_time = ev_time;

        if (ev_type == 0) {   // Assembly finished
            double pt = gen_polish_time();
            item_polish_time[ev_worker] = pt;

            // Look for an idle polishing machine
            int idle = -1;
            for (int m = 0; m < M; m++) {
                if (machine_busy[m] == 0) {
                    idle = m;
                    break;
                }
            }

            if (idle != -1) {
                // Machine available – start polishing immediately (wait = 0)
                machine_busy[idle] = 1;
                machine_worker[idle] = ev_worker;
                total_wait_time += 0.0;
                schedule_event(current_time + pt, 1, ev_worker);
            } else {
                // No machine free – join the queue
                queue[q_rear] = ev_worker;
                q_rear = (q_rear + 1) % 11;
                wait_start[ev_worker] = current_time;
            }
        } else {              // Polishing finished
            // Find which machine was used
            int m;
            for (m = 0; m < M; m++) {
                if (machine_busy[m] && machine_worker[m] == ev_worker)
                    break;
            }

            // Free the machine
            machine_busy[m] = 0;
            total_items++;

            // Worker starts a new assembly
            double assembly_time = uniform_random(100.0, 300.0);
            schedule_event(current_time + assembly_time, 0, ev_worker);

            // If there are waiting workers, assign the freed machine
            if (q_front != q_rear) {
                int w = queue[q_front];
                q_front = (q_front + 1) % 11;

                double wait = current_time - wait_start[w];
                total_wait_time += wait;

                machine_busy[m] = 1;
                machine_worker[m] = w;
                // Use the polishing time generated when the item was assembled
                schedule_event(current_time + item_polish_time[w], 1, w);
            }
        }
    }

    double avg_wait = total_wait_time / total_items;
    printf("Average waiting time per item with %d polishing machine(s): %.2f seconds\n",
           M, avg_wait);
}

int main() {
    srand((unsigned)time(NULL));
    printf("Factory simulation: %d workers, %d items polished.\n\n",
           NUM_WORKERS, N_ITEMS);

    simulate(1);
    simulate(2);
    simulate(3);

    return 0;
}            
