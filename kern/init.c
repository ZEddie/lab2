/* See COPYRIGHT for copyright information. */

#include <inc/types.h>
#include <inc/mmu.h>
#include <inc/memlayout.h>

void
i386_init(void)
{
	uint8_t check = 0;
	check++;
	write_serial('H');
	write_serial('e');
	write_serial('l');
	write_serial('l');
	write_serial('o');
	write_serial('!');
}

