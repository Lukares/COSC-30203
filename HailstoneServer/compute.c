#include "csapp.h"
#include <stdlib.h>
#include <stdio.h>

void compute(int connfd) 
{
    size_t n; 

    int i = 0;
    int count = 0;
    int connC = 0;
    int messC = 1;

    char buf[MAXLINE]; 
    rio_t rio;

    Rio_readinitb(&rio, connfd);
    while((n = Rio_readlineb(&rio, buf, MAXLINE)) != 0) 
    { 
	connC++;
	i = atoi(buf);
	printf("Server received number %d.\n", i);
	
	sprintf(buf, "\n[HSSMESG:%d:%d] - Sequence starting at number: %d\n", connC, messC, i);
	Rio_writen(connfd, buf, strlen(buf));
	messC++;
	count = 0;
	
	printf("Sending sequence.\n");
	while(i > 1)
	{
		if(i % 2 == 0) i /= 2;
		else i = 3 * i + 1;

		sprintf(buf, "[HSSMESG:%d:%d] - %d\n", connC, messC, i);
		Rio_writen(connfd, buf, strlen(buf));

		messC++;
		count++;
	}	

	sprintf(buf, "[HSSMESG:%d:%d] - Sequence ended after %d iterations.\n",connC, messC, count);
	Rio_writen(connfd, buf, strlen(buf));
	messC++;

	sprintf(buf, "0\n");
	Rio_writen(connfd, buf, strlen(buf));
    }
}

