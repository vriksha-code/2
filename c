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




biconvo

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

struct sockaddr_in serv_addr;
int sockfd, r, w;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[512];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUNIFIED UDP CLIENT.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nCLIENT ERROR: Cannot create socket.\n");
        exit(1);
    }

    printf("\nCLIENT: Connected to unified server.\n");
    printf("--- Multi-Function Client ---\n");
    printf("Commands:\n");
    printf("  B <number>     - Decimal to Binary\n");
    printf("  D <binary>     - Binary to Decimal\n");
    printf("  M <expression> - Math calculation (BODMAS)\n");
    printf("  exit           - Quit\n\n");
    
    int len = sizeof(serv_addr);

    while(1)
    {
        printf("Enter Request: ");
        fgets(buff, 256, stdin);
        buff[strcspn(buff, "\n")] = '\0';

        if((w = sendto(sockfd, buff, strlen(buff), 0, (struct sockaddr*)&serv_addr, len)) < 0)
        {
            printf("\nCLIENT ERROR: Cannot send.\n");
            continue;
        }

        if(strncmp(buff, "exit", 4) == 0)
            break;

        bzero(buff, 512);
        if((r = recvfrom(sockfd, buff, 512, 0, (struct sockaddr*)&serv_addr, &len)) < 0)
            printf("\nCLIENT ERROR: Cannot receive.\n");
        else
        {
            buff[r] = '\0';
            printf("Response: %s\n", buff);
        }
    }
    close(sockfd);
    return 0;
}


#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

struct sockaddr_in serv_addr, cli_addr;
int sockfd, r, w, cli_addr_len;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[256], reply[512];

int precedence(char op)
{
    if(op == '+' || op == '-') return 1;
    if(op == '*' || op == '/') return 2;
    return 0;
}

double applyOp(double a, double b, char op)
{
    if(op == '+') return a + b;
    if(op == '-') return a - b;
    if(op == '*') return a * b;
    if(op == '/') return (b != 0) ? a / b : 0;
    return 0;
}

double solveMath(char *exp)
{
    double values[100];
    char ops[100];
    int vTop = -1, oTop = -1;
    int len = strlen(exp);
    
    for(int i = 0; i < len; i++)
    {
        if(isspace(exp[i])) continue;
        
        if(isdigit(exp[i]) || exp[i] == '.')
        {
            double val = 0;
            int decimal = 0;
            double div = 1;
            while(i < len && (isdigit(exp[i]) || exp[i] == '.'))
            {
                if(exp[i] == '.')
                {
                    decimal = 1;
                    i++;
                    continue;
                }
                if(decimal == 0)
                    val = (val * 10) + (exp[i] - '0');
                else
                {
                    div *= 10;
                    val = val + (exp[i] - '0') / div;
                }
                i++;
            }
            values[++vTop] = val;
            i--;
        }
        else if(exp[i] == '(')
        {
            ops[++oTop] = exp[i];
        }
        else if(exp[i] == ')')
        {
            while(oTop != -1 && ops[oTop] != '(')
            {
                double val2 = values[vTop--];
                double val1 = values[vTop--];
                values[++vTop] = applyOp(val1, val2, ops[oTop--]);
            }
            if(oTop != -1) oTop--;
        }
        else if(exp[i] == '+' || exp[i] == '-' || exp[i] == '*' || exp[i] == '/')
        {
            while(oTop != -1 && precedence(ops[oTop]) >= precedence(exp[i]))
            {
                double val2 = values[vTop--];
                double val1 = values[vTop--];
                values[++vTop] = applyOp(val1, val2, ops[oTop--]);
            }
            ops[++oTop] = exp[i];
        }
    }
    
    while(oTop != -1)
    {
        double val2 = values[vTop--];
        double val1 = values[vTop--];
        values[++vTop] = applyOp(val1, val2, ops[oTop--]);
    }
    
    return values[vTop];
}

void decToBin(int num, char *bin)
{
    char temp[64];
    int i = 0;
    if(num == 0)
        strcpy(bin, "0");
    else
    {
        while(num > 0)
        {
            temp[i++] = (num % 2) + '0';
            num /= 2;
        }
        for(int j = 0; j < i; j++)
            bin[j] = temp[i - 1 - j];
        bin[i] = '\0';
    }
}

