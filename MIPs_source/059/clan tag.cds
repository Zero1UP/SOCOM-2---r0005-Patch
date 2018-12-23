

/*
player id start: 004414C4

// pointers to name
00726434

player pointer offsets
0: player team id
e: player name
2e: clan tag
*/

// original name: 000D17A0
// clan tag: 000d13a0 
// modified name: 000D13D0 



////////////// start player pointer check fnc /////////////



__clan_tag_fnc:

addiu sp, sp, $ff60
sw ra, $0000(sp)
sw t0, $0004(sp)
sw t1, $0008(sp)
sw a0, $000c(sp)
sw a1, $0010(sp)
sw a3, $0014(sp)
sw s0, $0018(sp)
sw s1, $001c(sp)
sw s2, $0020(sp)
sw v0, $0024(sp)

// check if modified player name exists
setreg t0, :__CLANTAG_modified_player_name
lw t1, $0000(t0)
beq t1, zero :CLAN__end
nop

// check if player pointer matches the stored one @000D1700
setreg a0, :__CLANTAG_original_player_name
setreg a1, $00726434
lw a1, $0000(a1)
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
beq v0, zero :__FIND_PLAYER_PERSONA
nop

// check if player pointer matches the modified name
setreg a0, :__CLANTAG_modified_player_name
setreg a1, $00726434
lw a1, $0000(a1)
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :CLAN__end
nop

// else name matches player name pointer

//////////////////////////////////////////////////
// FIND PLAYER PERSONA
//////////////////////////////////////////////////

__FIND_PLAYER_PERSONA:

// copy name with out tag pointer back to name pointer
setreg a0, :__CLANTAG_modified_player_name
lui a1, $0072
lw a1, $6434(a1) // get name pointer
jal :__string_copy
nop

// get initial player pointer and stopping address
setreg t0, $004414c4
setreg t2 $00441584 // stopping point

__check_name:
beq t0, t2 :CLAN__end //check if last player slot
nop

// check if player slot has pointer
lw t1, $0000(t0) // get string
beq t1, zero :__increment_player_persona_ptr
nop

addiu a0, t1, $000e // get player pointer name
setreg a1, :__CLANTAG_modified_player_name 
sw t0, $0060(sp)
sw t1, $0070(sp)
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
lw t0, $0060(sp) //restore variables
lw t1, $0070(sp) //restore variables
beq v0, zero :__write_clan_tag
nop

__increment_player_persona_ptr:
beq zero, zero :__check_name
addiu t0, t0, $0008 // increment to next address

__write_clan_tag:
// write clan tag
// strcpy; a1 = ptr to copy from
// strcpy; a0 = ptr to copy to
setreg a0, :__CLANTAG_clan_tag
sw t0, $0060(sp)
sw t1, $0070(sp)
// jal $00199060 //strcpy
jal :__string_copy
addiu a1, t1, $002e
lw t0, $0060(sp) //restore variables
lw t1, $0070(sp) //restore variables

// write player name
setreg a0, :__CLANTAG_modified_player_name  // player name copy pointer
addiu a1, t1, $E
//jal $00199060 //strcpy
jal :__string_copy
nop

CLAN__end:
lw ra, $0000(sp)
lw t0, $0004(sp)
lw t1, $0008(sp)
lw a0, $000c(sp)
lw a1, $0010(sp)
lw a3, $0014(sp)
lw s0, $0018(sp)
lw s1, $001c(sp)
lw s2, $0020(sp)
lw v0, $0024(sp)
jr ra
addiu sp, sp, $00A0

__string_copy:
addu t0, a0, zero // source pointer
addu t1, a1, zero // destination pointer

sc__next_byte:
lb t2, $0000(t0)
beq t2, zero :__end_string_copy
nop
sb t2, $0000(t1)
addiu t0, t0, $1
addiu t1, t1, $1
beq zero, zero :sc__next_byte
nop

__end_string_copy:
// store 0 to end of string to end string
sb zero, $0000(t1)

jr ra
nop

// This function saves the original player name @ 000D17A0
// and seperates the clan tag from the player name if the clan tag exists.

// original name: 000D17A0
// clan tag: 000d13a0 
// modified name: 000D13D0 





__CLAN_TAGS_initnetwork_hook:

addiu sp, sp, $ff70
sw ra, $0000(sp)
sw t0, $0004(sp)
sw t1, $0008(sp)
sw a0, $000c(sp)
sw a1, $0010(sp)
sw a3, $0014(sp)
sw s0, $0018(sp)
sw s1, $001c(sp)
sw s2, $0020(sp)
sw v0, $0024(sp)

// copy player name to storage address
setreg a0, $00726434
lw a0, $0000(a0)
setreg a1, :__CLANTAG_original_player_name // player name copy pointer
//jal $00199060 //strcpy
jal :__string_copy
nop

// get player name ptr
setreg t0, $00726434
lw t0, $0000(t0)

// check if clan tag bracket exists
lb t1, $0000(t0)
addiu t2, zero, $5B
bne t1, t2  :__no_clan_tag //skip function if clan tag does not exist.
nop

//////////////////////////////////////////////////
// SEPERATE CLAN TAG AND USER NAME
//////////////////////////////////////////////////

__get_tag:
// else clan tag exists.
// determine length of tag

addiu t0, t0, $1 // increment player name pointer
setreg t2, :__CLANTAG_clan_tag // clan tag storage
addiu t3, zero, $5D // ] bracket

__loop_tag_copy:
lb t4, $0000(t0) // get character from name
beq t4, t3 :__end_tag_copy
nop

sb t4, $0000(t2) // store character in to clan tag storage
addiu t0, t0, $1 // increment player name pointer
addiu t2, t2, $1 // increment clan tag store pointer
beq zero, zero :__loop_tag_copy
nop

__end_tag_copy:
addiu t0, t0, $1 // increment player name pointer

__get_player_name:
// store player name
setreg t2, :__CLANTAG_modified_player_name  // player name storage

__loop_name_copy:
lb t4, $0000(t0) // get character from name
beq t4, zero :__end_name_copy
nop

sb t4, $0000(t2) // store character in to player name storage
addiu t0, t0, $1 // increment player name pointer
addiu t2, t2, $1 // increment player name storage pointer
beq zero, zero :__loop_name_copy
nop

__end_name_copy:

__no_clan_tag:
lw ra, $0000(sp)
lw t0, $0004(sp)
lw t1, $0008(sp)
lw a0, $000c(sp)
lw a1, $0010(sp)
lw a3, $0014(sp)
lw s0, $0018(sp)
lw s1, $001c(sp)
lw s2, $0020(sp)
lw v0, $0024(sp)
jr ra
addiu sp, sp, $0090




__CLAN_TAG_clear:

// original name: 000D17A0 >> 97100
// clan tag: 000d13a0 >> 97140
// modified name: 000D13D0 >> 97180
setreg t0, :__CLANTAG_original_player_name
sq zero, $0000(t0)
setreg t0, :__CLANTAG_clan_tag
sq zero, $0000(t0)
setreg t0, :__CLANTAG_modified_player_name
sq zero, $0000(t0)

jr ra
nop








