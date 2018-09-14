#!/usr/bin/fish
for i in PETER ICC MSVC CLANG GCC
    nasm -felf64 -D$i bench.asm -o $i.out
    ld $i.out -o $i.x
end
