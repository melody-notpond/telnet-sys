TARGET = riscv64-unknown-elf
CC     = clang
GDB    = riscv64-elf-gdb
# GDB  = $(TARGET)-gdb
EMU    = qemu-system-riscv64

CODE = src/

EDEVICES = 
EFLAGS = -machine virt -cpu rv64 -bios opensbi-riscv64-generic-fw_dynamic.bin -m 256m -global virtio-mmio.force-legacy=false $(EDEVICES) -smp 1 -s -nographic
ifdef WAIT_GDB
	EFLAGS += -S
endif

CFLAGS = -march=rv64gc -mabi=lp64d -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -g -Wall -Wextra -Iinclude

ifeq ($(CC),clang)
	CFLAGS += -target $(TARGET) -mno-relax -Wno-unused-command-line-argument -Wthread-safety
endif

.PHONY: all clean run gdb kernel

all: $(CODE)*.s $(CODE)*.c
	mkdir -p build/
	$(CC) $(CFLAGS) -Tkernel.ld $? -o build/kernel

clean:
	-rm -r build/

run:
	$(EMU) $(EFLAGS) -kernel build/kernel

gdb:
	$(GDB) -q -x kernel.gdb
