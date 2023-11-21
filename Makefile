#
# It's good practice to use make macros for compiler and flags, so when you
# need to change, you change at one place, not throughout makefile
#
CC = gcc
CCFLAGS = -Wall -g -m32

#
# Use macros to give paths that might change
#
SCRd = /classes/cs3501/cs3501_lee/bin/

#
# Macros can also help with commonly referenced filenames
#
OBJ = cache.o prog3.o

xtest : $(OBJ)
	$(CC) $(CCFLAGS) -o xtest $(OBJ)

#
# This rules remove object and executables when they are no longer needed
#
clean :
	- rm -f $(OBJ)
kill :
	- rm -f $(OBJ) xtest
#
# This is an example of a specific rule for building tester.o given tester.c
#
cache.o : cache.c
	$(CC) $(CCFLAGS) -c cache.c

prog3.o : prog3.s
	$(CC) $(CCFLAGS) -c prog3.s 

#
# This is a generic rule showing how to build any .o file from a .c file.
# It is only used if no specific rule can be found
#
.c.o:
	$(CC) $(CCFLAGS) -c $<

#
# This rule uses our submission program to submit code that works!
#
submit:
	make kill
	$(SCRd)/p_copy -o 3
