# Makefile for writer application
# Supports Cross-Compilation via CROSS_COMPILE variable

CC = $(CROSS_COMPILE)gcc
CFLAGS = -Wall -g

.PHONY: all clean
all: writer
writer: writer.c
	$(CC) $(CFLAGS) -o $@ $<
clean:
	rm -f writer *.o
