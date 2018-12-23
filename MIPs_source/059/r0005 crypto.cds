/*

Special thanks to gtlcpimp and dnawrkshp for kernel hook.


Variables:
000f8fe0 - Checksum stack position 
000f8ff0 - CHECKSUM BOOL. Will = 1 if valid checksum.
000f8ff4 - MAIN CODES FNC BOOL. Will = 1 if checksum function is in tact. 
           Will = 0 if check fnc is disabled or missing.
000f8ff8 - MAIN FUNCTION timer
000f8ffc - codes enabled BOOL

Indexes:
8007f600 - functions to checksum
8007f800 - checksum results
8007fA00 - code stack

*/

//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
//
// KERNEL ENTRY
//
//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

address $8007A000
 
_init:
addiu sp, sp, $FFF0
sq ra, $0000(sp)
jal :kernal_start
nop
lq ra, $0000(sp)
addiu sp, sp, $0010
jalr k0
nop
j $00000304
// jr ra // seems to have issues every now and then.
nop

//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
//
// MAIN FUNCTION
//
//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

kernal_start:
addiu sp, sp, $FE00
sq at, $0000(sp)
sq v0, $0010(sp)
sq v1, $0020(sp)
sq a0, $0030(sp)
sq a1, $0040(sp)
sq a2, $0050(sp)
sq a3, $0060(sp)
sq t0, $0070(sp)
sq t1, $0080(sp)
sq t2, $0090(sp)
sq t3, $00a0(sp)
sq t4, $00b0(sp)
sq t5, $00c0(sp)
sq t6, $00d0(sp)
sq t7, $00e0(sp)
sq s0, $00f0(sp)
sq s1, $0100(sp)
sq s2, $0110(sp)
sq s3, $0120(sp)
sq s4, $0130(sp)
sq s5, $0140(sp)
sq s6, $0150(sp)
sq s7, $0160(sp)
sq t8, $0170(sp)
sq t9, $0180(sp)
sq k0, $0190(sp)
sq k1, $01a0(sp)
sq fp, $01b0(sp)
sq gp, $01c0(sp)
sq ra, $01d0(sp)
 
// TIMER is so the function scanner does not slow down the game.
// set timer limit
addiu s0, zero, $400
// set timer address for storage
setreg s1, $000f8ff8
// get timer count
lw s2, $0000(s1)
sub s3, s2, s0
bltz s3, :kernal__increment_timer
nop

jal :kernal__FNC_function_checker
nop

jal :kernal__FNC_main_codes
nop

// reset timer
sw zero, $0000(s1)
beq zero, zero :kernal___exit
nop

kernal__increment_timer:
addiu s2, s2, $1
sw s2, $0000(s1)

kernal___exit:
lq at, $0000(sp)
lq v0, $0010(sp)
lq v1, $0020(sp)
lq a0, $0030(sp)
lq a1, $0040(sp)
lq a2, $0050(sp)
lq a3, $0060(sp)
lq t0, $0070(sp)
lq t1, $0080(sp)
lq t2, $0090(sp)
lq t3, $00a0(sp)
lq t4, $00b0(sp)
lq t5, $00c0(sp)
lq t6, $00d0(sp)
lq t7, $00e0(sp)
lq s0, $00f0(sp)
lq s1, $0100(sp)
lq s2, $0110(sp)
lq s3, $0120(sp)
lq s4, $0130(sp)
lq s5, $0140(sp)
lq s6, $0150(sp)
lq s7, $0160(sp)
lq t8, $0170(sp)
lq t9, $0180(sp)
lq k0, $0190(sp)
lq k1, $01a0(sp)
lq fp, $01b0(sp)
lq gp, $01c0(sp)
lq ra, $01d0(sp)
jr ra
addiu sp, sp, $0200
 
 
//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
//
// MAIN CHECKSUM FUNCTION
//
// Check one function at a time to avoid screen lag.
//
//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////


kernal__FNC_function_checker:


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

