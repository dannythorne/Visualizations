
CC = g++

CFLAGS =
#CFLAGS+=

RM = /bin/rm -f

a.exe: main.o life.o
	$(CC) main.o life.o

main.o: main.cc
	$(CC) -c $(CFLAGS) main.cc

life.o: life.cc life.h
	$(CC) -c $(CFLAGS) life.cc

clean:
	$(RM) a.exe* *.o

sweep:
	$(RM) *~ *.sw*

