# EDK II configuration
EDK2_DIR  ?= $(HOME)/development/edk2
WORKSPACE := $(CURDIR)
CONF_PATH := $(WORKSPACE)/Conf

# Search roots for packages:
# parent directory contains UEFI-password-manager/
# EDK2_DIR contains MdePkg/, MdeModulePkg/, etc.
PACKAGES_PATH := $(abspath ..):$(EDK2_DIR)

# Build configuration
ARCH      ?= X64
TARGET    ?= DEBUG
TOOLCHAIN ?= GCC
PLATFORM  ?= UEFIPasswordManager.dsc

# Prepare EDK II environment in a child Bash process
EDK_ENV = WORKSPACE="$(WORKSPACE)" \
          CONF_PATH="$(CONF_PATH)" \
          EDK_TOOLS_PATH="$(EDK2_DIR)/BaseTools" \
          PACKAGES_PATH="$(PACKAGES_PATH)"

# QEMU / OVMF
QEMU       ?= qemu-system-x86_64
OVMF_CODE  ?= /usr/share/OVMF/OVMF_CODE_4M.fd
OVMF_VARS_TEMPLATE ?= /usr/share/OVMF/OVMF_VARS_4M.fd

ESP_DIR    := $(WORKSPACE)/test/esp
OVMF_VARS  := $(WORKSPACE)/test/OVMF_VARS_4M.fd

EFI_APP    := $(WORKSPACE)/Build/$(TARGET)_$(TOOLCHAIN)/$(ARCH)/PassManager.efi
EFI_BOOT   := $(ESP_DIR)/EFI/BOOT/BOOTX64.EFI

all: build

# Initialize EDK II configuration
config:
	mkdir -p "$(CONF_PATH)"
	$(EDK_ENV) bash -c 'source "$(EDK2_DIR)/edksetup.sh"'

# Build our UEFI application
build: config
	$(EDK_ENV) bash -c 'source "$(EDK2_DIR)/edksetup.sh" && \
		build -p "$(PLATFORM)" \
		      -a "$(ARCH)" \
		      -t "$(TOOLCHAIN)" \
		      -b "$(TARGET)"'

# Remove EDK II build output
clean:
	rm -rf "$(WORKSPACE)/Build"

run: build
	@mkdir -p "$(ESP_DIR)/EFI/BOOT"
	@cp "$(EFI_APP)" "$(EFI_BOOT)"
	@test -f "$(OVMF_VARS)" || cp "$(OVMF_VARS_TEMPLATE)" "$(OVMF_VARS)"
	$(QEMU) \
		-machine q35 \
		-m 256M \
		-drive if=pflash,format=raw,readonly=on,file="$(OVMF_CODE)" \
		-drive if=pflash,format=raw,file="$(OVMF_VARS)" \
		-drive format=raw,file=fat:rw:$(ESP_DIR) \
		-net none
	

.PHONY: all config build clean
