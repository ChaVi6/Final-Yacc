#!/bin/bash

/usr/bin/flex -w *.l
/usr/bin/bison -d *.y
gcc -c -o scaner.obj lex.yy.c
gcc -c -o parser.obj ind.tab.c
gcc -c -o zz.obj zz.c
gcc -o a.out scaner.obj parser.obj zz.obj

