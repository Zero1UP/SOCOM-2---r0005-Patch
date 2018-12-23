

/* 
fog color fnc

v1 + offset

d0-d8 - fog RGB
124 - fog intensity spread
128 - fog intensity distance

Other Notes: s3, s4, and s6 are unused.

00436540 - map names
shadow falls - mp64
abandoned - mp5
sandstorm - mp73

NV BOOL
0045C380 + 5dc
*/


////////////////////////////////
// FOG COLORS
____default_day_fog:
// RED
hexcode $3F1C9C9D
// GREEN
hexcode $3F1B9B9C
// BLUE
hexcode $3F088889
nop

____default_day_fog_darker:
// RED
hexcode $3F000000
// GREEN
hexcode $3EF5C28F
// BLUE
hexcode $3EF0A3D7
nop

// NIGHT FOG
____default_night_fog:
// RED
hexcode $00000000
// GREEN
hexcode $00000000
// BLUE
hexcode $00000000
nop

// SANDSTORM COLORS
// RED
____sandstorm:
hexcode $3ECCCCCD
// GREEN
hexcode $3EC28F5C
// BLUE
hexcode $3EB33333
nop
//
////////////////////////////////

// all maps original IDs
___shadowfalls_id:
print "mp64"
nop

___abandoned_id:
print "mp5"
nop

___sandstorm_id:
print "mp73"
nop

___vigilance_id:
print "mp51"
nop

___fishhook_id:
print "mp71"
nop

___crossroads_id:
print "mp72"
nop

___mixer_id:
print "mp52"
nop

___blizzard_id:
print "mp1"
nop

___frostfire_id:
print "mp2"
nop

___desertglory_id:
print "mp6"
nop

___nightstalker_id:
print "mp7"
nop

___ratsnest_id:
print "mp8"
nop

___bitterjungle_id:
print "mp9"
nop

___bloodlake_id:
print "mp10"
nop

___deathtrap_id:
print "mp11"
nop

___ruins_id:
print "mp12"
nop


// All map names altered for patch as day map IDs
// I used w/e ID wasn't used by other multiplayer maps.
___shadowfalls_day_id:
print "mp80"
nop

___abandoned_day_id:
print "mp21"
nop

___sandstorm_day_id:
print "mp89"
nop

___vigilance_day_id:
print "mp22"
nop

___fishhook_day_id:
print "mp23"
nop

___crossroads_day_id:
print "mp24"
nop

___mixer_day_id:
print "mp25"
nop

___blizzard_day_id:
print "mp26"
nop

___frostfire_day_id:
print "mp27"
nop

___desertglory_day_id:
print "mp28"
nop

___nightstalker_day_id:
print "mp29"
nop

___ratsnest_day_id:
print "mp30"
nop

___bitterjungle_day_id:
print "mp31"
nop

___bloodlake_day_id:
print "mp32"
nop

___deathtrap_day_id:
print "mp33"
nop

___ruins_day_id:
print "mp34"
nop




// ***NOTE*** map ID address: 00414E00

//////////////////////////////////////////////////
// SET FOG
//////////////////////////////////////////////////


__DAYMAPS__Fog_check:

addiu sp, sp, $ff80
sw a0, $0000(sp)
sw a1, $0004(sp)
sw v0, $0008(sp)
sw v1, $000c(sp)
sw s0, $0010(sp)
sw s1, $0014(sp)
sw s2, $0018(sp)
sw s3, $001c(sp)
sw s4, $0020(sp)
sw s5, $0024(sp)
sw ra, $0028(sp)
sw a2, $002c(sp)
sw a3, $0030(sp)

// check day maps bool
// PATCHED_GAME_BOOL = TRUE/1, FALSE/0
setreg s0, :patched_game_BOOL
lh s1, $0000(s0)
beq s1, zero :__normal_fog
nop

// CUSTOM_GAME_BOOL = TRUE/1, FALSE/0
setreg s0, :custom_game_BOOL
lh s1, $0000(s0)
beq s1, zero :__normal_fog
nop

/*
00436540 - map names
shadow falls - mp64
abandoned - mp5
sandstorm - mp73
*/

// set s4 as map name
setreg s4, $00436540


__RUINS:
daddu a0, s4, zero // move map name to a0
setreg a1, :___ruins_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__DEATHTRAP // check next map
nop
// set new fog color address
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop

