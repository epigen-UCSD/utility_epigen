#!/bin/bash

# check commands: slopBed, bedGraphToBigWig and bedClip

which bedtools &>/dev/null || { echo "bedtools not found! Download bedTools: <http://code.google.com/p/bedtools/>"; exit 1; }
which bedGraphToBigWig &>/dev/null || { echo "bedGraphToBigWig not found! Download: <http://hgdownload.cse.ucsc.edu/admin/exe/>"; exit 1; }
which bedClip &>/dev/null || { echo "bedClip not found! Download: <http://hgdownload.cse.ucsc.edu/admin/exe/>"; exit 1; }

# end of checking

if [ $# -lt 2 ];then
    echo "Need 2 parameters! <bedgraph> <chrom size file>"
    exit
fi


# bedgraph to bigwig 
tag=$1 # input
chrsz=$2 # chrsz


prefix=${bdg%.bdg}
bdg=${prefix}.bdg

bedtools genomecov -i $tag -bg -g $chrsz > $bdg





