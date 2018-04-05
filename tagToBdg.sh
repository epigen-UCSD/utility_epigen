#!/bin/bash

# check commands: slopBed, bedGraphToBigWig and bedClip

which bedtools &>/dev/null || { echo "bedtools not found! Download bedTools: <http://code.google.com/p/bedtools/>"; exit 1; }

# end of checking

if [ $# -lt 2 ];then
    echo "Need  parameters! <tagalign> <chrom size file>"
    exit
fi


# bedgraph to bigwig 
tag=$1 # input
chrsz=$2 # chrsz

prefix=${bdg%.tagAlign}
bdg=${prefix}.bdg

bedtools genomecov -i $tag -bg -g $chrsz > $bdg