__DEATHTRAP:
daddu a0, s4, zero // move map name to a0
setreg a1, :___deathtrap_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__BLOODLAKE // check next map
nop
// set new fog color address
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop

__BLOODLAKE:
daddu a0, s4, zero // move map name to a0
setreg a1, :___bloodlake_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__BITTERJUNGLE // check next map
nop
// set new fog color address
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop

__BITTERJUNGLE:
daddu a0, s4, zero // move map name to a0
setreg a1, :___bitterjungle_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__RATSNEST // check next map
nop
// set new fog color address
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop


__RATSNEST:
daddu a0, s4, zero // move map name to a0
setreg a1, :___ratsnest_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__NIGHTSTALKER // check next map
nop
// set new fog color address
setreg s3, :____default_day_fog
beq zero, zero :__DAYMAP_LONG_DRAW_DISTANCE
nop

__NIGHTSTALKER:
daddu a0, s4, zero // move map name to a0
setreg a1, :___nightstalker_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__DESERTGLORY // check next map
nop
// set new fog color address
setreg s3, :____default_day_fog_darker
beq zero, zero :__DAYMAP
nop


__DESERTGLORY:
daddu a0, s4, zero // move map name to a0
setreg a1, :___desertglory_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__FROSTFIRE // check next map
nop
// set new fog color address
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop

__FROSTFIRE:
daddu a0, s4, zero // move map name to a0
setreg a1, :___frostfire_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__BLIZZARD // check next map
nop
// set new fog color address
setreg s3, :____default_day_fog_darker
beq zero, zero :__DAYMAP_LIGHT
nop

__BLIZZARD:
daddu a0, s4, zero // move map name to a0
setreg a1, :___blizzard_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__MIXER // check next map
nop
// set new fog color address
setreg s3, :____default_day_fog_darker
beq zero, zero :__DAYMAP
nop

__MIXER:
daddu a0, s4, zero // move map name to a0
setreg a1, :___mixer_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__CROSSROADS // check next map
nop
// set new fog color address
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop


__CROSSROADS:
daddu a0, s4, zero // move map name to a0
setreg a1, :___crossroads_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__FISHHOOK // check next map
nop
// set new fog color address
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop



__FISHHOOK:
daddu a0, s4, zero // move map name to a0
setreg a1, :___fishhook_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__SHADOWFALLS // check next map
nop
// set new fog color address
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop


__SHADOWFALLS:
daddu a0, s4, zero // move map name to a0
setreg a1, :___shadowfalls_id
// check if map is shadow falls
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__VIGILANCE // check next map
nop
// set new fog color address
setreg s3, :____default_day_fog
beq zero, zero :__DAYMAP
nop

__VIGILANCE:
/* ***disabled since vigilance does not have fog.***
daddu a0, s4, zero // move map name to a0
setreg a1, :___vigilance_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__ABANDONED // check next map
nop
setreg s3, :____default_night_fog
beq zero, zero :__NIGHTMAP
nop
*/

__ABANDONED:
daddu a0, s4, zero // move map name to a0
setreg a1, :___abandoned_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__SANDSTORM // check next map
nop
setreg s3, :____default_day_fog
beq zero, zero :__DAYMAP_LONG_DRAW_DISTANCE
nop



__SANDSTORM:
daddu a0, s4, zero // move map name to a0
setreg a1, :___sandstorm_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__normal_fog // check next map
nop
setreg s3, :____sandstorm



__DAYMAP_LONG_DRAW_DISTANCE:
// fog colors
lwc1 $f4, $0000(s3) //R
lwc1 $f3, $0004(s3) //G
lwc1 $f2, $0008(s3) //B

// map draw distance
lw v1, $000c(sp) // restore v1
setreg t0, $44FA0000
sw t0, $00EC(v1)
sw t0, $00F0(v1)

// fog draw distance
setreg t0, $43960000
sw t0, $0124(v1)
setreg t0, $44960000
sw t0, $0128(v1)

// set light level to default of zero
lui s0, $004B
lui s1, $4170
sw s1, $4D4C(s0)

// disable night vision BOOL
setreg s0, $0045C380
lw s0, $0000(s0)
sw zero, $05DC(s0)


