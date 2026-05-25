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