// --------------------check individual functions
setreg s3, $000f8ff0 // CHECKSUM_FAILED BOOL
setreg s4, $000F8FE0 //checksum stack position
setreg s2, $000F8FE4 //checksum results position

// check if socom lan is loaded
setreg s0, $0069507C
setreg t1, $00010001
lw t0, $0000(s0) // get "ComeFromLAN" BOOL

// set start of function stack
setreg s0, :kernal__function_index // set function index default position
setreg s1, :kernal__checksum_index // set checksum results index position
bne t0, t1 :kernal__not_online
nop

//setreg s1, $8007f800
addiu t5, zero, $1

// check if checksum stack position is zero
lw s5, $0000(s4) // get current position for function to check
lw s7, $0000(s2) // get current position for checksum results

lw s6, $0000(s5) // get current function to scan
bne s6, zero :kernal__checksum_start
nop
// set checksum stack position to first slot
sw s0, $0000(s4)
lw s5, $0000(s4)
// set checmsum result stack position to first slot
sw s1, $0000(s2)
lw s7, $0000(s2)

kernal__checksum_start:

// check if there is another address to checksum
// s5 = current function to scan
lw a0, $0000(s5)
beq a0, zero :kernal__VALID
nop
// get correct checksum for compareing
lw a1, $0000(s7)
// jal checksum fnc here
jal :kernal__FNC_checksum
nop
beq v0, zero :kernal__valid_checksum
nop

kernal__infinite_loop:
// store 0 to CHECKSUM_FAILED BOOL
sw zero, $0000(s3)

// freeze player by infinite loop
beq zero, zero :kernal__infinite_loop
nop

kernal__valid_checksum:

kernal__VALID:
// store 1 in to checksum BOOL
// the MAIN CODES FNC checks this BOOL for 1. If it fails then the player freezes.
sw t5, $0000(s3)

// increment function stack position
lw s5, $0000(s4)
addiu s5, s5, $4
sw s5, $0000(s4)
lw s7, $0000(s2)
addiu s7, s7, $4
sw s7, $0000(s2)

beq zero, zero, :kernal__end
nop

kernal__not_online:
sw s0, $0000(s4) //set default checksum position
sw s1, $0000(s2) //set default results position

kernal__end:
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



/////////////////////////////////////////////////////////////////
//
// CHECK SUM FNC
//
// a0 = function to scan
// a1 = checksum to compare to
// v0 = zero if checksums are identical, 1 if they are different
// v1 = calculated checksum

kernal__FNC_checksum:

// move args in to temp registers
addu t0, a0, zero // function to check
addu t1, a1, zero // correct checksum
setreg t2, $03e00008
addu t3, zero, zero // zero calculated checksum register

kernal__next_address:
lw t4, $0000(t0) // get current address data
addu t3, t3, t4 // add to checksum
addiu t0, t0, $4 //increment function position
beq t4, t2 :kernal__last_address
nop
beq zero, zero :kernal__next_address
nop

kernal__last_address:
// this is needed to grab the address below the jr ra
lw t4, $0000(t0) // get current address data
addu t3, t3, t4 // add to checksum

// move calculated checksum to v1
addu v1, t3, zero

// t1 = correct checksum
// t3 = calculated checksum
beq t1, t3 :kernal___end_checksum
daddu v0, zero, zero
addiu v0, zero, $1

kernal___end_checksum:
jr ra
nop


//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
//
// MAIN CODES FUNCTION. Also checks the checksum fnc.
//
//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////


kernal__FNC_main_codes:

addiu sp, sp, $ff80
sw ra, $0000(sp)
sw v0, $0004(sp)
sw v1, $0008(sp)
sw s0, $0018(sp)
sw s1, $001c(sp)
sw s2, $0020(sp)
sw s3, $0024(sp)
sw s4, $0028(sp)
sw s5, $002c(sp)
sw s6, $0030(sp)
sw s7, $0034(sp)


///////////////////////////////////
// START CODES
///////////////////////////////////


// "SOCOM II r0005 v0.59" TEXT
setreg s0, $003E17E0

