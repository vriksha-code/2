#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 4

int table[SIZE][SIZE];
int emptyRow, emptyCol;

void displayTable() {
    printf("\n");
    for (int i = 0; i < SIZE; i++) {
  
        for (int j = 0; j < SIZE; j++) {
            if (table[i][j] == 0)
                printf("    ");
            else
                printf(" %2d ", table[i][j]);
        }
        printf("\n");
    }
   
}


void moveRight() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (table[i][j] == 0 && j > 0) {
                table[i][j] = table[i][j-1];
                table[i][j-1] = 0;
                emptyRow = i;
                emptyCol = j-1;
                return;
            }
        }
    }
}


void moveLeft() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (table[i][j] == 0 && j < SIZE-1) {
                table[i][j] = table[i][j+1];
                table[i][j+1] = 0;
                emptyRow = i;
                emptyCol = j+1;
                return;
            }
        }
    }
}


void moveUp() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (table[i][j] == 0 && i < SIZE-1) {
                table[i][j] = table[i+1][j];
                table[i+1][j] = 0;
                emptyRow = i+1;
                emptyCol = j;
                return;
            }
        }
    }
}


void moveDown() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (table[i][j] == 0 && i > 0) {
                table[i][j] = table[i-1][j];
                table[i-1][j] = 0;
                emptyRow = i-1;
                emptyCol = j;
                return;
            }
        }
    }
}

int isSolved() {
    int expected = 1;
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++) {
            if (i == SIZE-1 && j == SIZE-1) {
                if (table[i][j] != 0) return 0;
            } else {
                if (table[i][j] != expected++) return 0;
            }
        }
    return 1;
}


void findEmpty() {
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            if (table[i][j] == 0) {
                emptyRow = i;
                emptyCol = j;
            }
}


void moveBlankTo(int targetRow, int targetCol) {
    findEmpty();
    while (emptyRow != targetRow || emptyCol != targetCol) {
        if (emptyRow < targetRow) {
            moveUp();   
            printf("Move blank DOWN:\n");
        } else if (emptyRow > targetRow) {
            moveDown(); 
            printf("Move blank UP:\n");
        } else if (emptyCol < targetCol) {
            moveRight(); 
            printf("Move blank RIGHT:\n");
        } else if (emptyCol > targetCol) {
            moveLeft();  
            printf("Move blank LEFT:\n");
        }
        displayTable();
        findEmpty();
    }
}

int main() {
   
    int initial[SIZE][SIZE] = {
        { 1,  2,  3,  4},
        { 5,  6,  0,  8},
        { 9, 10,  7, 11},
        {13, 14, 15, 12}
    };

    memcpy(table, initial, sizeof(table));

    printf("Initial State:\n");
    displayTable();

    
    printf("\nStep 1: Move blank DOWN (7 slides up):\n");
    moveUp();
    displayTable();

    printf("\nStep 2: Move blank RIGHT (11 slides left):\n");
    moveLeft();
    displayTable();


    printf("\nStep 3: Move blank DOWN (12 slides up):\n");
    moveUp();
    displayTable();

   
    printf("\nFinal Solved State:\n");
    displayTable();

    if (isSolved())
        printf("\nPuzzle Solved Successfully!\n");
    else
        printf("\nPuzzle not fully solved with these steps.\n");

    return 0;
}
--------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 25020
#define BUFFER_SIZE 4096

int main() {

    int sockfd;

    struct sockaddr_in serv_addr, cli_addr;

    socklen_t len;

    char buffer[BUFFER_SIZE];
    char output[BUFFER_SIZE];

 
    int file_count = 1;


    sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    serv_addr.sin_addr.s_addr = INADDR_ANY;


    bind(
        sockfd,
        (struct sockaddr*)&serv_addr,
        sizeof(serv_addr)
    );

    printf(
        "UDP Remote Command Server Running On Port %d...\n",
        PORT
    );

    while(1) {

        memset(buffer, 0, BUFFER_SIZE);

        len = sizeof(cli_addr);
        recvfrom(
            sockfd,
            buffer,
            BUFFER_SIZE,
            0,
            (struct sockaddr*)&cli_addr,
            &len
        );


        if(strcmp(buffer, "exit") == 0) {

            printf("Client Requested Exit\n");

            continue;
        }

      
        if(strcmp(buffer, "time") == 0) {

            strcpy(buffer, "date");
        }

        printf("Running Command : %s\n", buffer);


        FILE *fp = popen(buffer, "r");

        if(fp == NULL) {

            strcpy(output,
                   "Error Running Command");

            sendto(
                sockfd,
                output,
                strlen(output),
                0,
                (struct sockaddr*)&cli_addr,
                len
            );

            continue;
        }

        memset(output, 0, BUFFER_SIZE);

        char line[256];

        while(fgets(line, sizeof(line), fp)) {

            strcat(output, line);
        }

        pclose(fp);
        char filename[100];

        sprintf(
            filename,
            "%s_%d.txt",
            buffer,
            file_count
        );


        for(int i = 0;
            filename[i] != '\0';
            i++) {

            if(filename[i] == ' ') {

                filename[i] = '_';
            }
        }
        FILE *file_ptr = fopen(filename, "w");

        fprintf(file_ptr, "%s", output);

        fclose(file_ptr);

        file_count++;
        char response[BUFFER_SIZE + 200];

        sprintf(
            response,
            "Output Stored In File : %s\n\n%s",
            filename,
            output
        );
        sendto(
            sockfd,
            response,
            strlen(response),
            0,
            (struct sockaddr*)&cli_addr,
            len
        );
    }
    close(sockfd);

    return 0;
}
-----------------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 25020
#define BUFFER_SIZE 4096

