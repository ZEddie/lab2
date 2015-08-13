/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>


###################################################################
# The kernel (this code) is linked at address ~(0xF0000000 + 1 Meg), 
# but the bootloader loads it at address ~1 Meg.
#	
# ((x) - 0xF0000000) maps a symbol x from its link address to its actual
# location in physical memory (its load address).	 
###################################################################


###################################################################
# entry point
###################################################################

.text

# The Multiboot header
.align 4
.long 0x1BADB002
.long 0
.long -(0x1BADB002 + 0)

# '_start' specifies the ELF entry point.  Since we haven't set up
# virtual memory when the bootloader enters this code, we need the
# bootloader to jump to the *physical* address of the entry point.
.globl		_start
_start = entry - 0xF0000000

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot

	# We haven't set up virtual memory yet, so we're running from
	# the physical address the boot loader loaded the kernel at: 1MB
	# (plus a few bytes).  However, the C code is linked to run at
	# 0xF0000000+1MB.  Hence, we set up a trivial page directory that
	# translates virtual addresses [0xF0000000, 0xF0000000+4MB) to
	# physical addresses [0, 4MB).  This 4MB region will be
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(entry_pgdir - 0xF0000000), %eax
	movl	%eax, %cr3
	# Turn on paging.
	movl	%cr0, %eax
	orl	$(0x00000001|0x80000000|0x00010000), %eax
	movl	%eax, %cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above 0xF0000000 before entering
	# C code.
	mov	$relocated, %eax
	jmp	*%eax
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer

	# Set the stack pointer
	movl	$(bootstacktop),%esp

	# now to C code
	call	i386_init

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin


.data
###################################################################
# boot stack
###################################################################

.align 4096
.section .bootstrap_stack, "aw", @nobits
.global bootstack
bootstack:
.skip 32768
.global		bootstacktop   
bootstacktop:
