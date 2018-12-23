




--- Credits 12-15-2018 ---

gtlcpimp - code designer 2.3, kernel hook.
various socom hackers - various codes, exploits, etc.






----------------------------------------------------------------------
To get started
----------------------------------------------------------------------


Extract the r0005.zip folder to C:/

*** example: C:/r0005 ***


Most up to date patch info: http://update.ps2.host/r0005/


** r0005 folder root **
- C_source: source for ELF
- MIPs_source
-- 059: Version 59 source files
---- debug: Debug files for generating checksums
- Programs: Various programs needed to convert code quickly.
-- Code Designer: Needed for opening/compiling .cds files.


----------------------------------------------------------------------
How the patch works
----------------------------------------------------------------------
1. 
- ELF writes Patch kernel and user memory functions.
**NOTE: ELF is nothing more than a capsule for injecting the patch code. The included ELF source does not work on all PS2s. You can also try the "auto updating" ELF @ https://github.com/Based-Skid/Ps2-Remote-ASM
2. 
- Patch kernel checks to see if SOCOM LAN is loaded. Once LAN loads it writes all the user memory hooks.
- On LAN load the patch will start scanning functions for invalid checksums. On finding an invlalid checksum the game will freeze. This is known as the kernel scanner.
3.
- When creating or joining a patch game the password key will be decrypted and overwritten.
- This key is always encrypted as it is the main security for patch games.
4.
- Once in game(map loaded) a user memory code scanner will start. This scanner is faster than the kernel scanner but is more vulnerable. This scanner will be idle when returning to the game lobby.



----------------------------------------------------------------------
New patch game password method
----------------------------------------------------------------------

--Address
create game key: 0030D278
join game key: 002BC7D0
rejoin game key: 0030D43C
hashed password location: 0045A1A8

--Values
Default Key: 7F0000FE
Example Patch Key: 592501D2
Patch Key setup(this is backwards for the sake of reading left to right)
1st byte: Patch version # ex: 59
2nd byte: Patch build # ex: 25
3rd byte: Can be anything. ex: 01
4th byte: Can be anything. ex: D2


Assuming a patched game is created(ex: example password = !123456):
1. The 2nd char of the password is changed to a char that can not be typed.
2. The rest of the password is XOR'd with a simple key.
3. The password key is changed in 3 locations(join game, create game, rejoin game).

Knowing the password at this point will not help. The player must also have the patch key.



----------------------------------------------------------------------
When creating a new patch revision:
----------------------------------------------------------------------

1. Change the patch game password key.
- Do note the password key is located in the "join patched games.cds" file.
2. Change patch version in "r0005_crypto" and "patch_display".

(optional) Change "Master Functions Start" address. 
(optional) Change master functions order.


----------------------------------------------------------------------
When compiling new patch
----------------------------------------------------------------------

.CDS File Notes

r0005 crypto.cds 
- This file contains all kernel code and will include all code from functions_write.cds. You must run all the hooks/variables from functions_write.cds through the Encryptor program. Take the output and paste it under the "kernal__data:" label. 
- These encrypted hooks/variables are wrote on LAN connect.

functions_write.cds
- The top of this file contains all hooks and variables for all functions. Do not change these.
- The bottom of this file contains imports of all patch functions.

All other .cds files:
- These are all functions for the patch. They will be stored in memory at the "Master Functions Start" address which is 0xD0000 by default.


1. Compile "functions_write.cds".
2. Copy all hooks from the compiled code of "functions_write.cds" and run those through the encryptor. 
3. Paste encryptor output in "r0005 crypto.cds" code stack section at the bottom under "kernal__data:" label. 
Note: This is done so the hooks are constant write. SOCOM 2 will overwrite these on main load so they must be written constantly.
4. Compile "r0005 crypto.cds". Copy compiled code. You can now run this code through the "MIPS to C" program and paste it in the default ELF file or you can create an update file for the auto updating ELF with instructions below.


----------------------------------------------------------------------
Creating an update file 
----------------------------------------------------------------------

1. Follow the instructions above to compile the patch.
2. Run the "Patch Compiler.exe" and paste the compiled code from "r0005 crypto.cds".
3a. (OPTIONAL) Enable the "Encryption" checkbox. This will XOR the patch with a key.
3b. Encryption Key: FED04AC6D427C07904E76226D8A47F92059DC5AAF0347664D1A4FA22542AFFCD.
4. Click "SAVE" button. A file called "update.dat" will be created in the same folder as the Patch Compiler program.


----------------------------------------------------------------------
NEW - variables and function locations
----------------------------------------------------------------------
Variables start @ 000f6000

old - new
00096000 - 000f6000 - textbox pointer used for passwords
00097000 - 000f7000 - Decrypted code output

000D17A0 - 000f7100 - CLANTAG: original player name
000D13A0 - 000f7140 - CLANTAG: clan tag
000D13D0 - 000f7180 - CLANTAG: modified player name

000C1FF0 - 000f71B0 - patched game BOOL
000C1FF4 - 000f71B4 - custom game BOOL
000C1FF8 - 000f71B8 - halo game BOOL

