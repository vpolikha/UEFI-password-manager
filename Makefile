CC = gcc
LD = ld
OBJCOPY = objcopy

SRC_DIR = src
BLD_DIR = build
INC_DIR = include

TARGET = $(BLD_DIR)/passmanager.efi
CFLAGS = -Wall -Wextra -O0 \
         -I/usr/include/efi \
         -I/usr/include/efi/x86_64 \
         -fpic -ffreestanding \
         -fno-stack-protector -fno-stack-check \
         -fshort-wchar -mno-red-zone \
         -maccumulate-outgoing-args

LDFLAGS = -nostdlib -znocombreloc \
          -T /usr/lib/elf_x86_64_efi.lds \
          -shared -Bsymbolic

EFI_CRT = /usr/lib/crt0-efi-x86_64.o
EFI_LIBS = -L/usr/lib -lefi -lgnuefi

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(patsubst $(SRC_DIR)/%.c,$(BLD_DIR)/%.o,$(SRC))

all: $(TARGET)

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) $(EFI_CRT) $(OBJ) $(EFI_LIBS) -o $(BLD_DIR)/passmanager.so
	$(OBJCOPY) -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc --target=efi-app-x86_64 $(BLD_DIR)/passmanager.so $@

$(BLD_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(BLD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BLD_DIR) $(TARGET)

run: $(TARGET)
	cp $(TARGET) ./test/esp/EFI/BOOT/BOOTX64.EFI
	qemu-system-x86_64 \
    	-machine q35 \
    	-m 256M \
    	-drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
    	-drive if=pflash,format=raw,file=test/OVMF_VARS.fd \
    	-drive format=raw,file=fat:rw:test/esp \
    	-net none
.PHONY: all run clean

