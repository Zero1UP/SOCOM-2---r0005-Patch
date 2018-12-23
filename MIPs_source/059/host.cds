


// host ID: 00C49760

// s0 = pptr
// add 1 to host id

// s3 = colors
/* 

offsets:

-8 - R
-4 - G
0 - B

*/

/*




find_host(host_ID, player_ID)
{

    if (host_ID <= 3)
    {
        is_host = true;
    }

    else if (host_ID + 1 == player_ID || host_ID + 2 == player_ID ||
        host_ID - 1 == player_ID || host_ID - 2 == player_ID)
    {
        is_host = true;
    }
    else
    {
        is_host = false;
    }

    return is_host;
}


*/






__determine_host:




// get player ID
lhu t0, $0004(s0)
// load host ID
lui t1, $00C5
lhu t1, $9760(t1)
// check if host ID equals player ID(should only happen if player ID = 3)
beq t1, t0 :__is_host
nop

// check if host id is 0 (equivalent player id <= 3)
//beq t1, zero, :__hostID_zero
//nop


// check if player ID is +/- 1 or 2
// add 1
addiu t2, t0, $1
// else continue normal ID check
beq t2, t1 :__is_host
nop
// add 2
addiu t2, t0, $2
// else continue normal ID check
beq t2, t1 :__is_host
nop
// add 3
addiu t2, t0, $3
// else continue normal ID check
beq t2, t1 :__is_host
nop
// sub 1
addiu t2, t0, $ffff
// else continue normal ID check
beq t2, t1 :__is_host
nop
// sub 2
addiu t2, t0, $fffe
// else continue normal ID check
beq t2, t1 :__is_host
nop
// sub 3
addiu t2, t0, $fffd
// else continue normal ID check
beq t2, t1 :__is_host
nop



// is NOT host
beq zero, zero, :host__skip
nop

// if host id is zero player id should <= 3
__hostID_zero:
// check if player ID is <= 3 while host ID is 0, if so player is host
slti t1, t0, $4 // if player ID < 4 { t1 = 1 } else{ t1 = 0 }
beq t1, zero :host__skip
nop


// player is host, change name color stored in s3
__is_host:

// R
lui t0, $4228
addiu t1, s3, $FFF8
sw t0, $0000(t1)
// G
lui t0, $42E6
addiu t1, s3, $FFFC
sw t0, $0000(t1)
// B
lui t0, $4220
sw t0, $0000(s3)


host__skip:

// original data
dsll32 v0, v0, 27
jr ra
dsrl32 v0, v0, 31

