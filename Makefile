TARGET_ELF:=target/avr-unknown-gnu-atmega328/release/rustc-ldd-x.elf
TARGET_HEX:=target/avr-unknown-gnu-atmega328/release/rustc-ldd-x.hex

.PHONY: all
all: ${TARGET_ELF} ${TARGET_HEX}

avr-unknown-gnu-atmega328.json:
	rustc -Z unstable-options --print target-spec-json --target avr-unknown-gnu-atmega328 >avr-unknown-gnu-atmega328.json
	sed -i 's/"is-builtin": true/"is-builtin": false/g' avr-unknown-gnu-atmega328.json

${TARGET_ELF}: avr-unknown-gnu-atmega328.json Cargo.toml src/main.rs
	cargo build --release

${TARGET_HEX}: ${TARGET_ELF}
	avr-objcopy -O ihex -j '.text' -j '.data' ${TARGET_ELF} ${TARGET_HEX}

.PHONY: lss
lss: ${TARGET_ELF}
	avr-objdump -sd -j '.data' -j '.text' ${TARGET_ELF}

.PHONY: clean
clean:
	-rm avr-unknown-gnu-atmega328.json
	-rm ${TARGET_HEX}
	cargo clean
