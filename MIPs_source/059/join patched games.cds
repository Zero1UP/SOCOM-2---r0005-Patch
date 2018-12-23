

/*

002E4620- hook to check for password
a0+1 = password
s1 = room name

0027D438 - does game have password
a0+1 = password

0027D410
a1 - room name

0027D418
a0+1 - password
a1+4 - room name

003FB850 = keyboard text

0039A6D0 - ptr for text box text
2039A6D0 3C050009
2039A6D4 24A56000

*/




__START_PW_FNCS:

__join_game_check:
addiu sp, sp, $FFE0
sw ra, $0000(sp)
sw a0, $0004(sp)
sw a1, $0008(sp)
sw a2, $000c(sp)
sw a3, $0010(sp)
sw v0, $0014(sp)
sw v1, $0018(sp)

// check if game has password
beq v0, zero :PATCH__normal_game
nop

// password pointer
addiu a1, a0, $1

// check if second letter is 0
// this is done to check if password is 1 character
lbu t0, $0001(a1)
beq t0, zero :PATCH__normal_game // check if zero first
nop


// ----------------- check for patched game
lbu t0, $0000(a1)
addiu t1, zero, $21 // "!" character
// check if first letter is "!"
bne t0, t1 :__check_halo_game
nop
// check if second letter is "F1"
// NOTE: I check for a second "identifier" letter that is otherwise impossible to type.
//       This keeps the player from force joining non-patch password games.
lbu t2, $0001(a1)
addiu t3, zero, $F1
beq t2, t3  :__normal_patch_game 
nop

// ----------------- check for HALO GAME MODE
__check_halo_game:
// check for halo game
lbu t0, $0000(a1)
addiu t1, zero, $40 // "@" character
// check if first letter is "@"
bne t0, t1 :PATCH__normal_game
nop

// check if second letter is "F1"
lbu t2, $0001(a1)
addiu t3, zero, $F1
bne t2, t3  :PATCH__normal_game
nop

// IS HALO GAME MODE

// disable render text address
// NOTE: Text is disabled for a few miliseconds. This is done to keep the user from seeing
//       the password.
setreg t0, $00363A9C
setreg t1, $10000008
sw t1, $0000(t0)

// force textbox to close address, this is the same as hitting ENTER on the keyboard
setreg t0, $0038CA64
sw zero, $0000(t0)

// set temp textbox ptr
setreg t0, $0039A6D0
setreg t1, $3C05000f // hard coded __text_box_pointer
sw t1, $0000(t0)
setreg t1, $24A56000
sw t1, $0004(t0)


// copy password to new textbox pointer
setreg a0, :__text_box_pointer //$00096000
jal $00199060
nop

__halo_game_MODE:
jal :__PATCHEDGAME
nop
jal :__enable_player_dynamics
nop

beq zero, zero :__end
nop

__normal_patch_game:
// disable render text address
setreg t0, $00363A9C
setreg t1, $10000008
sw t1, $0000(t0)

// force textbox to close address
setreg t0, $0038CA64
sw zero, $0000(t0)

// set temp textbox ptr
setreg t0, $0039A6D0
setreg t1, $3C05000f // hard coded __text_box_pointer
sw t1, $0000(t0)
setreg t1, $24A56000
sw t1, $0004(t0)


// copy password to new textbox pointer
setreg a0, :__text_box_pointer 
jal $00199060
nop

jal :__PATCHEDGAME
nop
jal :__disable_player_dynamics
nop

beq zero, zero :__end
nop

PATCH__normal_game:

jal :__PREPATCHEDGAME
nop
jal :__disable_player_dynamics
nop

__end:
lw ra, $0000(sp)
lw a0, $0004(sp)
lw a1, $0008(sp)
lw a2, $000c(sp)
lw a3, $0010(sp)
lw v0, $0014(sp)
lw v1, $0018(sp)
jr ra
addiu sp, sp, $20

__password_scramble:
// copy password ptr and increase to 3rd character
addiu t0, s4, $2
// set xor key
addiu t1, zero, $e4
__get_pw_byte:
// get password byte
lb t2, $0000(t0)
beq t2, zero, :__end_sramble
nop