int binToDec(char *bin)
{
    int dec = 0, base = 1;
    int len = strlen(bin);
    for(int i = len - 1; i >= 0; i--)
    {
        if(bin[i] == '1')
            dec += base;
        base *= 2;
    }
    return dec;
}

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUNIFIED UDP SERVER (Binary + Decimal + BODMAS Calculator).\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nSERVER ERROR: Cannot create socket.\n");
        exit(1);
    }

    if((bind(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr))) < 0)
    {
        printf("\nSERVER ERROR: Cannot bind.\n");
        close(sockfd);
        exit(1);
    }

    cli_addr_len = sizeof(cli_addr);
    printf("\nSERVER: Waiting for requests...\n");

    while(1)
    {
        bzero(buff, 256);
        bzero(reply, 512);
        
        if((r = recvfrom(sockfd, buff, 256, 0, (struct sockaddr*)&cli_addr, &cli_addr_len)) < 0)
        {
            printf("\nSERVER ERROR: Cannot receive.\n");
            continue;
        }
        buff[r] = '\0';

        if(strncmp(buff, "exit", 4) == 0)
        {
            printf("\nSERVER: Client disconnected.\n");
            continue;
        }

        char op = buff[0];
        char *data = buff + 2;

        printf("\nSERVER: Received request: %s\n", buff);

        if(op == 'B' || op == 'b')
        {
            int num = atoi(data);
            char binStr[64];
            decToBin(num, binStr);
            sprintf(reply, "Decimal %d = Binary %s\n", num, binStr);
            printf("SERVER: Converted Decimal to Binary\n");
        }
        else if(op == 'D' || op == 'd')
        {
            int dec = binToDec(data);
            sprintf(reply, "Binary %s = Decimal %d\n", data, dec);
            printf("SERVER: Converted Binary to Decimal\n");
        }
        else if(op == 'M' || op == 'm')
        {
            double result = solveMath(data);
            sprintf(reply, "Expression: %s\nResult: %.2f\n", data, result);
            printf("SERVER: Solved math expression\n");
        }
        else
        {
            strcpy(reply, "Error: Use B <num> for Dec to Bin, D <binary> for Bin to Dec, M <expression> for Math\n");
        }

        if((w = sendto(sockfd, reply, strlen(reply), 0, (struct sockaddr*)&cli_addr, cli_addr_len)) < 0)
            printf("\nSERVER ERROR: Cannot send.\n");
        else
            printf("SERVER: Response sent.\n");
    }
    close(sockfd);
    return 0;
}

calc client 

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

struct sockaddr_in serv_addr;

int sockfd, r, w;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[128];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP CALCULATOR CLIENT.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nCLIENT ERROR: Cannot create socket.\n");
        exit(1);
    }

    printf("\nCLIENT: Connected to calculator server.\n");
    printf("Format: number operator number (e.g., 5 + 3)\n");
    int len = sizeof(serv_addr);

    while(1)
    {
        printf("\nEnter expression or 'exit': ");
        fgets(buff, 128, stdin);
        buff[strcspn(buff, "\n")] = '\0';

        if((w = sendto(sockfd, buff, strlen(buff), 0, (struct sockaddr*)&serv_addr, len)) < 0)
        {
            printf("\nCLIENT ERROR: Cannot send.\n");
            continue;
        }

        if(strncmp(buff, "exit", 4) == 0)
            break;

        bzero(buff, 128);
        if((r = recvfrom(sockfd, buff, 128, 0, (struct sockaddr*)&serv_addr, &len)) < 0)
            printf("\nCLIENT ERROR: Cannot receive.\n");
        else
        {
            buff[r] = '\0';
            printf("\nResult: %s", buff);
        }
    }
    close(sockfd);
    return 0;
}



#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

struct sockaddr_in serv_addr, cli_addr;