// screen color normal
setreg s0, $004B4D40
setreg s1, $3F800000
sw s1, $0000(s0)
setreg s1, $3F800000
sw s1, $0004(s0)
setreg s1, $3F4CCCCD
sw s1, $0008(s0)


// go to end
beq zero, zero :__end_fog
nop

__DAYMAP:
// fog colors
lwc1 $f4, $0000(s3) //R
lwc1 $f3, $0004(s3) //G
lwc1 $f2, $0008(s3) //B

// map draw distance
lw v1, $000c(sp) // restore v1
setreg t0, $44FA0000
sw t0, $00EC(v1)
sw t0, $00F0(v1)


// set light level to default of 15
lui s0, $004B
lui s1, $4170
sw s1, $4D4C(s0)

// disable night vision BOOL
setreg s0, $0045C380
lw s0, $0000(s0)
sw zero, $05DC(s0)

// screen color normal
setreg s0, $004B4D40
setreg s1, $3F800000
sw s1, $0000(s0)
sw s1, $0004(s0)
sw s1, $0008(s0)

__DAYMAP_LIGHT:
// fog colors
lwc1 $f4, $0000(s3) //R
lwc1 $f3, $0004(s3) //G
lwc1 $f2, $0008(s3) //B

// map draw distance
lw v1, $000c(sp) // restore v1
setreg t0, $44FA0000
sw t0, $00EC(v1)
sw t0, $00F0(v1)

// fog draw distance
setreg t0, $43480000
sw t0, $0124(v1)
setreg t0, $44610000
sw t0, $0128(v1)


// set light level to default of 5
lui s0, $004B
lui s1, $4120
sw s1, $4D4C(s0)

// disable night vision BOOL
setreg s0, $0045C380
lw s0, $0000(s0)
sw zero, $05DC(s0)

// screen color normal
setreg s0, $004B4D40
setreg s1, $3F800000
sw s1, $0000(s0)
sw s1, $0004(s0)
sw s1, $0008(s0)

// go to end
beq zero, zero :__end_fog
nop


__NIGHTMAP:
// fog colors
lwc1 $f4, $0000(s3) //R
lwc1 $f3, $0004(s3) //G
lwc1 $f2, $0008(s3) //B

// set light level to default of zero
//lui s0, $004B
//lui s1, $4170
//sw s1, $4D4C(s0)

// enable night vision BOOL
setreg s0, $0045C380
lw s0, $0000(s0)
addiu s1, zero, $1
sw s1, $05DC(s0)

// screen color for night effect
setreg s0, $004B4D40
setreg s1, $3F333333 //r
sw s1, $0000(s0)
setreg s1, $3F4CCCCD //g
sw s1, $0004(s0)
setreg s1, $3F800000 //b
sw s1, $0008(s0)

// go to end
beq zero, zero :__end_fog
nop

__normal_fog:
lw v1, $000c(sp) // restore v1
lwc1 $f4, $00D0(v1)
lwc1 $f3, $00D4(v1)
lwc1 $f2, $00D8(v1)

// screen color normal
setreg s0, $004B4D40
setreg s1, $3F800000
sw s1, $0000(s0)
sw s1, $0004(s0)
sw s1, $0008(s0)

// set light level to default of zero
lui s0, $004B
sw zero, $4D4C(s0)

__end_fog:


lw a0, $0000(sp)
lw a1, $0004(sp)
lw v0, $0008(sp)
lw v1, $000c(sp)
lw s0, $0010(sp)
lw s1, $0014(sp)
lw s2, $0018(sp)
lw s3, $001c(sp)
lw s4, $0020(sp)
lw s5, $0024(sp)
lw ra, $0028(sp)
lw a2, $002c(sp)
lw a3, $0030(sp)
jr ra
addiu sp, sp, $80


// --------------------------------------------------------------------------------


__DAYMAPS__get_original_maps:
addiu sp, sp, $ff80
sw a0, $0000(sp)
sw a1, $0004(sp)
sw v0, $0008(sp)
sw v1, $000c(sp)
sw s0, $0010(sp)
sw s1, $0014(sp)
sw s2, $0018(sp)
sw s3, $001c(sp)
sw s4, $0020(sp)
sw s5, $0024(sp)
sw ra, $0028(sp)
sw a2, $002c(sp)
sw a3, $0030(sp)


//get map list pointers
setreg s0, $00441658
lw s0, $0000(s0)
beq s0, zero, :___end_map_stack_create
nop


