#!/bin/bash

# check commands: 
which bedtools &>/dev/null || { echo "bedtools not found! Download bedTools: <http://code.google.com/p/bedtools/>"; exit 1; }

# end of checking
if [ $# -lt 2 ];then
    echo "Need  parameters! <bed> <genome(hg19|hg38|mm10)>"
    exit
fi


# bedgraph to bigwig
bed=$1 # input
genome=$2 # chrsz

fa=$(find /home/zhc268/data/GENOME/${genome} -name "*.fa" -o -name "*.fasta" -maxdepth 1 2> /dev/null)    
[[ -z $genome ]] &&  echo " genome input is wrong!   <hg38|mm10|hg19>" && exit 1

bedtools getfasta -fi $fa -bed $bed
