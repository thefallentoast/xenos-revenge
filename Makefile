# --- Paths ---
LIBXENON_INC := $(DEVKITXENON)/usr/include
LIBXENON_LIB := $(DEVKITXENON)/usr/lib
LDSCRIPT     := $(DEVKITXENON)/app.lds

# --- Tools ---
CC       := xenon-gcc
LD       := xenon-gcc
OBJCOPY  := xenon-objcopy
STRIP    := xenon-strip

# --- Flags ---
MACHDEP = -DXENON -m32 -maltivec -fno-pic -mpowerpc64 -mhard-float

CFLAGS  := -g -O2 -Wall $(MACHDEP) -I$(LIBXENON_INC)
LDFLAGS := -g $(MACHDEP) -T $(LDSCRIPT) -L$(LIBXENON_LIB)

LIBS := -lxenon

# --- Build rules ---

%.o: %.c
    @echo [CC] $(notdir $<)
	@$(CC) $(CFLAGS) -c $< -o $@

%.elf: %.o
	@echo [LD] $(notdir $@)
	@$(LD) $^ $(LDFLAGS) $(LIBS) -o $@

%.elf32: %.elf
	@echo [OBJCOPY] $(notdir $@)
	@$(OBJCOPY) -O elf32-powerpc --adjust-vma 0x80000000 $< $@
	@$(STRIP) $@

main: test.elf32
