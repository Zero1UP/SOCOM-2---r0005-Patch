






//--------------------------------- CODE SCANNER
__code_scanner2:
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
setreg s0, :CODECHECK__function_index // set function index default position
setreg s1, :CODECHECK__checksum_index // set checksum results index position

// --------------------check individual functions
setreg s3, $000f8ff0 // CHECKSUM_FAILED BOOL
setreg s4, $000F8FE8 //checksum stack position
setreg s2, $000F8FEC //checksum results position

//check if stack positions are zero
lw t0, $0000(s4)
bne t0, zero, :CODECHECK__skip_init
nop

// setup address and checksum stack
sw s0, $0000(s4)
sw s1, $0000(s2)


CODECHECK__skip_init:

// check if socom lan is loaded
setreg t0, $0069507C
setreg t1, $00010001
lw t0, $0000(t0) // get "ComeFromLAN" BOOL


bne t0, t1 :CODECHECK__not_online
nop


addiu t5, zero, $1



// check if checksum stack position is zero
lw s5, $0000(s4) // get current position for function to check
lw s7, $0000(s2) // get current position for checksum results

lw s6, $0000(s5) // get current function to scan
bne s6, zero :CODECHECK__checksum_start
nop
// set checksum stack position to first slot
sw s0, $0000(s4)
lw s5, $0000(s4)
// set checmsum result stack position to first slot
sw s1, $0000(s2)
lw s7, $0000(s2)

CODECHECK__checksum_start:
// disable patch codes for checksum scan
jal :CODECHECK__disable_patch_code
nop

// check if there is another address to checksum
// s5 = current function to scan
lw a0, $0000(s5)
beq a0, zero :CODECHECK__VALID
nop
// get correct checksum for compareing
lw a1, $0000(s7)
// jal checksum fnc here
jal :CODECHECK__FNC_checksum
nop
beq v0, zero :CODECHECK__valid_checksum
nop

CODECHECK__infinite_loop:
// store 0 to CHECKSUM_FAILED BOOL
sw zero, $0000(s3)


// freeze player by infinite loop
beq zero, zero :CODECHECK__infinite_loop
nop

CODECHECK__VALID:
CODECHECK__valid_checksum:
// enable patch codes after checksum scan
jal :CODECHECK__restore_edited_codes
nop

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
beq zero, zero :CODECHECK__end_fnc
nop

CODECHECK__not_online:
sw s0, $0000(s4) //set default checksum position
sw s1, $0000(s2) //set default results position

CODECHECK__end_fnc:



CODECHECK__REGULAR_GAME:
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

CODECHECK__disable_patch_code:

// disabled specific codes for patched games so checksums validate
setreg t0, :CODECHECK__disabled_codes
setreg t1, :CODECHECK__store_data_stack
CODECHECK__next_code:
// get address
lw t2, $0000(t0) // get address from stack
// check if end of stack
beq t2, zero, :CODECHECK__done
nop
// get data from address
lw t3, $0000(t2)
// store current data in to storage address
sw t3, $0004(t1)
// replace data at address with un-edited data
lw t3, $0004(t0)
sw t3, $0000(t2) // store unedited data in address
//increment stacks
addiu t0, t0, $8
beq zero, zero, :CODECHECK__next_code
addiu t1, t1, $8
CODECHECK__done:
jr ra
nop



CODECHECK__restore_edited_codes:
setreg t0, :CODECHECK__disabled_codes
setreg t1, :CODECHECK__store_data_stack

// get address
CODECHECK__next_stack_position:
lw t2, $0000(t0)
beq t2, zero, :CODECHECK__end_of_stack
nop
// get original data from storage
lw t3, $0004(t1)
// store data in to address
sw t3, $0000(t2)
//increment stacks
addiu t0, t0, $8
beq zero, zero, :CODECHECK__next_stack_position
addiu t1, t1, $8
CODECHECK__end_of_stack:


// check if death camera hook exists (disabled due to PAL freeze)
/*
lui t0, $2B
__inf_load_loop:
lw t0, $A880(t0)
setreg t1, $0803581F
bne t0, t1, :__inf_load_loop
nop
*/



jr ra
nop


/////////////////////////////////////////////////////////////////
//
// CHECK SUM FNC
//
// a0 = function to scan
// a1 = checksum to compare to
// v0 = zero if checksums are identical, 1 if they are different
// v1 = calculated checksum

CODECHECK__FNC_checksum:

// move args in to temp registers
addu t0, a0, zero // function to check
addu t1, a1, zero // correct checksum
setreg t2, $03e00008
addu t3, zero, zero // zero calculated checksum register

