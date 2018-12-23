address $20204770
addiu sp, sp, $ffe0
sw ra, $0000(sp)

jal :__get_checksum
nop

lw ra, $0000(sp)
addiu sp, sp, $0020


// text ptr
lui a1, $003E
addiu a1, a1, $3B80

j $002049E0
nop

// print text
address $203E3B60
print "CHECKSUM"
nop










address $200f7000
__get_checksum:

/////////////////////////////////////////////////////////////////
//
// CHECK SUM FNC
//
// a0 = function to scan
// a1 = checksum to compare to
// v0 = zero if checksums are identical, 1 if they are different
// v1 = calculated checksum


// address to checksum
setreg t0, :__checksum_stack
// output
setreg t1, :__checksum_output
setreg t2, $03e00008
addu t3, zero, zero // zero calculated checksum register

__next_address:
lw t4, $0000(t0) // get current address data
addu t3, t3, t4 // add to checksum
addiu t0, t0, $4 //increment function position
beq t4, t2 :__last_address
nop
beq zero, zero :__next_address
nop

__last_address:
// this is needed to grab the address below the jr ra
lw t4, $0000(t0) // get current address data
addu t3, t3, t4 // add to checksum


// t3 = final checksum
sw t3, $0000(t1)

___end_checksum:
jr ra
nop







// functions to checksum
// first address = function to scan
// second address = checksum of function
__checksum_stack: 
hexcode $005BD100 // accuracy fnc
hexcode $002F6D00 // spec

// end stack
nop

__checksum_output:






