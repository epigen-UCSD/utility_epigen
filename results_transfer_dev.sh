#!/bin/bash
#Time-stamp: <2018-04-26 10:49:07> 
############################################################
# args 
############################################################
usage(){
    cat <<EOF    

Transfer results from scratch to condo data folder 
Usage: results_transfer.sh [-s <sample_id>] [-t <atac|chip|hic>] 

EOF
}


[[ $# -eq 0 ]] && { usage;exit }  

while getopts ":s:t" opt;
do
    case $opt in
        s) sample=$s;;
        t) type=$t;;
        \?) usage
            echo "input error"
            exit 1;;
    esac
done



# set default

[[ -z $sample ]] && { echo "no input sample "; exit 1 } 
[[ -z $type ]] && type="atac"


############################################################
# main 
############################################################

# transfer the analysis results from scratch folder to the storage folder 
# input: JYH_XX the prefix 

from=/home/zhc268/scratch/outputs/${sample}_chip 
to=/projects/ps-epigen/outputs/

if [ -d "$from" ]; then
    cd $from;
fi

# trimed fastq
find . -name "${sample}*trim.fastq.gz" -exec rsync -uv --progress {} /projects/ps-epigen/seqdata/ \; 

# bam files 
find . -name "${sample}*bam*"  | xargs -I '{}' rsync -uv --progress '{}' ${to}"bams"

# bed files 
find . -name "${sample}*bed*"  | xargs -I '{}' rsync -uv --progress '{}' ${to}"beds"

# tagAligns 
find . -name "${sample}*tagAlign*"  | xargs -I '{}' rsync -uv --progress '{}' ${to}"tagAligns"


# peaks 
peak_dir=${to}"peaks/"$sample
mkdir -p $peak_dir
find . -name "${sample}*[p|P]eak*" -type f  | xargs -I '{}' rsync -uv --progress '{}' $peak_dir



# libQCs 
qc_dir=${to}"libQCs/"$sample
mkdir -p $qc_dir
find ./qc -name "${sample}*" | xargs -I '{}' rsync -uv --progress '{}' $qc_dir


# signals 
signal_dir=${to}"signals"
mkdir -p $signal_dir 
find . -name "${sample}*bigwig*"  | xargs -I '{}' rsync -uv --progress '{}' $signal_dir
find . -name "${sample}_tracks.json"  | xargs -I '{}' rsync -uv --progress '{}' $signal_dir


# reports 
reports_dir=${to}"/reports/"$sample
mkdir -p $reports_dir
rsync -uv  ENCODE_summary.json $reports_dir
rsync -uvr *.html $reports_dir
rsync -uvr report $reports_dir


# usage
# ids=( 1 2 `seq 35 37` ) 
# for i in  ${ids[@]}; do s=JYH_$i; echo "transfering  $s"; results_transfer.sh $s; done 
