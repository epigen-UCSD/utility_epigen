#!/bin/bash 

usage() { echo "Usage: $0 [-s <set number>][libs]" 1>&2 ; exit 1; }

while getopts "s:" o; do
    case $o in 
	s) s="${OPTARG}";; #set
	*) usage;; 
    esac
done
shift $((OPTIND-1))                                                                                                                                                                                                                                 
lib=($@); echo ${lib[@]};
mkdir -p ./Set_$s; cd ./Set_$s

fastqs='./fastqs'; mkdir -p $fastqs
bams='./bams'; mkdir -p $bams
peaks='./peaks'; mkdir -p $peaks
bws='./bigwigs';mkdir -p $bws

data_dir='/project/ps-epigen'

for l in ${lib[@]}
do 
    l_n="JYH_$l"
    echo  $l_n
    
    echo "linking fastq files"
    find $data_dir"/seqdata" -name $l_n"*.bz2"  -type f -exec ln -s {} $fastqs"/"  \;
    find $data_dir"/outputs/bams" -name $l_n"*nodup*"  -type f -exec ln -s {} $bams"/"  \;
    find $data_dir"/outputs/peaks/"$l_n -name $l_n"*filt*"  -type f -exec ln -s {} $peaks"/"  \;
    find $data_dir"/outputs/signals/" -name $l_n"*fc*.bigwig"  -type f -exec ln -s {} $bws"/"  \;
    find $data_dir"/outputs/signals/" -name $l_n"*pval*.bigwig"  -type f -exec ln -s {} $bws"/"  \;
done

find . -name "*.meta" -exec rm {} \;
