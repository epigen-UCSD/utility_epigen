#!/bin/bash 
# run fastq QC for _2 libs/seq runs 
module load fastqc

FASTQ_DIR="/projects/ps-epigen/seqdata/"
sample_prefix="JYH_"$1"_2"

OUTPUT_DIR="/projects/ps-epigen/outputs/libQCs/"${sample_prefix}
mkdir -p $OUTPUT_DIR

fastq1=${FASTQ_DIR}${sample_prefix}"_R1.trim.fastq.gz"
fastq2=${FASTQ_DIR}${sample_prefix}"_R2.trim.fastq.gz"

fastqc  -outdir $OUTPUT_DIR  $fastq1
fastqc  -outdir $OUTPUT_DIR  $fastq2



