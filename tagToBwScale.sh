#!/bin/bash

# check commands: slopBed, bedGraphToBigWig and bedClip

which bedtools &>/dev/null || { echo "bedtools not found! Download bedTools: <http://code.google.com/p/bedtools/>"; exit 1; }
which bedGraphToBigWig &>/dev/null || { echo "bedGraphToBigWig not found! Download: <http://hgdownload.cse.ucsc.edu/admin/exe/>"; exit 1; }
which bedClip &>/dev/null || { echo "bedClip not found! Download: <http://hgdownload.cse.ucsc.edu/admin/exe/>"; exit 1; }

# end of checking

if [ $# -lt 2 ];then
    echo "Need 2 parameters! <tagAlign> <chrom size file>"
    exit
fi


# bedgraph to bigwig 
tag=$1 # input
chrsz=$2 # chrsz

n_cuts=$(cat $tag|wc -l)
scale=$(python -c "print(1000000.0/$n_cuts)") #RPM 

#chrsz="/projects/ps-epigen/GENOME/${g}/${g}.chrom.sizes"
prefix=${tag%.tag*} # no >2 tag in the tagalign file name 
bdg=${prefix}.bdg
bed_srt=${prefix}.srt.bed
bdg_srt=${prefix}.srt.bedgraph
bigwig=${prefix}.bw


awk  -v OFS='\t' '{if($6=="+"){$3=$2+75;$2=$2-75} else {$2=$3-75;$3=$3+75};print $1,$2,$3}'  $tag |\
    slopBed -i - -g $chrsz -b 0 | grep -P "chr[0-9XY]+\t">$bed_srt
sort -k 1,1 $bed_srt | bedtools genomecov -i -  -bg -g $chrsz -scale $scale > $bdg
sort -k1,1 -k2,2n $bdg > $bdg_srt
bedGraphToBigWig $bdg_srt $chrsz $bigwig
rm -f $bdg $bdg_srt $bed_srt