000D6124 - 000f71C0 - Death Camera Timer

000A0FA0 - 000f71D0 - Select Menu - output text
000A12D0 - 000f71F0 - Select Menu - s0 variable (used by text printing functions)

000D34C8 - 000f75B0 - CODE CHECK - Stored data location (4 bytes)

000CD0D0 - 000f7600 - Custom maps pointer stack


Kernal Variables(stored in user memory, can not modify kernal during runtime):
000f8fe0 - Checksum stack position 
000f8ff0 - CHECKSUM BOOL. Will = 1 if valid checksum.
000f8ff4 - MAIN CODES FNC BOOL. Will = 1 if checksum function is in tact. 
           Will = 0 if check fnc is disabled or missing.
000f8ff8 - MAIN FUNCTION timer
000f8ffc - codes enabled BOOL



Functions start @ 0x000D0000
Note: This can be changed in the "functions_write.cds" file. Functions can start anywhere between 0xA0000-0xE0000.

Files to compile:
1. Functions Write: Contains all functions and hooks.
2. Put hooks in kernal function.



----------------------------------------------------------------------
Encrypted codes in CDS files
----------------------------------------------------------------------

__patchgame_codes:

disable wall sliding new (r0004 style)
0057E348 0000102D
disable multiplayer join game failure
003039E4 10000004
disable voice mod
003DF1A8 00000000
disable encryption and decryption
0062A79C 00000000
0062A838 00000000
password key join game
0030D278 3C035925
0030D27C 346301D2
password key initial join game
0030D43C 3C035925
0030D440 346301D2
password key create game
002BC7C0 3C035925
002BC7C8 346401D2


__prepatchgame_codes:

enable wall sliding new
0057E348 8E2210AC
enable multiplayer join game failure check
003039E4 10000004
disable voice mod(keep disabled)
003DF1A8 00000000
enable encryption and decryption
0062A79C 00C53026
0062A838 00832026
password key join game
0030D278 3C037F00
0030D27C 346300FE
password key initial join game
0030D43C 3C037F00
0030D440 346300FE
password key create game
002BC7C0 3C037F00
002BC7C8 346400FE



-------------------------------------------------------------------------------


*** OLD COMPILE METHOD for v58 or older ***



The "main.c" in the "r0005\C_source\058 folder" is nothing more than a capsule for the assembly code. 


1. Open the "compile_normal.cds" located in "r0005\MIPs_source\058". It will have code that looks like this:

import "C:\r0005\MIPs_source\058\small codes.cds"
import "C:\r0005\MIPs_source\058\all maps respawn.cds"
import "C:\r0005\MIPs_source\058\LAN Ranks.cds"
import "C:\r0005\MIPs_source\058\clan tag.cds"
import "C:\r0005\MIPs_source\058\day maps.cds"
import "C:\r0005\MIPs_source\058\death cam.cds"
import "C:\r0005\MIPs_source\058\select screen.cds"
import "C:\r0005\MIPs_source\058\join patched games .cds"
import "C:\r0005\MIPs_source\058\code check.cds"
import "C:\r0005\MIPs_source\058\host.cds"

***NOTE: These import locations can be changed to anywhere.***

This code gathers all the assembly code for each function and compiles it in to one window. Makes it easier to copy all the code.


2. Compile the code with Code Designer. Now press the copy button. (Code designer v2.3 included)


3. Open "Code Stack Encryptor.exe" located in "r0005\Programs".
- Paste the copied code from code designer in to the INPUT colum in "Code Stack Encryptor.exe".
- Hit CONVERT button.
- Copy code from OUTPUT Window.

4. Open "r0005 crypto.cds" located in "r0005\MIPs_source\058" with Code Designer.
- Scroll down to the bottom of the window. You will see the following comments:

//---------------- CODE STACK HERE



//----------------- end code stack

- Paste the OUTPUT code from the "Code Stack Encryptor.exe" program between the "CODE STACK HERE" and "end code stack" comments in the Code designer window.
- Click "Compile" button in bottom right of code designer.
- Click the "Copy" button in the bottom right of code designer.

5. Open "MIPStoC.exe" located in "r0005\Programs".
- Paste copied code in INPUT column. 
- Press CONVERT button.
- Copy code in OUTPUT column.

6. Open "main.c" located in "r0005\C_source\058" with a C editor such as Crimson Editor or Notepad.
- Scroll down to line 488. You should see the following code:

ee_kmode_enter();
			
// write kernal functions

ee_kmode_exit();


- Paste the OUTPUT code from the "MIPStoC.exe" program directly below the "write kernal functions" comment.

- Compile the main.C file using ps2sdk. I usually call the compiled ELF r0005.ELF.

- Pack the compiled ELF with ps2_packer.exe(included in "r0005\C_source\058") and name the packed ELF something like "r0005v58.ELF". This is done so the ELF can't be opened with PS2DIs and easily read. It also eliminates all labels.

7. Test the ELF with PCSX2 or PS2.


