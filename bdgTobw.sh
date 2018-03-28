#!/bin/bash

# bedgraph to bigwig 
bdg=$1 # input
g=$2 # genome
prefix=${bdg%.bdg}
bedgraph=${prefix}.bedgraph
bedgraph_srt=${prefix}.srt.bedgraph
chrsz="/projects/ps-epigen/GENOME/${g}/${g}.chrom.sizes"
bigwig=${prefix}.bigwig

slopBed -i $bdg -g $chrsz -b 0 | bedClip stdin $chrsz $bedgraph
sort -k1,1 -k2,2n $bedgraph > $bedgraph_srt
bedGraphToBigWig $bedgraph_srt $chrsz $bigwig
rm -f $bedgraph $bedgraph_srt

