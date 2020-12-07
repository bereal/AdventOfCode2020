#!/bin/sh

z80asm -o solve.z8b solve.asm
z80golf solve.z8b < input.txt
