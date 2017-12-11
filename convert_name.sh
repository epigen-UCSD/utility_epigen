#!/bin/bash

while read l;
do
    l1=($l);
    fs=(`ls ${l1[0]}*`); 
    for f in ${fs[@]}
    do
        echo "mv $f ${f/${l1[0]}/${l1[2]}}"
        eval "mv $f ${f/${l1[0]}/${l1[2]}}"
    done
done < zhang2.txt
