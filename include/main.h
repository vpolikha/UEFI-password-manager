#ifndef MAIN
#define MAIN

#include <efi.h>
#include <efilib.h>

#define DEBUG_PORT 0x462

void debugcon_putchar(char c);
void debugcon_write(char const *s);

#endif