int sockfd, r, w, cli_addr_len;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[128], reply[128];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP CALCULATOR SERVER.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nSERVER ERROR: Cannot create socket.\n");
        exit(1);
    }

    if((bind(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr))) < 0)
    {
        printf("\nSERVER ERROR: Cannot bind.\n");
        close(sockfd);
        exit(1);
    }

    cli_addr_len = sizeof(cli_addr);
    printf("\nSERVER: Waiting for calculation requests...\n");

    while(1)
    {
        bzero(buff, 128);
        if((r = recvfrom(sockfd, buff, 128, 0, (struct sockaddr*)&cli_addr, &cli_addr_len)) < 0)
        {
            printf("\nSERVER ERROR: Cannot receive.\n");
            continue;
        }
        buff[r] = '\0';

        if(strncmp(buff, "exit", 4) == 0)
        {
            printf("\nSERVER: Client disconnected.\n");
            continue;
        }

        char op;
        int a, b;
        sscanf(buff, "%d %c %d", &a, &op, &b);

        switch(op)
        {
            case '+': sprintf(reply, "%d + %d = %d\n", a, b, a + b); break;
            case '-': sprintf(reply, "%d - %d = %d\n", a, b, a - b); break;
            case '*': sprintf(reply, "%d * %d = %d\n", a, b, a * b); break;
            case '/': 
                if(b != 0)
                    sprintf(reply, "%d / %d = %.2f\n", a, b, (float)a / b);
                else
                    sprintf(reply, "Error: Division by zero\n");
                break;
            default: sprintf(reply, "Invalid format. Use: number operator number\n");
        }

        if((w = sendto(sockfd, reply, strlen(reply), 0, (struct sockaddr*)&cli_addr, cli_addr_len)) < 0)
            printf("\nSERVER ERROR: Cannot send.\n");
    }
    close(sockfd);
    return 0;
}


chat client


#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

struct sockaddr_in serv_addr;

int sockfd, r, w;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[256];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP CHAT CLIENT.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nCLIENT ERROR: Cannot create socket.\n");
        exit(1);
    }

    printf("\nCLIENT: Chat started. Type 'exit' to end.\n");
    int len = sizeof(serv_addr);

    while(1)
    {
        printf("\nClient: ");
        fgets(buff, 256, stdin);
        buff[strcspn(buff, "\n")] = '\0';

        if((w = sendto(sockfd, buff, strlen(buff), 0, (struct sockaddr*)&serv_addr, len)) < 0)
        {
            printf("\nCLIENT ERROR: Cannot send.\n");
            continue;
        }

        if(strncmp(buff, "exit", 4) == 0)
        {
            printf("\nCLIENT: Chat ended.\n");
            break;
        }

        bzero(buff, 256);
        if((r = recvfrom(sockfd, buff, 256, 0, (struct sockaddr*)&serv_addr, &len)) < 0)
        {
            printf("\nCLIENT ERROR: Cannot receive.\n");
            continue;
        }
        buff[r] = '\0';
        
        if(strncmp(buff, "exit", 4) == 0)
        {
            printf("\nServer: exit\nCLIENT: Chat ended.\n");
            break;
        }
        
        printf("\nServer: %s", buff);
    }
    close(sockfd);
    return 0;
}


#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

struct sockaddr_in serv_addr, cli_addr;

int sockfd, r, w, cli_addr_len;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[256], reply[256];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP CHAT SERVER.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nSERVER ERROR: Cannot create socket.\n");
        exit(1);
    }

    if((bind(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr))) < 0)
    {
        printf("\nSERVER ERROR: Cannot bind.\n");
        close(sockfd);
        exit(1);
    }

    cli_addr_len = sizeof(cli_addr);
    printf("\nSERVER: Chat started. Waiting for client...\n");

    while(1)
    {
        bzero(buff, 256);
        if((r = recvfrom(sockfd, buff, 256, 0, (struct sockaddr*)&cli_addr, &cli_addr_len)) < 0)
        {
            printf("\nSERVER ERROR: Cannot receive.\n");
            continue;
        }
        buff[r] = '\0';
        
        if(strncmp(buff, "exit", 4) == 0)
        {
            printf("\nSERVER: Client ended chat.\n");
            break;
        }
        
        printf("\nClient: %s", buff);
        printf("\nServer: ");
        fgets(reply, 256, stdin);
        reply[strcspn(reply, "\n")] = '\0';

        if((w = sendto(sockfd, reply, strlen(reply), 0, (struct sockaddr*)&cli_addr, cli_addr_len)) < 0)
            printf("\nSERVER ERROR: Cannot send.\n");
        
        if(strncmp(reply, "exit", 4) == 0)
        {
            printf("\nSERVER: Chat ended.\n");
            break;
        }
    }
    close(sockfd);
    return 0;
}

