

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




__code_decryption_fnc:
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



//-----------------init
// start address
daddu s0, a0, zero
// output address
setreg s1, :decryption__output
// crypto key
setreg s2, :decryption__key
// store counter
addu s3, zero, zero
// counter max
addiu s4, zero, $8

//-----------------crypto
// Must load each byte seperatly due to freezing. Must be some sort of kernal issue.
decryption__next_byte:
// check for 4 bytes of 00
lb s5, $0000(s0)
bne s5, zero, :decryption__continue
nop
lb s5, $0001(s0)
bne s5, zero, :decryption__continue
nop
lb s5, $0002(s0)
bne s5, zero, :decryption__continue
nop
lb s5, $0003(s0)
beq s5, zero, :decryption__end_crypto
nop

decryption__continue:

// get byte by from data stack
lb s5, $0000(s0)
// get byte from key stack
lb s6, $0000(s2)
bne s6, zero, :decryption__xor
nop

// if key byte is zero, reset key position to 0
setreg s2, :decryption__key
lb s6, $0000(s2)

decryption__xor:
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
bne s3, s4, :decryption__continue_loop
nop

// store data to address
setreg s1, :decryption__output
lw t0, $0000(s1) //get address
lw t1, $0004(s1) //get data
sw t1, $0000(t0) //save data to address
// reset counter
daddu s3, zero, zero

decryption__continue_loop:
// loop
beq zero, zero, :decryption__next_byte
nop

//-----------------end decryption
decryption__end_crypto:
// zero output address
sw zero, $0000(s1)
sw zero, $0004(s1)

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


__PATCHEDGAME:
addiu sp, sp, $ffe0
sw ra, $0000(sp)
sw a0, $0004(sp)
sw t0, $0008(sp)
sw t1, $000c(sp)

// set day maps bool
// I use this bool to determine if the player is in a patched game to enable all maps as day.
// PATCHED_GAME_BOOL = TRUE
setreg t0, :patched_game_BOOL
addiu t1, zero, $1
sw t1, $0000(t0)

// set patched game code stack
setreg a0, :__patchgame_codes
jal :__code_decryption_fnc
nop


lw ra, $0000(sp)
lw a0, $0004(sp)
lw t0, $0008(sp)
lw t1, $000c(sp)
jr ra
addiu sp, sp, $20

__PREPATCHEDGAME:
addiu sp, sp, $ffe0
sw ra, $0000(sp)
sw a0, $0004(sp)
sw t0, $0008(sp)
sw t1, $000c(sp)
// set day maps bool
// I use this bool to determine if the player is in a patched game to enable all maps as day.
// PATCHED_GAME_BOOL = FALSE
setreg t0, :patched_game_BOOL
sw zero, $0000(t0) //disable patch settings
setreg t0, :custom_game_BOOL
sw zero, $0000(t0) //disable custom maps


// set patched game code stack
setreg a0, :__prepatchgame_codes
jal :__code_decryption_fnc
nop

lw ra, $0000(sp)
lw a0, $0004(sp)
lw t0, $0008(sp)
lw t1, $000c(sp)
jr ra
addiu sp, sp, $20


// decrypted values stored in readme.txt
// game password key is stored here
__patchgame_codes:


//end
nop


// decrypted values stored in readme.txt
// game password key is stored here
__prepatchgame_codes:

//end
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

decryption__key:
hexcode $5fb82ffa
hexcode $d87f4abf
hexcode $a86214de
hexcode $c4cd8a96
hexcode $617e2671
nop






