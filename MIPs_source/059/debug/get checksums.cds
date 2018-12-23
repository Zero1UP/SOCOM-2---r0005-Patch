
/*
address $20204770
addiu sp, sp, $ffe0
sw ra, $0000(sp)

jal $000f5000
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
print "GET CHECKSUM"
nop
*/


address $202CED04
j $000f5000

//////////////////////////////
// function stack checker

address $200f5000
addiu sp, sp, $ff80
sw ra, $0000(sp)
sw v0, $0004(sp)
sw v1, $0008(sp)
sw a0, $000c(sp)
sw a1, $0010(sp)
sw a2, $0014(sp)
sw s0, $0018(sp)
sw s1, $001c(sp)
sw s2, $0020(sp)
sw s3, $0024(sp)
sw s4, $0028(sp)
sw s5, $002c(sp)
sw s6, $0030(sp)
sw s7, $0034(sp)


// set start of function stack
setreg s0, :__functions_to_checksum

// set start of checksum stack
setreg s1, :__output
 


__loop:
// check if there is another address to checksum
lw a0, $0000(s0)
beq a0, zero :__end
nop

// load checksum
lw a1, $0000(s1)

// jal checksum fnc here
jal :__FNC_checksum
nop

// store checksum in to stack
sw v1, $0000(s1)

// increment loop for next address in stack
addiu s0, s0, $4
beq zero, zero :__loop
addiu s1, s1, $4



__end:

lw ra, $0000(sp)
lw v0, $0004(sp)
lw v1, $0008(sp)
lw a0, $000c(sp)
lw a1, $0010(sp)
lw a2, $0014(sp)
lw s0, $0018(sp)
lw s1, $001c(sp)
lw s2, $0020(sp)
lw s3, $0024(sp)
lw s4, $0028(sp)
lw s5, $002c(sp)
lw s6, $0030(sp)
lw s7, $0034(sp)
jr ra
addiu sp, sp, $0080





////////////////////////////////////////////////////
// CHECK SUM FNC
//
// a0 = function to scan
// a1 = checksum to compare to
// v0 = zero if checksums are identical, 1 if they are different
// v1 = calculated checksum


//address $200f7000

__FNC_checksum:
// move args in to temp registers
addu t0, a0, zero // function to check
addu t1, a1, zero // correct checksum
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

// move calculated checksum to v1
addu v1, t3, zero

// t1 = correct checksum
// t3 = calculated checksum
beq t1, t3 :___end_checksum
daddu v0, zero, zero
addiu v0, zero, $1

___end_checksum:
jr ra
nop




// functions to checksum
// first address = function to scan

__functions_to_checksum:

/*
hexcode $002F6D00 //spec function
hexcode $002269A0 //team tags
//hexcode $002CE9E0 // refresh fnc
hexcode $002D0330
hexcode $00571010
hexcode $005BE9A0
hexcode $005BDA70
hexcode $005C2670
hexcode $005807D0
hexcode $0021A700
hexcode $002DDE40
hexcode $003CF1F0
hexcode $003C5980
hexcode $005BE300
hexcode $005B91C0
hexcode $003C5950
hexcode $005af930
hexcode $005A0E70
hexcode $005A5830
hexcode $0022D590
hexcode $0028AA20
hexcode $002BAF30
//hexcode $002BA140 //vote packet send (mod this one)
//hexcode $002BBDA0 //shoot = boot packet (mod this one)
hexcode $002BAD40
hexcode $0025A720
hexcode $002D7030
hexcode $00592D50
hexcode $003CDA30
hexcode $005442C0
hexcode $0025A8F0
hexcode $005A1B80
hexcode $005A1B70
//hexcode $002BBBD0 // get shoot packet
hexcode $002B8660
hexcode $003D2810 //ammo
hexcode $0021F850 //actions
hexcode $005483D0 //vc
hexcode $005C0FD0 //rapid fire area
hexcode $003CA5A0
hexcode $005B8260
hexcode $005477A0
hexcode $00547350
hexcode $005AA6E0
hexcode $0023C390
hexcode $00289BB0
hexcode $005B5D40
hexcode $00598B90 //respawn in place v2
*/

/*
hexcode $005BD100 // accuracy fnc
hexcode $00594CF0 // player fnc 1
hexcode $005BD530 // terrorists no ammo
hexcode $005C1970 // rapid everything
hexcode $005C4B10 // run with turrent
hexcode $005AA6E0 // auto aim
hexcode $003CF1F4 // all weapons (does not scan first line)
hexcode $001C0700 // shoot through everything
hexcode $005A49F0 // random dynamics
hexcode $005E1DF0 // animations
hexcode $003C5950 // one shot kill
hexcode $001F0030 // gun dynamics 1
hexcode $001F97B0 // ghost function 1
hexcode $0054D9A0 // player movement/invisible
hexcode $005B3340 // player movement 2
hexcode $001C6390 // system function 1
hexcode $002BAF30 // error setup 1
hexcode $002F13F0 // kill count
hexcode $0032A910 // smoke colors
hexcode $0054F7E0 // player collision
hexcode $003C9FB0 // grenade control 1
hexcode $001F1470 // blue world
hexcode $00260B40 // weapon dynamics 2
hexcode $005A1B70 // update health
hexcode $005A1B80 // update health fnc
hexcode $005B8260 // more health updates
hexcode $005483D0 // player can move (clipping)
hexcode $005AB1C0 // autoaim fnc 2
hexcode $0023C390 // can use weapon
hexcode $00289BB0 // player movement speed
*/

hexcode $002041E0 // start menu (seal or terrorist)
hexcode $002A76D0 // lobby text stuff and timers
hexcode $0032A910 // no particles/colors
hexcode $003CF1F0 // all weapons












// end stack
nop





















// checksum equivalents
__output:

