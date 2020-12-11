#!/bin/sh

nasm -felf32 solve.asm
ld -m elf_i386 solve.o -o solve

./solve < input.txt
