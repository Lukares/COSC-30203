#include "csapp.h"

void compute(int connfd);

int main(int argc, char **argv) 
{
    int connCount = 0;
    int messCount = 0;
    int listenfd, connfd;
    rio_t rio;
    socklen_t clientlen;
    struct sockaddr_storage clientaddr;  
    char client_hostname[MAXLINE], client_port[MAXLINE];
    char temp[MAXLINE];    

    if (argc != 2) {
	fprintf(stderr, "usage: %s <port>\n", argv[0]);
	exit(0);
    }

    printf("Server listening on port %s. . .\n", argv[1]);

    listenfd = Open_listenfd(argv[1]);

    while (1) {
	clientlen = sizeof(struct sockaddr_storage); 
	connfd = Accept(listenfd, (SA *)&clientaddr, &clientlen);
        Getnameinfo((SA *) &clientaddr, clientlen, client_hostname, MAXLINE, 
                    client_port, MAXLINE, 0);
	connCount++;
	
	sprintf(temp, "[HSSMESG:%d:%d] - Welcome to the Hailstone Sequence Server v1.0!\n", connCount, messCount);
	Rio_writen(connfd, temp, strlen(temp));
	messCount++;

	printf("Connected to (%s, %s)\n", client_hostname, client_port);

	compute(connfd);

	Close(connfd);
	printf("Closing connection for: %s\n ", client_hostname);
	printf("Waiting for connection...\n");

    }
    exit(0);
}
