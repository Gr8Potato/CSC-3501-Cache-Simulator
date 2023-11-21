# CSC-3501-Cache-Simulator
I made **the assembly portion of this program** to demonstrate how caching works. The cache handler is written in IA32 AT&T assembly.

Student-faculty provided the C code and Make file.

The assembly procedure performs the following operations including but not limited to:
- Capturing bits within a byte
- Dereferencing fields within structs and fields within structs
- Moving parts of register data

### Compilation-Execution
This program was designed to be run on specific 32-bit architecture. As such, dependencies & the nature of the program may result in failing to create a proper executable. With that said, there are 2 ways to create a program executable.

Make: `make` (the executable will be `xtest`).

Manual: `gcc -m32 cache.c prog3.s -o <executable name`.
