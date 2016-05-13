# Toolchain
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
LOADER=teensy_loader_cli

# Target
TARGET=thumbv7em-none-eabi

# Files
OUT_DIR=target/$(TARGET)/release
OUT_FILE=$(OUT_DIR)/blink

.PHONY: build clean listing load

all: build listing
build: $(OUT_FILE).hex
listing: $(OUT_FILE).lst

$(OUT_FILE):
	cargo build --release --target=$(TARGET) --verbose

$(OUT_DIR)/%.hex: $(OUT_DIR)/%
	$(OBJCOPY) -O ihex $< $@

$(OUT_DIR)/%.lst: $(OUT_DIR)/%
	$(OBJDUMP) -D $< > $@

clean:
	cargo clean

load: $(OUT_FILE).hex
	$(LOADER) -s --mcu=mk20dx256 -v $<