int main() {

    int sockfd;

    struct sockaddr_in serv_addr;

    char buffer[BUFFER_SIZE];


    sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    inet_aton(
        "127.0.0.1",
        &serv_addr.sin_addr
    );

    printf("UDP Client Ready\n");

    while(1) {

        printf("\ncmd> ");

        fgets(buffer, BUFFER_SIZE, stdin);

        buffer[strcspn(buffer, "\n")] = 0;

       
        sendto(
            sockfd,
            buffer,
            strlen(buffer),
            0,
            (struct sockaddr*)&serv_addr,
            sizeof(serv_addr)
        );

    
        if(strcmp(buffer, "exit") == 0) {

            break;
        }

        memset(buffer, 0, BUFFER_SIZE);

        recvfrom(
            sockfd,
            buffer,
            BUFFER_SIZE,
            0,
            NULL,
            NULL
        );

        printf(
            "\nServer Response:\n%s\n",
            buffer
        );
    }

    close(sockfd);

    return 0;
}


------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 25020
#define BUFFER_SIZE 1024

int main() {

    int sockfd;

    struct sockaddr_in serverAddr, clientAddr;

    socklen_t addr_size;

    char buffer[BUFFER_SIZE];

    // Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(PORT);
    serverAddr.sin_addr.s_addr = INADDR_ANY;

    // Bind socket
    bind(
        sockfd,
        (struct sockaddr*)&serverAddr,
        sizeof(serverAddr)
    );

    printf(
        "UDP Chat Server Running...\n"
    );

    addr_size = sizeof(clientAddr);

    while(1) {

        memset(buffer, 0, BUFFER_SIZE);

        // Receive client message
        recvfrom(
            sockfd,
            buffer,
            BUFFER_SIZE,
            0,
            (struct sockaddr*)&clientAddr,
            &addr_size
        );

        printf("\nClient : %s\n", buffer);

        // If client exits
        if(strcmp(buffer, "exit") == 0) {

            printf(
                "Client Disconnected\n"
            );

            // Continue waiting
            continue;
        }

        // Server reply
        printf("Server : ");

        fgets(buffer, BUFFER_SIZE, stdin);

        buffer[strcspn(buffer, "\n")] = 0;

        // Send reply
        sendto(
            sockfd,
            buffer,
            strlen(buffer),
            0,
            (struct sockaddr*)&clientAddr,
            addr_size
        );

        // Server exit
        if(strcmp(buffer, "exit") == 0) {

            printf(
                "Server Closed\n"
            );

            break;
        }
    }

    close(sockfd);

    return 0;
}
------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 25020
#define BUFFER_SIZE 1024

int main() {

    int sockfd;

    struct sockaddr_in serverAddr;

    char buffer[BUFFER_SIZE];

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(PORT);

    inet_aton(
        "127.0.0.1",
        &serverAddr.sin_addr
    );

    printf(
        "UDP Chat Client Started...\n"
    );

    while(1) {

        printf("\nClient : ");

        fgets(buffer, BUFFER_SIZE, stdin);

        buffer[strcspn(buffer, "\n")] = 0;

        // Send message
        sendto(
            sockfd,
            buffer,
            strlen(buffer),
            0,
            (struct sockaddr*)&serverAddr,
            sizeof(serverAddr)
        );

        // Client exit
        if(strcmp(buffer, "exit") == 0) {

            printf(
                "Client Closed\n"
            );

            break;
        }

        memset(buffer, 0, BUFFER_SIZE);

        // Receive reply
        recvfrom(
            sockfd,
            buffer,
            BUFFER_SIZE,
            0,
            NULL,
            NULL
        );

        printf(
            "Server : %s\n",
            buffer
        );

        // Server exit
        if(strcmp(buffer, "exit") == 0) {

            printf(
                "Server Closed\n"
            );

            break;
        }
    }

    close(sockfd);

    return 0;
}