// set custom maps stack pointer
setreg s2, :___custom_maps_stack_start

// copy pointers custom location
__next_map_pointer:

// store pointer
lw s1, $0000(s0) // get map pointer
sw s1, $0000(s2)

// increment custom map stack
addiu s2, s2, $4

// increment loop
addiu s0, s0, $4 
lw s1, $0000(s0)

//loop
bne s1, zero :__next_map_pointer
nop


// set map #
setreg s0, $00441654
addiu s1, zero, $25 // original count = 16
sw s1, $0000(s0)

setreg s0, $00441658
setreg s1, :__custom_maps_start
sw s1, $0000(s0)


___end_map_stack_create:
lw a0, $0000(sp)
lw a1, $0004(sp)
lw v0, $0008(sp)
lw v1, $000c(sp)
lw s0, $0010(sp)
lw s1, $0014(sp)
lw s2, $0018(sp)
lw s3, $001c(sp)
lw s4, $0020(sp)
lw s5, $0024(sp)
lw ra, $0028(sp)
lw a2, $002c(sp)
lw a3, $0030(sp)
jr ra
addiu sp, sp, $80



// Altered map listing. Includes all original maps plus altered day maps.
// original maps are added via the above function

//address $00441658
//hexcode $000CD000





// -------------------------------------------------



__abandoned_day:
hexcode $41424112
hexcode $41445F4E
hexcode $00000059
hexcode $00000001 // enabled
hexcode $00000015 // map id (og id was 5, add 10 to id for unique id, needed for MAP LOAD below)
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__shadowfalls_day:
hexcode $41485312
hexcode $5F574F44
hexcode $00594144
hexcode $00000001 // enabled
hexcode $00000050 // map id (og id was 5, add 10 to id for unique id, needed for MAP LOAD below)
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__sandstorm_day:
hexcode $4E415312
hexcode $41445F44
hexcode $00000059
hexcode $00000001 // enabled
hexcode $00000059 // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__fishhook_day:
hexcode $53494612
hexcode $494E5F48
hexcode $00544847
hexcode $00000001 // enabled
hexcode $00000017 // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__crossroads_day:
hexcode $4F524312
hexcode $494E5F53
hexcode $00544847
hexcode $00000001 // enabled
hexcode $00000018 // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__mixer_day:
hexcode $58494D12
hexcode $47494E5F
hexcode $00005448
hexcode $00000001 // enabled
hexcode $00000019 // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__blizzard_day:
hexcode $494C4212
hexcode $445F5A5A
hexcode $00005941
hexcode $00000001 // enabled
hexcode $0000001A // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__frostfire_day:
hexcode $4F524612
hexcode $445F5453
hexcode $00005941
hexcode $00000001 // enabled
hexcode $0000001B // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__desertglory_day:
hexcode $5F474412
hexcode $4847494E
hexcode $00000054
hexcode $00000001 // enabled
hexcode $0000001C // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__nightstalker_day:
hexcode $5F534E12
hexcode $00594144
hexcode $00000000
hexcode $00000001 // enabled
hexcode $0000001D // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__ratsnest_day:
hexcode $54415212
hexcode $41445F53
hexcode $00000059
hexcode $00000001 // enabled
hexcode $0000001E // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__bitterjungle_day:
hexcode $54494212
hexcode $494E5F54
hexcode $00544847
hexcode $00000001 // enabled
hexcode $0000001F // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__bloodlake_day:
hexcode $5F4C4212
hexcode $4847494E
hexcode $00000054
hexcode $00000001 // enabled
hexcode $00000020 // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__deathtrap_day:
hexcode $5F544412
hexcode $4847494E
hexcode $00000054
hexcode $00000001 // enabled
hexcode $00000021 // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031

__ruins_day:
hexcode $49555212
hexcode $494E5F4E
hexcode $00544847
hexcode $00000001 // enabled
hexcode $00000022 // map id 
hexcode $00000005 // map mode
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000000
hexcode $00000031



//-------------------------------------------------------------

/* 
ON MAP LOAD:
- check map id
- load map if id is normal
- if it matches an altered map value then load original map with altered fog/light
*/
// map name: a3+20
// 002ACD88


nop


