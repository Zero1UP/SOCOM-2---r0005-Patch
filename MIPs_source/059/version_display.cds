


// Call "__FNC_display" constantly to print text


//address $002CED04
//j :version__FNC_display

//address $000b0000

version__title:
print "PATCH VERSION: 59"
nop

version__patchgame:
print "Patch Game: Create game with password starting with !."
nop
version__patchgame_ex:
print "ex: !12345678"
nop
version__halogame:
print "Halo Game: Create game with password starting with @."
nop
version__halogame_ex:
print "ex: @12345678"
nop

// This function setups up a text stack before calling fnc:print_text
version__FNC_display:
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

// check if mp_persistent is enabled
// this address = 1 as long as the player is not in game
lui t0, $0069
lb t0, $4C1C(t0)
bne t0, zero, :version__end
nop

// check joker
lui t0, $0045
lh t0, $F15C(t0)
addiu t1, zero, $FFFE // select
bne t0, t1, :version__end
nop


// title
setreg a0, :version__title
setreg a1, $43960000
setreg a2, $43200000
setreg a3, $3F800000
setreg t0, $43000000
setreg t1, $43000000
setreg t2, $42800000
setreg t3, $42DC0000
jal :version__print_text
nop

// Patch games
setreg a0, :version__patchgame
setreg a1, $43480000
setreg a2, $43340000
setreg a3, $3F4CCCCD
setreg t0, $43000000
setreg t1, $43000000
setreg t2, $43000000
setreg t3, $42B40000
jal :version__print_text
nop
// Patch games example
setreg a0, :version__patchgame_ex
setreg a1, $43480000
setreg a2, $43480000
setreg a3, $3F4CCCCD
setreg t0, $43000000
setreg t1, $43000000
setreg t2, $43000000
setreg t3, $42700000
jal :version__print_text
nop
// halo game
setreg a0, :version__halogame
setreg a1, $43480000
setreg a2, $435C0000
setreg a3, $3F4CCCCD
setreg t0, $43000000
setreg t1, $43000000
setreg t2, $43000000
setreg t3, $42B40000
jal :version__print_text
nop
// halo game ex
setreg a0, :version__halogame_ex
setreg a1, $43480000
setreg a2, $43700000
setreg a3, $3F4CCCCD
setreg t0, $43000000
setreg t1, $43000000
setreg t2, $43000000
setreg t3, $42700000
jal :version__print_text
nop


version__end:
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
version__print_text:

addiu sp, sp, $FF00
sw ra, $0000(sp)
sw s0, $0004(sp)

setreg s0, :__s0_register // pointer setup start
setreg v0, $00406DF0 //in game--00406DF0  //in menu--00407A90
sw v0, $000c(s0)
setreg v0, $0000004D //3F8000CD
sw v0, $0014(s0)

/*
setreg v0, $004A1120
lw v0, $0000(v0)
sw v0, $0018(s0)
*/

sw a0, $001c(s0)

addiu v0, zero, $000F
sw v0, $0020(s0)
addiu v0, zero, $000C //0006
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

setreg v0, $004A1120 //--lobby? //0040D57C //--game 
lw v0, $0000(v0) // 00DEFBA0
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

//setreg v0, $00406C10
sw zero, $0100(s0)

//setreg v0, $00488DF8
//lw v0, $0000(v0)
sw zero, $0104(s0)

//addiu a1, s0, $0100 // in game
setreg a1, $00408DC0 // in menu
daddu a0, s0, zero
addiu a2, zero, $1
addiu t0, zero, $1000
jal $003635C0 // print text fnc
nop

lw s0, $0004(sp)
lw ra, $0000(sp)
jr ra
addiu sp, sp, $0100

//__s0_register:
