// encrypt
xor t2, t2, t1
// store encrypted value in to password string
sb t2, $0000(t0)

beq zero, zero, :__get_pw_byte
addiu t0, t0, $1 //increment to next byte
__end_sramble:
jr ra
nop



//////////////////////////////////////////////////////
// Check if creating game is patched
//////////////////////////////////////////////////////



// 00304250
// s4 = password
// s5 = room name


__create_game_fnc:

// original code
bne s5, zero :__continue_check
nop

// jump to original address if s5 = zero
j $00304260
nop

__continue_check:
// check if second character is 0
// if password is one character long then ignore
lbu t1, $0001(s4)
beq t1, zero :__regular_game
nop

// check first character in password "!"
addiu t0, zero, $21 // "!"
lbu t1, $0000(s4) // get first character of password
beq t1, t0 :__is_patched_game
nop

// check first character in password "@"
addiu t0, zero, $40 // "@"
lbu t1, $0000(s4) // get first character of password
bne t1, t0 :__regular_game
nop
// GAME IS PATCHED
// replace second character with special char "F1"
// players will not know this changed.
addiu t0, zero, $F1
sb t0, $0001(s4)

// scramble rest of password
jal :__password_scramble
nop

beq zero, zero, :__HALO_GAME
nop

__is_patched_game:
// GAME IS PATCHED
// replace second character with special char "F1"
// players will not know this changed.
addiu t0, zero, $F1
sb t0, $0001(s4)

// scramble rest of password
jal :__password_scramble
nop

jal :__PATCHEDGAME
nop
jal :__disable_player_dynamics
nop

beq zero, zero :PATCH__continue
nop

__HALO_GAME:
jal :__PATCHEDGAME
nop
jal :__enable_player_dynamics
nop

beq zero, zero :PATCH__continue
nop

__regular_game:

jal :__PREPATCHEDGAME
nop
jal :__disable_player_dynamics
nop

PATCH__continue:
j $00304258
nop
__END_PW_FNCS:

//address $000A9300
__disable_player_dynamics:
// player dynamics normal
// max height falling death
setreg t0, $0044C260
setreg t1, $42E60000
sw t1, $0000(t0)
// gravity
setreg t0, $0044C250
setreg t1, $436B0000
sw t1, $0000(t0)
// jump
setreg t0, $0044C258
setreg t1, $3F59999A
sw t1, $0000(t0)
// player speed
lui t0, $0029
addiu t1, zero $3B80
sh t1, $9C4C(t0)
sh t1, $9CA4(t0)
// all weapons disable
lui t0, $0024
setreg t1, $0002102B
sw t1, $C6B8(t0)
// aim while jumping disable
lui t0, $0055
setreg t1, $AEA0023C
sw t1, $1978(t0)
lui t0, $005B
setreg t1, $AEC00000
sw t1, $FB68(t0)

// disable HALO BOOL
setreg t0, :halo_game_BOOL
sb zero, $0000(t0)
jr ra
nop

__enable_player_dynamics:
// player dynamics normal
// max height falling death
lui t0, $0045
lui t1, $47C3
sw t1, $C260(t0)
// gravity
lui t1, $4270
sw t1, $C250(t0)
// jump
lui t1, $4080
sw t1, $C258(t0)
// player speed
lui t0, $0029
addiu t1, zero $3BA0
sh t1, $9C4C(t0)
sh t1, $9CA4(t0)
// all weapons enable
lui t0, $0024
setreg t1, $24020001
sw t1, $C6B8(t0)
// aim while jumping enable
lui t0, $0055
sw zero, $1978(t0)
lui t0, $005B
sw zero, $FB68(t0)

// enable HALO BOOL
setreg t0, :halo_game_BOOL
addiu t1, zero, $1
sb t1, $0000(t0)
jr ra
nop

__PATCHEDGAME:
// set day maps bool
// I use this bool to determine if the player is in a patched game to enable all maps as day.
// PATCHED_GAME_BOOL = TRUE
setreg t0, :patched_game_BOOL
addiu t1, zero, $1
sw t1, $0000(t0)

