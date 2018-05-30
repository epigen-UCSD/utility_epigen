#!/bin/bash
basefolder=/home/zhc268/scratch/hg38_mapb
mkdir -p $basefolder && cd $basefolder

# runGEM.sh: script to generate GEM-mappablilty track
export PATH=$PATH:/home/zhc268/data/software/GEM/bin/

kmer=75
thr=32; # threads


## 1. generate gem index
reference="/home/zhc268/data/GENOME/hg38/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta"
pref="GRCh38"
idxpref="GRCh38_index"
#gem-indexer -T ${thr} -c dna -i ${reference} -o ${idxpref}


## 2. make 75 mapb track


# compute mappability data
#gem-mappability -T ${thr} -I ${idxpref}.gem -l ${kmer} -o ${pref}_${kmer}

# convert results to wig and bigwig
#gem-2-wig -I ${idxpref}.gem -i ${pref}_${kmer}.mappability -o ${pref}_${kmer}
awk -v OFS='\t' '{print $1,$3}'  ${pref}_${kmer}.sizes > ${pref}.sizes
sed -i 's/  AC//g' ${pref}_${kmer}.wig  
wigToBigWig ${pref}_${kmer}.wig ${pref}.sizes ${pref}_${kmer}.bw