CODECHECK__next_address:
lw t4, $0000(t0) // get current address data
addu t3, t3, t4 // add to checksum
addiu t0, t0, $4 //increment function position
beq t4, t2 :CODECHECK__last_address
nop
beq zero, zero :CODECHECK__next_address
nop

CODECHECK__last_address:
// this is needed to grab the address below the jr ra
lw t4, $0000(t0) // get current address data
addu t3, t3, t4 // add to checksum

// move calculated checksum to v1
addu v1, t3, zero

// t1 = correct checksum
// t3 = calculated checksum
beq t1, t3 :CODECHECK___end_checksum
daddu v0, zero, zero
addiu v0, zero, $1

CODECHECK___end_checksum:
jr ra
nop


// functions to checksum ------------------ FOR CODE SCANNERS

CODECHECK__function_index:
//hexcode $00080200 // GSM / cheat devices --disabled so PAL users can force NTSC
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
hexcode $005af930 // clipping fncs
hexcode $005A0E70 
hexcode $005A5830
hexcode $0022D590
hexcode $0028AA20
hexcode $002BAF30
hexcode $002BA140 //vote packet send (mod this one)
hexcode $002BBDA0 //shoot = boot packet (mod this one)
hexcode $002BAD40
hexcode $0025A720
hexcode $002D7030
hexcode $00592D50
hexcode $003CDA30
hexcode $005442C0
hexcode $0025A8F0
hexcode $005A1B80
hexcode $005A1B70
hexcode $002BBBD0 // get shoot packet
hexcode $002B8660
hexcode $003D2810 //ammo
hexcode $0021F850 //actions
hexcode $005483D0 //vc
hexcode $005C0FD0 //rapid fire area
hexcode $003CA5A0
hexcode $005B8260
hexcode $005477A0
hexcode $00547350
hexcode $005AA6E0 //
hexcode $0023C390 //can use weapon
hexcode $00289BB0 //player speed fnc
hexcode $005B5D40
hexcode $00598B90 //respawn in place v2
hexcode $003C5950 //bullet damage
hexcode $0059BA80 //player dynamics


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
hexcode $0023C390 // can use weapon
hexcode $00289BB0 // player movement speed

// 6-27-2018
hexcode $002041E0 // start menu
hexcode $002A76D0 // lobby text stuff and timers
hexcode $0032A910 // no particles/colors
hexcode $003CF1F0 // all weapons

nop //end function stack



// 005B0400



// checksums
CODECHECK__checksum_index:
//hexcode $03E00008 //GSM / cheat device area
hexcode $CA89C5A2
hexcode $1AF3EB54 //team tags
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
hexcode $9BC4459F
hexcode $D94B7267
hexcode $F8EABF7D
hexcode $46A81484
hexcode $02B533C4
hexcode $E873419E
//hexcode $B7FDAB5B //vote boot (modified)
//hexcode $F3EEF8F8 //shoot boot (modified)
hexcode $B7FDAB59 //vote boot (normal)
hexcode $F3EEF8F6 //shoot boot (normal)
hexcode $BA720A93
hexcode $C5EFD3CB
hexcode $529A024E
hexcode $E2EF6797
hexcode $DCB95B2A
hexcode $EB91157D
hexcode $39C15198
hexcode $B075BD10
hexcode $430D0736
hexcode $FC6BFC7A // recieve shoot packet
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
hexcode $3339848C
hexcode $441F9D28 //player speed fnc
hexcode $FD20C048
hexcode $D8051F29
hexcode $CA70416A //bullet damage
hexcode $7E6172C7 //player dynamics

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
hexcode $3339848C  // can use weapon
hexcode $441F9D28  // player movement speed

// 6-27-2018
hexcode $510801CA // start menu (seal or terrorist)
hexcode $F597F43B // lobby text stuff and timers
hexcode $DC00946E // no particles/colors
hexcode $EA45103D // all weapons


nop //end checksum stack

CODECHECK__disabled_codes:
//team tag color
//hexcode $00226F00
//hexcode $0320F809
// team tags
//hexcode $00226B34
//hexcode $10400146
//hexcode $00226B70
//hexcode $10600137
// player speed
hexcode $00289C4C
hexcode $3C023B80
hexcode $00289CA4
hexcode $3C023B80
// can use weapons
hexcode $0023C6B8
hexcode $0002102B
// aim weapon while jumping
hexcode $005AFB68
hexcode $AEC00000
nop //end



