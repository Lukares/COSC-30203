#include "csapp.h"

int main(int argc, char **argv) 
{
    int clientfd;
    int number;
    char *host, *port, buf[MAXLINE];
    rio_t rio;

    if (argc != 3) {
	fprintf(stderr, "usage: %s <host> <port>\n", argv[0]);
	exit(0);
    }
    host = argv[1];
    port = argv[2];
	
	while(1)
	{
	    clientfd = Open_clientfd(host, port);
	    if(clientfd > 0) 
	    {
		printf("Connection established to %s on port %s\n", argv[1], argv[2]);
		break;
    	    } 
	    else
	    {
		Close(clientfd);
		exit(0);
	    } 
	}
    

    	Rio_readinitb(&rio, clientfd);
	Rio_readlineb(&rio, buf, MAXLINE);
	fputs(buf, stdout);

	while(1)
	{
 	   printf("\nPlease enter a positive integer to initiate the hailstone sequence (Ctrl-d to quit): \n");

    		do
		{
    			if(Fgets(buf, MAXLINE, stdin) == NULL)
			{
				Close(clientfd);		
				exit(0);
			}

			number = atoi(buf);
			if(number <= 0) printf("Inavlid integer please try again: \n");		
	   	}
		while(number <= 0);
		
		Rio_writen(clientfd, buf, strlen(buf));

	   while(Rio_readlineb(&rio, buf, MAXLINE) > 0) 
	   {
		if(buf[0] == '0') break;
		Fputs(buf, stdout);
	   }
	}
}
