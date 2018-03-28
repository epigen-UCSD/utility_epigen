#!/bin/bash

# check commands: slopBed, bedGraphToBigWig and bedClip

which slopBed &>/dev/null || { echo "bedtools not found! Download bedTools: <http://code.google.com/p/bedtools/>"; exit 1; }
which bedGraphToBigWig &>/dev/null || { echo "bedGraphToBigWig not found! Download: <http://hgdownload.cse.ucsc.edu/admin/exe/>"; exit 1; }
which bedClip &>/dev/null || { echo "bedClip not found! Download: <http://hgdownload.cse.ucsc.edu/admin/exe/>"; exit 1; }

# end of checking

if [ $# -lt 2 ];then
    echo "Need 2 parameters! <bedgraph> <chrom size file>"
    exit
fi


# bedgraph to bigwig 
bdg=$1 # input
chrsz=$2 # chrsz

#chrsz="/projects/ps-epigen/GENOME/${g}/${g}.chrom.sizes"
prefix=${bdg%.bdg}
bedgraph=${prefix}.bedgraph
bedgraph_srt=${prefix}.srt.bedgraph

bigwig=${prefix}.bigwig

slopBed -i $bdg -g $chrsz -b 0 | bedClip stdin $chrsz $bedgraph
sort -k1,1 -k2,2n $bedgraph > $bedgraph_srt
bedGraphToBigWig $bedgraph_srt $chrsz $bigwig
rm -f $bedgraph $bedgraph_srt

