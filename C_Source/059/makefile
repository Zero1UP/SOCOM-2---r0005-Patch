EE_BIN  = r0005-UNPACKED.elf
EE_BIN_PACKED = r0005-packed.elf
EE_OBJS = main.o asm.o #systemHook.s
EE_LDFLAGS = -L$(PS2SDK)/sbv/lib 
EE_LIBS = -lpad -ldebug -lcdvd -lc -lmc -lpatches -lkernel

all: $(EE_BIN)
	ps2_packer/ps2_packer -p zlib $(EE_BIN) $(EE_BIN_PACKED)
	cp -f --remove-destination $(EE_BIN_PACKED) $(EE_BIN_DIR)/$(EE_BIN)

#release: $(EE_BIN)
#	 sjcrunch $(EE_BIN) packed.elf

clean:
	rm -f *.elf *.o

install:

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal