# Requer PS3DEV e PSL1GHT configurados (ps3toolchain). Uso: make pkg
.SUFFIXES:
ifeq ($(strip $(PSL1GHT)),)
$(error "Defina PSL1GHT: export PSL1GHT=/usr/local/ps3dev  (e PS3DEV)")
endif
include $(PSL1GHT)/ppu_rules

TARGET   := amongus_ps3
BUILD    := build
SOURCES  := source
TITLE    := Among Us Style PS3
APPID    := AMGS00001
CONTENTID:= UP0001-$(APPID)_00-AMONGUSSTYLE0001
SFOXML   := sfo.xml
ICON0    := ICON0.PNG

CFILES   := source/game.c source/main_ps3.c
OFILES   := $(patsubst source/%.c,$(BUILD)/%.o,$(CFILES))
CFLAGS   := -O2 -Wall -std=gnu99 $(MACHDEP) -I$(PORTLIBS)/include -I$(PSL1GHT)/ppu/include -Isource
LDFLAGS  := $(MACHDEP) -L$(PSL1GHT)/ppu/lib
LIBS     := -lrsx -lgcm_sys -lio -lsysutil -lrt -llv2 -lm

all: $(BUILD)/$(TARGET).self
$(BUILD):
	@mkdir -p $(BUILD)
$(BUILD)/%.o: source/%.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@
$(BUILD)/$(TARGET).elf: $(OFILES)
	$(CC) $(OFILES) $(LDFLAGS) $(LIBS) -o $@
$(BUILD)/$(TARGET).self: $(BUILD)/$(TARGET).elf
	$(SELF) $< $@ 2>/dev/null || ( $(STRIP) $< -o $(BUILD)/stripped.elf && $(SELF) $(BUILD)/stripped.elf $@ )
	$(SELF_NPDRM) $< $(BUILD)/EBOOT.BIN $(CONTENTID) >/dev/null 2>&1 || true

pkg: all
	@mkdir -p $(BUILD)/pkg/USRDIR
	@cp $(ICON0) $(BUILD)/pkg/ICON0.PNG
	@$(SELF_NPDRM) $(BUILD)/$(TARGET).elf $(BUILD)/pkg/USRDIR/EBOOT.BIN $(CONTENTID)
	@$(SFO) --title "$(TITLE)" --appid "$(APPID)" -f $(SFOXML) $(BUILD)/pkg/PARAM.SFO
	@$(PKG) --contentid $(CONTENTID) $(BUILD)/pkg/ $(TARGET).pkg
	@echo ">> gerado: $(TARGET).pkg"
clean:
	rm -rf $(BUILD) $(TARGET).pkg
.PHONY: all pkg clean
