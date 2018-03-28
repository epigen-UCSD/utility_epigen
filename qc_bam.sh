#!/bin/bash



# input: a PE bam
# output: venn counts for filter1: q30 ; filter2: 1804; filter3: -f2

#bam="SRC_1625_cortex.RNase.trt.raw.bam"
bam=$1
out=${bam%.raw.bam}

[[ ! -f $out".score.txt" ]] && samtools view $bam | awk '{print $2,$5}' > $out".score.txt" #flag + qscore

Rscript $(which plotQC.R) $out".score.txt" #flag + qscore








