#!/bin/bash
nasm town.asm -f elf32 -o town.o
g++ -m32 interface.cpp town.o -o game
