#!/usr/bin/fish
for i in ./*.x
    echo $i
    perf stat -r 10 $i
end
