







__halo_text:
print "HALO MODE"
nop
__KDR_text:
print "KDR: %.1f"
nop
__patched_text:
print "PATCHED GAME"
nop

// This function setups up a text stack before calling fnc:print_text
__FNC_display:
addiu sp, sp, $FF80
sw ra, $0000(sp)
sw t9, $0004(sp)
sw s0, $0008(sp)
sw v0, $000c(sp)
sw v1, $0010(sp)
sw a0, $0014(sp)
sw a1, $0018(sp)
sw a2, $001c(sp)
sw a3, $0020(sp)

//////////////////////////////////////////
// print: Menu enabled/disabled
// render text

// check menu BOOL
setreg t0, $00849E92
lb t0, $0000(t0)
beq t0, zero, :__no_render
nop

// ----------------------------------MODE

// check if HALO MODE
setreg t0, :halo_game_BOOL
lb t1, $0000(t0)
beq t1, zero, :__check_patched_game
nop

// halo mode
__check_halo_mode:
setreg a0, :__halo_text
beq zero, zero, :__mode_continue
nop

__check_patched_game:
setreg t0, :patched_game_BOOL
lb t1, $0000(t0)
// if not patched the game is normal
beq t1, zero, :__no_render
nop

// patched game
setreg a0, :__patched_text

__mode_continue:
setreg a1, $42340000
setreg a2, $434C0000
setreg a3, $3F4CCCCD
setreg t0, $43000000
setreg t1, $43000000
setreg t2, $43000000
setreg t3, $42B40000
jal :__print_text
nop

// ----------------------------------KDR

// get kills and deaths, check if either are zero
lui t0, $000F
lw t1, $0FF0(t0) //kills
lw t2, $0FF4(t0) //deaths

//check if kills > 0 and deaths = 0
beq t1, zero, :__zero_deaths
nop
bne t2, zero, :__continue
nop

//player has >0 kills and <=0 deaths
//force deaths = 1 so KDR shows
beq zero, zero, :__continue
lui t2, $3f80


//check if deaths = 0 to avoid dividing by 0
bne t2, zero, :__continue
nop

// zero deaths
__zero_deaths:
daddu v0, zero, zero
beq zero, zero, :__create_string
nop

__continue:
mtc1 t1, $f1
mtc1 t2, $f2
div.s $f12, $f1, $f2

// convert floating point
jal $001A0720
nop

// create string
__create_string:
setreg a0, :__output_text //addiu a0, sp, $30 //destination
setreg a1, :__KDR_text //source
daddu a2, v0, zero
jal $001988D0 //sprintf
nop

// print text
setreg a0, :__output_text //addiu a0, sp, $30 
setreg a1, $42340000
setreg a2, $43600000
setreg a3, $3F4CCCCD
setreg t0, $43000000
setreg t1, $43000000
setreg t2, $43000000
setreg t3, $42B40000
jal :__print_text
nop

__no_render:
lw ra, $0000(sp)
lw t9, $0004(sp)
lw s0, $0008(sp)
lw v0, $000c(sp)
lw v1, $0010(sp)
lw a0, $0014(sp)
lw a1, $0018(sp)
lw a2, $001c(sp)
lw a3, $0020(sp)
jr ra
addiu sp, sp, $80


//----------------------------------------------
// print text fnc
/*
args:
a0: ptr to text to render
a1: X offset
a2: Y offset
a3: text size
t0: text color RED
t1: text color GREEN
t2: text color BLUE
t3: text color ALPHA
*/

// this fnc was wrote by Antix
__print_text:

addiu sp, sp, $FF00
sw ra, $0000(sp)
sw s0, $0004(sp)

setreg s0, :__s0_register // pointer setup start
setreg v0, $00406DF0
sw v0, $000c(s0)
setreg v0, $3F8000CD
sw v0, $0014(s0)

sw a0, $001c(s0)

addiu v0, zero, $000F
sw v0, $0020(s0)
addiu v0, zero, $0006
sw v0, $0024(s0)
// X and Y offsets
setreg v0, $414ED2E3
sw v0, $0038(s0)
setreg v0, $42740000
sw v0, $003c(s0)
// set text size
sw a3, $0040(s0)

sw t0, $0048(s0)
sw t1, $004c(s0)
sw t2, $0050(s0)
sw t3, $0054(s0)

setreg v0, $80800051
sw v0, $005c(s0)

setreg v0, $0040D57C //--game    //004A1120 --lobby?
lw v0, $0000(v0)
sw v0, $0018(s0)

setreg v0, $004067B0
sw v0, $0060(s0)
addiu v0, zero, $0100
sw v0, $0068(s0)
addiu v0, zero, $015e
sw v0, $0070(s0)
setreg v0, $3F800000
sw v0, $0078(s0)
sw a1, $0090(s0) // X offset
sw a2, $0094(s0) // Y offset
setreg v0, $0000EC60
sw v0, $0098(s0)
setreg v0, $3F801B00
sw v0, $009c(s0)
setreg v0, $00488DF8

setreg v0, $00406C10
sw v0, $0100(s0)

setreg v0, $00488DF8
lw v0, $0000(v0)
sw v0, $0104(s0)

addiu a1, s0, $0100
daddu a0, s0, zero
jal $003635C0 // print text fnc
nop

lw s0, $0004(sp)
lw ra, $0000(sp)
jr ra
addiu sp, sp, $0100


















