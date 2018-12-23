

/*

rank on LAN
002EAFAC 2402000?

1 = Ensign
2 = Lieutenant
3 = Lieutenant Commander
4 = Captain
5 = Admiral


0029E04C - a refresh hook

total kills: 000F0FF0
total deaths: 000F0FF4


DEATH MOD HOOK
00545D6C

*/




__LANRanks__record_kill:
// original code
lhu v0, $000C(s1)
addiu v0, v0, $0001

// store kill for rank
setreg t0, $000F0FF0
lwc1 $f0, $0000(t0)
lui t1, $3f80
mtc1 $f1, t1
add.s $f0, $f0, $f1
swc1 $f0, $0000(t0)

jr ra
nop




__LANRanks__record_death:
// original code
lhu v1, $0012(s1)
addiu v1, v1, $0001


setreg t0, $000F0FF4
lwc1 $f0, $0000(t0)
lui t1, $3f80
mtc1 $f1, t1
add.s $f0, $f0, $f1
swc1 $f0, $0000(t0)

jr ra
nop

/////////////////////////////////////////////////////////



//--------------------- GET RANK FUNCTION


__get_rank:
/*
kill count ptr
+4 death count ptr
*/
setreg t0, $000f0FF0 // kills and deaths address
setreg t2, $002EAFAC // player rank
lui t3, $2402 //upper half of rank data

// check if player is 0:0
lw t4, $0000(t0)
bne t4, zero :LAN__skip
nop
lw t4, $0004(t0)
bne t4, zero :LAN__skip
nop

// else player is 0:0
// set lieutenant rank
beq zero, zero :__lieutenant
nop

LAN__skip:

lwc1 $f2, $0000(t0) //kills
lwc1 $f1, $0004(t0) //deaths
lw t1, $0004(t0)
beq t1, zero :__no_deaths // can not divide by zero
nop

// get KDR if player has deaths
div.s $f2, $f2, $f1 //get KDR

__no_deaths:

// if admiral
lui t1, $4040 // 3
mtc1 $f0, t1
c.lt.s $f2, $f0
bc1t :__captain
nop

ori t3, t3, $5
beq zero, zero :LAN__done
nop

// if captain
__captain:
lui t1, $3F99 // 1.2
mtc1 $f0, t1
c.lt.s $f2, $f0
bc1t :__lieutenant_comm
nop

ori t3, t3, $4
beq zero, zero :LAN__done
nop

// if lieutenant commander
__lieutenant_comm:
lui t1, $3F00 // 0.5
mtc1 $f0, t1
c.lt.s $f2, $f0
bc1t :__lieutenant
nop

ori t3, t3, $3
beq zero, zero :LAN__done
nop

// if lieutenant
__lieutenant:
lui t1, $3E4C // 0.2
mtc1 $f0, t1
c.lt.s $f2, $f0
bc1t :__ensign
nop

ori t3, t3, $2
beq zero, zero :LAN__done
nop

// else ensign (Less than 0.2)
__ensign:
ori t3, t3, $1

LAN__done:
sw t3, $0000(t2) //set player rank
jr ra
nop
















