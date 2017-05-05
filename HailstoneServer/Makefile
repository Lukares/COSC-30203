CC=gcc
LDLIBS=-lpthread

all: client server 

client: client client.c csapp.h csapp.c
server: server server.c compute.c csapp.h csapp.c

clean:
	rm -f *.o *~ *.exe hostinfo client server csapp.o

