# Author: Aidan Eiler

.global check_cache

check_cache:	
	# provided prologue code
	pushl   %ebp
	movl    %esp,   %ebp
	pushl   %ebx

	# My Code
	push %esi          # i used this register for addresses
	push %edi 		   # i'm going to use this for the cache array address
	mov 8(%ebp), %edi  # set address of cache array into edi
	mov 12(%ebp), %ebx # set address to be checked to ebx
	
	# BIT EXTRACTION
	mov %bl, %cl # copies the lower 8 bits of ebx (the entire byte address) into ch
	and $3, %cl  # extracts last 2 bits of address. these are our BLOCK OFFSET BITS
	
	shr $2, %bl  # shifts contents of bl (our address) right 2, discarding the block offset bits.
	mov %bl, %ch # copies the lower 8 bits of ebx (the entire byte address) into ch
	and $3, %ch  # extract the last 2 bits of address. these are our SET INDEX BITS
	
	shr $2, %bl  # shifts contents of bl (our address) right 2, discarding our set index bits.
	mov %bl, %dl # moves contents of bl to dl. these are our TAG BITS

	# SET INDEX EVALUATION
	cmp $3, %ch      # compare %ch with 3 (the highest valid set index in the cache array)
	ja .CACHE_MISS 	 # if ch is above 3, it is out of range, and therefore a cache miss

	# VALID INDEX EVALUATION
	movzbl %ch, %ebx          # clears ebx, and assigns it to set index of ch (with zero extension)
	imul $6, %ebx             # multiplies my index by 6. this is neccessary because the following instruction only allows me to mltiply by 1, 2, 4, or 8
	movzbl (%edi, %ebx), %esi # this should give us cache[ch].valid, as valid is the first field for each line struct. we use movzbl because we get a byte when we deref
	cmp $0, %esi              # compares 0 with cache[i].valid
	je .CACHE_MISS            # cache miss if it's zero

	# TAG INDEX EVALUATION
	movzbl 5(%edi, %ebx), %esi # this should give us cache[ch].tag. we use movzbl because we get a byte when we deref
	movzbl %dl, %edx           # zeroing out edx and zero extending dl to it. this gives us 0000...0000TTTT
	cmp %edx, %esi             # compares tag bits with cache[i].tags
	jne .CACHE_MISS            # cache miss if they're not equal
	
	# CACHE RETURN
	movzbl %cl, %ecx          # zeroes and extends cl, just like the previous instructions
	lea 1(%edi, %ebx), %esi    # address of cache[i].block[0]
	mov (%esi, %ecx), %al     # sets cache[i].block[ecx] to al
	
	jmp .END_PROG # skips cache miss handler

	.CACHE_MISS:   # any cache misses will be directed here
	mov $0xFF, %al # assigns 0xFF to al, showing cache miss as instructed
	.END_PROG:	   # skips over cache miss handler

	pop %edi # removes edi from stack and restores its value from the previous frame
	pop %esi # removes esi from stack and restores its value from the previous frame
	
	# provided termination code
	popl    %ebx
	popl    %ebp
	ret