setreg s1, $4F434F53
sw s1, $0000(s0)
setreg s1, $4949204D
sw s1, $0004(s0)
setreg s1, $30307220
sw s1, $0008(s0)
setreg s1, $76203530
sw s1, $000c(s0)
setreg s1, $39352E30
sw s1, $0010(s0)
setreg s1, $00000000
sw s1, $0014(s0)


// check if SOCOM LAN is loaded.
lui s0, $0069
lb s0, $507C(s0)
beq s0, zero :kernal__enableCodes
//beq zero, zero :kernal__endCodes
nop

// check codes enabled bool
// codes should enable on LAN connect and write 1 time until the EE is cleared.
setreg s0, $000f8ffc
lb s0, $0000(s0)
bne s0, zero :kernal__endCodes
nop




// ------------------------ CODE STACK START

//-----------------init
// start address
setreg s0, :kernal__data
// output address
setreg s1, :kernal__output
// crypto key
setreg s2, :kernal__key
// store counter
addu s3, zero, zero
// counter max
addiu s4, zero, $8

//-----------------crypto
// Must load each byte seperatly due to freezing. Must be some sort of kernal issue.
kernal__next_byte:
// check for 4 bytes of 00
lb s5, $0000(s0)
bne s5, zero, :kernal__continue
nop
lb s5, $0001(s0)
bne s5, zero, :kernal__continue
nop
lb s5, $0002(s0)
bne s5, zero, :kernal__continue
nop
lb s5, $0003(s0)
beq s5, zero, :kernal__end_crypto
nop

kernal__continue:

// get byte by from data stack
lb s5, $0000(s0)
// get byte from key stack
lb s6, $0000(s2)
bne s6, zero, :kernal__xor
nop

// if key byte is zero, reset key position to 0
setreg s2, :kernal__key
lb s6, $0000(s2)

kernal__xor:
// xor
xor s5, s5, s6
// stored xor'd data in to output address
sb s5, $0000(s1)

//-----------------increment variables
// increment data
addiu s0, s0, $1
// increment output address
addiu s1, s1, $1
// increment key
addiu s2, s2, $1
// increment counter
addiu s3, s3, $1

// if counter is 8 then store decrypted data to decrypted address
bne s3, s4, :kernal__continue_loop
nop

// store data to address
setreg s1, :kernal__output
lw t0, $0000(s1) //get address
lw t1, $0004(s1) //get data
sw t1, $0000(t0) //save data to address
// reset counter
daddu s3, zero, zero

kernal__continue_loop:
// loop
beq zero, zero, :kernal__next_byte
nop

//-----------------end decryption
kernal__end_crypto:
// zero output address
sd zero, $0000(s1)

// ------------------------ CODE STACK END

// disable codes write
addiu s1, zero, $1
setreg s0, $000f8ffc 
beq zero, zero,:kernal__endCodes
sw s1, $0000(s0)

// enable codes write
kernal__enableCodes:
setreg s0, $000f8ffc 
sw zero, $0000(s0)

kernal__endCodes:
lw ra, $0000(sp)
lw v0, $0004(sp)
lw v1, $0008(sp)
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


/////////////////////////////////////////////////////////////////////////////////
// function stack and checksum stacks below


// functions to checksum
kernal__function_index:
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
//hexcode $005af930 //skywalker/clipping fncs
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
//hexcode $0023C390 //can use weapon
//hexcode $00289BB0 //player speed fnc
hexcode $005B5D40
hexcode $00598B90 //respawn in place v2
hexcode $003C5950 //bullet damage
hexcode $0059BA80 //player dynamics
//hexcode $000D3000 // code_scanner2

// new
hexcode $005BD100 // accuracy fnc
//hexcode $00594CF0 // player fnc 1 --unknown freeze
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
//hexcode $0023C390 // can use weapon
//hexcode $00289BB0 // player movement speed

// end stack (do not delete)
nop

