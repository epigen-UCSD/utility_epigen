#!/bin/bash 
# use named pipe to run fastqc 

# activate conda environ
#source activate bds_atac_py3 
module load fastqc

FASTQ_DIR="/projects/ps-epigen/seqdata/"
sample_prefix="JYH_"$1

TMP_DIR="$HOME/.tmp/"
mkdir -p $TMP_DIR

OUTPUT_DIR="/projects/ps-epigen/outputs/libQCs/"${sample_prefix}
mkdir -p $OUTPUT_DIR


fastq_pair=( "${sample_prefix}_R1.fastq" "${sample_prefix}_R2.fastq" )

for p in ${fastq_pair[@]}
do

    bz2file="${p}.bz2"
    echo "running decompress $bz2file ..."
    bzip2 -d -c $FASTQ_DIR$bz2file > $TMP_DIR$p
    echo "running fastqc $p ..."
    fastqc  -o $OUTPUT_DIR "${TMP_DIR}$p" &&   rm "${TMP_DIR}$p"
done 




#bzip2 -d -c  JYH_1_R1.fastq.bz2 | fastqc /dev/stdin -o ~/
