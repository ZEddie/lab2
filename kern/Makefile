TARGET   ?=i586-elf
LINKER   ?= kernel.ld
SRCFILES := $(shell find . -maxdepth 1 -type f -name "*.c" -o -name "*.S")
OBJECTS  :=$(SRCFILES:.c=.o)
OBJECTS  :=$(OBJECTS:.S=.o) 
OBJECTS  := $(OBJECTS)
AS       :=$(TARGET)-as
CC       :=$(TARGET)-gcc
LD       :=$(TARGET)-gcc
EM       :=qemu-system-i386
ASFLAGS  := 
CFLAGS   := -std=gnu99 -ffreestanding -O2 -Wall  -Wextra -nostdlib -lgcc -I../ -DDEBUG
LDFLAGS  :=-ffreestanding -O2 -nostdlib -lgcc


all: rmlog $(OBJECTS) link iso test

link:
	$(LD) -T $(LINKER) -o ../isofiles/boot/kernel.elf $(LDFLAGS) $(OBJECTS)
test:
	@$(EM) $(EMUFLAGS) -cdrom ../bootable.iso -serial file:kernel.log -m 64M
.S.o:
	@$(AS) -I../inc/. -o $*.o $<
.c.o:
	$(CC) $(CFLAGS) -c -o $*.o $<
clean:
	-@rm $(OBJECTS) ../isofiles/boot/kernel.elf
iso:
	genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table -o ../bootable.iso ../isofiles
rmlog:
	-rm kernel.log
	
	