__LOAD_MAP:
addiu sp, sp, $ff00
sq a0, $0000(sp)
sq a1, $0010(sp)
sq v0, $0020(sp)
sq v1, $0030(sp)
sq s0, $0040(sp)
sq s1, $0050(sp)
sq s2, $0060(sp)
sq s3, $0070(sp)
sq s4, $0080(sp)
sq s5, $0090(sp)
sq ra, $00A0(sp)
sq a2, $00B0(sp)
sq a3, $00C0(sp)

jal :__CHECK_MAP_ID
nop

lq a0, $0000(sp)
lq a1, $0010(sp)
lq v0, $0020(sp)
lq v1, $0030(sp)
lq s0, $0040(sp)
lq s1, $0050(sp)
lq s2, $0060(sp)
lq s3, $0070(sp)
lq s4, $0080(sp)
lq s5, $0090(sp)
lq ra, $00A0(sp)
lq a2, $00B0(sp)
lq a3, $00C0(sp)
j $00198C58
addiu sp, sp, $100



__JOIN_GAME:
addiu sp, sp, $fff0
sw ra, $0000(sp)

jal :__CHECK_MAP_ID
nop

lw ra, $0000(sp)
j $0027F810
addiu sp, sp, $10


__JOIN_GAME_ALREADY_IN_PROGRESS:
addiu sp, sp, $fff0
sw ra, $0000(sp)

// check if host
setreg t0, $0045A0C0
lb t0, $0000(t0)
bne t0, zero, :__IS_GAME_HOST2
nop

jal :__CHECK_MAP_ID
nop

__IS_GAME_HOST2:
lw ra, $0000(sp)
j $0027F810
addiu sp, sp, $10


__END_GAME:
addiu sp, sp, $fff0
sw ra, $0000(sp)

// check if host
setreg t0, $0045A0C0
lb t0, $0000(t0)
bne t0, zero, :__IS_GAME_HOST
nop

// is not host
jal :__CHECK_MAP_ID
nop

__IS_GAME_HOST:
lw ra, $0000(sp)
j $0027F810
addiu sp, sp, $10

//--------------------------------------------------------------
__CHECK_MAP_ID:

addiu sp, sp, $ff80
sw a0, $0000(sp)
sw a1, $0004(sp)
sw v0, $0008(sp)
sw v1, $000c(sp)
sw s0, $0010(sp)
sw s1, $0014(sp)
sw s2, $0018(sp)
sw s3, $001c(sp)
sw s4, $0020(sp)
sw s5, $0024(sp)
sw ra, $0028(sp)
sw a2, $002c(sp)
sw a3, $0030(sp)

// CHECK if patch game
// ----
// If someone trys to glitch a day map in to a regular game they will freeze because
// this function converts the day map ids to regular ids so the map will load.
setreg s0, :patched_game_BOOL
lw s1, $0000(s0)
beq s1, zero, :___exit_CHECK_MAP
nop

// get map ID from server
setreg s1, $00414E00
lw s4, $0000(s1)
beq s4, zero, :___exit_CHECK_MAP
nop

// check if abandoned day
__check_abandoned:
daddu a0, s1, zero
setreg a1, :___abandoned_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_shadowfalls // check next map
nop
setreg s2, :____default_day_fog
setreg s3, :___abandoned_id
beq zero, zero :__CUSTOM_MAP
nop

// check if shadow falls day
__check_shadowfalls:
daddu a0, s1, zero
setreg a1, :___shadowfalls_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_sandstorm // check next map
nop
setreg s2, :____default_day_fog
setreg s3, :___shadowfalls_id
beq zero, zero :__CUSTOM_MAP
nop

// check if sandstorm day
__check_sandstorm:
daddu a0, s1, zero
setreg a1, :___sandstorm_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_vigilance // check next map
nop
setreg s2, :____sandstorm
setreg s3, :___sandstorm_id
beq zero, zero :__CUSTOM_MAP
nop

// check if vigilance day
__check_vigilance:

daddu a0, s1, zero
setreg a1, :___vigilance_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_fishhook // check next map
nop
setreg s2, :____default_night_fog
setreg s3, :___vigilance_id
beq zero, zero :__CUSTOM_MAP
nop

// check if fishhook day
__check_fishhook:

daddu a0, s1, zero
setreg a1, :___fishhook_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_crossroads // check next map
nop
setreg s2, :____default_night_fog
setreg s3, :___fishhook_id
beq zero, zero :__CUSTOM_MAP
nop

