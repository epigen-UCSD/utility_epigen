#!/bin/bash

############################################################
# args: $flowcell_id,  $ftp_addr $user $password 
############################################################

#ftp_addr=ftp://igm-storage1.ucsd.edu/190215_K00180_0755_BH2WKMBBXY_SR75_Combo/
ftp_addr=$1
user=$2
pass=$3
flowcell_id=$4
############################################################
# transfer data 
############################################################
cmd="wget -q -r --user $user --password $pass  $ftp_addr  ~/data/seqdata"
echo $cmd 
echo $cmd | bash

############################################################
# get reads cnt 
############################################################
fastq_dir="/projects/ps-epigen/seqdata/${ftp_addr##*//}"
reads_cnt_file="${fastq_dir}/reads_cnt.tsv"
>$reads_cnt_file

cd $fastq_dir

for i in *_R1_*.fastq.gz
do
    if [ ${i:0:12} != "Undetermined" ]
    then
        lib=${i%_S[0-9]*}
        echo $lib
        nreads=$(zcat $i | wc -l ) && echo -e "$lib\t$[nreads/4]" >> $reads_cnt_file & sleep 1
    fi
done
wait

############################################################
# update status to finish or warning @ VM
############################################################
cmd="source activate django; python \$(which updateReadsNumberPerRun.py) -f $flowcell_id -i $reads_cnt_file; python \$(which updateRunReads.py) -f $flowcell_id"
ssh zhc268@epigenomics.sdsc.edu $cmd

