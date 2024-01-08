@echo off
echo **********************************************
echo * Retro Programmers United for Obscure Systems *
echo * ALICE 32/90                                  *                      
echo * ASM 6803                                     *
echo **********************************************

..\..\vbcc\bin\vasm6800_oldstyle.exe  src\main.asm -m6801 -Fbin -dotdir -o bin\prg.bin

pause