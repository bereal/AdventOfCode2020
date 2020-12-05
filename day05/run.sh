#!/bin/sh

z80asm solve.z80 -o solve.z8b
z80golf solve.z8b
