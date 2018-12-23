#include <tamtypes.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <kernel.h>
#include <sifrpc.h>
#include <iopcontrol.h>
#include <loadfile.h>
#include <fileio.h>
#include <debug.h>
#include "libpad.h"
#include "malloc.h"
#include "libcdvd.h"
//#include "r5900_regs.h"
#include <iopheap.h>
#include <sbv_patches.h>
#include <io_common.h>
#include <syscallnr.h>

#define TYPE_MC

// ASM.C
void PasteASM();
//
