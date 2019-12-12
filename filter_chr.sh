#!/bin/bash

input_tg=$1

# hg38 
chrs=($(for i in $(seq 1 23) X Y; do echo chr"$i";done))

zcat $input_tg | awk -v var="${chrs[*]}" 'BEGIN{
    OFS="\t";split(var,list); for (i in list) chrs[list[i]]=""}{
        if($1 in chrs) print $0}' > ${input_tg/.gz/}

gzip -f ${input_tg/.gz/}