// wall sliding old
//setreg t0, $0058BB5C
//setreg t1, $1000001C
//sw t1, $0000(t0)

// disable wall sliding new
setreg t0, $0057E348
setreg t1, $0000102D
sw t1, $0000(t0)

// disable multiplayer join game failure
setreg t0, $003039E4
setreg t1, $10000004
sw t1, $0000(t0)

// disable voice mod
setreg t0, $003DF1A8
sw zero, $0000(t0)

// disable encryption and decryption
setreg t0, $0062A79C
sw zero, $0000(t0)
setreg t0, $0062A838
sw zero, $0000(t0)

// set join game password key to altered
setreg t0, $0030D278
setreg t1, $3C035923
sw t1, $0000(t0)
setreg t0, $0030D27C
setreg t1, $346300F0
sw t1, $0000(t0)
// set initial join game password key to altered
setreg t0, $0030D43C
setreg t1, $3C035923
sw t1, $0000(t0)
setreg t0, $0030D440
setreg t1, $346300F0
sw t1, $0000(t0)
// set create game password key to altered
setreg t0, $002BC7C0
setreg t1, $3C035923
sw t1, $0000(t0)
setreg t0, $002BC7C8
setreg t1, $346400F0
sw t1, $0000(t0)


jr ra
nop


__PREPATCHEDGAME:
// set day maps bool
// I use this bool to determine if the player is in a patched game to enable all maps as day.
// PATCHED_GAME_BOOL = FALSE
setreg t0, :patched_game_BOOL
sw zero, $0000(t0) //disable patch settings
setreg t0, :custom_game_BOOL
sw zero, $0000(t0) //disable custom maps

// wall sliding NORMAL old
//setreg t0, $0058BB5C
//setreg t1, $1083001C
//sw t1, $0000(t0)

// wall sliding NORMAL new
setreg t0, $0057E348
setreg t1, $8E2210AC
sw t1, $0000(t0)

// enable multiplayer join game failure check
setreg t0, $003039E4
setreg t1, $14400004
sw t1, $0000(t0)

// disable voice mod
setreg t0, $003DF1A8
sw zero, $0000(t0)

// enable encryption and decryption
setreg t0, $0062A79C
setreg t1, $00C53026
sw t1, $0000(t0)
setreg t0, $0062A838
setreg t1, $00832026
sw t1, $0000(t0)

// set join game password key to normal
setreg t0, $0030D278
setreg t1, $3C037F00
sw t1, $0000(t0)
setreg t0, $0030D27C
setreg t1, $346300FE
sw t1, $0000(t0)
// set initial join game password key to normal
setreg t0, $0030D43C
setreg t1, $3C037F00
sw t1, $0000(t0)
setreg t0, $0030D440
setreg t1, $346300FE
sw t1, $0000(t0)
// set create game password key to normal
setreg t0, $002BC7C0
setreg t1, $3C037F00
sw t1, $0000(t0)
setreg t0, $002BC7C8
setreg t1, $346400FE
sw t1, $0000(t0)

jr ra
nop



__END_GAME_RESULTS:

// reset custom game
setreg t0, :custom_game_BOOL
jr ra
sw zero, $0000(t0) //disable custom maps




/* ------------------- Keyboard enter/close
- turn text back on.
- reset text rendering
- reset text box
*/


// new address
//address $0038CB78
//j $000C1400

//address $0027E52C


__close_keyboard:
// reset keyboard text pointer
setreg t0, $0039A6D0
setreg t1, $3c050040
sw t1, $0000(t0)
setreg t1, $24a5b850
sw t1, $0004(t0)

// render text address
setreg t0, $00363A9C
setreg t1, $10400008
sw t1, $0000(t0)

// set textbox back to normal
setreg t0, $0038CA64
setreg t1, $14430006
sw t1, $0000(t0)

jr ra
nop



// -------------------------------------------------
// Disconnect from game HOOK
// Reset patched game and custom map BOOL



// from another file (unused)
//address $000A3000
//__xor_calc:



