#!/bin/bash

# check commands:


# end of checking

if [ $# -lt 1 ];then
    echo "Need 1 parameters! <tagAlign> "
    exit
fi


# bedgraph to bigwig 
tag=$1 # input
zcat $tag | awk 'NR%2{printf "%s ",$0;next;}1'|awk '{print $1,$2,$3,$8,$9}' | awk -v OFS='\t' '{min=$2;max=$2;for(i=2;i<=5;i++) {if ($i>max) max=$i;if($i<min) min=$i;} print $1,min,max}' 

