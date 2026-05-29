#include <stdio.h>
#include <string.h>

#define MAX 10

struct Car {
    char license[20];
    int moves;
};

struct Car garage[MAX];

int top = -1;

// Arrival Function
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

// Departure Function
void departure(char num[]) {

    if(top == -1) {

        printf("Garage is empty.\n");
        return;
    }

    struct Car temp[MAX];

    int tempTop = -1;

    int found = 0;

    while(top != -1) {

        // Car found
        if(strcmp(garage[top].license, num) == 0) {

            printf("Car %s departed. Moved %d times.\n",
                   garage[top].license,
                   garage[top].moves);

            top--;

            found = 1;

            break;
        }

        // Move blocking cars
        garage[top].moves++;

        tempTop++;

        temp[tempTop] = garage[top];

        top--;
    }

    // Car not found
    if(found == 0) {

        printf("Car not found.\n");
    }

    // Restore cars
    while(tempTop != -1) {

        top++;

        garage[top] = temp[tempTop];

        tempTop--;
    }
}

// Display Function
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

// Main Function
int main() {

    char type;

    char number[20];

    while(1) {

        printf("\nA -> Arrival\n");
        printf("D -> Departure\n");
        printf("E -> Exit\n");

        printf("Enter Choice: ");

        scanf(" %c", &type);

        // Exit
        if(type == 'E' || type == 'e') {

            printf("Program Ended.\n");

            break;
        }

        printf("Enter License Number: ");

        scanf("%s", number);

        // Arrival
        if(type == 'A' || type == 'a') {

            arrival(number);
        }

        // Departure
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
