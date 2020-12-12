#!/bin/sh

nasm -felf32 solve.asm
ld -m elf_i386 solve.o -o solve-1

PART2=1 nasm -felf32 solve.asm
ld -m elf_i386 solve.o -o solve-2

./solve-1 < input.txt
./solve-2 < input.txt


