#include "../include/main.h"

void debugcon_putchar(char c){
    __asm__ volatile (
        "outb %0, %1"
        :
        : "a"(c), "Nd"(DEBUG_PORT)
    );
}

void debugcon_write(char const *s){
    while ('\0' != *s){
        debugcon_putchar(*s);
        s++;
    }
}