// check if crossroads day
__check_crossroads:
daddu a0, s1, zero
setreg a1, :___crossroads_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_mixer // check next map
nop
setreg s2, :____default_night_fog
setreg s3, :___crossroads_id
beq zero, zero :__CUSTOM_MAP
nop


// check if mixer day
__check_mixer:
daddu a0, s1, zero
setreg a1, :___mixer_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_blizzard // check next map
nop
setreg s2, :____default_night_fog
setreg s3, :___mixer_id
beq zero, zero :__CUSTOM_MAP
nop

// check if blizzard day
__check_blizzard:

daddu a0, s1, zero
setreg a1, :___blizzard_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_frostfire // check next map
nop
setreg s2, :____default_day_fog
setreg s3, :___blizzard_id
beq zero, zero :__CUSTOM_MAP
nop

// check if frostfire day
__check_frostfire:
daddu a0, s1, zero
setreg a1, :___frostfire_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_desertglory // check next map
nop
setreg s2, :____default_day_fog
setreg s3, :___frostfire_id
beq zero, zero :__CUSTOM_MAP
nop

// check if desertglory day
__check_desertglory:
daddu a0, s1, zero
setreg a1, :___desertglory_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_nightstalker // check next map
nop
setreg s2, :____default_night_fog
setreg s3, :___desertglory_id
beq zero, zero :__CUSTOM_MAP
nop

// check if nightstalker day
__check_nightstalker:

daddu a0, s1, zero
setreg a1, :___nightstalker_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_ratsnest // check next map
nop
setreg s2, :____default_day_fog
setreg s3, :___nightstalker_id
beq zero, zero :__CUSTOM_MAP
nop

// check if ratsnest day
__check_ratsnest:
daddu a0, s1, zero
setreg a1, :___ratsnest_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_bitterjungle // check next map
nop
setreg s2, :____default_day_fog
setreg s3, :___ratsnest_id
beq zero, zero :__CUSTOM_MAP
nop

// check if bitterjungle day
__check_bitterjungle:

daddu a0, s1, zero
setreg a1, :___bitterjungle_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_bloodlake // check next map
nop
setreg s2, :____default_night_fog
setreg s3, :___bitterjungle_id
beq zero, zero :__CUSTOM_MAP
nop

// check if bloodlake day
__check_bloodlake:
daddu a0, s1, zero
setreg a1, :___bloodlake_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_deathtrap // check next map
nop
setreg s2, :____default_night_fog
setreg s3, :___bloodlake_id
beq zero, zero :__CUSTOM_MAP
nop

// check if deathtrap day
__check_deathtrap:
daddu a0, s1, zero
setreg a1, :___deathtrap_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :__check_ruins // check next map
nop
setreg s2, :____default_night_fog
setreg s3, :___deathtrap_id
beq zero, zero :__CUSTOM_MAP
nop

// check if ruins day
__check_ruins:
daddu a0, s1, zero
setreg a1, :___ruins_day_id
jal $00198f18 //strcmp: compare a0 and a1, v0 = result
nop
bne v0, zero :___exit_CHECK_MAP //exit map check
nop
setreg s2, :____default_night_fog
setreg s3, :___ruins_id
beq zero, zero :__CUSTOM_MAP
nop

// NORMAL MAP
beq zero, zero, :___exit_CHECK_MAP
nop

__CUSTOM_MAP:
// copy correct map name
lw s3, $0000(s3)
sw s3, $0000(s1) //map pointer 1
// copy correct map name 2
setreg s2, $00436540
sw s3, $0000(s2)

// enable custom fog/light function
addiu s3, zero, $1
setreg s0, :patched_game_BOOL
sw s3, $0000(s0)

// enable custom map BOOL
setreg s0, :custom_game_BOOL
sw s3, $0000(s0)

___exit_CHECK_MAP:
lw a0, $0000(sp)
lw a1, $0004(sp)
lw v0, $0008(sp)
lw v1, $000c(sp)
lw s0, $0010(sp)
lw s1, $0014(sp)
lw s2, $0018(sp)
lw s3, $001c(sp)
lw s4, $0020(sp)
lw s5, $0024(sp)
lw ra, $0028(sp)
lw a2, $002c(sp)
lw a3, $0030(sp)
jr ra
addiu sp, sp, $80