cmd client

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

struct sockaddr_in serv_addr;

int sockfd, r, w;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[4096];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP COMMAND EXECUTOR CLIENT.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nCLIENT ERROR: Cannot create socket.\n");
        exit(1);
    }

    printf("\nCLIENT: Connected to command server.\n");
    printf("Enter commands like: ls, pwd, date, whoami\nType 'exit' to quit.\n");
    int len = sizeof(serv_addr);

    while(1)
    {
        printf("\ncmd> ");
        fgets(buff, 256, stdin);
        buff[strcspn(buff, "\n")] = '\0';

        if((w = sendto(sockfd, buff, strlen(buff), 0, (struct sockaddr*)&serv_addr, len)) < 0)
        {
            printf("\nCLIENT ERROR: Cannot send.\n");
            continue;
        }

        if(strncmp(buff, "exit", 4) == 0)
            break;

        bzero(buff, 4096);
        if((r = recvfrom(sockfd, buff, 4096, 0, (struct sockaddr*)&serv_addr, &len)) < 0)
            printf("\nCLIENT ERROR: Cannot receive.\n");
        else
        {
            buff[r] = '\0';
            printf("\nServer Output:\n%s", buff);
        }
    }
    close(sockfd);
    return 0;
}

#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

struct sockaddr_in serv_addr, cli_addr;

int sockfd, r, w, cli_addr_len;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[256], reply[4096];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP COMMAND EXECUTOR SERVER.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nSERVER ERROR: Cannot create socket.\n");
        exit(1);
    }

    if((bind(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr))) < 0)
    {
        printf("\nSERVER ERROR: Cannot bind.\n");
        close(sockfd);
        exit(1);
    }

    cli_addr_len = sizeof(cli_addr);
    printf("\nSERVER: Waiting for command requests...\n");

    while(1)
    {
        bzero(buff, 256);
        if((r = recvfrom(sockfd, buff, 256, 0, (struct sockaddr*)&cli_addr, &cli_addr_len)) < 0)
        {
            printf("\nSERVER ERROR: Cannot receive.\n");
            continue;
        }
        buff[r] = '\0';

        if(strncmp(buff, "exit", 4) == 0)
        {
            printf("\nSERVER: Client disconnected.\n");
            continue;
        }

        printf("\nSERVER: Executing command: %s\n", buff);

        FILE *fp = popen(buff, "r");
        if(fp == NULL)
        {
            strcpy(reply, "Error: Cannot execute command\n");
        }
        else
        {
            bzero(reply, 4096);
            char line[256];
            while(fgets(line, sizeof(line), fp))
            {
                strcat(reply, line);
            }
            pclose(fp);
            if(strlen(reply) == 0)
                strcpy(reply, "Command executed successfully (no output)\n");
        }

        if((w = sendto(sockfd, reply, strlen(reply), 0, (struct sockaddr*)&cli_addr, cli_addr_len)) < 0)
            printf("\nSERVER ERROR: Cannot send.\n");
        else
            printf("\nSERVER: Response sent.\n");
    }
    close(sockfd);
    return 0;
}



echo client 

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

struct sockaddr_in serv_addr;

int sockfd, r, w;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char rbuff[128];
char sbuff[128] = "===good morning===";

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP ECHO CLIENT.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nCLIENT ERROR: Cannot create socket.\n");
        exit(1);
    }

    printf("\nCLIENT: Sending message to echo server.\n");

    if((w = sendto(sockfd, sbuff, strlen(sbuff), 0, (struct sockaddr*)&serv_addr, sizeof(serv_addr))) < 0)
    {
        printf("\nCLIENT ERROR: Cannot send message to the echo server.\n");
        close(sockfd);
        exit(1);
    }
    printf("\nCLIENT: Message sent to echo server.\n");

    int len = sizeof(serv_addr);
    bzero(rbuff, 128);
    if((r = recvfrom(sockfd, rbuff, 128, 0, (struct sockaddr*)&serv_addr, &len)) < 0)
        printf("\nCLIENT ERROR: Cannot receive message from server.\n");
    else
    {
        rbuff[r] = '\0';
        printf("\nCLIENT: Message from echo server: %s\n", rbuff);
    }

    close(sockfd);
    return 0;
}


#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

struct sockaddr_in serv_addr, cli_addr;

