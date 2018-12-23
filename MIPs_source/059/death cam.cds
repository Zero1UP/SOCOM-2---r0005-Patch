

// 3 second death cam






/////////////////////////////////////////////////////////////////
//
// CHECK SUM FNC
//
// a0 = function to scan
// a1 = checksum to compare to
// v0 = zero if checksums are identical, 1 if they are different
// v1 = calculated checksum

DEATHCAM__FNC_checksum:

// move args in to temp registers
addu t0, a0, zero // function to check
addu t1, a1, zero // correct checksum
setreg t2, $03e00008
addu t3, zero, zero // zero calculated checksum register

DEATHCAM__next_address:
lw t4, $0000(t0) // get current address data
addu t3, t3, t4 // add to checksum
addiu t0, t0, $4 //increment function position
beq t4, t2 :DEATHCAM__last_address
nop
beq zero, zero :DEATHCAM__next_address
nop

DEATHCAM__last_address:
// this is needed to grab the address below the jr ra
lw t4, $0000(t0) // get current address data
addu t3, t3, t4 // add to checksum

// move calculated checksum to v1
addu v1, t3, zero

// t1 = correct checksum
// t3 = calculated checksum
beq t1, t3 :DEATHCAM___end_checksum
daddu v0, zero, zero
addiu v0, zero, $1

DEATHCAM___end_checksum:
jr ra
nop

//------------------------------------- DEATH CAMERA SETUP
// Function executes on player death.

__death_cam_setup:
addiu sp, sp, $FFF0
sw t0, $0000(sp)
sw t1, $0004(sp)
// set timer for 3 seconds
setreg t0, :__timer
addiu t1, zero, $c0
sw t1, $0000(t0)
//restore registers
lw t0, $0000(sp)
lw t1, $0004(sp)
j $00298230
addiu sp, sp, $10


//------------------------------------- DEATH CAMERA FOLLOW
// Function executes constantly during game play.

__death_cam_follow_check:
addiu sp, sp, $ffe0
sw v0, $0000(sp)
sw ra, $0004(sp)
// check if patch game
setreg t0, :patched_game_BOOL
lw t0, $0000(t0)
beq t0, zero, :CAM__end
nop
// get camera pointer
setreg t0, $00415FF0
lw t0, $0000(t0)
// check if camera ptr exists
beq t0, zero, :CAM__end
nop
// get player camera position
lb t1, $0144(t0)
// check if camera is following player
// 3 = camera follow player
addiu t2, zero, $3
// if camera is not following player END
bne t1, t2, :CAM__end
nop

// decrement timer
setreg t3, :__timer
lw t4, $0000(t3)
// if timer is already 0 SKIP
beq t4, zero, :__disable_death_cam
nop
// decrement by -1
addiu t5, t4, $fffe
// save timer value
sw t5, $0000(t3)
// check if timer is 0
bne t5, zero, :CAM__end
nop

__disable_death_cam:
// disable death camera follow
// 7 = player control camera
addiu t1, zero, $7
sb t1, $0144(t0)

CAM__end:

// check code scanner hook
// NOTE: This is a failsafe to check for code scanner 1. Do note this only checks for the 
//       code scanner in user memory. I do not have a way to check for the scanner in kernal.
/*
lui t0, $0030
lw t0, $4604(t0)
setreg t1, $08034C00
bne t0, t1, :__inifnite_loop2
nop
*/


// temp code
beq zero, zero, :DEATHCAM__end_code_check
nop

// infinite loop
DEATHCAM__inifnite_loop:
nop
beq zero, zero, :DEATHCAM__inifnite_loop
nop

DEATHCAM__end_code_check:
lw v0, $0000(sp)
lw ra, $0004(sp)
jr ra
addiu sp, sp, $20



