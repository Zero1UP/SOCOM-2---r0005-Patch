


///////////////// FUNCTION HOOKS and Misc Code ////////////////////





// all maps respawn
address $002749E8 
hexcode $24100000
// all maps respawn
address $00274b00 
hexcode $24020005
// all maps respawn hook
address $002CED04
j :__all_maps_respawn


// CLAN TAG refresh hook 
address $00333B20
j :__clan_tag_fnc
// CLAN TAGS initnetwork hook
address $00276ECC
j :__CLAN_TAGS_initnetwork_hook
// This fnc clears all the name pointers that were created in earlier functions when logging off.
address $0027E600
j :__CLAN_TAG_clear



// CODE CHECK - come from LAN hook
address $00304604
j :__code_scanner2


// DAY MAPS --- FOG_FNC hook
address $00339E38
jal :__DAYMAPS__Fog_check
// disabled in FOG_FNC so the fog isn't loaded by default
address $00339E40
nop
// disabled in FOG_FNC so the fog isn't loaded by default
address $00339E48
nop
// DAY MAPS --- get original maps
address $00276DB4 // DMEInit HOOK
j :__DAYMAPS__get_original_maps
// DAY MAPS --- load map hook
address $002AF09C
jal :__LOAD_MAP

// DAY MAPS --- join game hook
address $002B96FC
jal :__JOIN_GAME

// DAY MAPS --- join game already in progress hook
address $002B9428
jal :__JOIN_GAME_ALREADY_IN_PROGRESS

// DAY MAPS --- end game hook (disable if host) original jal: 0027F810
address $002C08A8
jal :__END_GAME



// DEATH CAM --- Setup
address $002981D4
j :__death_cam_setup
// DEATH CAM --- follow check
address $002AA880
j :__death_cam_follow_check



// HOST --- determine host of game
address $0022A374
jal :__determine_host
nop



// PATCHED GAME --- prepatch
address $0027E4B8
j :__PREPATCHEDGAME
// PATCHED GAME --- End game results hook to reset
address $0027FF18
j :__END_GAME_RESULTS
// PATCHED GAME --- __create_game_fnc hook
address $00304250
j :__create_game_fnc
// PATCHED GAME --- keyboard close/enter hook
address $00367940
j :__close_keyboard
// PATCHED GAME --- hook from "does game have password" fnc
address $0027D438
j :__join_game_check



// LAN RANKS --- RECORD KILL HOOK
address $005452D4
jal :__LANRanks__record_kill
nop
// LAN RANKS --- RECORD DEATH HOOK
address $00545D54
jal :__LANRanks__record_death
nop
// LAN RANKS --- lobby hook
address $0029E04C
j :__get_rank



// SELECT MENU --- print select menu hook
address $002AAB18
j :__FNC_display

// version menu
address $0030DBA8
j :version__FNC_display


//////////////////////// Various Codes that require write on LAN LOAD /////////////////////////
// no text limit
address $0039A100 
hexcode $00000000

// all characters unlocked
address $00695630 
hexcode $00030001
address $00695644 
hexcode $00030001
address $00695658 
hexcode $00030001
address $0069566c 
hexcode $00030001
address $00695680 
hexcode $00030001
address $00695694 
hexcode $00030001
address $006956a8 
hexcode $00030001
address $006956bc 
hexcode $00030001

// force game display details
address $002E2080
nop




//------------------------------------------------------------------------------------------------
//////////////// Variables and Misc /////////////////////



// TEXT BOX --- pointer (used for patched games to check password)
address $000f6000
__text_box_pointer:


// KERNAL -- decrypted code output
address $000f7000 
kernal__output:


// CLANTAG: original player name
address $000f7100 
__CLANTAG_original_player_name:
// CLANTAG: clan tag
address $000f7140
__CLANTAG_clan_tag:
// CLANTAG: modified player name
address $000f7180 
__CLANTAG_modified_player_name:


// patched_game_BOOL
address $000f71B0
patched_game_BOOL:
// custom_game_BOOL
address $000f71B4
custom_game_BOOL:
// halo_game_BOOL
address $000f71B8
halo_game_BOOL:


// DEATH CAMERA --- Timer
address $000f71C0
__timer:


// Select Menu - output text
address $000f71D0 
__output_text:

// Select Menu - s0 variable
address $000f71F0
__s0_register:


// CODE CHECK - Stored data location (4 bytes)
address $000f75B0
CODECHECK__store_data_stack:

address $000f75D0
decryption__output:


// CUSTOM MAPS info stack
address $000f7600
__custom_maps_start:

// custom maps
hexcode :__abandoned_day
hexcode :__shadowfalls_day
hexcode :__sandstorm_day
hexcode :__fishhook_day
hexcode :__crossroads_day
hexcode :__mixer_day
hexcode :__blizzard_day
hexcode :__frostfire_day
hexcode :__desertglory_day
hexcode :__nightstalker_day
hexcode :__ratsnest_day
hexcode :__bitterjungle_day
hexcode :__bloodlake_day
hexcode :__deathtrap_day
hexcode :__ruins_day
// start original map listings
___custom_maps_stack_start:


//CHECK SUM BOOL --- Needed for the code scanner.
address $000F8FF0
__checksum_BOOL:


//------------------------------------------------------------------------------------------------






///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// CUSTOM FUNCTIONS START //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////





// Master Functions Start
address $000D0000


// all maps respawn
import "C:\r0005\MIPs_source\059\all maps respawn.cds"
nop

// code check
import "C:\r0005\MIPs_source\059\code check.cds"
nop

// clan tags
import "C:\r0005\MIPs_source\059\clan tag.cds"
nop

// day maps
import "C:\r0005\MIPs_source\059\day maps.cds"
nop

// death camera
import "C:\r0005\MIPs_source\059\death cam.cds"
nop

// host
import "C:\r0005\MIPs_source\059\host.cds"
nop


// LAN Ranks
import "C:\r0005\MIPs_source\059\LAN Ranks.cds"
nop

// Join patched games
import "C:\r0005\MIPs_source\059\join patched games_new.cds"
//import "C:\r0005\MIPs_source\059\join patched games.cds"
nop

// Select Menu
import "C:\r0005\MIPs_source\059\select screen.cds"
nop

// Version menu
import "C:\r0005\MIPs_source\059\version_display.cds"
nop