int sockfd, r, w, cli_addr_len;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[128];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP ECHO SERVER.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nSERVER ERROR: Cannot create socket.\n");
        exit(1);
    }

    if((bind(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr))) < 0)
    {
        printf("\nSERVER ERROR: Cannot bind.\n");
        close(sockfd);
        exit(1);
    }

    cli_addr_len = sizeof(cli_addr);
    for( ; ; )
    {
        printf("\nSERVER: Waiting for messages...Press Ctrl + c to stop:\n");
        
        bzero(buff, 128);
        if((r = recvfrom(sockfd, buff, 128, 0, (struct sockaddr*)&cli_addr, &cli_addr_len)) < 0)
        {
            printf("\nSERVER ERROR: Cannot receive message from client.\n");
        }
        else
        {
            buff[r] = '\0';
            printf("\nSERVER: Received %s from %s.\n", buff, inet_ntoa(cli_addr.sin_addr));

            if((w = sendto(sockfd, buff, strlen(buff), 0, (struct sockaddr*)&cli_addr, cli_addr_len)) < 0)
                printf("\nSERVER ERROR: Cannot send message to the client.\n");
            else
                printf("\nSERVER: Echoed back %s to %s.\n", buff, inet_ntoa(cli_addr.sin_addr));
        }
    }
}

time client


#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

struct sockaddr_in serv_addr;

int sockfd, r, w;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[256];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP TIME CLIENT.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nCLIENT ERROR: Cannot create socket.\n");
        exit(1);
    }

    printf("\nCLIENT: Connected to time server.\n");
    int len = sizeof(serv_addr);

    while(1)
    {
        printf("\nEnter 'time' or 'exit': ");
        fgets(buff, 256, stdin);
        buff[strcspn(buff, "\n")] = '\0';

        if((w = sendto(sockfd, buff, strlen(buff), 0, (struct sockaddr*)&serv_addr, len)) < 0)
        {
            printf("\nCLIENT ERROR: Cannot send.\n");
            continue;
        }

        if(strncmp(buff, "exit", 4) == 0)
            break;

        bzero(buff, 256);
        if((r = recvfrom(sockfd, buff, 256, 0, (struct sockaddr*)&serv_addr, &len)) < 0)
            printf("\nCLIENT ERROR: Cannot receive.\n");
        else
        {
            buff[r] = '\0';
            printf("\nServer Response:\n%s", buff);
        }
    }
    close(sockfd);
    return 0;
}


#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct sockaddr_in serv_addr, cli_addr;

int sockfd, r, w, cli_addr_len;
unsigned short serv_port = 25020;
char serv_ip[] = "127.0.0.1";
char buff[128], reply[256];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, (&serv_addr.sin_addr));

    printf("\nUDP TIME SERVER.\n");

    if((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        printf("\nSERVER ERROR: Cannot create socket.\n");
        exit(1);
    }

    if((bind(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr))) < 0)
    {
        printf("\nSERVER ERROR: Cannot bind.\n");
        close(sockfd);
        exit(1);
    }

    cli_addr_len = sizeof(cli_addr);
    printf("\nSERVER: Waiting for time requests...\n");

    while(1)
    {
        bzero(buff, 128);
        if((r = recvfrom(sockfd, buff, 128, 0, (struct sockaddr*)&cli_addr, &cli_addr_len)) < 0)
        {
            printf("\nSERVER ERROR: Cannot receive.\n");
            continue;
        }
        buff[r] = '\0';

        if(strncmp(buff, "exit", 4) == 0)
        {
            printf("\nSERVER: Client disconnected.\n");
            continue;
        }

        if(strncmp(buff, "time", 4) == 0 || strncmp(buff, "TIME", 4) == 0)
        {
            time_t t = time(NULL);
            struct tm *tm_info = localtime(&t);
            strftime(reply, 256, "Current Time: %H:%M:%S\nCurrent Date: %d-%m-%Y\n", tm_info);
        }
        else
        {
            strcpy(reply, "Unknown command. Type 'time' for current time.\n");
        }

        if((w = sendto(sockfd, reply, strlen(reply), 0, (struct sockaddr*)&cli_addr, cli_addr_len)) < 0)
            printf("\nSERVER ERROR: Cannot send.\n");
    }
    close(sockfd);
    return 0;
}
