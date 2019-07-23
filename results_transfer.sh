#!/bin/bash

# transfer the analysis results from scratch folder to the storage folder 
# input: JYH_XX the prefix

[[ $# -eq 0 ]] && { echo "ERROR:Need input"; exit 1; }
sample=$1

from=/oasis/tscc/scratch/$(whoami)/outputs/${sample}
to="/projects/ps-epigen/outputs/"

[[ -d "$from" ]] &&  cd $from

# trimed fastq
#find . -name "${sample}*trim.fastq.gz" -exec rsync -uv --progress {} /projects/ps-epigen/seqdata/ \; 

# bam files 
find . -name "${sample}*bam*"  | xargs -I '{}' rsync -uv --progress '{}' ${to}"bams"

# bed files 
find . -name "${sample}*bed*"  | xargs -I '{}' rsync -uv --progress '{}' ${to}"beds"

# tagAligns 
find . -name "${sample}*tagAlign.gz"  | xargs -I '{}' rsync -uv --progress '{}' ${to}"tagAligns"


# peaks 
peak_dir=${to}"peaks/"$sample
mkdir -p $peak_dir
find . -name "${sample}*[p|P]eak*.gz*" -type f  | xargs -I '{}' rsync -uv --progress '{}' $peak_dir



# libQCs 
qc_dir=${to}"libQCs/"$sample
mkdir -p $qc_dir
find ./qc -name "${sample}*" | xargs -I '{}' rsync -uv --progress '{}' $qc_dir
find . -name "*.qc"| xargs -I '{}' rsync -uv --progress '{}' $qc_dir

# signals 
signal_dir=${to}"signals"
mkdir -p $signal_dir 
find . -name "${sample}*bigwig*"  | xargs -I '{}' rsync -uv --progress '{}' $signal_dir
find . -name "${sample}*bw*"  | xargs -I '{}' rsync -uv --progress '{}' $signal_dir
find . -name "${sample}*_tracks.json"  | xargs -I '{}' rsync -uv --progress '{}' $signal_dir


# reports 
reports_dir=${to}"/reports/"$sample
mkdir -p $reports_dir
rsync -uv  ENCODE_summary.json $reports_dir
rsync -uvr *.html $reports_dir
rsync -uvr report $reports_dir


# usage
# ids=( 1 2 `seq 35 37` ) 
# for i in  ${ids[@]}; do s=JYH_$i; echo "transfering  $s"; results_transfer.sh $s; done