// checksums
kernal__checksum_index:
hexcode $CA89C5A2
hexcode $1AF3EB54 // team tags
//hexcode $FA988E79 // refresh fnc
hexcode $E228C259
hexcode $6076A5F4
hexcode $ED8BF6F5
hexcode $487D8FC4
hexcode $00DB51C9
hexcode $62F8FA7B
hexcode $D6725AEB
hexcode $865AE825
hexcode $EA45103D
hexcode $92F279EB
hexcode $E7639DD6
hexcode $69DBC44D
hexcode $CA70416A
//hexcode $9BC4459F //skywalker/clipping fncs
hexcode $D94B7267
hexcode $F8EABF7D
hexcode $46A81484
hexcode $02B533C4
hexcode $E873419E
//hexcode $B7FDAB5B //vote boot (modified)
//hexcode $F3EEF8F8 //shoot boot (modified)
//hexcode $B7FDAB59 //vote boot (normal)
//hexcode $F3EEF8F6 //shoot boot (normal)
hexcode $BA720A93
hexcode $C5EFD3CB
hexcode $529A024E
hexcode $E2EF6797
hexcode $DCB95B2A
hexcode $EB91157D
hexcode $39C15198
hexcode $B075BD10
hexcode $430D0736
//hexcode $FC6BFC7A // recieve shoot packet
hexcode $BDC21951
hexcode $90620030
hexcode $7ABA6E34
hexcode $9E366A20
hexcode $CD59CD69
hexcode $113B5992
hexcode $C502448D
hexcode $E75943C4
hexcode $6B4CD7A3
hexcode $25F5AD0E
//hexcode $3339848C //can use weapon
//hexcode $441F9D28 // player speed fnc
hexcode $FD20C048
hexcode $D8051F29
hexcode $CA70416A //bullet damage
hexcode $7E6172C7 //player dynamics
//hexcode $EEED4E97 // code_scanner2

// new checksums
hexcode $D5B1ADB3  // accuracy fnc
//hexcode $59EA632B  // player fnc 1 --unknown freeze
hexcode $71D39813  // terrorists no ammo
hexcode $F805C146  // rapid everything
hexcode $099F0364  // run with turrent
hexcode $25F5AD0E  // auto aim
hexcode $B9C20F3E  // all weapons (does not scan first line)
hexcode $F0469ABC  // shoot through everything
hexcode $62DC333D  // random dynamics
hexcode $C3C367D0  // animations
hexcode $CA70416A  // one shot kill
hexcode $41C1A552  // gun dynamics 1
hexcode $C402AE4C  // ghost function 1
hexcode $C0686B23  // player movement/invisible
hexcode $BDC99136  // player movement 2
hexcode $9E978584  // system function 1
hexcode $E873419E  // error setup 1
hexcode $7298CA03  // kill count
hexcode $DC00946E  // smoke colors
hexcode $D1FCFE72  // player collision
hexcode $51E0446C  // grenade control 1
hexcode $0A89B0A4  // blue world
hexcode $262FFD1E  // weapon dynamics 2
hexcode $430D0736  // update health
hexcode $B075BD10  // update health fnc
hexcode $C502448D  // more health updates
hexcode $9E366A20  // player can move (clipping)
hexcode $1196B77D  // autoaim fnc 2
//hexcode $3339848C  // can use weapon
//hexcode $441F9D28  // player movement speed

// end stack (do not delete)
nop 








//----------------------------------- crypto key
kernal__key:
hexcode $5fb82ffa
hexcode $d87f4abf
hexcode $a86214de
hexcode $c4cd8a96
hexcode $617e2671
nop






kernal__data:

////////////////////////////////////
// Encrypted Code Stack
////////////////////////////////////









//----------------- end code stack
nop

// user memory output address, can't write to kernel memory
//address $00097000
//kernal__output:
// temporary output goes here


//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
//
// KERNEL HOOK
//
// Must write this last so the game does not freeze.
//
//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

address $800002FC
jal :_init


// all user memory functions and variables
import "C:\r0005\MIPs_source\059\functions_write.cds"


